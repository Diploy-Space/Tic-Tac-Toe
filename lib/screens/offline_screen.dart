import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

/// Show this when online features are used without a connection.
/// TODO: detect connectivity with the connectivity_plus package and push '/offline'.
class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});
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
            PrimaryButton('Try again', onTap: () => Navigator.maybePop(context)),
            GhostButton('Play vs The Doll offline',
                onTap: () => startVsDoll(context)),
          ], gap: 16),
        ),
      ),
    );
  }
}
