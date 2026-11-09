import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/painters.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String duration = 'All';

  List<MatchRecord> _filtered() {
    final now = DateTime.now();
    return playerStats.history.where((m) {
      switch (duration) {
        case 'Today':
          return m.at.year == now.year &&
              m.at.month == now.month &&
              m.at.day == now.day;
        case '7 days':
          return m.at.isAfter(now.subtract(const Duration(days: 7)));
        case '30 days':
          return m.at.isAfter(now.subtract(const Duration(days: 30)));
        default:
          return true;
      }
    }).toList();
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) {
          final list = _filtered();
          return Column(children: [
            const TopBar('History'),
            const SizedBox(height: 14),
            AppCard(
                borderColor: C.magenta,
                child: Column(children: [
                  Row(children: [
                    Container(
                        width: 52,
                        height: 52,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: C.border2)),
                        child: const AvatarFace(size: 50)),
                    const SizedBox(width: 12),
                    const Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Tag('Player 042'),
                          Text('Guest',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ])),
                    const CoinChip(),
                  ]),
                  const SizedBox(height: 12),
                  Container(
                      padding: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                          border:
                              Border(top: BorderSide(color: C.border2))),
                      child: Row(children: [
                        Expanded(
                            child: Column(children: [
                          const Text('Played',
                              style:
                                  TextStyle(color: C.muted, fontSize: 13)),
                          Text('${playerStats.played}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                        ])),
                        Expanded(
                            child: Column(children: [
                          const Text('Duration',
                              style:
                                  TextStyle(color: C.muted, fontSize: 13)),
                          PopupMenuButton<String>(
                              color: C.surface,
                              initialValue: duration,
                              onSelected: (v) =>
                                  setState(() => duration = v),
                              itemBuilder: (_) => [
                                    for (final d in const [
                                      'All',
                                      'Today',
                                      '7 days',
                                      '30 days'
                                    ])
                                      PopupMenuItem(
                                          value: d, child: Text(d)),
                                  ],
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(duration,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: C.teal)),
                                    const Icon(Icons.arrow_drop_down,
                                        color: C.teal),
                                  ])),
                        ])),
                      ])),
                ])),
            const SizedBox(height: 14),
            const AppCard(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Match',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Text('Result',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Text('Date',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ])),
            const SizedBox(height: 14),
            Expanded(
                child: list.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        child: AppCard(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                              ShapeIcon(ShapeKind.circle,
                                  size: 40, color: C.muted),
                              SizedBox(height: 12),
                              Text('No history found',
                                  style: TextStyle(color: C.muted)),
                            ])))
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final m = list[i];
                          final win = m.result == 'Win' || m.result == 'P1 win';
                          return AppCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Row(children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(m.opponent,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                          '${m.size}×${m.size}'
                                          '${m.coinDelta != 0 ? ' · ${m.coinDelta > 0 ? '+' : ''}${m.coinDelta}' : ''}',
                                          style: const TextStyle(
                                              color: C.muted, fontSize: 12)),
                                    ])),
                                Text(m.result,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: win
                                            ? C.teal
                                            : m.result == 'Draw'
                                                ? C.muted
                                                : C.danger)),
                                const SizedBox(width: 12),
                                SizedBox(
                                    width: 72,
                                    child: Text(_fmt(m.at),
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            color: C.muted, fontSize: 12))),
                              ]));
                        })),
          ]);
        },
      ),
    );
  }
}
