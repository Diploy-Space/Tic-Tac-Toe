import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 13 — Chat rules.
class ChatRulesScreen extends StatelessWidget {
  const ChatRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Chat rules'),
          const Text(
            'Text chat never starts on its own. One player asks, the other must accept.',
            style: TextStyle(color: C.muted, height: 1.4),
          ),
          _rule('Friend challenge',
              'Chat after both players accept the request.'),
          _rule('Private room (by username)',
              'Chat after both players accept the request.'),
          _rule('Random match',
              'Chat after both players accept. Nothing is shared beyond the username.'),
          const PdfSectionLabel('Always true'),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Emoji reactions work without a request, and can be muted.'),
                SizedBox(height: 10),
                Text('• Either player can stop the chat at any time.'),
                SizedBox(height: 10),
                Text('• Messages vanish in seconds and are never saved.'),
                SizedBox(height: 10),
                Text('• Chat ends automatically when the match ends.'),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  static Widget _rule(String title, String body) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(color: C.muted, height: 1.35)),
          ],
        ),
      );
}
