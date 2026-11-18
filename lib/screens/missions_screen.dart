import 'package:flutter/material.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/progress_sync_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../l10n/app_localizations.dart';
import '../services/rewarded_ad_service.dart';

class _Mission {
  final String id;
  final String title;
  final int Function() current;
  final int total;
  final int reward;
  const _Mission(this.id, this.title, this.current, this.total, this.reward);
  bool get ready => current() >= total;
  bool get claimed => playerStats.claimedMissions.contains(id);
}

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});
  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  int tab = 0;
  bool _claiming = false;

  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) ProgressSyncService.refresh();
  }

  List<_Mission> get daily => [
        _Mission(
            'd_win3', context.l10n.misWin3, () => playerStats.dailyWins, 3, 20),
        _Mission('d_play5', context.l10n.misPlay5, () => playerStats.dailyPlays,
            5, 15),
        _Mission('d_win4', context.l10n.misWin4x4, () => playerStats.dailyWin4,
            1, 30),
        _Mission('d_quick', context.l10n.misQuick, () => playerStats.dailyQuick,
            1, 25),
      ];

  List<_Mission> get weekly => [
        _Mission('w_win15', context.l10n.misWin15, () => playerStats.weeklyWins,
            15, 100),
        _Mission('w_play30', context.l10n.misPlay30,
            () => playerStats.weeklyPlays, 30, 80),
        _Mission('w_tourney', context.l10n.misTourney,
            () => playerStats.tournamentsJoined, 1, 60),
      ];

  Future<void> _claim(_Mission m) async {
    if (_claiming || m.claimed || !m.ready) return;
    setState(() => _claiming = true);
    try {
      // Mission coins only after a rewarded ad is watched to the end.
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
      // One claim per mission per period (claimedMissions + server).
      await ProgressSyncService.claimMission(missionId: m.id, reward: m.reward);
      if (!mounted) return;
      SfxService.play(Sfx.rewardClaim);
      final cloudSaved =
          AuthService.isSignedIn && ConnectivityService.instance.isOnline;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(cloudSaved
              ? context.l10n.coinsSavedCloud(
                  AppLocaleService.formatCoinAmount(m.reward))
              : context.l10n.plusCoins(
                  AppLocaleService.formatCoinAmount(m.reward)))));
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      SfxService.play(Sfx.error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.messageFromError(e))));
    } finally {
      if (mounted) setState(() => _claiming = false);
    }
  }

  Widget _card(_Mission m) {
    final cur = m.current().clamp(0, m.total);
    Widget right;
    if (m.claimed) {
      right = Tag(context.l10n.done);
    } else if (m.ready) {
      right = SmallButton(context.l10n.claimLabel,
          onTap: _claiming ? null : () => _claim(m));
    } else {
      right = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: C.border2)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const CurrencyMark(size: 16),
            const SizedBox(width: 4),
            Text('${m.reward}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ]));
    }
    return AppCard(
        child: Column(children: [
      Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text('$cur/${m.total}',
              style: const TextStyle(color: C.muted, fontSize: 13)),
        ])),
        right,
      ]),
      const SizedBox(height: 10),
      AppProgress(cur / m.total, color: m.ready ? C.teal : C.magenta),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    ensureMissionResets();
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) => ValueListenableBuilder<int>(
          valueListenable: ProgressSyncService.tick,
          builder: (_, ___, ____) {
            final list = tab == 0 ? daily : weekly;
            final done = list.where((m) => m.claimed).length;
            return SingleChildScrollView(
              child: staggered([
                TopBar(context.l10n.missions),
                if (AuthService.isSignedIn)
                  Text(context.l10n.claimsSync,
                      style: const TextStyle(color: C.muted, fontSize: 13)),
                SegRow(
                    options: [context.l10n.daily, context.l10n.weekly],
                    selected: tab,
                    onChanged: (i) => setState(() => tab = i)),
                AppCard(
                    borderColor: C.magenta,
                    child: Row(children: [
                      const IconCircle(Icons.card_giftcard, size: 52),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                                tab == 0
                                    ? context.l10n.dailyChest
                                    : context.l10n.weeklyChest,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            Text(
                                context.l10n
                                    .missionsDone('$done', '${list.length}'),
                                style: const TextStyle(
                                    color: C.muted, fontSize: 13)),
                            const SizedBox(height: 8),
                            AppProgress(done / list.length),
                          ])),
                    ])),
                for (final m in list) _card(m),
              ]),
            );
          },
        ),
      ),
    );
  }
}
