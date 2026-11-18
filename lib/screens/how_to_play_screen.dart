import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

/// How to play: 3 swipeable pages (Take turns → Three in a row → Bigger
/// boards). Opened from the "?" on the home screen.
class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});
  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final _pc = PageController();
  int _i = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  /// Back to wherever it was opened from (home), or home if nothing below.
  void _finish() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }

  void _next() {
    if (_i == 2) return _finish();
    _pc.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1F),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: C.magenta, width: 2),
              ),
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 18),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const DollFace(size: 60),
                const SizedBox(height: 10),
                Text(context.l10n.howToPlayStep('${_i + 1}'),
                    style: _ts(14, w: FontWeight.w700, c: C.magenta, ls: 5)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 470,
                  child: PageView(
                    controller: _pc,
                    onPageChanged: (v) => setState(() => _i = v),
                    children: [
                      _Page(
                        title: context.l10n.takeTurnsCaps,
                        body: context.l10n.takeTurnsBody,
                        child: const _TurnsBoard(),
                      ),
                      _Page(
                        title: context.l10n.threeInRowCaps,
                        body: context.l10n.threeInRowBody,
                        child: const _LinesBoard(),
                      ),
                      _Page(
                        title: context.l10n.biggerBoardsCaps,
                        body: context.l10n.biggerBoardsBody,
                        child: const _BigBoard(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var d = 0; d < 3; d++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: d == _i ? 44 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: d == _i ? C.magenta : const Color(0xFF3A3A44),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                ]),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                      _i == 2 ? context.l10n.letsPlay : context.l10n.next,
                      onTap: _next),
                ),
                SizedBox(
                  height: 44,
                  child: _i == 2
                      ? null
                      : TextButton(
                          onPressed: _finish,
                          child: Text(context.l10n.skip,
                              style: _ts(17, c: C.muted))),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _ts(double size, {FontWeight? w, Color? c, double? ls, double? h}) =>
    TextStyle(
        fontSize: size,
        fontWeight: w,
        color: c ?? C.text,
        letterSpacing: ls,
        height: h);

class _Page extends StatelessWidget {
  final String title, body;
  final Widget child;
  const _Page({required this.title, required this.body, required this.child});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      // Small phones / large text: scroll instead of overflowing.
      physics: const ClampingScrollPhysics(),
      child: Column(children: [
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title, style: _ts(34, w: FontWeight.w800))),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F14),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: C.border),
          ),
          child: child,
        ),
        const SizedBox(height: 18),
        Text(body,
            textAlign: TextAlign.center, style: _ts(18, c: C.muted, h: 1.4)),
      ]));
}

/// Small read-only board. Cells: 'X', 'O', '' (empty) or '+' (tap here).
class _BoardGrid extends StatelessWidget {
  final List<String> cells;
  final int n;
  final double cell;
  final double gap;
  final Set<int> highlight;
  const _BoardGrid({
    required this.cells,
    required this.n,
    required this.cell,
    required this.gap,
    this.highlight = const {},
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < n; r++)
            Padding(
              padding: EdgeInsets.only(top: r == 0 ? 0 : gap),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                for (var c = 0; c < n; c++)
                  Padding(
                    padding: EdgeInsets.only(left: c == 0 ? 0 : gap),
                    child: _cell(r * n + c),
                  ),
              ]),
            ),
        ],
      );

  Widget _cell(int i) {
    final v = cells[i];
    final hi = highlight.contains(i);
    final tap = v == '+';
    final color = v == 'X' ? C.magenta : C.teal;
    return Container(
      width: cell,
      height: cell,
      decoration: BoxDecoration(
        color: hi ? color.withValues(alpha: .16) : C.surface,
        borderRadius: BorderRadius.circular(cell * .22),
        border: Border.all(
          color: hi
              ? color
              : tap
                  ? C.magenta.withValues(alpha: .8)
                  : C.border2,
          width: hi || tap ? 1.6 : 1,
        ),
        boxShadow: hi
            ? [BoxShadow(color: color.withValues(alpha: .35), blurRadius: 10)]
            : null,
      ),
      alignment: Alignment.center,
      child: switch (v) {
        'X' || 'O' => MarkIcon(isX: v == 'X', size: cell * .55),
        '+' => Icon(Icons.touch_app_rounded, size: cell * .5, color: C.magenta),
        _ => null,
      },
    );
  }
}

class _TurnsBoard extends StatelessWidget {
  const _TurnsBoard();
  @override
  Widget build(BuildContext context) => Column(children: [
        const _BoardGrid(
            cells: ['X', 'O', '', '', '+', 'O', 'X', '', 'X'],
            n: 3,
            cell: 56,
            gap: 8),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(context.l10n.youX, style: _ts(15, c: C.magenta)),
          const SizedBox(width: 26),
          Text(context.l10n.rivalO, style: _ts(15, c: C.teal)),
        ]),
      ]);
}

class _LinesBoard extends StatelessWidget {
  const _LinesBoard();
  Widget _b(List<String> c, Set<int> h) =>
      _BoardGrid(cells: c, n: 3, cell: 32, gap: 4, highlight: h);
  @override
  Widget build(BuildContext context) => Column(children: [
        // Three boards side by side shrink to fit narrow phones.
        FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _b(['O', 'O', 'O', '', 'X', '', 'X', '', 'X'], {0, 1, 2}),
              const SizedBox(width: 14),
              _b(['O', 'X', '', 'O', 'X', '', 'O', '', 'X'], {0, 3, 6}),
              const SizedBox(width: 14),
              _b(['O', 'X', '', 'X', 'O', '', '', '', 'O'], {0, 4, 8}),
            ])),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text(context.l10n.row, style: _ts(15, c: C.muted)),
          Text(context.l10n.column, style: _ts(15, c: C.muted)),
          Text(context.l10n.diagonal, style: _ts(15, c: C.muted)),
        ]),
      ]);
}

class _BigBoard extends StatelessWidget {
  const _BigBoard();
  @override
  Widget build(BuildContext context) => Column(children: [
        const _BoardGrid(
          cells: [
            'X', 'O', '', '', //
            'O', 'X', 'O', '',
            'O', 'O', 'O', 'O',
            'X', 'O', 'X', 'O',
          ],
          n: 4,
          cell: 46,
          gap: 6,
          highlight: {8, 9, 10, 11},
        ),
        const SizedBox(height: 10),
        Text(context.l10n.biggerNeedFour, style: _ts(15, c: C.muted)),
      ]);
}
