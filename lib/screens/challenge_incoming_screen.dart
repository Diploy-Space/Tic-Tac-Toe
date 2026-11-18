import 'dart:async';

import 'package:flutter/material.dart';
import '../services/challenge_flow_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// NEW MATCH CHALLENGE modal — pixel match to design.
class ChallengeIncomingScreen extends StatefulWidget {
  const ChallengeIncomingScreen({super.key});

  @override
  State<ChallengeIncomingScreen> createState() =>
      _ChallengeIncomingScreenState();
}

class _ChallengeIncomingScreenState extends State<ChallengeIncomingScreen> {
  Timer? _t;
  bool _busy = false;
  String? _boundId;

  ChallengeItem? get _item {
    final a = ModalRoute.of(context)?.settings.arguments;
    String? id;
    if (a is ChallengeItem) id = a.id;
    if (a is String) id = a;
    id ??= ChallengeFlowService.incomingPopup.value?.id;
    _boundId ??= id;
    final lookup = _boundId ?? id;
    if (lookup != null) {
      for (final c in ChallengeFlowService.items.value) {
        if (c.id == lookup) return c;
      }
    }
    if (a is ChallengeItem) return a;
    return ChallengeFlowService.incomingPopup.value;
  }

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      final c = _item;
      if (c != null &&
          (c.status != ChallengeItemStatus.pending || c.secondsLeft <= 0)) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    });
    ChallengeFlowService.items.addListener(_onItems);
    ChallengeFlowService.incomingPopup.addListener(_onItems);
  }

  void _onItems() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _t?.cancel();
    ChallengeFlowService.items.removeListener(_onItems);
    ChallengeFlowService.incomingPopup.removeListener(_onItems);
    super.dispose();
  }

  Future<void> _accept(ChallengeItem c) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final acc = await ChallengeFlowService.accept(c.id);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/match-lobby',
        (r) => r.isFirst,
        arguments: (acc ?? c).lobbyArgs(),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'.replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _decline(ChallengeItem c) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ChallengeFlowService.decline(c.id);
      if (!mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'.replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _item;
    final progress = c == null ? 0.0 : (c.secondsLeft / 60).clamp(0.0, 1.0);

    final dollSize = MediaQuery.sizeOf(context).width * 0.74;
    return AppScaffold(
      doll: false,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Doll character peeking out under the card (design).
          Positioned(
            left: 0,
            right: 0,
            bottom: -dollSize * 0.18,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.55,
                child: Center(child: DollFace(size: dollSize)),
              ),
            ),
          ),
          Column(
            children: [
              TopBar(context.l10n.challenge),
              const Spacer(flex: 4),
              Center(
                child: c == null
                    ? Text(context.l10n.noChallenge,
                        style: const TextStyle(color: C.muted))
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                        decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: C.magenta, width: 1.6),
                          boxShadow: [
                            BoxShadow(
                              color: C.magenta.withValues(alpha: 0.35),
                              blurRadius: 18,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.l10n.newMatchChallengeCaps,
                              style: const TextStyle(
                                color: C.teal,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 18),
                            PdfGradientAvatar(
                              c.opponentName.isNotEmpty
                                  ? c.opponentName[0]
                                  : '?',
                              size: 72,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              c.opponentName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${context.l10n.rankScore('${c.rank}', '${c.score}')} · ${c.stakeLabel}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: C.muted,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(99),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: C.surface2,
                                color: C.magenta,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.l10n
                                  .secondsLeftToRespond('${c.secondsLeft}'),
                              style: const TextStyle(
                                color: C.text,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: PdfTealButton(
                                    context.l10n.acceptCaps,
                                    onTap: _busy ? null : () => _accept(c),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: FilledButton(
                                      onPressed:
                                          _busy ? null : () => _decline(c),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: C.magenta,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            C.magenta.withValues(alpha: 0.5),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        context.l10n.declineCaps,
                                        style: const TextStyle(
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
              ),
              SizedBox(height: dollSize * 0.62),
            ],
          ),
        ],
      ),
    );
  }
}
