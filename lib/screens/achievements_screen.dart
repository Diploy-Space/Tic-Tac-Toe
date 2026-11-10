import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';
import '../services/match_sync_service.dart';
import '../services/progress_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/painters.dart';

class _Badge {
  final String id;
  final Widget Function(Color) icon;
  final String name;
  final int Function() progress;
  final int total;
  const _Badge(this.id, this.icon, this.name, this.progress, this.total);
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) {
      ProgressSyncService.refresh();
      FriendService.refresh();
    }
  }

  List<_Badge> get _badges {
    final cloud = MatchSyncService.myStats.value;
    final useCloud = AuthService.isSignedIn && cloud != null;
    final wins = useCloud ? cloud.wins : playerStats.wins;
    final score = useCloud ? cloud.score : playerStats.score;
    final streak =
        MatchSyncService.derivedBestStreak ?? playerStats.bestStreak;
    final friends = AuthService.isSignedIn
        ? FriendService.friends.value.length
        : playerStats.friendsCount;
    return [
      _Badge('first_win', (c) => ShapeIcon(ShapeKind.circle, size: 30, color: c),
          'First win', () => wins.clamp(0, 1), 1),
      _Badge('streak_5', (c) => ShapeIcon(ShapeKind.triangle, size: 30, color: c),
          'Streak ×5', () => streak.clamp(0, 5), 5),
      _Badge('pass_play_10', (c) => ShapeIcon(ShapeKind.square, size: 30, color: c),
          'Pass & Play ×10', () => playerStats.passPlayGames.clamp(0, 10), 10),
      _Badge('score_100', (c) => Icon(Icons.emoji_events_outlined, size: 30, color: c),
          'Score 100', () => score >= 100 ? 1 : 0, 1),
      _Badge('make_friend', (c) => Icon(Icons.group_outlined, size: 30, color: c),
          'Make a friend', () => friends.clamp(0, 1), 1),
      _Badge('wins_100', (c) => Icon(Icons.star_outline, size: 30, color: c),
          '100 wins', () => wins.clamp(0, 100), 100),
    ];
  }

  Widget _tile(_Badge b) {
    final progress = b.progress();
    final cloudUnlocked =
        ProgressSyncService.unlockedAchievements.value.contains(b.id);
    final unlocked = cloudUnlocked || progress >= b.total;
    final color = unlocked ? C.magenta : const Color(0xFF6A6A78);
    return Opacity(
        opacity: unlocked ? 1 : .8,
        child: AppCard(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: C.bg,
                  border: Border.all(color: color, width: 2)),
              child: Center(child: b.icon(color))),
          const SizedBox(height: 10),
          Text(b.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 2),
          Text('$progress/${b.total}',
              style: const TextStyle(color: C.muted, fontSize: 13)),
          const SizedBox(height: 8),
          AppProgress(progress / b.total, color: color),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) => ValueListenableBuilder<int>(
          valueListenable: ProgressSyncService.tick,
          builder: (_, ___, ____) => ValueListenableBuilder<int>(
            valueListenable: MatchSyncService.tick,
            builder: (_, _____, ______) {
              final badges = _badges;
              final unlocked = badges
                  .where((b) =>
                      ProgressSyncService.unlockedAchievements.value
                          .contains(b.id) ||
                      b.progress() >= b.total)
                  .length;
              return SingleChildScrollView(
                child: staggered([
                  const TopBar('Achievements'),
                  if (AuthService.isSignedIn)
                    const Text('Unlocks sync to your cloud account',
                        style: TextStyle(color: C.muted, fontSize: 13)),
                  AppCard(
                      child: Row(children: [
                    Text('$unlocked',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: C.magenta)),
                    const SizedBox(width: 10),
                    Text('of ${badges.length} unlocked',
                        style: const TextStyle(color: C.muted)),
                  ])),
                  GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: .92,
                      children: [for (final b in badges) _tile(b)]),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}
