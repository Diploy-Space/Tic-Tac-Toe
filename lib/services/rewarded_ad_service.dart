import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../config/admob_config.dart';

enum RewardedAdResult { earned, dismissed, failed }

/// Proof that one rewarded ad was watched to the end. Created only inside
/// AdMob's `onUserEarnedReward`, so coins can never be granted without it.
/// [AdRewardService] credits a receipt at most once.
class AdReceipt {
  AdReceipt._(this.id);
  final String id;

  /// Tests only: a receipt without a real ad.
  @visibleForTesting
  factory AdReceipt.forTest(String id) => AdReceipt._(id);
}

/// Outcome of [RewardedAdService.show]; [receipt] is set only when earned.
class AdShowOutcome {
  const AdShowOutcome(this.result, [this.receipt]);
  final RewardedAdResult result;
  final AdReceipt? receipt;
  bool get earned => result == RewardedAdResult.earned && receipt != null;
}

/// Loads and shows AdMob rewarded ads.
///
/// - Keeps one ad preloaded and reloads right after each show.
/// - Concurrent callers share one in-flight load (no "already loading → fail").
/// - Failed loads retry with backoff; ads older than 55 min are replaced
///   (AdMob expires them after an hour).
/// - Only one ad can be on screen at a time.
class RewardedAdService {
  RewardedAdService._();
  static final RewardedAdService instance = RewardedAdService._();

  static const _maxAdAge = Duration(minutes: 55);
  static const _loadTimeout = Duration(seconds: 20);

  bool _initialized = false;
  Future<void>? _initFuture;
  RewardedAd? _ad;
  DateTime? _loadedAt;
  Future<bool>? _loading;
  bool _showing = false;
  int _failedLoads = 0;
  Timer? _retry;
  final _rnd = Random.secure();

  bool get isShowing => _showing;
  bool get hasAdReady => _ad != null && !_isExpired;
  bool get _isExpired =>
      _loadedAt != null && DateTime.now().difference(_loadedAt!) > _maxAdAge;

  Future<void> init() => _initFuture ??= _init();

  Future<void> _init() async {
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      unawaited(preload());
    } catch (e, st) {
      _initFuture = null; // allow another attempt later
      debugPrint('RewardedAdService.init: $e\n$st');
    }
  }

  /// Ensures an ad is loaded. Returns true when one is ready.
  Future<bool> preload() {
    if (!_initialized) return Future.value(false);
    if (_ad != null && !_isExpired) return Future.value(true);
    if (_ad != null && _isExpired) {
      _ad!.dispose();
      _ad = null;
    }
    return _loading ??= _load().whenComplete(() => _loading = null);
  }

  Future<bool> _load() {
    final done = Completer<bool>();
    RewardedAd.load(
      adUnitId: AdMobConfig.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadedAt = DateTime.now();
          _failedLoads = 0;
          if (!done.isCompleted) done.complete(true);
        },
        onAdFailedToLoad: (err) {
          debugPrint('RewardedAd load failed: $err');
          _ad = null;
          _scheduleRetry();
          if (!done.isCompleted) done.complete(false);
        },
      ),
    );
    return done.future.timeout(_loadTimeout, onTimeout: () => _ad != null);
  }

  /// Background retry: 5s, 10s, 20s … up to 2 min.
  void _scheduleRetry() {
    _failedLoads++;
    _retry?.cancel();
    final secs = min(120, 5 * pow(2, _failedLoads - 1).toInt());
    _retry = Timer(Duration(seconds: secs), () => unawaited(preload()));
  }

  /// Shows a rewarded ad. The outcome carries an [AdReceipt] only when AdMob
  /// confirmed the user earned the reward (watched to the end).
  Future<AdShowOutcome> show() async {
    if (_showing) return const AdShowOutcome(RewardedAdResult.failed);
    await init();
    if (!await preload()) return const AdShowOutcome(RewardedAdResult.failed);
    final ad = _ad;
    if (ad == null) return const AdShowOutcome(RewardedAdResult.failed);
    _ad = null;
    _showing = true;

    final completer = Completer<AdShowOutcome>();
    AdReceipt? receipt;

    void finish(RewardedAdResult r) {
      _showing = false;
      unawaited(preload()); // next ad ready for the next claim
      if (!completer.isCompleted) {
        completer.complete(receipt != null
            ? AdShowOutcome(RewardedAdResult.earned, receipt)
            : AdShowOutcome(r));
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        finish(RewardedAdResult.dismissed);
      },
      onAdFailedToShowFullScreenContent: (a, err) {
        debugPrint('RewardedAd show failed: $err');
        a.dispose();
        finish(RewardedAdResult.failed);
      },
    );

    try {
      await ad.show(onUserEarnedReward: (_, __) {
        receipt ??= AdReceipt._(
            '${DateTime.now().microsecondsSinceEpoch}_${_rnd.nextInt(1 << 32)}');
      });
    } catch (e) {
      debugPrint('RewardedAd show threw: $e');
      ad.dispose();
      finish(RewardedAdResult.failed);
    }

    return completer.future.timeout(const Duration(minutes: 5), onTimeout: () {
      _showing = false;
      return receipt != null
          ? AdShowOutcome(RewardedAdResult.earned, receipt)
          : const AdShowOutcome(RewardedAdResult.failed);
    });
  }
}
