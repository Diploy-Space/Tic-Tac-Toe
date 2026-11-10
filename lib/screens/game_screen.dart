import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/ai.dart';
import '../game/ai_callback_gate.dart';
import '../game/board.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
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
  static const _aiDelay = Duration(milliseconds: 520);

  late GameArgs args;
  late Board board;
  late final AnimationController timer;
  final _rnd = Random();
  final _aiGate = AiCallbackGate();
  Timer? _aiTimer;
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
    args = (ModalRoute.of(context)?.settings.arguments as GameArgs?) ??
        const GameArgs(size: 3);
    board = Board(args.size);
    if (args.stake > 0 && !_stakeTaken) {
      final take = min(args.stake, coins.value);
      coins.value -= take;
      _stakeTaken = true;
    }
    timer = AnimationController(
        vsync: this, duration: const Duration(seconds: turnSeconds))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _timeout();
      })
      ..forward();
  }

  @override
  void dispose() {
    _cancelPendingAi();
    if (_init) timer.dispose();
    super.dispose();
  }

  void _cancelPendingAi() {
    _aiTimer?.cancel();
    _aiTimer = null;
    _aiGate.invalidate();
  }

  void _scheduleAi() {
    _cancelPendingAi();
    final token = _aiGate.token;
    _aiTimer = Timer(_aiDelay, () => _ai(token));
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

    final vsAi = args.vsAi;
    String title, subtitle;
    String? coinText;
    Widget art;
    var coinDelta = 0;

    if (winner == null) {
      // Return stake on draw for quick matches.
      if (args.stake > 0) {
        coins.value += args.stake;
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
      coins.value += pot;
      coinDelta = args.stake > 0 ? args.stake : 10;
      title = 'You survived';
      subtitle = '${args.opponentName} wants a rematch.';
      coinText = '+$coinDelta coins';
      art = const PlayerFace(size: 100);
    } else {
      // Stake already deducted at start for quick match.
      final loss = args.stake > 0 ? args.stake : min(10, coins.value);
      if (args.stake == 0) coins.value -= loss;
      coinDelta = -loss;
      title = 'Eliminated';
      subtitle = '${args.opponentName} wins this round.';
      coinText = loss > 0 ? '-$loss coins' : null;
      art = const DollFace(size: 100);
    }

    playerStats.recordMatch(winner: winner, args: args, coinDelta: coinDelta);

    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final again = await showResultDialog(context,
        art: art, title: title, subtitle: subtitle, coinText: coinText);
    if (!mounted) return;
    if (again == true) {
      if (args.stake > 0) {
        if (coins.value < args.stake) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Not enough coins for another stake.')));
          _leaveToHome();
          return;
        }
        coins.value -= args.stake;
      }
      _cancelPendingAi();
      setState(() {
        board = Board(args.size);
        turn = 'O';
        over = false;
      });
      timer.forward(from: 0);
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

  Widget _player(String mark, String name, String no) {
    final active = turn == mark && !over;
    final color = mark == 'O' ? C.teal : C.magenta;
    return AppCard(
        borderColor: active ? color : C.border,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          MarkIcon(isX: mark == 'X', size: 24),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Tag(no, color: color),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ]));
  }

  Widget _cell(int i) {
    final v = board.cells[i];
    final canTap = !over && !(args.vsAi && turn != 'O');
    return Padding(
        padding: const EdgeInsets.all(5),
        child: PopIn(
            delayMs: i * 40,
            child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: canTap ? () => _place(i) : null,
                child: Container(
                    decoration: BoxDecoration(
                        color: boardColor(equippedBoard.value),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: C.border)),
                    child: v == null
                        ? null
                        : TweenAnimationBuilder<double>(
                            key: ValueKey('$i$v'),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            builder: (_, s, child) =>
                                Transform.scale(scale: s, child: child),
                            child: Center(
                                child: FractionallySizedBox(
                                    widthFactor: .55,
                                    heightFactor: .55,
                                    child: FittedBox(
                                        child: MarkIcon(
                                            isX: v == 'X', size: 44)))))))));
  }

  @override
  Widget build(BuildContext context) {
    final mover = over
        ? 'Game over'
        : args.vsAi
            ? (turn == 'O' ? 'Your move' : '${args.opponentName} is thinking')
            : (turn == 'O' ? "Player 1's move" : "Player 2's move");
    return AppScaffold(
      child: Column(children: [
        Row(children: [
          AnimatedBuilder(
              animation: timer,
              builder: (_, __) {
                final left = (turnSeconds * (1 - timer.value)).ceil();
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(color: C.border2)),
                    child: Text('$mover · 0:${left.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)));
              }),
          const Spacer(),
          const CoinChip(),
          const SizedBox(width: 8),
          RoundIconBox(Icons.pause, label: 'Pause', onTap: _pause),
        ]),
        const SizedBox(height: 12),
        AnimatedBuilder(
            animation: timer,
            builder: (_, __) => ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                    value: 1 - timer.value,
                    minHeight: 6,
                    backgroundColor: C.border,
                    color: C.magenta))),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _player('O', _leftName, 'No. 042'),
          const Text('VS',
              style: TextStyle(color: C.magenta, fontWeight: FontWeight.w800)),
          _player('X', _rightName, 'No. 001'),
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
            width: double.infinity,
            child: GhostButton('Leave game', onTap: _leaveGame)),
      ]),
    );
  }
}
