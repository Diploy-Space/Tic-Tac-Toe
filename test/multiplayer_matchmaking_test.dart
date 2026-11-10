import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/models/multiplayer_match.dart';
import 'package:tic_tac_game/services/multiplayer_matchmaking_service.dart';

void main() {
  test('allowed board sizes and stakes match product dialogs', () {
    expect(MultiplayerMatchmakingService.allowedSizes, {3, 4, 5});
    expect(MultiplayerMatchmakingService.allowedStakes, {10, 25, 50, 100});
  });

  test('MatchmakingStatus parses matched payload', () {
    final m = MatchmakingStatus.fromJson({
      'status': 'matched',
      'room_id': 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
      'opponent_id': '11111111-2222-3333-4444-555555555555',
      'my_mark': 'X',
      'board_size': 4,
      'stake': 25,
    });
    expect(m.isMatched, isTrue);
    expect(m.myMark, 'X');
    expect(m.boardSize, 4);
    expect(m.stake, 25);
    final args = OnlineRoomArgs.fromMatch(m);
    expect(args.roomId, m.roomId);
    expect(args.myMark, 'X');
  });

  test('searching and error statuses', () {
    expect(MatchmakingStatus.fromJson({'status': 'searching'}).isSearching,
        isTrue);
    expect(
        MatchmakingStatus.fromJson(
            {'status': 'error', 'message': 'x'}).isError,
        isTrue);
    expect(MatchmakingStatus.fromJson({'status': 'timeout'}).isTimeout, isTrue);
  });
}
