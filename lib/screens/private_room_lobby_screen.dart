import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/online_realtime_service.dart';
import '../services/private_room_service.dart';
import '../services/qr_code_service.dart';
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
  bool _ready = false;
  bool _busy = false;
  bool _navigated = false;
  Timer? _poll;

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
    _ready = true;
    OnlineRealtimeService.state.addListener(_onState);
    OnlineRealtimeService.attach(roomId);
    // Safety net if Realtime update is delayed / missed.
    _poll = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_navigated) return;
      OnlineRealtimeService.refresh();
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
    OnlineRealtimeService.state.removeListener(_onState);
    OnlineRealtimeService.detach().then((_) {
      if (!mounted) return;
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

  @override
  void dispose() {
    _poll?.cancel();
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
    return AppScaffold(
      child: ValueListenableBuilder(
        valueListenable: OnlineRealtimeService.state,
        builder: (_, room, __) {
          final status = room?.roomStatus ?? 'waiting';
          return SingleChildScrollView(
            child: staggered([
              const TopBar('Private room'),
              AppCard(
                borderColor: C.magenta,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Tag('Waiting for opponent'),
                    const SizedBox(height: 8),
                    const Heading('Share this code', size: 22),
                    const SizedBox(height: 14),
                    Center(
                      child: SelectableText(
                        code,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: QrImageView(
                          data: QrCodeService.encodeRoomCode(code),
                          version: QrVersions.auto,
                          size: 180,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Same code as above — scan to join',
                        style: TextStyle(color: C.muted, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton('Copy code', onTap: _busy ? null : _copy),
                    const SizedBox(height: 10),
                    GhostButton('Share code', onTap: _busy ? null : _share),
                    const SizedBox(height: 12),
                    Text(
                      'Board ${boardSize}×$boardSize · Stake $stake\n'
                      'Status: $status',
                      style: const TextStyle(color: C.muted, height: 1.4),
                    ),
                  ],
                ),
              ),
              GhostButton(_busy ? 'Cancelling…' : 'Cancel room',
                  onTap: _busy ? null : _cancel),
            ], gap: 16),
          );
        },
      ),
    );
  }
}
