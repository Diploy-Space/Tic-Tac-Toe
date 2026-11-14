// ignore_for_file: avoid_print
/// End-to-end chat probe with 2 temporary accounts.
/// Run: dart run tool/probe_game_chat_e2e.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tic_tac_game/config/supabase_config.dart';

final _rng = Random.secure();
String _id() => List.generate(8, (_) => _rng.nextInt(16).toRadixString(16)).join();

class SbClient {
  SbClient(this.label);
  final String label;
  final HttpClient http = HttpClient();
  String? accessToken;
  String? userId;

  Map<String, String> get _headers => {
        'apikey': SupabaseConfig.publishableKey,
        'Authorization':
            'Bearer ${accessToken ?? SupabaseConfig.publishableKey}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<Map<String, dynamic>> _json(
    String method,
    String path, {
    Object? body,
    Map<String, String>? extraHeaders,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}$path');
    final req = await http.openUrl(method, uri);
    _headers.forEach(req.headers.set);
    extraHeaders?.forEach(req.headers.set);
    if (body != null) req.add(utf8.encode(jsonEncode(body)));
    final res = await req.close();
    final text = await res.transform(utf8.decoder).join();
    dynamic decoded;
    try {
      decoded = text.isEmpty ? null : jsonDecode(text);
    } catch (_) {
      decoded = text;
    }
    return {
      'status': res.statusCode,
      'body': decoded,
      'raw': text,
    };
  }

  Future<void> signUp(String email, String password, {String? username}) async {
    final r = await _json('POST', '/auth/v1/signup', body: {
      'email': email,
      'password': password,
      if (username != null) 'data': {'username': username},
    });
    print('[$label] signup ${r['status']}: ${_brief(r['raw'])}');
    final body = r['body'];
    if (body is Map) {
      accessToken = body['access_token'] as String?;
      final user = body['user'];
      if (user is Map) userId = user['id'] as String?;
      // Email confirm may block session
      if (accessToken == null && body['session'] is Map) {
        accessToken = (body['session'] as Map)['access_token'] as String?;
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    final r = await _json(
      'POST',
      '/auth/v1/token?grant_type=password',
      body: {'email': email, 'password': password},
    );
    print('[$label] signIn ${r['status']}: ${_brief(r['raw'])}');
    final body = r['body'];
    if (body is Map) {
      accessToken = body['access_token'] as String?;
      final user = body['user'];
      if (user is Map) userId = user['id'] as String?;
    }
  }

  Future<Map<String, dynamic>> rest(
    String method,
    String path, {
    Object? body,
    Map<String, String>? extra,
  }) =>
      _json(method, path, body: body, extraHeaders: extra);

  Future<Map<String, dynamic>> rpc(String name, Map<String, dynamic> args) =>
      _json('POST', '/rest/v1/rpc/$name', body: args);

  void close() => http.close(force: true);
}

String _brief(Object? raw) {
  final s = '$raw';
  return s.length > 220 ? '${s.substring(0, 220)}…' : s;
}

Future<void> main() async {
  final stamp = DateTime.now().millisecondsSinceEpoch;
  final pass = 'ChatTest_${_id()}!Aa1';
  final emailA = 'chat_a_$stamp@example.com';
  final emailB = 'chat_b_$stamp@example.com';

  final a = SbClient('A');
  final b = SbClient('B');

  print('=== Auth ===');
  await a.signUp(emailA, pass, username: 'chata${_id()}');
  await b.signUp(emailB, pass, username: 'chatb${_id()}');
  if (a.accessToken == null) await a.signIn(emailA, pass);
  if (b.accessToken == null) await b.signIn(emailB, pass);

  if (a.accessToken == null || b.accessToken == null) {
    print('\nFAIL: could not get JWT (email confirm likely required).');
    print('Cannot complete live send/receive without authenticated session.');
    a.close();
    b.close();
    exit(2);
  }
  print('A uid=${a.userId}');
  print('B uid=${b.userId}');

  print('\n=== Ensure profiles ===');
  for (final c in [a, b]) {
    final me = await c.rpc('get_my_profile', {});
    print('[${c.label}] get_my_profile ${me['status']}: ${_brief(me['raw'])}');
  }

  // Wallet may be required for private room stake.
  for (final c in [a, b]) {
    final w = await c.rpc('get_my_wallet', {});
    print('[${c.label}] wallet ${w['status']}: ${_brief(w['raw'])}');
    final credit = await c.rpc('wallet_credit', {
      'p_amount': 100,
      'p_reason': 'chat_probe',
    });
    print('[${c.label}] wallet_credit ${credit['status']}: ${_brief(credit['raw'])}');
  }

  print('\n=== Create / join private room ===');
  final created = await a.rpc('create_private_room', {
    'p_board_size': 3,
    'p_stake': 10,
  });
  print('[A] create_private_room ${created['status']}: ${_brief(created['raw'])}');

  Map<String, dynamic>? room;
  if (created['body'] is Map) {
    room = Map<String, dynamic>.from(created['body'] as Map);
  }

  String? roomId = room?['room_id']?.toString() ?? room?['id']?.toString();
  final code = room?['room_code']?.toString() ??
      room?['code']?.toString() ??
      room?['join_code']?.toString();

  if (code != null && code != 'null') {
    final joined = await b.rpc('join_private_room', {'p_code': code});
    print('[B] join_private_room ${joined['status']}: ${_brief(joined['raw'])}');
    if (joined['body'] is Map) {
      final j = Map<String, dynamic>.from(joined['body'] as Map);
      roomId ??= j['room_id']?.toString() ?? j['id']?.toString();
    }
  }

  if (roomId == null || roomId == 'null') {
    print('\nFAIL: no room_id — cannot test chat insert (needs participant room).');
    a.close();
    b.close();
    exit(3);
  }
  print('room_id=$roomId');

  print('\n=== Chat insert as A ===');
  final msgText = 'probe hello ${_id()}';
  final send = await a.rest(
    'POST',
    '/rest/v1/game_chat_messages',
    body: {
      'room_id': roomId,
      'sender_id': a.userId,
      'message': msgText,
    },
    extra: {'Prefer': 'return=representation'},
  );
  print('[A] send ${send['status']}: ${_brief(send['raw'])}');

  print('\n=== Chat select as B ===');
  final recv = await b.rest(
    'GET',
    '/rest/v1/game_chat_messages?select=id,message,sender_id,created_at&room_id=eq.$roomId&order=created_at.asc',
  );
  print('[B] select ${recv['status']}: ${_brief(recv['raw'])}');

  final okSend = send['status'] == 201 || send['status'] == 200;
  var okRecv = false;
  if (recv['body'] is List) {
    okRecv = (recv['body'] as List).any((row) =>
        row is Map && '${row['message']}' == msgText);
  }

  print('\n=== RESULT ===');
  print('send_ok=$okSend  peer_select_ok=$okRecv');
  if (okSend && okRecv) {
    print('PASS: authenticated chat write+read works between two users.');
    print('Realtime pub still needs Dashboard/015 — app now also polls every 2s.');
    exit(0);
  } else {
    print('FAIL: see errors above (RLS / missing seat / migration).');
    exit(1);
  }
}
