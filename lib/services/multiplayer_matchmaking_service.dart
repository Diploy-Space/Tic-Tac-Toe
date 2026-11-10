import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/multiplayer_match.dart';
import 'auth_service.dart';

/// C1 online matchmaking only. Does not touch AI quick_match.
class MultiplayerMatchmakingService {
  MultiplayerMatchmakingService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static const allowedSizes = {3, 4, 5};
  static const allowedStakes = {10, 25, 50, 100};

  static Future<MatchmakingStatus> join({
    required int boardSize,
    required int stake,
  }) async {
    if (!AuthService.isSignedIn) {
      return const MatchmakingStatus(
        status: 'error',
        message: 'Sign in required for online matchmaking',
      );
    }
    if (!allowedSizes.contains(boardSize)) {
      return const MatchmakingStatus(
        status: 'error',
        message: 'Invalid board size',
      );
    }
    if (!allowedStakes.contains(stake)) {
      return const MatchmakingStatus(
        status: 'error',
        message: 'Invalid stake',
      );
    }

    try {
      final raw = await _db.rpc(
        'join_online_matchmaking',
        params: {
          'p_board_size': boardSize,
          'p_stake': stake,
        },
      );
      return _parse(raw);
    } catch (e, st) {
      debugPrint('MultiplayerMatchmakingService.join: $e\n$st');
      return MatchmakingStatus(
        status: 'error',
        message: AuthService.messageFromError(e),
      );
    }
  }

  static Future<MatchmakingStatus> poll() async {
    if (!AuthService.isSignedIn) {
      return const MatchmakingStatus(status: 'idle');
    }
    try {
      final raw = await _db.rpc('poll_online_matchmaking');
      return _parse(raw);
    } catch (e, st) {
      debugPrint('MultiplayerMatchmakingService.poll: $e\n$st');
      return MatchmakingStatus(
        status: 'error',
        message: AuthService.messageFromError(e),
      );
    }
  }

  static Future<MatchmakingStatus> leave() async {
    if (!AuthService.isSignedIn) {
      return const MatchmakingStatus(status: 'cancelled');
    }
    try {
      final raw = await _db.rpc('leave_online_matchmaking');
      return _parse(raw);
    } catch (e, st) {
      debugPrint('MultiplayerMatchmakingService.leave: $e\n$st');
      return MatchmakingStatus(
        status: 'error',
        message: AuthService.messageFromError(e),
      );
    }
  }

  static MatchmakingStatus _parse(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return MatchmakingStatus.fromJson(raw);
    }
    if (raw is Map) {
      return MatchmakingStatus.fromJson(Map<String, dynamic>.from(raw));
    }
    return const MatchmakingStatus(
      status: 'error',
      message: 'Unexpected matchmaking response',
    );
  }
}
