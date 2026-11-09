/// Pure board rules for 3×3 (need 3) and 4×4 / 5×5 (need 4 in a row).
class Board {
  final int size;
  final int winLength;
  final List<String?> cells;

  Board(this.size)
      : winLength = size == 3 ? 3 : 4,
        cells = List<String?>.filled(size * size, null);

  Board._(this.size, this.winLength, this.cells);

  Board clone() => Board._(size, winLength, List<String?>.from(cells));

  List<int> get emptyCells => [
        for (var i = 0; i < cells.length; i++)
          if (cells[i] == null) i
      ];

  bool get isFull => !cells.contains(null);

  bool winsAt(int idx, String player) {
    if (cells[idx] != player) return false;
    final r = idx ~/ size, c = idx % size;
    for (final d in const [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1]
    ]) {
      var count = 1;
      for (final s in const [1, -1]) {
        var rr = r + d[0] * s, cc = c + d[1] * s;
        while (rr >= 0 &&
            rr < size &&
            cc >= 0 &&
            cc < size &&
            cells[rr * size + cc] == player) {
          count++;
          rr += d[0] * s;
          cc += d[1] * s;
        }
      }
      if (count >= winLength) return true;
    }
    return false;
  }

  /// Returns winning player, 'draw', or null if ongoing.
  String? outcomeIfPlace(int idx, String player) {
    cells[idx] = player;
    if (winsAt(idx, player)) return player;
    if (isFull) return 'draw';
    return null;
  }

  /// Longest run for [player] through [idx] in any direction.
  int lineStrength(int idx, String player) {
    final r = idx ~/ size, c = idx % size;
    var best = 0;
    for (final d in const [
      [0, 1],
      [1, 0],
      [1, 1],
      [1, -1]
    ]) {
      var count = 1;
      for (final s in const [1, -1]) {
        var rr = r + d[0] * s, cc = c + d[1] * s;
        while (rr >= 0 &&
            rr < size &&
            cc >= 0 &&
            cc < size &&
            cells[rr * size + cc] == player) {
          count++;
          rr += d[0] * s;
          cc += d[1] * s;
        }
      }
      if (count > best) best = count;
    }
    return best;
  }

  /// Heuristic score from AI (X) perspective.
  int evaluate(String ai, String human) {
    var score = 0;
    for (var i = 0; i < cells.length; i++) {
      if (cells[i] == null) continue;
      final s = lineStrength(i, cells[i]!);
      final weight = s >= winLength
          ? 100000
          : s == winLength - 1
              ? 5000
              : s == winLength - 2
                  ? 200
                  : s * 10;
      score += cells[i] == ai ? weight : -weight;
    }
    // Prefer center control.
    final mid = (size ~/ 2) * size + size ~/ 2;
    if (cells[mid] == ai) score += 30;
    if (cells[mid] == human) score -= 30;
    return score;
  }
}
