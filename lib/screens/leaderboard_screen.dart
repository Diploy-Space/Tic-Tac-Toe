import 'package:flutter/material.dart';
import '../models.dart';
import '../models/cloud_match.dart';
import '../services/auth_service.dart';
import '../services/match_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const _medal = [
    Color(0xFFFFC24D),
    Color(0xFFC9CCE0),
    Color(0xFFE0915A)
  ];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    MatchSyncService.refresh().whenComplete(() {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) => ValueListenableBuilder<int>(
          valueListenable: MatchSyncService.tick,
          builder: (_, ___, ____) {
            final local = playerStats;
            final cloud = MatchSyncService.myStats.value;
            final rankNum = MatchSyncService.myRank.value;
            final useCloudStats = AuthService.isSignedIn && cloud != null;
            final rank = useCloudStats
                ? (rankNum == null ? '–' : '#$rankNum')
                : '–';
            final score =
                useCloudStats ? '${cloud.score}' : '${local.score}';
            final played =
                useCloudStats ? '${cloud.played}' : '${local.played}';
            final wins = useCloudStats ? '${cloud.wins}' : '${local.wins}';
            final rows = MatchSyncService.leaderboard.value;

            return SingleChildScrollView(
              child: staggered([
                const TopBar('Leaderboard'),
                UserCard(showCoins: false, stats: [
                  MapEntry('Rank', rank),
                  MapEntry('Score', score),
                  MapEntry('Played', played),
                  MapEntry('Wins', wins),
                ]),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (rows.isNotEmpty)
                  for (var i = 0; i < rows.length; i++) _cloudRow(rows[i], i)
                else
                  AppCard(
                      child: Text(
                    AuthService.isSignedIn
                        ? 'No cloud matches yet. Play vs The Doll while signed in to appear here.'
                        : 'No ranked players yet. Sign in and play to join the board.',
                    style: const TextStyle(color: C.muted),
                  )),
              ], gap: 10),
            );
          },
        ),
      ),
    );
  }

  Widget _cloudRow(LeaderboardEntry e, int i) {
    return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/public-profile',
            arguments: e.userId,
          ),
          borderRadius: BorderRadius.circular(14),
          child: Row(children: [
            SizedBox(
                width: 34,
                child: i < 3
                    ? Container(
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _medal[i], shape: BoxShape.circle),
                        child: Text('${e.rank}',
                            style: const TextStyle(
                                color: C.bg, fontWeight: FontWeight.w800)))
                    : Text('${e.rank}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: C.muted, fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Container(
                width: 34,
                height: 34,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ProfileAvatar(url: e.avatarUrl, size: 34)),
            const SizedBox(width: 12),
            Expanded(
                child: Text(e.username,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
            Text('${e.score}',
                style: const TextStyle(fontWeight: FontWeight.w800)),
          ]),
        ));
  }
}
