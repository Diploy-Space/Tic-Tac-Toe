class UserProfile {
  final String id;
  final String username;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.username,
    this.avatarUrl,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: '${json['id']}',
      username: '${json['username']}',
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'avatar_url': avatarUrl,
        'created_at': createdAt.toIso8601String(),
      };

  UserProfile copyWith({
    String? username,
    String? avatarUrl,
    bool clearAvatar = false,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      avatarUrl: clearAvatar ? null : (avatarUrl ?? this.avatarUrl),
      createdAt: createdAt,
    );
  }
}
