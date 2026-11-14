import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

/// Ludo-style quick reactions used during an online match.
const matchEmojiPack = [
  '😂',
  '😎',
  '😡',
  '😢',
  '👏',
  '🔥',
  '👍',
  '❤️',
  '😮',
  '🎉',
  '🤔',
  '💪',
];

class MatchEmojiBurst {
  final String emoji;
  final bool fromMe;
  final int id;
  const MatchEmojiBurst({
    required this.emoji,
    required this.fromMe,
    required this.id,
  });
}

/// Floating reaction that pops near a player seat (Ludo-style).
class MatchEmojiBurstOverlay extends StatelessWidget {
  final MatchEmojiBurst burst;
  /// true = left seat (O), false = right seat (X)
  final bool onLeft;

  const MatchEmojiBurstOverlay({
    super.key,
    required this.burst,
    required this.onLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(burst.id),
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 2200),
          curve: Curves.easeOutCubic,
          builder: (_, t, __) {
            // Pop in → hold → fade out.
            final scale = t < 0.18
                ? Curves.easeOutBack.transform(t / 0.18)
                : (t > 0.75
                    ? (1 - ((t - 0.75) / 0.25) * 0.35)
                    : 1.0);
            final opacity = t < 0.08
                ? t / 0.08
                : (t > 0.72 ? (1 - (t - 0.72) / 0.28).clamp(0.0, 1.0) : 1.0);
            final bob = math.sin(t * math.pi * 2) * 6;

            return Align(
              alignment: onLeft
                  ? const Alignment(-0.72, -0.62)
                  : const Alignment(0.72, -0.62),
              child: Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, bob - 12 * t),
                  child: Transform.scale(
                    scale: 0.55 + scale * 0.9,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: C.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: burst.fromMe ? C.magenta : C.teal,
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (burst.fromMe ? C.magenta : C.teal)
                                .withValues(alpha: 0.35),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Text(
                        burst.emoji,
                        style: const TextStyle(fontSize: 42, height: 1),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Bottom-right smiley button + expandable emoji tray (Ludo UX).
class MatchEmojiLauncher extends StatefulWidget {
  final ValueChanged<String> onPick;
  final bool enabled;
  /// Seconds before another emoji can be sent.
  final int cooldownSec;

  const MatchEmojiLauncher({
    super.key,
    required this.onPick,
    this.enabled = true,
    this.cooldownSec = 4,
  });

  @override
  State<MatchEmojiLauncher> createState() => _MatchEmojiLauncherState();
}

class _MatchEmojiLauncherState extends State<MatchEmojiLauncher>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  int _coolLeft = 0;
  Timer? _coolTimer;
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _coolTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _coolTimer?.cancel();
    setState(() => _coolLeft = widget.cooldownSec);
    _coolTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_coolLeft <= 1) {
        t.cancel();
        setState(() => _coolLeft = 0);
      } else {
        setState(() => _coolLeft--);
      }
    });
  }

  void _toggle() {
    if (!widget.enabled) return;
    HapticFeedback.selectionClick();
    setState(() => _open = !_open);
  }

  void _pick(String emoji) {
    if (_coolLeft > 0 || !widget.enabled) return;
    HapticFeedback.lightImpact();
    setState(() => _open = false);
    widget.onPick(emoji);
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    final cooling = _coolLeft > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_open) ...[
          Container(
            width: 236,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: C.border2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick react',
                  style: TextStyle(
                    color: C.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final e in matchEmojiPack)
                      Material(
                        color: C.surface2,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: cooling ? null : () => _pick(e),
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Center(
                              child: Text(e,
                                  style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) {
            final glow = _open ? 0.0 : 4 + _pulse.value * 6;
            return Material(
              color: cooling ? C.surface2 : C.magenta,
              shape: const CircleBorder(),
              elevation: _open ? 0 : 4,
              shadowColor: C.magenta.withValues(alpha: 0.55),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: cooling ? null : _toggle,
                child: Container(
                  width: 54,
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: cooling
                        ? null
                        : [
                            BoxShadow(
                              color: C.magenta.withValues(alpha: 0.35),
                              blurRadius: glow,
                            ),
                          ],
                  ),
                  child: cooling
                      ? Text(
                          '$_coolLeft',
                          style: const TextStyle(
                            color: C.muted,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        )
                      : Icon(
                          _open ? Icons.close_rounded : Icons.emoji_emotions,
                          color: Colors.white,
                          size: 28,
                        ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

bool isMatchEmojiOnly(String text) {
  final t = text.trim();
  if (matchEmojiPack.contains(t)) return true;
  return t.runes.length <= 2 &&
      RegExp(r'^[\u{1F300}-\u{1FAFF}\u{2600}-\u{27BF}]+$', unicode: true)
          .hasMatch(t);
}
