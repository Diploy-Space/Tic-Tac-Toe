import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';
import '../services/match_sync_service.dart';
import '../services/progress_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

enum _IconTone { magenta, teal }

class _Badge {
  final String id;
  final ShapeKind shape;
  final _IconTone tone;
  final String name;
  final int Function() progress;
  final int total;

  /// When true and not unlocked with 0 progress, subtitle shows "Locked".
  final bool lockedLabel;
  const _Badge({
    required this.id,
    required this.shape,
    required this.tone,
    required this.name,
    required this.progress,
    required this.total,
    this.lockedLabel = false,
  });
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  static const _lockedIcon = Color(0xFF3A3A46);
  static const _lockedTitle = Color(0xFF6A6A78);
  static const _lockedSub = Color(0xFF5A5A68);

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
    final played = useCloud ? cloud.played : playerStats.played;
    final score = useCloud ? cloud.score : playerStats.score;
    final streak = MatchSyncService.derivedBestStreak ?? playerStats.bestStreak;
    final rank = MatchSyncService.myRank.value;
    final friends = AuthService.isSignedIn
        ? FriendService.friends.value.length
        : playerStats.friendsCount;
    final tournaments = playerStats.tournamentsJoined;

    return [
      _Badge(
        id: 'first_win',
        shape: ShapeKind.circle,
        tone: _IconTone.magenta,
        name: context.l10n.achFirstWin,
        progress: () => wins.clamp(0, 1),
        total: 1,
      ),
      _Badge(
        id: 'streak_3',
        shape: ShapeKind.triangle,
        tone: _IconTone.teal,
        name: context.l10n.achStreak3,
        progress: () => streak.clamp(0, 3),
        total: 3,
      ),
      _Badge(
        id: 'matches_10',
        shape: ShapeKind.square,
        tone: _IconTone.magenta,
        name: context.l10n.ach10Matches,
        progress: () => played.clamp(0, 10),
        total: 10,
      ),
      _Badge(
        id: 'challenger',
        shape: ShapeKind.circle,
        tone: _IconTone.magenta,
        name: context.l10n.achChallenger,
        progress: () => friends.clamp(0, 1),
        total: 1,
      ),
      _Badge(
        id: 'survivor_10',
        shape: ShapeKind.triangle,
        tone: _IconTone.teal,
        name: context.l10n.achSurvivor,
        progress: () => wins.clamp(0, 10),
        total: 10,
      ),
      _Badge(
        id: 'champion',
        shape: ShapeKind.square,
        tone: _IconTone.magenta,
        name: context.l10n.achChampion,
        progress: () => tournaments.clamp(0, 1),
        total: 1,
      ),
      _Badge(
        id: 'streak_5',
        shape: ShapeKind.circle,
        tone: _IconTone.magenta,
        name: context.l10n.achStreak5,
        progress: () => streak.clamp(0, 5),
        total: 5,
      ),
      _Badge(
        id: 'matches_50',
        shape: ShapeKind.triangle,
        tone: _IconTone.teal,
        name: context.l10n.ach50Matches,
        progress: () => played.clamp(0, 50),
        total: 50,
      ),
      _Badge(
        id: 'top_3',
        shape: ShapeKind.square,
        tone: _IconTone.magenta,
        name: context.l10n.achTop3,
        progress: () => (rank != null && rank <= 3) ? 1 : 0,
        total: 1,
        lockedLabel: true,
      ),
      _Badge(
        id: 'score_100',
        shape: ShapeKind.circle,
        tone: _IconTone.magenta,
        name: context.l10n.achScore100,
        progress: () => score >= 100 ? 1 : 0,
        total: 1,
        lockedLabel: true,
      ),
      _Badge(
        id: 'pass_play_10',
        shape: ShapeKind.triangle,
        tone: _IconTone.teal,
        name: context.l10n.passAndPlay,
        progress: () => playerStats.passPlayGames.clamp(0, 10),
        total: 10,
      ),
      _Badge(
        id: 'wins_100',
        shape: ShapeKind.square,
        tone: _IconTone.magenta,
        name: context.l10n.ach100Wins,
        progress: () => wins.clamp(0, 100),
        total: 100,
      ),
    ];
  }

  bool _isUnlocked(_Badge b) {
    return ProgressSyncService.unlockedAchievements.value.contains(b.id) ||
        b.progress() >= b.total;
  }

  Color _activeColor(_Badge b) => b.tone == _IconTone.teal ? C.teal : C.magenta;

  String _subtitle(_Badge b, bool unlocked, int progress) {
    if (unlocked) return context.l10n.unlocked;
    if (b.lockedLabel && progress <= 0) return context.l10n.locked;
    return context.l10n.progressOf('$progress', '${b.total}');
  }

  Widget _tile(_Badge b) {
    final progress = b.progress();
    final unlocked = _isUnlocked(b);
    final accent = unlocked ? _activeColor(b) : _lockedIcon;
    final titleColor = unlocked ? C.text : _lockedTitle;
    final subColor = unlocked ? C.muted : _lockedSub;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: C.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShapeIcon(b.shape, size: 36, color: accent, stroke: 2.4),
          const SizedBox(height: 12),
          Text(
            b.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _subtitle(b, unlocked, progress),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressHeader(int unlocked, int total) {
    final pct = total == 0 ? 0.0 : unlocked / total;
    final pctLabel = '${(pct * 100).round()}%';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.unlockedCount('$unlocked', '$total'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                pctLabel,
                style: const TextStyle(
                  color: C.teal,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: C.surface2,
              color: C.teal,
            ),
          ),
        ],
      ),
    );
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
              final unlocked = badges.where(_isUnlocked).length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopBar(context.l10n.achievements),
                  const SizedBox(height: 14),
                  _progressHeader(unlocked, badges.length),
                  const SizedBox(height: 14),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: badges.length,
                      itemBuilder: (_, i) => _tile(badges[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
