import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/admob_config.dart';
import '../game/ai.dart';
import '../game/ai_callback_gate.dart';
import '../game/board.dart';
import '../models.dart';
import '../services/match_music_service.dart';
import '../services/match_sync_service.dart';
import '../services/progress_sync_service.dart';
import '../services/sfx_service.dart';
import '../services/wallet_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/match_turn.dart';
import '../widgets/painters.dart';
import 'dialogs.dart';

/// Playable board: 3x3 (3 in a row), 4x4 and 5x5 (4 in a row).
/// "O" is the first/local player, "X" is the opponent (The Doll, rival or Player 2).
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  static const turnSeconds = 20;
  // Long enough for the "thinking" state to read on screen.
  static const _aiDelay = Duration(milliseconds: 1100);
  static const _urgentSeconds = 5;

  late GameArgs args;
  late Board board;
  late final AnimationController timer;
  final _rnd = Random();
  final _aiGate = AiCallbackGate();
  Timer? _aiTimer;
  Timer? _ghostTimer;
  Timer? _flashTimer;
  int? _ghostCell;
  String? _timeoutText;
  int _lastTickSecond = -1;
  Color _timeoutColor = C.teal;
  String turn = 'O';
  bool over = false;
  bool _init = false;
  bool _stakeTaken = false;

  int get n => board.size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    MatchMusicService.instance.start();
    args = (ModalRoute.of(context)?.settings.arguments as GameArgs?) ??
        const GameArgs(size: 3);
    board = Board(args.size);
    if (args.stake > 0 && !_stakeTaken) {
      final take = min(args.stake, coins.value);
      _stakeTaken = true;
      unawaited(WalletService.debit(
        amount: take,
        reason: 'match_stake',
        idempotencyKey:
            'match_stake_${DateTime.now().millisecondsSinceEpoch}',
        refType: 'match',
        refId: args.opponentName,
      ));
    }
    timer = AnimationController(
        vsync: this, duration: const Duration(seconds: turnSeconds))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _timeout();
      })
      ..addListener(_countdownTick)
      ..forward();
    SfxService.play(Sfx.countdownGo);
  }

  @override
  void dispose() {
    _aiTimer?.cancel();
    _ghostTimer?.cancel();
    _aiGate.invalidate();
    _flashTimer?.cancel();
    if (_init) {
      timer.dispose();
      MatchMusicService.instance.stop();
    }
    super.dispose();
  }

  void _cancelPendingAi() {
    _aiTimer?.cancel();
    _aiTimer = null;
    _aiGate.invalidate();
    _stopGhost();
  }

  void _scheduleAi() {
    _cancelPendingAi();
    final token = _aiGate.token;
    _aiTimer = Timer(_aiDelay, () => _ai(token));
    _startGhost();
  }

  /// While the AI "thinks", a faint mark hops between empty squares.
  void _startGhost() {
    _stopGhost();
    void hop() {
      final empty = board.emptyCells;
      if (!mounted || empty.isEmpty) return;
      setState(() => _ghostCell = empty[_rnd.nextInt(empty.length)]);
    }

    hop();
    _ghostTimer =
        Timer.periodic(const Duration(milliseconds: 1600), (_) => hop());
  }

  void _stopGhost() {
    _ghostTimer?.cancel();
    _ghostTimer = null;
    if (_ghostCell != null && mounted) setState(() => _ghostCell = null);
  }

  /// One tick per second during the last [_urgentSeconds] of a turn.
  void _countdownTick() {
    if (over || !timer.isAnimating) return;
    final left = (turnSeconds * (1 - timer.value)).ceil();
    if (left > _urgentSeconds || left <= 0) {
      _lastTickSecond = -1;
      return;
    }
    if (left == _lastTickSecond) return;
    _lastTickSecond = left;
    SfxService.play(Sfx.countdownTick);
  }

  void _flashTimeout(String who) {
    _flashTimer?.cancel();
    setState(() {
      _timeoutText = "Time's up · $who";
      _timeoutColor = markColor(turn);
    });
    _flashTimer = Timer(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _timeoutText = null);
    });
  }

  void _stopTurnTimer() {
    if (_init) timer.stop();
  }

  void _leaveToHome() {
    _cancelPendingAi();
    _stopTurnTimer();
    if (!mounted) return;
    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  void _leaveGame() {
    _cancelPendingAi();
    _stopTurnTimer();
    if (!mounted) return;
    Navigator.pop(context);
  }

  void _haptic() {
    if (vibrationOn.value) HapticFeedback.lightImpact();
  }

  void _place(int i) {
    if (over || board.cells[i] != null) return;
    _haptic();
    SfxService.place(turn);
    setState(() => board.cells[i] = turn);

    if (board.winsAt(i, turn)) {
      _finish(turn);
      return;
    }
    if (board.isFull) {
      _finish(null);
      return;
    }

    setState(() => turn = turn == 'O' ? 'X' : 'O');
    timer.forward(from: 0);

    if (args.vsAi && turn == 'X') {
      _scheduleAi();
    } else {
      // Human / P2 turn — drop any stale AI callback.
      _cancelPendingAi();
    }
  }

  void _timeout() {
    if (over || !mounted) return;
    // Timeout owns the move; invalidate any delayed AI for this turn.
    _cancelPendingAi();
    _flashTimeout(turn == 'O' ? _leftName : _rightName);
    final empty = board.emptyCells;
    if (empty.isNotEmpty) _place(empty[_rnd.nextInt(empty.length)]);
  }

  Future<void> _ai(int scheduledToken) async {
    if (!_aiGate.allowMove(
      scheduledToken: scheduledToken,
      mounted: mounted,
      over: over,
      vsAi: args.vsAi,
      turn: turn,
    )) {
      return;
    }
    if (board.emptyCells.isEmpty) return;
    // Snapshot + isolate search so Medium/Hard never stall the UI isolate.
    final snapshot = board.clone();
    final difficulty = args.difficulty;
    final pick = await GameAi.chooseMoveAsync(snapshot, difficulty);
    if (!_aiGate.allowMove(
      scheduledToken: scheduledToken,
      mounted: mounted,
      over: over,
      vsAi: args.vsAi,
      turn: turn,
    )) {
      return;
    }
    if (pick < 0 || pick >= board.cells.length) return;
    if (board.cells[pick] != null) return;
    _place(pick);
  }

  Future<void> _finish(String? winner) async {
    _cancelPendingAi();
    _stopTurnTimer();
    if (!mounted) return;
    setState(() => over = true);
    SfxService.play(winner == null
        ? Sfx.draw
        : (winner == 'O' || !args.vsAi)
            ? Sfx.win
            : Sfx.lose);

    final vsAi = args.vsAi;
    String title, subtitle;
    String? coinText;
    Widget art;
    var coinDelta = 0;

    if (winner == null) {
      // Return stake on draw for quick matches.
      if (args.stake > 0) {
        await WalletService.credit(
          amount: args.stake,
          reason: 'match_reward',
          idempotencyKey:
              'draw_return_${DateTime.now().millisecondsSinceEpoch}',
          refType: 'match_draw',
          refId: args.opponentName,
        );
        coinDelta = 0;
      }
      title = 'Draw';
      subtitle = 'Nobody blinked.';
      art = const Row(mainAxisSize: MainAxisSize.min, children: [
        ShapeIcon(ShapeKind.circle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.triangle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.square, size: 40),
      ]);
    } else if (!vsAi) {
      title = winner == 'O' ? 'Player 1 wins' : 'Player 2 wins';
      subtitle = 'Rematch?';
      art = const PlayerFace(size: 100);
    } else if (winner == 'O') {
      final pot = args.stake > 0 ? args.stake * 2 : 10;
      coinDelta = args.stake > 0 ? args.stake : 10;
      await WalletService.credit(
        amount: pot,
        reason: 'match_reward',
        idempotencyKey:
            'match_win_${DateTime.now().millisecondsSinceEpoch}',
        refType: 'match',
        refId: args.opponentName,
      );
      title = 'You survived';
      subtitle = '${args.opponentName} wants a rematch.';
      coinText = '+$coinDelta coins';
      art = const PlayerFace(size: 100);
    } else {
      // Stake already deducted at start for quick match.
      final loss = args.stake > 0 ? args.stake : min(10, coins.value);
      if (args.stake == 0 && loss > 0) {
        await WalletService.debit(
          amount: loss,
          reason: 'match_stake',
          idempotencyKey:
              'match_loss_${DateTime.now().millisecondsSinceEpoch}',
          refType: 'match',
          refId: args.opponentName,
        );
      }
      coinDelta = -loss;
      title = 'Eliminated';
      subtitle = '${args.opponentName} wins this round.';
      coinText = loss > 0 ? '-$loss coins' : null;
      art = const DollFace(size: 100);
    }

    playerStats.recordMatch(winner: winner, args: args, coinDelta: coinDelta);
    // Cloud sync for signed-in AI / quick_match only (pass & play stays local).
    final sync = await MatchSyncService.syncCompletedMatch(
      winner: winner,
      args: args,
      coinDelta: coinDelta,
    );
    await ProgressSyncService.onMatchFinished();
    if (mounted && args.vsAi && sync.message != null) {
      final failed = sync.attempted && !sync.ok;
      final skippedGuest = !sync.attempted;
      if (failed || skippedGuest || sync.ok && sync.attempted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              failed
                  ? 'Cloud save failed: ${sync.message}'
                  : sync.message!,
            ),
            backgroundColor: failed ? const Color(0xFFB3123E) : null,
          ),
        );
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final again = await showResultDialog(context,
        art: art,
        title: title,
        subtitle: subtitle,
        coinText: coinText,
        baseCoins: coinDelta,
        // Won AI match: rewarded video credits a fixed bonus.
        bonusReward:
            vsAi && winner == 'O' ? AdMobConfig.matchBonusReward : 0,
        shareText: winner != null && (winner == 'O' || !vsAi)
            ? 'I just won a match of DROTIX'
                '${vsAi ? ' against ${args.opponentName}' : ''}! '
                'Think you can beat me? Play now: https://playdrotix.com'
            : null,
        refId: args.opponentName);
    if (!mounted) return;
    if (again == true) {
      if (args.stake > 0) {
        if (coins.value < args.stake) {
          SfxService.play(Sfx.error);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Not enough coins for another stake.')));
          _leaveToHome();
          return;
        }
        final ok = await WalletService.debit(
          amount: args.stake,
          reason: 'match_stake',
          idempotencyKey:
              'match_stake_rematch_${DateTime.now().millisecondsSinceEpoch}',
          refType: 'match',
          refId: args.opponentName,
        );
        if (!ok) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  WalletService.error.value ?? 'Not enough coins')));
          _leaveToHome();
          return;
        }
      }
      _cancelPendingAi();
      setState(() {
        board = Board(args.size);
        turn = 'O';
        over = false;
      });
      timer.forward(from: 0);
      SfxService.play(Sfx.countdownGo);
    } else {
      _leaveToHome();
    }
  }

  Future<void> _pause() async {
    if (over) return;
    _cancelPendingAi();
    timer.stop();
    final r = await showPauseDialog(context);
    if (!mounted) return;
    switch (r) {
      case 'restart':
        _cancelPendingAi();
        setState(() {
          board = Board(args.size);
          turn = 'O';
          over = false;
        });
        timer.forward(from: 0);
        SfxService.play(Sfx.countdownGo);
        break;
      case 'settings':
        await Navigator.pushNamed(context, '/settings');
        if (!mounted || over) return;
        timer.forward();
        if (args.vsAi && turn == 'X') _scheduleAi();
        break;
      case 'quit':
        _leaveToHome();
        break;
      default:
        if (over) return;
        timer.forward();
        if (args.vsAi && turn == 'X') _scheduleAi();
    }
  }

  String get _leftName => args.vsAi ? 'You' : 'Player 1';
  String get _rightName => args.opponentName;

  Widget _player(String mark, String name, String no) => TurnPlayerCard(
        mark: mark,
        tag: no,
        name: name,
        active: turn == mark && !over,
        // Pass & play: both seats are local humans.
        isYou: !args.vsAi || mark == 'O',
      );

  bool get _humanTurn => !over && !(args.vsAi && turn != 'O');

  Widget _cell(int i) {
    final human = _humanTurn;
    return PopIn(
        delayMs: i * 40,
        child: TurnBoardCell(
          index: i,
          value: board.cells[i],
          base: boardColor(equippedBoard.value),
          hintColor: human && !over ? markColor(turn) : null,
          dim: !human && !over,
          ghostMark: _ghostCell == i ? turn : null,
          onTap: human && board.cells[i] == null ? () => _place(i) : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final mover = over
        ? 'Game over'
        : args.vsAi
            ? (turn == 'O' ? 'Your move' : '${args.opponentName}\u2019s move')
            : (turn == 'O' ? "Player 1's move" : "Player 2's move");
    final color = markColor(turn);
    return AppScaffold(
      child: Stack(children: [
        Column(children: [
          AnimatedBuilder(
              animation: timer,
              builder: (_, __) {
                final left = (turnSeconds * (1 - timer.value)).ceil();
                final urgent = !over && timer.isAnimating && left <= _urgentSeconds;
                return Column(children: [
                  Row(children: [
                    Expanded(
                      child: TurnStatusPill(
                        text: over
                            ? mover
                            : '$mover · 0:${left.toString().padLeft(2, '0')}',
                        color: over ? C.border2 : color,
                        urgent: urgent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CoinChip(),
                    const SizedBox(width: 8),
                    RoundIconBox(Icons.pause, label: 'Pause', onTap: _pause),
                  ]),
                  const SizedBox(height: 12),
                  TurnTimerBar(
                    value: over ? 0 : 1 - timer.value,
                    color: color,
                    urgent: urgent,
                  ),
                ]);
              }),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _player('O', _leftName, 'No. 042')),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 22, 8, 0),
              child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                      color: markColor(turn == 'O' ? 'X' : 'O'),
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                  child: const Text('VS')),
            ),
            Expanded(child: _player('X', _rightName, 'No. 001')),
          ]),
          Expanded(
              child: Center(
                  child: AspectRatio(
                      aspectRatio: 1,
                      child: Column(children: [
                        for (var r = 0; r < n; r++)
                          Expanded(
                              child: Row(children: [
                            for (var c = 0; c < n; c++)
                              Expanded(child: _cell(r * n + c)),
                          ])),
                      ])))),
          SizedBox(
            height: 24,
            child: Center(
              child: over
                  ? null
                  : TurnCaption(
                      myTurn: _humanTurn,
                      opponentName: args.opponentName,
                      color: color,
                    ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
              width: double.infinity,
              child: GhostButton('Leave game', onTap: _leaveGame)),
        ]),
        if (_timeoutText != null)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: TimeoutFlash(
                  key: ValueKey(_timeoutText),
                  color: _timeoutColor,
                  text: _timeoutText!,
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
