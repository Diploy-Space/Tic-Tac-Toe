import 'package:flutter/foundation.dart';
import '../models.dart';
import 'auth_service.dart';
import 'connectivity_service.dart';
import 'friend_service.dart';
import 'match_sync_service.dart';
import 'progress_repository.dart';

/// Cloud mission claims + achievement unlocks. Progress counters stay local.
class ProgressSyncService {
  ProgressSyncService._();

  static final ValueNotifier<Set<String>> unlockedAchievements =
      ValueNotifier<Set<String>>({});
  static final ValueNotifier<int> tick = ValueNotifier<int>(0);

  static String dailyPeriodKey([DateTime? d]) => 'd:${todayKey(d)}';

  static String weeklyPeriodKey([DateTime? d]) {
    final now = d ?? DateTime.now();
    final weekStart = now.subtract(Duration(days: (now.weekday - 1) % 7));
    return 'w:${todayKey(weekStart)}';
  }

  static String periodKeyForMission(String missionId) {
    if (missionId.startsWith('w_')) return weeklyPeriodKey();
    return dailyPeriodKey();
  }

  static void clear() {
    unlockedAchievements.value = {};
    tick.value++;
  }

  static Future<void> refresh() async {
    if (!AuthService.isSignedIn) {
      clear();
      return;
    }
    ensureMissionResets();
    try {
      final claims = await ProgressRepository.fetchMissionClaims(
        periodKeys: [dailyPeriodKey(), weeklyPeriodKey()],
      );
      // Keep local-only claims that aren't period-synced yet, then merge cloud.
      playerStats.claimedMissions = {
        ...playerStats.claimedMissions.where((id) {
          // Drop period missions; re-apply from cloud below.
          return !id.startsWith('d_') && !id.startsWith('w_');
        }),
        ...claims,
      };
      unlockedAchievements.value =
          await ProgressRepository.fetchAchievements();
      await _syncAchievementsFromLocal();
      statsTick.value++;
      tick.value++;
    } catch (e) {
      debugPrint('ProgressSyncService.refresh: $e');
    }
  }

  static Future<void> claimMission({
    required String missionId,
    required int reward,
  }) async {
    ensureMissionResets();
    if (playerStats.claimedMissions.contains(missionId)) return;

    // Cloud claim only when reachable; local reward still applies offline.
    if (AuthService.isSignedIn && ConnectivityService.instance.isOnline) {
      await ProgressRepository.claimMission(
        missionId: missionId,
        periodKey: periodKeyForMission(missionId),
        reward: reward,
      );
    }

    coins.value += reward;
    playerStats.claimedMissions = {...playerStats.claimedMissions, missionId};
    statsTick.value++;
    tick.value++;
  }

  static Future<void> _syncAchievementsFromLocal() async {
    final s = playerStats;
    final cloud = MatchSyncService.myStats.value;
    final wins = cloud?.wins ?? s.wins;
    final score = cloud?.score ?? s.score;
    final bestStreak = MatchSyncService.derivedBestStreak ?? s.bestStreak;
    final friends = FriendService.friends.value.length;

    final candidates = <String, bool>{
      'first_win': wins >= 1,
      'streak_5': bestStreak >= 5,
      'pass_play_10': s.passPlayGames >= 10,
      'score_100': score >= 100,
      'make_friend': friends >= 1,
      'wins_100': wins >= 100,
    };

    final have = {...unlockedAchievements.value};
    final canCloud =
        AuthService.isSignedIn && ConnectivityService.instance.isOnline;
    for (final e in candidates.entries) {
      if (!e.value || have.contains(e.key)) continue;
      if (canCloud) {
        await ProgressRepository.unlockAchievement(e.key);
      }
      have.add(e.key);
    }
    unlockedAchievements.value = have;
  }

  /// Call after a match finishes (local + optional cloud).
  static Future<void> onMatchFinished() async {
    if (AuthService.isSignedIn) {
      await _syncAchievementsFromLocal();
      tick.value++;
    }
  }
}
