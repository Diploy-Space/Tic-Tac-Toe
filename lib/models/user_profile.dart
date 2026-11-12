class UserProfile {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? phoneE164;
  final String? callingCode;
  final String? countryIso2;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.phoneE164,
    this.callingCode,
    this.countryIso2,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: '${json['id']}',
      username: '${json['username']}',
      avatarUrl: json['avatar_url'] as String?,
      phoneE164: json['phone_e164'] as String?,
      callingCode: json['calling_code'] as String?,
      countryIso2: json['country_iso2'] as String?,
      createdAt: DateTime.tryParse('${json['created_at']}') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'avatar_url': avatarUrl,
        'phone_e164': phoneE164,
        'calling_code': callingCode,
        'country_iso2': countryIso2,
        'created_at': createdAt.toIso8601String(),
      };

  String? get nationalNumber {
    final e = phoneE164;
    final cc = callingCode;
    if (e == null || cc == null || !e.startsWith(cc)) return null;
    return e.substring(cc.length);
  }

  UserProfile copyWith({
    String? username,
    String? avatarUrl,
    String? phoneE164,
    String? callingCode,
    String? countryIso2,
    bool clearAvatar = false,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      avatarUrl: clearAvatar ? null : (avatarUrl ?? this.avatarUrl),
      phoneE164: phoneE164 ?? this.phoneE164,
      callingCode: callingCode ?? this.callingCode,
      countryIso2: countryIso2 ?? this.countryIso2,
      createdAt: createdAt,
    );
  }
}
