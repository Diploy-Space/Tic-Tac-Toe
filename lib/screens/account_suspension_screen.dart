import 'package:flutter/material.dart';
import '../models/moderation_models.dart';
import '../services/auth_service.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AccountSuspensionScreen extends StatefulWidget {
  const AccountSuspensionScreen({super.key});

  @override
  State<AccountSuspensionScreen> createState() =>
      _AccountSuspensionScreenState();
}

class _AccountSuspensionScreenState extends State<AccountSuspensionScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await ModerationService.refresh();
    if (!mounted) return;
    final s = ModerationService.status.value;
    if (s?.accountStatus == AccountStatus.underReview ||
        (s?.hasActiveAppeal ?? false)) {
      Navigator.pushReplacementNamed(context, '/appeal-under-review');
      return;
    }
    if (s?.accountStatus == AccountStatus.active) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      return;
    }
    setState(() => _loading = false);
  }

  String _fmt(DateTime? t) {
    if (t == null) return '—';
    final l = t.toLocal();
    return '${l.year}-${l.month.toString().padLeft(2, '0')}-${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<ModerationStatus?>(
        valueListenable: ModerationService.status,
        builder: (_, status, __) {
          if (_loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar('Account suspended'),
              const SizedBox(height: 24),
              AppCard(
                borderColor: C.danger,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your account has been suspended',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      status?.suspensionReason ??
                          'A moderator suspended this account after a report review.',
                      style: const TextStyle(color: C.muted, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Suspended: ${_fmt(status?.suspendedAt)}',
                      style: const TextStyle(color: C.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'You cannot play matches, join rooms, or use chat while suspended. '
                'You may submit one appeal for review.',
                style: TextStyle(color: C.muted, height: 1.4),
              ),
              const Spacer(),
              if (status?.canSubmitAppeal ?? true)
                FilledButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/appeal-submit'),
                  child: const Text('Submit appeal'),
                )
              else
                FilledButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, '/appeal-under-review'),
                  child: const Text('View appeal status'),
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
