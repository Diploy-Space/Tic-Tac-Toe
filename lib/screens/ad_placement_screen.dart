import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// PDF page 34 — Ad placement policy.
class AdPlacementScreen extends StatelessWidget {
  const AdPlacementScreen({super.key});

  Widget _row({
    required String title,
    required String sub,
    required String badge,
    bool highlight = false,
  }) {
    final badgeColor = highlight ? C.magenta : C.teal;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? C.magenta : C.border,
          width: highlight ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(sub,
                    style: const TextStyle(color: C.muted, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Ad placement'),
          const Text(
            'Ads appear in one place only, and only when the player asks for free coins.',
            style: TextStyle(color: C.muted, height: 1.4),
          ),
          _row(
            title: 'Home',
            sub: 'No banner, no pop-ups',
            badge: 'NO ADS',
          ),
          _row(
            title: 'Game board',
            sub: 'Never interrupted during play',
            badge: 'NO ADS',
          ),
          _row(
            title: 'Tournament',
            sub: 'No ads in any round',
            badge: 'NO ADS',
          ),
          _row(
            title: 'Challenges and chat',
            sub: 'No ads',
            badge: 'NO ADS',
          ),
          _row(
            title: 'Shop → Free coins',
            sub: 'Player taps Watch video',
            badge: 'REWARDED VIDEO',
            highlight: true,
          ),
          const AppCard(
            child: Text(
              'No banner, interstitial or app-open ads anywhere in the app.',
              style: TextStyle(color: C.muted, height: 1.4),
            ),
          ),
        ]),
      ),
    );
  }
}
