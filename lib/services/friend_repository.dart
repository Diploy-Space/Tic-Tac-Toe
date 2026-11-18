import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/friendship.dart';
import '../l10n/app_localizations.dart';

class FriendRepository {
  FriendRepository._();

  static SupabaseClient get _db => Supabase.instance.client;

  static Future<List<ProfileSearchHit>> searchProfiles(String query,
      {int limit = 20}) async {
    final q = query.trim().toLowerCase();
    final isId = RegExp(r'^(player|id|#|\s)*\d+$').hasMatch(q);
    if (q.isEmpty || (q.length < 2 && !isId)) return const [];
    final uid = _db.auth.currentUser?.id;
    // Username or Player ID (029_search_players.sql).
    try {
      final rows = await _db.rpc('search_players',
          params: {'p_query': q, 'p_limit': limit});
      return [
        for (final r in rows as List)
          if ('${r['id']}' != uid)
            ProfileSearchHit(
              id: '${r['id']}',
              username: '${r['username']}',
              avatarUrl: r['avatar_url'] as String?,
              playerNo: (r['player_no'] as num?)?.toInt(),
            ),
      ];
    } on PostgrestException catch (e) {
      // Older server without the RPC: username-only search below.
      if (e.code != 'PGRST202') rethrow;
    }
    if (q.length < 2) return const [];
    final rows = await _db
        .from('public_profiles')
        .select('id, username, avatar_url')
        .ilike('username', '%$q%')
        .limit(limit);
    final out = <ProfileSearchHit>[];
    for (final r in rows as List) {
      final id = '${r['id']}';
      if (uid != null && id == uid) continue;
      out.add(ProfileSearchHit(
        id: id,
        username: '${r['username']}',
        avatarUrl: r['avatar_url'] as String?,
      ));
    }
    return out;
  }

  /// Public username + avatar for match UI / friends lists.
  static Future<Map<String, ProfileSearchHit>> profilesByIds(
      Iterable<String> ids) async {
    final list = ids
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != 'null')
        .toSet()
        .toList();
    if (list.isEmpty) return {};
    final rows = await _db
        .from('public_profiles')
        .select('id, username, avatar_url')
        .inFilter('id', list);
    return {
      for (final r in rows as List)
        '${r['id']}': ProfileSearchHit(
          id: '${r['id']}',
          username: '${r['username']}',
          avatarUrl: r['avatar_url'] as String?,
        ),
    };
  }

  static Future<List<Friendship>> fetchMine() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return const [];

    final rows = await _db
        .from('friendships')
        .select('id, requester_id, addressee_id, status, created_at')
        .or('requester_id.eq.$uid,addressee_id.eq.$uid')
        .order('created_at', ascending: false);

    final mapped = <Map<String, dynamic>>[
      for (final r in rows as List) Map<String, dynamic>.from(r as Map),
    ];
    final otherIds = <String>[];
    for (final r in mapped) {
      otherIds.add('${r['requester_id']}' == uid
          ? '${r['addressee_id']}'
          : '${r['requester_id']}');
    }
    final profiles = await profilesByIds(otherIds);

    final out = <Friendship>[];
    for (final r in mapped) {
      final requesterId = '${r['requester_id']}';
      final addresseeId = '${r['addressee_id']}';
      final otherId = requesterId == uid ? addresseeId : requesterId;
      final p = profiles[otherId];
      out.add(Friendship(
        id: '${r['id']}',
        requesterId: requesterId,
        addresseeId: addresseeId,
        status: '${r['status']}',
        otherUserId: otherId,
        otherUsername: p?.username ?? 'player',
        otherAvatarUrl: p?.avatarUrl,
        createdAt: DateTime.tryParse('${r['created_at']}') ?? DateTime.now(),
      ));
    }
    return out;
  }

  static Future<void> sendRequest(String addresseeId) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception(l10nNow.signInRequired);
    if (uid == addresseeId) throw Exception(l10nNow.cannotFriendSelf);
    try {
      await _db.from('friendships').insert({
        'requester_id': uid,
        'addressee_id': addresseeId,
        'status': 'pending',
      });
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception(l10nNow.friendRequestExists);
      }
      rethrow;
    }
  }

  static Future<void> accept(String friendshipId) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception(l10nNow.signInRequired);
    await _db
        .from('friendships')
        .update({'status': 'accepted'})
        .eq('id', friendshipId)
        .eq('addressee_id', uid)
        .eq('status', 'pending');
  }

  static Future<void> decline(String friendshipId) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception(l10nNow.signInRequired);
    await _db
        .from('friendships')
        .update({'status': 'declined'})
        .eq('id', friendshipId)
        .eq('addressee_id', uid)
        .eq('status', 'pending');
  }

  static Future<void> remove(String friendshipId) async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) throw Exception(l10nNow.signInRequired);
    await _db.from('friendships').delete().eq('id', friendshipId);
  }
}
