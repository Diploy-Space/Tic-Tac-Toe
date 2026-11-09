import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/painters.dart';

class _Badge {
  final Widget Function(Color) icon;
  final String name;
  final int Function() progress;
  final int total;
  const _Badge(this.icon, this.name, this.progress, this.total);
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  List<_Badge> get _badges => [
        _Badge((c) => ShapeIcon(ShapeKind.circle, size: 30, color: c), 'First win',
            () => playerStats.wins.clamp(0, 1), 1),
        _Badge((c) => ShapeIcon(ShapeKind.triangle, size: 30, color: c), 'Streak ×5',
            () => playerStats.bestStreak.clamp(0, 5), 5),
        _Badge((c) => ShapeIcon(ShapeKind.square, size: 30, color: c), 'Pass & Play ×10',
            () => playerStats.passPlayGames.clamp(0, 10), 10),
        _Badge((c) => Icon(Icons.emoji_events_outlined, size: 30, color: c), 'Score 100',
            () => playerStats.score >= 100 ? 1 : 0, 1),
        _Badge((c) => Icon(Icons.group_outlined, size: 30, color: c), 'Make a friend',
            () => playerStats.friendsCount.clamp(0, 1), 1),
        _Badge((c) => Icon(Icons.star_outline, size: 30, color: c), '100 wins',
            () => playerStats.wins.clamp(0, 100), 100),
      ];

  Widget _tile(_Badge b) {
    final progress = b.progress();
    final unlocked = progress >= b.total;
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
        builder: (_, __, ___) {
          final badges = _badges;
          final unlocked = badges.where((b) => b.progress() >= b.total).length;
          return SingleChildScrollView(
            child: staggered([
              const TopBar('Achievements'),
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
    );
  }
}
