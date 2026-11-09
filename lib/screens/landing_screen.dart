import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

/// Animated splash / landing screen.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
    ..repeat(reverse: true);
  late final AnimationController _bar = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2600))
    ..repeat();
  @override
  void dispose() {
    _glow.dispose();
    _bar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ScrollFill(
        child: Column(children: [
          const SizedBox(height: 70),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            PopIn(delayMs: 200, child: ShapeIcon(ShapeKind.circle, size: 48)),
            SizedBox(width: 14),
            PopIn(delayMs: 500, child: ShapeIcon(ShapeKind.triangle, size: 48)),
            SizedBox(width: 14),
            PopIn(delayMs: 800, child: ShapeIcon(ShapeKind.square, size: 48)),
          ]),
          const SizedBox(height: 22),
          GestureDetector(
            // Hidden: long-press the title to preview the app logo sheet.
            onLongPress: () => Navigator.pushNamed(context, '/logo'),
            child: AnimatedBuilder(
                animation: _glow,
                builder: (_, __) => Text('TIC\nTAC\nTOE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 46,
                        height: 1.02,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1 + 4 * _glow.value,
                        shadows: [
                          Shadow(
                              color: C.magenta.withAlpha((60 + 150 * _glow.value).round()),
                              blurRadius: 14 + 12 * _glow.value)
                        ]))),
          ),
          const SizedBox(height: 8),
          const Tag('The deadliest little game'),
          const SizedBox(height: 22),
          FadeUp(
              index: 4,
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
                GuardFace(size: 84),
                SizedBox(width: 4),
                DollFace(size: 96),
                SizedBox(width: 4),
                PlayerFace(size: 84),
              ])),
          const Spacer(),
          AnimatedBuilder(
              animation: _bar,
              builder: (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                      value: Curves.easeInOut.transform(_bar.value),
                      minHeight: 4,
                      backgroundColor: C.border,
                      color: C.magenta))),
          const SizedBox(height: 14),
          FadeUp(
              index: 6,
              child: SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                      AuthService.isSignedIn
                          ? 'Continue playing'
                          : 'Sign in with email',
                      onTap: () {
                        if (AuthService.isSignedIn) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (r) => false);
                        } else {
                          Navigator.pushNamed(context, '/signin');
                        }
                      }))),
          const SizedBox(height: 12),
          FadeUp(
              index: 7,
              child: SizedBox(
                  width: double.infinity,
                  child: GhostButton('Continue with Google', onTap: () async {
                    try {
                      final ok = await AuthService.signInWithGoogle();
                      if (!context.mounted) return;
                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Could not open Google sign-in')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Complete Google sign-in, then return')));
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(AuthService.messageFromError(e))));
                    }
                  }))),
          const SizedBox(height: 6),
          TextButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (r) => false),
              child: const Text('Play as guest',
                  style: TextStyle(color: C.muted))),
        ]),
      ),
    );
  }
}
