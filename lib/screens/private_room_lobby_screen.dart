import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/online_realtime_service.dart';
import '../services/private_room_service.dart';
import '../services/qr_code_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Host waits here until opponent joins (Realtime → active).
class PrivateRoomLobbyScreen extends StatefulWidget {
  const PrivateRoomLobbyScreen({super.key});
  @override
  State<PrivateRoomLobbyScreen> createState() => _PrivateRoomLobbyScreenState();
}

class _PrivateRoomLobbyScreenState extends State<PrivateRoomLobbyScreen> {
  late final String roomId;
  late final String code;
  late final int boardSize;
  late final int stake;
  DateTime? expiresAt;
  bool _ready = false;
  bool _busy = false;
  bool _navigated = false;
  Timer? _poll;
  Timer? _tick;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is! Map) return;
    roomId = '${arg['roomId']}';
    code = '${arg['code']}';
    boardSize = (arg['boardSize'] as num?)?.toInt() ?? 3;
    stake = (arg['stake'] as num?)?.toInt() ?? 10;
    expiresAt = DateTime.tryParse('${arg['expiresAt'] ?? ''}');
    _ready = true;
    OnlineRealtimeService.state.addListener(_onState);
    OnlineRealtimeService.attach(roomId);
    _poll = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_navigated) return;
      OnlineRealtimeService.refresh();
    });
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _onState() {
    final s = OnlineRealtimeService.state.value;
    if (s == null || _navigated) return;
    final ready = s.hasOpponent &&
        (s.roomStatus == 'active' || s.roomStatus == 'matched');
    if (ready) {
      _goGame(s.roomId, s.myMark, s.opponentId, s.boardSize, s.stake);
      return;
    }
    if (s.roomStatus == 'expired' || s.roomStatus == 'cancelled') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(s.roomStatus == 'expired'
              ? 'Room expired'
              : 'Room cancelled')));
    }
  }

  void _goGame(
    String id,
    String mark,
    String opponent,
    int size,
    int st,
  ) {
    if (_navigated || !mounted) return;
    _navigated = true;
    _poll?.cancel();
    _tick?.cancel();
    OnlineRealtimeService.state.removeListener(_onState);
    OnlineRealtimeService.detach().then((_) {
      if (!mounted) return;
      SfxService.play(Sfx.matchFound);
      Navigator.pushReplacementNamed(
        context,
        '/online-room',
        arguments: OnlineRoomArgs(
          roomId: id,
          myMark: mark,
          opponentId: opponent,
          boardSize: size,
          stake: st,
        ),
      );
    });
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room code copied')));
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(
        ClipboardData(text: QrCodeService.shareLinkForCode(code)));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link copied')));
  }

  Future<void> _share() async {
    try {
      await QrCodeService.shareRoomCode(code);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.messageFromError(e))));
    }
  }

  Future<void> _cancel() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await PrivateRoomService.cancel(roomId);
      await OnlineRealtimeService.detach();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.messageFromError(e))));
      setState(() => _busy = false);
    }
  }

  String _closesInLabel() {
    final end = expiresAt;
    if (end == null) return 'Room closes soon if nobody joins.';
    final left = end.difference(DateTime.now());
    if (left.isNegative) return 'Room is closing…';
    final m = left.inMinutes.clamp(0, 99);
    final s = left.inSeconds.remainder(60).clamp(0, 59);
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return 'Room closes in $mm:$ss if nobody joins.';
  }

  @override
  void dispose() {
    _poll?.cancel();
    _tick?.cancel();
    OnlineRealtimeService.state.removeListener(_onState);
    if (!_navigated) {
      OnlineRealtimeService.detach();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const AppScaffold(
          child: Center(child: CircularProgressIndicator()));
    }
    final link = QrCodeService.shareLinkForCode(code);
    return AppScaffold(
      child: ValueListenableBuilder(
        valueListenable: OnlineRealtimeService.state,
        builder: (_, room, __) {
          final status = room?.roomStatus ?? 'waiting';
          final open = status == 'waiting' ||
              status == 'open' ||
              status == 'matched' ||
              status == 'active';
          return Column(
            children: [
              Row(
                children: [
                  RoundIconBox(
                    Icons.arrow_back_ios_new_rounded,
                    label: 'Back',
                    onTap: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'PRIVATE ROOM',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF143832),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      open ? 'ROOM OPEN' : status.toUpperCase(),
                      style: const TextStyle(
                        color: C.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: C.magenta, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'ROOM CODE',
                              style: TextStyle(
                                color: C.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  code,
                                  style: const TextStyle(
                                    color: C.teal,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Material(
                                  color: C.surface2,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: _busy ? null : _copy,
                                    borderRadius: BorderRadius.circular(12),
                                    child: const SizedBox(
                                      width: 42,
                                      height: 42,
                                      child: Icon(Icons.copy_rounded, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: QrImageView(
                                data: QrCodeService.encodeRoomCode(code),
                                version: QrVersions.auto,
                                size: 190,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Scan to join, or share the link',
                              style: TextStyle(
                                color: C.muted,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Material(
                              color: C.surface2,
                              borderRadius: BorderRadius.circular(99),
                              child: InkWell(
                                onTap: _busy ? null : _copyLink,
                                borderRadius: BorderRadius.circular(99),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Text(
                                    link.replaceFirst('https://', ''),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: C.teal,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      decorationColor: C.teal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: C.surface2,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: C.border),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'JOIN',
                                    style: TextStyle(
                                      color: C.magenta,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    code,
                                    style: const TextStyle(
                                      color: C.teal,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const Icon(Icons.qr_code_2,
                                      size: 18, color: C.muted),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invite image',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Code, QR and link in one picture. Send it on WhatsApp or anywhere.',
                                    style: TextStyle(
                                      color: C.muted,
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: _busy ? null : _share,
                          style: FilledButton.styleFrom(
                            backgroundColor: C.magenta,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.ios_share_rounded, size: 20),
                          label: const Text(
                            'SHARE INVITE',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: C.teal,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Waiting for a friend...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _closesInLabel(),
                                    style: const TextStyle(
                                      color: C.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _busy ? null : _cancel,
                        child: Text(
                          _busy ? 'Closing…' : 'Close room',
                          style: const TextStyle(
                            color: C.danger,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
