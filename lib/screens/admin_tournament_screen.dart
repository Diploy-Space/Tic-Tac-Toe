import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/tournament_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// Admin: create tournament + generate bracket (profiles.is_admin).
class AdminTournamentScreen extends StatefulWidget {
  const AdminTournamentScreen({super.key});

  @override
  State<AdminTournamentScreen> createState() => _AdminTournamentScreenState();
}

class _AdminTournamentScreenState extends State<AdminTournamentScreen> {
  final _name = TextEditingController(text: 'Weekend Showdown');
  final _fee = TextEditingController(text: '25');
  final _max = TextEditingController(text: '32');
  final _regDays = TextEditingController(text: '2');
  final _startDays = TextEditingController(text: '3');
  bool _busy = false;
  String? _lastId;
  String? _msg;

  @override
  void initState() {
    super.initState();
    TournamentService.refreshList();
  }

  @override
  void dispose() {
    _name.dispose();
    _fee.dispose();
    _max.dispose();
    _regDays.dispose();
    _startDays.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (_busy) return;
    final name = _name.text.trim();
    final fee = int.tryParse(_fee.text.trim()) ?? 0;
    final maxP = int.tryParse(_max.text.trim()) ?? 0;
    final regD = int.tryParse(_regDays.text.trim()) ?? 2;
    final startD = int.tryParse(_startDays.text.trim()) ?? 3;
    if (name.isEmpty || maxP < 2) {
      setState(() => _msg = 'Name and max players (min 2) required');
      return;
    }
    setState(() {
      _busy = true;
      _msg = null;
    });
    final now = DateTime.now();
    final id = await TournamentService.adminCreateTournament(
      name: name,
      entryFee: fee,
      maxParticipants: maxP,
      registrationClosesAt: now.add(Duration(days: regD)),
      startsAt: now.add(Duration(days: startD)),
    );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _lastId = id;
      _msg = id == null
          ? (TournamentService.error.value ?? 'Failed')
          : 'Created: $id';
    });
  }

  Future<void> _generate(String id) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _msg = null;
    });
    final res = await TournamentService.adminGenerateBracket(id);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _msg = res == null
          ? (TournamentService.error.value ?? 'Bracket failed')
          : 'Bracket OK · size ${res['bracket_size']} · byes ${res['byes']} · players ${res['players']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Admin tournament'),
          const Text(
            'Requires profiles.is_admin. Create event, then generate bracket after players register.',
            style: TextStyle(color: C.muted, height: 1.35),
          ),
          const PdfSectionLabel('Create'),
          AppField(
            icon: Icons.emoji_events_outlined,
            hint: 'Tournament name',
            controller: _name,
            obscure: false,
            obscureToggle: false,
          ),
          Row(children: [
            Expanded(
              child: AppField(
                icon: Icons.monetization_on_outlined,
                hint: 'Entry fee',
                controller: _fee,
                obscure: false,
                obscureToggle: false,
                type: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppField(
                icon: Icons.groups_outlined,
                hint: 'Max players',
                controller: _max,
                obscure: false,
                obscureToggle: false,
                type: TextInputType.number,
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: AppField(
                icon: Icons.timer_outlined,
                hint: 'Reg closes (days)',
                controller: _regDays,
                obscure: false,
                obscureToggle: false,
                type: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppField(
                icon: Icons.play_arrow_outlined,
                hint: 'Starts in (days)',
                controller: _startDays,
                obscure: false,
                obscureToggle: false,
                type: TextInputType.number,
              ),
            ),
          ]),
          PdfPinkButton(
            _busy ? 'Working…' : 'CREATE TOURNAMENT',
            onTap: _busy ? null : _create,
          ),
          if (_lastId != null) ...[
            AppCard(
              borderColor: C.teal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Last created ID',
                      style: TextStyle(color: C.muted, fontSize: 12)),
                  SelectableText(_lastId!,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: PdfGhostButton('Copy ID', onTap: () async {
                        await Clipboard.setData(ClipboardData(text: _lastId!));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied')),
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PdfTealButton('Generate bracket',
                          onTap: _busy ? null : () => _generate(_lastId!)),
                    ),
                  ]),
                ],
              ),
            ),
          ],
          if (_msg != null)
            Text(_msg!,
                style: TextStyle(
                  color: _msg!.startsWith('Created') || _msg!.startsWith('Bracket')
                      ? C.teal
                      : C.danger,
                )),
          const PdfSectionLabel('Existing'),
          ValueListenableBuilder(
            valueListenable: TournamentService.list,
            builder: (_, items, __) {
              if (items.isEmpty) {
                return const AppCard(
                  child: Text('No tournaments yet.',
                      style: TextStyle(color: C.muted)),
                );
              }
              return Column(
                children: [
                  for (final t in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(t.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                            Text(
                              '${t.status} · ${t.registeredCount}/${t.maxParticipants} · fee ${t.entryFeeMinor}',
                              style: const TextStyle(
                                  color: C.muted, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            Row(children: [
                              Expanded(
                                child: PdfGhostButton('Bracket', onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/tournament-bracket',
                                    arguments: t.id,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: PdfTealButton(
                                  'Generate',
                                  compact: true,
                                  onTap: _busy ? null : () => _generate(t.id),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ]),
      ),
    );
  }
}
