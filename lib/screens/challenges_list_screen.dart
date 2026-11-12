import 'package:flutter/material.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 6 — Challenges Received / Sent / History.
class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  int tab = 0;

  void _goLobby(ChallengeItem c) {
    Navigator.pushNamed(
      context,
      '/match-lobby',
      arguments: {
        'opponentName': c.opponentName,
        'opponentId': c.opponentId,
        'stakeLabel': c.stakeLabel,
      },
    );
  }

  Widget _row(ChallengeItem c, {required bool canAccept}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Row(
        children: [
          PdfGradientAvatar(
            c.opponentName.isNotEmpty ? c.opponentName[0] : '?',
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.opponentName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                Text(
                  c.status == ChallengeItemStatus.pending
                      ? '${c.stakeLabel} · ${c.secondsLeft}s left'
                      : '${c.stakeLabel} · ${c.status.name}',
                  style: const TextStyle(color: C.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          if (canAccept && c.status == ChallengeItemStatus.pending) ...[
            PdfTealButton('Accept', compact: true, onTap: () {
              ChallengeFlowService.accept(c.id);
              _goLobby(c);
            }),
            const SizedBox(width: 8),
            PdfDeclineBox(onTap: () => ChallengeFlowService.decline(c.id)),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<List<ChallengeItem>>(
        valueListenable: ChallengeFlowService.items,
        builder: (_, __, ___) {
          final lists = [
            ChallengeFlowService.received(),
            ChallengeFlowService.sent(),
            ChallengeFlowService.history(),
          ];
          final rows = lists[tab];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar('Challenges'),
              const SizedBox(height: 12),
              PdfSegRow(
                options: const ['Received', 'Sent', 'History'],
                selected: tab,
                onChanged: (i) => setState(() => tab = i),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (rows.isEmpty)
                      const AppCard(
                        child: Text('No challenges here.',
                            style: TextStyle(color: C.muted)),
                      )
                    else
                      for (final c in rows)
                        _row(c, canAccept: tab == 0 && !c.outgoing),
                    if (tab == 0) ...[
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'Expired challenges move to History.',
                          style: TextStyle(color: C.muted, fontSize: 12),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    PdfGhostButton(
                      'Simulate incoming challenge',
                      onTap: () {
                        final c = ChallengeFlowService.simulateIncoming(
                          fromId: 'demo-opp',
                          fromName: 'diployteam',
                          rank: 1,
                          score: 76,
                        );
                        Navigator.pushNamed(context, '/challenge-incoming',
                            arguments: c);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
