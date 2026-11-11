import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/models.dart';
import 'package:tic_tac_game/models/game_chat_message.dart';

void main() {
  group('InGameChatGate', () {
    test('allows real UUID PvP seats', () {
      const o = '11111111-1111-1111-1111-111111111111';
      const x = '22222222-2222-2222-2222-222222222222';
      expect(
        InGameChatGate.isRealPlayerVsRealPlayer(
          playerO: o,
          playerX: x,
          opponentId: x,
        ),
        isTrue,
      );
    });

    test('rejects missing / empty opponent', () {
      const o = '11111111-1111-1111-1111-111111111111';
      expect(
        InGameChatGate.isRealPlayerVsRealPlayer(
          playerO: o,
          playerX: '',
          opponentId: '',
        ),
        isFalse,
      );
      expect(
        InGameChatGate.isRealPlayerVsRealPlayer(
          playerO: o,
          playerX: 'null',
          opponentId: 'null',
        ),
        isFalse,
      );
    });

    test('rejects non-UUID local / AI labels', () {
      expect(
        InGameChatGate.isRealPlayerVsRealPlayer(
          playerO: 'local-player',
          playerX: 'The Doll',
          opponentId: 'The Doll',
        ),
        isFalse,
      );
    });

    test('AI / quickMatch GameArgs never qualify as chat hosts', () {
      expect(
        InGameChatGate.isAiOrLocalMatch(vsAi: true, quickMatch: false),
        isTrue,
      );
      expect(
        InGameChatGate.isAiOrLocalMatch(vsAi: false, quickMatch: true),
        isTrue,
      );
      // Pass & play is local — chat still must not appear (no OnlineGameScreen).
      expect(
        InGameChatGate.isAiOrLocalMatch(vsAi: false, quickMatch: false),
        isFalse,
      );
    });
  });

  group('GameArgs AI paths', () {
    test('offline doll and quick match are vsAi/quickMatch', () {
      const doll = GameArgs(size: 3, vsAi: true, difficulty: 'Hard');
      const quick = GameArgs(
        size: 3,
        vsAi: true,
        quickMatch: true,
        opponentName: 'Rival',
      );
      expect(InGameChatGate.isAiOrLocalMatch(
          vsAi: doll.vsAi, quickMatch: doll.quickMatch), isTrue);
      expect(InGameChatGate.isAiOrLocalMatch(
          vsAi: quick.vsAi, quickMatch: quick.quickMatch), isTrue);
    });
  });

  group('GameChatMessage', () {
    test('parses json and marks mine', () {
      final m = GameChatMessage.fromJson({
        'id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'room_id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'sender_id': 'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'message': 'hello',
        'created_at': '2026-01-01T12:00:00Z',
      });
      expect(m.message, 'hello');
      expect(m.isMine('cccccccc-cccc-cccc-cccc-cccccccccccc'), isTrue);
      expect(m.isMine('dddddddd-dddd-dddd-dddd-dddddddddddd'), isFalse);
    });

    test('allowed reaction emoji set is fixed', () {
      expect(GameChatMessage.allowedEmojis, contains('👍'));
      expect(GameChatMessage.allowedEmojis, contains('❤️'));
      expect(GameChatMessage.allowedEmojis.length, 6);
    });
  });
}
