// ignore_for_file: avoid_print
/// Realtime probe using official supabase Dart client.
/// Run: dart run tool/probe_game_chat_realtime_sdk.dart
import 'dart:async';
import 'dart:math';

import 'package:supabase/supabase.dart';
import 'package:tic_tac_game/config/supabase_config.dart';

final _rng = Random.secure();
String _hex([int n = 8]) =>
    List.generate(n, (_) => _rng.nextInt(16).toRadixString(16)).join();

Future<SupabaseClient> authed(String label) async {
  final c = SupabaseClient(
    SupabaseConfig.url,
    SupabaseConfig.publishableKey,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );
  final email =
      'rtsdk_${label}_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final pass = 'RtSdk_${_hex()}!Aa1';
  final username = 'rts$label${_hex(6)}';
  final res = await c.auth.signUp(
    email: email,
    password: pass,
    data: {'username': username},
  );
  if (res.session == null) {
    throw StateError('[$label] no session after signup');
  }
  print('[$label] uid=${res.user?.id}');
  return c;
}

Future<void> main() async {
  final a = await authed('a');
  final b = await authed('b');

  final created = await a.rpc('create_private_room', params: {
    'p_board_size': 3,
    'p_stake': 10,
  });
  final room = Map<String, dynamic>.from(created as Map);
  final roomId = '${room['room_id']}';
  final code = '${room['code']}';
  print('[A] room=$roomId code=$code');

  final joined = await b.rpc('join_private_room', params: {'p_code': code});
  print('[B] join=$joined');

  final msgText = 'sdk rt ${_hex()}';
  final got = Completer<bool>();
  final statuses = <String>[];

  final ch = b.channel('probe-chat-$roomId');
  ch.onPostgresChanges(
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
      print('[B] REALTIME insert: $row');
      if ('${row['message']}' == msgText) {
        if (!got.isCompleted) got.complete(true);
      }
    },
  );
  ch.subscribe((status, [err]) {
    statuses.add('$status');
    print('[B] channel status=$status err=$err');
  });

  await Future<void>.delayed(const Duration(seconds: 2));

  final inserted = await a.from('game_chat_messages').insert({
    'room_id': roomId,
    'sender_id': a.auth.currentUser!.id,
    'message': msgText,
  }).select().single();
  print('[A] inserted=$inserted');

  final rows = await b
      .from('game_chat_messages')
      .select('message')
      .eq('room_id', roomId)
      .eq('message', msgText);
  final restOk = (rows as List).isNotEmpty;
  print('[B] restOk=$restOk rows=$rows');

  final rtOk = await got.future.timeout(
    const Duration(seconds: 10),
    onTimeout: () => false,
  );

  await b.removeChannel(ch);
  await a.auth.signOut();
  await b.auth.signOut();
  a.dispose();
  b.dispose();

  print('\n=== RESULT ===');
  print('statuses=$statuses restOk=$restOk realtimeOk=$rtOk');
  if (restOk && rtOk) {
    print('PASS: realtime websocket delivers chat inserts.');
    return;
  }
  if (restOk) {
    print(
      'PARTIAL: REST chat works; Realtime event missing.\n'
      '→ Dashboard → Database → Publications → supabase_realtime\n'
      '  enable game_chat_messages (+ reactions).\n'
      'App still delivers via 2s poll fallback.',
    );
    throw Exception('realtime missing');
  }
  throw Exception('chat broken');
}
