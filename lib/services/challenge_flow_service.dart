import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models.dart';
import 'app_locale_service.dart';
import 'auth_service.dart';
import '../l10n/app_localizations.dart';

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
  final DateTime? expiresAt;
  int secondsLeft;

  /// Online room created when the challenge was accepted (server only).
  String? roomId;

  /// `busy` when the player was in a match and the app declined for them.
  String? declineReason;

  bool get declinedBusy =>
      status == ChallengeItemStatus.declined && declineReason == 'busy';

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
    this.expiresAt,
    this.secondsLeft = 60,
    this.roomId,
    this.declineReason,
  }) : createdAt = createdAt ?? DateTime.now();

  String get stakeLabel => stake == ChallengeStakeKind.free
      ? l10nNow.freeMatch
      : '${AppLocaleService.currencySymbol}${l10nNow.coins5}';

  ChallengeItem copyWith({
    ChallengeItemStatus? status,
    int? secondsLeft,
    String? opponentName,
    String? avatarUrl,
    int? rank,
    int? score,
  }) {
    return ChallengeItem(
      id: id,
      opponentId: opponentId,
      opponentName: opponentName ?? this.opponentName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      stake: stake,
      outgoing: outgoing,
      status: status ?? this.status,
      createdAt: createdAt,
      expiresAt: expiresAt,
      secondsLeft: secondsLeft ?? this.secondsLeft,
      roomId: roomId,
      declineReason: declineReason,
    );
  }

  /// Room stake as stored on the server (free = 0, coins5 = 5).
  int get roomStake => stake == ChallengeStakeKind.coins5 ? 5 : 0;

  /// Arguments for `/match-lobby`; with [roomId] the lobby opens the real
  /// online room, otherwise (signed-out demo) a local match.
  Map<String, dynamic> lobbyArgs() => {
        'opponentName': opponentName,
        'opponentId': opponentId,
        'stakeLabel': stakeLabel,
        if (roomId != null) 'roomId': roomId,
        // Challenger plays O, the player who accepted plays X.
        if (roomId != null) 'myMark': outgoing ? 'O' : 'X',
        if (roomId != null) 'stake': roomStake,
      };
}

/// Challenge inbox + Supabase realtime (send / accept / decline).
class ChallengeFlowService {
  ChallengeFlowService._();

  static final ValueNotifier<List<ChallengeItem>> items =
      ValueNotifier<List<ChallengeItem>>(const []);
  static final ValueNotifier<ChallengeItem?> incomingPopup =
      ValueNotifier<ChallengeItem?>(null);

  /// Cached can-challenge results keyed by target user id.
  static final ValueNotifier<Map<String, bool>> canChallengeByUser =
      ValueNotifier<Map<String, bool>>(const {});

  static Timer? _tick;
  static RealtimeChannel? _channel;
  static String? _listeningUid;
  static bool _busyClient = false;
  static void Function(ChallengeItem)? _onIncomingAvailable;
  static void Function(ChallengeItem)? _onOutgoingResolved;

  static SupabaseClient get _db => AuthService.client;

  /// Routes where the player is considered "in a match" and must not see popups.
  static const busyRoutes = {
    '/game',
    '/online-room',
    '/online-matching',
    '/matching',
    '/match-lobby',
    '/tournament-match',
    '/tournament-ready',
  };

  static void setBusyClient(bool busy) => _busyClient = busy;

  static void setIncomingHandler(void Function(ChallengeItem)? fn) {
    _onIncomingAvailable = fn;
  }

  static void setOutgoingResolvedHandler(void Function(ChallengeItem)? fn) {
    _onOutgoingResolved = fn;
  }

  static void _ensureTicker() {
    _tick ??= Timer.periodic(const Duration(seconds: 1), (_) {
      final next = <ChallengeItem>[];
      var changed = false;
      for (final c in items.value) {
        var item = c;
        if (item.status == ChallengeItemStatus.pending) {
          final left = item.expiresAt != null
              ? item.expiresAt!.difference(DateTime.now()).inSeconds
              : item.secondsLeft - 1;
          final clamped = left.clamp(0, 60);
          if (clamped != item.secondsLeft) {
            item = item.copyWith(secondsLeft: clamped);
            changed = true;
          }
          if (clamped <= 0 && item.status == ChallengeItemStatus.pending) {
            item = item.copyWith(
              status: ChallengeItemStatus.expired,
              secondsLeft: 0,
            );
            changed = true;
            if (incomingPopup.value?.id == item.id) {
              incomingPopup.value = null;
            }
          }
        }
        next.add(item);
      }
      if (changed) {
        items.value = List.unmodifiable(next);
        _syncIncomingFromList();
      }
    });
  }

