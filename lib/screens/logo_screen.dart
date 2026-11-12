import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../widgets/pdf_ui.dart';

/// PDF pages 32–33 — Splash logo + logo kit.
class LogoScreen extends StatelessWidget {
  const LogoScreen({super.key});

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 8),
        child: Text(
          t.toUpperCase(),
          style: const TextStyle(
            color: C.magenta,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            fontSize: 11,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Logo kit'),
          _label('App icon'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppLogoMark(size: 96),
              SizedBox(width: 16),
              AppLogoMark(size: 64),
              SizedBox(width: 16),
              AppLogoMark(size: 40),
            ],
          ),
          _label('Horizontal lockup'),
          AppCard(
            child: const Row(
              children: [
                AppLogoMark(size: 56),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TIC TAC',
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            letterSpacing: 1)),
                    Text('0 4 2',
                        style: TextStyle(
                            color: C.teal,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4)),
                  ],
                ),
              ],
            ),
          ),
          _label('On light background'),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                AppLogoMark(size: 48),
                SizedBox(width: 12),
                Text('TIC TAC',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20)),
              ],
            ),
          ),
          _label('Symbols'),
          const AppCard(
            child: Text(
              'Circle, triangle and square on the winning diagonal. Pink and teal only, with a gold line for the win.',
              style: TextStyle(color: C.muted, height: 1.4),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShapeIcon(ShapeKind.circle, size: 34),
              SizedBox(width: 12),
              ShapeIcon(ShapeKind.triangle, size: 34),
              SizedBox(width: 12),
              ShapeIcon(ShapeKind.square, size: 34),
            ],
          ),
          PdfPinkButton('Preview splash', onTap: () {
            Navigator.pushNamed(context, '/logo-splash');
          }),
        ], gap: 10),
      ),
    );
  }
}

/// PDF page 32 — Splash / loading brand screen.
class LogoSplashScreen extends StatelessWidget {
  const LogoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: C.magenta.withValues(alpha: 0.45),
                  blurRadius: 28,
                ),
              ],
            ),
            child: const AppLogoMark(size: 160),
          ),
          const SizedBox(height: 24),
          const Text('TIC TAC',
              style: TextStyle(
                  fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const Text('0 4 2',
              style: TextStyle(
                  color: C.teal,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 6)),
          const SizedBox(height: 10),
          const Text(
            'THREE IN A ROW. ONE SURVIVOR.',
            style: TextStyle(
              color: C.muted,
              letterSpacing: 1.5,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: const LinearProgressIndicator(
              value: 0.55,
              minHeight: 8,
              backgroundColor: C.surface2,
              color: C.magenta,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Loading...', style: TextStyle(color: C.muted)),
          const SizedBox(height: 24),
          PdfGhostButton('Back', onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
