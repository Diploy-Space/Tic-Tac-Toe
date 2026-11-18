import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';
import 'contact_about_screen.dart';

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
            TopBar(context.l10n.settings),
            AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(children: [
                  ToggleRow(Icons.volume_up_outlined,
                      context.l10n.soundEffects, soundOn),
                  ToggleRow(
                      Icons.music_note_outlined, context.l10n.music, musicOn),
                  ToggleRow(
                      Icons.vibration, context.l10n.vibration, vibrationOn),
                  ToggleRow(Icons.notifications_none,
                      context.l10n.notifications, notificationsOn,
                      last: true),
                ])),
            AppCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(children: [
                  MenuTile(Icons.translate, context.l10n.language,
                      onTap: () => go('/language')),
                  MenuTile(Icons.sports_esports_outlined,
                      context.l10n.challenges,
                      onTap: () => go('/challenges')),
                  MenuTile(Icons.lock_outline, context.l10n.challengePrivacy,
                      onTap: () => go('/challenge-privacy')),
                  MenuTile(Icons.chat_bubble_outline, context.l10n.chatRules,
                      onTap: () => go('/chat-rules')),
                  MenuTile(Icons.phone_outlined, context.l10n.contactAbout,
                      onTap: () => go('/contact')),
                  MenuTile(Icons.description_outlined,
                      context.l10n.privacyPolicy,
                      onTap: () => go('/privacy')),
                  MenuTile(Icons.gavel_outlined,
                      context.l10n.termsOfService,
                      onTap: () => go('/terms')),
                  MenuTile(Icons.star_outline, context.l10n.rateApp,
                      onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(context.l10n.ratingsSoon)));
                  }),
                  MenuTile(Icons.delete_outline, context.l10n.deleteAccount,
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
                child: Text(context.l10n.versionLabel(ContactAboutScreen.appVersion),
                    style: const TextStyle(color: C.muted))),
          ]),
        ),
      ),
    );
  }
}
