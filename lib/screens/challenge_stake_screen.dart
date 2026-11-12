import 'package:flutter/material.dart';
import '../models.dart';
import '../models/challenge_args.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 3 — Challenge stakes (visual match).
class ChallengeStakeScreen extends StatefulWidget {
  const ChallengeStakeScreen({super.key});

  @override
  State<ChallengeStakeScreen> createState() => _ChallengeStakeScreenState();
}

class _ChallengeStakeScreenState extends State<ChallengeStakeScreen> {
  int _stakeIndex = 0;

  ChallengeStakeArgs? get _args {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ChallengeStakeArgs ? a : null;
  }

  void _send() {
    final args = _args;
    if (args == null) return;
    final kind = _stakeIndex == 0
        ? ChallengeStakeKind.free
        : ChallengeStakeKind.coins5;
    try {
      final c = ChallengeFlowService.send(
        opponentId: args.opponentId,
        opponentName: args.opponentName,
        avatarUrl: args.avatarUrl,
        rank: args.rank,
        score: args.score,
        stake: kind,
      );
      Navigator.pushReplacementNamed(context, '/challenge-waiting',
          arguments: c);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'.replaceFirst('Exception: ', ''))),
      );
    }
  }

  Widget _stakeCard({
    required bool selected,
    required String title,
    required String subtitle,
    Widget? titleLeading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? C.magenta : C.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (titleLeading != null) ...[
                  titleLeading,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: C.muted, fontSize: 13, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;
    if (args == null) {
      return const AppScaffold(
        child: Center(child: Text('Missing challenge data')),
      );
    }

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(
            'Challenge',
            trailing: ValueListenableBuilder<int>(
              valueListenable: coins,
              builder: (_, c, __) => PdfCoinChip(c),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.border),
            ),
            child: Row(
              children: [
                PdfGradientAvatar(
                  args.opponentName.isNotEmpty ? args.opponentName[0] : '?',
                  size: 52,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.opponentName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Rank #${args.rank} · Score ${args.score}',
                        style: const TextStyle(color: C.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const PdfSectionLabel('Match stakes'),
          const SizedBox(height: 10),
          _stakeCard(
            selected: _stakeIndex == 0,
            title: 'Free match',
            subtitle: '3 free matches per day',
            onTap: () => setState(() => _stakeIndex = 0),
          ),
          const SizedBox(height: 10),
          _stakeCard(
            selected: _stakeIndex == 1,
            title: '5 coins entry fee',
            titleLeading: const Icon(Icons.diamond, color: C.teal, size: 18),
            subtitle:
                'Used after free matches run out, or to raise the stakes.',
            onTap: () => setState(() => _stakeIndex = 1),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Challenge expires in 60 seconds if not accepted.',
              style: TextStyle(color: C.muted, fontSize: 13),
            ),
          ),
          const Spacer(),
          PdfPinkButton('Send challenge', onTap: _send),
          const SizedBox(height: 10),
          SizedBox(
            height: 54,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: C.text,
                side: const BorderSide(color: C.border2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
