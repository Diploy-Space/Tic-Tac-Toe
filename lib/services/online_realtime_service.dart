import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/online_room_state.dart';
import 'auth_service.dart';

/// C2: Realtime + snapshot. Optimistic UI for smoothness; Postgres remains truth.
class OnlineRealtimeService {
  OnlineRealtimeService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static RealtimeChannel? _channel;
  static String? _roomId;
  static int _appliedMoveCount = -1;
  static int _fetchGeneration = 0;
  static Timer? _reconcileTimer;

  static final ValueNotifier<OnlineRoomState?> state =
      ValueNotifier<OnlineRoomState?>(null);
  static final ValueNotifier<String?> error =
      ValueNotifier<String?>(null);
  static final ValueNotifier<bool> connected =
      ValueNotifier<bool>(false);
  static final ValueNotifier<bool> submitInFlight =
      ValueNotifier<bool>(false);

  static Future<OnlineRoomState?> fetchSnapshot(String roomId) async {
    final gen = ++_fetchGeneration;
    try {
      final raw = await _db.rpc(
        'get_online_room',
        params: {'p_room_id': roomId},
      );
      if (gen != _fetchGeneration) return state.value;

      final map = _asMap(raw);
      if (map == null) {
        error.value = 'Unexpected room snapshot';
        return null;
      }
      if ('${map['status']}' == 'error') {
        error.value = '${map['message'] ?? 'Room error'}';
        return null;
      }

      final snap = OnlineRoomState.fromJson(map);
      _applyIfNewer(snap);
      error.value = null;
      return snap;
    } catch (e, st) {
      debugPrint('OnlineRealtimeService.fetchSnapshot: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return null;
    }
  }

  static void _applyIfNewer(OnlineRoomState snap) {
    // Never apply an older board revision.
    if (snap.moveCount < _appliedMoveCount) return;

    final prev = state.value;
    if (prev != null &&
        prev.roomId == snap.roomId &&
        snap.moveCount == _appliedMoveCount &&
        _sameCells(prev.cells, snap.cells) &&
        !_roomMetaChanged(prev, snap)) {
      // Same board AND same lobby/meta — skip notifier noise.
      return;
    }
    _appliedMoveCount = snap.moveCount;
    state.value = snap;
  }

  /// Opponent join / status / turn / winner can change without a new move.
  static bool _roomMetaChanged(OnlineRoomState a, OnlineRoomState b) {
    return a.roomStatus != b.roomStatus ||
        a.playerO != b.playerO ||
        a.playerX != b.playerX ||
        a.currentTurn != b.currentTurn ||
        a.winner != b.winner ||
        a.myMark != b.myMark ||
        a.stake != b.stake ||
        a.boardSize != b.boardSize ||
        a.chatStopped != b.chatStopped;
  }

  static bool _sameCells(List<String?> a, List<String?> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Apply Realtime row immediately; soft-reconcile shortly after.
  static void _onRealtimePayload(PostgresChangePayload payload) {
    final roomId = _roomId;
    if (roomId == null) return;

    final current = state.value;
    final row = payload.newRecord;
    if (row.isNotEmpty && current != null) {
      try {
        final snap = OnlineRoomState.fromRealtimeRow(
          Map<String, dynamic>.from(row),
          myMark: current.myMark,
        );
        if (snap.roomId == roomId || '${row['id']}' == roomId) {
          _applyIfNewer(snap);
          // Debounced truth check (does not block UI)
          _scheduleReconcile(roomId, delayMs: 400);
          return;
        }
      } catch (e) {
        debugPrint('OnlineRealtime payload apply failed: $e');
      }
    }
    _scheduleReconcile(roomId, delayMs: 50);
  }

  static void _scheduleReconcile(String roomId, {int delayMs = 300}) {
    _reconcileTimer?.cancel();
    _reconcileTimer = Timer(Duration(milliseconds: delayMs), () {
      fetchSnapshot(roomId);
    });
  }

  static Future<void> attach(String roomId) async {
    if (_roomId != roomId) {
      await detach();
      _roomId = roomId;
      _appliedMoveCount = -1;
    }

    // Snapshot + subscribe in parallel for faster first paint
    final snapFuture = fetchSnapshot(roomId);

    await _channel?.unsubscribe();
    _channel = _db.channel('online-room-$roomId');

    _channel!.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'multiplayer_rooms',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'id',
        value: roomId,
      ),
      callback: _onRealtimePayload,
    );

    _channel!.subscribe((status, [err]) {
      debugPrint('OnlineRealtime channel status=$status err=$err');
      connected.value = status == RealtimeSubscribeStatus.subscribed;
      if (status == RealtimeSubscribeStatus.subscribed) {
        _scheduleReconcile(roomId, delayMs: 0);
      }
      if (status == RealtimeSubscribeStatus.channelError ||
          status == RealtimeSubscribeStatus.timedOut) {
        error.value = err?.toString() ?? 'Realtime subscription error';
      }
    });

    await snapFuture;
  }

