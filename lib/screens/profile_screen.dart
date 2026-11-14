import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/match_sync_service.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) {
      MatchSyncService.refresh();
      ProfileService.loadMyProfile(retry: false);
    }
  }

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
              builder: (_, __, ___) => ValueListenableBuilder<int>(
                  valueListenable: MatchSyncService.tick,
                  builder: (_, ___, ____) {
                    final s = playerStats;
                    final cloud = MatchSyncService.myStats.value;
                    final useCloud = AuthService.isSignedIn && cloud != null;
                    final rankNum = MatchSyncService.myRank.value;
                    final rank = useCloud
                        ? (rankNum == null ? '–' : '#$rankNum')
                        : (s.rankEstimate == 0 ? '–' : '#${s.rankEstimate}');
                    return _ProfileHeaderCard(
                      stats: [
                        MapEntry('Rank', rank),
                        MapEntry(
                            'Score', '${useCloud ? cloud.score : s.score}'),
                        MapEntry(
                            'Played', '${useCloud ? cloud.played : s.played}'),
                        MapEntry('Wins', '${useCloud ? cloud.wins : s.wins}'),
                      ],
                      onEdit: () => go('/edit-profile'),
                    );
                  })),
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
                MenuTile(Icons.group_outlined, 'Friends',
                    onTap: () => go('/friends')),
                MenuTile(Icons.palette_outlined, 'Customize',
                    onTap: () => go('/customize')),
                MenuTile(Icons.history, 'History', onTap: () => go('/history')),
                MenuTile(Icons.receipt_long_outlined, 'Match History',
                    onTap: () => go('/match-history')),
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

/// Profile header — edit icon opens Edit Profile (camera lives there).
class _ProfileHeaderCard extends StatelessWidget {
  final List<MapEntry<String, String>> stats;
  final VoidCallback onEdit;

  const _ProfileHeaderCard({
    required this.stats,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) => AppCard(
      borderColor: C.magenta,
      child: Column(children: [
        Row(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: authAvatarUrl,
                builder: (_, url, __) => Container(
                  width: 52,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: C.border2),
                  ),
                  child: ProfileAvatar(url: url, size: 50),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Material(
                  color: C.magenta,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onEdit,
                    child: const SizedBox(
                      width: 22,
                      height: 22,
                      child: Icon(Icons.edit, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
              child: ValueListenableBuilder<String>(
                  valueListenable: authDisplayName,
                  builder: (_, name, __) => Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)))),
          const CoinChip(),
        ]),
        const SizedBox(height: 12),
        Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: C.border2))),
            child: Row(children: [
              for (final s in stats)
                Expanded(
                    child: Column(children: [
                  Text(s.key,
                      style: const TextStyle(fontSize: 13, color: C.muted)),
                  Text(s.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ])),
            ])),
      ]));
}
