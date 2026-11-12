import 'dart:async';

import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 9 — Connection unstable.
class ConnectionUnstableScreen extends StatefulWidget {
  const ConnectionUnstableScreen({super.key});

  @override
  State<ConnectionUnstableScreen> createState() =>
      _ConnectionUnstableScreenState();
}

class _ConnectionUnstableScreenState extends State<ConnectionUnstableScreen> {
  int _left = 30;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_left <= 1) {
        _t?.cancel();
        Navigator.pushReplacementNamed(context, '/match-abandoned');
        return;
      }
      setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Online'),
          const Spacer(),
          PdfModalCard(
            borderColor: C.danger,
            child: Column(
              children: [
                const Icon(Icons.wifi_off_rounded, size: 48, color: C.danger),
                const SizedBox(height: 14),
                const Text(
                  'CONNECTION UNSTABLE',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Attempting to reconnect…',
                    style: TextStyle(color: C.muted)),
                const SizedBox(height: 18),
                PdfCircularTimer(value: _left, total: 30, size: 110),
                const SizedBox(height: 14),
                const Text(
                  'The board is hidden until you are back.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: C.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const Spacer(),
          PdfGhostButton(
            'Simulate reconnect',
            onTap: () {
              _t?.cancel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// PDF page 10 — Match abandoned.
class MatchAbandonedScreen extends StatelessWidget {
  const MatchAbandonedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const Spacer(),
          PdfModalCard(
            borderColor: C.danger,
            child: Column(
              children: [
                const Icon(Icons.error_outline, size: 48, color: C.danger),
                const SizedBox(height: 14),
                const Text(
                  'MATCH ABANDONED',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Opponent disconnected',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The 30 second grace window has ended. You can claim the win.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: C.muted, height: 1.4),
                ),
                const SizedBox(height: 20),
                PdfPinkButton('Claim victory', onTap: () {
                  Navigator.pushReplacementNamed(context, '/match-result',
                      arguments: {
                        'victory': true,
                        'duration': '01:24',
                        'coins': 5,
                      });
                }),
                const SizedBox(height: 10),
                PdfGhostButton(
                  'Back to menu',
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// PDF page 11 — Match result.
class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final map =
        args is Map ? Map<String, dynamic>.from(args) : <String, dynamic>{};
    final draw = map['draw'] == true;
    final victory = !draw && map['victory'] != false;
    final duration = '${map['duration'] ?? '01:24'}';
    final coinGain = (map['coins'] as num?)?.toInt() ?? 0;

    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Match result'),
          const Spacer(),
          PdfModalCard(
            borderColor: draw
                ? C.border2
                : victory
                    ? C.teal
                    : C.danger,
            child: Column(
              children: [
                Text(
                  draw
                      ? 'DRAW'
                      : victory
                          ? 'VICTORY'
                          : 'DEFEAT',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: draw
                        ? C.text
                        : victory
                            ? C.teal
                            : C.danger,
                  ),
                ),
                const SizedBox(height: 14),
                Text('Match duration $duration',
                    style: const TextStyle(color: C.muted)),
                const SizedBox(height: 8),
                Text(
                  coinGain == 0
                      ? 'Balance ${coins.value}'
                      : 'Coins ${coinGain > 0 ? '+' : ''}$coinGain · Balance ${coins.value}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                if (victory) ...[
                  const SizedBox(height: 8),
                  const Text('Leaderboard updated',
                      style: TextStyle(color: C.muted, fontSize: 13)),
                  const Text('Score +10',
                      style: TextStyle(
                          color: C.coin, fontWeight: FontWeight.w800)),
                ],
              ],
            ),
          ),
          const Spacer(),
          if (victory || draw)
            PdfPinkButton('Rematch', onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/challenges', (r) => r.isFirst);
            }),
          const SizedBox(height: 10),
          PdfGhostButton(
            'Return to main menu',
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (r) => false),
          ),
        ],
      ),
    );
  }
}
