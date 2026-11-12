import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 29–31 — How to play carousel.
class HowToPlayFlowScreen extends StatefulWidget {
  const HowToPlayFlowScreen({super.key});

  @override
  State<HowToPlayFlowScreen> createState() => _HowToPlayFlowScreenState();
}

class _HowToPlayFlowScreenState extends State<HowToPlayFlowScreen> {
  final page = PageController();
  int index = 0;

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  Widget _mascot() => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: C.magenta, width: 2),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB4A2), Color(0xFFFF8FAB)],
          ),
        ),
        alignment: Alignment.center,
        child: const Text('🎀', style: TextStyle(fontSize: 22)),
      );

  Widget _dots() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == index ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? C.magenta : C.surface2,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
        ],
      );

  Widget _cell(String? m, {bool glow = false, bool dashed = false}) {
    final color = m == 'X' ? C.magenta : C.teal;
    return Container(
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: dashed
              ? C.magenta
              : glow
                  ? color
                  : C.border,
          width: glow || dashed ? 1.6 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        dashed && m == null ? '+' : (m ?? ''),
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 16,
          color: dashed ? C.magenta : color,
          shadows: glow
              ? [Shadow(color: color.withValues(alpha: 0.7), blurRadius: 8)]
              : null,
        ),
      ),
    );
  }

  Widget _miniBoard(List<String?> marks, {Set<int> glow = const {}}) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          for (var i = 0; i < 9; i++)
            _cell(marks[i], glow: glow.contains(i)),
        ],
      ),
    );
  }

  Widget _page0() => Column(
        children: [
          _mascot(),
          const SizedBox(height: 10),
          const Text('HOW TO PLAY · 1/3',
              style: TextStyle(
                  color: C.magenta,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 11)),
          const SizedBox(height: 8),
          const Text('TAKE TURNS',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: GridView.count(
                    crossAxisCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _cell('X'),
                      _cell('O'),
                      _cell(null),
                      _cell(null),
                      _cell(null, dashed: true),
                      _cell('O'),
                      _cell('X'),
                      _cell(null),
                      _cell('X'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'You: X  ',
                      style: TextStyle(
                          color: C.magenta, fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: 'Rival: O',
                      style: TextStyle(
                          color: C.teal, fontWeight: FontWeight.w700)),
                ])),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'You and your rival place one mark each turn. Tap an empty square to make your move.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.4),
          ),
        ],
      );

  Widget _page1() => Column(
        children: [
          _mascot(),
          const SizedBox(height: 10),
          const Text('HOW TO PLAY · 2/3',
              style: TextStyle(
                  color: C.magenta,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 11)),
          const SizedBox(height: 8),
          const Text('THREE IN A ROW',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 16),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(children: [
                    _miniBoard(
                      ['O', 'O', 'O', null, 'X', null, 'X', null, null],
                      glow: {0, 1, 2},
                    ),
                    const SizedBox(height: 6),
                    const Text('Row', style: TextStyle(color: C.muted, fontSize: 12)),
                  ]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(children: [
                    _miniBoard(
                      ['X', 'O', null, null, 'O', 'X', null, 'O', null],
                      glow: {1, 4, 7},
                    ),
                    const SizedBox(height: 6),
                    const Text('Column',
                        style: TextStyle(color: C.muted, fontSize: 12)),
                  ]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(children: [
                    _miniBoard(
                      ['O', 'X', null, null, 'O', 'X', null, null, 'O'],
                      glow: {0, 4, 8},
                    ),
                    const SizedBox(height: 6),
                    const Text('Diagonal',
                        style: TextStyle(color: C.muted, fontSize: 12)),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Line up three of your marks in a row, in a column or on a diagonal before your rival does.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.4),
          ),
        ],
      );

  Widget _page2() => Column(
        children: [
          _mascot(),
          const SizedBox(height: 10),
          const Text('HOW TO PLAY · 3/3',
              style: TextStyle(
                  color: C.magenta,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  fontSize: 11)),
          const SizedBox(height: 8),
          const Text('BIGGER BOARDS',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: GridView.count(
                    crossAxisCount: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    children: [
                      for (var i = 0; i < 16; i++)
                        _cell(
                          i >= 8 && i <= 11
                              ? 'O'
                              : i == 0 || i == 5
                                  ? 'X'
                                  : i == 3 || i == 13
                                      ? 'X'
                                      : null,
                          glow: i >= 8 && i <= 11,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Bigger boards need four in a row',
                    style: TextStyle(color: C.muted, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'On larger boards you need four in a row to win. If the board fills up with no line, it is a draw.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.4),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          Expanded(
            child: PdfModalCard(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: page,
                      onPageChanged: (i) => setState(() => index = i),
                      children: [
                        SingleChildScrollView(child: _page0()),
                        SingleChildScrollView(child: _page1()),
                        SingleChildScrollView(child: _page2()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _dots(),
                  const SizedBox(height: 14),
                  if (index < 2)
                    PdfPinkButton('NEXT', onTap: () {
                      page.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeOut);
                    })
                  else
                    PdfPinkButton("LET'S PLAY", onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (r) => false);
                    }),
                  if (index < 2)
                    TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (r) => false),
                      child: const Text('Skip',
                          style: TextStyle(color: C.muted)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
