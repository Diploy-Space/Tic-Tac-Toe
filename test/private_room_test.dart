import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/models/online_room_state.dart';

void main() {
  test('waiting room has no opponent until player_x set', () {
    final s = OnlineRoomState.fromJson({
      'room_id': 'r1',
      'board_size': 3,
      'stake': 10,
      'player_o': 'host',
      'player_x': null,
      'my_mark': 'O',
      'board': List.filled(9, null),
      'current_turn': 'O',
      'move_count': 0,
      'room_status': 'waiting',
    });
    expect(s.hasOpponent, isFalse);
    expect(s.roomStatus, 'waiting');
    expect(s.isMyTurn, isFalse); // waiting is not active
  });

  test('active private room with opponent', () {
    final s = OnlineRoomState.fromJson({
      'room_id': 'r1',
      'board_size': 3,
      'stake': 25,
      'player_o': 'host',
      'player_x': 'guest',
      'my_mark': 'X',
      'board': List.filled(9, null),
      'current_turn': 'O',
      'move_count': 0,
      'room_status': 'active',
    });
    expect(s.hasOpponent, isTrue);
    expect(s.opponentId, 'host');
  });
}
