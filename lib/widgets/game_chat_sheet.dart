import 'dart:async';

import 'package:flutter/material.dart';
import '../models/game_chat_message.dart';
import '../services/auth_service.dart';
import '../services/game_chat_service.dart';
import '../services/online_realtime_service.dart';
import '../theme.dart';
import 'extras.dart';
import 'pdf_ui.dart';
import 'report_user_sheet.dart';

const _quickReplies = ['Good move!', 'Close one!', 'GG', 'Rematch?'];

/// Opens in-game chat bottom sheet matching PDF live-chat design.
Future<void> openGameChatSheet(
  BuildContext context, {
  required String roomId,
  String opponentName = 'Opponent',
  String? opponentId,
  String? opponentAvatarUrl,
  String? myAvatarUrl,
  String myMark = 'X',
  String opponentMark = 'O',
}) {
  GameChatService.setSheetOpen(true);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: Container(
        height: MediaQuery.sizeOf(ctx).height * 0.82,
        decoration: const BoxDecoration(
          color: C.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: GameChatPanel(
          roomId: roomId,
          opponentName: opponentName,
          opponentId: opponentId,
          opponentAvatarUrl: opponentAvatarUrl,
          myAvatarUrl: myAvatarUrl,
          myMark: myMark,
          opponentMark: opponentMark,
        ),
      ),
    ),
  ).whenComplete(() => GameChatService.setSheetOpen(false));
}

class GameChatPanel extends StatefulWidget {
  final String roomId;
  final String opponentName;
  final String? opponentId;
  final String? opponentAvatarUrl;
  final String? myAvatarUrl;
  final String myMark;
  final String opponentMark;

  const GameChatPanel({
    super.key,
    required this.roomId,
    this.opponentName = 'Opponent',
    this.opponentId,
    this.opponentAvatarUrl,
    this.myAvatarUrl,
    this.myMark = 'X',
    this.opponentMark = 'O',
  });

  @override
  State<GameChatPanel> createState() => _GameChatPanelState();
}

