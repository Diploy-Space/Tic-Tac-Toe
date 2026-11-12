import 'package:flutter/material.dart';
import '../models.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    void go(String r) => Navigator.pushNamed(context, r);
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Settings'),
          AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(children: [
                ToggleRow(Icons.volume_up_outlined, 'Sound effects', soundOn),
                ToggleRow(Icons.music_note_outlined, 'Music', musicOn),
                ToggleRow(Icons.vibration, 'Vibration', vibrationOn),
                ToggleRow(Icons.notifications_none, 'Notifications', notificationsOn,
                    last: true),
              ])),
          AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(children: [
                MenuTile(Icons.translate, 'Language', onTap: () => go('/language')),
                MenuTile(Icons.sports_esports_outlined, 'Challenges',
                    onTap: () => go('/challenges')),
                MenuTile(Icons.lock_outline, 'Challenge privacy',
                    onTap: () => go('/challenge-privacy')),
                MenuTile(Icons.chat_bubble_outline, 'Chat rules',
                    onTap: () => go('/chat-rules')),
                MenuTile(Icons.bolt_outlined, 'Quick chat demo',
                    onTap: () => go('/ephemeral-chat')),
                MenuTile(Icons.ondemand_video_outlined, 'Ad placement',
                    onTap: () => go('/ad-placement')),
                MenuTile(Icons.wifi_off_outlined, 'Connection demo',
                    onTap: () => go('/connection-unstable')),
                MenuTile(Icons.phone_outlined, 'Contact & about', onTap: () => go('/contact')),
                MenuTile(Icons.description_outlined, 'Privacy & terms', onTap: () => go('/privacy')),
                MenuTile(Icons.shield_outlined, 'Admin moderation',
                    onTap: () => go('/admin-moderation')),
                MenuTile(Icons.emoji_events_outlined, 'Admin tournament',
                    onTap: () => go('/admin-tournament')),
                MenuTile(Icons.star_outline, 'Rate the app', onTap: () {
                  // TODO: use the in_app_review package.
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add in_app_review to enable ratings')));
                }),
                MenuTile(Icons.delete_outline, 'Delete account',
                    danger: true,
                    last: true,
                    onTap: () async {
                      final ok = await showDeleteDialog(context);
                      if (ok == true && context.mounted) {
                        await AppStorage.clearAccount();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (r) => false);
                        }
                      }
                    }),
              ])),
          const Center(
              child: Text('Version 1.0.1', style: TextStyle(color: C.muted))),
        ]),
      ),
    );
  }
}
