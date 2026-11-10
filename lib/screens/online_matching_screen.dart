import 'dart:async';
import 'package:flutter/material.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/multiplayer_matchmaking_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// Real online matchmaking UI (separate from AI [MatchingScreen]).
class OnlineMatchingScreen extends StatefulWidget {
  const OnlineMatchingScreen({super.key});
  @override
  State<OnlineMatchingScreen> createState() => _OnlineMatchingScreenState();
}

class _OnlineMatchingScreenState extends State<OnlineMatchingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2400))
    ..repeat();

  Timer? _poll;
  int _sec = 0;
  bool _leaving = false;
  bool _navigated = false;
  String _phase = 'joining'; // joining | searching | error
  String? _error;
  int _boardSize = 3;
  int _stake = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map) {
      _boardSize = (arg['boardSize'] as num?)?.toInt() ?? 3;
      _stake = (arg['stake'] as num?)?.toInt() ?? 10;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    if (!AuthService.isSignedIn) {
      setState(() {
        _phase = 'error';
        _error = 'Sign in required for online matchmaking';
      });
      return;
    }

    setState(() {
      _phase = 'joining';
      _error = null;
    });

    final joined = await MultiplayerMatchmakingService.join(
      boardSize: _boardSize,
      stake: _stake,
    );
    if (!mounted || _leaving) return;

    if (joined.isMatched) {
      _goRoom(joined);
      return;
    }
    if (joined.isError) {
      setState(() {
        _phase = 'error';
        _error = joined.message ?? 'Matchmaking failed';
      });
      return;
    }

    setState(() => _phase = 'searching');
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  Future<void> _onTick() async {
    if (!mounted || _leaving || _navigated) return;
    setState(() => _sec++);

    final status = await MultiplayerMatchmakingService.poll();
    if (!mounted || _leaving || _navigated) return;

    if (status.isMatched) {
      _poll?.cancel();
      _goRoom(status);
      return;
    }
    if (status.isTimeout) {
      _poll?.cancel();
      setState(() {
        _phase = 'error';
        _error = 'No opponent found — try again';
      });
      return;
    }
    if (status.isError) {
      _poll?.cancel();
      setState(() {
        _phase = 'error';
        _error = status.message ?? 'Matchmaking error';
      });
    }
  }

  void _goRoom(MatchmakingStatus m) {
    if (_navigated || !mounted) return;
    _navigated = true;
    _poll?.cancel();
    Navigator.pushReplacementNamed(
      context,
      '/online-room',
      arguments: OnlineRoomArgs.fromMatch(m),
    );
  }

  Future<void> _cancel() async {
    if (_leaving) return;
    _leaving = true;
    _poll?.cancel();
    await MultiplayerMatchmakingService.leave();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _poll?.cancel();
    _c.dispose();
    // Best-effort leave if user backs out without Cancel.
    if (!_navigated && !_leaving) {
      MultiplayerMatchmakingService.leave();
    }
    super.dispose();
  }

  Widget _ring(double phase) => AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final v = (_c.value + phase) % 1.0;
        return Opacity(
            opacity: (1 - v) * .9,
            child: Transform.scale(
                scale: .45 + .55 * v,
                child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: C.magenta, width: 2)))));
      });

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (_phase) {
      'joining' => 'Joining queue…',
      'searching' =>
        'Online · ${_boardSize}×$_boardSize · stake $_stake · 0:${_sec.toString().padLeft(2, '0')}',
      'error' => _error ?? 'Something went wrong',
      _ => '',
    };

    return AppScaffold(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: C.border2)),
              child: Text('Online · Stake $_stake',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          const CoinChip(),
        ]),
        Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: 250,
              height: 250,
              child: Stack(alignment: Alignment.center, children: [
                if (_phase != 'error') ...[_ring(0), _ring(.33), _ring(.66)],
                Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.surface,
                        border: Border.all(color: C.magenta, width: 2)),
                    child: const Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: PlayerFace(size: 90))),
              ])),
          const SizedBox(height: 22),
          Heading(
            _phase == 'error' ? 'Matchmaking stopped' : 'Finding a player',
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: C.muted)),
          if (_phase == 'error') ...[
            const SizedBox(height: 18),
            PrimaryButton('Try again', onTap: () {
              _leaving = false;
              _navigated = false;
              _sec = 0;
              _start();
            }),
          ],
        ])),
        SizedBox(
            width: double.infinity,
            child: GhostButton(
              _phase == 'error' ? 'Back' : 'Cancel',
              onTap: _cancel,
            )),
      ]),
    );
  }
}
