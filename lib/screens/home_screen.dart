import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ScrollFill(
        child: staggered([
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
                    builder: (_, name, __) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Tag('Player 042'),
                              Text(name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ]))),
            IconButton(
                tooltip: 'How to play',
                onPressed: () => showHowToDialog(context),
                icon: const Icon(Icons.help_outline, color: C.muted)),
            const CoinChip(),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _Quick(Icons.card_giftcard, 'Daily', '/daily', dot: true),
            _Quick(Icons.track_changes, 'Missions', '/missions'),
            _Quick(Icons.shopping_bag_outlined, 'Shop', '/shop'),
            _Quick(Icons.emoji_events_outlined, 'Events', '/events'),
          ]),
          const Heading('Pick your game'),
          _ModeCard(
              shape: ShapeKind.circle,
              title: 'Play vs The Doll',
              subtitle: 'Offline, smart opponent',
              number: '01',
              onTap: () => startVsDoll(context)),
          _ModeCard(
              shape: ShapeKind.triangle,
              title: 'Random match',
              subtitle: 'Quick match vs AI',
              number: '02',
              onTap: () => startRandom(context)),
          _ModeCard(
              shape: ShapeKind.square,
              title: 'Online match',
              subtitle: 'Find · private room · join code',
              number: '03',
              onTap: () => startOnlineMatch(context)),
          _ModeCard(
              shape: ShapeKind.circle,
              title: 'Pass & Play',
              subtitle: 'Two players, one phone',
              number: '04',
              onTap: () => startPassAndPlay(context)),
          const Spacer(),
          const AppBottomNav(current: 0),
        ]),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final ShapeKind shape;
  final String title, subtitle, number;
  final VoidCallback onTap;
  const _ModeCard(
      {required this.shape,
      required this.title,
      required this.subtitle,
      required this.number,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Semantics(
      button: true,
      label: title,
      child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(children: [
                Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: C.bg,
                        shape: BoxShape.circle,
                        border: Border.all(color: C.magenta)),
                    child: Center(child: ShapeIcon(shape))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Tag('Mode $number', color: C.magenta),
                  const SizedBox(height: 2),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18)),
                  Text(subtitle,
                      style: const TextStyle(color: C.muted, fontSize: 13)),
                ])),
                const Icon(Icons.chevron_right, color: C.muted),
              ]))));
}

class _Quick extends StatelessWidget {
  final IconData icon;
  final String label, route;
  final bool dot;
  const _Quick(this.icon, this.label, this.route, {this.dot = false});
  @override
  Widget build(BuildContext context) => Semantics(
      button: true,
      label: label,
      child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, route),
          child: SizedBox(
              width: 76,
              child: Column(children: [
                Stack(children: [
                  Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                          color: C.bg,
                          shape: BoxShape.circle,
                          border: Border.all(color: dot ? C.magenta : C.border2)),
                      child: Icon(icon, size: 22)),
                  if (dot)
                    Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                                color: C.magenta, shape: BoxShape.circle))),
                ]),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(color: C.muted, fontSize: 13)),
              ]))));
}
