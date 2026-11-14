import 'dart:async';

import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 14–18 (+ reactions) — Quick/ephemeral chat visual flow.
enum _ChatPhase { off, sent, incoming, on, stopped, reactions }

class EphemeralChatDemoScreen extends StatefulWidget {
  const EphemeralChatDemoScreen({super.key});

  @override
  State<EphemeralChatDemoScreen> createState() =>
      _EphemeralChatDemoScreenState();
}

class _EphemeralChatDemoScreenState extends State<EphemeralChatDemoScreen> {
  _ChatPhase phase = _ChatPhase.off;
  int waitLeft = 20;
  Timer? _t;
  final _input = TextEditingController();
  final List<_Bubble> bubbles = [
    _Bubble('Nice move', mine: false, faded: true),
    _Bubble('Good luck!', mine: false),
    _Bubble('You too!', mine: true),
  ];
  bool muteReactions = false;
  String? selectedReaction = '🔥';

  @override
  void dispose() {
    _t?.cancel();
    _input.dispose();
    super.dispose();
  }

  void _startWait() {
    waitLeft = 20;
    phase = _ChatPhase.sent;
    _t?.cancel();
    _t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (waitLeft <= 1) {
        _t?.cancel();
        setState(() => phase = _ChatPhase.off);
        return;
      }
      setState(() => waitLeft--);
    });
    setState(() {});
  }

  Widget _header() {
    return Row(
      children: [
        const PdfGradientAvatar('Y', size: 44),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You', style: TextStyle(fontWeight: FontWeight.w800)),
              Text('X', style: TextStyle(color: C.magenta, fontSize: 13)),
            ],
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('diployteam',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              Text('O', style: TextStyle(color: C.teal, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: phase == _ChatPhase.reactions ? C.teal : Colors.transparent,
              width: 2,
            ),
          ),
          child: const PdfGradientAvatar('D', size: 44),
        ),
      ],
    );
  }

  Widget _cell(String? m, {String? reaction}) => Container(
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        alignment: Alignment.center,
        child: m == null
            ? null
            : Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    m,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: m == 'X' ? C.magenta : C.teal,
                      shadows: [
                        Shadow(
                          color: (m == 'X' ? C.magenta : C.teal)
                              .withValues(alpha: 0.7),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  if (reaction != null)
                    Positioned(
                      right: 6,
                      bottom: 6,
                      child: Text(reaction, style: const TextStyle(fontSize: 14)),
                    ),
                ],
              ),
      );

  Widget _board() => Expanded(
        child: GridView.count(
          crossAxisCount: 3,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _cell('X'),
            _cell(null),
            _cell('O', reaction: phase == _ChatPhase.reactions ? '🔥' : null),
            _cell(null),
            _cell('X'),
            _cell(null),
            _cell('O'),
            _cell(null),
            _cell(null),
          ],
        ),
      );

  Widget _panel() {
    switch (phase) {
      case _ChatPhase.off:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: C.muted, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chat is off',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        Text(
                          'diployteam must accept before chat starts.',
                          style: TextStyle(color: C.muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PdfPinkButton('Request chat', onTap: _startWait),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => setState(() => phase = _ChatPhase.reactions),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 54,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: C.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: C.border2),
                    ),
                    child: const Text('🔥', style: TextStyle(fontSize: 22)),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => setState(() => phase = _ChatPhase.incoming),
              child: const Text('Simulate incoming request',
                  style: TextStyle(color: C.teal)),
            ),
          ],
        );
      case _ChatPhase.sent:
        return PdfModalCard(
          child: Column(
            children: [
              const PdfGradientAvatar('D', size: 52),
              const SizedBox(height: 12),
              const Text('Chat request sent',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 8),
              const Text(
                'Waiting for diployteam to accept. Keep playing, the match is not paused.',
                textAlign: TextAlign.center,
                style: TextStyle(color: C.muted, fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 12),
              Text('${waitLeft}s',
                  style: const TextStyle(
                      color: C.teal, fontWeight: FontWeight.w800, fontSize: 20)),
              const SizedBox(height: 14),
              PdfGhostButton('Cancel request', onTap: () {
                _t?.cancel();
                setState(() => phase = _ChatPhase.off);
              }),
            ],
          ),
        );
      case _ChatPhase.incoming:
        return PdfModalCard(
          borderColor: C.teal,
          child: Column(
            children: [
              const PdfSectionLabel('Chat request'),
              const SizedBox(height: 12),
              const PdfGradientAvatar('D', size: 56),
              const SizedBox(height: 12),
              const Text('diployteam wants to chat',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              const SizedBox(height: 8),
              const Text(
                'Messages vanish in seconds and are never saved. You can stop at any time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: C.muted, fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: PdfTealButton('Accept', onTap: () {
                    setState(() => phase = _ChatPhase.on);
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PdfGhostButton('Not now', onTap: () {
                    setState(() => phase = _ChatPhase.off);
                  }),
                ),
              ]),
              TextButton(
                onPressed: () => setState(() => phase = _ChatPhase.off),
                child: const Text('Block chat for this match',
                    style: TextStyle(color: C.muted)),
              ),
            ],
          ),
        );
      case _ChatPhase.on:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: C.teal, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              const Text('Chat on',
                  style: TextStyle(
                      color: C.teal, fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: C.magenta.withValues(alpha: 0.55),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Material(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Use Report in live matches (Chat → flag)')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: C.magenta, width: 1.4),
                      ),
                      child: const Icon(Icons.flag_outlined,
                          color: C.text, size: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 42,
                child: OutlinedButton(
                  onPressed: () => setState(() => phase = _ChatPhase.stopped),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: C.danger,
                    side: const BorderSide(color: C.magenta),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  child: const Text('Stop chat',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            PdfModalCard(
              borderColor: C.teal,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final b in bubbles)
                    Align(
                      alignment: b.mine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: b.mine
                              ? C.magenta.withValues(alpha: 0.28)
                              : C.surface2,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          b.text,
                          style: TextStyle(
                            color: b.faded ? C.muted : C.text,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: C.surface2,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < 3; i++)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 2.5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: C.teal.withValues(
                                    alpha: i == 1 ? 1 : 0.35),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: const LinearProgressIndicator(
                      value: 0.55,
                      minHeight: 4,
                      backgroundColor: C.surface2,
                      color: C.teal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Messages disappear after 8s • never saved',
                    style: TextStyle(color: C.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final q in [
                    'Good move!',
                    'Close one!',
                    'GG',
                    'Rematch?'
                  ]) ...[
                    PdfQuickChip(q, onTap: () {
                      setState(() => bubbles.add(_Bubble(q, mine: true)));
                    }),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  style: const TextStyle(color: C.text),
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: const TextStyle(color: C.muted),
                    isDense: true,
                    filled: true,
                    fillColor: C.surface2,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    final t = _input.text.trim();
                    if (t.isEmpty) return;
                    setState(() {
                      bubbles.add(_Bubble(t, mine: true));
                      _input.clear();
                    });
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: C.magenta,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Send',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
          ],
        );
      case _ChatPhase.stopped:
        return PdfModalCard(
          borderColor: C.danger,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('diployteam stopped the chat',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 6),
              const Text(
                'Chat is off for the rest of this match. Reactions still work.',
                style: TextStyle(color: C.muted, fontSize: 13, height: 1.35),
              ),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                    child: PdfGhostButton('Request again', onTap: _startWait)),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Use Chat → Report in live matches')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: C.danger,
                        side: const BorderSide(color: C.danger),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Report',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ]),
            ],
          ),
        );
      case _ChatPhase.reactions:
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: C.teal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: C.teal),
                ),
                child: const Text('diployteam reacted',
                    style: TextStyle(
                        color: C.teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ),
            PdfModalCard(
              borderColor: C.border2,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Reactions',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            setState(() => muteReactions = !muteReactions),
                        child: Text(
                          muteReactions ? 'Unmute' : 'Mute reactions',
                          style: const TextStyle(color: C.muted, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  if (!muteReactions)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        for (final e in [
                          '🔥',
                          '😂',
                          '👏',
                          '😮',
                          '😎',
                          '❤️',
                          '😡',
                          '🤝'
                        ])
                          InkWell(
                            onTap: () => setState(() {
                              selectedReaction = e;
                              phase = _ChatPhase.off;
                            }),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: C.surface2,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: selectedReaction == e
                                      ? C.magenta
                                      : C.border,
                                  width: selectedReaction == e ? 1.6 : 1,
                                ),
                              ),
                              child:
                                  Text(e, style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Quick chat'),
          _header(),
          const SizedBox(height: 12),
          _board(),
          const SizedBox(height: 12),
          _panel(),
        ],
      ),
    );
  }
}

class _Bubble {
  final String text;
  final bool mine;
  final bool faded;
  const _Bubble(this.text, {required this.mine, this.faded = false});
}
