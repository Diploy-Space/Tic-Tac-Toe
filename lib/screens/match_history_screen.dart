import 'package:flutter/material.dart';
import '../models.dart';
import '../models/cloud_match.dart';
import '../services/auth_service.dart';
import '../services/match_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

enum _ModeFilter { all, computer, online, challenge }

/// Design sheet: MATCH HISTORY — All / Computer / Online / Challenge + W/L/D cards.
class MatchHistoryScreen extends StatefulWidget {
  const MatchHistoryScreen({super.key});

  @override
  State<MatchHistoryScreen> createState() => _MatchHistoryScreenState();
}

class _MatchHistoryScreenState extends State<MatchHistoryScreen> {
  _ModeFilter _filter = _ModeFilter.all;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (AuthService.isSignedIn) {
      _loading = true;
      MatchSyncService.refresh().whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  List<_HistItem> _items({
    required bool useCloud,
    required List<CloudMatch> cloud,
  }) {
    final raw = useCloud
        ? [
            for (final m in cloud) _HistItem.fromCloud(m),
          ]
        : [
            for (final m in playerStats.history) _HistItem.fromLocal(m),
          ];
    return [
      for (final i in raw)
        if (_filter == _ModeFilter.all || i.bucket == _filter) i,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: statsTick,
        builder: (_, __, ___) => ValueListenableBuilder<int>(
          valueListenable: MatchSyncService.tick,
          builder: (_, ___, ____) {
            final signedIn = AuthService.isSignedIn;
            final cloud = MatchSyncService.history.value;
            final useCloud = signedIn;
            final items = _items(useCloud: useCloud, cloud: cloud);
            final wins = items.where((e) => e.kind == _ResultKind.win).length;
            final losses =
                items.where((e) => e.kind == _ResultKind.loss).length;
            final draws =
                items.where((e) => e.kind == _ResultKind.draw).length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopBar('MATCH HISTORY'),
                const SizedBox(height: 16),
                _ModeChips(
                  selected: _filter,
                  onChanged: (f) => setState(() => _filter = f),
                ),
                const SizedBox(height: 14),
                Text(
                  '${items.length} matches · $wins wins · $losses losses · $draws draw${draws == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: C.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(color: C.magenta),
                        )
                      : items.isEmpty
                          ? const _Empty()
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) => _MatchCard(item: items[i]),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

enum _ResultKind { win, loss, draw }

class _HistItem {
  final String title;
  final String subtitle;
  final _ResultKind kind;
  final DateTime at;
  final _ModeFilter bucket;

  const _HistItem({
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.at,
    required this.bucket,
  });

  factory _HistItem.fromCloud(CloudMatch m) {
    final modeLabel = _cloudModeLabel(m);
    final bucket = _cloudBucket(m);
    final parts = <String>[
      modeLabel,
      '${m.boardSize}×${m.boardSize}',
    ];
    final kind = switch (m.result) {
      'win' => _ResultKind.win,
      'draw' => _ResultKind.draw,
      _ => _ResultKind.loss,
    };
    final name = (m.opponentName ?? '').trim();
    return _HistItem(
      title: name.isEmpty ? 'vs $modeLabel' : 'vs $name',
      subtitle: parts.join(' · '),
      kind: kind,
      at: m.playedAt.toLocal(),
      bucket: bucket,
    );
  }

  factory _HistItem.fromLocal(MatchRecord m) {
    final modeLabel = m.vsAi
        ? 'Computer'
        : (m.quickMatch ? 'Online' : 'Pass & Play');
    final bucket = m.vsAi
        ? _ModeFilter.computer
        : (m.quickMatch ? _ModeFilter.online : _ModeFilter.all);
    final kind = (m.result == 'Win' || m.result == 'P1 win')
        ? _ResultKind.win
        : (m.result == 'Draw' ? _ResultKind.draw : _ResultKind.loss);
    final name = m.opponent.trim();
    return _HistItem(
      title: name.isEmpty ? 'vs $modeLabel' : 'vs $name',
      subtitle: '$modeLabel · ${m.size}×${m.size}',
      kind: kind,
      at: m.at,
      bucket: bucket,
    );
  }
}

String _cloudModeLabel(CloudMatch m) {
  if (m.stake > 0 && (m.mode == 'online' || m.mode == 'quick_match')) {
    return 'Challenge';
  }
  switch (m.mode) {
    case 'ai':
      return 'Computer';
    case 'quick_match':
    case 'online':
      return 'Online';
    default:
      return m.mode;
  }
}

_ModeFilter _cloudBucket(CloudMatch m) {
  if (m.stake > 0 && (m.mode == 'online' || m.mode == 'quick_match')) {
    return _ModeFilter.challenge;
  }
  switch (m.mode) {
    case 'ai':
      return _ModeFilter.computer;
    case 'quick_match':
    case 'online':
      return _ModeFilter.online;
    default:
      return _ModeFilter.all;
  }
}

class _ModeChips extends StatelessWidget {
  final _ModeFilter selected;
  final ValueChanged<_ModeFilter> onChanged;
  const _ModeChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, _ModeFilter f) {
      final on = selected == f;
      return Material(
        color: on ? C.magenta : C.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onChanged(f),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: on
                  ? null
                  : Border.all(color: const Color(0xFF3A3A46), width: 1),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: on ? Colors.white : C.muted,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          chip('All', _ModeFilter.all),
          const SizedBox(width: 8),
          chip('Computer', _ModeFilter.computer),
          const SizedBox(width: 8),
          chip('Online', _ModeFilter.online),
          const SizedBox(width: 8),
          chip('Challenge', _ModeFilter.challenge),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final _HistItem item;
  const _MatchCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final (letter, bg, fg) = switch (item.kind) {
      _ResultKind.win => (
          'W',
          const Color(0xFF1B3D36),
          const Color(0xFF3DDBB0),
        ),
      _ResultKind.loss => (
          'L',
          const Color(0xFF3A1A28),
          const Color(0xFFE0457A),
        ),
      _ResultKind.draw => (
          'D',
          const Color(0xFF3A2E18),
          const Color(0xFFE0B04A),
        ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              letter,
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: C.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: C.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _relativeDay(item.at),
            style: const TextStyle(
              color: C.muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _relativeDay(DateTime at) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(at.year, at.month, at.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${at.day} ${months[at.month - 1]}';
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'No matches yet',
        style: TextStyle(color: C.muted, fontWeight: FontWeight.w600),
      ),
    );
  }
}
