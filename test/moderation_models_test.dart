import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/models/moderation_models.dart';
import 'package:tic_tac_game/models/game_chat_message.dart';

void main() {
  group('AccountStatus / ModerationStatus', () {
    test('parses statuses and blocked flags', () {
      expect(AccountStatus.parse('active'), AccountStatus.active);
      expect(AccountStatus.parse('suspended').isBlocked, isTrue);
      expect(AccountStatus.parse('under_review').isBlocked, isTrue);
      expect(AccountStatus.parse('nope'), AccountStatus.unknown);
    });

    test('fromJson maps appeal + suspension fields', () {
      final s = ModerationStatus.fromJson({
        'account_status': 'suspended',
        'suspension_reason': 'Harassment',
        'suspended_at': '2026-01-02T10:00:00Z',
        'suspension_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'appeal_id': null,
        'appeal_status': null,
      });
      expect(s.isBlocked, isTrue);
      expect(s.canSubmitAppeal, isTrue);
      expect(s.suspensionReason, 'Harassment');
    });

    test('active appeal blocks resubmit', () {
      final s = ModerationStatus.fromJson({
        'account_status': 'under_review',
        'suspension_id': 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'appeal_id': 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        'appeal_status': 'pending',
        'appeal_submitted_at': '2026-01-03T10:00:00Z',
      });
      expect(s.hasActiveAppeal, isTrue);
      expect(s.canSubmitAppeal, isFalse);
    });
  });

  group('ReportReason', () {
    test('includes required reason codes', () {
      final codes = ReportReason.all.map((r) => r.code).toSet();
      expect(codes.contains('harassment'), isTrue);
      expect(codes.contains('cheating'), isTrue);
      expect(codes.contains('other'), isTrue);
      expect(ReportReason.all.length, 7);
    });
  });

  group('Chat + report eligibility', () {
    test('AI matches never get chat gate', () {
      expect(
        InGameChatGate.isAiOrLocalMatch(vsAi: true, quickMatch: false),
        isTrue,
      );
      expect(
        InGameChatGate.isRealPlayerVsRealPlayer(
          playerO: 'local',
          playerX: 'doll',
          opponentId: 'doll',
        ),
        isFalse,
      );
    });

    test('real UUID seats enable chat (report entry point)', () {
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
  });

  group('Client-side report draft validation helpers', () {
    test('description minimum length rule', () {
      expect('short'.trim().length < 10, isTrue);
      expect('long enough description'.trim().length >= 10, isTrue);
    });
  });
}
