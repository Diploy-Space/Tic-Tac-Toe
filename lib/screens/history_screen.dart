import 'package:flutter/material.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../models/cloud_match.dart';
import '../services/auth_service.dart';
import '../services/match_sync_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String duration = 'All';

  /// Filter values stay English; only the label is translated.
  String _durationLabel(String d) => switch (d) {
        'Today' => context.l10n.today,
        '7 days' => context.l10n.days7,
        '30 days' => context.l10n.days30,
        _ => context.l10n.all,
      };
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

  bool _inRange(DateTime at) {
    final now = DateTime.now();
    switch (duration) {
      case 'Today':
        return at.year == now.year &&
            at.month == now.month &&
            at.day == now.day;
      case '7 days':
        return at.isAfter(now.subtract(const Duration(days: 7)));
      case '30 days':
        return at.isAfter(now.subtract(const Duration(days: 30)));
      default:
        return true;
    }
  }

  List<MatchRecord> _localFiltered() =>
      playerStats.history.where((m) => _inRange(m.at)).toList();

  List<CloudMatch> _cloudFiltered(List<CloudMatch> all) =>
      all.where((m) => _inRange(m.playedAt.toLocal())).toList();

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

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
            // Signed-in users always use cloud history (even if empty).
            final useCloud = signedIn;
            final localList = _localFiltered();
            final cloudList = _cloudFiltered(cloud);
            final playedCount = useCloud
                ? (MatchSyncService.myStats.value?.played ?? cloud.length)
                : playerStats.played;

            return Column(children: [
              TopBar(context.l10n.history),
              const SizedBox(height: 14),
              AppCard(
                  borderColor: C.magenta,
                  child: Column(children: [
                    Row(children: [
                      ValueListenableBuilder<String?>(
                          valueListenable: authAvatarUrl,
                          builder: (_, url, __) => Container(
                              width: 52,
                              height: 52,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: C.border2)),
                              child: ProfileAvatar(url: url, size: 50))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: ValueListenableBuilder<String>(
                              valueListenable: authDisplayName,
                              builder: (_, name, __) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Tag(signedIn
                                            ? context.l10n.cloud
                                            : context.l10n.local),
                                        Text(name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                      ]))),
                      const CoinChip(),
                    ]),
                    const SizedBox(height: 12),
                    Container(
                        padding: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: C.border2))),
                        child: Row(children: [
                          Expanded(
                              child: Column(children: [
                            Text(context.l10n.played,
                                style: const TextStyle(color: C.muted, fontSize: 13)),
                            Text('$playedCount',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800)),
                          ])),
                          Expanded(
                              child: Column(children: [
                            Text(context.l10n.duration,
                                style: const TextStyle(color: C.muted, fontSize: 13)),
                            PopupMenuButton<String>(
                                color: C.surface,
                                initialValue: duration,
                                onSelected: (v) => setState(() => duration = v),
                                itemBuilder: (_) => [
                                      for (final d in const [
                                        'All',
                                        'Today',
                                        '7 days',
                                        '30 days'
                                      ])
                                        PopupMenuItem(
                                            value: d,
                                            child: Text(_durationLabel(d))),
                                    ],
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_durationLabel(duration),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: C.teal)),
                                      const Icon(Icons.arrow_drop_down,
                                          color: C.teal),
                                    ])),
                          ])),
                        ])),
                  ])),
              const SizedBox(height: 14),
              AppCard(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(context.l10n.match,
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(context.l10n.result,
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                        Text(context.l10n.date,
                            style: const TextStyle(fontWeight: FontWeight.w800)),
                      ])),
              const SizedBox(height: 14),
              Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : useCloud
                          ? _cloudListView(cloudList)
                          : _localListView(localList)),
            ]);
          },
        ),
      ),
    );
  }

  Widget _empty() => SizedBox(
      width: double.infinity,
      child: AppCard(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const ShapeIcon(ShapeKind.circle, size: 40, color: C.muted),
        const SizedBox(height: 12),
        Text(context.l10n.noHistory, style: const TextStyle(color: C.muted)),
      ])));

  Widget _localListView(List<MatchRecord> list) {
    if (list.isEmpty) return _empty();
    return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final m = list[i];
          final win = m.result == 'Win' || m.result == 'P1 win';
          return _row(
            title: m.opponent,
            subtitle:
                '${m.size}×${m.size}${m.coinDelta != 0 ? ' · ${m.coinDelta > 0 ? '+${AppLocaleService.formatCoinAmount(m.coinDelta)}' : AppLocaleService.formatCoinAmount(m.coinDelta)}' : ''}',
            result: m.result,
            win: win,
            draw: m.result == 'Draw',
            at: m.at,
          );
        });
  }

  Widget _cloudListView(List<CloudMatch> list) {
    if (list.isEmpty) return _empty();
    return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final m = list[i];
          final label = m.resultLabel;
          return _row(
            title: m.opponentName ?? m.mode,
            subtitle:
                '${m.boardSize}×${m.boardSize}${m.coinDelta != 0 ? ' · ${m.coinDelta > 0 ? '+${AppLocaleService.formatCoinAmount(m.coinDelta)}' : AppLocaleService.formatCoinAmount(m.coinDelta)}' : ''}',
            result: label,
            win: m.result == 'win',
            draw: m.result == 'draw',
            at: m.playedAt.toLocal(),
          );
        });
  }

  Widget _row({
    required String title,
    required String subtitle,
    required String result,
    required bool win,
    required bool draw,
    required DateTime at,
  }) =>
      AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle,
                      style: const TextStyle(color: C.muted, fontSize: 12)),
                ])),
            Text(result,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: win
                        ? C.teal
                        : draw
                            ? C.muted
                            : C.danger)),
            const SizedBox(width: 12),
            SizedBox(
                width: 72,
                child: Text(_fmt(at),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: C.muted, fontSize: 12))),
          ]));
}
