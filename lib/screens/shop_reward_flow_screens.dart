import 'dart:async';

import 'package:flutter/material.dart';
import '../config/admob_config.dart';
import '../l10n/app_localizations.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/ad_reward_service.dart';
import '../services/rewarded_ad_service.dart';
import '../services/storage.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 36–45 rewarded video shop / wallet Free Coins flow (AdMob).

Future<void> startShopRewardFlow(BuildContext context) async {
  final used = AppStorage.freeVideosUsedToday;
  if (used >= 5) {
    await Navigator.pushNamed(context, '/shop-daily-limit');
    return;
  }
  final go = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(12),
      child: PdfModalCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CurrencyMark(size: 48),
            const SizedBox(height: 10),
            Text(context.l10n.watchShortVideo,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Text(context.l10n.plusCoins(
                    AppLocaleService.formatCoinAmount(AdMobConfig.freeCoinsReward)),
                style: const TextStyle(
                    color: C.teal, fontWeight: FontWeight.w800, fontSize: 22)),
            const SizedBox(height: 8),
            Text(
              context.l10n.videoLength,
              textAlign: TextAlign.center,
              style: const TextStyle(color: C.muted, height: 1.35),
            ),
            const SizedBox(height: 16),
            PdfPinkButton(ctx.l10n.watchNowCaps,
                onTap: () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  await Navigator.pushNamed(context, '/shop-ad-loading');
}

/// Credits Free Coins for one completed rewarded ad ([receipt]).
/// Each receipt pays at most once; no receipt → no coins.
Future<AdRewardStatus> grantFreeCoinsReward(AdReceipt receipt) async {
  final status = await AdRewardService.credit(
    receipt,
    amount: AdMobConfig.freeCoinsReward,
    reason: 'ad_reward',
    refType: 'rewarded_ad',
    refId: AdMobConfig.rewardedUnitId,
  );
  if (status == AdRewardStatus.credited) {
    SfxService.play(Sfx.rewardClaim);
    await AppStorage.incrementFreeVideosUsed();
  }
  return status;
}

class ShopAdLoadingScreen extends StatefulWidget {
  const ShopAdLoadingScreen({super.key});
  @override
  State<ShopAdLoadingScreen> createState() => _ShopAdLoadingScreenState();
}

class _ShopAdLoadingScreenState extends State<ShopAdLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    if (AppStorage.freeVideosUsedToday >= 5) {
      await Navigator.pushReplacementNamed(context, '/shop-daily-limit');
      return;
    }
    final outcome = await RewardedAdService.instance.show();
    if (!mounted) return;
    if (outcome.earned) {
      // Only a completed ad carries a receipt → only then can coins be paid.
      await Navigator.pushReplacementNamed(context, '/shop-ad-verifying',
          arguments: outcome.receipt);
      return;
    }
    if (outcome.result == RewardedAdResult.dismissed) {
      SfxService.play(Sfx.error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.watchFullVideo)));
      Navigator.pop(context);
      return;
    }
    await Navigator.pushReplacementNamed(context, '/shop-no-video');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.shop),
          const Spacer(),
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: C.magenta, strokeWidth: 4),
          ),
          const SizedBox(height: 18),
          Text(context.l10n.gettingVideo,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 6),
          Text(context.l10n.takesFewSeconds, style: const TextStyle(color: C.muted)),
          const Spacer(),
        ],
      ),
    );
  }
}

class ShopAdPlayerScreen extends StatefulWidget {
  const ShopAdPlayerScreen({super.key});
  @override
  State<ShopAdPlayerScreen> createState() => _ShopAdPlayerScreenState();
}

