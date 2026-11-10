import 'package:flutter/material.dart';
import '../models/multiplayer_match.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// C1 → C2/C3 integration boundary.
/// Matchmaking succeeded; Realtime board / turns arrive in later phases.
class OnlineRoomPlaceholderScreen extends StatelessWidget {
  const OnlineRoomPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final room = args is OnlineRoomArgs
        ? args
        : const OnlineRoomArgs(
            roomId: '—',
            myMark: 'O',
            opponentId: '—',
            boardSize: 3,
            stake: 0,
          );

    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Online room'),
          AppCard(
            borderColor: C.magenta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Tag('Match found'),
                const SizedBox(height: 8),
                const Heading("You're matched", size: 22),
                const SizedBox(height: 8),
                Text('Room ${room.roomId}',
                    style: const TextStyle(color: C.muted, fontSize: 13)),
                const SizedBox(height: 14),
                _row('You play as', room.myMark),
                _row('Board', '${room.boardSize}×${room.boardSize}'),
                _row('Stake', '${room.stake}'),
                _row('Opponent', room.opponentId),
                const SizedBox(height: 12),
                const Text(
                  'Realtime sync, turns, and results land in C2–C5. '
                  'This screen confirms C1 matchmaking only.',
                  style: TextStyle(color: C.muted, height: 1.4),
                ),
              ],
            ),
          ),
          PrimaryButton('Back to home',
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (r) => false)),
        ], gap: 16),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(
                width: 100,
                child: Text(k, style: const TextStyle(color: C.muted))),
            Expanded(
                child: Text(v,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
          ],
        ),
      );
}
