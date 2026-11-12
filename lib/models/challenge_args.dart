/// Navigation payload for public profile → challenge flow (PDF screens).
class PublicProfileArgs {
  final String userId;
  final String? username;
  final String? avatarUrl;
  final int? rank;
  final int? score;
  final int? wins;

  const PublicProfileArgs({
    required this.userId,
    this.username,
    this.avatarUrl,
    this.rank,
    this.score,
    this.wins,
  });

  static PublicProfileArgs fromRoute(Object? raw) {
    if (raw is PublicProfileArgs) return raw;
    if (raw is String) return PublicProfileArgs(userId: raw);
    if (raw is Map) {
      final m = Map<String, dynamic>.from(raw);
      return PublicProfileArgs(
        userId: '${m['userId'] ?? m['user_id'] ?? ''}',
        username: m['username'] as String?,
        avatarUrl: m['avatarUrl'] as String? ?? m['avatar_url'] as String?,
        rank: (m['rank'] as num?)?.toInt(),
        score: (m['score'] as num?)?.toInt(),
        wins: (m['wins'] as num?)?.toInt(),
      );
    }
    return const PublicProfileArgs(userId: '');
  }
}

class ChallengeStakeArgs {
  final String opponentId;
  final String opponentName;
  final String? avatarUrl;
  final int rank;
  final int score;

  const ChallengeStakeArgs({
    required this.opponentId,
    required this.opponentName,
    this.avatarUrl,
    required this.rank,
    required this.score,
  });
}
