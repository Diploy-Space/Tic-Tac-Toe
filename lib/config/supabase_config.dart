/// Supabase project credentials (client-side publishable key is safe to ship).
class SupabaseConfig {
  static const url = 'https://gaiyalhrcozftudbmzgb.supabase.co';
  static const publishableKey =
      'sb_publishable_0Z0imimvSzyS82y_7EXp3Q_So1ClCJc';

  /// Deep-link used for OAuth / email redirects on mobile.
  static const redirectScheme = 'tic_tac_game';
  static const redirectUrl = '$redirectScheme://login-callback/';
}
