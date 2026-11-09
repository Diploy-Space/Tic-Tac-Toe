import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

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

  List<_Mission> get daily => [
        _Mission('d_win3', 'Win 3 games', () => playerStats.dailyWins, 3, 20),
        _Mission('d_play5', 'Play 5 matches', () => playerStats.dailyPlays, 5, 15),
        _Mission('d_win4', 'Win on a 4×4 board', () => playerStats.dailyWin4, 1, 30),
        _Mission('d_quick', 'Play a random match', () => playerStats.dailyQuick, 1, 25),
      ];

  List<_Mission> get weekly => [
        _Mission('w_win15', 'Win 15 games', () => playerStats.weeklyWins, 15, 100),
        _Mission('w_play30', 'Play 30 matches', () => playerStats.weeklyPlays, 30, 80),
        _Mission('w_tourney', 'Join a tournament', () => playerStats.tournamentsJoined, 1, 60),
      ];

  Widget _card(_Mission m) {
    final cur = m.current().clamp(0, m.total);
    Widget right;
    if (m.claimed) {
      right = const Tag('Done');
    } else if (m.ready) {
      right = SmallButton('Claim', onTap: () {
        coins.value += m.reward;
        playerStats.claimedMissions = {...playerStats.claimedMissions, m.id};
        statsTick.value++;
        setState(() {});
      });
    } else {
      right = Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: C.border2)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.monetization_on_outlined, size: 16, color: C.coin),
            const SizedBox(width: 4),
            Text('${m.reward}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ]));
    }
    return AppCard(
        child: Column(children: [
      Row(children: [
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        builder: (_, __, ___) {
          final list = tab == 0 ? daily : weekly;
          final done = list.where((m) => m.claimed).length;
          return SingleChildScrollView(
            child: staggered([
              const TopBar('Missions'),
              SegRow(
                  options: const ['Daily', 'Weekly'],
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
                          Text(tab == 0 ? 'Daily chest' : 'Weekly chest',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text('$done of ${list.length} missions done',
                              style: const TextStyle(color: C.muted, fontSize: 13)),
                          const SizedBox(height: 8),
                          AppProgress(done / list.length),
                        ])),
                  ])),
              for (final m in list) _card(m),
            ]),
          );
        },
      ),
    );
  }
}
