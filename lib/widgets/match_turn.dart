import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';
import 'painters.dart';
import '../l10n/app_localizations.dart';

/// Theme colour for a mark: O = teal, X = pink.
Color markColor(String mark) => mark == 'O' ? C.teal : C.magenta;

/// Repeating 0..1 driver shared by the turn widgets below.
class _Loop extends StatefulWidget {
  final Duration period;
  final bool running;
  final Widget Function(BuildContext, double t) builder;
  const _Loop(
      {required this.period, required this.builder, this.running = true});
  @override
  State<_Loop> createState() => _LoopState();
}

class _LoopState extends State<_Loop> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.period);

  @override
  void initState() {
    super.initState();
    if (widget.running) _c.repeat();
  }

  @override
  void didUpdateWidget(covariant _Loop old) {
    super.didUpdateWidget(old);
    if (old.period != widget.period) _c.duration = widget.period;
    if (widget.running && !_c.isAnimating) {
      _c.repeat();
    } else if (!widget.running && _c.isAnimating) {
      _c.stop();
      _c.value = 0;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _c, builder: (ctx, _) => widget.builder(ctx, _c.value));
}

/// 0 → 1 → 0 ease over one loop, with an optional phase offset (0..1).
double _wave(double t, [double phase = 0]) {
  final p = (t - phase) % 1.0;
  return (1 - math.cos(p * 2 * math.pi)) / 2;
}

/// Top status pill: "Your move · 0:19", bordered and glowing in the
/// active player's colour. Pulses faster when [urgent].
class TurnStatusPill extends StatelessWidget {
  final String text;
  final Color color;
  final bool urgent;
  const TurnStatusPill(
      {super.key,
      required this.text,
      required this.color,
      this.urgent = false});

  @override
  Widget build(BuildContext context) => _Loop(
        period: Duration(milliseconds: urgent ? 600 : 1800),
        builder: (_, t) {
          final w = _wave(t);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Color.lerp(C.surface, color, urgent ? .18 * w : 0),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: color, width: 1.5),
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: .25 + .25 * w),
                    blurRadius: 10 + 8 * w),
              ],
            ),
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          );
        },
      );
}

/// Shrinking countdown bar in the active player's colour.
class TurnTimerBar extends StatelessWidget {
  /// Remaining fraction, 1 → 0.
  final double value;
  final Color color;
  final bool urgent;
  const TurnTimerBar(
      {super.key,
      required this.value,
      required this.color,
      this.urgent = false});

  @override
  Widget build(BuildContext context) => _Loop(
        period: const Duration(milliseconds: 500),
        running: urgent,
        builder: (_, t) {
          final flicker = urgent ? .55 + .45 * (1 - _wave(t)) : 1.0;
          return Container(
            height: 8,
            decoration: BoxDecoration(
                color: C.border, borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: flicker),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: color.withValues(alpha: .8 * flicker),
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
          );
        },
      );
}

/// Player seat card. Active → glowing ring + gentle breathe + "YOUR TURN" /
/// "THEIR TURN" label. Inactive → dimmed to 50%.
class TurnPlayerCard extends StatelessWidget {
  final String mark;
  final String tag;
  final String name;
  final bool active;
  final bool isYou;
  final Widget? avatar;

  /// Optional tap (e.g. open the opponent popover) and anchor for it.
  final VoidCallback? onTap;
  final LayerLink? anchor;

  /// Replaces "YOUR TURN" / "THEIR TURN" under an active card (e.g. "WINNER").
  final String? label;
  const TurnPlayerCard({
    super.key,
    required this.mark,
    required this.tag,
    required this.name,
    required this.active,
    required this.isYou,
    this.avatar,
    this.onTap,
    this.anchor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = markColor(mark);
    Widget card = _Loop(
      period: const Duration(milliseconds: 1400),
      running: active,
      builder: (_, t) {
        final w = active ? _wave(t) : 0.0;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: active ? 1 : .5,
          child: Transform.scale(
            scale: 1 + .025 * w,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: active ? color : C.border, width: active ? 2 : 1),
                boxShadow: active
                    ? [
                        BoxShadow(
                            color: color.withValues(alpha: .35 + .5 * w),
                            blurRadius: 10 + 20 * w),
                      ]
                    : null,
              ),
              child: Row(children: [
                avatar ??
                    Text(mark,
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: color,
                            shadows: [Shadow(color: color, blurRadius: 10)])),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tag(tag, color: color),
                        Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ]),
                ),
              ]),
            ),
          ),
        );
      },
    );
    if (onTap != null) {
      card = GestureDetector(
          behavior: HitTestBehavior.opaque, onTap: onTap, child: card);
    }
    if (anchor != null) {
      card = CompositedTransformTarget(link: anchor!, child: card);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      card,
      SizedBox(
        height: 26,
        child: active
            ? Center(
                child: _Loop(
                  period: const Duration(milliseconds: 1000),
                  builder: (_, t) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Opacity(
                        opacity: .25 + .75 * _wave(t),
                        child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                          label ??
                              (isYou
                                  ? context.l10n.yourTurnCaps
                                  : context.l10n.theirTurnCaps),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: color)),
                    ]),
                  ),
                ),
              )
            : null,
      ),
    ]);
  }
}

