import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';
import 'package:tic_tac_game/screens/chat_rules_screen.dart';
import 'package:tic_tac_game/services/privacy_prefs_service.dart';
import 'package:tic_tac_game/services/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
    );
    await AppStorage.init();
    PrivacyPrefsService.bind();
  });

  testWidgets('chat privacy: tapping an option selects and saves it',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: const ChatRulesScreen(),
    ));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('WHO CAN SEND YOU MESSAGES'), findsOneWidget);
    expect(PrivacyPrefsService.chatWho.value, 0);

    await tester.ensureVisible(find.text('Friends only'));
    await tester.tap(find.text('Friends only'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(PrivacyPrefsService.chatWho.value, 1);
    expect(AppStorage.chatPrivacyWho, 1);

    await tester.ensureVisible(find.text('Nobody'));
    await tester.tap(find.text('Nobody'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(AppStorage.chatPrivacyWho, 2);
  });
}
