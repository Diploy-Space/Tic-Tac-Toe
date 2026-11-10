/// Invalidates delayed AI callbacks when the turn changes, the game ends,
/// or the player leaves — preventing stale Timer firings from placing moves.
class AiCallbackGate {
  int _token = 0;

  int get token => _token;

  /// Cancels logical validity of any previously scheduled callback.
  int invalidate() => ++_token;

  bool isValid(int scheduledToken) => scheduledToken == _token;

  /// Whether an AI move may be applied for this scheduled callback.
  bool allowMove({
    required int scheduledToken,
    required bool mounted,
    required bool over,
    required bool vsAi,
    required String turn,
  }) {
    return isValid(scheduledToken) &&
        mounted &&
        !over &&
        vsAi &&
        turn == 'X';
  }
}
