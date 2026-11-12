import 'package:flutter/material.dart';
import '../models/challenge_args.dart';
import '../models/cloud_match.dart';
import '../models/friendship.dart';
import '../services/auth_service.dart';
import '../services/friend_service.dart';
import '../services/match_repository.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';
import 'dialogs.dart';

/// PDF page 2 — Friends / Requests / Search (visual match).
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int tab = 1;
  final _search = TextEditingController();
  List<ProfileSearchHit> _hits = const [];
  bool _searching = false;
  bool _busy = false;
  final Map<String, LeaderboardEntry> _stats = {};

  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) {
      FriendService.refresh().then((_) => _prefetchStats());
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  Future<void> _prefetchStats() async {
    final ids = <String>{
      for (final f in FriendService.friends.value) f.otherUserId,
      for (final f in FriendService.incoming.value) f.otherUserId,
      for (final h in _hits) h.id,
    };
    for (final id in ids) {
      if (_stats.containsKey(id)) continue;
      try {
        final row = await MatchRepository.fetchLeaderboardEntry(id);
        if (row != null && mounted) setState(() => _stats[id] = row);
      } catch (_) {}
    }
  }

  String _rankScore(String userId) {
    final s = _stats[userId];
    if (s == null) return 'Rank – · Score –';
    return 'Rank #${s.rank} · Score ${s.score}';
  }

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
      await _prefetchStats();
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

  void _openProfile(String userId, String? username, String? avatar) {
    final s = _stats[userId];
    Navigator.pushNamed(
      context,
      '/public-profile',
      arguments: PublicProfileArgs(
        userId: userId,
        username: username ?? s?.username,
        avatarUrl: avatar ?? s?.avatarUrl,
        rank: s?.rank,
        score: s?.score,
        wins: s?.wins,
      ),
    );
  }

  Widget _avatar(String name, String? url) {
    if (url != null && url.trim().isNotEmpty) {
      return ClipOval(child: ProfileAvatar(url: url, size: 44));
    }
    return PdfGradientAvatar(name, size: 44);
  }

  Widget _rowCard({
    required String name,
    required String? avatarUrl,
    required String userId,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: InkWell(
        onTap: () => _openProfile(userId, name, avatarUrl),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            _avatar(name, avatarUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(_rankScore(userId),
                      style: const TextStyle(color: C.muted, fontSize: 13)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: FriendService.tick,
        builder: (_, __, ___) {
          final signedIn = AuthService.isSignedIn;
          final friends = FriendService.friends.value;
          final requests = FriendService.incoming.value;
          final reqLabel =
              requests.isEmpty ? 'Requests' : 'Requests · ${requests.length}';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopBar('Friends'),
              const SizedBox(height: 14),
              if (!signedIn)
                const AppCard(
                  child: Text(
                    'Sign in to search players and sync friends to the cloud.',
                    style: TextStyle(color: C.muted),
                  ),
                )
              else ...[
                PdfSearchField(
                  controller: _search,
                  onSubmitted: _runSearch,
                ),
                const SizedBox(height: 12),
                PdfSegRow(
                  options: ['Friends', reqLabel],
                  selected: tab.clamp(0, 1),
                  onChanged: (i) => setState(() => tab = i),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (_searching)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (_hits.isNotEmpty) ...[
                        const PdfSectionLabel('Search results'),
                        const SizedBox(height: 10),
                        for (final h in _hits)
                          _rowCard(
                            name: h.username,
                            avatarUrl: h.avatarUrl,
                            userId: h.id,
                            trailing: FriendService.friends.value
                                    .any((f) => f.otherUserId == h.id)
                                ? const PdfOutlineButton('Friends')
                                : PdfTealButton(
                                    'Add friend',
                                    compact: true,
                                    onTap: _busy ? null : () => _send(h),
                                  ),
                          ),
                        const SizedBox(height: 8),
                      ],
                      if (tab == 0) ...[
                        if (friends.isEmpty)
                          const AppCard(
                            child: Text(
                              'No friends yet — search to add someone.',
                              style: TextStyle(color: C.muted),
                            ),
                          )
                        else
                          for (final f in friends)
                            _rowCard(
                              name: f.otherUsername ?? 'player',
                              avatarUrl: f.otherAvatarUrl,
                              userId: f.otherUserId,
                              trailing: PdfTealButton(
                                'Challenge',
                                compact: true,
                                onTap: () {
                                  final s = _stats[f.otherUserId];
                                  Navigator.pushNamed(
                                    context,
                                    '/challenge-stake',
                                    arguments: ChallengeStakeArgs(
                                      opponentId: f.otherUserId,
                                      opponentName:
                                          f.otherUsername ?? 'player',
                                      avatarUrl: f.otherAvatarUrl,
                                      rank: s?.rank ?? 0,
                                      score: s?.score ?? 0,
                                    ),
                                  );
                                },
                              ),
                            ),
                      ] else ...[
                        if (requests.isNotEmpty) ...[
                          const PdfSectionLabel('Requests'),
                          const SizedBox(height: 10),
                        ],
                        if (requests.isEmpty)
                          const AppCard(
                            child: Text('No pending requests.',
                                style: TextStyle(color: C.muted)),
                          )
                        else
                          for (final r in requests)
                            _rowCard(
                              name: r.otherUsername ?? 'player',
                              avatarUrl: r.otherAvatarUrl,
                              userId: r.otherUserId,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PdfTealButton(
                                    'Accept',
                                    compact: true,
                                    onTap: _busy
                                        ? null
                                        : () async {
                                            if (!await requireInternet(
                                                context)) {
                                              return;
                                            }
                                            if (!mounted) return;
                                            setState(() => _busy = true);
                                            try {
                                              await FriendService.accept(r.id);
                                              _msg(
                                                  '${r.otherUsername ?? 'player'} added');
                                            } catch (e) {
                                              _msg(AuthService
                                                  .messageFromError(e));
                                            } finally {
                                              if (mounted) {
                                                setState(() => _busy = false);
                                              }
                                            }
                                          },
                                  ),
                                  const SizedBox(width: 8),
                                  PdfDeclineBox(
                                    onTap: _busy
                                        ? null
                                        : () async {
                                            if (!await requireInternet(
                                                context)) {
                                              return;
                                            }
                                            if (!mounted) return;
                                            setState(() => _busy = true);
                                            try {
                                              await FriendService.decline(
                                                  r.id);
                                            } catch (e) {
                                              _msg(AuthService
                                                  .messageFromError(e));
                                            } finally {
                                              if (mounted) {
                                                setState(() => _busy = false);
                                              }
                                            }
                                          },
                                  ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Requests expire after 7 days if not answered.',
                            style: TextStyle(color: C.muted, fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
