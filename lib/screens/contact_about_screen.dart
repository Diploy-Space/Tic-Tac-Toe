import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

class ContactAboutScreen extends StatelessWidget {
  const ContactAboutScreen({super.key});

  // Keep in sync with `version:` in pubspec.yaml.
  static const appVersion = '1.0.1';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      doll: false,
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('About us'),
          Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: const AppLogoMark(size: 92),
            ),
            const SizedBox(height: 14),
            const Text(
              'DROTIX',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Version $appVersion',
                style: TextStyle(color: C.muted, fontSize: 13)),
            const SizedBox(height: 14),
            const Text(
              'DROTIX is a fast, competitive game of three in a row. '
              'Play the computer, match with real players, challenge '
              'friends and climb the leaderboard.',
              textAlign: TextAlign.center,
              style: TextStyle(color: C.muted, fontSize: 15, height: 1.55),
            ),
          ]),
          const ContactUsCard(),
        ]),
      ),
    );
  }
}

/// "CONTACT US" card shared by About and Terms. Tapping a value copies it.
class ContactUsCard extends StatelessWidget {
  const ContactUsCard({super.key});

  static const website = 'playdrotix.com';
  static const supportEmail = 'support@playdrotix.com';

  void _copy(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$label copied: $value')));
  }

  Widget _row(BuildContext context, String label, String value) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _copy(context, label, value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Text(label, style: const TextStyle(color: C.muted, fontSize: 14)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: C.teal,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: C.teal,
                ),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONTACT US',
              style: TextStyle(
                color: C.teal,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            _row(context, 'Official website', website),
            _row(context, 'Support email', supportEmail),
          ],
        ),
      );
}
