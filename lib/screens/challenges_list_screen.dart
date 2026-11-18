import 'package:flutter/material.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF page 6 — Challenges Received / Sent / History.
class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  int tab = 0;

  void _goLobby(ChallengeItem c) {
    Navigator.pushNamed(context, '/match-lobby', arguments: c.lobbyArgs());
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
                      ? '${c.stakeLabel} · ${context.l10n.secondsLeft('${c.secondsLeft}')}'
                      : '${c.stakeLabel} · ${c.status.name}',
                  style: const TextStyle(color: C.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          if (canAccept && c.status == ChallengeItemStatus.pending) ...[
            PdfTealButton(context.l10n.accept, compact: true, onTap: () async {
              try {
                final acc = await ChallengeFlowService.accept(c.id);
                if (!mounted) return;
                _goLobby(acc ?? c);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$e'.replaceFirst('Exception: ', '')),
                  ),
                );
              }
            }),
            const SizedBox(width: 8),
            PdfDeclineBox(
              onTap: () => ChallengeFlowService.decline(c.id),
            ),
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
              TopBar(context.l10n.challenges),
              const SizedBox(height: 12),
              PdfSegRow(
                options: [
                  context.l10n.received,
                  context.l10n.sent,
                  context.l10n.history
                ],
                selected: tab,
                onChanged: (i) => setState(() => tab = i),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    if (rows.isEmpty)
                      AppCard(
                        child: Text(context.l10n.noChallengesHere,
                            style: const TextStyle(color: C.muted)),
                      )
                    else
                      for (final c in rows)
                        _row(c, canAccept: tab == 0 && !c.outgoing),
                    if (tab == 0) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          context.l10n.expiredMoveToHistory,
                          style: const TextStyle(color: C.muted, fontSize: 12),
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
