/// One in-game chat message (+ aggregated emoji reactions).
class GameChatMessage {
  final String id;
  final String roomId;
  final String senderId;
  final String message;
  final DateTime createdAt;
  /// emoji → set of user ids who reacted
  final Map<String, Set<String>> reactions;

  const GameChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.reactions = const {},
  });

  static const allowedEmojis = ['👍', '❤️', '😂', '🔥', '😮', '👏'];

  bool isMine(String? uid) => uid != null && senderId == uid;

  GameChatMessage copyWith({
    Map<String, Set<String>>? reactions,
  }) =>
      GameChatMessage(
        id: id,
        roomId: roomId,
        senderId: senderId,
        message: message,
        createdAt: createdAt,
        reactions: reactions ?? this.reactions,
      );

  factory GameChatMessage.fromJson(Map<String, dynamic> json) {
    return GameChatMessage(
      id: '${json['id']}',
      roomId: '${json['room_id']}',
      senderId: '${json['sender_id']}',
      message: '${json['message'] ?? ''}',
      createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal() ??
          DateTime.now(),
    );
  }
}

/// Gate: chat only for real authenticated PvP rooms (never AI / GameArgs.vsAi).
class InGameChatGate {
  InGameChatGate._();

  /// True when both seats are real profile UUIDs (online multiplayer room).
  static bool isRealPlayerVsRealPlayer({
    required String? playerO,
    required String? playerX,
    required String? opponentId,
  }) {
    final o = (playerO ?? '').trim();
    final x = (playerX ?? '').trim();
    final opp = (opponentId ?? '').trim();
    if (o.isEmpty || x.isEmpty || opp.isEmpty) return false;
    if (o == 'null' || x == 'null' || opp == 'null') return false;
    // AI / local games never populate multiplayer room UUIDs.
    return _looksLikeUuid(o) && _looksLikeUuid(x) && _looksLikeUuid(opp);
  }

  /// Local AI / quick_match / pass & play never use multiplayer room chat.
  static bool isAiOrLocalMatch({
    required bool vsAi,
    required bool quickMatch,
  }) {
    // vsAi covers Doll + Random AI; quickMatch alone is also AI simulation.
    return vsAi || quickMatch;
  }

  static bool _looksLikeUuid(String s) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(s);
  }
}