class _GameChatPanelState extends State<GameChatPanel> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;
  bool _showReportTip = true;
  Timer? _reportTipTimer;

  @override
  void initState() {
    super.initState();
    GameChatService.attach(widget.roomId);
    GameChatService.markRead();
    GameChatService.messages.addListener(_stickToBottom);
    OnlineRealtimeService.state.addListener(_onRoomMeta);
    // Tip only for 2s; Report button stays.
    _reportTipTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || !_showReportTip) return;
      setState(() => _showReportTip = false);
    });
  }

  @override
  void dispose() {
    _reportTipTimer?.cancel();
    OnlineRealtimeService.state.removeListener(_onRoomMeta);
    GameChatService.messages.removeListener(_stickToBottom);
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onRoomMeta() {
    final room = OnlineRealtimeService.state.value;
    if (room == null || room.roomId != widget.roomId) return;
    if (!room.chatStopped || !mounted) return;
    // Opponent (or this device) stopped chat — close sheet once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && route.isCurrent) {
        Navigator.of(context).maybePop();
      }
    });
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

  Future<void> _send([String? preset]) async {
    if (_sending) return;
    final text = (preset ?? _input.text).trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    final ok = await GameChatService.send(text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok && preset == null) _input.clear();
  }

  Future<void> _stopChat() async {
    final ok = await GameChatService.stopChat();
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            GameChatService.error.value ?? 'Could not stop chat',
          ),
        ),
      );
      return;
    }
    // Pop first so this sheet's room listener is disposed, then flag UI.
    Navigator.pop(context);
    OnlineRealtimeService.markChatStopped();
  }

  @override
  Widget build(BuildContext context) {
    final myId = AuthService.user?.id;
    final opp = widget.opponentName.trim().isEmpty
        ? 'Opponent'
        : widget.opponentName.trim();
    final oppLetter = opp[0].toUpperCase();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          children: [
            _PlayerHeader(
              opponentName: opp,
              oppLetter: oppLetter,
              myMark: widget.myMark,
              opponentMark: widget.opponentMark,
              myAvatarUrl: widget.myAvatarUrl,
              opponentAvatarUrl: widget.opponentAvatarUrl,
            ),
            const SizedBox(height: 14),
            _StatusRow(
              showReportTip: _showReportTip,
              onDismissTip: () => setState(() => _showReportTip = false),
              onReport: () {
                setState(() => _showReportTip = false);
                openReportUserSheet(
                  context,
                  roomId: widget.roomId,
                  opponentName: widget.opponentName,
                  opponentId: widget.opponentId,
                );
              },
              onStop: _stopChat,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: C.teal, width: 1.5),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: GameChatService.loading,
                        builder: (_, loading, __) =>
                            ValueListenableBuilder<List<GameChatMessage>>(
                          valueListenable: GameChatService.messages,
                          builder: (_, msgs, ___) {
                            if (loading && msgs.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: C.magenta,
                                ),
                              );
                            }
                            if (msgs.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No messages yet.\nQuick replies work too.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: C.muted),
                                ),
                              );
                            }
                            return ListView.builder(
                              controller: _scroll,
                              itemCount: msgs.length,
                              itemBuilder: (_, i) {
                                final m = msgs[i];
                                return _PdfBubble(
                                  message: m,
                                  mine: m.isMine(myId),
                                  myUid: myId,
                                  enabled: true,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Messages stay for this match',
                      style: TextStyle(
                        color: C.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final q in _quickReplies) ...[
                    _ChatQuickChip(
                      q,
                      onTap: () => _send(q),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: GameChatService.connected,
              builder: (_, live, __) => ValueListenableBuilder<String?>(
                valueListenable: GameChatService.error,
                builder: (_, err, ___) {
                  if (err != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        err,
                        style: const TextStyle(
                          color: C.magenta,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                  if (!live) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Text(
                        'Connecting chat… (polling active)',
                        style: TextStyle(color: C.muted, fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      controller: _input,
                      enabled: !_sending,
                      maxLength: 500,
                      style: const TextStyle(
                        color: C.text,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Type a message',
                        hintStyle: const TextStyle(
                          color: C.muted,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: C.surface2,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 72,
                  height: 48,
                  child: Material(
                    color: C.magenta,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: _sending ? null : () => _send(),
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: Text(
                          _sending ? '…' : 'Send',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final String opponentName;
  final String oppLetter;
  final String myMark;
  final String opponentMark;
  final String? myAvatarUrl;
  final String? opponentAvatarUrl;

  const _PlayerHeader({
    required this.opponentName,
    required this.oppLetter,
    required this.myMark,
    required this.opponentMark,
    this.myAvatarUrl,
    this.opponentAvatarUrl,
  });

  Widget _avatar(String letter, String? url) {
    final u = url?.trim();
    if (u != null && u.isNotEmpty) {
      return ClipOval(
        child: ProfileAvatar(url: u, size: 46),
      );
    }
    return PdfGradientAvatar(letter, size: 46);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _avatar('Y', myAvatarUrl),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: C.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                myMark,
                style: TextStyle(
                  color: myMark == 'O' ? C.teal : C.magenta,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                opponentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: C.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                opponentMark,
                style: TextStyle(
                  color: opponentMark == 'O' ? C.teal : C.magenta,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _avatar(oppLetter, opponentAvatarUrl),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  final bool showReportTip;
  final VoidCallback onDismissTip;
  final VoidCallback onReport;
  final VoidCallback onStop;

  const _StatusRow({
    required this.showReportTip,
    required this.onDismissTip,
    required this.onReport,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: C.teal,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Chat on',
              style: TextStyle(
                color: C.teal,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            _ReportFlagButton(onTap: onReport),
            const SizedBox(width: 8),
            SizedBox(
              height: 42,
              child: OutlinedButton(
                onPressed: onStop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: C.danger,
                  side: const BorderSide(color: C.magenta, width: 1.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text(
                  'Stop chat',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showReportTip) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              // Align tip under the flag (leave room for Stop chat ~110px).
              padding: const EdgeInsets.only(right: 100),
              child: GestureDetector(
                onTap: onDismissTip,
                child: const _ReportTipBubble(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ReportFlagButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ReportFlagButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: C.magenta.withValues(alpha: 0.75),
            blurRadius: 14,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: C.magenta.withValues(alpha: 0.35),
            blurRadius: 22,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: C.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.magenta, width: 1.5),
            ),
            child: const Icon(
              Icons.flag_outlined,
              color: C.text,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportTipBubble extends StatelessWidget {
  const _ReportTipBubble();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Caret pointing up at the flag button.
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: CustomPaint(
            size: const Size(14, 8),
            painter: _TipCaretPainter(C.magenta),
          ),
        ),
        Container(
          width: 236,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.magenta, width: 1.5),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REPORT BUTTON',
                style: TextStyle(
                  color: C.magenta,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Top right of the live chat, next to Stop chat. Always visible while chat is on.\nTap → pick a reason → add details and screenshots → submit.',
                style: TextStyle(
                  color: C.text,
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipCaretPainter extends CustomPainter {
  final Color color;
  _TipCaretPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = C.surface;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ChatQuickChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _ChatQuickChip(this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.surface2,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border2),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: C.text,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfBubble extends StatelessWidget {
  final GameChatMessage message;
  final bool mine;
  final String? myUid;
  final bool enabled;

  const _PdfBubble({
    required this.message,
    required this.mine,
    required this.myUid,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final reacts = message.reactions.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: !enabled
                ? null
                : () async {
                    final emoji = await showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: C.surface,
                      builder: (ctx) => SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final e in GameChatMessage.allowedEmojis)
                                InkWell(
                                  onTap: () => Navigator.pop(ctx, e),
                                  child: Text(e,
                                      style: const TextStyle(fontSize: 28)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (emoji != null) {
                      await GameChatService.toggleReaction(
                        messageId: message.id,
                        emoji: emoji,
                      );
                    }
                  },
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.68,
              ),
              decoration: BoxDecoration(
                color: mine ? const Color(0xFF5A1840) : C.surface2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.message,
                style: const TextStyle(
                  color: C.text,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (reacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 4,
                children: [
                  for (final e in reacts)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: C.surface2,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: (myUid != null && e.value.contains(myUid))
                              ? C.teal
                              : C.border2,
                        ),
                      ),
                      child: Text(
                        '${e.key} ${e.value.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}
