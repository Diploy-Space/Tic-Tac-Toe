import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cloud_match.dart';

class MatchRepository {
  MatchRepository._();

  static SupabaseClient get _db => Supabase.instance.client;

  /// Insert match and confirm the row via RETURNING. Idempotent on [id].
  static Future<String> insertMatch(Map<String, dynamic> row) async {
    try {
      final inserted = await _db.from('matches').insert(row).select('id').single();
      return '${inserted['id']}';
    } on PostgrestException catch (e) {
      // 23505 = unique_violation (duplicate id) → already saved.
      if (e.code == '23505') return '${row['id']}';
      rethrow;
    }
  }

  static Future<List<CloudMatch>> fetchOwnHistory({int limit = 50}) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return const [];
    final rows = await _db
        .from('matches')
        .select(
          'id, user_id, opponent_user_id, opponent_name, result, board_size, '
          'mode, difficulty, stake, coin_delta, played_at',
        )
        .eq('user_id', uid)
        .order('played_at', ascending: false)
        .limit(limit);
    return [
      for (final r in rows as List)
        CloudMatch.fromJson(Map<String, dynamic>.from(r as Map)),
    ];
  }

  static Future<MatchStatistics?> fetchOwnStatistics() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return null;
    final row =
        await _db.from('my_match_statistics').select().maybeSingle();
    if (row == null) {
      return MatchStatistics(
        userId: uid,
        played: 0,
        wins: 0,
        losses: 0,
        draws: 0,
        score: 0,
        winRate: 0,
      );
    }
    return MatchStatistics.fromJson(Map<String, dynamic>.from(row));
  }

  static Future<List<LeaderboardEntry>> fetchLeaderboard({int limit = 50}) async {
    final rows = await _db
        .from('leaderboard')
        .select(
          'user_id, username, avatar_url, played, wins, losses, draws, '
          'score, win_rate, rank',
        )
        .order('rank', ascending: true)
        .limit(limit);
    return [
      for (final r in rows as List)
        LeaderboardEntry.fromJson(Map<String, dynamic>.from(r as Map)),
    ];
  }

  static Future<LeaderboardEntry?> fetchOwnLeaderboardRow() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return null;
    return fetchLeaderboardEntry(uid);
  }

  /// Public leaderboard row for any user (rank / score / wins).
  static Future<LeaderboardEntry?> fetchLeaderboardEntry(String userId) async {
    final row = await _db
        .from('leaderboard')
        .select(
          'user_id, username, avatar_url, played, wins, losses, draws, '
          'score, win_rate, rank',
        )
        .eq('user_id', userId)
        .maybeSingle();
    if (row == null) return null;
    return LeaderboardEntry.fromJson(Map<String, dynamic>.from(row));
  }
}
