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
    loading.value = false;
  }

  static void _apply(UserProfile? p, {String? fallbackName}) {
    current.value = p;
    if (p != null) {
      authDisplayName.value = p.username;
      authAvatarUrl.value = p.avatarUrl;
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
}
