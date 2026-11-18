import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';
import '../l10n/app_localizations.dart';

/// Shown when online features are used without a connection.
class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  bool _retrying = false;

  Future<void> _tryAgain() async {
    if (_retrying) return;
    setState(() => _retrying = true);
    final online = await ConnectivityService.instance.retry();
    if (!mounted) return;
    setState(() => _retrying = false);
    if (online) {
      Navigator.maybePop(context);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.stillOffline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: staggered([
            const Center(child: IconCircle(Icons.wifi_off, size: 110)),
            Heading(context.l10n.youreOffline, align: TextAlign.center),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(context.l10n.offlineBody,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(color: C.muted, fontSize: 15, height: 1.5))),
            const SizedBox(height: 6),
            PrimaryButton(
              _retrying ? context.l10n.checking : context.l10n.tryAgain,
              onTap: _retrying ? null : _tryAgain,
            ),
            GhostButton(context.l10n.playDollOffline,
                onTap: () => startVsDoll(context)),
          ], gap: 16),
        ),
      ),
    );
  }
}
