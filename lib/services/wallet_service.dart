import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import 'auth_service.dart';
import 'storage.dart';

class WalletTx {
  final String id;
  final int amountMinor;
  final String direction;
  final String reason;
  final String? refType;
  final String? refId;
  final String currencyCode;
  final int balanceAfter;
  final DateTime createdAt;

  const WalletTx({
    required this.id,
    required this.amountMinor,
    required this.direction,
    required this.reason,
    this.refType,
    this.refId,
    required this.currencyCode,
    required this.balanceAfter,
    required this.createdAt,
  });

  factory WalletTx.fromJson(Map<String, dynamic> j) => WalletTx(
        id: '${j['id']}',
        amountMinor: (j['amount_minor'] as num?)?.toInt() ?? 0,
        direction: '${j['direction']}',
        reason: '${j['reason']}',
        refType: j['ref_type'] as String?,
        refId: j['ref_id']?.toString(),
        currencyCode: '${j['currency_code'] ?? 'COIN'}',
        balanceAfter: (j['balance_after'] as num?)?.toInt() ?? 0,
        createdAt:
            DateTime.tryParse('${j['created_at']}') ?? DateTime.now(),
      );
}

/// Server wallet mirror. Keeps [coins] ValueNotifier in sync when signed in.
class WalletService {
  WalletService._();

  static final ValueNotifier<int?> serverBalance = ValueNotifier<int?>(null);
  static final ValueNotifier<String> currencyCode = ValueNotifier<String>('COIN');
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);
  static final ValueNotifier<List<WalletTx>> transactions =
      ValueNotifier<List<WalletTx>>(const []);

  static SupabaseClient get _db => Supabase.instance.client;
  static bool get _signedIn => _db.auth.currentSession != null;

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static void clear({bool clearTransactions = true}) {
    serverBalance.value = null;
    currencyCode.value = 'COIN';
    error.value = null;
    if (clearTransactions) {
      transactions.value = const [];
    }
  }

  static void _applyBalance(int bal, String code) {
    serverBalance.value = bal;
    currencyCode.value = code;
    coins.value = bal;
  }

  /// Load wallet + one-time local migrate (capped). Falls back to local coins offline.
  static Future<void> refresh({bool migrateLocal = true}) async {
    if (!_signedIn) {
      // Keep any local (guest) ledger rows so Free Coins history still shows.
      clear(clearTransactions: false);
      serverBalance.value = coins.value;
      return;
    }
    loading.value = true;
    error.value = null;
    try {
      if (migrateLocal) {
        await _db.rpc(
          'migrate_local_coins',
          params: {'p_claimed_balance': coins.value},
        );
      }
      final raw = await _db.rpc('get_my_wallet');
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        error.value = '${map?['message'] ?? 'Wallet unavailable'}';
        return;
      }
      _applyBalance(
        (map['balance_minor'] as num?)?.toInt() ?? coins.value,
        '${map['currency_code'] ?? 'COIN'}',
      );
      await AppStorage.save();
    } catch (e, st) {
      debugPrint('WalletService.refresh: $e\n$st');
      error.value = AuthService.messageFromError(e);
    } finally {
      loading.value = false;
    }
  }

  static Future<void> loadTransactions({int limit = 50}) async {
    if (!_signedIn) {
      transactions.value = const [];
      return;
    }
    try {
      final raw = await _db.rpc(
        'list_my_wallet_transactions',
        params: {'p_limit': limit},
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') return;
      final items = map['items'];
      if (items is! List) {
        transactions.value = const [];
        return;
      }
      transactions.value = [
        for (final e in items)
          if (e is Map) WalletTx.fromJson(Map<String, dynamic>.from(e)),
      ];
    } catch (e, st) {
      debugPrint('WalletService.loadTransactions: $e\n$st');
    }
  }

  static Future<bool> debit({
    required int amount,
    required String reason,
    required String idempotencyKey,
    String? refType,
    String? refId,
  }) async {
    if (!_signedIn) {
      if (coins.value < amount) return false;
      coins.value -= amount;
      await AppStorage.save();
      _prependLocalTx(
        amount: amount,
        direction: 'debit',
        reason: reason,
        refType: refType,
        refId: refId,
      );
      return true;
    }
    final raw = await _db.rpc('wallet_debit', params: {
      'p_amount': amount,
      'p_reason': reason,
      'p_idempotency_key': idempotencyKey,
      'p_ref_type': refType,
      'p_ref_id': refId,
    });
    final map = _asMap(raw);
    if (map == null || '${map['status']}' != 'ok') {
      error.value = '${map?['message'] ?? 'Debit failed'}';
      return false;
    }
    _applyBalance(
      (map['balance_minor'] as num?)?.toInt() ?? coins.value,
      '${map['currency_code'] ?? currencyCode.value}',
    );
    await AppStorage.save();
    await loadTransactions(limit: 80);
    return true;
  }

  static Future<bool> credit({
    required int amount,
    required String reason,
    required String idempotencyKey,
    String? refType,
    String? refId,
  }) async {
    if (!_signedIn) {
      coins.value += amount;
      await AppStorage.save();
      _prependLocalTx(
        amount: amount,
        direction: 'credit',
        reason: reason,
        refType: refType,
        refId: refId,
      );
      return true;
    }
    final raw = await _db.rpc('wallet_credit', params: {
      'p_amount': amount,
      'p_reason': reason,
      'p_idempotency_key': idempotencyKey,
      'p_ref_type': refType,
      'p_ref_id': refId,
    });
    final map = _asMap(raw);
    if (map == null || '${map['status']}' != 'ok') {
      error.value = '${map?['message'] ?? 'Credit failed'}';
      return false;
    }
    _applyBalance(
      (map['balance_minor'] as num?)?.toInt() ?? coins.value,
      '${map['currency_code'] ?? currencyCode.value}',
    );
    await AppStorage.save();
    await loadTransactions(limit: 80);
    return true;
  }

  static void _prependLocalTx({
    required int amount,
    required String direction,
    required String reason,
    String? refType,
    String? refId,
  }) {
    final tx = WalletTx(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      amountMinor: amount,
      direction: direction,
      reason: reason,
      refType: refType,
      refId: refId,
      currencyCode: currencyCode.value,
      balanceAfter: coins.value,
      createdAt: DateTime.now(),
    );
    transactions.value = [tx, ...transactions.value];
  }
}
