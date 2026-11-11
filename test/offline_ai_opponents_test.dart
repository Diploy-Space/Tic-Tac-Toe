import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/data/offline_ai_opponents.dart';

void main() {
  test('offline catalog has 15 unique AI profiles with valid difficulties', () {
    expect(offlineAiOpponents.length, 15);
    final ids = offlineAiOpponents.map((p) => p.id).toSet();
    expect(ids.length, 15);
    final names = offlineAiOpponents.map((p) => p.name).toSet();
    expect(names.length, 15);

    const allowed = {'Easy', 'Medium', 'Hard'};
    for (final p in offlineAiOpponents) {
      expect(allowed.contains(p.difficulty), isTrue, reason: p.id);
      expect(p.avatarIndex, inInclusiveRange(0, 2));
      expect(p.description.trim(), isNotEmpty);
    }

    expect(offlineAiOpponents.any((p) => p.difficulty == 'Easy'), isTrue);
    expect(offlineAiOpponents.any((p) => p.difficulty == 'Medium'), isTrue);
    expect(offlineAiOpponents.any((p) => p.difficulty == 'Hard'), isTrue);
  });
}
