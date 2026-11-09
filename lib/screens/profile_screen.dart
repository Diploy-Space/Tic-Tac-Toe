import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void go(String r) => Navigator.pushNamed(context, r);
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RoundIconBox(Icons.arrow_back_ios_new_rounded,
                label: 'Back', onTap: () => Navigator.maybePop(context)),
            RoundIconBox(Icons.logout, label: 'Log out', onTap: () async {
              try {
                await AuthService.signOut();
              } catch (_) {}
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
            }),
          ]),
          ValueListenableBuilder<int>(
              valueListenable: statsTick,
              builder: (_, __, ___) {
                final s = playerStats;
                final rank = s.rankEstimate == 0 ? '–' : '#${s.rankEstimate}';
                return UserCard(stats: [
                  MapEntry('Rank', rank),
                  MapEntry('Score', '${s.score}'),
                  MapEntry('Played', '${s.played}'),
                  MapEntry('Wins', '${s.wins}'),
                ]);
              }),
          ValueListenableBuilder<bool>(
              valueListenable: soundOn,
              builder: (_, on, __) => SegRow(
                  options: const ['Sound enabled', 'Sound disabled'],
                  selected: on ? 0 : 1,
                  onChanged: (i) => soundOn.value = i == 0)),
          AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(children: [
                MenuTile(Icons.bar_chart, 'Stats', onTap: () => go('/stats')),
                MenuTile(Icons.emoji_events_outlined, 'Achievements',
                    onTap: () => go('/achievements')),
                MenuTile(Icons.group_outlined, 'Friends', onTap: () => go('/friends')),
                MenuTile(Icons.edit_outlined, 'Customize', onTap: () => go('/customize')),
                MenuTile(Icons.history, 'History', onTap: () => go('/history')),
                MenuTile(Icons.sports_esports_outlined, 'More games',
                    onTap: () => go('/games')),
                MenuTile(Icons.settings_outlined, 'Settings',
                    last: true, onTap: () => go('/settings')),
              ])),
        ]),
      ),
    );
  }
}
