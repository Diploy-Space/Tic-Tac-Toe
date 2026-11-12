import 'package:flutter/material.dart';
import '../models/challenge_args.dart';
import '../models/cloud_match.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/match_repository.dart';
import '../services/profile_service.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';

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
      ]);
      if (!mounted) return;
      final p = results[0] as UserProfile?;
      final s = results[1] as LeaderboardEntry?;
      setState(() {
        _profile = p ?? _profile;
        _stats = s ?? _stats;
        _loading = false;
        if (_profile == null) _error = 'Profile not found';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  String _memberSince(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final l = d.toLocal();
    return 'Member since ${months[l.month - 1]} ${l.year}';
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
              title: const Text('Share profile'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share coming soon')),
                );
              },
            ),
            ListTile(
              leading: Icon(
                _blocked ? Icons.lock_open : Icons.block,
                color: C.danger,
              ),
              title: Text(_blocked ? 'Unblock player' : 'Block player'),
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
      SnackBar(content: Text(_blocked ? 'Player blocked' : 'Player unblocked')),
    );
  }

  void _challenge() {
    if (!AuthService.isSignedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to challenge this player')),
      );
      return;
    }
    final p = _profile;
    if (p == null) return;
    if (p.id == AuthService.user?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot challenge yourself')),
      );
      return;
    }
    if (_blocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unblock this player to challenge')),
      );
      return;
    }
    Navigator.pushNamed(
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
              const Text(
                'Report or block',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                'Match history and activity stay private. Reporting is for profile abuse; in-match chat reports use the chat Report button.',
                style: TextStyle(color: C.muted, height: 1.35, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined, color: C.danger),
                title: const Text('Report player'),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Use Chat → Report during a live match for evidence-based reports.',
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
                title: Text(_blocked ? 'Unblock player' : 'Block player'),
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
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: C.border2),
            ),
            child: url != null && url.trim().isNotEmpty
                ? ProfileAvatar(url: url, size: 64)
                : PdfGradientAvatar(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    size: 64,
                  ),
          ),
          if (rank > 0)
            Positioned(
              right: 0,
              bottom: 2,
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: C.coin,
                  shape: BoxShape.circle,
                  border: Border.all(color: C.bg, width: 2),
                ),
                child: Text(
                  '#$rank',
                  style: const TextStyle(
                    color: C.bg,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
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
          Text(label, style: const TextStyle(color: C.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? C.text,
              fontWeight: FontWeight.w800,
              fontSize: 22,
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

    return AppScaffold(
      child: ScrollFill(
        child: staggered([
          TopBar(
            'Player',
            trailing: RoundIconBox(
              Icons.more_horiz,
              label: 'More',
              onTap: _openMenu,
            ),
          ),
          if (_loading && p == null)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null && p == null)
            AppCard(child: Text(_error!, style: const TextStyle(color: C.muted)))
          else if (p != null) ...[
            AppCard(
              borderColor: C.magenta,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _avatarWithRank(
                        p.username,
                        p.avatarUrl ?? s?.avatarUrl,
                        rank,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Tag('Player 042'),
                            Text(
                              p.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _memberSince(p.createdAt),
                              style: const TextStyle(
                                color: C.muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: C.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        _stat(
                          'Rank',
                          rank > 0 ? '#$rank' : '–',
                          valueColor: C.coin,
                        ),
                        Container(width: 1, height: 36, color: C.border),
                        _stat('Score', '$score'),
                        Container(width: 1, height: 36, color: C.border),
                        _stat('Wins', '$wins', valueColor: C.teal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const AppCard(
              child: Row(
                children: [
                  Icon(Icons.lock_outline, color: C.teal, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Only rank, score and wins are public. Match history and activity stay private.',
                      style: TextStyle(color: C.muted, height: 1.35, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PdfPinkButton('Challenge', onTap: _challenge),
            const SizedBox(height: 14),
            Center(
              child: InkWell(
                onTap: _reportOrBlock,
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_outlined, size: 16, color: C.muted),
                      SizedBox(width: 8),
                      Text(
                        'Report or block this player',
                        style: TextStyle(color: C.muted, fontSize: 13),
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
