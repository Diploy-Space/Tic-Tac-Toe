import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  ProfileRepository._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<UserProfile?> fetchOwn() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return null;
    return fetchById(uid);
  }

  /// Public profile by UUID — never includes email.
  static Future<UserProfile?> fetchById(String userId) async {
    final row = await _db
        .from('public_profiles')
        .select('id, username, avatar_url, created_at')
        .eq('id', userId)
        .maybeSingle();
    if (row == null) return null;
    return UserProfile.fromJson(Map<String, dynamic>.from(row));
  }

  static Future<UserProfile?> fetchOwnWithRetry({
    int attempts = 5,
    Duration delay = const Duration(milliseconds: 400),
  }) async {
    for (var i = 0; i < attempts; i++) {
      final p = await fetchOwn();
      if (p != null) return p;
      if (i < attempts - 1) await Future<void>.delayed(delay);
    }
    return null;
  }

  static Future<void> updateAvatarUrl(String? url) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception('Not signed in');
    await _db.from('profiles').update({'avatar_url': url}).eq('id', uid);
  }
}
