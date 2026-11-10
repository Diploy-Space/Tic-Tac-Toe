import 'package:flutter/material.dart';

/// Simple global app state with local progress tracking.
final ValueNotifier<int> coins = ValueNotifier<int>(500);
final ValueNotifier<bool> soundOn = ValueNotifier<bool>(true);
final ValueNotifier<String> language = ValueNotifier<String>('English');
final ValueNotifier<bool> musicOn = ValueNotifier<bool>(true);
final ValueNotifier<bool> vibrationOn = ValueNotifier<bool>(true);
final ValueNotifier<bool> notificationsOn = ValueNotifier<bool>(false);
final ValueNotifier<bool> introSeen = ValueNotifier<bool>(false);
final ValueNotifier<bool> authSignedIn = ValueNotifier<bool>(false);
final ValueNotifier<String> authDisplayName = ValueNotifier<String>('Guest');
final ValueNotifier<String> authEmail = ValueNotifier<String>('');
/// Supabase Storage public URL for the signed-in user's avatar (null = cosmetic face).
final ValueNotifier<String?> authAvatarUrl = ValueNotifier<String?>(null);

class GameArgs {
  final int size; // 3, 4 or 5
  final String difficulty; // Easy, Medium, Hard
  final bool vsAi; // false = Pass & Play
  final int stake; // coins for random match, 0 otherwise
  final String opponentName;
  final bool quickMatch; // simulated online match vs AI
  const GameArgs({
    required this.size,
    this.difficulty = 'Medium',
    this.vsAi = true,
    this.stake = 0,
    this.opponentName = 'The Doll',
    this.quickMatch = false,
  });
}

class Cosmetic {
  final String kind; // mark | board
  final String name;
  final int price;
  const Cosmetic(this.kind, this.name, this.price);
}

const marksCatalog = [
  Cosmetic('mark', 'Classic', 0),
  Cosmetic('mark', 'Shapes', 0),
  Cosmetic('mark', 'Neon', 0),
  Cosmetic('mark', 'Ghost', 200),
  Cosmetic('mark', 'Gold', 500),
  Cosmetic('mark', 'Pixel', 300),
];
const boardsCatalog = [
  Cosmetic('board', 'Dark', 0),
  Cosmetic('board', 'Midnight', 0),
  Cosmetic('board', 'Crimson', 250),
  Cosmetic('board', 'Teal', 250),
  Cosmetic('board', 'Ash', 150),
  Cosmetic('board', 'Violet', 350),
];

final ValueNotifier<Set<String>> owned = ValueNotifier<Set<String>>(
    {'Classic', 'Shapes', 'Neon', 'Dark', 'Midnight'});
final ValueNotifier<String> equippedMark = ValueNotifier<String>('Classic');
final ValueNotifier<String> equippedBoard = ValueNotifier<String>('Dark');
final ValueNotifier<int> equippedAvatar = ValueNotifier<int>(0);

Color boardColor(String name) {
  switch (name) {
    case 'Midnight':
      return const Color(0xFF14142B);
    case 'Crimson':
      return const Color(0xFF2A0F1C);
    case 'Teal':
      return const Color(0xFF0F2A29);
    case 'Ash':
      return const Color(0xFF26262E);
    case 'Violet':
      return const Color(0xFF221436);
    default:
      return const Color(0xFF17171C);
  }
}

bool unlockCosmetic(Cosmetic c) {
  if (owned.value.contains(c.name)) return true;
  if (coins.value < c.price) return false;
  coins.value -= c.price;
  owned.value = {...owned.value, c.name};
  return true;
}

class MatchRecord {
  final DateTime at;
  final String opponent;
  final String result; // Win | Loss | Draw | P1 | P2
  final int size;
  final int coinDelta;
  final bool vsAi;
  final bool quickMatch;

  const MatchRecord({
    required this.at,
    required this.opponent,
    required this.result,
    required this.size,
    required this.coinDelta,
    required this.vsAi,
    this.quickMatch = false,
  });

  Map<String, dynamic> toJson() => {
        'at': at.toIso8601String(),
        'opponent': opponent,
        'result': result,
        'size': size,
        'coinDelta': coinDelta,
        'vsAi': vsAi,
        'quickMatch': quickMatch,
      };

  factory MatchRecord.fromJson(Map<String, dynamic> j) => MatchRecord(
        at: DateTime.tryParse('${j['at']}') ?? DateTime.now(),
        opponent: '${j['opponent']}',
        result: '${j['result']}',
        size: (j['size'] as num?)?.toInt() ?? 3,
        coinDelta: (j['coinDelta'] as num?)?.toInt() ?? 0,
        vsAi: j['vsAi'] == true,
        quickMatch: j['quickMatch'] == true,
      );
}

