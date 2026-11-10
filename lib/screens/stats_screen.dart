import 'dart:math';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/match_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class _RingPainter extends CustomPainter {
  final double value;
  _RingPainter(this.value);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .1
      ..color = C.border;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .1
      ..strokeCap = StrokeCap.round
      ..color = C.magenta;
    final r = rect.deflate(size.width * .05);
    canvas.drawArc(r, 0, 2 * pi, false, base);
    canvas.drawArc(r, -pi / 2, 2 * pi * value.clamp(0, 1), false, arc);
  }

  @override
  bool shouldRepaint(covariant _RingPainter o) => o.value != value;
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) MatchSyncService.refresh();
  }

  Widget _stat(String v, String l) => Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(children: [
                Text(v,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                Text(l, style: const TextStyle(color: C.muted, fontSize: 13)),
              ]))));

  Widget _bar(String l, double p) => Row(children: [
        SizedBox(
            width: 36,
            child: Text(l, style: const TextStyle(color: C.muted))),
        Expanded(child: AppProgress(p, color: C.teal)),
        SizedBox(
            width: 44,
            child: Text('${(p * 100).round()}%',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w700))),
      ]);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) => ValueListenableBuilder<int>(
          valueListenable: MatchSyncService.tick,
          builder: (_, ___, ____) {
            final local = playerStats;
            final cloud = MatchSyncService.myStats.value;
            final useCloud = AuthService.isSignedIn && cloud != null;
            final played = useCloud ? cloud.played : local.played;
            final wins = useCloud ? cloud.wins : local.wins;
            final losses = useCloud ? cloud.losses : local.losses;
            final draws = useCloud ? cloud.draws : local.draws;
            final winRate = useCloud ? cloud.winRate : local.winRate;
            final bestStreak = useCloud
                ? (MatchSyncService.derivedBestStreak ?? 0)
                : local.bestStreak;
            final rate3 = useCloud
                ? (MatchSyncService.derivedBoardRates[3] ?? 0)
                : local.rateFor(3);
            final rate4 = useCloud
                ? (MatchSyncService.derivedBoardRates[4] ?? 0)
                : local.rateFor(4);
            final rate5 = useCloud
                ? (MatchSyncService.derivedBoardRates[5] ?? 0)
                : local.rateFor(5);
            final form = useCloud
                ? MatchSyncService.derivedRecentForm
                : local.recentForm;
            return SingleChildScrollView(
              child: staggered([
                const TopBar('Stats'),
                AppCard(
                    child: Column(children: [
                  const Tag('Win rate'),
                  const SizedBox(height: 12),
                  SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(alignment: Alignment.center, children: [
                        CustomPaint(
                            size: const Size.square(150),
                            painter: _RingPainter(winRate)),
                        Text('${(winRate * 100).round()}%',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w800)),
                      ])),
                ])),
                Row(children: [
                  _stat('$played', 'Played'),
                  _stat('$wins', 'Wins'),
                  _stat('$losses', 'Losses'),
                ]),
                Row(children: [
                  _stat('$draws', 'Draws'),
                  _stat('$bestStreak', 'Best streak'),
                  _stat(
                      '${useCloud ? cloud.score : local.score}', 'Score'),
                ]),
                AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('By board',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      _bar('3×3', rate3),
                      const SizedBox(height: 12),
                      _bar('4×4', rate4),
                      const SizedBox(height: 12),
                      _bar('5×5', rate5),
                    ])),
                AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('Last 7 games',
                          style: TextStyle(color: C.muted, fontSize: 13)),
                      const SizedBox(height: 10),
                      if (form.isEmpty)
                        const Text('Play a match to build your form.',
                            style: TextStyle(color: C.muted))
                      else
                        Row(children: [
                          for (final w in form)
                            Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: w ? C.magenta : C.surface2),
                                child: Text(w ? 'W' : 'L',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color:
                                            w ? Colors.white : C.muted))),
                        ]),
                    ])),
              ]),
            );
          },
        ),
      ),
    );
  }
}
