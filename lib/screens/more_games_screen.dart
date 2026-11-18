import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

class MoreGamesScreen extends StatelessWidget {
  const MoreGamesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const games = [
      ['Hextris', ShapeKind.triangle],
      ['Clumsy Bird', ShapeKind.circle],
      ['Pacman', ShapeKind.square],
    ];
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(context.l10n.moreGames),
          for (final g in games)
            AppCard(
                child: Row(children: [
              Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                      color: C.bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: C.border2)),
                  child: Center(child: ShapeIcon(g[1] as ShapeKind))),
              const SizedBox(width: 14),
              Expanded(
                  child: Text(g[0] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 17))),
              SizedBox(
                  width: 100,
                  height: 42,
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: C.btn,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                              // TODO: open the real store link with url_launcher.
                              SnackBar(
                                  content: Text(
                                      context.l10n.gameComingSoon('${g[0]}')))),
                      child: Text(context.l10n.playCaps,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, letterSpacing: 1)))),
            ])),
        ]),
      ),
    );
  }
}
