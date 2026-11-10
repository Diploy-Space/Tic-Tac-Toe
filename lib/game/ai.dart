import 'dart:isolate';
import 'dart:math';
import 'board.dart';

/// Computer opponent with difficulty-scaled negamax + alpha-beta search.
///
/// Score convention (negamax, **side-to-move**):
/// - Positive values favor the player about to move.
/// - [Board.evaluate] is **AI-centric** (positive = good for X).
/// - Depth-0 leaves convert: `toMove == ai ? eval : -eval`.
/// - Terminal wins use `_winScore + depth` so faster mates rank higher.
class GameAi {
  GameAi({Random? random}) : _rnd = random ?? Random();
  final Random _rnd;

  static const aiMark = 'X';
  static const humanMark = 'O';

  static const _inf = 0x3fffffff;
  static const _winScore = 100000;
  static const _rootWinScore = 1000000;

  /// Soft time budget for iterative deepening on 4×4 / 5×5 Hard.
  static const hardTimeBudget = Duration(milliseconds: 90);

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

  /// Runs Medium/Hard search off the UI isolate so the frame pipeline stays free.
  static Future<int> chooseMoveAsync(
    Board board,
    String difficulty, {
    int? seed,
  }) async {
    if (difficulty == 'Easy' || board.emptyCells.length <= 1) {
      return GameAi(random: seed == null ? Random() : Random(seed))
          .chooseMove(board, difficulty);
    }
    final size = board.size;
    final cells = List<String?>.from(board.cells);
    final rndSeed = seed ?? DateTime.now().microsecondsSinceEpoch;
    return Isolate.run(() {
      final b = Board.fromCells(size, cells);
      return GameAi(random: Random(rndSeed)).chooseMove(b, difficulty);
    });
  }

  int _easy(Board board, List<int> empty) {
    // Mostly random; ~20% chance to notice an immediate win or block.
    if (_rnd.nextDouble() < 0.20) {
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
    if (_rnd.nextDouble() < 0.85) {
      final block = _winningMove(board, empty, humanMark);
      if (block != null) return block;
    }
    final depth = board.size == 3 ? 3 : 2;
    final best = _search(
      board,
      depth: depth,
      empty: empty,
      pickRandomAmongBest: false,
    );
    // Controlled noise after a real search attempt.
    if (_rnd.nextDouble() < 0.18) {
      return empty[_rnd.nextInt(empty.length)];
    }
    return best ?? empty.first;
  }

  int _hard(Board board, List<int> empty) {
    final win = _winningMove(board, empty, aiMark);
    if (win != null) return win;
    final block = _winningMove(board, empty, humanMark);
    if (block != null) return block;

    if (board.size == 3) {
      return _search(
            board,
            depth: empty.length,
            empty: empty,
            pickRandomAmongBest: false,
          ) ??
          empty.first;
    }

    return _iterativeDeepening(
      board,
      empty: empty,
      maxDepth: board.size == 4 ? 5 : 4,
      budget: hardTimeBudget,
    );
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

  /// Root search with shared alpha across moves. Returns null if time-aborted
  /// before every root move was considered (caller keeps prior ID result).
  int? _search(
    Board board, {
    required int depth,
    required List<int> empty,
    required bool pickRandomAmongBest,
    Stopwatch? watch,
    Duration? budget,
  }) {
    var bestScore = -_inf;
    var bestMoves = <int>[];
    var alpha = -_inf;
    const beta = _inf;
    final ordered = _orderMoves(board, empty);

    for (final i in ordered) {
      if (budget != null && watch != null && watch.elapsed >= budget) {
        return bestMoves.isEmpty ? null : bestMoves.first;
      }

      board.cells[i] = aiMark;
      late final int score;
      if (board.winsAt(i, aiMark)) {
        score = _rootWinScore;
      } else if (board.isFull) {
        score = 0;
      } else if (depth <= 0) {
        score = board.evaluate(aiMark, humanMark);
      } else {
        score = -_negamax(
          board,
          depth - 1,
          -beta,
          -alpha,
          humanMark,
          watch: watch,
          budget: budget,
        );
      }
      board.cells[i] = null;

      if (bestMoves.isEmpty || score > bestScore) {
        bestScore = score;
        bestMoves = [i];
      } else if (score == bestScore) {
        bestMoves.add(i);
      }
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;
    }

    if (bestMoves.isEmpty) return null;
    if (pickRandomAmongBest) {
      return bestMoves[_rnd.nextInt(bestMoves.length)];
    }
    return bestMoves.first;
  }

  int _iterativeDeepening(
    Board board, {
    required List<int> empty,
    required int maxDepth,
    required Duration budget,
  }) {
    final watch = Stopwatch()..start();
    var best = _orderMoves(board, empty).first;
    final limit = maxDepth.clamp(1, empty.length);

    for (var d = 1; d <= limit; d++) {
      if (watch.elapsed >= budget) break;
      final move = _search(
        board,
        depth: d,
        empty: empty,
        pickRandomAmongBest: false,
        watch: watch,
        budget: budget,
      );
      if (move == null) break;
      best = move;

      board.cells[best] = aiMark;
      final won = board.winsAt(best, aiMark);
      board.cells[best] = null;
      if (won) break;
    }
    return best;
  }

  List<int> _orderMoves(Board board, List<int> empty) {
    final mid = (board.size ~/ 2) * board.size + board.size ~/ 2;
    final scored = <MapEntry<int, int>>[];
    for (final i in empty) {
      var h = i == mid ? 50 : 0;
      board.cells[i] = aiMark;
      if (board.winsAt(i, aiMark)) h += 100000;
      board.cells[i] = humanMark;
      if (board.winsAt(i, humanMark)) h += 50000;
      board.cells[i] = null;
      h += board.lineStrength(i, aiMark) * 10;
      scored.add(MapEntry(i, h));
    }
    scored.sort((a, b) {
      final c = b.value.compareTo(a.value);
      return c != 0 ? c : a.key.compareTo(b.key);
    });
    return [for (final e in scored) e.key];
  }

  /// Negamax + α-β. Return value is from [toMove]'s perspective.
  int _negamax(
    Board board,
    int depth,
    int alpha,
    int beta,
    String toMove, {
    Stopwatch? watch,
    Duration? budget,
  }) {
    if (budget != null && watch != null && watch.elapsed >= budget) {
      final eval = board.evaluate(aiMark, humanMark);
      return toMove == aiMark ? eval : -eval;
    }

    final empty = board.emptyCells;
    if (empty.isEmpty) return 0;

    if (depth == 0) {
      // AI-centric heuristic → side-to-move.
      final eval = board.evaluate(aiMark, humanMark);
      return toMove == aiMark ? eval : -eval;
    }

    var best = -_inf;
    for (final i in _orderMoves(board, empty)) {
      board.cells[i] = toMove;
      late final int score;
      if (board.winsAt(i, toMove)) {
        score = _winScore + depth;
      } else if (board.isFull) {
        score = 0;
      } else {
        final next = toMove == aiMark ? humanMark : aiMark;
        score = -_negamax(
          board,
          depth - 1,
          -beta,
          -alpha,
          next,
          watch: watch,
          budget: budget,
        );
      }
      board.cells[i] = null;

      if (score > best) best = score;
      if (score > alpha) alpha = score;
      if (alpha >= beta) break;
    }
    return best;
  }
}
