import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});
  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  static const entry = 25;
  // TODO: use the real end time of the event from your backend.
  Duration left = const Duration(hours: 2, minutes: 14, seconds: 9);
  bool joined = false;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || left.inSeconds == 0) return;
      setState(() => left -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Widget _box(String v, String l) => Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(children: [
                Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                Text(l, style: const TextStyle(color: C.muted, fontSize: 13)),
              ]))));

  Widget _round(String t, ShapeKind k, int n) => Expanded(
      child: Column(children: [
        Text(t, style: const TextStyle(color: C.muted, fontSize: 13)),
        const SizedBox(height: 8),
        for (var i = 0; i < n; i++)
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ShapeIcon(k, size: 24)),
      ]));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Tournament'),
          AppCard(
              borderColor: C.magenta,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Tag('Live event', color: C.magenta),
                const SizedBox(height: 6),
                const Heading('Weekend Showdown'),
                const SizedBox(height: 12),
                const Text('Ends in', style: TextStyle(color: C.muted, fontSize: 13)),
                const SizedBox(height: 6),
                Row(children: [
                  _box(_two(left.inHours), 'hrs'),
                  _box(_two(left.inMinutes % 60), 'min'),
                  _box(_two(left.inSeconds % 60), 'sec'),
                ]),
              ])),
          Row(children: [
            _box('$entry', 'Entry'),
            _box('2.5K', 'Prize pool'),
            _box('128', 'Players'),
          ]),
          AppCard(
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _round('Round of 8', ShapeKind.square, 4),
            _round('Semi', ShapeKind.triangle, 2),
            _round('Final', ShapeKind.circle, 1),
          ])),
          const Text('Single elimination. 20 seconds per move. A draw replays the round.',
              style: TextStyle(color: C.muted, height: 1.5)),
          PrimaryButton(joined ? 'Joined' : 'Join for $entry coins',
              onTap: joined
                  ? null
                  : () {
                      if (coins.value < entry) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not enough coins')));
                        return;
                      }
                      coins.value -= entry;
                      playerStats.tournamentsJoined++;
                      statsTick.value++;
                      setState(() => joined = true);
                    }),
        ]),
      ),
    );
  }
}