/// One board square.
/// - [hintColor] set → empty square pulses in that colour (staggered by
///   [index]) to invite a tap.
/// - [dim] → empty square fades (opponent is moving).
/// - [ghostMark] → a faint mark pulses here while the opponent "thinks".
class TurnBoardCell extends StatelessWidget {
  final int index;
  final String? value;
  final Color base;
  final Color? hintColor;
  final bool dim;
  final String? ghostMark;
  final VoidCallback? onTap;
  final Object? markKey;

  /// Part of the winning line: glows and pulses in this colour.
  final Color? winColor;

  /// Game over and not part of the winning line: fades back.
  final bool faded;
  const TurnBoardCell({
    super.key,
    required this.index,
    required this.value,
    required this.base,
    this.hintColor,
    this.dim = false,
    this.ghostMark,
    this.onTap,
    this.markKey,
    this.winColor,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final v = value;
    Widget mark(String m) => Center(
        child: FractionallySizedBox(
            widthFactor: .55,
            heightFactor: .55,
            child: FittedBox(child: MarkIcon(isX: m == 'X', size: 44))));

    final hinting = v == null && hintColor != null;
    final ghosting = v == null && ghostMark != null;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: _Loop(
          period: const Duration(milliseconds: 1600),
          running: hinting || ghosting || winColor != null,
          builder: (_, t) {
            final w = hinting ? _wave(t, (index % 4) * .18 / 1.6) : 0.0;
            final hc = hintColor ?? C.border;
            final g = ghosting ? _wave(t) : 0.0;
            final wc = winColor;
            final wp = wc != null ? _wave(t) : 0.0;
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 350),
              opacity: faded
                  ? .35
                  : v == null && dim && !ghosting
                      ? .6
                      : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: wc != null
                      ? Color.lerp(base, wc, .18 + .14 * wp)
                      : Color.lerp(base, hc, .16 * w),
                  borderRadius: BorderRadius.circular(16),
                  border: wc != null
                      ? Border.all(color: wc, width: 2.5)
                      : Border.all(color: Color.lerp(C.border, hc, w)!),
                  boxShadow: wc != null
                      ? [
                          BoxShadow(
                              color: wc.withValues(alpha: .35 + .3 * wp),
                              blurRadius: 10 + 12 * wp),
                        ]
                      : null,
                ),
                child: v != null
                    ? TweenAnimationBuilder<double>(
                        key: ValueKey(markKey ?? '$index$v'),
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        builder: (_, s, child) => Transform.scale(
                            scale: s * (1 + .1 * wp), child: child),
                        child: mark(v))
                    : ghosting
                        ? Opacity(
                            opacity: .55 * g,
                            child: Transform.scale(
                                scale: .6 + .4 * g, child: mark(ghostMark!)))
                        : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Caption under the board: "Tap an empty square" or "<name> is thinking •••".
class TurnCaption extends StatelessWidget {
  final bool myTurn;
  final String opponentName;
  final Color color;
  final String? message;
  const TurnCaption({
    super.key,
    required this.myTurn,
    required this.opponentName,
    required this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return Text(message!,
          style: const TextStyle(color: C.muted, fontSize: 15));
    }
    if (myTurn) {
      return Text(context.l10n.tapEmptySquare,
          style: TextStyle(
              color: color, fontSize: 15, fontWeight: FontWeight.w600));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Flexible(
        child: Text(context.l10n.isThinking(opponentName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: C.muted, fontSize: 15)),
      ),
      const SizedBox(width: 8),
      _Loop(
        period: const Duration(milliseconds: 1200),
        builder: (_, t) => Row(mainAxisSize: MainAxisSize.min, children: [
          for (var i = 0; i < 3; i++)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: color.withValues(
                    alpha: .25 + .75 * _dot((t - i * .2 / 1.2) % 1.0)),
                shape: BoxShape.circle,
              ),
            ),
        ]),
      ),
    ]);
  }

  // Matches CSS `dots`: dim at 0/80/100%, bright at 40%.
  static double _dot(double p) {
    if (p < .4) return p / .4;
    if (p < .8) return 1 - (p - .4) / .4;
    return 0;
  }
}

/// Brief "Time's up" flash shown when the turn timer expires.
class TimeoutFlash extends StatelessWidget {
  final Color color;
  final String text;
  const TimeoutFlash({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        builder: (_, s, child) => Opacity(
            opacity: s.clamp(0.0, 1.0),
            child: Transform.scale(scale: .8 + .2 * s, child: child)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color, width: 1.5),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: .55), blurRadius: 24)
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.timer_off_rounded, color: color),
            const SizedBox(width: 10),
            Flexible(
              child: Text(text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      );
}
