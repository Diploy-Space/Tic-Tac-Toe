import 'dart:async';

import 'package:flutter/material.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 4 — Waiting modal with circular timer.
class ChallengeWaitingScreen extends StatefulWidget {
  const ChallengeWaitingScreen({super.key});

  @override
  State<ChallengeWaitingScreen> createState() => _ChallengeWaitingScreenState();
}

class _ChallengeWaitingScreenState extends State<ChallengeWaitingScreen> {
  Timer? _timer;

  ChallengeItem? get _item {
    final a = ModalRoute.of(context)?.settings.arguments;
    return a is ChallengeItem ? a : null;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final c = _item;
      setState(() {});
      if (c == null) return;
      if (c.status != ChallengeItemStatus.pending || c.secondsLeft <= 0) {
        _timer?.cancel();
        if (c.status == ChallengeItemStatus.expired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Challenge expired')),
          );
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _item;
    final name = c?.opponentName ?? 'Opponent';
    final left = c?.secondsLeft ?? 0;
    final free = c?.stake == ChallengeStakeKind.free;

    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Challenge'),
          const Spacer(),
          PdfModalCard(
            child: Column(
              children: [
                PdfCircularTimer(value: left, total: 60, size: 128),
                const SizedBox(height: 20),
                Text(
                  'Waiting for $name to accept…',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  free
                      ? 'Challenge sent · Free match'
                      : 'Challenge sent · 5 coins',
                  style: const TextStyle(color: C.muted, fontSize: 13),
                ),
                const SizedBox(height: 20),
                PdfGhostButton(
                  'Cancel challenge',
                  onTap: () {
                    if (c != null) ChallengeFlowService.cancel(c.id);
                    _timer?.cancel();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              if (c == null) return;
              ChallengeFlowService.accept(c.id);
              Navigator.pushReplacementNamed(
                context,
                '/match-lobby',
                arguments: {
                  'opponentName': c.opponentName,
                  'opponentId': c.opponentId,
                  'stakeLabel': c.stakeLabel,
                },
              );
            },
            child: const Text('Simulate accept (single device)',
                style: TextStyle(color: C.teal)),
          ),
        ],
      ),
    );
  }
}
