import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/admob_config.dart';
import '../game/ai.dart';
import '../game/ai_callback_gate.dart';
import '../game/board.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
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
import '../l10n/app_localizations.dart';

/// Playable board: 3x3 (3 in a row), 4x4 and 5x5 (4 in a row).
/// "O" is the first/local player, "X" is the opponent (The Doll, rival or Player 2).
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
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

  /// Cells of the winning run (empty while playing or on a draw).
  List<int> _winLine = const [];

  /// Final result once [over]: 'O', 'X' or 'draw'.
  String? _outcome;

  /// Bumped on every new match so the board pop-in replays.
  int _round = 0;

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
        idempotencyKey: 'match_stake_${DateTime.now().millisecondsSinceEpoch}',
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
      _timeoutText = context.l10n.timesUp(who);
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
      _winLine = board.winningLine(i, turn);
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

  /// Wallet call that never blocks or breaks the result screen
  /// (no internet, slow server, signed-out, …).
  Future<bool> _safeWallet(Future<bool> Function() call) async {
    try {
      return await call().timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('GameScreen wallet: $e');
      return false;
    }
  }

  /// Coins, stats and cloud sync after a match. Runs in the background so the
  /// result is shown right away, even offline.
  Future<void> _settle(String? winner, int coinDelta) async {
    final key = DateTime.now().millisecondsSinceEpoch;
    if (winner == null) {
      // Draw: give the stake back.
      if (args.stake > 0) {
        await _safeWallet(() => WalletService.credit(
              amount: args.stake,
              reason: 'match_reward',
              idempotencyKey: 'draw_return_$key',
              refType: 'match_draw',
              refId: args.opponentName,
            ));
      }
    } else if (args.vsAi && winner == 'O') {
      await _safeWallet(() => WalletService.credit(
            amount: args.stake > 0 ? args.stake * 2 : 10,
            reason: 'match_reward',
            idempotencyKey: 'match_win_$key',
            refType: 'match',
            refId: args.opponentName,
          ));
    } else if (args.vsAi && args.stake == 0 && coinDelta < 0) {
      // Stake was already taken at the start of a staked match.
      await _safeWallet(() => WalletService.debit(
            amount: -coinDelta,
            reason: 'match_stake',
            idempotencyKey: 'match_loss_$key',
            refType: 'match',
            refId: args.opponentName,
          ));
    }

    playerStats.recordMatch(winner: winner, args: args, coinDelta: coinDelta);
    try {
      // Cloud sync for signed-in AI / quick_match only (skipped offline).
      final sync = await MatchSyncService.syncCompletedMatch(
        winner: winner,
        args: args,
        coinDelta: coinDelta,
      ).timeout(const Duration(seconds: 10));
      await ProgressSyncService.onMatchFinished()
          .timeout(const Duration(seconds: 10));
      if (mounted && args.vsAi && sync.attempted && !sync.ok) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.l10n.cloudSaveFailed('${sync.message}')),
          backgroundColor: const Color(0xFFB3123E),
        ));
      }
    } catch (e) {
      debugPrint('GameScreen sync: $e');
    }
  }

  Future<void> _finish(String? winner) async {
    _cancelPendingAi();
    _stopTurnTimer();
    _flashTimer?.cancel();
    if (!mounted) return;
    final vsAi = args.vsAi;
    final youWon = winner == 'O';
    setState(() {
      over = true;
      _outcome = winner ?? 'draw';
      _timeoutText = null;
    });
    if (winner != null) _haptic();
    SfxService.play(winner == null
        ? Sfx.draw
        : (youWon || !vsAi)
            ? Sfx.win
            : Sfx.lose);

    final ResultTone tone;
    final l = context.l10n;
    String title, subtitle;
    String? coinText;
    Widget art;
    var coinDelta = 0;

    if (winner == null) {
      tone = ResultTone.draw;
      title = l.draw;
      subtitle = vsAi ? l.nobodyBlinkedVs(args.opponentName) : l.nobodyBlinked;
      coinText = args.stake > 0 ? l.stakeReturned : null;
      art = const Row(mainAxisSize: MainAxisSize.min, children: [
        ShapeIcon(ShapeKind.circle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.triangle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.square, size: 40),
      ]);
    } else if (!vsAi) {
      tone = ResultTone.win;
      title = youWon ? l.player1Wins : l.player2Wins;
      subtitle = l.rematchQuestion;
      art = const PlayerFace(size: 100);
    } else if (youWon) {
      tone = ResultTone.win;
      coinDelta = args.stake > 0 ? args.stake : 10;
      title = l.youWin;
      subtitle = l.youBeat(args.opponentName);
      coinText = l.plusCoins(AppLocaleService.formatCoinAmount(coinDelta));
      art = const PlayerFace(size: 100);
    } else {
      tone = ResultTone.lose;
      final loss = args.stake > 0 ? args.stake : min(10, coins.value);
      coinDelta = -loss;
      title = l.youLose;
      subtitle = l.winsThisRound(args.opponentName);
      coinText = loss > 0
          ? l.minusCoins(AppLocaleService.formatCoinAmount(loss))
          : null;
      art = const DollFace(size: 100);
    }

    unawaited(_settle(winner, coinDelta));

    // Let the winning line / final board play out before the result.
    await Future<void>.delayed(
        Duration(milliseconds: winner == null ? 900 : 1300));
    if (!mounted || !over) return;
    final again = await showResultDialog(context,
        art: art,
        title: title,
        subtitle: subtitle,
        tone: tone,
        coinText: coinText,
        baseCoins: coinDelta,
        // Won AI match: rewarded video credits a fixed bonus.
        bonusReward: vsAi && youWon ? AdMobConfig.matchBonusReward : 0,
        shareText: winner != null && (youWon || !vsAi)
            ? (vsAi
                ? l.shareWinVs(args.opponentName, 'https://playdrotix.in')
                : l.shareWin('https://playdrotix.in'))
            : null,
        refId: args.opponentName);
    if (!mounted) return;
    if (again != true) {
      _leaveToHome();
      return;
    }
    if (args.stake > 0) {
      if (coins.value < args.stake) {
        SfxService.play(Sfx.error);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.notEnoughCoinsAnother)));
        _leaveToHome();
        return;
      }
      // Same as the first match: don't hold the board on the network.
      unawaited(_safeWallet(() => WalletService.debit(
            amount: args.stake,
            reason: 'match_stake',
            idempotencyKey:
                'match_stake_rematch_${DateTime.now().millisecondsSinceEpoch}',
            refType: 'match',
            refId: args.opponentName,
          )));
    }
    _newMatch();
  }

  /// Fresh board, O to move, timers and effects reset.
  void _newMatch() {
    _cancelPendingAi();
    _flashTimer?.cancel();
    setState(() {
      board = Board(args.size);
      turn = 'O';
      over = false;
      _outcome = null;
      _winLine = const [];
      _timeoutText = null;
      _lastTickSecond = -1;
      _round++;
    });
    timer.forward(from: 0);
    SfxService.play(Sfx.countdownGo);
  }

  Future<void> _pause() async {
    if (over) return;
    _cancelPendingAi();
    timer.stop();
    final r = await showPauseDialog(context);
    if (!mounted) return;
    switch (r) {
      case 'restart':
        _newMatch();
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

  String get _leftName => args.vsAi ? context.l10n.you : context.l10n.player1;

  String get _resultLabel {
    final l = context.l10n;
    return switch (_outcome) {
      'draw' => l.draw,
      'O' => args.vsAi ? l.youWin : l.player1Wins,
      'X' => args.vsAi ? l.youLose : l.player2Wins,
      _ => l.gameOver,
    };
  }

  Color get _resultColor => switch (_outcome) {
        'O' => markColor('O'),
        'X' => args.vsAi ? C.danger : markColor('X'),
        _ => C.muted,
      };
  String get _rightName => args.vsAi ? args.opponentName : context.l10n.player2;

  Widget _player(String mark, String name, String no) => TurnPlayerCard(
        mark: mark,
        tag: no,
        name: name,
        active: over ? _outcome == mark : turn == mark,
        label: over ? context.l10n.winner : null,
        // Pass & play: both seats are local humans.
        isYou: !args.vsAi || mark == 'O',
      );

  bool get _humanTurn => !over && !(args.vsAi && turn != 'O');

  Widget _cell(int i) {
    final human = _humanTurn;
    final inLine = _winLine.contains(i);
    return PopIn(
        key: ValueKey('cell-$_round-$i'),
        delayMs: i * 40,
        child: TurnBoardCell(
          index: i,
          value: board.cells[i],
          base: boardColor(equippedBoard.value),
          hintColor: human && !over ? markColor(turn) : null,
          dim: !human && !over,
          ghostMark: _ghostCell == i ? turn : null,
          onTap: human && board.cells[i] == null ? () => _place(i) : null,
          winColor: inLine ? markColor(board.cells[i]!) : null,
          faded: over && _winLine.isNotEmpty && !inLine,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final mover = over
        ? _resultLabel
        : args.vsAi
            ? (turn == 'O'
                ? context.l10n.yourMove
                : context.l10n.opponentsMove(args.opponentName))
            : (turn == 'O'
                ? context.l10n.player1Move
                : context.l10n.player2Move);
    final color = markColor(turn);
    return AppScaffold(
      child: Stack(children: [
        Column(children: [
          AnimatedBuilder(
              animation: timer,
              builder: (_, __) {
                final left = (turnSeconds * (1 - timer.value)).ceil();
                final urgent =
                    !over && timer.isAnimating && left <= _urgentSeconds;
                return Column(children: [
                  Row(children: [
                    Expanded(
                      child: TurnStatusPill(
                        text: over
                            ? mover
                            : '$mover · 0:${left.toString().padLeft(2, '0')}',
                        color: over ? _resultColor : color,
                        urgent: urgent,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CoinChip(),
                    const SizedBox(width: 8),
                    RoundIconBox(Icons.pause,
                        label: context.l10n.pause, onTap: _pause),
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
                  ? Text(_resultLabel,
                      style: TextStyle(
                          color: _resultColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .4))
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
              child: GhostButton(context.l10n.leaveGame, onTap: _leaveGame)),
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
