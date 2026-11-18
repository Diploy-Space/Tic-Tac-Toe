import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/screens/how_to_play_screen.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';

void main() {
  testWidgets('How to play: 3 pages, Next / Skip close it', (tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: nav,
      home: const Scaffold(body: Text('HOME')),
      routes: {'/how-to-play': (_) => const HowToPlayScreen()},
    ));
    nav.currentState!.pushNamed('/how-to-play');
    await tester.pumpAndSettle();

    expect(find.text('HOW TO PLAY · 1/3'), findsOneWidget);
    expect(find.text('TAKE TURNS'), findsOneWidget);
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('HOW TO PLAY · 2/3'), findsOneWidget);
    await tester.tap(find.text('NEXT'));
    await tester.pumpAndSettle();
    expect(find.text('BIGGER BOARDS'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    await tester.tap(find.text("LET'S PLAY"));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);

    nav.currentState!.pushNamed('/how-to-play');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('HOME'), findsOneWidget);
  });
}
