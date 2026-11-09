import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Privacy policy'),
          const AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Heading('Privacy policy', size: 20),
            SizedBox(height: 12),
            Text(
                'We collect only the gameplay data needed to run the app locally on your device '
                '(coins, cosmetics, match history and settings). Guest play does not require an account.\n\n'
                'If you later sign in, authentication details are used only to restore your progress. '
                'We do not sell personal data. You can clear local data anytime from Settings → Delete account.\n\n'
                'Contact: support@tictacgame.app',
                style: TextStyle(color: C.muted, height: 1.6)),
          ])),
        ]),
      ),
    );
  }
}
