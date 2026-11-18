import 'package:flutter/material.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/wallet_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../l10n/app_localizations.dart';
import '../services/rewarded_ad_service.dart';

class DailyRewardScreen extends StatefulWidget {
  const DailyRewardScreen({super.key});
  @override
  State<DailyRewardScreen> createState() => _DailyRewardScreenState();
}

class _DailyRewardScreenState extends State<DailyRewardScreen>
    with SingleTickerProviderStateMixin {
  static const amounts = [10, 20, 30, 40, 50, 75, 150];
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1600))
    ..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    ensureMissionResets();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  int get today => playerStats.dailyRewardDay.clamp(0, 6);
  bool get claimed => playerStats.lastDailyClaimDate == todayKey();

  Widget _tile(int i) {
    final done = i < today || (i == today && claimed);
    final now = i == today && !claimed;
    final color = done
        ? C.teal
        : now
            ? C.magenta
            : C.border;
    return Expanded(
        flex: i == 6 ? 2 : 1,
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, child) => Opacity(
                    opacity: (!done && !now) ? .55 : 1,
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: color),
                            boxShadow: now
                                ? [
                                    BoxShadow(
                                        color: C.magenta.withAlpha(60),
                                        spreadRadius: 7 * _pulse.value)
                                  ]
                                : null),
                        child: child)),
                child: Column(children: [
                  Text(context.l10n.dayN('${i + 1}'),
                      style: const TextStyle(color: C.muted, fontSize: 13)),
                  const SizedBox(height: 8),
                  done
                      ? const Icon(Icons.check, color: C.teal)
                      : const CurrencyMark(size: 24),
                  const SizedBox(height: 8),
                  Text('${amounts[i]}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                ]))));
  }

  bool _claiming = false;

  Future<void> _claim() async {
    if (claimed || _claiming) return;
    setState(() => _claiming = true);
    try {
      await _claimWithAd();
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  /// Daily coins only after a rewarded ad is watched to the end. The wallet
  /// key is fixed per day, so the reward can be paid once a day at most.
  Future<void> _claimWithAd() async {
    final ad = await RewardedAdService.instance.show();
    if (!mounted) return;
    if (!ad.earned) {
      SfxService.play(Sfx.error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ad.result == RewardedAdResult.dismissed
              ? context.l10n.watchFullVideo
              : context.l10n.noVideoNow)));
      return;
    }
    if (claimed) return;
    final amount = amounts[today];
    final ok = await WalletService.credit(
      amount: amount,
      reason: 'daily_reward',
      idempotencyKey: 'daily_${todayKey()}_$today',
      refType: 'daily',
      refId: 'day_$today',
    );
    if (!ok) {
      SfxService.play(Sfx.error);
      return;
    }
    SfxService.play(Sfx.rewardClaim);
    playerStats.lastDailyClaimDate = todayKey();
    playerStats.dailyRewardDay = (today + 1) % 7;
    statsTick.value++;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(children: [
        TopBar(context.l10n.txDailyReward),
        const SizedBox(height: 14),
        AppCard(
            borderColor: C.magenta,
            child: Row(children: [
              const Icon(Icons.local_fire_department_outlined,
                  color: C.magenta, size: 34),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(
                        context.l10n
                            .dayStreak('${claimed ? today : today + 1}'),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18)),
                    Text(context.l10n.missResets,
                        style: const TextStyle(color: C.muted, fontSize: 13)),
                  ])),
            ])),
        const SizedBox(height: 14),
        Row(children: [for (var i = 0; i < 4; i++) _tile(i)]),
        Row(children: [for (var i = 4; i < 7; i++) _tile(i)]),
        const Spacer(),
        SizedBox(
            width: double.infinity,
            child: PrimaryButton(
                claimed
                    ? context.l10n.comeBackTomorrow
                    : context.l10n.claimPlusCoins(
                        AppLocaleService.formatCoinAmount(amounts[today])),
                onTap: claimed || _claiming ? null : _claim)),
      ]),
    );
  }
}
