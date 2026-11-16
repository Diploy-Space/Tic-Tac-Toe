import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import 'contact_about_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  static const lastUpdated = '11 Nov 2026';

  static const _sections = <(String, String)>[
    ('1. Using DROTIX', 'You must follow these terms and play fairly.'),
    (
      '2. Your account',
      'Keep your sign-in secure. You are responsible for activity on your account.'
    ),
    (
      '3. Virtual coins',
      'Coins are virtual items with no cash value and cannot be exchanged for money.'
    ),
    (
      '4. Fair play and chat',
      'No cheating, abuse or harassment. We may suspend accounts that break the rules.'
    ),
    (
      '5. Changes',
      'We may update these terms. Continued use means you accept the updates.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      doll: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopBar('Terms of service'),
            const SizedBox(height: 14),
            const Text('Last updated $lastUpdated',
                style: TextStyle(color: C.muted, fontSize: 12)),
            const SizedBox(height: 10),
            for (final (title, body) in _sections) ...[
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
