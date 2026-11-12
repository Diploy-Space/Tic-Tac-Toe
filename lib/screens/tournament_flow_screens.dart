import 'dart:async';

import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 21–28 tournament flow.

class TournamentJoinConfirmScreen extends StatelessWidget {
  const TournamentJoinConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final after = coins.value >= 25 ? coins.value - 25 : coins.value;
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Tournament'),
          const Spacer(),
          PdfModalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Join Weekend Showdown?',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 16),
                Row(children: [
                  const Text('Entry fee', style: TextStyle(color: C.muted)),
                  const Spacer(),
                  const Icon(Icons.diamond, color: C.teal, size: 16),
                  const SizedBox(width: 4),
                  const Text('25',
                      style: TextStyle(
                          color: C.teal, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Text('Balance after',
                      style: TextStyle(color: C.muted)),
                  const Spacer(),
                  Text('${coins.value} → $after',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 14),
                const Text(
                  'Single elimination. If you lose a round you are out, and the entry fee is not returned.',
                  style: TextStyle(color: C.muted, height: 1.4, fontSize: 13),
                ),
                const SizedBox(height: 18),
                PdfPinkButton('CONFIRM & JOIN', onTap: () {
                  if (coins.value < 25) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Not enough coins')),
                    );
                    return;
                  }
                  coins.value -= 25;
                  Navigator.pushReplacementNamed(
                      context, '/tournament-joined');
                }),
                const SizedBox(height: 10),
                PdfGhostButton('Not now',
                    onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TournamentJoinedScreen extends StatefulWidget {
  const TournamentJoinedScreen({super.key});
  @override
  State<TournamentJoinedScreen> createState() => _TournamentJoinedScreenState();
}

class _TournamentJoinedScreenState extends State<TournamentJoinedScreen> {
  bool remind = true;

  Widget _stat(String v, String l) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border),
          ),
          child: Column(children: [
            Text(v,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            Text(l, style: const TextStyle(color: C.muted, fontSize: 12)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Tournament'),
          PdfModalCard(
            borderColor: C.teal,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "YOU'RE IN",
                  style: TextStyle(
                    color: C.teal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'WEEKEND SHOWDOWN',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your first match is set when the round opens.',
                  style: TextStyle(color: C.muted, height: 1.35),
                ),
              ],
            ),
          ),
          Row(children: [
            _stat('25', 'Entry'),
            _stat('2.5K', 'Prize pool'),
            _stat('128', 'Players'),
          ]),
          AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: const BoxDecoration(
                      color: C.teal, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Waiting for the round to open',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text(
                        'Stay in the app. We will alert you when your match is ready.',
                        style: TextStyle(color: C.muted, height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: remind,
              onChanged: (v) => setState(() => remind = v),
              title: const Text('Remind me before my match'),
              activeTrackColor: C.teal,
            ),
          ),
          PdfPinkButton('VIEW BRACKET',
              onTap: () =>
                  Navigator.pushNamed(context, '/tournament-bracket')),
          PdfGhostButton('Back to events',
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/events', (r) => false)),
        ]),
      ),
    );
  }
}

class TournamentBracketScreen extends StatelessWidget {
  const TournamentBracketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Bracket'),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Round of 16 · 8 matches, 4 shown. You are highlighted.',
              style: TextStyle(color: C.muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _col('Round of 16', [
                    _slot('You', 'rahul256', highlight: true),
                    _slot('diployteam', 'anik'),
                    _slot('TBD', 'TBD'),
                    _slot('TBD', 'TBD'),
                  ]),
                  const SizedBox(width: 12),
                  _col('Quarter', [
                    _slot('TBD', 'TBD'),
                    _slot('TBD', 'TBD'),
                  ]),
                  const SizedBox(width: 12),
                  _col('Semi', [_slot('TBD', 'TBD')]),
                  const SizedBox(width: 12),
                  _col('Final', [
                    _slot('Champion', 'TBD', champion: true),
                  ]),
                ],
              ),
            ),
          ),
          AppCard(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your next match',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      Text('Round of 16 · vs rahul256',
                          style: TextStyle(color: C.muted, fontSize: 13)),
                    ],
                  ),
                ),
                const Text('02:00',
                    style: TextStyle(
                        color: C.teal, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PdfPinkButton('GO TO MATCH', onTap: () {
            Navigator.pushNamed(context, '/tournament-ready');
          }),
        ],
      ),
    );
  }

  static Widget _col(String title, List<Widget> kids) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: C.muted, fontSize: 12)),
          const SizedBox(height: 8),
          ...kids.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: w,
              )),
        ],
      );

  static Widget _slot(String a, String b,
          {bool highlight = false, bool champion = false}) =>
      Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: champion
                ? C.coin
                : highlight
                    ? C.magenta
                    : C.border,
            width: highlight || champion ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(a,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: champion ? C.coin : C.text,
                )),
            Text(b, style: const TextStyle(color: C.muted, fontSize: 12)),
          ],
        ),
      );
}

