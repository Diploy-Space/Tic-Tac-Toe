import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models.dart';
import 'auth_service.dart';
import 'wallet_service.dart';

class ReferralApplyResult {
  final String code;
  final int bonus;
  final int balance;
  const ReferralApplyResult({
    required this.code,
    required this.bonus,
    required this.balance,
  });
}

/// Post-signup referral prompt + welcome bonus.
class ReferralService {
  ReferralService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  /// True when the signed-in user should see the referral screen.
  static Future<bool> shouldShowPrompt() async {
    if (!AuthService.isSignedIn) return false;
    try {
      final raw = await _db.rpc('get_my_referral_status');
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') return false;
      return map['can_apply'] == true;
    } catch (e, st) {
      debugPrint('ReferralService.shouldShowPrompt: $e\n$st');
      return false;
    }
  }

  static Future<void> skip() async {
    if (!AuthService.isSignedIn) return;
    try {
      await _db.rpc('mark_referral_prompt_seen');
    } catch (e, st) {
      debugPrint('ReferralService.skip: $e\n$st');
    }
  }

  static Future<ReferralApplyResult> applyCode(String rawCode) async {
    final code = rawCode.trim().toUpperCase();
    if (code.length < 3) {
      throw Exception('Enter a valid referral code');
    }
    final raw = await _db.rpc('apply_referral_code', params: {'p_code': code});
    final map = _asMap(raw);
    if (map == null || '${map['status']}' != 'ok') {
      throw Exception('${map?['message'] ?? 'Could not apply referral code'}');
    }
    final balance = (map['balance_minor'] as num?)?.toInt() ?? coins.value;
    final bonus = (map['bonus'] as num?)?.toInt() ?? 50;
    final used = '${map['referral_code'] ?? code}';
    // Keep local/server wallet mirrors in sync.
    coins.value = balance;
    WalletService.serverBalance.value = balance;
    await WalletService.loadTransactions(limit: 80);
    return ReferralApplyResult(code: used, bonus: bonus, balance: balance);
  }
}
