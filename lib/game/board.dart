/// Pure board rules for 3×3 (need 3) and 4×4 / 5×5 (need 4 in a row).
class Board {
  final int size;
  final int winLength;
  final List<String?> cells;

  Board(this.size)
      : winLength = size == 3 ? 3 : 4,
        cells = List<String?>.filled(size * size, null);

  Board._(this.size, this.winLength, this.cells);

  /// Rebuild a board for isolates / snapshots.
  factory Board.fromCells(int size, List<String?> cells) {
    final b = Board(size);
    final n = b.cells.length;
    for (var i = 0; i < n && i < cells.length; i++) {
      b.cells[i] = cells[i];
    }
    return b;
  }

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

  static const _dirs = [
    [0, 1],
    [1, 0],
    [1, 1],
    [1, -1],
  ];

  /// Heuristic from the AI mark's perspective (positive = good for [ai]).
  ///
  /// Scores each sliding window of [winLength] so lines are not double-counted
  /// per occupied cell. Mixed windows (both marks) score 0.
  int evaluate(String ai, String human) {
    var score = 0;
    for (final d in _dirs) {
      final dr = d[0], dc = d[1];
      for (var r = 0; r < size; r++) {
        for (var c = 0; c < size; c++) {
          final er = r + dr * (winLength - 1);
          final ec = c + dc * (winLength - 1);
          if (er < 0 || er >= size || ec < 0 || ec >= size) continue;

          var aiCount = 0, humanCount = 0;
          for (var k = 0; k < winLength; k++) {
            final v = cells[(r + dr * k) * size + (c + dc * k)];
            if (v == ai) {
              aiCount++;
            } else if (v == human) {
              humanCount++;
            }
          }
          if (aiCount > 0 && humanCount > 0) continue;
          if (aiCount > 0) score += _windowWeight(aiCount);
          if (humanCount > 0) score -= _windowWeight(humanCount);
        }
      }
    }
    final mid = (size ~/ 2) * size + size ~/ 2;
    if (cells[mid] == ai) score += 30;
    if (cells[mid] == human) score -= 30;
    return score;
  }

  int _windowWeight(int count) {
    if (count >= winLength) return 100000;
    if (count == winLength - 1) return 5000;
    if (count == winLength - 2) return 200;
    if (count == 1) return 10;
    return count * 40;
  }
}
