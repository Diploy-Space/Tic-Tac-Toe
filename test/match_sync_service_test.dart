import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/services/match_sync_service.dart';

void main() {
  group('MatchSyncService mapping', () {
    test('cloudMode maps doll and quick match; skips pass & play', () {
      expect(
        MatchSyncService.cloudMode(vsAi: true, quickMatch: false),
        'ai',
      );
      expect(
        MatchSyncService.cloudMode(vsAi: true, quickMatch: true),
        'quick_match',
      );
      expect(
        MatchSyncService.cloudMode(vsAi: false, quickMatch: false),
        isNull,
      );
    });

    test('cloudResult maps O/X/draw for AI; null for pass & play', () {
      expect(
        MatchSyncService.cloudResult(winner: 'O', vsAi: true),
        'win',
      );
      expect(
        MatchSyncService.cloudResult(winner: 'X', vsAi: true),
        'loss',
      );
      expect(
        MatchSyncService.cloudResult(winner: null, vsAi: true),
        'draw',
      );
      expect(
        MatchSyncService.cloudResult(winner: 'O', vsAi: false),
        isNull,
      );
    });

    test('MatchSyncResult.skipped is ok without attempt', () {
      expect(MatchSyncResult.skipped.attempted, isFalse);
      expect(MatchSyncResult.skipped.ok, isTrue);
    });

    test('newMatchId returns UUID-shaped strings', () {
      final id = MatchSyncService.newMatchId();
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(id),
        isTrue,
      );
      expect(MatchSyncService.newMatchId(), isNot(id));
    });
  });
}
