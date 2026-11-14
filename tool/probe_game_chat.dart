// ignore_for_file: avoid_print
/// Live probe: does remote Supabase expose game_chat tables?
/// Run: dart run tool/probe_game_chat.dart
import 'dart:convert';
import 'dart:io';

import 'package:tic_tac_game/config/supabase_config.dart';

Future<void> main() async {
  final base = SupabaseConfig.url;
  final key = SupabaseConfig.publishableKey;
  final client = HttpClient();

  Future<void> check(String path, {String method = 'GET', Object? body}) async {
    final uri = Uri.parse('$base$path');
    final req = await client.openUrl(method, uri);
    req.headers.set('apikey', key);
    req.headers.set('Authorization', 'Bearer $key');
    req.headers.set('Accept', 'application/json');
    if (body != null) {
      req.headers.set('Content-Type', 'application/json');
      req.add(utf8.encode(jsonEncode(body)));
    }
    final res = await req.close();
    final text = await res.transform(utf8.decoder).join();
    final short =
        text.length > 280 ? '${text.substring(0, 280)}…' : text;
    print('[$method ${res.statusCode}] $path');
    print('  → $short');
    print('');
  }

  print('Probing $base …\n');

  await check('/rest/v1/game_chat_messages?select=id&limit=1');
  await check('/rest/v1/game_chat_reactions?select=id&limit=1');
  await check('/rest/v1/multiplayer_rooms?select=id&limit=1');

  // Auth signup/signin not available without test users; expect RLS deny (not 404).
  await check(
    '/rest/v1/rpc/get_online_room',
    method: 'POST',
    body: {'p_room_id': '00000000-0000-0000-0000-000000000001'},
  );

  client.close(force: true);
  print('Legend:');
  print('  200/[]     = table exists, empty (or RLS hid rows)');
  print('  401/JWT    = key/auth issue');
  print('  404 PGRST  = table/RPC missing (migration not applied)');
  print('  42501/RLS  = table exists, policy blocked (expected without user JWT)');
}