class PlayerStats {
  int played = 0;
  int wins = 0;
  int losses = 0;
  int draws = 0;
  int bestStreak = 0;
  int currentStreak = 0;
  int coinsWon = 0;
  int wins3 = 0, played3 = 0;
  int wins4 = 0, played4 = 0;
  int wins5 = 0, played5 = 0;
  int passPlayGames = 0;
  int quickMatches = 0;
  int tournamentsJoined = 0;
  int friendsCount = 1;
  final List<bool> recentForm = []; // true=win for AI games / P1 for local
  final List<MatchRecord> history = [];

  // Mission counters (daily/weekly progress).
  int dailyWins = 0;
  int dailyPlays = 0;
  int dailyWin4 = 0;
  int dailyQuick = 0;
  int weeklyWins = 0;
  int weeklyPlays = 0;
  Set<String> claimedMissions = {};
  int dailyRewardDay = 0; // 0..6
  String? lastDailyClaimDate; // yyyy-MM-dd
  String? lastDailyResetDate;
  String? lastWeeklyResetDate;

  int get score => wins * 10 + draws * 2;
  double get winRate => played == 0 ? 0 : wins / played;
  double rateFor(int size) {
    final p = size == 3 ? played3 : size == 4 ? played4 : played5;
    final w = size == 3 ? wins3 : size == 4 ? wins4 : wins5;
    return p == 0 ? 0 : w / p;
  }

  int get rankEstimate {
    if (score == 0) return 0;
    // Local estimate among sample ladder (higher score → better rank).
    const ladder = [458, 424, 277, 166, 129, 125, 118, 100];
    var rank = 1;
    for (final s in ladder) {
      if (score < s) {
        rank++;
      } else {
        break;
      }
    }
    return rank;
  }

  void recordMatch({
    required String? winner, // 'O', 'X', or null draw
    required GameArgs args,
    required int coinDelta,
  }) {
    played++;
    dailyPlays++;
    weeklyPlays++;
    if (args.size == 3) played3++;
    if (args.size == 4) played4++;
    if (args.size == 5) played5++;
    if (!args.vsAi) passPlayGames++;
    if (args.quickMatch) {
      quickMatches++;
      dailyQuick++;
    }

    String resultLabel;
    var won = false;
    if (winner == null) {
      draws++;
      currentStreak = 0;
      resultLabel = 'Draw';
    } else if (!args.vsAi) {
      resultLabel = winner == 'O' ? 'P1 win' : 'P2 win';
      won = winner == 'O';
      if (won) {
        wins++;
        dailyWins++;
        weeklyWins++;
        currentStreak++;
        if (args.size == 3) wins3++;
        if (args.size == 4) {
          wins4++;
          dailyWin4++;
        }
        if (args.size == 5) wins5++;
      } else {
        losses++;
        currentStreak = 0;
      }
    } else if (winner == 'O') {
      wins++;
      dailyWins++;
      weeklyWins++;
      currentStreak++;
      won = true;
      resultLabel = 'Win';
      if (args.size == 3) wins3++;
      if (args.size == 4) {
        wins4++;
        dailyWin4++;
      }
      if (args.size == 5) wins5++;
    } else {
      losses++;
      currentStreak = 0;
      resultLabel = 'Loss';
    }

    if (currentStreak > bestStreak) bestStreak = currentStreak;
    if (coinDelta > 0) coinsWon += coinDelta;

    recentForm.insert(0, won);
    if (recentForm.length > 7) recentForm.removeLast();

    history.insert(
        0,
        MatchRecord(
          at: DateTime.now(),
          opponent: args.opponentName,
          result: resultLabel,
          size: args.size,
          coinDelta: coinDelta,
          vsAi: args.vsAi,
          quickMatch: args.quickMatch,
        ));
    if (history.length > 50) history.removeLast();
    statsTick.value++;
  }

  Map<String, dynamic> toJson() => {
        'played': played,
        'wins': wins,
        'losses': losses,
        'draws': draws,
        'bestStreak': bestStreak,
        'currentStreak': currentStreak,
        'coinsWon': coinsWon,
        'wins3': wins3,
        'played3': played3,
        'wins4': wins4,
        'played4': played4,
        'wins5': wins5,
        'played5': played5,
        'passPlayGames': passPlayGames,
        'quickMatches': quickMatches,
        'tournamentsJoined': tournamentsJoined,
        'friendsCount': friendsCount,
        'recentForm': recentForm,
        'history': history.map((e) => e.toJson()).toList(),
        'dailyWins': dailyWins,
        'dailyPlays': dailyPlays,
        'dailyWin4': dailyWin4,
        'dailyQuick': dailyQuick,
        'weeklyWins': weeklyWins,
        'weeklyPlays': weeklyPlays,
        'claimedMissions': claimedMissions.toList(),
        'dailyRewardDay': dailyRewardDay,
        'lastDailyClaimDate': lastDailyClaimDate,
        'lastDailyResetDate': lastDailyResetDate,
        'lastWeeklyResetDate': lastWeeklyResetDate,
      };

