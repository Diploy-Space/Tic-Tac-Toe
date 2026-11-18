import 'dart:async';

import 'package:flutter/material.dart';
import '../models.dart' show formatPlayerId;
import '../models/challenge_args.dart';
import '../models/cloud_match.dart';
import '../models/friendship.dart';
import '../services/auth_service.dart';
import '../services/challenge_flow_service.dart';
import '../services/friend_service.dart';
import '../services/match_repository.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';
import 'dialogs.dart';
import '../l10n/app_localizations.dart';

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
  // Query the current results belong to ('' = nothing searched yet).
  String _searchedFor = '';
  int _searchSeq = 0;
  Timer? _debounce;
  bool _busy = false;
  final Map<String, LeaderboardEntry> _stats = {};
  final Map<String, bool> _canChallenge = {};

  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) {
      FriendService.refresh().then((_) => _prefetchStats());
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
      if (!_stats.containsKey(id)) {
        try {
          final row = await MatchRepository.fetchLeaderboardEntry(id);
          if (row != null && mounted) setState(() => _stats[id] = row);
        } catch (_) {}
      }
      if (!_canChallenge.containsKey(id)) {
        try {
          final ok = await ChallengeFlowService.canChallenge(id);
          if (mounted) setState(() => _canChallenge[id] = ok);
        } catch (_) {
          if (mounted) setState(() => _canChallenge[id] = true);
        }
      }
    }
  }

  String _rankScore(String userId) {
    final s = _stats[userId];
    if (s == null) return context.l10n.rankScoreUnknown;
    return context.l10n.rankScore('${s.rank}', '${s.score}');
  }

  /// Live search while typing (debounced); Enter searches immediately.
  void _onQueryChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      _searchSeq++;
      setState(() {
        _hits = const [];
        _searchedFor = '';
        _searching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400),
        () => _runSearch(q, live: true));
  }

  Future<void> _runSearch(String q, {bool live = false}) async {
    _debounce?.cancel();
    final query = q.trim();
    if (query.isEmpty) return;
    if (!AuthService.isSignedIn) {
      _msg(context.l10n.signInFindFriends);
      return;
    }
    // While typing, don't pop the offline dialog on every keystroke.
    if (!live && !await requireInternet(context)) return;
    if (!mounted) return;
    final seq = ++_searchSeq;
    setState(() => _searching = true);
    try {
      final hits = await FriendService.search(query);
      if (!mounted || seq != _searchSeq) return; // a newer query won
      setState(() {
        _hits = hits;
        _searchedFor = query;
      });
      await _prefetchStats();
    } catch (e) {
      if (!live && mounted) _msg(AuthService.messageFromError(e));
    } finally {
      if (mounted && seq == _searchSeq) setState(() => _searching = false);
    }
  }

  Future<void> _send(ProfileSearchHit hit) async {
    if (!await requireInternet(context)) return;
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      await FriendService.sendRequest(hit.id);
      _msg(context.l10n.requestSentTo(hit.username));
      setState(() {
        _hits = [
          for (final h in _hits)
            if (h.id != hit.id) h
        ];
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
    int? playerNo,
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
                  // Same look as the Player ID on Home.
                  if (playerNo != null)
                    Text(context.l10n.playerIdLabel(formatPlayerId(playerNo)),
                        style: const TextStyle(
                            color: C.teal,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.4,
                            fontFeatures: [FontFeature.tabularFigures()])),
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
          final reqLabel = requests.isEmpty
              ? context.l10n.requests
              : context.l10n.requestsCount('${requests.length}');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopBar(context.l10n.friendsLabel),
              const SizedBox(height: 14),
              if (!signedIn)
                AppCard(
                  child: Text(
                    context.l10n.signInSearchPlayers,
                    style: const TextStyle(color: C.muted),
                  ),
                )
              else ...[
                PdfSearchField(
                  controller: _search,
                  hint: context.l10n.searchPlayersHint,
                  onChanged: _onQueryChanged,
                  onSubmitted: (q) => _runSearch(q),
                ),
                const SizedBox(height: 12),
                PdfSegRow(
                  options: [context.l10n.friendsLabel, reqLabel],
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
                      if (!_searching &&
                          _hits.isEmpty &&
                          _searchedFor.isNotEmpty &&
                          _search.text.trim() == _searchedFor)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(context.l10n.noPlayersFound,
                                style: const TextStyle(color: C.muted)),
                          ),
                        ),
                      if (_hits.isNotEmpty) ...[
                        PdfSectionLabel(context.l10n.searchResults),
                        const SizedBox(height: 10),
                        for (final h in _hits)
                          _rowCard(
                            name: h.username,
                            avatarUrl: h.avatarUrl,
                            userId: h.id,
                            playerNo: h.playerNo,
                            trailing: FriendService.friends.value
                                    .any((f) => f.otherUserId == h.id)
                                ? PdfOutlineButton(context.l10n.friendsLabel)
                                : PdfTealButton(
                                    context.l10n.addFriend,
                                    compact: true,
                                    onTap: _busy ? null : () => _send(h),
                                  ),
                          ),
                        const SizedBox(height: 8),
                      ],
                      if (tab == 0) ...[
                        if (friends.isEmpty)
                          AppCard(
                            child: Text(
                              context.l10n.noFriendsYet,
                              style: const TextStyle(color: C.muted),
                            ),
                          )
                        else
                          for (final f in friends)
                            _rowCard(
                              name: f.otherUsername ?? 'player',
                              avatarUrl: f.otherAvatarUrl,
                              userId: f.otherUserId,
                              trailing: (_canChallenge[f.otherUserId] ?? true)
                                  ? PdfTealButton(
                                      context.l10n.challenge,
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
                                    )
                                  : const SizedBox.shrink(),
                            ),
                      ] else ...[
                        if (requests.isNotEmpty) ...[
                          PdfSectionLabel(context.l10n.requests),
                          const SizedBox(height: 10),
                        ],
                        if (requests.isEmpty)
                          AppCard(
                            child: Text(context.l10n.noPendingRequests,
                                style: const TextStyle(color: C.muted)),
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
                                    context.l10n.accept,
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
                                              _msg(context.l10n.playerAdded(
                                                  r.otherUsername ??
                                                      context.l10n.player));
                                            } catch (e) {
                                              _msg(AuthService.messageFromError(
                                                  e));
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
                                              await FriendService.decline(r.id);
                                            } catch (e) {
                                              _msg(AuthService.messageFromError(
                                                  e));
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
                        Center(
                          child: Text(
                            context.l10n.requestsExpire7d,
                            style: const TextStyle(color: C.muted, fontSize: 12),
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
