import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../models/game_chat_message.dart';
import '../models/multiplayer_match.dart';
import '../models/online_room_state.dart';
import '../services/game_chat_service.dart';
import '../services/match_sync_service.dart';
import '../services/online_realtime_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/game_chat_sheet.dart';
import '../widgets/painters.dart';
import 'dialogs.dart';

/// C2/C4 online board: PostgreSQL is truth for moves, turns, and results.
class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({super.key});
  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen>
    with WidgetsBindingObserver {
  OnlineRoomArgs? _args;
  bool _attached = false;
  bool _resultShown = false;
  String? _listenedRoomId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    OnlineRealtimeService.state.addListener(_onRoomChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is OnlineRoomArgs && !_attached) {
      _args = arg;
      _attached = true;
      _listenedRoomId = arg.roomId;
      OnlineRealtimeService.attach(arg.roomId);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      OnlineRealtimeService.refresh();
    }
  }

  @override
  void dispose() {
    OnlineRealtimeService.state.removeListener(_onRoomChanged);
    WidgetsBinding.instance.removeObserver(this);
    GameChatService.detach();
    OnlineRealtimeService.detach();
    super.dispose();
  }

  bool _chatEligible(OnlineRoomState room) {
    return InGameChatGate.isRealPlayerVsRealPlayer(
      playerO: room.playerO,
      playerX: room.playerX,
      opponentId: room.opponentId,
    );
  }

  void _ensureChatAttached(OnlineRoomState room) {
    if (!_chatEligible(room)) {
      if (GameChatService.roomId != null) {
        GameChatService.detach();
      }
      return;
    }
    if (GameChatService.roomId != room.roomId) {
      GameChatService.attach(room.roomId);
    }
  }

  void _onRoomChanged() {
    final room = OnlineRealtimeService.state.value;
    if (room == null || !mounted) return;
    if (_listenedRoomId != null && room.roomId != _listenedRoomId) return;
    _ensureChatAttached(room);
    if (room.winner == null || _resultShown) return;
    _resultShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showServerResult(room);
    });
  }

  Future<void> _showServerResult(OnlineRoomState room) async {
    // Cloud history was settled server-side; refresh signed-in stats if possible.
    MatchSyncService.refresh();

    final String title;
    final String subtitle;
    final Widget art;
    String? coinText;
    if (room.winner == 'draw') {
      title = 'Draw';
      subtitle = 'Board is full — server confirmed.';
      art = const Row(mainAxisSize: MainAxisSize.min, children: [
        ShapeIcon(ShapeKind.circle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.triangle, size: 40),
        SizedBox(width: 8),
        ShapeIcon(ShapeKind.square, size: 40),
      ]);
    } else if (room.winner == room.myMark) {
      title = 'You win';
      subtitle = 'Result verified by the server.';
      coinText = room.stake > 0 ? '+${room.stake} stake' : null;
      art = const PlayerFace(size: 100);
    } else {
      title = 'You lose';
      subtitle = 'Result verified by the server.';
      coinText = room.stake > 0 ? '-${room.stake} stake' : null;
      art = const DollFace(size: 100);
    }

    if (!mounted) return;
    await showResultDialog(
      context,
      art: art,
      title: title,
      subtitle: subtitle,
      coinText: coinText,
    );
    if (!mounted) return;
    await GameChatService.detach();
    await OnlineRealtimeService.detach();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  Future<void> _tap(int i) async {
    final s = OnlineRealtimeService.state.value;
    if (s == null ||
        s.isFinished ||
        !s.isMyTurn ||
        OnlineRealtimeService.submitInFlight.value) {
      return;
    }
    if (i < 0 || i >= s.cells.length || s.cells[i] != null) return;
    if (vibrationOn.value) HapticFeedback.lightImpact();
    await OnlineRealtimeService.submitMove(i);
  }

  Future<void> _leave() async {
    final room = OnlineRealtimeService.state.value;
    final active = room != null && !room.isFinished;
    if (active) {
      final ok = await showConfirmDialog(
        context,
        title: 'Leave match?',
        body: 'Leaving now counts as a forfeit. Your opponent wins.',
      );
      if (ok != true || !mounted) return;
      await OnlineRealtimeService.forfeit();
      // Result dialog is shown via state listener when winner is set.
      if (OnlineRealtimeService.state.value?.winner == null) {
        await GameChatService.detach();
        await OnlineRealtimeService.detach();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      }
      return;
    }
    await GameChatService.detach();
    await OnlineRealtimeService.detach();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  Widget _player(String mark, String name, bool active) {
    final color = mark == 'O' ? C.teal : C.magenta;
    return AppCard(
        borderColor: active ? color : C.border,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          MarkIcon(isX: mark == 'X', size: 24),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Tag(mark == 'O' ? 'Player O' : 'Player X', color: color),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ]));
  }

  Widget _cell(OnlineRoomState s, int i) {
    final v = s.cells[i];
    final canTap = !s.isFinished &&
        s.isMyTurn &&
        !OnlineRealtimeService.submitInFlight.value &&
        v == null;
    return Padding(
        padding: const EdgeInsets.all(5),
        child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: canTap ? () => _tap(i) : null,
            child: Container(
                decoration: BoxDecoration(
                    color: boardColor(equippedBoard.value),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.border)),
                child: v == null
                    ? null
                    : TweenAnimationBuilder<double>(
                        key: ValueKey('$i-$v-${s.moveCount}'),
                        tween: Tween(begin: 0.7, end: 1),
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOutCubic,
                        builder: (_, scale, child) =>
                            Transform.scale(scale: scale, child: child),
                        child: Center(
                            child: FractionallySizedBox(
                                widthFactor: .55,
                                heightFactor: .55,
                                child: FittedBox(
                                    child: MarkIcon(
                                        isX: v == 'X', size: 44))))))));
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;
    return AppScaffold(
      child: ValueListenableBuilder<OnlineRoomState?>(
        valueListenable: OnlineRealtimeService.state,
        builder: (_, room, __) => ValueListenableBuilder<String?>(
          valueListenable: OnlineRealtimeService.error,
          builder: (_, err, ___) => ValueListenableBuilder<bool>(
            valueListenable: OnlineRealtimeService.connected,
            builder: (_, live, ____) => ValueListenableBuilder<bool>(
              valueListenable: OnlineRealtimeService.submitInFlight,
              builder: (_, pending, _____) {
                if (room == null) {
                  return Column(children: [
                    const TopBar('Online'),
                    const Spacer(),
                    if (err != null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(err,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: C.muted)),
                      )
                    else
                      const CircularProgressIndicator(),
                    const Spacer(),
                    GhostButton('Leave', onTap: _leave),
                  ]);
                }

                final showChat = _chatEligible(room);

                final n = room.boardSize;
                final mover = room.winner != null
                    ? (room.winner == 'draw'
                        ? 'Draw'
                        : (room.winner == room.myMark
                            ? 'You win'
                            : 'Opponent wins'))
                    : (room.isMyTurn
                        ? 'Your move'
                        : "Opponent's move");
                const youLabel = 'You';
                const oppLabel = 'Rival';

                return Column(children: [
                  Row(children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(color: C.border2)),
                        child: Text(
                            '$mover · ${live ? 'Live' : 'Reconnecting…'}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14))),
                    const Spacer(),
                    Text('×${room.moveCount}',
                        style: const TextStyle(color: C.muted)),
                    if (showChat) ...[
                      const SizedBox(width: 4),
                      IconButton(
                        tooltip: 'Chat',
                        onPressed: () => openGameChatSheet(
                          context,
                          roomId: room.roomId,
                        ),
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: C.teal),
                      ),
                    ],
                    const SizedBox(width: 4),
                    IconButton(
                        tooltip: 'Refresh',
                        onPressed: () => OnlineRealtimeService.refresh(),
                        icon: const Icon(Icons.refresh, color: C.muted)),
                  ]),
                  if (err != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(err,
                          style:
                              const TextStyle(color: C.magenta, fontSize: 12)),
                    ),
                  const SizedBox(height: 12),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _player(
                            'O',
                            room.myMark == 'O' ? youLabel : oppLabel,
                            room.currentTurn == 'O' && room.winner == null),
                        const Text('VS',
                            style: TextStyle(
                                color: C.magenta, fontWeight: FontWeight.w800)),
                        _player(
                            'X',
                            room.myMark == 'X' ? youLabel : oppLabel,
                            room.currentTurn == 'X' && room.winner == null),
                      ]),
                  const SizedBox(height: 8),
                  Text(
                      'Stake ${room.stake} · ${args?.roomId.substring(0, 8) ?? ''}…',
                      style: const TextStyle(color: C.muted, fontSize: 12)),
                  Expanded(
                      child: Center(
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Column(children: [
                                for (var r = 0; r < n; r++)
                                  Expanded(
                                      child: Row(children: [
                                    for (var c = 0; c < n; c++)
                                      Expanded(child: _cell(room, r * n + c)),
                                  ])),
                              ])))),
                  SizedBox(
                      width: double.infinity,
                      child: GhostButton(
                          room.isFinished ? 'Back to home' : 'Leave game',
                          onTap: _leave)),
                ]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
