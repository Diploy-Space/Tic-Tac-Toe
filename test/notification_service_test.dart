import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/screens/notifications_screen.dart';
import 'package:tic_tac_game/services/notification_service.dart';
import 'package:tic_tac_game/widgets/common.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
  });

  Map<String, dynamic> row(String id, String type, Map<String, dynamic> data) =>
      {
        'id': id,
        'type': type,
        'title': 'EN title',
        'body': 'EN body',
        'data': data,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'read_at': null,
      };

  test('texts are localized from type + data', () {
    final en = lookupL10n(const Locale('en'));
    final es = lookupL10n(const Locale('es'));
    final req = AppNotification.fromRow(
        row('1', 'challenge_request', {'name': 'rahul'}));
    expect(req.localizedTitle(en), 'New challenge');
    expect(req.localizedBody(en), 'rahul challenged you to a match');
    expect(req.localizedBody(es), 'rahul te desafió a una partida');
    expect(req.route, '/challenges');

    final busy =
        AppNotification.fromRow(row('2', 'challenge_busy', {'name': 'ana'}));
    expect(busy.localizedBody(en), 'ana is in a match right now. Try again later.');

    final coins = AppNotification.fromRow(
        row('3', 'coins_reward', {'amount': 10, 'balance': 510}));
    expect(coins.localizedBody(en), 'You earned 10 coins. Balance: 510');
    expect(coins.route, '/wallet');

    final debit = AppNotification.fromRow(
        row('4', 'coins_debit', {'amount': 5, 'balance': 505}));
    expect(debit.localizedTitle(en), 'Coins deducted');

    final lost = AppNotification.fromRow(
        row('5', 'match_result', {'name': 'x', 'result': 'loss'}));
    expect(lost.localizedTitle(en), 'You lost');
    expect(lost.route, '/match-history');

    final unknown = AppNotification.fromRow(row('6', 'something_new', {}));
    expect(unknown.localizedTitle(en), 'EN title');
    expect(unknown.localizedBody(en), 'EN body');
  });

  test('realtime insert: history, unread count and banner rules', () async {
    notificationsOn.value = true;
    NotificationService.isInMatch = () => false;
    await NotificationService.clear();

    NotificationService.debugInsert(
        row('a', 'friend_request', {'name': 'zoe'}));
    expect(NotificationService.items.value.length, 1);
    expect(NotificationService.unread.value, 1);
    expect(NotificationService.banner.value?.id, 'a');

    // Duplicate delivery is ignored.
    NotificationService.debugInsert(
        row('a', 'friend_request', {'name': 'zoe'}));
    expect(NotificationService.items.value.length, 1);

    // Challenge popup already covers this one: history only.
    NotificationService.hideBanner();
    NotificationService.debugInsert(
        row('b', 'challenge_request', {'name': 'zoe'}));
    expect(NotificationService.unread.value, 2);
    expect(NotificationService.banner.value, isNull);

    // In a match: coin updates are not shown as a banner.
    NotificationService.isInMatch = () => true;
    NotificationService.debugInsert(
        row('c', 'coins_debit', {'amount': 5, 'balance': 1}));
    expect(NotificationService.banner.value, isNull);
    expect(NotificationService.items.value.first.id, 'c');

    // Notifications switched off: still recorded, no banner.
    NotificationService.isInMatch = () => false;
    notificationsOn.value = false;
    NotificationService.debugInsert(
        row('d', 'room_joined', {'name': 'kai'}));
    expect(NotificationService.unread.value, 4);
    expect(NotificationService.banner.value, isNull);
    notificationsOn.value = true;

    await NotificationService.markRead(['a']);
    expect(NotificationService.unread.value, 3);
    await NotificationService.markAllRead();
    expect(NotificationService.unread.value, 0);
    await NotificationService.clear();
  });

  testWidgets('history screen asks guests to sign in', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: NotificationsScreen(),
    ));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('NOTIFICATIONS'), findsOneWidget);
    expect(find.text('Sign in to see your notifications'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('notification tile shows localized text and unread dot',
      (tester) async {
    final n = AppNotification.fromRow(
        row('t', 'coins_purchase', {'amount': 100, 'balance': 600}));
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Scaffold(body: NotificationTile(n)),
    ));
    expect(find.text('Purchase complete'), findsOneWidget);
    expect(find.text('100 coins added. Balance: 600'), findsOneWidget);
    expect(find.text('Just now'), findsOneWidget);
    // App's currency mark, not the Material "\$" coin icon.
    expect(find.byType(CurrencyMark), findsOneWidget);
    expect(find.byIcon(Icons.monetization_on_outlined), findsNothing);
  });

  testWidgets('details page shows the full text and opens the related screen',
      (tester) async {
    final n = AppNotification.fromRow(
        row('d1', 'coins_reward', {'amount': 10, 'balance': 510}));
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: nav,
      home: const Scaffold(body: Text('HOME')),
      routes: {
        '/notification': (_) => const NotificationDetailScreen(),
        '/wallet': (_) => const Scaffold(body: Text('WALLET')),
      },
    ));
    nav.currentState!.pushNamed('/notification', arguments: n);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Reward received'), findsOneWidget);
    expect(find.text('You earned 10 coins. Balance: 510'), findsOneWidget);
    await tester.tap(find.text('Wallet'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('WALLET'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
