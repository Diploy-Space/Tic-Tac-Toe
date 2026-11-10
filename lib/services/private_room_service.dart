import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/multiplayer_match.dart';
import 'auth_service.dart';

class PrivateRoomCreated {
  final String roomId;
  final String code;
  final int boardSize;
  final int stake;
  final DateTime? expiresAt;

  const PrivateRoomCreated({
    required this.roomId,
    required this.code,
    required this.boardSize,
    required this.stake,
    this.expiresAt,
  });
}

/// C3 private room RPCs. Does not replace C1 matchmaking.
class PrivateRoomService {
  PrivateRoomService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<PrivateRoomCreated> create({
    required int boardSize,
    required int stake,
  }) async {
    final raw = await _db.rpc(
      'create_private_room',
      params: {'p_board_size': boardSize, 'p_stake': stake},
    );
    final map = _asMap(raw);
    if (map == null) throw Exception('Unexpected create room response');
    if ('${map['status']}' == 'error') {
      throw Exception('${map['message'] ?? 'Create failed'}');
    }
    return PrivateRoomCreated(
      roomId: '${map['room_id']}',
      code: '${map['code']}',
      boardSize: (map['board_size'] as num?)?.toInt() ?? boardSize,
      stake: (map['stake'] as num?)?.toInt() ?? stake,
      expiresAt: DateTime.tryParse('${map['expires_at'] ?? ''}'),
    );
  }

  static Future<MatchmakingStatus> join(String code) async {
    try {
      final raw = await _db.rpc(
        'join_private_room',
        params: {'p_code': code.trim().toUpperCase()},
      );
      final map = _asMap(raw);
      if (map == null) {
        return const MatchmakingStatus(
          status: 'error',
          message: 'Unexpected join response',
        );
      }
      return MatchmakingStatus.fromJson(map);
    } catch (e, st) {
      debugPrint('PrivateRoomService.join: $e\n$st');
      return MatchmakingStatus(
        status: 'error',
        message: AuthService.messageFromError(e),
      );
    }
  }

  static Future<void> cancel(String roomId) async {
    final raw = await _db.rpc(
      'cancel_private_room',
      params: {'p_room_id': roomId},
    );
    final map = _asMap(raw);
    if (map != null && '${map['status']}' == 'error') {
      throw Exception('${map['message'] ?? 'Cancel failed'}');
    }
  }

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }
}