  static void _syncIncomingFromList() {
    final pendingIn = items.value.where(
      (c) =>
          !c.outgoing &&
          c.status == ChallengeItemStatus.pending &&
          c.secondsLeft > 0,
    );
    final first = pendingIn.isEmpty ? null : pendingIn.first;
    if (incomingPopup.value?.id != first?.id) {
      incomingPopup.value = first;
    } else if (first != null) {
      incomingPopup.value = first;
    }
  }

  static Future<void> start() async {
    final uid = AuthService.user?.id;
    if (uid == null) {
      await stop();
      return;
    }
    if (_listeningUid == uid && _channel != null) return;
    await stop();
    _listeningUid = uid;
    _ensureTicker();
    await refresh();
    _channel = _db.channel('challenges-$uid');
    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'challenges',
          callback: (payload) => unawaited(_onRow(payload.newRecord)),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'challenges',
          callback: (payload) => unawaited(_onRow(payload.newRecord)),
        )
        .subscribe();
  }

  static Future<void> stop() async {
    await _channel?.unsubscribe();
    _channel = null;
    _listeningUid = null;
    incomingPopup.value = null;
  }

  static Future<void> clear() async {
    await stop();
    items.value = const [];
    canChallengeByUser.value = const {};
  }

  static Future<void> refresh() async {
    final uid = AuthService.user?.id;
    if (uid == null) return;
    try {
      final rows = await _db
          .from('challenges')
          .select()
          .or('challenger_id.eq.$uid,challenged_id.eq.$uid')
          .order('created_at', ascending: false)
          .limit(40);
      final list = <ChallengeItem>[];
      for (final raw in rows as List) {
        final map = Map<String, dynamic>.from(raw as Map);
        final item = await _itemFromRow(map, uid);
        if (item != null) list.add(item);
      }
      items.value = List.unmodifiable(list);
      _syncIncomingFromList();
      _presentIncomingIfNeeded();
    } catch (e, st) {
      debugPrint('ChallengeFlowService.refresh: $e\n$st');
    }
  }

  static Future<void> _onRow(Map<String, dynamic> row) async {
    final uid = AuthService.user?.id;
    if (uid == null) return;
    final item = await _itemFromRow(row, uid);
    if (item == null) return;
    _upsert(item);
    if (!item.outgoing && item.status == ChallengeItemStatus.pending) {
      _presentIncomingIfNeeded();
    }
    if (item.outgoing &&
        (item.status == ChallengeItemStatus.accepted ||
            item.status == ChallengeItemStatus.declined ||
            item.status == ChallengeItemStatus.cancelled ||
            item.status == ChallengeItemStatus.expired)) {
      _onOutgoingResolved?.call(item);
    }
  }

  static void _upsert(ChallengeItem item) {
    final list = [for (final c in items.value) c];
    final i = list.indexWhere((e) => e.id == item.id);
    if (i < 0) {
      list.insert(0, item);
    } else {
      list[i] = item;
    }
    items.value = List.unmodifiable(list);
    _syncIncomingFromList();
  }

  static Future<ChallengeItem?> _itemFromRow(
    Map<String, dynamic> row,
    String uid,
  ) async {
    final challengerId = '${row['challenger_id'] ?? ''}';
    final challengedId = '${row['challenged_id'] ?? ''}';
    if (challengerId.isEmpty || challengedId.isEmpty) return null;
    final outgoing = challengerId == uid;
    final opponentId = outgoing ? challengedId : challengerId;
    final stakeRaw = '${row['stake_kind'] ?? 'free'}';
    final stake = stakeRaw == 'coins5'
        ? ChallengeStakeKind.coins5
        : ChallengeStakeKind.free;
    final status = _parseStatus('${row['status'] ?? 'pending'}');
    final created = DateTime.tryParse('${row['created_at'] ?? ''}')?.toLocal();
    final expires = DateTime.tryParse('${row['expires_at'] ?? ''}')?.toLocal();
    var seconds = 60;
    if (expires != null) {
      seconds = expires.difference(DateTime.now()).inSeconds.clamp(0, 60);
    }
    var name = 'player';
    String? avatar;
    var rank = 0;
    var score = 0;
    final existing = items.value.where((e) => e.opponentId == opponentId);
    if (existing.isNotEmpty) {
      name = existing.first.opponentName;
      avatar = existing.first.avatarUrl;
      rank = existing.first.rank;
      score = existing.first.score;
    } else {
      try {
        final p = await _db
            .from('profiles')
            .select('username, avatar_url')
            .eq('id', opponentId)
            .maybeSingle();
        if (p != null) {
          name = '${p['username'] ?? name}';
          avatar = p['avatar_url'] as String?;
        }
      } catch (_) {}
    }
    return ChallengeItem(
      id: '${row['id']}',
      opponentId: opponentId,
      opponentName: name,
      avatarUrl: avatar,
      rank: rank,
      score: score,
      stake: stake,
      outgoing: outgoing,
      status: status,
      createdAt: created,
      expiresAt: expires,
      secondsLeft: status == ChallengeItemStatus.pending ? seconds : 0,
      roomId: row['room_id'] == null ? null : '${row['room_id']}',
      declineReason: row['decline_reason'] as String?,
    );
  }

  static ChallengeItemStatus _parseStatus(String s) {
    switch (s) {
      case 'accepted':
        return ChallengeItemStatus.accepted;
      case 'declined':
        return ChallengeItemStatus.declined;
      case 'cancelled':
        return ChallengeItemStatus.cancelled;
      case 'expired':
        return ChallengeItemStatus.expired;
      default:
        return ChallengeItemStatus.pending;
    }
  }

  static void _presentIncomingIfNeeded() {
    final c = incomingPopup.value;
    if (c == null || c.status != ChallengeItemStatus.pending) return;
    if (_busyClient) {
      unawaited(declineBusy(c.id));
      return;
    }
    _onIncomingAvailable?.call(c);
  }

  /// Last `can_challenge_user` refusal reason per user
  /// (`nobody` | `friends_only` | `self` | `missing`).
  static final Map<String, String> challengeBlockReason = {};

  static Future<bool> canChallenge(String targetUserId) async {
    if (!AuthService.isSignedIn) return true; // show CTA; sign-in gated on tap
    if (targetUserId == AuthService.user?.id) return false;
    try {
      final raw = await _db.rpc(
        'can_challenge_user',
        params: {'p_target_id': targetUserId},
      );
      final map = _asMap(raw);
      final allowed = map != null && map['allowed'] == true;
      final reason = map?['reason'];
      if (allowed || reason == null) {
        challengeBlockReason.remove(targetUserId);
      } else {
        challengeBlockReason[targetUserId] = '$reason';
      }
      final next = Map<String, bool>.from(canChallengeByUser.value);
      next[targetUserId] = allowed;
      canChallengeByUser.value = Map.unmodifiable(next);
      return allowed;
    } catch (e) {
      debugPrint('canChallenge: $e');
      return true; // fail-open for offline/demo until migration applied
    }
  }

  static Future<ChallengeItem> send({
    required String opponentId,
    required String opponentName,
    String? avatarUrl,
    required int rank,
    required int score,
    required ChallengeStakeKind stake,
  }) async {
    _ensureTicker();
    if (stake == ChallengeStakeKind.coins5 && coins.value < 5) {
      throw Exception('Not enough coins');
    }

    if (AuthService.isSignedIn) {
      final raw = await _db.rpc(
        'send_challenge',
        params: {
          'p_challenged_id': opponentId,
          'p_stake_kind':
              stake == ChallengeStakeKind.coins5 ? 'coins5' : 'free',
        },
      );
      final map = _asMap(raw);
      if (map == null) throw Exception('Unexpected challenge response');
      if ('${map['status']}' == 'error') {
        throw Exception('${map['message'] ?? 'Challenge failed'}');
      }
      final id = '${map['id']}';
      final exp = DateTime.tryParse('${map['expires_at'] ?? ''}')?.toLocal();
      final c = ChallengeItem(
        id: id,
        opponentId: opponentId,
        opponentName: opponentName,
        avatarUrl: avatarUrl,
        rank: rank,
        score: score,
        stake: stake,
        outgoing: true,
        expiresAt: exp,
        secondsLeft: exp != null
            ? exp.difference(DateTime.now()).inSeconds.clamp(0, 60)
            : 60,
      );
      _upsert(c);
      return c;
    }

    // Local demo when signed out.
    final c = ChallengeItem(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      opponentId: opponentId,
      opponentName: opponentName,
      avatarUrl: avatarUrl,
      rank: rank,
      score: score,
      stake: stake,
      outgoing: true,
      expiresAt: DateTime.now().add(const Duration(seconds: 60)),
    );
    _upsert(c);
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
      expiresAt: DateTime.now().add(const Duration(seconds: 60)),
    );
    _upsert(c);
    incomingPopup.value = c;
    _onIncomingAvailable?.call(c);
    return c;
  }

  static void dismissIncomingPopup() => incomingPopup.value = null;

  static Future<void> cancel(String id) async {
    if (AuthService.isSignedIn &&
        !id.startsWith('c_') &&
        !id.startsWith('in_')) {
      try {
        await _db.rpc('cancel_challenge', params: {'p_challenge_id': id});
      } catch (e) {
        debugPrint('cancel_challenge: $e');
      }
    }
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.cancelled;
      c.secondsLeft = 0;
    });
  }

  static Future<void> decline(String id, {bool silent = false}) async {
    if (AuthService.isSignedIn &&
        !id.startsWith('c_') &&
        !id.startsWith('in_')) {
      try {
        final raw = await _db.rpc(
          'respond_challenge',
          params: {'p_challenge_id': id, 'p_accept': false},
        );
        final map = _asMap(raw);
        if (map != null && '${map['status']}' == 'error' && !silent) {
          throw Exception('${map['message'] ?? 'Decline failed'}');
        }
      } catch (e) {
        if (!silent) rethrow;
        debugPrint('decline silent: $e');
      }
    }
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.declined;
      c.secondsLeft = 0;
    });
    if (incomingPopup.value?.id == id) incomingPopup.value = null;
  }

  /// Player is in a match: decline without a popup and tell the challenger
  /// they are busy (server notifies them). Falls back to a plain decline on
  /// servers without 027_notifications.sql.
  static Future<void> declineBusy(String id) async {
    if (AuthService.isSignedIn &&
        !id.startsWith('c_') &&
        !id.startsWith('in_')) {
      try {
        await _db.rpc('decline_challenge_busy', params: {'p_challenge_id': id});
      } catch (e) {
        debugPrint('decline_challenge_busy: $e');
        await decline(id, silent: true);
        return;
      }
    }
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.declined;
      c.declineReason = 'busy';
      c.secondsLeft = 0;
    });
    if (incomingPopup.value?.id == id) incomingPopup.value = null;
  }

  static Future<ChallengeItem?> accept(String id) async {
    ChallengeItem? found;
    String? roomId;
    if (AuthService.isSignedIn &&
        !id.startsWith('c_') &&
        !id.startsWith('in_')) {
      final raw = await _db.rpc(
        'respond_challenge',
        params: {'p_challenge_id': id, 'p_accept': true},
      );
      final map = _asMap(raw);
      if (map == null) throw Exception('Unexpected accept response');
      if ('${map['status']}' == 'error') {
        throw Exception('${map['message'] ?? 'Accept failed'}');
      }
      if (map['room_id'] == null) {
        // Server without 026_challenge_match.sql: no shared room.
        throw Exception('Challenge match is not set up on the server yet');
      }
      roomId = '${map['room_id']}';
    }
    _mutate(id, (c) {
      c.status = ChallengeItemStatus.accepted;
      c.secondsLeft = 0;
      c.roomId = roomId ?? c.roomId;
      found = c;
      // Signed-out demo only; online stakes settle on the server.
      if (roomId == null &&
          c.stake == ChallengeStakeKind.coins5 &&
          coins.value >= 5) {
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
    _syncIncomingFromList();
  }

  static List<ChallengeItem> received() => [
        for (final c in items.value)
          if (!c.outgoing &&
              (c.status == ChallengeItemStatus.pending ||
                  c.status == ChallengeItemStatus.accepted))
            c
      ];

  static List<ChallengeItem> sent() => [
        for (final c in items.value)
          if (c.outgoing) c
      ];

  static List<ChallengeItem> history() => [
        for (final c in items.value)
          if (c.status == ChallengeItemStatus.expired ||
              c.status == ChallengeItemStatus.declined ||
              c.status == ChallengeItemStatus.cancelled)
            c
      ];

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }
}
