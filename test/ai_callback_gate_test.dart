import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/game/ai_callback_gate.dart';

void main() {
  group('AiCallbackGate', () {
    test('allowMove only when token matches and it is AI turn', () {
      final gate = AiCallbackGate();
      final token = gate.token;

      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'X',
        ),
        isTrue,
      );

      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'O',
        ),
        isFalse,
      );
    });

    test('invalidate blocks previously scheduled callbacks', () {
      final gate = AiCallbackGate();
      final oldToken = gate.token;
      gate.invalidate();

      expect(gate.isValid(oldToken), isFalse);
      expect(
        gate.allowMove(
          scheduledToken: oldToken,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'X',
        ),
        isFalse,
      );
      expect(
        gate.allowMove(
          scheduledToken: gate.token,
          mounted: true,
          over: false,
          vsAi: true,
          turn: 'X',
        ),
        isTrue,
      );
    });

    test('blocks moves when game is over or vsAi is false', () {
      final gate = AiCallbackGate();
      final token = gate.token;

      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: true,
          over: true,
          vsAi: true,
          turn: 'X',
        ),
        isFalse,
      );
      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: true,
          over: false,
          vsAi: false,
          turn: 'X',
        ),
        isFalse,
      );
      expect(
        gate.allowMove(
          scheduledToken: token,
          mounted: false,
          over: false,
          vsAi: true,
          turn: 'X',
        ),
        isFalse,
      );
    });

    test('timeout-style invalidate then new schedule uses fresh token', () {
      final gate = AiCallbackGate();
      final pending = gate.token;
      // Simulate timeout cancelling pending AI.
      gate.invalidate();
      final next = gate.token;

      expect(gate.isValid(pending), isFalse);
      expect(gate.isValid(next), isTrue);
      expect(next, isNot(pending));
    });
  });
}
