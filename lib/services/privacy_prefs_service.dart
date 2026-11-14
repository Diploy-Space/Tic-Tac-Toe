import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models.dart';
import 'auth_service.dart';
import 'storage.dart';

/// Syncs Challenge privacy prefs with Supabase (signed-in) + SharedPreferences cache.
class PrivacyPrefsService {
  PrivacyPrefsService._();

  static final ValueNotifier<int> challengeWho = ValueNotifier<int>(0);
  static final ValueNotifier<bool> saving = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  static bool _bound = false;
  static bool _applyingRemote = false;
  static Timer? _debounce;

  static SupabaseClient get _db => Supabase.instance.client;
  static bool get _signedIn => AuthService.isSignedIn;

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  /// Call once after [AppStorage.init].
  static void bind() {
    if (_bound) return;
    _bound = true;
    challengeWho.value = AppStorage.challengePrivacyWho;
    challengeWho.addListener(_onLocalChanged);
    notifyChallengeRequests.addListener(_onLocalChanged);
    notifyMatchInvites.addListener(_onLocalChanged);
    notifyMatchResults.addListener(_onLocalChanged);
  }

  static void _onLocalChanged() {
    if (_applyingRemote) return;
    // Always mirror to local prefs.
    unawaited(AppStorage.setChallengePrivacyWho(challengeWho.value));
    unawaited(AppStorage.save());
    if (!_signedIn) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(push());
    });
  }

  static void _apply({
    required int who,
    required bool challengeReq,
    required bool matchInvites,
    required bool matchResults,
  }) {
    _applyingRemote = true;
    challengeWho.value = who.clamp(0, 2);
    notifyChallengeRequests.value = challengeReq;
    notifyMatchInvites.value = matchInvites;
    notifyMatchResults.value = matchResults;
    _applyingRemote = false;
    unawaited(AppStorage.setChallengePrivacyWho(challengeWho.value));
    unawaited(AppStorage.save());
  }

  /// Pull from Supabase when signed in; otherwise keep local cache.
  static Future<void> refresh() async {
    if (!_signedIn) {
      challengeWho.value = AppStorage.challengePrivacyWho;
      error.value = null;
      return;
    }
    try {
      final raw = await _db.rpc('get_my_privacy_prefs');
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Could not load privacy prefs'}';
        return;
      }
      _apply(
        who: (map['challenge_who'] as num?)?.toInt() ?? 0,
        challengeReq: map['notify_challenge_requests'] == true,
        matchInvites: map['notify_match_invites'] == true,
        matchResults: map['notify_match_results'] == true,
      );
      error.value = null;
    } catch (e, st) {
      debugPrint('PrivacyPrefsService.refresh: $e\n$st');
      error.value = AuthService.messageFromError(e);
    }
  }

  /// Push current notifiers to Supabase.
  static Future<bool> push() async {
    if (!_signedIn) return false;
    saving.value = true;
    error.value = null;
    try {
      final raw = await _db.rpc('update_my_privacy_prefs', params: {
        'p_challenge_who': challengeWho.value.clamp(0, 2),
        'p_notify_challenge_requests': notifyChallengeRequests.value,
        'p_notify_match_invites': notifyMatchInvites.value,
        'p_notify_match_results': notifyMatchResults.value,
      });
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Could not save privacy prefs'}';
        return false;
      }
      _apply(
        who: (map['challenge_who'] as num?)?.toInt() ?? challengeWho.value,
        challengeReq: map['notify_challenge_requests'] == true,
        matchInvites: map['notify_match_invites'] == true,
        matchResults: map['notify_match_results'] == true,
      );
      return true;
    } catch (e, st) {
      debugPrint('PrivacyPrefsService.push: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return false;
    } finally {
      saving.value = false;
    }
  }

  static Future<void> setChallengeWho(int who) async {
    challengeWho.value = who.clamp(0, 2);
    // Listener debounces push when signed in.
  }
}
