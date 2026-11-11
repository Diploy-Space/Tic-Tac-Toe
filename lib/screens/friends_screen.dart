import 'package:flutter/material.dart';
import '../models/friendship.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int tab = 0;
  final _search = TextEditingController();
  List<ProfileSearchHit> _hits = const [];
  bool _searching = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) FriendService.refresh();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _runSearch(String q) async {
    if (!AuthService.isSignedIn) {
      _msg('Sign in to find friends');
      return;
    }
    if (!await requireInternet(context)) return;
    if (!mounted) return;
    setState(() => _searching = true);
    try {
      final hits = await FriendService.search(q);
      if (!mounted) return;
      setState(() => _hits = hits);
    } catch (e) {
      _msg(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _send(ProfileSearchHit hit) async {
    if (!await requireInternet(context)) return;
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      await FriendService.sendRequest(hit.id);
      _msg('Request sent to ${hit.username}');
      setState(() {
        _hits = [for (final h in _hits) if (h.id != hit.id) h];
      });
    } catch (e) {
      _msg(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _friend(Friendship f) {
    final name = f.otherUsername ?? 'player';
    return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          ProfileAvatar(url: f.otherAvatarUrl, size: 40),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const Text('Friend',
                    style: TextStyle(color: C.muted, fontSize: 13)),
              ])),
          SmallButton('Challenge', onTap: () async {
            _msg('Starting Pass & Play with $name');
            if (!mounted) return;
            await startPassAndPlay(context);
          }),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Remove',
            onPressed: _busy
                ? null
                : () async {
                    if (!await requireInternet(context)) return;
                    if (!mounted) return;
                    setState(() => _busy = true);
                    try {
                      await FriendService.remove(f.id);
                      _msg('Removed $name');
                    } catch (e) {
                      _msg(AuthService.messageFromError(e));
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
            icon: const Icon(Icons.person_remove_outlined, color: C.muted),
          ),
        ]));
  }

  Widget _request(Friendship f) {
    final name = f.otherUsername ?? 'player';
    return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          ProfileAvatar(url: f.otherAvatarUrl, size: 40),
          const SizedBox(width: 12),
          Expanded(
              child: Text(name,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          SmallButton('Accept', color: C.teal, onTap: _busy
              ? null
              : () async {
                  if (!await requireInternet(context)) return;
                  if (!mounted) return;
                  setState(() => _busy = true);
                  try {
                    await FriendService.accept(f.id);
                    _msg('$name added');
                  } catch (e) {
                    _msg(AuthService.messageFromError(e));
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                }),
          const SizedBox(width: 8),
          SmallButton('Decline', color: C.border2, onTap: _busy
              ? null
              : () async {
                  if (!await requireInternet(context)) return;
                  if (!mounted) return;
                  setState(() => _busy = true);
                  try {
                    await FriendService.decline(f.id);
                  } catch (e) {
                    _msg(AuthService.messageFromError(e));
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                }),
        ]));
  }

  Widget _hit(ProfileSearchHit h) => AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        ProfileAvatar(url: h.avatarUrl, size: 40),
        const SizedBox(width: 12),
        Expanded(
            child: Text(h.username,
                style: const TextStyle(fontWeight: FontWeight.w700))),
        SmallButton('Add', onTap: _busy ? null : () => _send(h)),
      ]));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: FriendService.tick,
        builder: (_, __, ___) {
          final signedIn = AuthService.isSignedIn;
          final friends = FriendService.friends.value;
          final requests = FriendService.incoming.value;
          return SingleChildScrollView(
            child: staggered([
              const TopBar('Friends'),
              if (!signedIn)
                const AppCard(
                    child: Text(
                  'Sign in to search players and sync friends to the cloud.',
                  style: TextStyle(color: C.muted),
                ))
              else ...[
                AppField(
                    icon: Icons.person_outline,
                    hint: 'Search by username',
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _runSearch),
                if (_searching)
                  const Center(child: CircularProgressIndicator())
                else if (_hits.isNotEmpty) ...[
                  const Text('Search results',
                      style: TextStyle(color: C.muted, fontSize: 13)),
                  for (final h in _hits) _hit(h),
                ],
                SegRow(
                    options: const ['Friends', 'Requests'],
                    selected: tab,
                    onChanged: (i) => setState(() => tab = i)),
                AppCard(
                    borderColor: C.magenta,
                    child: Row(children: [
                      const IconCircle(Icons.card_giftcard),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('${friends.length} friends',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            const Text(
                                'Search a username above to send a request',
                                style:
                                    TextStyle(color: C.muted, fontSize: 13)),
                          ])),
                    ])),
                if (tab == 0)
                  if (friends.isEmpty)
                    const AppCard(
                        child: Text('No friends yet — search to add someone.',
                            style: TextStyle(color: C.muted)))
                  else
                    for (final f in friends) _friend(f)
                else if (requests.isEmpty)
                  const AppCard(
                      child: Text('No pending requests.',
                          style: TextStyle(color: C.muted)))
                else
                  for (final r in requests) _request(r),
              ],
            ], gap: 12),
          );
        },
      ),
    );
  }
}
