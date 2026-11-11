import 'dart:async';
import 'package:flutter/material.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/multiplayer_matchmaking_service.dart';
import '../services/online_realtime_service.dart';
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
  bool _argsReady = false;
  int _staleRetries = 0;
  String _phase = 'joining'; // joining | searching | error
  String? _error;
  int _boardSize = 3;
  int _stake = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsReady) return;
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is Map) {
      _boardSize = (arg['boardSize'] as num?)?.toInt() ?? 3;
      _stake = (arg['stake'] as num?)?.toInt() ?? 10;
    }
    _argsReady = true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _start();
    });
  }

  Future<void> _start() async {
    if (_leaving || _navigated) return;
    if (!AuthService.isSignedIn) {
      if (!mounted) return;
      setState(() {
        _phase = 'error';
        _error = 'Sign in required for online matchmaking';
      });
      return;
    }

    setState(() {
      _phase = 'joining';
      _error = null;
      _sec = 0;
    });
    debugPrint(
        'OnlineMatching: join start size=$_boardSize stake=$_stake');

    final joined = await MultiplayerMatchmakingService.join(
      boardSize: _boardSize,
      stake: _stake,
    );
    debugPrint(
        'OnlineMatching: join done status=${joined.status} mounted=$mounted leaving=$_leaving');
    if (!mounted || _leaving || _navigated) return;

    if (joined.isMatched) {
      final ok = await _roomStillPlayable(joined.roomId!);
      if (!mounted || _leaving || _navigated) return;
      if (ok) {
        _staleRetries = 0;
        _goRoom(joined);
        return;
      }
      // Stale matched queue → clear and search again (needs SQL 009 leave fix).
      _staleRetries++;
      debugPrint(
          'OnlineMatching: stale matched room, re-queue try=$_staleRetries');
      await MultiplayerMatchmakingService.leave();
      if (!mounted || _leaving || _navigated) return;
      if (_staleRetries >= 3) {
        setState(() {
          _phase = 'error';
          _error =
              'Previous match expired. Apply SQL 009 / try again in a moment.';
        });
        return;
      }
      await _start();
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
    debugPrint('OnlineMatching: searching…');
    _poll?.cancel();
    _poll = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  /// Reject finished / missing rooms left over from a previous session.
  Future<bool> _roomStillPlayable(String roomId) async {
    final snap = await OnlineRealtimeService.fetchSnapshot(roomId);
    final ok = snap != null &&
        snap.winner == null &&
        !snap.isFinished &&
        (snap.roomStatus == 'matched' || snap.roomStatus == 'active') &&
        snap.hasOpponent;
    if (!ok) {
      await OnlineRealtimeService.detach();
    }
    debugPrint(
        'OnlineMatching: room $roomId playable=$ok status=${snap?.roomStatus} winner=${snap?.winner}');
    return ok;
  }

  Future<void> _onTick() async {
    if (!mounted || _leaving || _navigated) return;
    setState(() => _sec++);

    final status = await MultiplayerMatchmakingService.poll();
    if (!mounted || _leaving || _navigated) return;

    if (status.isMatched) {
      _poll?.cancel();
      final ok = await _roomStillPlayable(status.roomId!);
      if (!mounted || _leaving || _navigated) return;
      if (ok) {
        _goRoom(status);
      } else {
        debugPrint('OnlineMatching: poll matched stale room, re-queue');
        await MultiplayerMatchmakingService.leave();
        if (!mounted || _leaving || _navigated) return;
        await _start();
      }
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
    if (_navigated || !mounted || _leaving) return;
    _navigated = true;
    _poll?.cancel();
    Navigator.pushReplacementNamed(
      context,
      '/online-room',
      arguments: OnlineRoomArgs.fromMatch(m),
    );
  }

  Future<void> _cancel() async {
    if (_leaving || _navigated) return;
    _leaving = true;
    _poll?.cancel();
    await MultiplayerMatchmakingService.leave();
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    debugPrint(
        'OnlineMatching: dispose navigated=$_navigated leaving=$_leaving phase=$_phase');
    _poll?.cancel();
    _c.dispose();
    // Best-effort leave only on unexpected teardown (not matched / not cancel).
    if (!_navigated && !_leaving) {
      debugPrint('OnlineMatching: dispose → leave_online_matchmaking');
      unawaited(MultiplayerMatchmakingService.leave());
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
        'Online · ${_boardSize}x$_boardSize · stake $_stake · 0:${_sec.toString().padLeft(2, '0')}',
      'error' => _error ?? 'Something went wrong',
      _ => '',
    };

    // Allow normal back only on error; Cancel button handles leave explicitly.
    // Do not auto-_cancel on framework pop probes (that closed the screen early).
    return PopScope(
      canPop: _phase == 'error' || _leaving,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _leaving = true;
          if (!_navigated) {
            unawaited(MultiplayerMatchmakingService.leave());
          }
        }
      },
      child: AppScaffold(
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: C.border2)),
                child: Text('Online · Stake $_stake',
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            const CoinChip(),
          ]),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SizedBox(
                    width: 250,
                    height: 250,
                    child: Stack(alignment: Alignment.center, children: [
                      if (_phase != 'error') ...[
                        _ring(0),
                        _ring(.33),
                        _ring(.66)
                      ],
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
                  _phase == 'error'
                      ? 'Matchmaking stopped'
                      : 'Finding a player',
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
      ),
    );
  }
}
