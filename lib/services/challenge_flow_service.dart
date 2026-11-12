import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models.dart';

enum ChallengeStakeKind { free, coins5 }

enum ChallengeItemStatus { pending, expired, accepted, declined, cancelled }

class ChallengeItem {
  final String id;
  final String opponentId;
  final String opponentName;
  final String? avatarUrl;
  final int rank;
  final int score;
  final ChallengeStakeKind stake;
  final bool outgoing; // true = I sent
  ChallengeItemStatus status;
  final DateTime createdAt;
  int secondsLeft;

  ChallengeItem({
    required this.id,
    required this.opponentId,
    required this.opponentName,
    this.avatarUrl,
    required this.rank,
    required this.score,
    required this.stake,
    required this.outgoing,
    this.status = ChallengeItemStatus.pending,
    DateTime? createdAt,
    this.secondsLeft = 60,
  }) : createdAt = createdAt ?? DateTime.now();

  String get stakeLabel =>
      stake == ChallengeStakeKind.free ? 'Free match' : '5 coins';
}

/// Local challenge inbox (PDF pages 3–6) until server RPCs exist.
class ChallengeFlowService {
  ChallengeFlowService._();

  static final ValueNotifier<List<ChallengeItem>> items =
      ValueNotifier<List<ChallengeItem>>(const []);
  static final ValueNotifier<ChallengeItem?> incomingPopup =
      ValueNotifier<ChallengeItem?>(null);

  static Timer? _tick;

  static void _ensureTicker() {
    _tick ??= Timer.periodic(const Duration(seconds: 1), (_) {
      final next = <ChallengeItem>[];
      var changed = false;
      for (final c in items.value) {
        if (c.status == ChallengeItemStatus.pending && c.secondsLeft > 0) {
          c.secondsLeft -= 1;
          changed = true;
          if (c.secondsLeft <= 0) {
            c.status = ChallengeItemStatus.expired;
          }
        }
        next.add(c);
      }
      if (changed) items.value = List.unmodifiable(next);
    });
  }

  static ChallengeItem send({
    required String opponentId,
    required String opponentName,
    String? avatarUrl,
    required int rank,
    required int score,
    required ChallengeStakeKind stake,
  }) {
    _ensureTicker();
    if (stake == ChallengeStakeKind.coins5 && coins.value < 5) {
      throw Exception('Not enough coins');
    }
    final c = ChallengeItem(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      opponentId: opponentId,
      opponentName: opponentName,
      avatarUrl: avatarUrl,
      rank: rank,
      score: score,
      stake: stake,
      outgoing: true,
    );
    items.value = List.unmodifiable([c, ...items.value]);
    return c;
  }

  /// Demo: simulate opponent challenging you (single-device testing).
  static ChallengeItem simulateIncoming({
    required String fromId,
    required String fromName,
    String? avatarUrl,
    int rank = 1,
    int score = 76,
    ChallengeStakeKind stake = ChallengeStakeKind.free,
  }) {
    _ensureTicker();
    final c = ChallengeItem(
      id: 'in_${DateTime.now().millisecondsSinceEpoch}',
      opponentId: fromId,
      opponentName: fromName,
      avatarUrl: avatarUrl,
      rank: rank,
      score: score,
      stake: stake,
      outgoing: false,
    );
    items.value = List.unmodifiable([c, ...items.value]);
    incomingPopup.value = c;
    return c;
  }

  static void dismissIncomingPopup() => incomingPopup.value = null;

  static void cancel(String id) {
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.cancelled;
      c.secondsLeft = 0;
    });
  }

  static void decline(String id) {
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.declined;
      c.secondsLeft = 0;
    });
    if (incomingPopup.value?.id == id) incomingPopup.value = null;
  }

  static ChallengeItem? accept(String id) {
    ChallengeItem? found;
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.accepted;
      c.secondsLeft = 0;
      found = c;
      if (c.stake == ChallengeStakeKind.coins5 && coins.value >= 5) {
        coins.value -= 5;
      }
    });
    if (incomingPopup.value?.id == id) incomingPopup.value = null;
    return found;
  }

  static void _mutate(String id, void Function(ChallengeItem) fn) {
    final list = [for (final c in items.value) c];
    final i = list.indexWhere((e) => e.id == id);
    if (i < 0) return;
    fn(list[i]);
    items.value = List.unmodifiable(list);
  }

  static List<ChallengeItem> received() => [
        for (final c in items.value)
          if (!c.outgoing &&
              (c.status == ChallengeItemStatus.pending ||
                  c.status == ChallengeItemStatus.accepted))
            c
      ];

  static List<ChallengeItem> sent() => [
        for (final c in items.value) if (c.outgoing) c
      ];

  static List<ChallengeItem> history() => [
        for (final c in items.value)
          if (c.status == ChallengeItemStatus.expired ||
              c.status == ChallengeItemStatus.declined ||
              c.status == ChallengeItemStatus.cancelled)
            c
      ];
}
