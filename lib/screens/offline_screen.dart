import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

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
      const SnackBar(
        content: Text('Still offline. Check your connection and try again.'),
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
            const Heading('You’re offline', align: TextAlign.center),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                    'Online matches and tournaments need a connection. You can still play against The Doll.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: C.muted, fontSize: 15, height: 1.5))),
            const SizedBox(height: 6),
            PrimaryButton(
              _retrying ? 'Checking…' : 'Try again',
              onTap: _retrying ? null : _tryAgain,
            ),
            GhostButton('Play vs The Doll offline',
                onTap: () => startVsDoll(context)),
          ], gap: 16),
        ),
      ),
    );
  }
}
