import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import '../models/user_profile.dart';
import 'avatar_service.dart';
import 'profile_repository.dart';

/// In-memory profile state. Cleared on logout.
class ProfileService {
  ProfileService._();

  static final ValueNotifier<UserProfile?> current =
      ValueNotifier<UserProfile?>(null);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);

  static bool get _signedIn =>
      Supabase.instance.client.auth.currentSession != null;

  static String normalizeUsername(String raw) {
    return raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  /// Returns null when valid; otherwise an error message.
  static String? validateUsername(String raw) {
    final u = normalizeUsername(raw);
    if (u.length < 3 || u.length > 20) {
      return 'Username must be 3–20 characters (a-z, 0-9, _)';
    }
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(u)) {
      return 'Only lowercase letters, numbers, and underscore';
    }
    return null;
  }

  static void clear() {
    current.value = null;
    authAvatarUrl.value = null;
    authPlayerNo.value = null;
    loading.value = false;
  }

  static void _apply(UserProfile? p, {String? fallbackName}) {
    current.value = p;
    if (p != null) {
      authDisplayName.value = p.username;
      authAvatarUrl.value = p.avatarUrl;
      // Country / currency come from automatic detection, not the profile.
    } else if (!_signedIn) {
      authDisplayName.value = 'Guest';
      authAvatarUrl.value = null;
    } else if (fallbackName != null && fallbackName.isNotEmpty) {
      authDisplayName.value = fallbackName;
    }
  }

  static Future<UserProfile?> loadMyProfile({
    bool retry = true,
    String? fallbackName,
  }) async {
    if (!_signedIn) {
      clear();
      authDisplayName.value = 'Guest';
      return null;
    }
    loading.value = true;
    try {
      final p = retry
          ? await ProfileRepository.fetchOwnWithRetry()
          : await ProfileRepository.fetchOwn();
      _apply(p, fallbackName: fallbackName);
      if (p != null) await _loadPlayerNo();
      return p;
    } catch (e) {
      debugPrint('loadMyProfile: $e');
      if (fallbackName != null && fallbackName.isNotEmpty) {
        authDisplayName.value = fallbackName;
      }
      return null;
    } finally {
      loading.value = false;
    }
  }

  static Future<void> _loadPlayerNo() async {
    try {
      authPlayerNo.value = await ProfileRepository.fetchMyPlayerNo();
    } catch (e) {
      // Column missing until APPLY_PLAYER_ID.sql is run.
      debugPrint('loadPlayerNo: $e');
    }
  }

  static Future<UserProfile?> loadPublic(String userId) {
    return ProfileRepository.fetchById(userId);
  }

  static Future<void> changeAvatarFromGallery() async {
    final bytes = await AvatarService.pickImageBytes();
    if (bytes == null) return;
    final url = await AvatarService.uploadAndSet(bytes);
    final cur = current.value;
    if (cur != null) {
      _apply(cur.copyWith(avatarUrl: url));
    } else {
      await loadMyProfile(retry: false);
    }
  }

  static Future<void> removeAvatar() async {
    await AvatarService.deleteAvatar();
    final cur = current.value;
    if (cur != null) {
      _apply(cur.copyWith(clearAvatar: true));
    } else {
      authAvatarUrl.value = null;
    }
  }

  static Future<UserProfile> updateContact({
    required String callingCode,
    required String nationalNumber,
    required String countryIso2,
  }) async {
    final p = await ProfileRepository.updateContact(
      callingCode: callingCode,
      nationalNumber: nationalNumber,
      countryIso2: countryIso2,
    );
    _apply(p);
    return p;
  }

  static Future<UserProfile> updateProfile({
    required String username,
    String? callingCode,
    String? nationalNumber,
    String? countryIso2,
  }) async {
    final err = validateUsername(username);
    if (err != null) throw Exception(err);
    final p = await ProfileRepository.updateProfile(
      username: normalizeUsername(username),
      callingCode: callingCode,
      nationalNumber: nationalNumber,
      countryIso2: countryIso2,
    );
    _apply(p);
    return p;
  }
}
