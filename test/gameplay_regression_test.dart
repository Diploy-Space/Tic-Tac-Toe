import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/game/ai.dart';
import 'package:tic_tac_game/game/ai_callback_gate.dart';
import 'package:tic_tac_game/game/board.dart';

/// Lightweight regression checks for Phase 2 gameplay / AI / timer-gate rules.
void main() {
  group('boards & outcomes', () {
    test('3×3 win / draw detection', () {
      final win = Board(3);
      win.cells[0] = 'O';
      win.cells[1] = 'O';
      win.cells[2] = 'O';
      expect(win.winsAt(2, 'O'), isTrue);

      final draw = Board(3);
      // O X O / X O X / X O X — full, no three-in-a-row
      final pattern = ['O', 'X', 'O', 'X', 'O', 'X', 'X', 'O', 'X'];
      for (var i = 0; i < 9; i++) {
        draw.cells[i] = pattern[i];
      }
      expect(draw.isFull, isTrue);
      for (var i = 0; i < 9; i++) {
        expect(draw.winsAt(i, draw.cells[i]!), isFalse);
      }
    });

    test('4×4 and 5×5 use winLength 4', () {
      expect(Board(4).winLength, 4);
      expect(Board(5).winLength, 4);
    });
  });

  group('AI callback gate (timeout / leave / over)', () {
    test('stale token cannot move after invalidate', () {
      final gate = AiCallbackGate();
      final token = gate.token;
      gate.invalidate();
      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'X',
        ),
        isFalse,
      );
    });

    test('blocks AI when over or wrong turn', () {
      final gate = AiCallbackGate();
      expect(
        gate.allowMove(
          scheduledToken: gate.token,
          mounted: true,
          over: true,
          vsAi: true,
          turn: 'X',
        ),
        isFalse,
      );
      expect(
        gate.allowMove(
          scheduledToken: gate.token,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'O',
        ),
        isFalse,
      );
    });
  });

  group('AI illegal moves & difficulties', () {
    test('Hard never plays occupied cells on sparse board', () {
      final b = Board(3);
      b.cells[0] = 'O';
      b.cells[4] = 'X';
      final move = GameAi(random: Random(7)).chooseMove(b, 'Hard');
      expect(b.cells[move], isNull);
    });

    test('chooseMoveAsync Hard returns legal empty cell', () async {
      final b = Board(3);
      b.cells[0] = 'O';
      b.cells[1] = 'X';
      final move = await GameAi.chooseMoveAsync(b, 'Hard', seed: 3);
      expect(b.cells[move], isNull);
    });
  });
}
