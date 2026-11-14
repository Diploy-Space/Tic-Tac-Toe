import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/app_locale_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Shown after a valid referral code credits +50 welcome bonus.
class ReferralSuccessScreen extends StatelessWidget {
  const ReferralSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    var code = '—';
    var bonus = 50;
    var balance = 50;
    if (args is Map) {
      code = '${args['code'] ?? code}';
      bonus = (args['bonus'] as num?)?.toInt() ?? bonus;
      balance = (args['balance'] as num?)?.toInt() ?? balance;
    }

    return AppScaffold(
      doll: false,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 2),
          SizedBox(
            height: 160,
            child: LayoutBuilder(
              builder: (context, box) {
                final w = box.maxWidth;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (final p in _particles)
                      Positioned(
                        left: w * p.xf - p.size / 2,
                        top: 160 * p.yf - p.size / 2,
                        child: Opacity(
                          opacity: p.opacity,
                          child: Transform.rotate(
                            angle: p.angle,
                            child: _MiniCoin(size: p.size),
                          ),
                        ),
                      ),
                    const _HeroCoin(),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'WELCOME BONUS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: C.teal,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '+$bonus ',
                  style: const TextStyle(
                    color: Color(0xFFFFC24D),
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                    height: 1.1,
                  ),
                ),
                const TextSpan(
                  text: 'coins',
                  style: TextStyle(
                    color: Color(0xFFE8D5A8),
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your referral code worked. The coins are in your wallet and ready to use.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFD0D0D8),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.teal, width: 1.2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Referral code',
                      style: TextStyle(color: C.muted, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      code,
                      style: const TextStyle(
                        color: C.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Wallet balance',
                      style: TextStyle(color: C.muted, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.monetization_on,
                      color: C.coin,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$balance',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (r) => false,
              ),
              style: FilledButton.styleFrom(
                backgroundColor: C.magenta,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'START PLAYING',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  final double xf;
  final double yf;
  final double size;
  final double opacity;
  final double angle;
  const _Particle(this.xf, this.yf, this.size, this.opacity, this.angle);
}

const _particles = [
  _Particle(0.12, 0.18, 18, 0.35, -0.4),
  _Particle(0.86, 0.12, 14, 0.28, 0.5),
  _Particle(0.16, 0.72, 12, 0.22, 0.2),
  _Particle(0.84, 0.68, 16, 0.3, -0.7),
  _Particle(0.30, 0.06, 10, 0.2, 0.1),
  _Particle(0.70, 0.82, 11, 0.25, -0.3),
];

class _HeroCoin extends StatelessWidget {
  const _HeroCoin();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 108,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFB300), Color(0xFFFF8F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFFD54F), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB300).withValues(alpha: 0.45),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        AppLocaleService.currencySymbol,
        style: const TextStyle(
          color: Color(0xFF4E342E),
          fontWeight: FontWeight.w900,
          fontSize: 48,
          height: 1,
        ),
      ),
    );
  }
}

class _MiniCoin extends StatelessWidget {
  final double size;
  const _MiniCoin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        AppLocaleService.currencySymbol,
        style: TextStyle(
          color: const Color(0xFF5D4037),
          fontWeight: FontWeight.w900,
          fontSize: math.max(8, size * 0.45),
          height: 1,
        ),
      ),
    );
  }
}