class TournamentReadyScreen extends StatefulWidget {
  const TournamentReadyScreen({super.key});
  @override
  State<TournamentReadyScreen> createState() => _TournamentReadyScreenState();
}

class _TournamentReadyScreenState extends State<TournamentReadyScreen> {
  int left = 60;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (left <= 1) {
        t?.cancel();
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Weekend Showdown'),
          const Spacer(),
          const PdfSectionLabel('Round of 16'),
          const SizedBox(height: 8),
          const Text(
            'YOUR MATCH IS READY',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(children: [
                PdfGradientAvatar('Y', size: 72),
                SizedBox(height: 8),
                Text('You', style: TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const Text('vs',
                  style: TextStyle(color: C.muted, fontWeight: FontWeight.w700)),
              Column(children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: C.teal, width: 2),
                  ),
                  child: const PdfGradientAvatar('R', size: 72),
                ),
                const SizedBox(height: 8),
                const Text('rahul256',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ]),
            ],
          ),
          const SizedBox(height: 28),
          const Text('STARTS IN',
              style: TextStyle(
                  color: C.muted,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
          Text('$left',
              style: const TextStyle(
                  fontSize: 56, fontWeight: FontWeight.w900, color: C.magenta)),
          const Spacer(),
          const Text(
            'If you do not join in time, your opponent advances.',
            textAlign: TextAlign.center,
            style: TextStyle(color: C.muted),
          ),
          const SizedBox(height: 12),
          PdfPinkButton("I'M READY", onTap: () {
            t?.cancel();
            Navigator.pushReplacementNamed(context, '/tournament-match');
          }),
        ],
      ),
    );
  }
}

/// PDF page 25 — tournament in-match chrome.
class TournamentMatchDemoScreen extends StatefulWidget {
  const TournamentMatchDemoScreen({super.key});
  @override
  State<TournamentMatchDemoScreen> createState() =>
      _TournamentMatchDemoScreenState();
}

class _TournamentMatchDemoScreenState extends State<TournamentMatchDemoScreen> {
  int left = 14;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (left <= 1) {
        t?.cancel();
        Navigator.pushReplacementNamed(context, '/tournament-round-result',
            arguments: true);
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

  Widget _mark(String? m) => Container(
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        alignment: Alignment.center,
        child: m == null
            ? null
            : Text(
                m,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: m == 'X' ? C.magenta : C.teal,
                  shadows: [
                    Shadow(
                      color: (m == 'X' ? C.magenta : C.teal)
                          .withValues(alpha: 0.7),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const Row(
            children: [
              Text('ROUND OF 16',
                  style: TextStyle(
                      color: C.magenta,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 12)),
              Spacer(),
              Text('Weekend Showdown',
                  style: TextStyle(color: C.muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const PdfGradientAvatar('Y', size: 44),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You', style: TextStyle(fontWeight: FontWeight.w800)),
                    Text('X', style: TextStyle(color: C.magenta)),
                  ],
                ),
              ),
              PdfCircularTimer(value: left, total: 20, size: 72),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('rahul256',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    Text('O', style: TextStyle(color: C.teal)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const PdfGradientAvatar('R', size: 44),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _mark('X'),
                _mark(null),
                _mark('O'),
                _mark(null),
                _mark('X'),
                _mark(null),
                _mark('O'),
                _mark(null),
                _mark(null),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: C.border),
            ),
            child: const Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Your move',
                    style: TextStyle(
                        color: C.magenta, fontWeight: FontWeight.w800)),
                TextSpan(
                    text: '  ·  20s per move',
                    style: TextStyle(color: C.muted)),
              ]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Run out of time and the move is skipped.',
            style: TextStyle(color: C.muted, fontSize: 13),
          ),
          TextButton(
            onPressed: () {
              t?.cancel();
              Navigator.pushReplacementNamed(context, '/tournament-round-result',
                  arguments: false);
            },
            child: const Text('Preview eliminated',
                style: TextStyle(color: C.muted)),
          ),
        ],
      ),
    );
  }
}

