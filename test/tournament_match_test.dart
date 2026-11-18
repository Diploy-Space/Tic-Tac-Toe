import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/screens/tournament_flow_screens.dart';

void main() {
  setUp(() {
    soundOn.value = false;
    vibrationOn.value = false;
  });

  Future<void> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routes: {
        '/': (_) => const TournamentMatchDemoScreen(),
        '/tournament-round-result': (c) => Scaffold(
            body: Text('RESULT ${ModalRoute.of(c)!.settings.arguments}')),
      },
    ));
    await tester.pump(const Duration(milliseconds: 500));
  }

  int marks(WidgetTester tester, String m) => tester
      .widgetList<Text>(find.text(m))
      .where((t) => (t.style?.fontSize ?? 0) == 36)
      .length;

  testWidgets('board starts empty and a tap places X', (tester) async {
    await open(tester);
    expect(marks(tester, 'X'), 0);
    expect(marks(tester, 'O'), 0);
    await tester.tap(find.byType(GestureDetector).at(4));
    await tester.pump();
    expect(marks(tester, 'X'), 1);
    expect(find.textContaining('rahul256 is thinking'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2)); // let the rival delay end
  });

  testWidgets('rival answers, and taps are ignored on its turn',
      (tester) async {
    await open(tester);
    await tester.tap(find.byType(GestureDetector).at(4));
    await tester.pump();
    await tester.tap(find.byType(GestureDetector).at(0)); // not my turn
    await tester.pump();
    expect(marks(tester, 'X'), 1);
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(marks(tester, 'O'), 1);
    expect(find.textContaining('Your move'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('time running out skips my move', (tester) async {
    await open(tester);
    await tester.pump(const Duration(seconds: 20));
    expect(find.textContaining('rahul256 is thinking'), findsOneWidget);
    expect(marks(tester, 'X'), 0);
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(const SizedBox()); // stop the move clock
  });
}
