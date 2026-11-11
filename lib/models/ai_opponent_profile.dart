/// Local-only AI opponent card for offline Random Match.
/// Never used as a fake online / matchmaking player.
class AiOpponentProfile {
  final String id;
  final String name;
  /// 0 = PlayerFace, 1 = GuardFace, 2 = DollFace (see [AvatarFace]).
  final int avatarIndex;
  final String difficulty; // Easy | Medium | Hard
  final String description;

  const AiOpponentProfile({
    required this.id,
    required this.name,
    required this.avatarIndex,
    required this.difficulty,
    required this.description,
  });
}
