import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _avatarBusy = false;

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _avatarActions() async {
    if (!AuthService.isSignedIn) {
      _toast('Sign in to change your avatar');
      return;
    }
    final hasAvatar =
        (ProfileService.current.value?.avatarUrl ?? authAvatarUrl.value)
                ?.isNotEmpty ==
            true;

    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: C.border2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(hasAvatar ? 'Replace photo' : 'Upload photo'),
                onTap: () => Navigator.pop(ctx, 'upload'),
              ),
              if (hasAvatar)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Remove photo',
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () => Navigator.pop(ctx, 'remove'),
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );

    if (choice == null || !mounted) return;
    setState(() => _avatarBusy = true);
    try {
      if (choice == 'upload') {
        await ProfileService.changeAvatarFromGallery();
        _toast('Avatar updated');
      } else if (choice == 'remove') {
        await ProfileService.removeAvatar();
        _toast('Avatar removed');
      }
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _avatarBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    void go(String r) => Navigator.pushNamed(context, r);
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RoundIconBox(Icons.arrow_back_ios_new_rounded,
                label: 'Back', onTap: () => Navigator.maybePop(context)),
            RoundIconBox(Icons.logout, label: 'Log out', onTap: () async {
              try {
                await AuthService.signOut();
              } catch (_) {}
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
            }),
          ]),
          ValueListenableBuilder<int>(
              valueListenable: statsTick,
              builder: (_, __, ___) {
                final s = playerStats;
                final rank = s.rankEstimate == 0 ? '–' : '#${s.rankEstimate}';
                return _ProfileHeaderCard(
                  stats: [
                    MapEntry('Rank', rank),
                    MapEntry('Score', '${s.score}'),
                    MapEntry('Played', '${s.played}'),
                    MapEntry('Wins', '${s.wins}'),
                  ],
                  avatarBusy: _avatarBusy,
                  onAvatarTap: _avatarActions,
                );
              }),
          ValueListenableBuilder<bool>(
              valueListenable: soundOn,
              builder: (_, on, __) => SegRow(
                  options: const ['Sound enabled', 'Sound disabled'],
                  selected: on ? 0 : 1,
                  onChanged: (i) => soundOn.value = i == 0)),
          AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(children: [
                MenuTile(Icons.bar_chart, 'Stats', onTap: () => go('/stats')),
                MenuTile(Icons.emoji_events_outlined, 'Achievements',
                    onTap: () => go('/achievements')),
                MenuTile(Icons.group_outlined, 'Friends',
                    onTap: () => go('/friends')),
                MenuTile(Icons.edit_outlined, 'Customize',
                    onTap: () => go('/customize')),
                MenuTile(Icons.history, 'History', onTap: () => go('/history')),
                MenuTile(Icons.sports_esports_outlined, 'More games',
                    onTap: () => go('/games')),
                MenuTile(Icons.settings_outlined, 'Settings',
                    last: true, onTap: () => go('/settings')),
              ])),
        ]),
      ),
    );
  }
}

/// Same layout as [UserCard], with tappable avatar for upload/replace/delete.
class _ProfileHeaderCard extends StatelessWidget {
  final List<MapEntry<String, String>> stats;
  final bool avatarBusy;
  final VoidCallback onAvatarTap;

  const _ProfileHeaderCard({
    required this.stats,
    required this.avatarBusy,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) => AppCard(
      borderColor: C.magenta,
      child: Column(children: [
        Row(children: [
          GestureDetector(
            onTap: avatarBusy ? null : onAvatarTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: authAvatarUrl,
                  builder: (_, url, __) => Container(
                    width: 52,
                    height: 52,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: C.border2),
                    ),
                    child: ProfileAvatar(url: url, size: 50),
                  ),
                ),
                if (avatarBusy)
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: C.magenta,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: ValueListenableBuilder<String>(
                  valueListenable: authDisplayName,
                  builder: (_, name, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Tag('Player 042'),
                        Text(name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      ]))),
          const CoinChip(),
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
                  Text(s.key,
                      style: const TextStyle(fontSize: 13, color: C.muted)),
                  Text(s.value,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ])),
            ])),
      ]));
}