class _ShopAdPlayerScreenState extends State<ShopAdPlayerScreen> {
  int left = 15;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (left <= 1) {
        t?.cancel();
        Navigator.pushReplacementNamed(context, '/shop-ad-loading');
        return;
      }
      setState(() => left--);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  Future<void> _closeAttempt() async {
    final keep = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: PdfModalCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.leaveVideoQuestion,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                context.l10n.loseCoinsIfClose('$left'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.muted, height: 1.35),
              ),
              const SizedBox(height: 18),
              PdfPinkButton(context.l10n.keepWatchingCaps,
                  onTap: () => Navigator.pop(ctx, true)),
              const SizedBox(height: 10),
              PdfGhostButton(context.l10n.closeAndLose,
                  onTap: () => Navigator.pop(ctx, false)),
            ],
          ),
        ),
      ),
    );
    if (keep == false && mounted) {
      t?.cancel();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1 - (left / 15);
    return AppScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text('AD',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text.rich(
                        // Translated sentence; the countdown stays teal
                        // wherever the language puts it.
                        TextSpan(children: [
                          for (final (i, part) in context.l10n
                              .rewardIn('\u0000')
                              .split('\u0000')
                              .indexed) ...[
                            if (i > 0)
                              TextSpan(
                                text: '${left}s',
                                style: const TextStyle(
                                    color: C.teal,
                                    fontWeight: FontWeight.w800),
                              ),
                            TextSpan(text: part),
                          ],
                        ]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _closeAttempt,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: C.border2, style: BorderStyle.solid, width: 1.4),
                ),
                child: Text(
                  context.l10n.advertiserVideo,
                  style: const TextStyle(color: C.muted),
                ),
              ),
            ),
          ),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 4,
            backgroundColor: C.surface2,
            color: C.magenta,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: C.surface,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: C.surface2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.advertiserApp,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(context.l10n.sponsored,
                          style: const TextStyle(color: C.muted, fontSize: 12)),
                    ],
                  ),
                ),
                PdfTealButton(context.l10n.install,
                    compact: true, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShopAdVerifyingScreen extends StatefulWidget {
  const ShopAdVerifyingScreen({super.key});
  @override
  State<ShopAdVerifyingScreen> createState() => _ShopAdVerifyingScreenState();
}

class _ShopAdVerifyingScreenState extends State<ShopAdVerifyingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _grant());
  }

  Future<void> _grant() async {
    final receipt = ModalRoute.of(context)?.settings.arguments;
    if (receipt is! AdReceipt) {
      // Opened without a completed ad: never pay.
      Navigator.pop(context);
      return;
    }
    final status = await grantFreeCoinsReward(receipt);
    if (!mounted) return;
    switch (status) {
      case AdRewardStatus.credited:
        await Navigator.pushReplacementNamed(context, '/shop-reward-earned');
      case AdRewardStatus.creditFailed:
        await Navigator.pushReplacementNamed(context, '/shop-verify-fail',
            arguments: receipt);
      default:
        Navigator.pop(context); // already paid
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.shop),
          const Spacer(),
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: C.magenta, strokeWidth: 4),
          ),
          const SizedBox(height: 18),
          Text(context.l10n.verifyingReward,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 6),
          Text(context.l10n.confirmingVideo, style: const TextStyle(color: C.muted)),
          const Spacer(),
        ],
      ),
    );
  }
}

class ShopRewardEarnedScreen extends StatelessWidget {
  const ShopRewardEarnedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final used = AppStorage.freeVideosUsedToday;
    final left = (5 - used).clamp(0, 5);
    final bal = coins.value;
    return AppScaffold(
      child: Column(
        children: [
          const Spacer(),
            const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CurrencyMark(size: 36),
              SizedBox(width: 8),
              CurrencyMark(size: 64),
              SizedBox(width: 8),
              CurrencyMark(size: 36),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.rewardEarnedCaps,
            style: const TextStyle(
              color: C.teal,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 13,
            ),
          ),
          Text(AppLocaleService.formatCoinAmount(AdMobConfig.freeCoinsReward),
              style: const TextStyle(
                  fontSize: 44, fontWeight: FontWeight.w900, color: C.coin)),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '${context.l10n.balanceArrow(AppLocaleService.formatCoinAmount(bal - 10))} ',
                style: const TextStyle(color: C.muted)),
            TextSpan(
                text: AppLocaleService.formatCoinAmount(bal),
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ])),
          const SizedBox(height: 18),
          AppCard(
            child: Row(
              children: [
                Text(context.l10n.freeVideosToday,
                    style: const TextStyle(color: C.muted)),
                const Spacer(),
                Text(context.l10n.nOf5('$used'),
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Spacer(),
          if (left > 0)
            PdfPinkButton(context.l10n.watchAnotherLeft('$left'), onTap: () {
              Navigator.pushReplacementNamed(context, '/shop');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) startShopRewardFlow(context);
              });
            }),
          const SizedBox(height: 10),
          PdfGhostButton(context.l10n.done,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/shop', (r) => false)),
        ],
      ),
    );
  }
}

