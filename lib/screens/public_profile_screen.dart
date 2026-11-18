import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/challenge_args.dart';
import '../models/cloud_match.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/challenge_flow_service.dart';
import '../services/friend_repository.dart';
import '../services/match_repository.dart';
import '../services/profile_service.dart';
import '../services/sfx_service.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF · Public Profile – Player Screen (page 1).
class PublicProfileScreen extends StatefulWidget {
  final String userId;
  const PublicProfileScreen({super.key, required this.userId});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  UserProfile? _profile;
  LeaderboardEntry? _stats;
  bool _loading = true;
  String? _error;
  bool _blocked = false;
  bool _canChallenge = true;

  /// none | pending (I sent) | incoming (they sent) | declined | friends | self
  String _friendState = 'none';
  String? _friendshipId;
  bool _friendBusy = false;

  PublicProfileArgs get _seed {
    final arg = ModalRoute.of(context)?.settings.arguments;
    return PublicProfileArgs.fromRoute(arg ?? widget.userId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final seed = _seed;
    final uid = seed.userId.isNotEmpty ? seed.userId : widget.userId;
    setState(() {
      _loading = true;
      _error = null;
      _blocked = AppStorage.isPlayerBlocked(uid);
      if (seed.username != null) {
        _profile = UserProfile(
          id: uid,
          username: seed.username!,
          avatarUrl: seed.avatarUrl,
          createdAt: DateTime.now(),
        );
      }
      if (seed.rank != null) {
        _stats = LeaderboardEntry(
          userId: uid,
          username: seed.username ?? 'player',
          avatarUrl: seed.avatarUrl,
          played: 0,
          wins: seed.wins ?? 0,
          losses: 0,
          draws: 0,
          score: seed.score ?? 0,
          winRate: 0,
          rank: seed.rank ?? 0,
        );
      }
    });
    try {
      final results = await Future.wait([
        ProfileService.loadPublic(uid),
        MatchRepository.fetchLeaderboardEntry(uid),
        ChallengeFlowService.canChallenge(uid),
        _loadFriendState(uid),
      ]);
      if (!mounted) return;
      final p = results[0] as UserProfile?;
      final s = results[1] as LeaderboardEntry?;
      final allow = results[2] as bool;
      final friend = results[3] as String;
      setState(() {
        _friendState = friend;
        _profile = p ?? _profile;
        _stats = s ?? _stats;
        _canChallenge = allow;
        _loading = false;
        if (_profile == null) _error = context.l10n.profileNotFound;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<String> _loadFriendState(String uid) async {
    final me = AuthService.user?.id;
    if (me == null) return 'none';
    if (me == uid) return 'self';
    try {
      final all = await FriendRepository.fetchMine();
      for (final f in all) {
        if (f.otherUserId != uid) continue;
        _friendshipId = f.id;
        if (f.status == 'accepted') return 'friends';
        if (f.status == 'pending') {
          return f.requesterId == me ? 'pending' : 'incoming';
        }
        return 'declined';
      }
    } catch (_) {}
    return 'none';
  }

  Future<void> _addFriend() async {
    if (!AuthService.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signInToAddFriends)),
      );
      return;
    }
    final p = _profile;
    if (p == null || _friendBusy) return;
    if (_friendState == 'friends' || _friendState == 'pending') return;
    if (_blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unblockToAdd)),
      );
      return;
    }
    setState(() => _friendBusy = true);
    String msg = context.l10n.friendRequestSentShort;
    try {
      if (_friendState == 'incoming' && _friendshipId != null) {
        await FriendRepository.accept(_friendshipId!);
        msg = context.l10n.nowFriendsShort;
        if (mounted) setState(() => _friendState = 'friends');
        // Friends-only challenge privacy may now allow a challenge.
        final allow = await ChallengeFlowService.canChallenge(p.id);
        if (mounted) setState(() => _canChallenge = allow);
      } else {
        // A previously declined request still occupies the unique pair;
        // clear it so a fresh request can be sent.
        if (_friendState == 'declined' && _friendshipId != null) {
          await FriendRepository.remove(_friendshipId!);
        }
        await FriendRepository.sendRequest(p.id);
        if (mounted) setState(() => _friendState = 'pending');
      }
    } catch (e) {
      SfxService.play(Sfx.error);
      msg = e.toString().replaceFirst('Exception: ', '');
      if ((msg == context.l10n.friendRequestExists ||
              msg.contains('already exists')) &&
          mounted) {
        setState(() => _friendState = 'pending');
      }
    }
    if (!mounted) return;
    setState(() => _friendBusy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _friendButton() {
    final (label, icon, enabled) = switch (_friendState) {
      'friends' => (context.l10n.friendsCaps, Icons.how_to_reg_outlined, false),
      'pending' => (context.l10n.requestSentCaps, Icons.schedule, false),
      'incoming' => (
          context.l10n.acceptRequestCaps,
          Icons.person_add_alt_1_outlined,
          true
        ),
      _ => (context.l10n.addFriendCaps, Icons.person_add_alt_1_outlined, true),
    };
    final color = enabled ? C.teal : C.muted;
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: enabled && !_friendBusy ? _addFriend : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: enabled ? C.teal : C.border2, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _friendBusy
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 22, color: color),
                const SizedBox(width: 10),
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: .5)),
              ]),
      ),
    );
  }

  Widget _challengeButton() => SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton(
          onPressed: _challenge,
          style: FilledButton.styleFrom(
            backgroundColor: C.magenta,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(context.l10n.challengeCaps,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1)),
        ),
      );

  String _memberSince(DateTime d) {
    final l10n = context.l10n;
    return l10n
        .memberSince(DateFormat.yMMM(l10n.localeName).format(d.toLocal()));
  }

  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined, color: C.muted),
              title: Text(context.l10n.shareProfile),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.shareComingSoon)),
                );
              },
            ),
            ListTile(
              leading: Icon(
                _blocked ? Icons.lock_open : Icons.block,
                color: C.danger,
              ),
              title: Text(_blocked
                  ? context.l10n.unblockPlayer
                  : context.l10n.blockPlayer),
              onTap: () async {
                Navigator.pop(ctx);
                await _toggleBlock();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBlock() async {
    final uid = _profile?.id ?? widget.userId;
    if (_blocked) {
      await AppStorage.unblockPlayer(uid);
    } else {
      await AppStorage.blockPlayer(uid);
    }
    if (!mounted) return;
    setState(() => _blocked = !_blocked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(_blocked
              ? context.l10n.playerBlocked
              : context.l10n.playerUnblocked)),
    );
  }

  Future<void> _challenge() async {
    if (!AuthService.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signInToChallenge)),
      );
      return;
    }
    final p = _profile;
    if (p == null) return;
    if (p.id == AuthService.user?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.cannotChallengeSelf)),
      );
      return;
    }
    if (_blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unblockToChallenge)),
      );
      return;
    }
    if (!_canChallenge) {
      // Re-check: privacy or friendship may have changed since load.
      final allow = await ChallengeFlowService.canChallenge(p.id);
      if (!mounted) return;
      setState(() => _canChallenge = allow);
      if (!allow) {
        SfxService.play(Sfx.error);
        final reason = ChallengeFlowService.challengeBlockReason[p.id];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(switch (reason) {
            'friends_only' => context.l10n.onlyFriendsChallenges(p.username),
            'nobody' => context.l10n.notAcceptingChallenges(p.username),
            _ => context.l10n.cantChallengeNow,
          }),
        ));
        return;
      }
    }
    await Navigator.pushNamed(
      context,
      '/challenge-stake',
      arguments: ChallengeStakeArgs(
        opponentId: p.id,
        opponentName: p.username,
        avatarUrl: p.avatarUrl ?? _stats?.avatarUrl,
        rank: _stats?.rank ?? 0,
        score: _stats?.score ?? 0,
      ),
    );
  }

  void _reportOrBlock() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.reportOrBlock,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.profilePrivacyNote,
                style:
                    const TextStyle(color: C.muted, height: 1.35, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined, color: C.danger),
                title: Text(context.l10n.reportPlayer),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n.useChatReport,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  _blocked ? Icons.lock_open : Icons.block,
                  color: C.danger,
                ),
                title: Text(_blocked
                    ? context.l10n.unblockPlayer
                    : context.l10n.blockPlayer),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _toggleBlock();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarWithRank(String name, String? url, int rank) {
    const size = 84.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: C.magenta, width: 2),
            ),
            child: ClipOval(
              child: url != null && url.trim().isNotEmpty
                  ? ProfileAvatar(url: url, size: size - 10)
                  : PdfGradientAvatar(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      size: size - 10,
                    ),
            ),
          ),
          if (rank > 0)
            Positioned(
              right: -2,
              bottom: 2,
              child: Container(
                constraints: const BoxConstraints(minWidth: 26),
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: C.coin,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: C.surface, width: 2),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: C.bg,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {Color? valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: C.muted, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? C.text,
              fontWeight: FontWeight.w700,
              fontSize: 28,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _profile;
    final s = _stats;
    final rank = s?.rank ?? 0;
    final score = s?.score ?? 0;
    final wins = s?.wins ?? 0;
    final isSelf =
        _friendState == 'self' || (p != null && p.id == AuthService.user?.id);

    return AppScaffold(
      child: ScrollFill(
        child: staggered([
          TopBar(
            context.l10n.player,
            trailing: RoundIconBox(
              Icons.more_horiz,
              label: context.l10n.more,
              onTap: _openMenu,
            ),
          ),
          if (_loading && p == null)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null && p == null)
            AppCard(
                child: Text(_error!, style: const TextStyle(color: C.muted)))
          else if (p != null) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: C.magenta, width: 1.5),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _avatarWithRank(
                        p.username,
                        p.avatarUrl ?? s?.avatarUrl,
                        rank,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _memberSince(p.createdAt),
                              style: const TextStyle(
                                color: C.muted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1, thickness: 1, color: C.border),
                  const SizedBox(height: 14),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        _stat(
                          context.l10n.rank,
                          rank > 0 ? '#$rank' : '–',
                          valueColor: C.coin,
                        ),
                        const VerticalDivider(
                            width: 1, thickness: 1, color: C.border),
                        _stat(context.l10n.score, '$score'),
                        const VerticalDivider(
                            width: 1, thickness: 1, color: C.border),
                        _stat(context.l10n.wins, '$wins', valueColor: C.teal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: C.surface.withValues(alpha: .6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: C.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: C.teal, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      context.l10n.publicStatsNote,
                      style: const TextStyle(
                          color: C.muted, height: 1.4, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (!isSelf) ...[
              _friendButton(),
              _challengeButton(),
            ],
            Center(
              child: InkWell(
                onTap: _reportOrBlock,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.outlined_flag, size: 18, color: C.muted),
                      const SizedBox(width: 10),
                      Text(
                        context.l10n.reportOrBlockPlayer,
                        style: const TextStyle(color: C.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ]),
      ),
    );
  }
}
