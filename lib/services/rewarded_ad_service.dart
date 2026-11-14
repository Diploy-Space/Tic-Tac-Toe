import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/admob_config.dart';

enum RewardedAdResult { earned, dismissed, failed }

/// Loads and shows AdMob rewarded ads for Free Coins.
class RewardedAdService {
  RewardedAdService._();
  static final RewardedAdService instance = RewardedAdService._();

  bool _initialized = false;
  RewardedAd? _ad;
  bool _loading = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      unawaited(preload());
    } catch (e, st) {
      debugPrint('RewardedAdService.init: $e\n$st');
    }
  }

  Future<void> preload() async {
    if (!_initialized || _loading || _ad != null) return;
    _loading = true;
    final completer = Completer<void>();
    RewardedAd.load(
      adUnitId: AdMobConfig.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (err) {
          debugPrint('RewardedAd load failed: $err');
          _ad = null;
          _loading = false;
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await completer.future.timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        _loading = false;
      },
    );
  }

  /// Shows a rewarded ad. Returns [RewardedAdResult.earned] only when the
  /// user completes the reward callback from AdMob.
  Future<RewardedAdResult> show() async {
    await init();
    if (_ad == null) {
      await preload();
    }
    final ad = _ad;
    if (ad == null) return RewardedAdResult.failed;

    final completer = Completer<RewardedAdResult>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _ad = null;
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete(
            earned ? RewardedAdResult.earned : RewardedAdResult.dismissed,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (a, err) {
        debugPrint('RewardedAd show failed: $err');
        a.dispose();
        _ad = null;
        unawaited(preload());
        if (!completer.isCompleted) {
          completer.complete(RewardedAdResult.failed);
        }
      },
    );

    ad.show(
      onUserEarnedReward: (_, __) {
        earned = true;
      },
    );
    _ad = null;

    return completer.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () =>
          earned ? RewardedAdResult.earned : RewardedAdResult.failed,
    );
  }
}
