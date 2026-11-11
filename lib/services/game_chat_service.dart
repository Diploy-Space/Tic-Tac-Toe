import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/game_chat_message.dart';
import 'auth_service.dart';

/// Realtime in-game chat for a single multiplayer room (ValueNotifier pattern).
class GameChatService {
  GameChatService._();

  static SupabaseClient get _db => Supabase.instance.client;

  static final ValueNotifier<List<GameChatMessage>> messages =
      ValueNotifier<List<GameChatMessage>>(const []);
  static final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  static final ValueNotifier<String?> error = ValueNotifier<String?>(null);
  static final ValueNotifier<bool> connected = ValueNotifier<bool>(false);

  static RealtimeChannel? _msgChannel;
  static RealtimeChannel? _reactChannel;
  static String? _roomId;
  static final Set<String> _seenMessageIds = {};
  static bool _sending = false;

  static String? get roomId => _roomId;

  static Future<void> attach(String roomId) async {
    if (_roomId == roomId && _msgChannel != null) {
      await refresh();
      return;
    }
    await detach();
    _roomId = roomId;
    loading.value = true;
    error.value = null;

    await refresh();
    _subscribe(roomId);
    loading.value = false;
  }

  static Future<void> refresh() async {
    final roomId = _roomId;
    final uid = AuthService.user?.id;
    if (roomId == null || uid == null) {
      messages.value = const [];
      return;
    }
    try {
      final rows = await _db
          .from('game_chat_messages')
          .select('id, room_id, sender_id, message, created_at')
          .eq('room_id', roomId)
          .order('created_at', ascending: true)
          .limit(200);

      final list = <GameChatMessage>[];
      _seenMessageIds.clear();
      for (final r in rows as List) {
        final m = GameChatMessage.fromJson(Map<String, dynamic>.from(r as Map));
        _seenMessageIds.add(m.id);
        list.add(m);
      }

      if (list.isNotEmpty) {
        final ids = list.map((m) => m.id).toList();
        final reacts = await _db
            .from('game_chat_reactions')
            .select('message_id, user_id, emoji')
            .inFilter('message_id', ids);
        final byMsg = <String, Map<String, Set<String>>>{};
        for (final r in reacts as List) {
          final map = Map<String, dynamic>.from(r as Map);
          final mid = '${map['message_id']}';
          final emoji = '${map['emoji']}';
          final user = '${map['user_id']}';
          byMsg.putIfAbsent(mid, () => {});
          byMsg[mid]!.putIfAbsent(emoji, () => <String>{});
          byMsg[mid]![emoji]!.add(user);
        }
        for (var i = 0; i < list.length; i++) {
          final r = byMsg[list[i].id];
          if (r != null) list[i] = list[i].copyWith(reactions: r);
        }
      }

      messages.value = List.unmodifiable(list);
      error.value = null;
    } catch (e, st) {
      debugPrint('GameChatService.refresh: $e\n$st');
      error.value = AuthService.messageFromError(e);
    }
  }

  static void _subscribe(String roomId) {
    _msgChannel = _db.channel('game-chat-msg-$roomId');
    _msgChannel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'game_chat_messages',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'room_id',
        value: roomId,
      ),
      callback: (payload) {
        final row = payload.newRecord;
        if (row.isEmpty) return;
        final m =
            GameChatMessage.fromJson(Map<String, dynamic>.from(row));
        if (_seenMessageIds.contains(m.id)) return;
        _seenMessageIds.add(m.id);
        messages.value = List.unmodifiable([...messages.value, m]);
      },
    );
    _msgChannel!.subscribe((status, [err]) {
      connected.value = status == RealtimeSubscribeStatus.subscribed;
      if (status == RealtimeSubscribeStatus.channelError ||
          status == RealtimeSubscribeStatus.timedOut) {
        error.value = err?.toString() ?? 'Chat realtime error';
      }
    });

    _reactChannel = _db.channel('game-chat-react-$roomId');
    void onReactPayload(PostgresChangePayload payload) {
      final row = payload.newRecord.isNotEmpty
          ? payload.newRecord
          : payload.oldRecord;
      final mid = '${row['message_id'] ?? ''}';
      if (mid.isEmpty || !_seenMessageIds.contains(mid)) return;
      refresh();
    }

    _reactChannel!.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'game_chat_reactions',
      callback: onReactPayload,
    );
    _reactChannel!.onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'game_chat_reactions',
      callback: onReactPayload,
    );
    _reactChannel!.subscribe();
  }

  static Future<bool> send(String text) async {
    final roomId = _roomId;
    final uid = AuthService.user?.id;
    final trimmed = text.trim();
    if (roomId == null || uid == null) {
      error.value = 'Not signed in';
      return false;
    }
    if (trimmed.isEmpty) {
      error.value = 'Message cannot be empty';
      return false;
    }
    if (_sending) return false;
    _sending = true;
    error.value = null;
    try {
      await _db.from('game_chat_messages').insert({
        'room_id': roomId,
        'sender_id': uid,
        'message': trimmed,
      });
      // Realtime insert will append; soft refresh if needed.
      return true;
    } catch (e, st) {
      debugPrint('GameChatService.send: $e\n$st');
      error.value = AuthService.messageFromError(e);
      return false;
    } finally {
      _sending = false;
    }
  }

  /// Toggle emoji reaction for the current user on a message.
  static Future<void> toggleReaction({
    required String messageId,
    required String emoji,
  }) async {
    final uid = AuthService.user?.id;
    if (uid == null) return;
    if (!GameChatMessage.allowedEmojis.contains(emoji)) return;

    try {
      final existing = await _db
          .from('game_chat_reactions')
          .select('id, emoji')
          .eq('message_id', messageId)
          .eq('user_id', uid)
          .maybeSingle();

      if (existing != null) {
        final prev = '${existing['emoji']}';
        await _db
            .from('game_chat_reactions')
            .delete()
            .eq('message_id', messageId)
            .eq('user_id', uid);
        if (prev == emoji) {
          await refresh();
          return;
        }
      }

      await _db.from('game_chat_reactions').insert({
        'message_id': messageId,
        'user_id': uid,
        'emoji': emoji,
      });
      await refresh();
    } catch (e, st) {
      debugPrint('GameChatService.toggleReaction: $e\n$st');
      error.value = AuthService.messageFromError(e);
    }
  }

  static Future<void> detach() async {
    try {
      await _msgChannel?.unsubscribe();
    } catch (_) {}
    try {
      await _reactChannel?.unsubscribe();
    } catch (_) {}
    _msgChannel = null;
    _reactChannel = null;
    _roomId = null;
    _seenMessageIds.clear();
    messages.value = const [];
    loading.value = false;
    error.value = null;
    connected.value = false;
    _sending = false;
  }
}
