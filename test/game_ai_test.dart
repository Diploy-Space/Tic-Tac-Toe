import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/game/ai.dart';
import 'package:tic_tac_game/game/board.dart';

Board _board(int size, Map<int, String> marks) {
  final b = Board(size);
  marks.forEach((i, m) => b.cells[i] = m);
  return b;
}

void main() {
  group('win rules', () {
    test('detects 3-in-a-row win on 3×3', () {
      final b = Board(3);
      b.cells[0] = 'O';
      b.cells[1] = 'O';
      expect(b.winsAt(2, 'O'), isFalse);
      b.cells[2] = 'O';
      expect(b.winsAt(2, 'O'), isTrue);
    });

    test('4×4 needs 4 in a row', () {
      final b = Board(4);
      expect(b.winLength, 4);
      b.cells[0] = 'X';
      b.cells[1] = 'X';
      b.cells[2] = 'X';
      expect(b.winsAt(2, 'X'), isFalse);
      b.cells[3] = 'X';
      expect(b.winsAt(3, 'X'), isTrue);
    });

    test('5×5 needs 4 in a row', () {
      final b = Board(5);
      expect(b.winLength, 4);
      for (var i = 0; i < 3; i++) {
        b.cells[i] = 'O';
      }
      expect(b.winsAt(2, 'O'), isFalse);
      b.cells[3] = 'O';
      expect(b.winsAt(3, 'O'), isTrue);
    });
  });

  group('Hard AI tactics', () {
    test('takes immediate winning move on 3×3', () {
      final b = _board(3, {0: 'X', 1: 'X', 3: 'O', 4: 'O'});
      final move = GameAi(random: Random(1)).chooseMove(b, 'Hard');
      expect(move, 2);
      expect(b.cells[move], isNull);
    });

    test('blocks immediate opponent win on 3×3', () {
      final b = _board(3, {0: 'O', 1: 'O', 4: 'X'});
      final move = GameAi(random: Random(1)).chooseMove(b, 'Hard');
      expect(move, 2);
    });

    test('takes winning move on 4×4 (4-in-a-row)', () {
      final b = _board(4, {
        0: 'X',
        1: 'X',
        2: 'X',
        4: 'O',
        5: 'O',
        6: 'O',
      });
      final move = GameAi(random: Random(1)).chooseMove(b, 'Hard');
      expect(move, 3);
    });

    test('blocks opponent 4-in-a-row threat on 5×5', () {
      final b = _board(5, {
        0: 'O',
        1: 'O',
        2: 'O',
        10: 'X',
        11: 'X',
      });
      final move = GameAi(random: Random(1)).chooseMove(b, 'Hard');
      expect(move, 3);
    });

    test('is deterministic with no intentional noise', () {
      final b = _board(3, {0: 'O', 4: 'X', 8: 'O'});
      final a = GameAi(random: Random(99)).chooseMove(b.clone(), 'Hard');
      final c = GameAi(random: Random(1)).chooseMove(b.clone(), 'Hard');
      expect(a, c);
      expect(b.cells[a], isNull);
    });

    test('never returns an occupied cell', () {
      final b = _board(3, {
        0: 'O',
        1: 'X',
        2: 'O',
        3: 'X',
        4: 'O',
        5: 'X',
        6: 'X',
        7: 'O',
      });
      final move = GameAi(random: Random(0)).chooseMove(b, 'Hard');
      expect(move, 8);
    });
  });

  group('difficulty differentiation', () {
    test('Medium always takes an immediate win', () {
      final b = _board(3, {0: 'X', 1: 'X', 3: 'O', 4: 'O'});
      for (var seed = 0; seed < 40; seed++) {
        final move =
            GameAi(random: Random(seed)).chooseMove(b.clone(), 'Medium');
        expect(move, 2, reason: 'seed $seed');
      }
    });

    test('Easy sometimes ignores an immediate win', () {
      final b = _board(3, {0: 'X', 1: 'X', 3: 'O', 4: 'O'});
      var ignored = 0;
      for (var seed = 0; seed < 80; seed++) {
        final move =
            GameAi(random: Random(seed)).chooseMove(b.clone(), 'Easy');
        expect(b.cells[move], isNull);
        if (move != 2) ignored++;
      }
      expect(ignored, greaterThan(10),
          reason: 'Easy should often skip the forced win');
    });

    test('Hard never skips a forced win across seeds', () {
      final b = _board(3, {0: 'X', 1: 'X', 3: 'O', 4: 'O'});
      for (var seed = 0; seed < 20; seed++) {
        expect(GameAi(random: Random(seed)).chooseMove(b.clone(), 'Hard'), 2);
      }
    });
  });

  group('evaluate convention', () {
    test('AI-centric evaluate is positive when AI has stronger windows', () {
      final b = _board(3, {0: 'X', 1: 'X', 3: 'O'});
      expect(b.evaluate('X', 'O'), greaterThan(0));
    });

    test('center bias favors AI center', () {
      final aiCenter = _board(3, {4: 'X'});
      final humanCenter = _board(3, {4: 'O'});
      expect(
        aiCenter.evaluate('X', 'O'),
        greaterThan(humanCenter.evaluate('X', 'O')),
      );
    });
  });

  group('performance bounds', () {
    test('Hard 5×5 returns within ~3× time budget', () {
      final b = Board(5);
      b.cells[12] = 'O';
      final sw = Stopwatch()..start();
      final move = GameAi(random: Random(2)).chooseMove(b, 'Hard');
      sw.stop();
      expect(b.cells[move], isNull);
      expect(
        sw.elapsed,
        lessThan(GameAi.hardTimeBudget * 3),
        reason: 'bounded ID should finish near the soft budget',
      );
    });
  });
}
