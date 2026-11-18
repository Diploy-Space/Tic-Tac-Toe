import 'package:flutter/foundation.dart';

import 'rewarded_ad_service.dart';
import 'wallet_service.dart';

/// Result of [AdRewardService.watchAndCredit].
enum AdRewardStatus {
  /// Ad watched to the end and coins credited.
  credited,

  /// User closed the ad before the reward — nothing credited.
  notCompleted,

  /// No ad could be loaded / shown — nothing credited.
  noAd,

  /// Ad was completed but the wallet credit failed; retry with the receipt.
  creditFailed,

  /// This receipt was already credited (duplicate claim blocked).
  alreadyCredited,
}

/// The only way the app grants free / bonus coins: a completed rewarded ad
/// first, then exactly one credit per ad.
///
/// Duplicate protection:
/// - Each completed ad has a unique [AdReceipt]; a receipt is credited once
///   (in-memory guard) and its wallet idempotency key is derived from it, so
///   a retry after a network error can never pay twice (server dedupes).
/// - A claim that is already running blocks a second tap.
class AdRewardService {
  AdRewardService._();

  static final Set<String> _credited = {};
  static final Set<String> _inFlight = {};

  /// Shows a rewarded ad and, only if it was watched to the end, credits
  /// [amount] coins. [onCompleted] runs between ad completion and credit
  /// (e.g. to show a "verifying" state).
  static Future<(AdRewardStatus, AdReceipt?)> watchAndCredit({
    required int amount,
    required String reason,
    required String refType,
    String? refId,
  }) async {
    final outcome = await RewardedAdService.instance.show();
    if (!outcome.earned) {
      return (
        outcome.result == RewardedAdResult.dismissed
            ? AdRewardStatus.notCompleted
            : AdRewardStatus.noAd,
        null,
      );
    }
    final status = await credit(outcome.receipt!,
        amount: amount, reason: reason, refType: refType, refId: refId);
    return (status, outcome.receipt);
  }

  /// Credits one completed ad. Safe to call again with the same receipt
  /// after [AdRewardStatus.creditFailed].
  static Future<AdRewardStatus> credit(
    AdReceipt receipt, {
    required int amount,
    required String reason,
    required String refType,
    String? refId,
  }) async {
    if (_credited.contains(receipt.id)) return AdRewardStatus.alreadyCredited;
    if (!_inFlight.add(receipt.id)) return AdRewardStatus.alreadyCredited;
    try {
      for (var attempt = 0; attempt < 3; attempt++) {
        try {
          final ok = await WalletService.credit(
            amount: amount,
            reason: reason,
            // Same key on every retry → the server can only pay once.
            idempotencyKey: 'adr_${receipt.id}',
            refType: refType,
            refId: refId,
          ).timeout(const Duration(seconds: 10));
          if (ok) {
            _credited.add(receipt.id);
            return AdRewardStatus.credited;
          }
        } catch (e) {
          debugPrint('AdRewardService credit attempt $attempt: $e');
        }
        await Future<void>.delayed(Duration(milliseconds: 600 * (attempt + 1)));
      }
      return AdRewardStatus.creditFailed;
    } finally {
      _inFlight.remove(receipt.id);
    }
  }

  /// True once [receipt] has been paid out.
  static bool isCredited(AdReceipt receipt) => _credited.contains(receipt.id);
}
