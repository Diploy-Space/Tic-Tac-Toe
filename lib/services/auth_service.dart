import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models.dart';
import 'friend_service.dart';
import 'match_sync_service.dart';
import 'moderation_service.dart';
import 'privacy_prefs_service.dart';
import 'profile_service.dart';
import 'progress_sync_service.dart';
import 'wallet_service.dart';

class AuthService {
  AuthService._();

  static SupabaseClient get client => Supabase.instance.client;
  static User? get user => client.auth.currentUser;
  static Session? get session => client.auth.currentSession;
  static bool get isSignedIn => session != null;

  /// True after recovery OTP until the user finishes [updatePassword].
  static bool pendingPasswordReset = false;

  static String get displayName {
    final u = user;
    if (u == null) return 'Guest';
    final meta = u.userMetadata ?? {};
    final name = meta['username'] ?? meta['full_name'] ?? meta['name'];
    if (name is String && name.trim().isNotEmpty) return name.trim();
    final email = u.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'Player';
  }

  static String get email => user?.email ?? '';

  /// Best-effort login provider label for Edit Profile (read-only).
  static String get loginMethodLabel {
    final identities = user?.identities ?? const [];
    for (final i in identities) {
      final p = i.provider.toLowerCase();
      if (p == 'google') return 'Google';
      if (p == 'apple') return 'Apple';
      if (p == 'facebook') return 'Facebook';
      if (p == 'phone') return 'Phone';
    }
    if ((user?.email ?? '').isNotEmpty) return 'Email';
    return 'Account';
  }

  static Future<void> init() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _syncProfileNotifiers();
    if (isSignedIn) {
      // Fire-and-forget; UI listens via ValueNotifiers.
      ProfileService.loadMyProfile(fallbackName: displayName);
      ModerationService.refresh();
      WalletService.refresh();
      PrivacyPrefsService.refresh();
      MatchSyncService.refresh().then((_) async {
        await FriendService.refresh();
        await ProgressSyncService.refresh();
      });
    }
    client.auth.onAuthStateChange.listen((data) async {
      _syncProfileNotifiers();
      switch (data.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
        case AuthChangeEvent.userUpdated:
          await ProfileService.loadMyProfile(fallbackName: displayName);
          await ModerationService.refresh();
          await WalletService.refresh();
          await PrivacyPrefsService.refresh();
          await MatchSyncService.refresh();
          await FriendService.refresh();
          await ProgressSyncService.refresh();
          break;
        case AuthChangeEvent.signedOut:
          ProfileService.clear();
          MatchSyncService.clear();
          FriendService.clear();
          ProgressSyncService.clear();
          ModerationService.clear();
          WalletService.clear();
          _syncProfileNotifiers();
          break;
        default:
          break;
      }
    });
  }

  static void _syncProfileNotifiers() {
    authEmail.value = email;
    authSignedIn.value = isSignedIn;
    if (!isSignedIn) {
      authDisplayName.value = 'Guest';
      authAvatarUrl.value = null;
    } else if (ProfileService.current.value == null) {
      authDisplayName.value = displayName;
    }
  }

  static String messageFromError(Object e) {
    if (e is AuthException) return e.message;
    if (e is PostgrestException) return e.message;
    if (e is StorageException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }

  static bool isEmailNotConfirmed(Object e) {
    if (e is! AuthException) return false;
    final msg = e.message.toLowerCase();
    final code = (e.code ?? '').toLowerCase();
    return code == 'email_not_confirmed' ||
        msg.contains('email not confirmed') ||
        msg.contains('email_not_confirmed');
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final res = await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    _syncProfileNotifiers();
    await ProfileService.loadMyProfile(fallbackName: displayName);
    await ModerationService.refresh();
    await MatchSyncService.refresh();
    return res;
  }

  /// Resend the signup confirmation email (when Confirm email is enabled).
  static Future<void> resendSignupConfirmation(String email) async {
    await client.auth.resend(
      type: OtpType.signup,
      email: email.trim(),
      emailRedirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
    );
  }

  /// Returns true when email confirmation is required (no session yet).
  static Future<bool> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final normalized = ProfileService.normalizeUsername(username);
    final err = ProfileService.validateUsername(normalized);
    if (err != null) throw Exception(err);

    final res = await client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'username': normalized},
      emailRedirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
    );
    _syncProfileNotifiers();
    if (res.session != null) {
      await ProfileService.loadMyProfile(fallbackName: displayName);
      await MatchSyncService.refresh();
    }
    return res.session == null;
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
    );
  }

  /// Verify the 6-digit recovery code from the reset-password email.
  static Future<AuthResponse> verifyRecoveryOtp({
    required String email,
    required String token,
  }) async {
    final res = await client.auth.verifyOTP(
      type: OtpType.recovery,
      email: email.trim(),
      token: token.trim(),
    );
    pendingPasswordReset = true;
    _syncProfileNotifiers();
    return res;
  }

  /// Set a new password after a successful recovery OTP / recovery session.
  static Future<UserResponse> updatePassword(String newPassword) async {
    final res = await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
    pendingPasswordReset = false;
    _syncProfileNotifiers();
    return res;
  }

  static Future<bool> signInWithGoogle() async {
    return client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
    ProfileService.clear();
    MatchSyncService.clear();
    ModerationService.clear();
    _syncProfileNotifiers();
  }
}
