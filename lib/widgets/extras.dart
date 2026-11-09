import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'painters.dart';

class IconCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const IconCircle(this.icon, {super.key, this.color = C.magenta, this.size = 52});
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: C.surface,
          border: Border.all(color: color, width: 2)),
      child: Icon(icon, color: color, size: size * .45));
}

class AppProgress extends StatelessWidget {
  final double value;
  final Color color;
  const AppProgress(this.value, {super.key, this.color = C.magenta});
  @override
  Widget build(BuildContext context) => ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
          value: value.clamp(0, 1).toDouble(),
          minHeight: 8,
          backgroundColor: C.border,
          color: color));
}

class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  const SmallButton(this.label, {super.key, this.onTap, this.color = C.btn});
  @override
  Widget build(BuildContext context) => SizedBox(
      height: 40,
      child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Text(label.toUpperCase(),
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1))));
}

class SoftAvatar extends StatelessWidget {
  final String letter;
  final Color color;
  final double size;
  const SoftAvatar(this.letter, this.color, {super.key, this.size = 44});
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Text(letter[0],
          style: const TextStyle(color: C.bg, fontWeight: FontWeight.w800)));
}

/// Avatar chosen in Customize (Player, Guard or Doll).
class AvatarFace extends StatelessWidget {
  final double size;
  const AvatarFace({super.key, this.size = 50});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
      valueListenable: equippedAvatar,
      builder: (_, i, __) => i == 1
          ? GuardFace(size: size)
          : i == 2
              ? DollFace(size: size)
              : PlayerFace(size: size));
}

class ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final ValueNotifier<bool> notifier;
  final bool last;
  const ToggleRow(this.icon, this.label, this.notifier,
      {super.key, this.last = false});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (_, v, __) => Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
              border: last
                  ? null
                  : const Border(bottom: BorderSide(color: C.border))),
          child: Row(children: [
            Icon(icon, size: 22),
            const SizedBox(width: 14),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15))),
            Switch(
                value: v,
                onChanged: (x) => notifier.value = x,
                thumbColor: const WidgetStatePropertyAll(Colors.white),
                trackColor: WidgetStateProperty.resolveWith(
                    (s) => s.contains(WidgetState.selected) ? C.teal : C.border2),
                trackOutlineColor:
                    const WidgetStatePropertyAll(Colors.transparent)),
          ])));
}

class CosmeticTile extends StatelessWidget {
  final Cosmetic item;
  final bool selected;
  final bool equipped;
  final VoidCallback onTap;
  const CosmeticTile(
      {super.key,
      required this.item,
      required this.selected,
      required this.equipped,
      required this.onTap});

  Widget _preview() {
    if (item.kind == 'board') {
      return Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
              color: boardColor(item.name),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.border2)),
          child: const Center(child: MarkIcon(isX: true, size: 24)));
    }
    if (item.name == 'Shapes') {
      return Row(mainAxisSize: MainAxisSize.min, children: const [
        ShapeIcon(ShapeKind.circle, size: 26),
        SizedBox(width: 6),
        ShapeIcon(ShapeKind.triangle, size: 26),
      ]);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: const [
      MarkIcon(isX: true, size: 26),
      SizedBox(width: 6),
      MarkIcon(isX: false, size: 26),
    ]);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<Set<String>>(
      valueListenable: owned,
      builder: (_, own, __) {
        final has = own.contains(item.name);
        final sub = equipped
            ? 'Equipped'
            : has
                ? 'Owned'
                : '${item.price} coins';
        return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                    color: C.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: selected ? C.magenta : C.border)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(height: 54, child: Center(child: _preview())),
                  const SizedBox(height: 8),
                  Text(item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(sub,
                      style: TextStyle(
                          fontSize: 12, color: equipped ? C.teal : C.muted)),
                ])));
      });
}

/// 3-column grid of cosmetics (shrink-wrapped, for use inside a scroll view).
class CosmeticGrid extends StatelessWidget {
  final List<Cosmetic> items;
  final String? selected;
  final String equipped;
  final ValueChanged<Cosmetic> onTap;
  const CosmeticGrid(
      {super.key,
      required this.items,
      required this.selected,
      required this.equipped,
      required this.onTap});
  @override
  Widget build(BuildContext context) => GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: .88,
      children: [
        for (final c in items)
          CosmeticTile(
              item: c,
              selected: c.name == selected,
              equipped: c.name == equipped,
              onTap: () => onTap(c)),
      ]);
}
