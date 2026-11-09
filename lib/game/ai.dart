import 'dart:math';
import 'board.dart';

/// Computer opponent with difficulty-scaled decision making.
class GameAi {
  GameAi({Random? random}) : _rnd = random ?? Random();
  final Random _rnd;

  static const aiMark = 'X';
  static const humanMark = 'O';

  int chooseMove(Board board, String difficulty) {
    final empty = board.emptyCells;
    if (empty.isEmpty) return 0;
    switch (difficulty) {
      case 'Easy':
        return _easy(board, empty);
      case 'Hard':
        return _hard(board, empty);
      default:
        return _medium(board, empty);
    }
  }

  int _easy(Board board, List<int> empty) {
    // 25% chance to take an immediate win / block; else random.
    if (_rnd.nextDouble() < .25) {
      final win = _winningMove(board, empty, aiMark);
      if (win != null) return win;
      final block = _winningMove(board, empty, humanMark);
      if (block != null) return block;
    }
    return empty[_rnd.nextInt(empty.length)];
  }

  int _medium(Board board, List<int> empty) {
    final win = _winningMove(board, empty, aiMark);
    if (win != null) return win;
    if (_rnd.nextDouble() < .85) {
      final block = _winningMove(board, empty, humanMark);
      if (block != null) return block;
    }
    // Shallow search with occasional noise.
    final best = _search(board, depth: board.size == 3 ? 4 : 2, empty: empty);
    if (_rnd.nextDouble() < .2) return empty[_rnd.nextInt(empty.length)];
    return best;
  }

  int _hard(Board board, List<int> empty) {
    final win = _winningMove(board, empty, aiMark);
    if (win != null) return win;
    final block = _winningMove(board, empty, humanMark);
    if (block != null) return block;
    // Full minimax on 3×3; deeper heuristic search on larger boards.
    final depth = board.size == 3
        ? 9
        : board.size == 4
            ? 3
            : 2;
    return _search(board, depth: depth, empty: empty);
  }

  int? _winningMove(Board board, List<int> empty, String mark) {
    for (final i in empty) {
      board.cells[i] = mark;
      final w = board.winsAt(i, mark);
      board.cells[i] = null;
      if (w) return i;
    }
    return null;
  }

  int _search(Board board, {required int depth, required List<int> empty}) {
    var bestScore = -0x3fffffff;
    var bestMoves = <int>[empty.first];
    final ordered = _orderMoves(board, empty);
    for (final i in ordered) {
      board.cells[i] = aiMark;
      final score = board.winsAt(i, aiMark)
          ? 1000000
          : -_negamax(board, depth - 1, -0x3fffffff, 0x3fffffff, humanMark);
      board.cells[i] = null;
      if (score > bestScore) {
        bestScore = score;
        bestMoves = [i];
      } else if (score == bestScore) {
        bestMoves.add(i);
      }
    }
    return bestMoves[_rnd.nextInt(bestMoves.length)];
  }

  List<int> _orderMoves(Board board, List<int> empty) {
    final mid = (board.size ~/ 2) * board.size + board.size ~/ 2;
    final scored = [
      for (final i in empty)
        MapEntry(i, (i == mid ? 50 : 0) + board.lineStrength(i, aiMark) * 10)
    ]..sort((a, b) => b.value.compareTo(a.value));
    return [for (final e in scored) e.key];
  }

  int _negamax(Board board, int depth, int alpha, int beta, String toMove) {
    final empty = board.emptyCells;
    if (empty.isEmpty) return 0;
    if (depth == 0) {
      return board.evaluate(aiMark, humanMark) *
          (toMove == aiMark ? 1 : -1);
    }

    var best = -0x3fffffff;
    for (final i in _orderMoves(board, empty)) {
      board.cells[i] = toMove;
      int score;
      if (board.winsAt(i, toMove)) {
        score = 100000 + depth;
      } else {
        final next = toMove == aiMark ? humanMark : aiMark;
        score = -_negamax(board, depth - 1, -beta, -alpha, next);
      }
      board.cells[i] = null;
      if (score > best) best = score;
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;
    }
    return best;
  }
}
