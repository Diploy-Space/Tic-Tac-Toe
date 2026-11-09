import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models.dart';

class AuthService {
  AuthService._();

  static SupabaseClient get client => Supabase.instance.client;
  static User? get user => client.auth.currentUser;
  static Session? get session => client.auth.currentSession;
  static bool get isSignedIn => session != null;

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

  static Future<void> init() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _syncProfileNotifiers();
    client.auth.onAuthStateChange.listen((data) {
      _syncProfileNotifiers();
    });
  }

  static void _syncProfileNotifiers() {
    authDisplayName.value = displayName;
    authEmail.value = email;
    authSignedIn.value = isSignedIn;
  }

  static String messageFromError(Object e) {
    if (e is AuthException) return e.message;
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
    final res = await client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {'username': username.trim()},
      emailRedirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
    );
    _syncProfileNotifiers();
    return res.session == null;
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: kIsWeb ? null : SupabaseConfig.redirectUrl,
    );
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
    _syncProfileNotifiers();
  }
}
