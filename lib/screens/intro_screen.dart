import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

/// First-run onboarding: three swipeable slides.
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _pc = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _done() {
    introSeen.value = true;
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _slide(Widget art, String title, String text) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        art,
        const SizedBox(height: 22),
        Heading(title, size: 30, align: TextAlign.center),
        const SizedBox(height: 14),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: C.muted, fontSize: 15, height: 1.5))),
      ]);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Tag('${_page + 1} / 3'),
          TextButton(
              onPressed: _done,
              child: Text(context.l10n.skip,
                  style: const TextStyle(color: C.muted))),
        ]),
        Expanded(
            child: PageView(
                controller: _pc,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
              _slide(const DollFace(size: 150), context.l10n.introTitle1,
                  context.l10n.introBody1),
              _slide(
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShapeIcon(ShapeKind.circle, size: 52),
                        SizedBox(width: 14),
                        ShapeIcon(ShapeKind.triangle, size: 52),
                        SizedBox(width: 14),
                        ShapeIcon(ShapeKind.square, size: 52),
                      ]),
                  context.l10n.introTitle2,
                  context.l10n.introBody2),
              _slide(const PlayerFace(size: 150), context.l10n.introTitle3,
                  context.l10n.introBody3),
            ])),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < 3; i++)
            AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _page ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                    color: i == _page ? C.magenta : C.border2,
                    borderRadius: BorderRadius.circular(4))),
        ]),
        const SizedBox(height: 18),
        SizedBox(
            width: double.infinity,
            child: PrimaryButton(
                _page == 2 ? context.l10n.getStarted : context.l10n.next,
                onTap: () => _page == 2
                    ? _done()
                    : _pc.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut))),
      ]),
    );
  }
}
