/// Result of C1 online matchmaking RPCs (not AI quick_match).
class MatchmakingStatus {
  final String status; // searching | matched | timeout | cancelled | idle | error
  final String? roomId;
  final String? opponentId;
  final String? myMark; // O | X
  final int? boardSize;
  final int? stake;
  final String? message;
  final int? elapsedMs;

  const MatchmakingStatus({
    required this.status,
    this.roomId,
    this.opponentId,
    this.myMark,
    this.boardSize,
    this.stake,
    this.message,
    this.elapsedMs,
  });

  bool get isMatched => status == 'matched' && roomId != null;
  bool get isSearching => status == 'searching';
  bool get isError => status == 'error';
  bool get isTimeout => status == 'timeout';

  factory MatchmakingStatus.fromJson(Map<String, dynamic> json) {
    return MatchmakingStatus(
      status: '${json['status'] ?? 'error'}',
      roomId: json['room_id']?.toString(),
      opponentId: json['opponent_id']?.toString(),
      myMark: json['my_mark'] as String?,
      boardSize: (json['board_size'] as num?)?.toInt(),
      stake: (json['stake'] as num?)?.toInt(),
      message: json['message'] as String?,
      elapsedMs: (json['elapsed_ms'] as num?)?.toInt(),
    );
  }
}

/// Args for the C2/C3 online room boundary screen (no gameplay yet).
class OnlineRoomArgs {
  final String roomId;
  final String myMark;
  final String opponentId;
  final int boardSize;
  final int stake;

  const OnlineRoomArgs({
    required this.roomId,
    required this.myMark,
    required this.opponentId,
    required this.boardSize,
    required this.stake,
  });

  factory OnlineRoomArgs.fromMatch(MatchmakingStatus m) {
    return OnlineRoomArgs(
      roomId: m.roomId!,
      myMark: m.myMark ?? 'O',
      opponentId: m.opponentId ?? '',
      boardSize: m.boardSize ?? 3,
      stake: m.stake ?? 0,
    );
  }
}