  /// Optimistic local flag so both UI paths hide chat immediately.
  static void markChatStopped() {
    final prev = state.value;
    if (prev == null || prev.chatStopped) return;
    state.value = prev.withChatStopped(true);
  }

  /// Resign: server awards the win to the opponent and settles matches.
  static Future<OnlineRoomState?> forfeit() async {
    final roomId = _roomId;
    if (roomId == null) {
      error.value = 'No active room';
      return null;
    }
    if (submitInFlight.value) return state.value;
    submitInFlight.value = true;
    error.value = null;
    try {
      final raw = await _db.rpc(
        'forfeit_online_room',
        params: {'p_room_id': roomId},
      );
      final map = _asMap(raw);
      if (map == null) {
        error.value = 'Unexpected forfeit response';
        await fetchSnapshot(roomId);
        return state.value;
      }
      if ('${map['status']}' == 'error') {
        error.value = '${map['message'] ?? 'Forfeit failed'}';
        await fetchSnapshot(roomId);
        return state.value;
      }
      final snap = OnlineRoomState.fromJson(map);
      _applyIfNewer(snap);
      error.value = null;
      return snap;
    } catch (e, st) {
      debugPrint('OnlineRealtimeService.forfeit: $e\n$st');
      error.value = AuthService.messageFromError(e);
      await fetchSnapshot(roomId);
      return null;
    } finally {
      submitInFlight.value = false;
    }
  }

  /// Optimistic paint, then server ACK. Rolls back via snapshot on failure.
  static Future<OnlineRoomState?> submitMove(int cellIndex) async {
    final roomId = _roomId;
    final current = state.value;
    if (roomId == null || current == null) {
      error.value = 'No active room';
      return null;
    }
    if (submitInFlight.value) return current;
    if (current.isFinished || !current.isMyTurn) return current;
    if (cellIndex < 0 ||
        cellIndex >= current.cells.length ||
        current.cells[cellIndex] != null) {
      return current;
    }

    final expected = current.moveCount;
    final optimistic = current.withOptimisticMove(cellIndex);
    _applyIfNewer(optimistic);
    submitInFlight.value = true;
    error.value = null;

    try {
      final raw = await _db.rpc(
        'submit_online_move',
        params: {
          'p_room_id': roomId,
          'p_cell_index': cellIndex,
          'p_expected_move_count': expected,
        },
      );
      final map = _asMap(raw);
      if (map == null) {
        error.value = 'Unexpected move response';
        await fetchSnapshot(roomId);
        return state.value;
      }
      final status = '${map['status']}';
      if (status == 'error' || status == 'stale') {
        error.value = '${map['message'] ?? status}';
        await fetchSnapshot(roomId);
        return state.value;
      }
      final snap = OnlineRoomState.fromJson(map);
      _applyIfNewer(snap);
      error.value = null;
      return snap;
    } catch (e, st) {
      debugPrint('OnlineRealtimeService.submitMove: $e\n$st');
      error.value = AuthService.messageFromError(e);
      await fetchSnapshot(roomId);
      return null;
    } finally {
      submitInFlight.value = false;
    }
  }

  static Future<void> refresh() async {
    final id = _roomId;
    if (id != null) await fetchSnapshot(id);
  }

  static Future<void> detach() async {
    _fetchGeneration++;
    _reconcileTimer?.cancel();
    _reconcileTimer = null;
    submitInFlight.value = false;
    try {
      await _channel?.unsubscribe();
    } catch (_) {}
    _channel = null;
    _roomId = null;
    _appliedMoveCount = -1;
    state.value = null;
    error.value = null;
    connected.value = false;
  }

  static Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }
}
