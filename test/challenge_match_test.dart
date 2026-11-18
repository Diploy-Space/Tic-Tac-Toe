import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/models/multiplayer_match.dart';
import 'package:tic_tac_game/screens/challenge_incoming_screen.dart';
import 'package:tic_tac_game/screens/match_lobby_screen.dart';
import 'package:tic_tac_game/services/challenge_flow_service.dart';

/// Accepted challenge → match lobby → the shared online room.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    soundOn.value = false;
    musicOn.value = false;
    vibrationOn.value = false;
  });

  ChallengeItem item({required bool outgoing, String? roomId}) =>
      ChallengeItem(
        id: 'x1',
        opponentId: 'opp-1',
        opponentName: 'diployteam',
        rank: 1,
        score: 76,
        stake: ChallengeStakeKind.free,
        outgoing: outgoing,
        roomId: roomId,
      );

  test('lobby args: challenger is O, accepter is X, free stake is 0', () {
    final sent = item(outgoing: true, roomId: 'r1').lobbyArgs();
    expect(sent['roomId'], 'r1');
    expect(sent['myMark'], 'O');
    expect(sent['stake'], 0);
    final got = item(outgoing: false, roomId: 'r1').lobbyArgs();
    expect(got['myMark'], 'X');
    expect(item(outgoing: false).lobbyArgs().containsKey('roomId'), isFalse);
  });

  testWidgets('lobby with a room id opens the online room', (tester) async {
    Object? opened;
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: nav,
      home: const Scaffold(),
      onGenerateRoute: (s) => MaterialPageRoute(
        settings: s,
        builder: (_) {
          if (s.name == '/online-room') {
            opened = s.arguments;
            return const Scaffold(body: Text('ROOM'));
          }
          return const MatchLobbyScreen();
        },
      ),
    ));
    nav.currentState!.pushNamed('/match-lobby',
        arguments: item(outgoing: false, roomId: 'room-9').lobbyArgs());
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('ROOM'), findsOneWidget);
    final a = opened as OnlineRoomArgs;
    expect(a.roomId, 'room-9');
    expect(a.myMark, 'X');
    expect(a.opponentId, 'opp-1');
    expect(a.stake, 0);
  });

  testWidgets('incoming challenge popup shows card, accept and decline',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    // Service ticker is a long-lived static timer: create it outside the
    // test's fake clock.
    final c = (await tester.runAsync(() async =>
        ChallengeFlowService.simulateIncoming(
            fromId: 'opp-2', fromName: 'diployteam')))!;
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: nav,
      home: const Scaffold(body: Text('HOME')),
      routes: {
        '/challenge-incoming': (_) => const ChallengeIncomingScreen(),
      },
    ));
    nav.currentState!.pushNamed('/challenge-incoming', arguments: c);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('diployteam'), findsOneWidget);
    expect(find.text('ACCEPT'), findsOneWidget);
    expect(find.text('DECLINE'), findsOneWidget);
    expect(find.textContaining('Rank #1 · Score 76 · '), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('DECLINE'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('HOME'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
