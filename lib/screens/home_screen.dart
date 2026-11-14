import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models.dart';
import '../models/moderation_models.dart';
import '../services/app_locale_service.dart';
import '../services/auth_service.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../widgets/extras.dart';
import '../widgets/offline_banner.dart';
import 'dialogs.dart';
import 'how_to_play_flow_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _enforceModeration());
  }

  Future<void> _enforceModeration() async {
    if (!AuthService.isSignedIn || !mounted) return;
    final s = ModerationService.status.value ??
        await ModerationService.refresh();
    if (!mounted || s == null) return;
    if (s.accountStatus == AccountStatus.suspended) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account-suspended', (r) => false);
    } else if (s.accountStatus == AccountStatus.underReview) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/appeal-under-review', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppLocaleService.revision,
      builder: (context, _, __) => AppScaffold(
        child: ScrollFill(
          child: staggered([
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: ValueListenableBuilder<String?>(
                    valueListenable: authAvatarUrl,
                    builder: (_, url, __) => Container(
                        width: 52,
                        height: 52,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: C.border2)),
                        child: ProfileAvatar(url: url, size: 50))),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                behavior: HitTestBehavior.opaque,
                child: ValueListenableBuilder<String>(
                    valueListenable: authDisplayName,
                    builder: (_, name, __) => Text(name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16))),
              )),
              IconButton(
                  tooltip: 'How to play',
                  onPressed: () => showHowToPlayDialog(context),
                  icon: const Icon(Icons.help_outline, color: C.muted)),
              const CoinChip(),
            ]),
            const OfflineBanner(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _Quick(Icons.card_giftcard, 'Daily', '/daily', dot: true),
              _Quick(Icons.sports_esports_outlined, context.tr('challenges'),
                  '/challenges'),
              _Quick(Icons.shopping_bag_outlined, context.tr('shop'), '/shop'),
              _Quick(Icons.emoji_events_outlined, 'Events', '/events'),
            ]),
            Heading(context.tr('pick_your_game')),
            // Accent hex sampled 1:1 from design icon sheet.
            _ModeCard(
                shape: ShapeKind.circle,
                accent: const Color(0xFFDA3575),
                title: context.tr('play_vs_doll'),
                subtitle: context.tr('offline_smart'),
                number: '01',
                onTap: () => startVsDoll(context)),
            _ModeCard(
                shape: ShapeKind.triangle,
                accent: const Color(0xFF31D3B6),
                title: context.tr('random_match'),
                subtitle: context.tr('online_offline_ai'),
                number: '02',
                onTap: () => startRandom(context)),
            _ModeCard(
                shape: ShapeKind.square,
                accent: const Color(0xFFDC3275),
                title: context.tr('online_match'),
                subtitle: context.tr('find_private_join'),
                number: '03',
                onTap: () => startOnlineMatch(context)),
            _ModeCard(
                shape: ShapeKind.bullseye,
                accent: const Color(0xFFFBC34C),
                title: context.tr('pass_and_play'),
                subtitle: context.tr('two_players'),
                number: '04',
                onTap: () => startPassAndPlay(context)),
            const Spacer(),
            const AppBottomNav(current: 0),
          ]),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final ShapeKind shape;
  final Color accent;
  final String title, subtitle, number;
  final VoidCallback onTap;
  const _ModeCard(
      {required this.shape,
      required this.accent,
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
                        border: Border.all(
                            color: accent.withValues(alpha: 0.55)),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.22),
                            blurRadius: 10,
                            spreadRadius: 0.5,
                          ),
                        ]),
                    child: Center(
                        child: ShapeIcon(shape,
                            color: accent, stroke: 2.4))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Tag(context.tr('mode', {'n': number}), color: accent),
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
