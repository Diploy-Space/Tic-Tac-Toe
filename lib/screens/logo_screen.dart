import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// Logo preview sheet (open it by long-pressing the title on the landing screen).
class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('App logo'),
          const SizedBox(height: 10),
          const Center(child: PopIn(child: AppLogoMark(size: 220))),
          const SizedBox(height: 10),
          const Center(child: Tag('App icon sizes')),
          const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppLogoMark(size: 112),
                SizedBox(width: 20),
                AppLogoMark(size: 72),
                SizedBox(width: 20),
                AppLogoMark(size: 48),
              ]),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ShapeIcon(ShapeKind.circle, size: 34),
            SizedBox(width: 10),
            ShapeIcon(ShapeKind.triangle, size: 34),
            SizedBox(width: 10),
            ShapeIcon(ShapeKind.square, size: 34),
          ]),
          const Center(
              child: Text('TIC TAC TOE',
                  style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 2))),
          const Center(child: Tag('Calculate every move', color: C.teal)),
        ], gap: 18),
      ),
    );
  }
}
