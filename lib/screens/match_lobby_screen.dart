import 'dart:async';

import 'package:flutter/material.dart';
import '../models.dart';
import '../models/multiplayer_match.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF page 7 — Match lobby READY / VS / countdown.
class MatchLobbyScreen extends StatefulWidget {
  const MatchLobbyScreen({super.key});

  @override
  State<MatchLobbyScreen> createState() => _MatchLobbyScreenState();
}

class _MatchLobbyScreenState extends State<MatchLobbyScreen> {
  int _count = 3;
  Timer? _t;
  final bool _youReady = true;
  final bool _oppReady = true;

  Map<String, dynamic> get _args {
    final a = ModalRoute.of(context)?.settings.arguments;
    if (a is Map) return Map<String, dynamic>.from(a);
    return const {};
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_count <= 1) {
        _t?.cancel();
        final args = _args;
        final roomId = args['roomId'] as String?;
        if (roomId != null) {
          // Accepted challenge: both players open the same online room.
          SfxService.play(Sfx.matchFound);
          Navigator.pushReplacementNamed(
            context,
            '/online-room',
            arguments: OnlineRoomArgs(
              roomId: roomId,
              myMark: '${args['myMark'] ?? 'O'}',
              opponentId: '${args['opponentId'] ?? ''}',
              boardSize: 3,
              stake: (args['stake'] as int?) ?? 0,
            ),
          );
          return;
        }
        final name = '${args['opponentName'] ?? 'Rival'}';
        Navigator.pushReplacementNamed(
          context,
          '/game',
          arguments: GameArgs(
            size: 3,
            vsAi: true,
            quickMatch: true,
            opponentName: name,
            stake: 0,
          ),
        );
        return;
      }
      setState(() => _count--);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  Widget _seat(String name, bool ready, {required bool you}) {
    return Expanded(
      child: PdfModalCard(
        borderColor: ready ? (you ? C.magenta : C.teal) : C.border,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            PdfGradientAvatar(you ? 'Y' : name, size: 64),
            const SizedBox(height: 10),
            Text(you ? context.l10n.you : name,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              ready ? context.l10n.readyCaps : context.l10n.waitingCaps,
              style: TextStyle(
                color: ready ? C.teal : C.muted,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final opp = '${_args['opponentName'] ?? 'diployteam'}';
    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.matchLobby),
          const Spacer(),
          Row(
            children: [
              _seat('You', _youReady, you: true),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'VS',
                  style: TextStyle(
                    color: C.magenta,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              _seat(opp, _oppReady, you: false),
            ],
          ),
          const SizedBox(height: 28),
          PdfSectionLabel(context.l10n.matchStartsIn),
          const SizedBox(height: 8),
          Text(
            '$_count',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: C.teal,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
