import 'package:flutter/material.dart';
import '../models/moderation_models.dart';
import '../services/auth_service.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AppealUnderReviewScreen extends StatefulWidget {
  const AppealUnderReviewScreen({super.key});

  @override
  State<AppealUnderReviewScreen> createState() =>
      _AppealUnderReviewScreenState();
}

class _AppealUnderReviewScreenState extends State<AppealUnderReviewScreen> {
  @override
  void initState() {
    super.initState();
    ModerationService.refresh();
  }

  String _fmt(DateTime? t) {
    if (t == null) return '—';
    final l = t.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _refresh() async {
    final s = await ModerationService.refresh();
    if (!mounted) return;
    if (s?.accountStatus == AccountStatus.active) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    } else if (s?.accountStatus == AccountStatus.suspended &&
        !(s?.hasActiveAppeal ?? false)) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account-suspended', (r) => false);
    }
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final argId = ModalRoute.of(context)?.settings.arguments as String?;
    return AppScaffold(
      child: ValueListenableBuilder<ModerationStatus?>(
        valueListenable: ModerationService.status,
        builder: (_, status, __) {
          final appealId = status?.appealId ?? argId ?? '—';
          final appealStatus = status?.appealStatus ?? 'pending';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar('Appeal under review'),
              const SizedBox(height: 24),
              AppCard(
                borderColor: C.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appeal submitted successfully',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text('Reference: $appealId',
                        style: const TextStyle(color: C.muted)),
                    const SizedBox(height: 6),
                    Text('Submitted: ${_fmt(status?.appealSubmittedAt)}',
                        style: const TextStyle(color: C.muted)),
                    const SizedBox(height: 6),
                    Text('Status: $appealStatus',
                        style: const TextStyle(
                            color: C.teal, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your account remains restricted until a moderator finishes review. '
                'Gameplay, matchmaking, and chat stay locked.',
                style: TextStyle(color: C.muted, height: 1.4),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _refresh,
                child: const Text('Refresh status'),
              ),
              const SizedBox(height: 10),
              GhostButton('Sign out', onTap: _signOut),
            ],
          );
        },
      ),
    );
  }
}
