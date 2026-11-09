import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// "Finding an opponent" screen with a radar animation.
/// Currently simulates a match after 4 seconds; replace with real matchmaking.
class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});
  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2400))
    ..repeat();
  Timer? _t;
  int _sec = 0;
  GameArgs? _args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args ??= ModalRoute.of(context)?.settings.arguments as GameArgs?;
    _t ??= Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _sec++);
      if (_sec >= 4) {
        t.cancel();
        Navigator.pushReplacementNamed(context, '/game',
            arguments: _args ?? const GameArgs(size: 3));
      }
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  Widget _ring(double phase) => AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final v = (_c.value + phase) % 1.0;
        return Opacity(
            opacity: (1 - v) * .9,
            child: Transform.scale(
                scale: .45 + .55 * v,
                child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: C.magenta, width: 2)))));
      });

  @override
  Widget build(BuildContext context) {
    final stake = _args?.stake ?? 0;
    return AppScaffold(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: C.border2)),
              child: Text('Stake · $stake',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const CoinChip(),
        ]),
        Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: 250,
              height: 250,
              child: Stack(alignment: Alignment.center, children: [
                _ring(0),
                _ring(.33),
                _ring(.66),
                Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.surface,
                        border: Border.all(color: C.magenta, width: 2)),
                    child: const Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: PlayerFace(size: 90))),
              ])),
          const SizedBox(height: 22),
          const Heading('Finding an opponent', size: 24),
          const SizedBox(height: 8),
          Text('Quick match vs AI · 0:${_sec.toString().padLeft(2, '0')}',
              style: const TextStyle(color: C.muted)),
        ])),
        SizedBox(
            width: double.infinity,
            child: GhostButton('Cancel', onTap: () => Navigator.pop(context))),
      ]),
    );
  }
}
