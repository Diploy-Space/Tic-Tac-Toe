import 'package:flutter/material.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/private_room_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class JoinPrivateRoomScreen extends StatefulWidget {
  const JoinPrivateRoomScreen({super.key});
  @override
  State<JoinPrivateRoomScreen> createState() => _JoinPrivateRoomScreenState();
}

class _JoinPrivateRoomScreenState extends State<JoinPrivateRoomScreen> {
  final _code = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Future<void> _join() async {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) {
      _toast('Enter a room code');
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final res = await PrivateRoomService.join(code);
      if (!mounted) return;
      if (!res.isMatched || res.roomId == null) {
        _toast(res.message ?? 'Could not join room');
        setState(() => _busy = false);
        return;
      }
      Navigator.pushReplacementNamed(
        context,
        '/online-room',
        arguments: OnlineRoomArgs.fromMatch(res),
      );
    } catch (e) {
      if (!mounted) return;
      _toast(AuthService.messageFromError(e));
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ScrollFill(
        child: staggered([
          const TopBar('Join room'),
          const Heading('Enter room code'),
          const Text(
            'Ask your friend for their 6-character code.',
            style: TextStyle(color: C.muted, height: 1.4),
          ),
          AppField(
            icon: Icons.tag,
            hint: 'Room code',
            controller: _code,
            obscure: false,
            obscureToggle: false,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _join(),
          ),
          PrimaryButton(_busy ? 'Joining…' : 'Join room',
              onTap: _busy ? null : _join),
        ]),
      ),
    );
  }
}
