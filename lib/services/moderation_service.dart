import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/moderation_models.dart';
import 'auth_service.dart';

/// Reports, suspension status, appeals (ValueNotifier — no GetX).
class ModerationService {
  ModerationService._();

  static SupabaseClient get _db => Supabase.instance.client;
  static const evidenceBucket = 'report-evidence';
  static const maxScreenshotBytes = 2 * 1024 * 1024;
  static final _picker = ImagePicker();

  static final ValueNotifier<ModerationStatus?> status =
      ValueNotifier<ModerationStatus?>(null);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);

  static RealtimeChannel? _profileChannel;
  static String? _watchedUid;
  static bool _forceSigningOut = false;

  /// Called when remote suspension is detected while a session is active.
  static VoidCallback? onForceSuspended;

  static void clear() {
    status.value = null;
    loading.value = false;
    error.value = null;
    _unsubscribeProfile();
  }

  static Future<ModerationStatus?> refresh() async {
    final uid = AuthService.user?.id;
    if (uid == null) {
      clear();
      return null;
    }
    loading.value = true;
    error.value = null;
    try {
      final raw = await _db.rpc('get_my_moderation_status');
      final map = _asMap(raw);
      if (map == null) {
        error.value = 'Could not verify account status';
        status.value = null;
        return null;
      }
      if ('${map['status']}' == 'error') {
        error.value = '${map['message'] ?? 'Moderation check failed'}';
        status.value = null;
        return null;
      }
      final s = ModerationStatus.fromJson(map);
      status.value = s;
      _subscribeOwnProfile(uid);
      return s;
    } catch (e, st) {
      debugPrint('ModerationService.refresh: $e\n$st');
      error.value = AuthService.messageFromError(e);
      status.value = null;
      return null;
    } finally {
      loading.value = false;
    }
  }

  /// Fail-closed for gameplay: null / unknown / blocked → not allowed.
  static bool get canAccessGameplay {
    final s = status.value;
    if (s == null) return false;
    return s.accountStatus == AccountStatus.active;
  }

  static String? gameplayBlockReason() {
    final s = status.value;
    if (s == null) {
      return error.value ?? 'Account status unavailable. Try again.';
    }
    if (s.accountStatus == AccountStatus.suspended) {
      return 'Your account is suspended.';
    }
    if (s.accountStatus == AccountStatus.underReview) {
      return 'Your appeal is under review.';
    }
    if (s.accountStatus == AccountStatus.unknown) {
      return 'Account status unknown. Try again.';
    }
    return null;
  }

  static void _subscribeOwnProfile(String uid) {
    if (_watchedUid == uid && _profileChannel != null) return;
    _unsubscribeProfile();
    _watchedUid = uid;
    _profileChannel = _db.channel('moderation-profile-$uid');
    _profileChannel!.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'profiles',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: uid,
      ),
      callback: (payload) {
        final row = payload.newRecord;
        if (row.isEmpty) return;
        final next = AccountStatus.parse('${row['account_status']}');
        final current = status.value;
        status.value = ModerationStatus(
          accountStatus: next,
          suspensionReason: row['suspension_reason'] as String? ??
              current?.suspensionReason,
          suspendedAt: DateTime.tryParse('${row['suspended_at'] ?? ''}') ??
              current?.suspendedAt,
          suspensionId: current?.suspensionId,
          appealId: current?.appealId,
          appealStatus: current?.appealStatus,
          appealSubmittedAt: current?.appealSubmittedAt,
        );
        if (next == AccountStatus.suspended) {
          _handleRemoteSuspension();
        } else if (next == AccountStatus.active ||
            next == AccountStatus.underReview) {
          // Soft refresh for appeal fields.
          refresh();
        }
      },
    );
    _profileChannel!.subscribe();
  }

  static void _unsubscribeProfile() {
    try {
      _profileChannel?.unsubscribe();
    } catch (_) {}
    _profileChannel = null;
    _watchedUid = null;
  }

  static Future<void> _handleRemoteSuspension() async {
    if (_forceSigningOut) return;
    _forceSigningOut = true;
    try {
      onForceSuspended?.call();
      await AuthService.signOut();
    } catch (e) {
      debugPrint('force suspend signOut: $e');
    } finally {
      _forceSigningOut = false;
    }
  }

  static Future<Uint8List?> pickScreenshot() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    if (bytes.length > maxScreenshotBytes) {
      throw Exception('Screenshot must be under 2 MB');
    }
    return bytes;
  }

  static String _contentType(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    return 'image/jpeg';
  }

  static Future<String> uploadEvidence(Uint8List bytes) async {
    final uid = AuthService.user?.id;
    if (uid == null) throw Exception('Not signed in');
    if (bytes.length > maxScreenshotBytes) {
      throw Exception('Screenshot must be under 2 MB');
    }
    final ext = _contentType(bytes) == 'image/png' ? 'png' : 'jpg';
    final path =
        '$uid/${DateTime.now().millisecondsSinceEpoch}_report.$ext';
    await _db.storage.from(evidenceBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: false,
            contentType: _contentType(bytes),
            cacheControl: '3600',
          ),
        );
    return path;
  }

  static Future<String?> submitReport({
    required String roomId,
    required String reasonCode,
    required String description,
    required Uint8List screenshotBytes,
  }) async {
    error.value = null;
    if (!ReportReason.all.any((r) => r.code == reasonCode)) {
      error.value = 'Select a report reason';
      return null;
    }
    if (description.trim().length < 10) {
      error.value = 'Description must be at least 10 characters';
      return null;
    }
    try {
      final path = await uploadEvidence(screenshotBytes);
      final raw = await _db.rpc(
        'submit_game_report',
        params: {
          'p_room_id': roomId,
          'p_reason': reasonCode,
          'p_description': description.trim(),
          'p_screenshot_path': path,
        },
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Report failed'}';
        return null;
      }
      return '${map['report_id']}';
    } catch (e, st) {
      debugPrint('submitReport: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return null;
    }
  }

  static Future<String?> submitAppeal(String message) async {
    error.value = null;
    if (message.trim().length < 20) {
      error.value = 'Appeal must be at least 20 characters';
      return null;
    }
    try {
      final raw = await _db.rpc(
        'submit_suspension_appeal',
        params: {'p_appeal_message': message.trim()},
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Appeal failed'}';
        return null;
      }
      await refresh();
      return '${map['appeal_id']}';
    } catch (e, st) {
      debugPrint('submitAppeal: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return null;
    }
  }

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }
}
