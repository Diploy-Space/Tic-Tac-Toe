import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';
import 'package:tic_tac_game/l10n/gen/l10n_en.dart';

/// Changing MaterialApp.locale must re-translate screens already on screen.
void main() {
  testWidgets('switching language updates visible text', (tester) async {
    final locale = ValueNotifier(const Locale('en'));
    await tester.pumpWidget(ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (_, l, __) => MaterialApp(
        locale: l,
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        home: Builder(
            builder: (c) => Scaffold(
                body: Column(children: [
              Text(c.l10n.settings),
              Text(c.l10n.youWin),
            ]))),
      ),
    ));
    expect(find.text('Settings'), findsOneWidget);

    for (final (code, settings) in [
      ('hi', 'सेटिंग्स'),
      ('bn', 'সেটিংস'),
      ('ta', 'அமைப்புகள்'),
      ('ar', 'الإعدادات'),
      ('ja', '設定'),
    ]) {
      locale.value = Locale(code);
      await tester.pumpAndSettle();
      expect(find.text(settings), findsOneWidget, reason: code);
      expect(find.text('Settings'), findsNothing, reason: code);
    }
  });

  test('all 22 languages are supported and every key has a value', () {
    expect(L10n.supportedLocales.map((l) => l.languageCode).toSet(), {
      'en', 'hi', 'bn', 'or', 'ta', 'te', 'gu', 'mr', 'kn', 'ml', 'pa', //
      'ur', 'es', 'fr', 'de', 'ar', 'pt', 'zh', 'ja', 'ko', 'ru', 'it',
    });
    final en = L10nEn();
    for (final l in L10n.supportedLocales) {
      final t = lookupL10n(l);
      expect(t.settings, isNotEmpty);
      if (l.languageCode != 'en') {
        expect(t.settings, isNot(en.settings), reason: l.languageCode);
      }
    }
  });
}
