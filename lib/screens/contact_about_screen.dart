import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ContactAboutScreen extends StatelessWidget {
  const ContactAboutScreen({super.key});
  Widget _item(IconData icon, String label, String value) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border)),
      child: Row(children: [
        Icon(icon, color: C.teal),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: C.muted, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      ]));
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Contact & About'),
          AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Heading('Contact us', size: 20),
            const SizedBox(height: 8),
            const Text('Questions about orders or services? Reach us here.',
                style: TextStyle(color: C.muted, fontSize: 13)),
            const SizedBox(height: 14),
            _item(Icons.phone_outlined, 'Call', '+880 1700-000000'),
            const SizedBox(height: 10),
            _item(Icons.mail_outline, 'Email', 'support@tictacgame.app'),
          ])),
          const AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Heading('About us', size: 20),
            SizedBox(height: 8),
            Text(
                'Welcome to Tic Tac Toe — a dark geometric survival-game themed board game. Made by Tic Tac Studio.',
                style: TextStyle(color: C.muted, height: 1.5)),
          ])),
        ]),
      ),
    );
  }
}
