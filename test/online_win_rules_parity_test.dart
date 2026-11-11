import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/game/board.dart';

/// Documents the winLength rules that SQL `_mp_wins_at` must mirror (C4).
void main() {
  group('C4 win rule parity (Flutter Board)', () {
    test('3×3 wins with 3 in a row', () {
      final b = Board(3);
      expect(b.winLength, 3);
      b.cells[0] = 'O';
      b.cells[1] = 'O';
      b.cells[2] = 'O';
      expect(b.winsAt(2, 'O'), isTrue);
    });

    test('4×4 and 5×5 require 4 in a row', () {
      expect(Board(4).winLength, 4);
      expect(Board(5).winLength, 4);

      final b4 = Board(4);
      // Three in a row is not enough
      b4.cells[0] = 'X';
      b4.cells[1] = 'X';
      b4.cells[2] = 'X';
      expect(b4.winsAt(2, 'X'), isFalse);
      b4.cells[3] = 'X';
      expect(b4.winsAt(3, 'X'), isTrue);
    });

    test('outcomeIfPlace returns draw on full board without win', () {
      final b = Board(3);
      // X O X
      // O X O
      // O X O  — no three-in-a-row; last cell fill is draw path via isFull after place
      final fills = {
        0: 'X',
        1: 'O',
        2: 'X',
        3: 'O',
        4: 'X',
        5: 'O',
        6: 'O',
        7: 'X',
      };
      fills.forEach((i, m) => b.cells[i] = m);
      expect(b.outcomeIfPlace(8, 'O'), 'draw');
    });
  });
}
