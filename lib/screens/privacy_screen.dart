import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(context.l10n.privacyPolicy),
          AppCard(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Heading(context.l10n.privacyPolicy, size: 20),
                const SizedBox(height: 12),
                Text(context.l10n.privacyBody('support@playdrotix.in'),
                    style: const TextStyle(color: C.muted, height: 1.6)),
              ])),
        ]),
      ),
    );
  }
}