class ShopDailyLimitScreen extends StatelessWidget {
  const ShopDailyLimitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.shop),
          const Spacer(),
          PdfModalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.dailyLimit,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: C.coin,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Text(context.l10n.fiveOfFiveWatched,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                Text(context.l10n.newVideosUnlockIn,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: C.muted)),
                const SizedBox(height: 8),
                const Text('06:42:10',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: C.teal)),
                const SizedBox(height: 18),
                PdfPinkButton(
                    context.l10n
                        .coinPacksFrom(AppLocaleService.lowestShopPackLabel()),
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/shop', (r) => false)),
                const SizedBox(height: 10),
                PdfGhostButton(context.l10n.close,
                    onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ShopNoVideoScreen extends StatelessWidget {
  const ShopNoVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.shop),
          const Spacer(),
          PdfModalCard(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: C.border2, width: 2),
                  ),
                  child: const Text('?',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: C.muted)),
                ),
                const SizedBox(height: 14),
                Text(context.l10n.noVideoRightNow,
                    style:
                        const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  context.l10n.noVideoFound,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.muted, height: 1.4),
                ),
                const SizedBox(height: 18),
                PdfPinkButton(context.l10n.tryAgainCaps,
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/shop-ad-loading')),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ShopVerifyFailScreen extends StatelessWidget {
  const ShopVerifyFailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.shop),
          const Spacer(),
          PdfModalCard(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: C.magenta, width: 2),
                  ),
                  child: const Text('!',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: C.magenta)),
                ),
                const SizedBox(height: 14),
                Text(context.l10n.couldNotVerify,
                    style:
                        const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                Text(
                  context.l10n.verifyFailBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.muted, height: 1.4),
                ),
                const SizedBox(height: 18),
                // Retries the SAME completed ad (same receipt), so it can
                // only ever pay once. Without a receipt there is nothing
                // to verify.
                PdfPinkButton(context.l10n.checkAgainCaps, onTap: () {
                  final receipt = ModalRoute.of(context)?.settings.arguments;
                  if (receipt is AdReceipt) {
                    Navigator.pushReplacementNamed(
                        context, '/shop-ad-verifying',
                        arguments: receipt);
                  } else {
                    Navigator.pop(context);
                  }
                }),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// PDF page 45 — reward flow overview.
class RewardFlowOverviewScreen extends StatelessWidget {
  const RewardFlowOverviewScreen({super.key});

  static const steps = [
    ('Player taps Watch video', 'Only entry point for ads'),
    ('Daily limit check', 'Server checks videos used today'),
    (
      'Ad auction',
      'Bidding networks compete, highest eCPM wins. Others run as a waterfall.'
    ),
    ('Video plays', 'Reward unlocks only after full view'),
    ('Server-side verification', 'AdMob confirms the view to your server'),
    ('Wallet credit', 'Supabase credits once per unique ad transaction'),
    (
      'Duplicates blocked',
      'A repeated claim returns the same result, no extra coins'
    ),
    ('App updates balance', 'Player sees +10 coins'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Reward flow'),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (i == 0 || i == 5) ? C.magenta : C.surface2,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(steps[i].$1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(steps[i].$2,
                            style:
                                const TextStyle(color: C.muted, height: 1.35)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
