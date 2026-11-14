// ignore_for_file: avoid_print
/// Live realtime chat probe: B subscribes, A inserts, B must get event.
/// Run: dart run tool/probe_game_chat_realtime.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tic_tac_game/config/supabase_config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final _rng = Random.secure();
String _hex([int n = 8]) =>
    List.generate(n, (_) => _rng.nextInt(16).toRadixString(16)).join();

Future<Map<String, dynamic>> httpJson(
  String method,
  String path, {
  String? token,
  Object? body,
  Map<String, String>? extra,
}) async {
  final client = HttpClient();
  final uri = Uri.parse('${SupabaseConfig.url}$path');
  final req = await client.openUrl(method, uri);
  final key = SupabaseConfig.publishableKey;
  req.headers.set('apikey', key);
  req.headers.set('Authorization', 'Bearer ${token ?? key}');
  req.headers.set('Accept', 'application/json');
  req.headers.set('Content-Type', 'application/json');
  extra?.forEach(req.headers.set);
  if (body != null) req.add(utf8.encode(jsonEncode(body)));
  final res = await req.close();
  final text = await res.transform(utf8.decoder).join();
  client.close(force: true);
  dynamic decoded;
  try {
    decoded = text.isEmpty ? null : jsonDecode(text);
  } catch (_) {
    decoded = text;
  }
  return {'status': res.statusCode, 'body': decoded, 'raw': text};
}

String brief(Object? s) {
  final t = '$s';
  return t.length > 180 ? '${t.substring(0, 180)}…' : t;
}

Future<Map<String, String>> signup(String label) async {
  final email = 'rt_${label}_${DateTime.now().millisecondsSinceEpoch}@example.com';
  final pass = 'RtChat_${_hex()}!Aa1';
  final user = 'rt$label${_hex(6)}';
  final r = await httpJson('POST', '/auth/v1/signup', body: {
    'email': email,
    'password': pass,
    'data': {'username': user},
  });
  print('[$label] signup ${r['status']}');
  final body = r['body'];
  if (body is! Map || body['access_token'] == null) {
    throw StateError('signup failed: ${brief(r['raw'])}');
  }
  return {
    'token': '${body['access_token']}',
    'uid': '${(body['user'] as Map)['id']}',
  };
}

Future<void> main() async {
  print('=== Realtime chat probe ===\n');
  final a = await signup('a');
  final b = await signup('b');

  final created = await httpJson(
    'POST',
    '/rest/v1/rpc/create_private_room',
    token: a['token'],
    body: {'p_board_size': 3, 'p_stake': 10},
  );
  print('[A] create ${created['status']}: ${brief(created['raw'])}');
  final room = Map<String, dynamic>.from(created['body'] as Map);
  final roomId = '${room['room_id']}';
  final code = '${room['code']}';

  final joined = await httpJson(
    'POST',
    '/rest/v1/rpc/join_private_room',
    token: b['token'],
    body: {'p_code': code},
  );
  print('[B] join ${joined['status']}: ${brief(joined['raw'])}');

  // Realtime websocket as B
  final wsHost = SupabaseConfig.url
      .replaceFirst('https://', 'wss://')
      .replaceFirst('http://', 'ws://');
  final wsUri = Uri.parse(
    '$wsHost/realtime/v1/websocket?apikey=${Uri.encodeComponent(SupabaseConfig.publishableKey)}&vsn=1.0.0',
  );

  final channel = WebSocketChannel.connect(wsUri);
  final gotInsert = Completer<bool>();
  final topic = 'realtime:public:game_chat_messages';
  final ref = '1';
  final msgText = 'rt hello ${_hex()}';

  channel.stream.listen((raw) {
    final text = raw is String ? raw : '$raw';
    Map? data;
    try {
      data = jsonDecode(text) as Map?;
    } catch (_) {}
    if (data == null) return;
    final event = '${data['event']}';
    final payload = data['payload'];
    if (event == 'phx_reply' && '${data['ref']}' == ref) {
      final status = payload is Map ? '${payload['status']}' : '';
      print('[B] subscribe reply status=$status');
      if (status != 'ok' && !gotInsert.isCompleted) {
        // still wait — maybe joined without filter ok
      }
    }
    if (event == 'postgres_changes' || event == 'INSERT') {
      final p = payload is Map ? payload : null;
      final record = p?['data'] is Map
          ? (p!['data'] as Map)['record']
          : p?['record'];
      final map = record is Map ? record : (p?['new'] is Map ? p!['new'] : null);
      if (map is Map) {
        final mid = '${map['message'] ?? ''}';
        final rid = '${map['room_id'] ?? ''}';
        print('[B] realtime event message="$mid" room=$rid');
        if (mid == msgText && rid == roomId && !gotInsert.isCompleted) {
          gotInsert.complete(true);
        }
      } else {
        // fallback: any payload containing our text
        if (text.contains(msgText) && !gotInsert.isCompleted) {
          print('[B] realtime payload matched text');
          gotInsert.complete(true);
        }
      }
    }
  }, onError: (e) {
    print('[B] ws error: $e');
    if (!gotInsert.isCompleted) gotInsert.complete(false);
  }, onDone: () {
    print('[B] ws closed');
    if (!gotInsert.isCompleted) gotInsert.complete(false);
  });

  // Join phoenix channel with auth + filter
  channel.sink.add(jsonEncode({
    'topic': topic,
    'event': 'phx_join',
    'payload': {
      'config': {
        'postgres_changes': [
          {
            'event': 'INSERT',
            'schema': 'public',
            'table': 'game_chat_messages',
            'filter': 'room_id=eq.$roomId',
          }
        ],
      },
      'access_token': b['token'],
    },
    'ref': ref,
  }));

  // Also send access_token push (supabase realtime often needs this)
  channel.sink.add(jsonEncode({
    'topic': 'realtime:phoenix', // ignored if unsupported
    'event': 'access_token',
    'payload': {'access_token': b['token']},
    'ref': '2',
  }));

  await Future<void>.delayed(const Duration(milliseconds: 800));

  print('[A] inserting message…');
  final send = await httpJson(
    'POST',
    '/rest/v1/game_chat_messages',
    token: a['token'],
    body: {
      'room_id': roomId,
      'sender_id': a['uid'],
      'message': msgText,
    },
    extra: {'Prefer': 'return=representation'},
  );
  print('[A] send ${send['status']}: ${brief(send['raw'])}');

  // REST confirm for B
  final select = await httpJson(
    'GET',
    '/rest/v1/game_chat_messages?select=message&room_id=eq.$roomId&message=eq.${Uri.encodeQueryComponent(msgText)}',
    token: b['token'],
  );
  final restOk = select['status'] == 200 &&
      select['body'] is List &&
      (select['body'] as List).isNotEmpty;
  print('[B] rest select ok=$restOk ${brief(select['raw'])}');

  final rtOk = await gotInsert.future.timeout(
    const Duration(seconds: 8),
    onTimeout: () => false,
  );

  try {
    channel.sink.close();
  } catch (_) {}

  print('\n=== RESULT ===');
  print('rest_peer_read=$restOk  realtime_event=$rtOk');
  if (restOk && rtOk) {
    print('PASS: chat is realtime (websocket insert delivered).');
    exit(0);
  }
  if (restOk && !rtOk) {
    print(
      'PARTIAL: write/read OK; realtime event not seen in 8s '
      '(app still works via 2s poll). Check Realtime toggle for game_chat_messages.',
    );
    exit(2);
  }
  print('FAIL: chat read/write broken again.');
  exit(1);
}
