/// Authoritative online room snapshot from PostgreSQL (via RPC).
class OnlineRoomState {
  final String roomId;
  final int boardSize;
  final int stake;
  final String playerO;
  final String playerX;
  final String myMark;
  final List<String?> cells;
  final String currentTurn;
  final int moveCount;
  final String? winner;
  final String roomStatus;
  final DateTime? updatedAt;

  const OnlineRoomState({
    required this.roomId,
    required this.boardSize,
    required this.stake,
    required this.playerO,
    required this.playerX,
    required this.myMark,
    required this.cells,
    required this.currentTurn,
    required this.moveCount,
    this.winner,
    required this.roomStatus,
    this.updatedAt,
  });

  bool get isFinished =>
      winner != null ||
      roomStatus == 'finished' ||
      roomStatus == 'completed' ||
      roomStatus == 'abandoned';

  bool get isMyTurn =>
      !isFinished &&
      (roomStatus == 'active' || roomStatus == 'matched') &&
      currentTurn == myMark;

  String get opponentId {
    final id = myMark == 'O' ? playerX : playerO;
    if (id.isEmpty || id == 'null') return '';
    return id;
  }

  bool get hasOpponent => opponentId.isNotEmpty;

  /// Instant local preview before server ACK (reconciled by snapshot).
  OnlineRoomState withOptimisticMove(int cellIndex) {
    final next = List<String?>.from(cells);
    if (cellIndex < 0 || cellIndex >= next.length || next[cellIndex] != null) {
      return this;
    }
    next[cellIndex] = myMark;
    return OnlineRoomState(
      roomId: roomId,
      boardSize: boardSize,
      stake: stake,
      playerO: playerO,
      playerX: playerX,
      myMark: myMark,
      cells: next,
      currentTurn: myMark == 'O' ? 'X' : 'O',
      moveCount: moveCount + 1,
      winner: winner,
      roomStatus: roomStatus == 'matched' ? 'active' : roomStatus,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  /// Build from Realtime `newRecord` (keeps local [myMark]).
  factory OnlineRoomState.fromRealtimeRow(
    Map<String, dynamic> row, {
    required String myMark,
  }) {
    return OnlineRoomState.fromJson({
      ...row,
      'room_id': row['id'] ?? row['room_id'],
      'my_mark': myMark,
      'room_status': row['status'] ?? row['room_status'],
    });
  }

  factory OnlineRoomState.fromJson(Map<String, dynamic> json) {
    final size = (json['board_size'] as num?)?.toInt() ?? 3;
    final rawBoard = json['board'];
    final cells = <String?>[];
    if (rawBoard is List) {
      for (final e in rawBoard) {
        if (e == null) {
          cells.add(null);
        } else {
          final s = '$e';
          cells.add(s == 'null' || s.isEmpty ? null : s);
        }
      }
    }
    while (cells.length < size * size) {
      cells.add(null);
    }
    String idOf(dynamic v) {
      if (v == null) return '';
      final s = '$v';
      return s == 'null' ? '' : s;
    }

    return OnlineRoomState(
      roomId: '${json['room_id']}',
      boardSize: size,
      stake: (json['stake'] as num?)?.toInt() ?? 0,
      playerO: idOf(json['player_o']),
      playerX: idOf(json['player_x']),
      myMark: '${json['my_mark'] ?? 'O'}',
      cells: cells,
      currentTurn: '${json['current_turn'] ?? 'O'}',
      moveCount: (json['move_count'] as num?)?.toInt() ?? 0,
      winner: json['winner'] as String?,
      roomStatus: '${json['room_status'] ?? json['status'] ?? 'active'}',
      updatedAt: DateTime.tryParse('${json['updated_at'] ?? ''}'),
    );
  }
}
