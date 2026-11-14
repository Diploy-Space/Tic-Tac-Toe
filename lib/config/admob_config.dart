import 'package:flutter/foundation.dart';

/// AdMob IDs for this app.
class AdMobConfig {
  AdMobConfig._();

  static const appId = 'ca-app-pub-1605976200621322~1357025600';

  /// Production rewarded unit (Free Coins / shop video).
  static const rewardedUnitIdProd =
      'ca-app-pub-1605976200621322/5763174474';

  /// Google sample rewarded unit — used in debug to protect the AdMob account.
  static const rewardedUnitIdTest =
      'ca-app-pub-3940256099942544/5224354917';

  static String get rewardedUnitId =>
      kReleaseMode ? rewardedUnitIdProd : rewardedUnitIdTest;

  /// Coins granted after a completed rewarded video.
  static const freeCoinsReward = 10;
}
