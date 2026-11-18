import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:tic_tac_game/game/board.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/screens/game_screen.dart';
import 'package:tic_tac_game/widgets/match_turn.dart';
import 'package:tic_tac_game/l10n/app_localizations.dart';

/// Offline (AI + pass & play) result flow: win / loss / draw detection,
/// winning-line highlight, result dialog and Play again.
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

  group('Board.winningLine', () {
    List<int> line(int size, List<int> cells, int last) {
      final b = Board(size);
      for (final i in cells) {
        b.cells[i] = 'O';
      }
      return b.winningLine(last, 'O');
    }

    test('3×3 rows, columns and both diagonals', () {
      expect(line(3, [0, 1, 2], 1), [0, 1, 2]);
      expect(line(3, [6, 7, 8], 6), [6, 7, 8]);
      expect(line(3, [1, 4, 7], 7), [1, 4, 7]);
      expect(line(3, [0, 4, 8], 4), [0, 4, 8]);
      expect(line(3, [2, 4, 6], 2), [2, 4, 6]);
    });

    test('no line when not three in a row', () {
      expect(line(3, [0, 1, 5], 1), isEmpty);
      expect(Board(3).winningLine(0, 'O'), isEmpty);
    });

    test('4×4 and 5×5 need four', () {
      expect(line(4, [0, 1, 2], 2), isEmpty);
      expect(line(4, [0, 5, 10, 15], 10), [0, 5, 10, 15]);
      expect(line(5, [3, 7, 11, 15], 3), [3, 7, 11, 15]);
      expect(line(5, [5, 6, 7, 8, 9], 7), [5, 6, 7, 8, 9]);
    });
  });

  // ---- widget flow ----------------------------------------------------

  Future<void> openGame(WidgetTester tester, GameArgs args) async {
    // Phone-sized screen so the whole board is on-screen.
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      navigatorKey: nav,
      initialRoute: '/home',
      routes: {
        '/home': (_) => const Scaffold(body: Text('HOME')),
        '/game': (_) => const GameScreen(),
      },
    ));
    nav.currentState!.pushNamed('/game', arguments: args);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900)); // board pop-in
    await tester.pump(const Duration(milliseconds: 100)); // route settles
  }

  List<TurnBoardCell> cells(WidgetTester tester) => tester
      .widgetList<TurnBoardCell>(find.byType(TurnBoardCell))
      .toList();

  Future<void> tapCell(WidgetTester tester, int i) async {
    await tester.tap(find.byType(TurnBoardCell).at(i));
    await tester.pump(const Duration(milliseconds: 350));
  }

  /// Plays [moves] alternately (O first) in pass & play.
  Future<void> play(WidgetTester tester, List<int> moves) async {
    for (final m in moves) {
      await tapCell(tester, m);
    }
  }

  Future<void> waitForResult(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 800)); // dialog anims
  }

  Future<void> playAgain(WidgetTester tester) async {
    await tester.ensureVisible(find.text('PLAY AGAIN'));
    await tester.tap(find.text('PLAY AGAIN'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 100)); // dialog gone
  }

  void expectFreshBoard(WidgetTester tester) {
    final cs = cells(tester);
    expect(cs.every((c) => c.value == null), isTrue,
        reason: 'board should be empty after Play again');
    expect(cs.every((c) => c.winColor == null && !c.faded), isTrue);
  }

  testWidgets('pass & play: Player 1 win highlights line, Play again resets',
      (tester) async {
    await openGame(tester, const GameArgs(size: 3, vsAi: false));
    // O 0,1,2 — X 3,4
    await play(tester, [0, 3, 1, 4, 2]);

    final cs = cells(tester);
    for (final i in [0, 1, 2]) {
      expect(cs[i].winColor, isNotNull, reason: 'cell $i in winning line');
    }
    expect(cs[3].faded, isTrue);
    expect(cs[5].faded, isTrue);

    await waitForResult(tester);
    expect(find.text('VICTORY'), findsOneWidget);
    expect(find.text('Player 1 wins!'), findsWidgets);

    await playAgain(tester);
    expectFreshBoard(tester);
    expect(find.text('VICTORY'), findsNothing);
    expect(find.textContaining("Player 1's move"), findsOneWidget);

    // Second match works too: Player 2 wins column 2,5,8.
    await play(tester, [0, 2, 1, 5, 7, 8]);
    await waitForResult(tester);
    expect(find.text('Player 2 wins!'), findsWidgets);
    final cs2 = cells(tester);
    for (final i in [2, 5, 8]) {
      expect(cs2[i].winColor, isNotNull);
    }
  });

  testWidgets('pass & play: full board with no line is a draw',
      (tester) async {
    await openGame(tester, const GameArgs(size: 3, vsAi: false));
    // O X O / O X X / X O O
    await play(tester, [0, 1, 2, 4, 3, 5, 7, 6, 8]);
    expect(cells(tester).every((c) => c.winColor == null), isTrue);

    await waitForResult(tester);
    expect(find.text('DRAW'), findsOneWidget);
    expect(find.text('VICTORY'), findsNothing);
    expect(find.text('DEFEAT'), findsNothing);

    await playAgain(tester);
    expectFreshBoard(tester);
  });

  testWidgets('pass & play: 4×4 needs four in a row', (tester) async {
    await openGame(tester, const GameArgs(size: 4, vsAi: false));
    // O 0,1,2 then X blocks nothing; O 3 completes the row.
    await play(tester, [0, 4, 1, 5, 2, 6]);
    expect(find.text('VICTORY'), findsNothing,
        reason: 'three in a row is not a win on 4×4');
    await play(tester, [3]);
    await waitForResult(tester);
    expect(find.text('Player 1 wins!'), findsWidgets);
  });

  /// Lets the AI's delayed move run (Medium/Hard search runs on an isolate).
  Future<void> letAiMove(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump(const Duration(milliseconds: 350));
  }

  bool isOver(WidgetTester tester) =>
      find.text('VICTORY').evaluate().isNotEmpty ||
      find.text('DEFEAT').evaluate().isNotEmpty ||
      find.text('DRAW').evaluate().isNotEmpty;

  /// Human (O) takes a winning cell if there is one, else the centre,
  /// else the lowest empty cell.
  int greedyMove(List<String?> b) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], //
      [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6],
    ];
    for (final l in lines) {
      final marks = l.map((i) => b[i]).toList();
      if (marks.where((m) => m == 'O').length == 2 && marks.contains(null)) {
        return l[marks.indexOf(null)];
      }
    }
    if (b[4] == null) return 4;
    return b.indexOf(null);
  }

  /// Plays one match vs AI; returns 'VICTORY' / 'DEFEAT' / 'DRAW'.
  Future<String> playVsAi(
      WidgetTester tester, int Function(List<String?>) pick) async {
    for (var turn = 0; turn < 9 && !isOver(tester); turn++) {
      final b = cells(tester).map((c) => c.value).toList();
      final empty = b.where((v) => v == null).length;
      final oCount = b.where((v) => v == 'O').length;
      final xCount = b.where((v) => v == 'X').length;
      if (empty == 0) break;
      if (oCount == xCount) {
        await tapCell(tester, pick(b));
        // Game may have ended on our move.
        await tester.pump(const Duration(milliseconds: 100));
        final after = cells(tester).map((c) => c.value).toList();
        if (after.contains(null) && !_lineFor(after)) await letAiMove(tester);
      } else {
        await letAiMove(tester);
      }
      if (!isOver(tester)) {
        // Result dialog appears after the line highlight.
        final now = cells(tester).map((c) => c.value).toList();
        if (_lineFor(now) || !now.contains(null)) await waitForResult(tester);
      }
    }
    if (!isOver(tester)) await waitForResult(tester);
    for (final r in ['VICTORY', 'DEFEAT', 'DRAW']) {
      if (find.text(r).evaluate().isNotEmpty) return r;
    }
    fail('no result dialog shown');
  }

  testWidgets('vs AI (Hard): passive play ends in a loss with DEFEAT',
      (tester) async {
    await openGame(tester, const GameArgs(size: 3, difficulty: 'Hard'));
    final r = await playVsAi(tester, (b) => b.indexOf(null));
    expect(r, 'DEFEAT');
    expect(find.text('You lose'), findsWidgets);
    expect(cells(tester).where((c) => c.winColor != null).length, 3);

    // Play again: new board, AI still answers.
    await playAgain(tester);
    expectFreshBoard(tester);
    await tapCell(tester, 4);
    await letAiMove(tester);
    final b = cells(tester).map((c) => c.value).toList();
    expect(b.where((v) => v == 'X').length, 1, reason: 'AI moved after rematch');
  });

  testWidgets('vs AI (Easy): win shows VICTORY, coins and bonus offer',
      (tester) async {
    await openGame(tester, const GameArgs(size: 3, difficulty: 'Easy'));
    final seen = <String>{};
    for (var round = 0; round < 25 && !seen.contains('VICTORY'); round++) {
      final r = await playVsAi(tester, greedyMove);
      seen.add(r);
      if (r == 'VICTORY') {
        expect(find.text('You win!'), findsWidgets);
        expect(find.textContaining('10 coins'), findsOneWidget);
        expect(find.textContaining('Bonus Coins'), findsOneWidget);
        expect(cells(tester).where((c) => c.winColor != null).length, 3);
      } else if (r == 'DEFEAT') {
        expect(find.text('You lose'), findsWidgets);
      }
      await playAgain(tester);
      expectFreshBoard(tester);
    }
    expect(seen, contains('VICTORY'));
  });

  testWidgets('turn timer runs out: a move is made for the player',
      (tester) async {
    await openGame(tester, const GameArgs(size: 3, vsAi: false));
    await tester.pump(const Duration(seconds: 21));
    await tester.pump(const Duration(milliseconds: 400));
    final b = cells(tester).map((c) => c.value).toList();
    expect(b.where((v) => v == 'O').length, 1);
    expect(find.textContaining("Player 2's move"), findsOneWidget);
    await tester.pump(const Duration(seconds: 2)); // let flash finish
  });
}

bool _lineFor(List<String?> b) {
  const lines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], //
    [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6],
  ];
  return lines.any((l) =>
      b[l[0]] != null && b[l[0]] == b[l[1]] && b[l[1]] == b[l[2]]);
}
