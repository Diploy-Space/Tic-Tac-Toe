import 'package:flutter/material.dart';

/// Opens How to Play as a rounded pink-border dialog (design sheet style).
Future<void> showHowToPlayDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (ctx) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: HowToPlayFlowScreen(),
    ),
  );
}

/// How to play — design sheets 1:1 via provided screenshots.
/// 1/3 Take Turns → 2/3 Three in a Row → 3/3 Bigger Boards.
class HowToPlayFlowScreen extends StatefulWidget {
  const HowToPlayFlowScreen({super.key});

  @override
  State<HowToPlayFlowScreen> createState() => _HowToPlayFlowScreenState();
}

class _HowToPlayFlowScreenState extends State<HowToPlayFlowScreen> {
  final _page = PageController();
  int _index = 0;

  static const _pink = Color(0xFFE03079);
  static const _card = Color(0xFF17171C);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  void _close() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
      return;
    }
    nav.pushNamedAndRemoveUntil('/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    // One continuous rounded pink border around the whole sheet.
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
          maxWidth: 420,
        ),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _pink, width: 1.8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _page,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: [
                    _scroll(_pageAsset('assets/icon/how_to_page1_content.png')),
                    _scroll(_pageAsset('assets/icon/how_to_page2_content.png')),
                    _scroll(_pageAsset('assets/icon/how_to_page3_content.png')),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _dots(),
              const SizedBox(height: 14),
              _cta(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scroll(Widget child) =>
      SingleChildScrollView(physics: const BouncingScrollPhysics(), child: child);

  Widget _pageAsset(String path) => Center(
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
      );

  Widget _dots() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _index ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == _index ? _pink : const Color(0xFF2A2A33),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
        ],
      );

  Widget _cta() {
    final last = _index >= 2;
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _pink.withValues(alpha: 0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FilledButton(
            onPressed: () {
              if (!last) {
                _page.nextPage(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOut,
                );
                return;
              }
              _close();
            },
            style: FilledButton.styleFrom(
              backgroundColor: _pink,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              last ? "LET'S PLAY" : 'NEXT',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        if (!last)
          TextButton(
            onPressed: _close,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFFD0D0D8),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
      ],
    );
  }
}
