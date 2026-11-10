/// Row from public.matches / history UI mapping.
class CloudMatch {
  final String id;
  final String userId;
  final String? opponentUserId;
  final String? opponentName;
  final String result; // win | loss | draw
  final int boardSize;
  final String mode; // ai | quick_match | online
  final String? difficulty;
  final int stake;
  final int coinDelta;
  final DateTime playedAt;

  const CloudMatch({
    required this.id,
    required this.userId,
    this.opponentUserId,
    this.opponentName,
    required this.result,
    required this.boardSize,
    required this.mode,
    this.difficulty,
    required this.stake,
    required this.coinDelta,
    required this.playedAt,
  });

  factory CloudMatch.fromJson(Map<String, dynamic> json) {
    return CloudMatch(
      id: '${json['id']}',
      userId: '${json['user_id']}',
      opponentUserId: json['opponent_user_id'] as String?,
      opponentName: json['opponent_name'] as String?,
      result: '${json['result']}',
      boardSize: (json['board_size'] as num?)?.toInt() ?? 3,
      mode: '${json['mode']}',
      difficulty: json['difficulty'] as String?,
      stake: (json['stake'] as num?)?.toInt() ?? 0,
      coinDelta: (json['coin_delta'] as num?)?.toInt() ?? 0,
      playedAt: DateTime.tryParse('${json['played_at']}') ?? DateTime.now(),
    );
  }

  /// Labels aligned with local MatchRecord display.
  String get resultLabel {
    switch (result) {
      case 'win':
        return 'Win';
      case 'loss':
        return 'Loss';
      case 'draw':
        return 'Draw';
      default:
        return result;
    }
  }
}

class MatchStatistics {
  final String userId;
  final int played;
  final int wins;
  final int losses;
  final int draws;
  final int score;
  final double winRate;

  const MatchStatistics({
    required this.userId,
    required this.played,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.score,
    required this.winRate,
  });

  factory MatchStatistics.fromJson(Map<String, dynamic> json) {
    return MatchStatistics(
      userId: '${json['user_id']}',
      played: (json['played'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0,
    );
  }

  static const empty = MatchStatistics(
    userId: '',
    played: 0,
    wins: 0,
    losses: 0,
    draws: 0,
    score: 0,
    winRate: 0,
  );
}

class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int played;
  final int wins;
  final int losses;
  final int draws;
  final int score;
  final double winRate;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.played,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.score,
    required this.winRate,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: '${json['user_id']}',
      username: '${json['username']}',
      avatarUrl: json['avatar_url'] as String?,
      played: (json['played'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
      draws: (json['draws'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
    );
  }
}
