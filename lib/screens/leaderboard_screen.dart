import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  static const _rows = [
    ['Riya Bhatti', '458'],
    ['Jignesh M.', '424'],
    ['Hetal Gohil', '277'],
    ['Jignesh G', '166'],
    ['Harish', '129'],
    ['Rashmi', '125'],
    ['Player 7', '118'],
    ['Player 8', '100'],
  ];
  static const _medal = [Color(0xFFFFC24D), Color(0xFFC9CCE0), Color(0xFFE0915A)];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) {
          final s = playerStats;
          final rank = s.rankEstimate == 0 ? '–' : '#${s.rankEstimate}';
          return SingleChildScrollView(
            child: staggered([
              const TopBar('Leaderboard'),
              UserCard(showCoins: false, stats: [
                MapEntry('Rank', rank),
                MapEntry('Score', '${s.score}'),
                MapEntry('Played', '${s.played}'),
                MapEntry('Wins', '${s.wins}'),
              ]),
              for (var i = 0; i < _rows.length; i++) _row(i),
            ], gap: 10),
          );
        },
      ),
    );
  }

  Widget _row(int i) {
    final name = _rows[i][0];
    return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          SizedBox(
              width: 34,
              child: i < 3
                  ? Container(
                      height: 34,
                      alignment: Alignment.center,
                      decoration:
                          BoxDecoration(color: _medal[i], shape: BoxShape.circle),
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              color: C.bg, fontWeight: FontWeight.w800)))
                  : Text('${i + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: C.muted, fontWeight: FontWeight.w700))),
          const SizedBox(width: 12),
          CircleAvatar(
              radius: 17,
              backgroundColor: C.surface2,
              child: Text(name[0],
                  style: const TextStyle(fontWeight: FontWeight.w800))),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(_rows[i][1], style: const TextStyle(fontWeight: FontWeight.w800)),
        ]));
  }
}
