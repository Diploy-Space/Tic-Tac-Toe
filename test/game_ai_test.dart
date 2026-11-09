import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/game/ai.dart';
import 'package:tic_tac_game/game/board.dart';

void main() {
  test('detects 3-in-a-row win', () {
    final b = Board(3);
    b.cells[0] = 'O';
    b.cells[1] = 'O';
    expect(b.winsAt(2, 'O'), isFalse); // empty cell is not a win
    b.cells[2] = 'O';
    expect(b.winsAt(2, 'O'), isTrue);
  });

  test('hard AI takes immediate winning move', () {
    final b = Board(3);
    // X X _ on top row — AI (X) should play index 2
    b.cells[0] = 'X';
    b.cells[1] = 'X';
    b.cells[3] = 'O';
    b.cells[4] = 'O';
    final move = GameAi().chooseMove(b, 'Hard');
    expect(move, 2);
  });

  test('hard AI blocks opponent win', () {
    final b = Board(3);
    // O O _ — AI must block at 2
    b.cells[0] = 'O';
    b.cells[1] = 'O';
    b.cells[4] = 'X';
    final move = GameAi().chooseMove(b, 'Hard');
    expect(move, 2);
  });

  test('4x4 needs 4 in a row', () {
    final b = Board(4);
    expect(b.winLength, 4);
    b.cells[0] = 'X';
    b.cells[1] = 'X';
    b.cells[2] = 'X';
    expect(b.winsAt(2, 'X'), isFalse);
    b.cells[3] = 'X';
    expect(b.winsAt(3, 'X'), isTrue);
  });
}
