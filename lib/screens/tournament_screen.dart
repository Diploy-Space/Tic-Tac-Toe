import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/tournament_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// Tournament hub — loads live list when migration applied; demo fallback otherwise.
class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});
  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  Duration left = const Duration(hours: 2, minutes: 14, seconds: 6);
  Timer? _t;
  bool _usedServer = false;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || left.inSeconds == 0) return;
      setState(() => left -= const Duration(seconds: 1));
    });
    _load();
  }

  Future<void> _load() async {
    if (!AuthService.isSignedIn) return;
    await TournamentService.refreshList();
    if (!mounted) return;
    setState(() =>
        _usedServer = TournamentService.list.value.isNotEmpty ||
            TournamentService.error.value == null);
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  Widget _timeBox(String v, String l) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: C.surface2,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: [
            Text(v,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            Text(l, style: const TextStyle(color: C.muted, fontSize: 12)),
          ]),
        ),
      );

  Widget _stat(String v, String l) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: C.border),
          ),
          child: Column(children: [
            Text(v,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            Text(l, style: const TextStyle(color: C.muted, fontSize: 12)),
          ]),
        ),
      );

  Widget _bullet(String text) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: C.magenta,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(height: 1.3))),
          ],
        ),
      );

  Future<void> _register(TournamentSummary t) async {
    final ok = await TournamentService.register(t.id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(TournamentService.error.value ?? 'Failed')));
      return;
    }
    Navigator.pushNamed(context, '/tournament-joined', arguments: t.id);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ValueListenableBuilder<List<TournamentSummary>>(
            valueListenable: TournamentService.list,
            builder: (_, items, __) {
              final live = items.isNotEmpty ? items.first : null;
              final entry = live?.entryFeeMinor ?? 25;
              final name = live?.name ?? 'Weekend Showdown';
              final players = live != null
                  ? '${live.registeredCount}/${live.maxParticipants}'
                  : '128';
              final prize = live != null
                  ? '${live.prizePoolMinor}'
                  : '2.5K';

              return staggered([
                const TopBar('Tournament'),
                if (TournamentService.error.value != null && live == null)
                  AppCard(
                    child: Text(
                      'Server tournaments unavailable — showing demo.\n${TournamentService.error.value}',
                      style: const TextStyle(color: C.muted, height: 1.35),
                    ),
                  ),
                PdfModalCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        live != null
                            ? live.status.toUpperCase()
                            : 'LIVE EVENT',
                        style: const TextStyle(
                          color: C.magenta,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text('Ends in',
                          style: TextStyle(color: C.muted, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(children: [
                        _timeBox(_two(left.inHours), 'hrs'),
                        _timeBox(_two(left.inMinutes % 60), 'min'),
                        _timeBox(_two(left.inSeconds % 60), 'sec'),
                      ]),
                    ],
                  ),
                ),
                Row(children: [
                  _stat('$entry', 'Entry'),
                  _stat(prize, 'Prize pool'),
                  _stat(players, 'Players'),
                ]),
                const PdfSectionLabel('How it works'),
                _bullet('Single elimination: lose once and you are out'),
                _bullet('20 seconds per move'),
                _bullet('A draw replays the round'),
                ValueListenableBuilder<int>(
                  valueListenable: coins,
                  builder: (_, c, __) => Text(
                    'Your balance: $c coins',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: C.muted),
                  ),
                ),
                if (live != null && !live.iAmRegistered)
                  PdfPinkButton(
                    'JOIN FOR $entry COINS',
                    onTap: () => _register(live),
                  )
                else if (live != null && live.iAmRegistered)
                  PdfPinkButton(
                    "YOU'RE IN — VIEW BRACKET",
                    onTap: () {
                      TournamentService.activeTournamentId.value = live.id;
                      Navigator.pushNamed(context, '/tournament-bracket',
                          arguments: live.id);
                    },
                  )
                else
                  PdfPinkButton(
                    'JOIN FOR $entry COINS',
                    onTap: () => Navigator.pushNamed(
                        context, '/tournament-join-confirm'),
                  ),
                PdfGhostButton(
                  'View bracket',
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/tournament-bracket',
                    arguments: live?.id,
                  ),
                ),
                if (_usedServer && items.length > 1) ...[
                  const PdfSectionLabel('Other events'),
                  for (final t in items.skip(1))
                    AppCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                        subtitle: Text(
                          '${t.entryFeeMinor} coins · ${t.registeredCount}/${t.maxParticipants} · ${t.status}',
                          style: const TextStyle(color: C.muted),
                        ),
                        trailing: t.iAmRegistered
                            ? const Tag('Joined', color: C.teal)
                            : null,
                        onTap: t.iAmRegistered
                            ? () => Navigator.pushNamed(
                                context, '/tournament-bracket',
                                arguments: t.id)
                            : () => _register(t),
                      ),
                    ),
                ],
              ]);
            },
          ),
        ),
      ),
    );
  }
}
