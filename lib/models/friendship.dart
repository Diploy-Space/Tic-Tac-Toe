class Friendship {
  final String id;
  final String requesterId;
  final String addresseeId;
  final String status; // pending | accepted | declined
  final String? otherUsername;
  final String? otherAvatarUrl;
  final String otherUserId;
  final DateTime createdAt;

  const Friendship({
    required this.id,
    required this.requesterId,
    required this.addresseeId,
    required this.status,
    required this.otherUserId,
    this.otherUsername,
    this.otherAvatarUrl,
    required this.createdAt,
  });
}

class ProfileSearchHit {
  final String id;
  final String username;
  final String? avatarUrl;

  const ProfileSearchHit({
    required this.id,
    required this.username,
    this.avatarUrl,
  });
}
