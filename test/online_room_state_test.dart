import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/models/online_room_state.dart';

void main() {
  test('parses board cells and my turn', () {
    final s = OnlineRoomState.fromJson({
      'room_id': 'r1',
      'board_size': 3,
      'stake': 10,
      'player_o': 'a',
      'player_x': 'b',
      'my_mark': 'O',
      'board': [null, 'X', null, null, 'O', null, null, null, null],
      'current_turn': 'O',
      'move_count': 2,
      'winner': null,
      'room_status': 'active',
    });
    expect(s.cells[1], 'X');
    expect(s.cells[4], 'O');
    expect(s.isMyTurn, isTrue);
    expect(s.opponentId, 'b');
  });

  test('optimistic move paints mark and flips turn', () {
    final s = OnlineRoomState.fromJson({
      'room_id': 'r1',
      'board_size': 3,
      'stake': 10,
      'player_o': 'a',
      'player_x': 'b',
      'my_mark': 'O',
      'board': List.filled(9, null),
      'current_turn': 'O',
      'move_count': 0,
      'room_status': 'active',
    });
    final next = s.withOptimisticMove(4);
    expect(next.cells[4], 'O');
    expect(next.currentTurn, 'X');
    expect(next.moveCount, 1);
  });

  test('not my turn when current_turn differs', () {
    final s = OnlineRoomState.fromJson({
      'room_id': 'r1',
      'board_size': 3,
      'stake': 10,
      'player_o': 'a',
      'player_x': 'b',
      'my_mark': 'X',
      'board': List.filled(9, null),
      'current_turn': 'O',
      'move_count': 0,
      'room_status': 'active',
    });
    expect(s.isMyTurn, isFalse);
  });
}
