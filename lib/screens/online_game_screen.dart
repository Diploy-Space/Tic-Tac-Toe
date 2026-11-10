import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../models/multiplayer_match.dart';
import '../models/online_room_state.dart';
import '../services/online_realtime_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// C2 online board: PostgreSQL snapshot + Realtime refetch. Not AI GameScreen.
class OnlineGameScreen extends StatefulWidget {
  const OnlineGameScreen({super.key});
  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen>
    with WidgetsBindingObserver {
  OnlineRoomArgs? _args;
  bool _attached = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is OnlineRoomArgs && !_attached) {
      _args = arg;
      _attached = true;
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
    WidgetsBinding.instance.removeObserver(this);
    OnlineRealtimeService.detach();
    super.dispose();
  }

  Future<void> _tap(int i) async {
    final s = OnlineRealtimeService.state.value;
    if (s == null ||
        !s.isMyTurn ||
        OnlineRealtimeService.submitInFlight.value) {
      return;
    }
    if (i < 0 || i >= s.cells.length || s.cells[i] != null) return;
    if (vibrationOn.value) HapticFeedback.lightImpact();
    // Optimistic — mark paints immediately; service reconciles with server.
    await OnlineRealtimeService.submitMove(i);
  }

  Future<void> _leave() async {
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
    final canTap =
        s.isMyTurn && !OnlineRealtimeService.submitInFlight.value && v == null;
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
                  const SizedBox(width: 8),
                  IconButton(
                      tooltip: 'Refresh',
                      onPressed: () => OnlineRealtimeService.refresh(),
                      icon: const Icon(Icons.refresh, color: C.muted)),
                ]),
                if (err != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(err,
                        style: const TextStyle(color: C.magenta, fontSize: 12)),
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
                    child: GhostButton('Leave game', onTap: _leave)),
              ]);
            },
            ),
          ),
        ),
      ),
    );
  }
}
