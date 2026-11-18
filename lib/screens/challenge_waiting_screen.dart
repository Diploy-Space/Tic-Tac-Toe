import 'dart:async';

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// Waiting modal — reacts in realtime when opponent accepts / declines.
class ChallengeWaitingScreen extends StatefulWidget {
  const ChallengeWaitingScreen({super.key});

  @override
  State<ChallengeWaitingScreen> createState() => _ChallengeWaitingScreenState();
}

class _ChallengeWaitingScreenState extends State<ChallengeWaitingScreen> {
  Timer? _timer;
  String? _id;
  bool _closing = false;

  ChallengeItem? get _item {
    final a = ModalRoute.of(context)?.settings.arguments;
    if (_id == null && a is ChallengeItem) _id = a.id;
    if (_id != null) {
      for (final c in ChallengeFlowService.items.value) {
        if (c.id == _id) return c;
      }
    }
    return a is ChallengeItem ? a : null;
  }

  @override
  void initState() {
    super.initState();
    ChallengeFlowService.items.addListener(_onItems);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _closing) return;
      setState(() {});
      _checkStatus(_item);
    });
  }

  void _onItems() {
    if (!mounted || _closing) return;
    setState(() {});
    _checkStatus(_item);
  }

  void _checkStatus(ChallengeItem? c) {
    if (c == null || _closing) return;
    if (c.status == ChallengeItemStatus.pending && c.secondsLeft > 0) return;
    _closing = true;
    _timer?.cancel();
    if (!mounted) return;
    if (c.status == ChallengeItemStatus.accepted) {
      Navigator.pushReplacementNamed(context, '/match-lobby',
          arguments: c.lobbyArgs());
      return;
    }
    final msg = switch (c.status) {
      ChallengeItemStatus.declined when c.declinedBusy =>
        context.l10n.notifChallengeBusyBody(c.opponentName),
      ChallengeItemStatus.declined => context.l10n.challengeDeclined,
      ChallengeItemStatus.cancelled => context.l10n.challengeCancelled,
      ChallengeItemStatus.expired => context.l10n.challengeExpired,
      _ => context.l10n.challengeClosed,
    };
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    ChallengeFlowService.items.removeListener(_onItems);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _item;
    final name = c?.opponentName ?? context.l10n.opponent;
    final left = c?.secondsLeft ?? 0;
    final free = c?.stake == ChallengeStakeKind.free;

    return AppScaffold(
      child: Column(
        children: [
          TopBar(context.l10n.challenge),
          const Spacer(),
          PdfModalCard(
            child: Column(
              children: [
                PdfCircularTimer(value: left, total: 60, size: 128),
                const SizedBox(height: 20),
                Text(
                  context.l10n.waitingForAccept(name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                if (free)
                  Text(context.l10n.challengeSentFree,
                      style: const TextStyle(color: C.muted, fontSize: 13))
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CurrencyMark(size: 13),
                      const SizedBox(width: 4),
                      Text(context.l10n.challengeSentCoins,
                          style: const TextStyle(color: C.muted, fontSize: 13)),
                    ],
                  ),
                const SizedBox(height: 20),
                PdfGhostButton(
                  context.l10n.cancelChallenge,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    if (c != null) await ChallengeFlowService.cancel(c.id);
                    _timer?.cancel();
                    if (!mounted) return;
                    nav.pop();
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          if (!AuthService.isSignedIn)
            TextButton(
              onPressed: () async {
                if (c == null) return;
                final nav = Navigator.of(context);
                final acc = await ChallengeFlowService.accept(c.id);
                if (!mounted) return;
                nav.pushReplacementNamed('/match-lobby',
                    arguments: (acc ?? c).lobbyArgs());
              },
              child: const Text(
                'Simulate accept (single device)',
                style: TextStyle(color: C.teal),
              ),
            ),
        ],
      ),
    );
  }
}