  void loadJson(Map<String, dynamic> j) {
    played = (j['played'] as num?)?.toInt() ?? 0;
    wins = (j['wins'] as num?)?.toInt() ?? 0;
    losses = (j['losses'] as num?)?.toInt() ?? 0;
    draws = (j['draws'] as num?)?.toInt() ?? 0;
    bestStreak = (j['bestStreak'] as num?)?.toInt() ?? 0;
    currentStreak = (j['currentStreak'] as num?)?.toInt() ?? 0;
    coinsWon = (j['coinsWon'] as num?)?.toInt() ?? 0;
    wins3 = (j['wins3'] as num?)?.toInt() ?? 0;
    played3 = (j['played3'] as num?)?.toInt() ?? 0;
    wins4 = (j['wins4'] as num?)?.toInt() ?? 0;
    played4 = (j['played4'] as num?)?.toInt() ?? 0;
    wins5 = (j['wins5'] as num?)?.toInt() ?? 0;
    played5 = (j['played5'] as num?)?.toInt() ?? 0;
    passPlayGames = (j['passPlayGames'] as num?)?.toInt() ?? 0;
    quickMatches = (j['quickMatches'] as num?)?.toInt() ?? 0;
    tournamentsJoined = (j['tournamentsJoined'] as num?)?.toInt() ?? 0;
    friendsCount = (j['friendsCount'] as num?)?.toInt() ?? 1;
    recentForm
      ..clear()
      ..addAll(((j['recentForm'] as List?) ?? []).map((e) => e == true));
    history
      ..clear()
      ..addAll(((j['history'] as List?) ?? [])
          .map((e) => MatchRecord.fromJson(Map<String, dynamic>.from(e as Map))));
    dailyWins = (j['dailyWins'] as num?)?.toInt() ?? 0;
    dailyPlays = (j['dailyPlays'] as num?)?.toInt() ?? 0;
    dailyWin4 = (j['dailyWin4'] as num?)?.toInt() ?? 0;
    dailyQuick = (j['dailyQuick'] as num?)?.toInt() ?? 0;
    weeklyWins = (j['weeklyWins'] as num?)?.toInt() ?? 0;
    weeklyPlays = (j['weeklyPlays'] as num?)?.toInt() ?? 0;
    claimedMissions = {...((j['claimedMissions'] as List?) ?? []).map((e) => '$e')};
    dailyRewardDay = (j['dailyRewardDay'] as num?)?.toInt() ?? 0;
    lastDailyClaimDate = j['lastDailyClaimDate'] as String?;
    lastDailyResetDate = j['lastDailyResetDate'] as String?;
    lastWeeklyResetDate = j['lastWeeklyResetDate'] as String?;
  }

  void resetProgress() {
    loadJson({});
    claimedMissions.clear();
    history.clear();
    recentForm.clear();
    statsTick.value++;
  }
}

final playerStats = PlayerStats();
/// Bumped whenever stats change so UI can rebuild.
final ValueNotifier<int> statsTick = ValueNotifier<int>(0);

String todayKey([DateTime? d]) {
  final t = d ?? DateTime.now();
  return '${t.year.toString().padLeft(4, '0')}-'
      '${t.month.toString().padLeft(2, '0')}-'
      '${t.day.toString().padLeft(2, '0')}';
}

void ensureMissionResets() {
  final today = todayKey();
  if (playerStats.lastDailyResetDate != today) {
    playerStats.dailyWins = 0;
    playerStats.dailyPlays = 0;
    playerStats.dailyWin4 = 0;
    playerStats.dailyQuick = 0;
    playerStats.claimedMissions.removeWhere((id) => id.startsWith('d_'));
    playerStats.lastDailyResetDate = today;
    // Advance streak day if previous day was claimed, else reset streak.
    final yesterday = todayKey(DateTime.now().subtract(const Duration(days: 1)));
    if (playerStats.lastDailyClaimDate != yesterday &&
        playerStats.lastDailyClaimDate != today) {
      playerStats.dailyRewardDay = 0;
    }
  }
  // Weekly reset on Monday.
  final now = DateTime.now();
  final weekStart = todayKey(now.subtract(Duration(days: (now.weekday - 1) % 7)));
  if (playerStats.lastWeeklyResetDate != weekStart) {
    playerStats.weeklyWins = 0;
    playerStats.weeklyPlays = 0;
    playerStats.claimedMissions.removeWhere((id) => id.startsWith('w_'));
    playerStats.lastWeeklyResetDate = weekStart;
  }
}
