import 'dart:math';

import 'package:flutter/foundation.dart';
import '../models.dart';
import '../models/cloud_match.dart';
import 'auth_service.dart';
import 'connectivity_service.dart';
import 'match_repository.dart';

/// Result of attempting to sync a finished match to Supabase.
class MatchSyncResult {
  final bool attempted;
  final bool ok;
  final String? message;

  const MatchSyncResult({
    required this.attempted,
    required this.ok,
    this.message,
  });

  static const skipped = MatchSyncResult(attempted: false, ok: true);
}

/// Cloud match sync + cached stats for UI (local SharedPreferences unchanged).
class MatchSyncService {
  MatchSyncService._();

  static final ValueNotifier<MatchStatistics?> myStats =
      ValueNotifier<MatchStatistics?>(null);
  static final ValueNotifier<int?> myRank = ValueNotifier<int?>(null);
  static final ValueNotifier<List<CloudMatch>> history =
      ValueNotifier<List<CloudMatch>>(const []);
  static final ValueNotifier<List<LeaderboardEntry>> leaderboard =
      ValueNotifier<List<LeaderboardEntry>>(const []);
  static final ValueNotifier<int> tick = ValueNotifier<int>(0);

  /// Derived from [history] (newest-first). Null when no cloud history.
  static int? derivedBestStreak;
  static Map<int, double> derivedBoardRates = const {};
  static List<bool> derivedRecentForm = const [];

  static void clear() {
    myStats.value = null;
    myRank.value = null;
    history.value = const [];
    leaderboard.value = const [];
    derivedBestStreak = null;
    derivedBoardRates = const {};
    derivedRecentForm = const [];
    tick.value++;
  }

  static void _deriveFromHistory(List<CloudMatch> hist) {
    // hist is newest-first from repo.
    var best = 0;
    var cur = 0;
    // Chronological for streak: oldest → newest
    for (final m in hist.reversed) {
      if (m.result == 'win') {
        cur++;
        if (cur > best) best = cur;
      } else {
        cur = 0;
      }
    }
    derivedBestStreak = hist.isEmpty ? 0 : best;

    final played = <int, int>{3: 0, 4: 0, 5: 0};
    final wins = <int, int>{3: 0, 4: 0, 5: 0};
    for (final m in hist) {
      played[m.boardSize] = (played[m.boardSize] ?? 0) + 1;
      if (m.result == 'win') {
        wins[m.boardSize] = (wins[m.boardSize] ?? 0) + 1;
      }
    }
    derivedBoardRates = {
      for (final size in [3, 4, 5])
        size: (played[size] ?? 0) == 0
            ? 0.0
            : (wins[size] ?? 0) / played[size]!,
    };

    derivedRecentForm = [
      for (final m in hist.take(7)) m.result == 'win',
    ];
  }

  /// Maps game outcome to cloud `result`. Pass & Play is not synced.
  static String? cloudResult({
    required String? winner,
    required bool vsAi,
  }) {
    if (!vsAi) return null; // pass_play stays local-only
    if (winner == null) return 'draw';
    if (winner == 'O') return 'win';
    if (winner == 'X') return 'loss';
    return null;
  }

  static String? cloudMode({
    required bool vsAi,
    required bool quickMatch,
  }) {
    if (!vsAi) return null;
    if (quickMatch) return 'quick_match';
    return 'ai';
  }

  static String newMatchId() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40;
    b[8] = (b[8] & 0x3f) | 0x80;
    String hex(int s, int e) => b
        .sublist(s, e)
        .map((x) => x.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex(0, 4)}-${hex(4, 6)}-${hex(6, 8)}-${hex(8, 10)}-${hex(10, 16)}';
  }

  /// After local [PlayerStats.recordMatch]. No-ops for guests / pass & play.
  static Future<MatchSyncResult> syncCompletedMatch({
    required String? winner,
    required GameArgs args,
    required int coinDelta,
  }) async {
    // Only sync when confirmed online — avoids misleading cloud errors offline.
    if (!ConnectivityService.instance.isOnline) {
      debugPrint('MatchSync: skipped (not online)');
      return MatchSyncResult.skipped;
    }

    final session = AuthService.session;
    final uid = AuthService.user?.id;
    if (session == null || uid == null) {
      debugPrint('MatchSync: skipped (no session/uid)');
      return const MatchSyncResult(
        attempted: false,
        ok: true,
        message: 'Sign in to save matches to the cloud',
      );
    }

    final mode = cloudMode(vsAi: args.vsAi, quickMatch: args.quickMatch);
    final result = cloudResult(winner: winner, vsAi: args.vsAi);
    if (mode == null || result == null) {
      debugPrint('MatchSync: skipped (pass & play / non-cloud mode)');
      return MatchSyncResult.skipped;
    }

    final id = newMatchId();
    final row = <String, dynamic>{
      'id': id,
      'user_id': uid,
      'opponent_name': args.opponentName,
      'result': result,
      'board_size': args.size,
      'mode': mode,
      'difficulty': args.difficulty,
      'stake': args.stake,
      'coin_delta': coinDelta,
      'played_at': DateTime.now().toUtc().toIso8601String(),
    };

    debugPrint('MatchSync: inserting uid=$uid mode=$mode result=$result');

    try {
      final savedId = await MatchRepository.insertMatch(row);
      debugPrint('MatchSync: saved id=$savedId');
      await refresh();
      return const MatchSyncResult(
        attempted: true,
        ok: true,
        message: 'Match saved to cloud',
      );
    } catch (e, st) {
      debugPrint('MatchSyncService.syncCompletedMatch: $e\n$st');
      return MatchSyncResult(
        attempted: true,
        ok: false,
        message: AuthService.messageFromError(e),
      );
    }
  }

  static Future<void> refresh() async {
    if (!AuthService.isSignedIn) {
      clear();
      return;
    }
    try {
      final stats = await MatchRepository.fetchOwnStatistics();
      final ownBoard = await MatchRepository.fetchOwnLeaderboardRow();
      final hist = await MatchRepository.fetchOwnHistory();
      final board = await MatchRepository.fetchLeaderboard();
      myStats.value = stats;
      myRank.value = ownBoard?.rank;
      history.value = hist;
      leaderboard.value = board;
      _deriveFromHistory(hist);
      tick.value++;
    } catch (e) {
      debugPrint('MatchSyncService.refresh: $e');
    }
  }
}
