import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/ai.dart';
import '../game/board.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF pages 21–28 tournament flow.

class TournamentJoinConfirmScreen extends StatelessWidget {
  const TournamentJoinConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final after = coins.value >= 25 ? coins.value - 25 : coins.value;
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.tournament),
          const Spacer(),
          PdfModalCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(context.l10n.joinTournamentQuestion('Weekend Showdown'),
                    style:
                        const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 16),
                Row(children: [
                  Text(context.l10n.entryFee,
                      style: const TextStyle(color: C.muted)),
                  const Spacer(),
                  const CurrencyMark(size: 16, color: C.teal),
                  const SizedBox(width: 4),
                  Text(AppLocaleService.formatCoinAmount(25),
                      style: TextStyle(
                          color: C.teal, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Text(context.l10n.balanceAfter,
                      style: const TextStyle(color: C.muted)),
                  const Spacer(),
                  Text('${AppLocaleService.formatCoinAmount(coins.value)} → ${AppLocaleService.formatCoinAmount(after)}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 14),
                Text(
                  context.l10n.tSingleElimFee,
                  style: const TextStyle(color: C.muted, height: 1.4, fontSize: 13),
                ),
                const SizedBox(height: 18),
                PdfPinkButton(context.l10n.confirmJoinCaps, onTap: () {
                  if (coins.value < 25) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.notEnoughCoins)),
                    );
                    return;
                  }
                  coins.value -= 25;
                  Navigator.pushReplacementNamed(context, '/tournament-joined');
                }),
                const SizedBox(height: 10),
                PdfGhostButton(context.l10n.notNow,
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
          TopBar(context.l10n.tournament),
          PdfModalCard(
            borderColor: C.teal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.youreInCaps,
                  style: const TextStyle(
                    color: C.teal,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'WEEKEND SHOWDOWN',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.firstMatchSet,
                  style: const TextStyle(color: C.muted, height: 1.35),
                ),
              ],
            ),
          ),
          Row(children: [
            _stat('25', context.l10n.entry),
            _stat('2.5K', context.l10n.prizePool),
            _stat('128', context.l10n.players),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.waitingRoundOpen,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.stayInApp,
                        style: const TextStyle(color: C.muted, height: 1.35),
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
              title: Text(context.l10n.remindMe),
              activeTrackColor: C.teal,
            ),
          ),
          PdfPinkButton(context.l10n.viewBracketCaps,
              onTap: () => Navigator.pushNamed(context, '/tournament-bracket')),
          PdfGhostButton(context.l10n.backToEvents,
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
          TopBar(context.l10n.bracket),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n.bracketInfo,
              style: const TextStyle(color: C.muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _col(context.l10n.roundOf16, [
                    _slot(context.l10n.you, 'rahul256', highlight: true),
                    _slot('diployteam', 'anik'),
                    _slot(context.l10n.tbd, context.l10n.tbd),
                    _slot(context.l10n.tbd, context.l10n.tbd),
                  ]),
                  const SizedBox(width: 12),
                  _col(context.l10n.quarter, [
                    _slot(context.l10n.tbd, context.l10n.tbd),
                    _slot(context.l10n.tbd, context.l10n.tbd),
                  ]),
                  const SizedBox(width: 12),
                  _col(context.l10n.semi,
                      [_slot(context.l10n.tbd, context.l10n.tbd)]),
                  const SizedBox(width: 12),
                  _col(context.l10n.finalRound, [
                    _slot(context.l10n.achChampion, context.l10n.tbd,
                        champion: true),
                  ]),
                ],
              ),
            ),
          ),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.yourNextMatch,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(context.l10n.roundOf16Vs('rahul256'),
                          style: const TextStyle(color: C.muted, fontSize: 13)),
                    ],
                  ),
                ),
                const Text('02:00',
                    style:
                        TextStyle(color: C.teal, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PdfPinkButton(context.l10n.goToMatchCaps, onTap: () {
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
          PdfSectionLabel(context.l10n.roundOf16),
          const SizedBox(height: 8),
          Text(
            context.l10n.yourMatchReadyCaps,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [
                const PdfGradientAvatar('Y', size: 72),
                const SizedBox(height: 8),
                Text(context.l10n.you,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ]),
              const Text('vs',
                  style:
                      TextStyle(color: C.muted, fontWeight: FontWeight.w700)),
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
          Text(context.l10n.startsInCaps,
              style: const TextStyle(
                  color: C.muted,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
          Text('$left',
              style: const TextStyle(
                  fontSize: 56, fontWeight: FontWeight.w900, color: C.magenta)),
          const Spacer(),
          Text(
            context.l10n.opponentAdvances,
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted),
          ),
          const SizedBox(height: 12),
          PdfPinkButton(context.l10n.imReadyCaps, onTap: () {
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
  // You are X (shown magenta), rahul256 is O. Internally the AI engine
  // always plays 'X', so the board stores you as 'O' and the rival as 'X';
  // [_shown] swaps them for display.
  static const _me = 'O';
  static const _rival = 'X';
  static const _turnSeconds = 20;
  static const _rivalName = 'rahul256';

  Board board = Board(3);
  String turn = _me;
  int left = _turnSeconds;
  bool over = false;
  Timer? t;
  int _round = 0; // bumps on draw replays; stale AI moves are ignored

  @override
  void initState() {
    super.initState();
    SfxService.play(Sfx.countdownGo);
    _startClock();
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  void _startClock() {
    t?.cancel();
    left = _turnSeconds;
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || over) return;
      if (left <= 1) {
        _timeUp();
        return;
      }
      setState(() => left--);
      if (left <= 5) SfxService.play(Sfx.countdownTick);
    });
  }

  /// Run out of time and the move is skipped.
  void _timeUp() {
    if (turn != _me) {
      setState(() => left = _turnSeconds);
      return;
    }
    _nextTurn();
  }

  void _tap(int i) {
    if (over || turn != _me || board.cells[i] != null) return;
    _place(i, _me);
  }

  void _place(int i, String mark) {
    if (vibrationOn.value) HapticFeedback.lightImpact();
    SfxService.place(mark == _me ? 'X' : 'O');
    setState(() => board.cells[i] = mark);
    if (board.winsAt(i, mark)) {
      _finish(mark == _me);
      return;
    }
    if (board.isFull) {
      _replayRound();
      return;
    }
    _nextTurn();
  }

  void _nextTurn() {
    setState(() => turn = turn == _me ? _rival : _me);
    _startClock();
    if (turn == _rival) _rivalMove();
  }

  Future<void> _rivalMove() async {
    final round = _round;
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted || over || round != _round) return;
    final pick = await GameAi.chooseMoveAsync(board.clone(), 'Medium');
    if (!mounted || over || round != _round || turn != _rival) return;
    if (pick < 0 || pick >= board.cells.length || board.cells[pick] != null) {
      final empty = board.emptyCells;
      if (empty.isEmpty) return;
      _place(empty.first, _rival);
      return;
    }
    _place(pick, _rival);
  }

  /// A draw replays the round.
  void _replayRound() {
    SfxService.play(Sfx.draw);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.tDrawReplays)));
    setState(() {
      _round++;
      board = Board(3);
      turn = _me;
    });
    _startClock();
  }

  void _finish(bool won) {
    over = true;
    t?.cancel();
    SfxService.play(won ? Sfx.win : Sfx.lose);
    // Let the final board show for a moment.
    Future<void>.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/tournament-round-result',
          arguments: won);
    });
  }

  String? _shown(String? m) => m == null ? null : (m == _me ? 'X' : 'O');

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
          Row(
            children: [
              Flexible(
                child: Text(context.l10n.roundOf16Caps,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: C.magenta,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 12)),
              ),
              const SizedBox(width: 8),
              const Spacer(),
              const Flexible(
                child: Text('Weekend Showdown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: C.muted, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const PdfGradientAvatar('Y', size: 44),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.you,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const Text('X', style: TextStyle(color: C.magenta)),
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
                for (var i = 0; i < 9; i++)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _tap(i),
                    child: _mark(_shown(board.cells[i])),
                  ),
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
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: turn == _me
                        ? context.l10n.yourMove
                        : context.l10n.isThinking(_rivalName),
                    style: TextStyle(
                        color: turn == _me ? C.magenta : C.teal,
                        fontWeight: FontWeight.w800)),
                TextSpan(
                    text: '  ·  ${context.l10n.perMove20s}',
                    style: const TextStyle(color: C.muted)),
              ]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.timeSkipped,
            style: const TextStyle(color: C.muted, fontSize: 13),
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
            context.l10n.roundOf16Caps,
            style: TextStyle(
              color: win ? C.teal : C.magenta,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            win ? context.l10n.youWinCaps : context.l10n.eliminatedCaps,
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
                ? context.l10n.advanceQuarter
                : context.l10n.greatRun('Weekend Showdown'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: C.muted),
          ),
          const SizedBox(height: 22),
          PdfModalCard(
            borderColor: win ? C.teal : C.border2,
            child: Column(
              children: [
                if (win) ...[
                  _kv(context.l10n.nextRound, context.l10n.quarterFinal),
                  _kv(context.l10n.opponent, context.l10n.waitingOtherMatches),
                  _kv(context.l10n.playersLeft, '8', last: true),
                ] else ...[
                  _kv(context.l10n.youFinished, context.l10n.top16),
                  _kv(context.l10n.roundsWon, '3', last: true),
                ],
              ],
            ),
          ),
          const Spacer(),
          PdfPinkButton(
            win ? context.l10n.viewBracketCaps : context.l10n.watchBracketCaps,
            onTap: () => Navigator.pushNamed(context, '/tournament-bracket'),
          ),
          const SizedBox(height: 10),
          PdfGhostButton(
            win ? context.l10n.backToEvent : context.l10n.backToEvents,
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
            context.l10n.championCaps,
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
          Text(context.l10n.prizeAdded, style: const TextStyle(color: C.muted)),
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
          Align(
            alignment: Alignment.centerLeft,
            child: PdfSectionLabel(context.l10n.podium),
          ),
          const SizedBox(height: 8),
          _podium('1', context.l10n.you, gold: true),
          _podium('2', 'rahul256'),
          _podium('3', 'anik'),
          const Spacer(),
          PdfPinkButton(
            context.l10n.backToEventsCaps,
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
