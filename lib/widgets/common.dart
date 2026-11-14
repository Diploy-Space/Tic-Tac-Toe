import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../theme.dart';
import 'painters.dart';
import 'extras.dart';

/// Slides + fades its child in, with a delay of [index] * 80 ms.
class FadeUp extends StatefulWidget {
  final Widget child;
  final int index;
  const FadeUp({super.key, required this.child, this.index = 0});
  @override
  State<FadeUp> createState() => _FadeUpState();
}

class _FadeUpState extends State<FadeUp> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _t = Timer(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _a,
        child: widget.child,
        builder: (_, child) => Opacity(
            opacity: _a.value,
            child: Transform.translate(
                offset: Offset(0, 18 * (1 - _a.value)), child: child)),
      );
}

/// Scale-pop entrance with delay in milliseconds.
class PopIn extends StatefulWidget {
  final Widget child;
  final int delayMs;
  const PopIn({super.key, required this.child, this.delayMs = 0});
  @override
  State<PopIn> createState() => _PopInState();
}

class _PopInState extends State<PopIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  late final Animation<double> _a =
      CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
  Timer? _t;
  @override
  void initState() {
    super.initState();
    _t = Timer(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
      scale: _a, child: FadeTransition(opacity: _c, child: widget.child));
}

class _Floating extends StatefulWidget {
  final Widget child;
  const _Floating({required this.child});
  @override
  State<_Floating> createState() => _FloatingState();
}

class _FloatingState extends State<_Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3500))
    ..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) => Transform.translate(
          offset: Offset(0, -14 * Curves.easeInOut.transform(_c.value)),
          child: child));
}

/// Screen shell: dark gradient + floating doll silhouette in the background.
class AppScaffold extends StatelessWidget {
  final Widget child;
  final bool doll;
  final EdgeInsets padding;
  const AppScaffold(
      {super.key,
      required this.child,
      this.doll = true,
      this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 20)});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(
                center: Alignment(1, -1),
                radius: 1.3,
                colors: [Color(0xFF3A0A24), C.bg],
                stops: [0, .55])),
        child: Stack(children: [
          if (doll)
            const Positioned(
                left: 0,
                right: 0,
                bottom: -30,
                child: IgnorePointer(
                    child: Opacity(
                        opacity: .16,
                        child: Center(
                            child: _Floating(
                                child: DollFace(size: 420)))))),
          SafeArea(child: Padding(padding: padding, child: child)),
        ]),
      ),
    );
  }
}

/// Scrollable column that still lets a Spacer push content to the bottom.
class ScrollFill extends StatelessWidget {
  final Widget child;
  const ScrollFill({super.key, required this.child});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (c, box) => SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: box.maxHeight),
              child: IntrinsicHeight(child: child))));
}

/// Column whose children fade up one after another. Spacer/Expanded pass through.
Widget staggered(List<Widget> items,
    {double gap = 14,
    CrossAxisAlignment cross = CrossAxisAlignment.stretch,
    int start = 0}) {
  final out = <Widget>[];
  var i = start;
  for (final w in items) {
    if (out.isNotEmpty && w is! Spacer && w is! Expanded) {
      out.add(SizedBox(height: gap));
    }
    out.add(w is Spacer || w is Expanded ? w : FadeUp(index: i++, child: w));
  }
  return Column(crossAxisAlignment: cross, children: out);
}

class AppCard extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final EdgeInsets padding;
  const AppCard(
      {super.key,
      required this.child,
      this.borderColor = C.border,
      this.padding = const EdgeInsets.all(16)});
  @override
  Widget build(BuildContext context) => Container(
      padding: padding,
      decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor)),
      child: child);
}

class Tag extends StatelessWidget {
  final String text;
  final Color color;
  const Tag(this.text, {super.key, this.color = C.teal});
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      style: TextStyle(
          fontSize: 11,
          letterSpacing: 3,
          fontWeight: FontWeight.w600,
          color: color));
}

class Heading extends StatelessWidget {
  final String text;
  final double size;
  final TextAlign? align;
  const Heading(this.text, {super.key, this.size = 26, this.align});
  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(),
      textAlign: align,
      style: TextStyle(
          fontSize: size, fontWeight: FontWeight.w800, letterSpacing: 1));
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color fg;
  const PrimaryButton(this.label,
      {super.key, this.onTap, this.color = const Color(0xFFD4156B), this.fg = Colors.white});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool filledMagenta;
  const GhostButton(this.label,
      {super.key, this.onTap, this.filledMagenta = false});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 54,
      child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
              backgroundColor: filledMagenta ? C.btn : C.surface,
              foregroundColor: C.text,
              side: BorderSide(color: filledMagenta ? C.btn : C.border2),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
          child: Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))));
}

class CoinChip extends StatelessWidget {
  final VoidCallback? onTap;
  const CoinChip({super.key, this.onTap});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: AppLocaleService.revision,
      builder: (context, _, __) => ValueListenableBuilder<int>(
          valueListenable: coins,
          builder: (_, v, __) => Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(99),
                  onTap: onTap ??
                      () => Navigator.pushNamed(context, '/wallet'),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: C.border2)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.monetization_on_outlined,
                            size: 18, color: C.coin),
                        const SizedBox(width: 6),
                        Text('$v',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 6),
                        Text(
                          AppLocaleService.currencyCode,
                          style: const TextStyle(
                            color: C.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ])),
                ),
              )));
}

class RoundIconBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String label;
  const RoundIconBox(this.icon, {super.key, this.onTap, required this.label});
  @override
  Widget build(BuildContext context) => Semantics(
      button: true,
      label: label,
      child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: C.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: C.border2)),
              child: Icon(icon, size: 22))));
}

class TopBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const TopBar(this.title, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Row(children: [
        RoundIconBox(Icons.arrow_back_ios_new_rounded,
            label: 'Back', onTap: () => Navigator.maybePop(context)),
        const SizedBox(width: 12),
        Expanded(child: Heading(title, size: 20)),
        if (trailing != null) trailing!,
      ]);
}

class AppField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final bool obscureToggle;
  final TextInputType? type;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  const AppField(
      {super.key,
      required this.icon,
      required this.hint,
      this.obscure = false,
      this.obscureToggle = true,
      this.type,
      this.controller,
      this.textInputAction,
      this.onSubmitted});
  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  late bool _hide = widget.obscure;
  @override
  Widget build(BuildContext context) => Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border2)),
      child: Row(children: [
        Icon(widget.icon, size: 20, color: C.muted),
        const SizedBox(width: 10),
        Expanded(
            child: TextField(
                controller: widget.controller,
                obscureText: _hide,
                keyboardType: widget.type,
                textInputAction: widget.textInputAction,
                onSubmitted: widget.onSubmitted,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: const TextStyle(color: C.muted)))),
        if (widget.obscure && widget.obscureToggle)
          IconButton(
              tooltip: 'Show or hide password',
              onPressed: () => setState(() => _hide = !_hide),
              icon: Icon(
                  _hide
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: C.muted)),
      ]));
}

class SegRow extends StatelessWidget {
  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;
  const SegRow(
      {super.key,
      required this.options,
      required this.selected,
      required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
              child: Semantics(
                  button: true,
                  selected: i == selected,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onChanged(i),
                      child: Container(
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: i == selected ? C.teal : C.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: i == selected ? C.teal : C.border2)),
                          child: Text(options[i],
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: i == selected
                                      ? const Color(0xFF04201F)
                                      : C.text)))))),
        ]
      ]);
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  final bool last;
  const MenuTile(this.icon, this.label,
      {super.key, required this.onTap, this.danger = false, this.last = false});
  @override
  Widget build(BuildContext context) {
    final c = danger ? C.danger : C.text;
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            decoration: BoxDecoration(
                border: last
                    ? null
                    : const Border(bottom: BorderSide(color: C.border))),
            child: Row(children: [
              Icon(icon, size: 22, color: c),
              const SizedBox(width: 14),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15, color: c))),
              Icon(Icons.chevron_right, size: 20, color: c),
            ])));
  }
}

/// Player card with avatar, name, optional coins and a stats row.
class UserCard extends StatelessWidget {
  final bool showCoins;
  final List<MapEntry<String, String>> stats;
  const UserCard({super.key, this.showCoins = true, required this.stats});
  @override
  Widget build(BuildContext context) => AppCard(
      borderColor: C.magenta,
      child: Column(children: [
        Row(children: [
          ValueListenableBuilder<String?>(
              valueListenable: authAvatarUrl,
              builder: (_, url, __) => Container(
                  width: 52,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: C.border2)),
                  child: ProfileAvatar(url: url, size: 50))),
          const SizedBox(width: 12),
          Expanded(
              child: ValueListenableBuilder<String>(
                  valueListenable: authDisplayName,
                  builder: (_, name, __) => Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)))),
          if (showCoins) const CoinChip(),
        ]),
        const SizedBox(height: 12),
        Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: C.border2))),
            child: Row(children: [
              for (final s in stats)
                Expanded(
                    child: Column(children: [
                  Text(s.key, style: const TextStyle(fontSize: 13, color: C.muted)),
                  Text(s.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ])),
            ])),
      ]));
}

class AppBottomNav extends StatelessWidget {
  final int current;
  const AppBottomNav({super.key, required this.current});
  @override
  Widget build(BuildContext context) {
    final items = [
      [Icons.home_outlined, 'Play', '/home'],
      [Icons.leaderboard_outlined, 'Ranks', '/ranks'],
      [Icons.shopping_bag_outlined, 'Shop', '/shop'],
      [Icons.person_outline, 'Profile', '/profile'],
    ];
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.border)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          for (var i = 0; i < items.length; i++)
            InkWell(
                onTap: () {
                  if (i == current) return;
                  Navigator.pushNamed(context, items[i][2] as String);
                },
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(items[i][0] as IconData,
                          color: i == current ? C.pinkText : C.muted),
                      const SizedBox(height: 4),
                      Text(items[i][1] as String,
                          style: TextStyle(
                              fontSize: 12,
                              color: i == current ? C.pinkText : C.muted)),
                    ]))),
        ]));
  }
}

/// Shared dialog shell used for every popup.
Future<T?> showAppDialog<T>(BuildContext context, Widget Function(BuildContext) builder,
    {bool dismissible = true}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: 'Close',
    barrierColor: const Color(0xC7050507),
    transitionDuration: const Duration(milliseconds: 280),
    transitionBuilder: (c, a, _, child) => FadeTransition(
        opacity: a,
        child: ScaleTransition(
            scale: CurvedAnimation(parent: a, curve: Curves.easeOutBack),
            child: child)),
    pageBuilder: (c, _, __) => Center(
        child: Material(
            color: Colors.transparent,
            child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                    decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: C.magenta)),
                    child: builder(c))))),
  );
}

class DialogClose extends StatelessWidget {
  const DialogClose({super.key});
  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.centerRight,
      child: IconButton(
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: C.muted)));
}
