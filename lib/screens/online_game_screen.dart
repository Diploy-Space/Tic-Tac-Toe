import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../models/game_chat_message.dart';
import '../models/multiplayer_match.dart';
import '../models/online_room_state.dart';
import '../services/friend_repository.dart';
import '../services/game_chat_service.dart';
import '../services/match_sync_service.dart';
import '../services/online_realtime_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/game_chat_sheet.dart';
import '../widgets/match_emoji_reaction.dart';
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
  Timer? _reconnectTimer;
  int _reconnectLeft = 30;
  bool _showingUnstable = false;

  String _myName = 'You';
  String _oppName = 'Opponent';
  String? _myAvatar;
  String? _oppAvatar;
  String? _loadedForRoom;

  /// Ludo-style floating reactions (can stack briefly).
  final List<MatchEmojiBurst> _bursts = [];
  final Map<int, Timer> _burstTimers = {};
  int _burstSeq = 0;
  String? _lastHandledIncomingId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    OnlineRealtimeService.state.addListener(_onRoomChanged);
    OnlineRealtimeService.connected.addListener(_onConnectionChanged);
    GameChatService.lastIncoming.addListener(_onIncomingChat);
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
    _reconnectTimer?.cancel();
    for (final t in _burstTimers.values) {
      t.cancel();
    }
    _burstTimers.clear();
    OnlineRealtimeService.connected.removeListener(_onConnectionChanged);
    OnlineRealtimeService.state.removeListener(_onRoomChanged);
    GameChatService.lastIncoming.removeListener(_onIncomingChat);
    WidgetsBinding.instance.removeObserver(this);
    GameChatService.detach();
    OnlineRealtimeService.detach();
    super.dispose();
  }

  void _onIncomingChat() {
    final m = GameChatService.lastIncoming.value;
    if (m == null || !mounted || _resultShown) return;
    if (_lastHandledIncomingId == m.id) return;
    _lastHandledIncomingId = m.id;

    final text = m.message.trim();
    if (isMatchEmojiOnly(text)) {
      _showBurst(text, fromMe: false);
    } else if (!GameChatService.isSheetOpen) {
      final preview =
          text.length > 42 ? '${text.substring(0, 42)}…' : text;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: C.surface,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 88),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: C.teal),
          ),
          content: Row(
            children: [
              const Icon(Icons.chat_bubble, color: C.teal, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$_oppName: $preview',
                  style: const TextStyle(
                    color: C.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Open',
            textColor: C.magenta,
            onPressed: () {
              final room = OnlineRealtimeService.state.value;
              if (room != null) _openChat(room);
            },
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
    GameChatService.clearLastIncoming();
  }

  void _showBurst(String emoji, {required bool fromMe}) {
    final burst = MatchEmojiBurst(
      emoji: emoji,
      fromMe: fromMe,
      id: ++_burstSeq,
    );
    setState(() {
      _bursts.add(burst);
      if (_bursts.length > 3) {
        final old = _bursts.removeAt(0);
        _burstTimers.remove(old.id)?.cancel();
      }
    });
    _burstTimers[burst.id]?.cancel();
    _burstTimers[burst.id] = Timer(const Duration(milliseconds: 2300), () {
      _burstTimers.remove(burst.id);
      if (!mounted) return;
      setState(() => _bursts.removeWhere((b) => b.id == burst.id));
    });
  }

  Future<void> _sendReact(String emoji) async {
    if (GameChatService.roomId == null) return;
    _showBurst(emoji, fromMe: true);
    await GameChatService.send(emoji);
  }

  void _onConnectionChanged() {
    final live = OnlineRealtimeService.connected.value;
    final room = OnlineRealtimeService.state.value;
    if (!mounted || room == null || room.isFinished || _resultShown) return;
    if (live) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      if (_showingUnstable) setState(() => _showingUnstable = false);
      return;
    }
    if (_reconnectTimer != null) return;
    _reconnectLeft = 30;
    setState(() => _showingUnstable = true);
    _reconnectTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted) return;
      if (OnlineRealtimeService.connected.value) {
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        setState(() => _showingUnstable = false);
        return;
      }
      if (_reconnectLeft <= 1) {
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        await GameChatService.detach();
        await OnlineRealtimeService.detach();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/match-abandoned',
          (r) => false,
        );
        return;
      }
      setState(() => _reconnectLeft--);
      OnlineRealtimeService.refresh();
    });
  }

  bool _chatEligible(OnlineRoomState room) {
    if (room.chatStopped) return false;
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

  Future<void> _loadProfiles(OnlineRoomState room) async {
    final key = '${room.roomId}:${room.playerO}:${room.playerX}';
    if (_loadedForRoom == key) return;
    _loadedForRoom = key;
    try {
      final map = await FriendRepository.profilesByIds([
        room.playerO,
        room.playerX,
      ]);
      if (!mounted) return;
      final myId = room.myMark == 'O' ? room.playerO : room.playerX;
      final oppId = room.opponentId;
      final me = map[myId];
      final opp = map[oppId];
      setState(() {
        _myName = me?.username ?? authDisplayName.value;
        if (_myName.trim().isEmpty) _myName = 'You';
        _oppName = (opp?.username ?? '').trim().isEmpty
            ? 'Opponent'
            : opp!.username;
        _myAvatar = me?.avatarUrl ?? authAvatarUrl.value;
        _oppAvatar = opp?.avatarUrl;
      });
    } catch (_) {
      // Keep defaults.
    }
  }

  void _onRoomChanged() {
    final room = OnlineRealtimeService.state.value;
    if (room == null || !mounted) return;
    if (_listenedRoomId != null && room.roomId != _listenedRoomId) return;
    _ensureChatAttached(room);
    _loadProfiles(room);
    if (room.winner == null || _resultShown) return;
    _resultShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showServerResult(room);
    });
  }

  Future<void> _showServerResult(OnlineRoomState room) async {
    MatchSyncService.refresh();
    _reconnectTimer?.cancel();
    final victory = room.winner == room.myMark;
    final draw = room.winner == 'draw';
    await GameChatService.detach();
    await OnlineRealtimeService.detach();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/match-result',
      (r) => false,
      arguments: {
        'victory': victory,
        'draw': draw,
        'duration': '—',
        'coins': victory ? room.stake : (draw ? 0 : -room.stake),
        'stake': room.stake,
      },
    );
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

  Future<void> _openChat(OnlineRoomState room) async {
    if (!_chatEligible(room)) return;
    await openGameChatSheet(
      context,
      roomId: room.roomId,
      opponentName: _oppName,
      opponentId: room.opponentId,
      opponentAvatarUrl: _oppAvatar,
      myAvatarUrl: _myAvatar,
      myMark: room.myMark,
      opponentMark: room.myMark == 'X' ? 'O' : 'X',
    );
  }

  Widget _player({
    required String mark,
    required String name,
    required String? avatarUrl,
    required bool active,
    required bool isYou,
  }) {
    final color = mark == 'O' ? C.teal : C.magenta;
    return AppCard(
      borderColor: active ? color : C.border,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        ClipOval(child: ProfileAvatar(url: avatarUrl, size: 36)),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Tag(isYou ? 'You · $mark' : mark, color: color),
          SizedBox(
            width: 88,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ]),
      ]),
    );
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

                if (_showingUnstable && !live && !room.isFinished) {
                  return Column(children: [
                    const TopBar('Online'),
                    const Spacer(),
                    const Icon(Icons.wifi_off_rounded,
                        size: 56, color: C.danger),
                    const SizedBox(height: 16),
                    const Heading('Connection unstable', size: 22),
                    const SizedBox(height: 8),
                    const Text('Attempting to reconnect…',
                        style: TextStyle(color: C.muted)),
                    const SizedBox(height: 20),
                    Text(
                      '${_reconnectLeft}s',
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: C.teal),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The board is hidden until you are back.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: C.muted),
                    ),
                    const Spacer(),
                    GhostButton('Leave game', onTap: _leave),
                  ]);
                }

                final oName =
                    room.myMark == 'O' ? _myName : _oppName;
                final xName =
                    room.myMark == 'X' ? _myName : _oppName;
                final oAvatar =
                    room.myMark == 'O' ? _myAvatar : _oppAvatar;
                final xAvatar =
                    room.myMark == 'X' ? _myAvatar : _oppAvatar;

                return Stack(
                  children: [
                    Column(children: [
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14))),
                        const Spacer(),
                        Text('×${room.moveCount}',
                            style: const TextStyle(color: C.muted)),
                        if (showChat) ...[
                          const SizedBox(width: 4),
                          ValueListenableBuilder<int>(
                            valueListenable: GameChatService.unreadCount,
                            builder: (_, unread, __) => Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  tooltip: 'Chat',
                                  onPressed: () => _openChat(room),
                                  icon: const Icon(
                                      Icons.chat_bubble_outline,
                                      color: C.teal),
                                ),
                                if (unread > 0)
                                  Positioned(
                                    right: 6,
                                    top: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: C.magenta,
                                        borderRadius:
                                            BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        unread > 9 ? '9+' : '$unread',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(width: 4),
                        IconButton(
                            tooltip: 'Refresh',
                            onPressed: () =>
                                OnlineRealtimeService.refresh(),
                            icon: const Icon(Icons.refresh,
                                color: C.muted)),
                      ]),
                      if (err != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(err,
                              style: const TextStyle(
                                  color: C.magenta, fontSize: 12)),
                        ),
                      const SizedBox(height: 12),
                      Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            _player(
                              mark: 'O',
                              name: oName,
                              avatarUrl: oAvatar,
                              active: room.currentTurn == 'O' &&
                                  room.winner == null,
                              isYou: room.myMark == 'O',
                            ),
                            const Text('VS',
                                style: TextStyle(
                                    color: C.magenta,
                                    fontWeight: FontWeight.w800)),
                            _player(
                              mark: 'X',
                              name: xName,
                              avatarUrl: xAvatar,
                              active: room.currentTurn == 'X' &&
                                  room.winner == null,
                              isYou: room.myMark == 'X',
                            ),
                          ]),
                      const SizedBox(height: 8),
                      Text(
                          'Stake ${room.stake} · ${args?.roomId.substring(0, 8) ?? ''}…',
                          style: const TextStyle(
                              color: C.muted, fontSize: 12)),
                      Expanded(
                          child: Center(
                              child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Column(children: [
                                    for (var r = 0; r < n; r++)
                                      Expanded(
                                          child: Row(children: [
                                        for (var c = 0; c < n; c++)
                                          Expanded(
                                              child: _cell(
                                                  room, r * n + c)),
                                      ])),
                                  ])))),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: double.infinity,
                          child: GhostButton(
                              room.isFinished
                                  ? 'Back to home'
                                  : 'Leave game',
                              onTap: _leave)),
                    ]),
                    // Ludo-style bursts near the sender's seat.
                    for (final b in _bursts)
                      MatchEmojiBurstOverlay(
                        burst: b,
                        onLeft: b.fromMe
                            ? room.myMark == 'O'
                            : room.myMark != 'O',
                      ),
                    if (showChat && !room.isFinished)
                      Positioned(
                        right: 4,
                        bottom: 70,
                        child: MatchEmojiLauncher(
                          onPick: _sendReact,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
