import 'package:flutter/material.dart';
import '../models/game_chat_message.dart';
import '../services/auth_service.dart';
import '../services/game_chat_service.dart';
import '../theme.dart';
import 'extras.dart';
import 'report_user_sheet.dart';

/// Opens in-game chat bottom sheet for a real PvP room.
Future<void> openGameChatSheet(BuildContext context, {required String roomId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: C.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(ctx).height * 0.62,
        child: GameChatPanel(roomId: roomId),
      ),
    ),
  );
}

class GameChatPanel extends StatefulWidget {
  final String roomId;
  const GameChatPanel({super.key, required this.roomId});

  @override
  State<GameChatPanel> createState() => _GameChatPanelState();
}

class _GameChatPanelState extends State<GameChatPanel> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    GameChatService.attach(widget.roomId);
    GameChatService.messages.addListener(_stickToBottom);
  }

  @override
  void dispose() {
    GameChatService.messages.removeListener(_stickToBottom);
    // Keep subscription while game screen is open; OnlineGameScreen owns detach.
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _stickToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    if (_sending) return;
    final text = _input.text;
    if (text.trim().isEmpty) return;
    setState(() => _sending = true);
    final ok = await GameChatService.send(text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) _input.clear();
  }

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final myId = AuthService.user?.id;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: C.border2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text('Match chat',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: GameChatService.connected,
                builder: (_, live, __) => Text(
                  live ? 'Live' : 'Connecting…',
                  style: TextStyle(
                    color: live ? C.teal : C.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => openReportUserSheet(
                  context,
                  roomId: widget.roomId,
                ),
                child: const Text('Report',
                    style: TextStyle(
                        color: C.danger,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: C.muted),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: GameChatService.error,
          builder: (_, err, __) {
            if (err == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(err,
                  style: const TextStyle(color: C.magenta, fontSize: 12)),
            );
          },
        ),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: GameChatService.loading,
            builder: (_, loading, __) => ValueListenableBuilder<List<GameChatMessage>>(
              valueListenable: GameChatService.messages,
              builder: (_, msgs, ___) {
                if (loading && msgs.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (msgs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet.\nSay hi to your opponent.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: C.muted),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scroll,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i];
                    final mine = m.isMine(myId);
                    return _Bubble(
                      message: m,
                      mine: mine,
                      time: _time(m.createdAt),
                    );
                  },
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(color: C.text),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Type a message…',
                    hintStyle: const TextStyle(color: C.muted),
                    filled: true,
                    fillColor: C.bg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: C.border2),
                    ),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              SmallButton(
                _sending ? '…' : 'Send',
                onTap: _sending ? null : _send,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final GameChatMessage message;
  final bool mine;
  final String time;

  const _Bubble({
    required this.message,
    required this.mine,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final align = mine ? Alignment.centerRight : Alignment.centerLeft;
    final bg = mine ? C.magenta.withValues(alpha: 0.25) : C.bg;
    final border = mine ? C.magenta : C.border2;
    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _pickReaction(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mine ? 'You' : 'Opponent',
                        style: TextStyle(
                          color: mine ? C.pinkText : C.teal,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(message.message,
                          style: const TextStyle(color: C.text, height: 1.35)),
                      const SizedBox(height: 4),
                      Text(time,
                          style:
                              const TextStyle(color: C.muted, fontSize: 10)),
                    ],
                  ),
                ),
              ),
              if (message.reactions.isNotEmpty) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: [
                    for (final e in message.reactions.entries)
                      if (e.value.isNotEmpty)
                        GestureDetector(
                          onTap: () => GameChatService.toggleReaction(
                            messageId: message.id,
                            emoji: e.key,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: C.surface2,
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: C.border2),
                            ),
                            child: Text(
                              '${e.key} ${e.value.length}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickReaction(BuildContext context) async {
    final emoji = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: C.surface,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final e in GameChatMessage.allowedEmojis)
                InkWell(
                  onTap: () => Navigator.pop(ctx, e),
                  child: Text(e, style: const TextStyle(fontSize: 28)),
                ),
            ],
          ),
        ),
      ),
    );
    if (emoji == null) return;
    await GameChatService.toggleReaction(
      messageId: message.id,
      emoji: emoji,
    );
  }
}
