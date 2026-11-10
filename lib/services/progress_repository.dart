import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressRepository {
  ProgressRepository._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<Set<String>> fetchMissionClaims({
    required List<String> periodKeys,
  }) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null || periodKeys.isEmpty) return {};
    final rows = await _db
        .from('mission_claims')
        .select('mission_id')
        .eq('user_id', uid)
        .inFilter('period_key', periodKeys);
    return {
      for (final r in rows as List) '${r['mission_id']}',
    };
  }

  static Future<void> claimMission({
    required String missionId,
    required String periodKey,
    required int reward,
  }) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception('Sign in required');
    try {
      await _db.from('mission_claims').insert({
        'user_id': uid,
        'mission_id': missionId,
        'period_key': periodKey,
        'reward': reward,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') return; // already claimed
      rethrow;
    }
  }

  static Future<Set<String>> fetchAchievements() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return {};
    final rows = await _db
        .from('achievement_unlocks')
        .select('achievement_id')
        .eq('user_id', uid);
    return {
      for (final r in rows as List) '${r['achievement_id']}',
    };
  }

  static Future<void> unlockAchievement(String achievementId) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return;
    try {
      await _db.from('achievement_unlocks').insert({
        'user_id': uid,
        'achievement_id': achievementId,
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') return;
      rethrow;
    }
  }
}
