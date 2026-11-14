import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  ProfileRepository._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static Future<UserProfile?> fetchOwn() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return null;
    try {
      final raw = await _db.rpc('get_my_profile');
      final map = _asMap(raw);
      if (map != null && '${map['status']}' == 'ok') {
        return UserProfile.fromJson(map);
      }
    } catch (_) {
      // Migration not applied yet — fall back to public view.
    }
    return fetchById(uid);
  }

  /// Public profile by UUID — never includes email/phone.
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

  static Future<UserProfile> updateContact({
    required String callingCode,
    required String nationalNumber,
    required String countryIso2,
  }) async {
    final raw = await _db.rpc('update_my_profile_contact', params: {
      'p_calling_code': callingCode,
      'p_national_number': nationalNumber,
      'p_country_iso2': countryIso2,
    });
    final map = _asMap(raw);
    if (map == null || '${map['status']}' != 'ok') {
      throw Exception('${map?['message'] ?? 'Update failed'}');
    }
    return UserProfile.fromJson(map);
  }

  /// Username (+ optional phone). Requires migration 017.
  static Future<UserProfile> updateProfile({
    required String username,
    String? callingCode,
    String? nationalNumber,
    String? countryIso2,
  }) async {
    final raw = await _db.rpc('update_my_profile', params: {
      'p_username': username,
      'p_calling_code': callingCode,
      'p_national_number': nationalNumber,
      'p_country_iso2': countryIso2,
    });
    final map = _asMap(raw);
    if (map == null || '${map['status']}' != 'ok') {
      throw Exception('${map?['message'] ?? 'Update failed'}');
    }
    return UserProfile.fromJson(map);
  }
}