class TournamentRoundResultScreen extends StatelessWidget {
  const TournamentRoundResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final win = (ModalRoute.of(context)?.settings.arguments as bool?) ?? true;
    return AppScaffold(
      child: Column(
        children: [
          const Spacer(),
          Text(
            'ROUND OF 16',
            style: TextStyle(
              color: win ? C.teal : C.magenta,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            win ? 'YOU WIN' : 'ELIMINATED',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: win ? C.teal : C.magenta,
              shadows: [
                Shadow(
                  color: (win ? C.teal : C.magenta).withValues(alpha: 0.7),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            win
                ? 'You advance to the Quarter-final'
                : 'Great run in the Weekend Showdown',
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted),
          ),
          const SizedBox(height: 22),
          PdfModalCard(
            borderColor: win ? C.teal : C.border2,
            child: Column(
              children: [
                if (win) ...[
                  _kv('Next round', 'Quarter-final'),
                  _kv('Opponent', 'Waiting for other matches'),
                  _kv('Players left', '8', last: true),
                ] else ...[
                  _kv('You finished', 'Top 16'),
                  _kv('Rounds won', '3', last: true),
                ],
              ],
            ),
          ),
          const Spacer(),
          PdfPinkButton(
            win ? 'VIEW BRACKET' : 'WATCH THE BRACKET',
            onTap: () => Navigator.pushNamed(context, '/tournament-bracket'),
          ),
          const SizedBox(height: 10),
          PdfGhostButton(
            win ? 'Back to event' : 'Back to events',
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/events', (r) => false),
          ),
          if (win)
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/tournament-champion'),
              child: const Text('Preview champion screen',
                  style: TextStyle(color: C.teal)),
            ),
        ],
      ),
    );
  }

  static Widget _kv(String k, String v, {bool last = false}) => Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 12),
        child: Row(
          children: [
            Text(k, style: const TextStyle(color: C.muted)),
            const Spacer(),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class TournamentChampionScreen extends StatelessWidget {
  const TournamentChampionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'WEEKEND SHOWDOWN',
            style: TextStyle(
              color: C.coin,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'CHAMPION',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: C.coin,
              shadows: [
                Shadow(
                  color: C.coin.withValues(alpha: 0.7),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text('Prize added to your balance',
              style: TextStyle(color: C.muted)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.diamond, color: C.teal, size: 28),
              SizedBox(width: 8),
              Text('+1,250',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: C.teal)),
            ],
          ),
          const SizedBox(height: 28),
          const Align(
            alignment: Alignment.centerLeft,
            child: PdfSectionLabel('Podium'),
          ),
          const SizedBox(height: 8),
          _podium('1', 'You', gold: true),
          _podium('2', 'rahul256'),
          _podium('3', 'anik'),
          const Spacer(),
          PdfPinkButton(
            'BACK TO EVENTS',
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/events', (r) => false),
          ),
        ],
      ),
    );
  }

  static Widget _podium(String rank, String name, {bool gold = false}) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: gold ? C.coin : C.border),
        ),
        child: Row(
          children: [
            Text(rank,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: gold ? C.coin : C.muted,
                  fontSize: 18,
                )),
            const SizedBox(width: 14),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
