import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
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
    return ValueListenableBuilder<int>(
      valueListenable: AppLocaleService.revision,
      builder: (context, _, __) => AppScaffold(
        child: SingleChildScrollView(
          child: staggered([
            TopBar(context.tr('settings')),
            AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(children: [
                  ToggleRow(Icons.volume_up_outlined,
                      context.tr('sound_effects'), soundOn),
                  ToggleRow(
                      Icons.music_note_outlined, context.tr('music'), musicOn),
                  ToggleRow(
                      Icons.vibration, context.tr('vibration'), vibrationOn),
                  ToggleRow(Icons.notifications_none,
                      context.tr('notifications'), notificationsOn,
                      last: true),
                ])),
            AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(children: [
                  MenuTile(Icons.translate, context.tr('language'),
                      onTap: () => go('/language')),
                  MenuTile(Icons.sports_esports_outlined,
                      context.tr('challenges'),
                      onTap: () => go('/challenges')),
                  MenuTile(Icons.lock_outline, context.tr('challenge_privacy'),
                      onTap: () => go('/challenge-privacy')),
                  MenuTile(Icons.chat_bubble_outline, context.tr('chat_rules'),
                      onTap: () => go('/chat-rules')),
                  MenuTile(Icons.phone_outlined, context.tr('contact_about'),
                      onTap: () => go('/contact')),
                  MenuTile(Icons.description_outlined,
                      context.tr('privacy_terms'),
                      onTap: () => go('/privacy')),
                  MenuTile(Icons.star_outline, context.tr('rate_app'),
                      onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Add in_app_review to enable ratings')));
                  }),
                  MenuTile(Icons.delete_outline, context.tr('delete_account'),
                      danger: true,
                      last: true, onTap: () async {
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
            Center(
                child: Text(context.tr('version'),
                    style: const TextStyle(color: C.muted))),
          ]),
        ),
      ),
    );
  }
}
