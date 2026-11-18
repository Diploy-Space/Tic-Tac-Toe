import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'contact_about_screen.dart';
import '../l10n/app_localizations.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const lastUpdated = '11 Nov 2026';

  static List<(String, String)> _sections(L10n l) => [
        (l.termsUsingTitle, l.termsUsingBody),
        (l.termsAccountTitle, l.termsAccountBody),
        (l.termsCoinsTitle, l.termsCoinsBody),
        (l.termsFairTitle, l.termsFairBody),
        (l.termsChangesTitle, l.termsChangesBody),
      ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      doll: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(context.l10n.termsOfService),
            const SizedBox(height: 14),
            Text(context.l10n.lastUpdated(lastUpdated),
                style: const TextStyle(color: C.muted, fontSize: 12)),
            const SizedBox(height: 10),
            for (final (title, body) in _sections(context.l10n)) ...[
              Text(title,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(body,
                  style: const TextStyle(
                      color: C.muted, fontSize: 13.5, height: 1.5)),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 4),
            const ContactUsCard(),
          ],
        ),
      ),
    );
  }
}
