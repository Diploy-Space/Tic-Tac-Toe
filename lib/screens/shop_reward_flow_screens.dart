import 'dart:async';

import 'package:flutter/material.dart';
import '../models.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 36–45 rewarded video shop flow (UI; real AdMob later).

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
            const Icon(Icons.monetization_on, color: C.coin, size: 48),
            const SizedBox(height: 10),
            const Text('Watch a short video',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            const Text('+10 coins',
                style: TextStyle(
                    color: C.teal, fontWeight: FontWeight.w800, fontSize: 22)),
            const SizedBox(height: 8),
            const Text(
              'The video is about 15 to 30 seconds. Watch it to the end to get your coins.',
              textAlign: TextAlign.center,
              style: TextStyle(color: C.muted, height: 1.35),
            ),
            const SizedBox(height: 16),
            PdfPinkButton('WATCH NOW', onTap: () => Navigator.pop(ctx, true)),
          ],
        ),
      ),
    ),
  );
  if (go != true || !context.mounted) return;
  await Navigator.pushNamed(context, '/shop-ad-loading');
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
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/shop-ad-player');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          TopBar('Shop'),
          Spacer(),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: C.magenta, strokeWidth: 4),
          ),
          SizedBox(height: 18),
          Text('Getting your video…',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          SizedBox(height: 6),
          Text('This usually takes a few seconds.',
              style: TextStyle(color: C.muted)),
          Spacer(),
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
        Navigator.pushReplacementNamed(context, '/shop-ad-verifying');
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
              const Text('Leave the video?',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 10),
              Text(
                'You will not get your 10 coins if you close it now. $left seconds left.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.muted, height: 1.35),
              ),
              const SizedBox(height: 18),
              PdfPinkButton('KEEP WATCHING',
                  onTap: () => Navigator.pop(ctx, true)),
              const SizedBox(height: 10),
              PdfGhostButton('Close and lose reward',
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
                        TextSpan(children: [
                          const TextSpan(text: 'Reward in '),
                          TextSpan(
                            text: '${left}s',
                            style: const TextStyle(
                                color: C.teal, fontWeight: FontWeight.w800),
                          ),
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
                child: const Text(
                  'Advertiser video plays here',
                  style: TextStyle(color: C.muted),
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Advertiser app',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('Sponsored',
                          style: TextStyle(color: C.muted, fontSize: 12)),
                    ],
                  ),
                ),
                PdfTealButton('Install', compact: true, onTap: () {}),
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
    Future<void>.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await AppStorage.incrementFreeVideosUsed();
      coins.value += 10;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/shop-reward-earned');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      child: Column(
        children: [
          TopBar('Shop'),
          Spacer(),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(color: C.magenta, strokeWidth: 4),
          ),
          SizedBox(height: 18),
          Text('Verifying your reward',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          SizedBox(height: 6),
          Text('Confirming the video was watched. Please wait.',
              style: TextStyle(color: C.muted)),
          Spacer(),
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
              Icon(Icons.monetization_on, color: C.coin, size: 36),
              SizedBox(width: 8),
              Icon(Icons.monetization_on, color: C.coin, size: 64),
              SizedBox(width: 8),
              Icon(Icons.monetization_on, color: C.coin, size: 36),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'REWARD EARNED',
            style: TextStyle(
              color: C.teal,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 13,
            ),
          ),
          const Text('+10',
              style: TextStyle(
                  fontSize: 44, fontWeight: FontWeight.w900, color: C.coin)),
          Text.rich(TextSpan(children: [
            TextSpan(
                text: 'Balance ${bal - 10} → ',
                style: const TextStyle(color: C.muted)),
            TextSpan(
                text: '$bal',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ])),
          const SizedBox(height: 18),
          AppCard(
            child: Row(
              children: [
                const Text('Free videos today',
                    style: TextStyle(color: C.muted)),
                const Spacer(),
                Text('$used of 5',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Spacer(),
          if (left > 0)
            PdfPinkButton('WATCH ANOTHER ($left LEFT)', onTap: () {
              Navigator.pushReplacementNamed(context, '/shop');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) startShopRewardFlow(context);
              });
            }),
          const SizedBox(height: 10),
          PdfGhostButton('Done',
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
          const TopBar('Shop'),
          const Spacer(),
          PdfModalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'DAILY LIMIT REACHED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: C.coin,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                const Text('5 of 5 videos watched',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                const Text('New free videos unlock in',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: C.muted)),
                const SizedBox(height: 8),
                const Text('06:42:10',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: C.teal)),
                const SizedBox(height: 18),
                PdfPinkButton('COIN PACKS FROM ₹29',
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/shop', (r) => false)),
                const SizedBox(height: 10),
                PdfGhostButton('Close', onTap: () => Navigator.pop(context)),
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
          const TopBar('Shop'),
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
                const Text('No video right now',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                const Text(
                  'We could not find a video for you. Your free video was not used. Try again in a minute.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: C.muted, height: 1.4),
                ),
                const SizedBox(height: 18),
                PdfPinkButton('TRY AGAIN',
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
          const TopBar('Shop'),
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
                const Text('We could not verify it',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 8),
                const Text(
                  'This can happen on a weak connection, or if the reward was already claimed. Your coins are safe.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: C.muted, height: 1.4),
                ),
                const SizedBox(height: 18),
                PdfPinkButton('CHECK AGAIN',
                    onTap: () => Navigator.pushReplacementNamed(
                        context, '/shop-ad-verifying')),
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
    ('Ad auction',
        'Bidding networks compete, highest eCPM wins. Others run as a waterfall.'),
    ('Video plays', 'Reward unlocks only after full view'),
    ('Server-side verification', 'AdMob confirms the view to your server'),
    ('Wallet credit', 'Supabase credits once per unique ad transaction'),
    ('Duplicates blocked',
        'A repeated claim returns the same result, no extra coins'),
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
                      color: (i == 0 || i == 5)
                          ? C.magenta
                          : C.surface2,
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
                            style: const TextStyle(
                                color: C.muted, height: 1.35)),
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
