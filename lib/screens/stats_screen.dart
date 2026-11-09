import 'dart:math';
import 'package:flutter/material.dart';
import '../models.dart';
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

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

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
        builder: (_, __, ___) {
          final s = playerStats;
          final form = s.recentForm;
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
                          painter: _RingPainter(s.winRate)),
                      Text('${(s.winRate * 100).round()}%',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w800)),
                    ])),
              ])),
              Row(children: [
                _stat('${s.played}', 'Played'),
                _stat('${s.wins}', 'Wins'),
                _stat('${s.losses}', 'Losses'),
              ]),
              Row(children: [
                _stat('${s.draws}', 'Draws'),
                _stat('${s.bestStreak}', 'Best streak'),
                _stat('${s.coinsWon}', 'Coins won'),
              ]),
              AppCard(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text('By board',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _bar('3×3', s.rateFor(3)),
                    const SizedBox(height: 12),
                    _bar('4×4', s.rateFor(4)),
                    const SizedBox(height: 12),
                    _bar('5×5', s.rateFor(5)),
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
                                      color: w ? Colors.white : C.muted))),
                      ]),
                  ])),
            ]),
          );
        },
      ),
    );
  }
}
