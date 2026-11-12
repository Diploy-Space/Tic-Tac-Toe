import 'dart:async';

import 'package:flutter/material.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 5 — NEW MATCH CHALLENGE modal card (100% layout match).
class ChallengeIncomingScreen extends StatefulWidget {
  const ChallengeIncomingScreen({super.key});

  @override
  State<ChallengeIncomingScreen> createState() =>
      _ChallengeIncomingScreenState();
}

class _ChallengeIncomingScreenState extends State<ChallengeIncomingScreen> {
  Timer? _t;

  ChallengeItem? get _item {
    final a = ModalRoute.of(context)?.settings.arguments;
    if (a is ChallengeItem) return a;
    if (a is String) {
      for (final c in ChallengeFlowService.items.value) {
        if (c.id == a) return c;
      }
    }
    return ChallengeFlowService.incomingPopup.value;
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _accept(ChallengeItem c) {
    ChallengeFlowService.accept(c.id);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/match-lobby',
      (r) => r.isFirst,
      arguments: {
        'opponentName': c.opponentName,
        'opponentId': c.opponentId,
        'stakeLabel': c.stakeLabel,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _item;
    final progress = c == null ? 0.0 : (c.secondsLeft / 60).clamp(0.0, 1.0);

    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Challenge'),
          const Spacer(),
          if (c == null)
            const Text('No challenge', style: TextStyle(color: C.muted))
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: C.magenta, width: 1.6),
              ),
              child: Column(
                children: [
                  const Text(
                    'NEW MATCH CHALLENGE!',
                    style: TextStyle(
                      color: C.teal,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  PdfGradientAvatar(
                    c.opponentName.isNotEmpty ? c.opponentName[0] : '?',
                    size: 72,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    c.opponentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rank #${c.rank} · Score ${c.score} · ${c.stakeLabel}',
                    style: const TextStyle(color: C.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: C.surface2,
                      color: C.magenta,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${c.secondsLeft}s left to respond',
                    style: const TextStyle(color: C.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: PdfTealButton(
                          'ACCEPT',
                          onTap: () => _accept(c),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: () {
                              ChallengeFlowService.decline(c.id);
                              Navigator.pop(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: C.magenta,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'DECLINE',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
