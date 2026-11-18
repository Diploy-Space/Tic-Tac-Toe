import 'package:flutter/material.dart';
import '../models.dart';
import '../services/privacy_prefs_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF page 12 — Challenge privacy (synced to Supabase when signed in).
class ChallengePrivacyScreen extends StatefulWidget {
  const ChallengePrivacyScreen({super.key});

  @override
  State<ChallengePrivacyScreen> createState() => _ChallengePrivacyScreenState();
}

class _ChallengePrivacyScreenState extends State<ChallengePrivacyScreen> {
  @override
  void initState() {
    super.initState();
    PrivacyPrefsService.refresh();
  }

  Widget _whoTile(String label, int i, int who) {
    final sel = who == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => PrivacyPrefsService.setChallengeWho(i),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: sel ? C.magenta : C.border,
              width: sel ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: sel ? C.text : C.muted,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: sel ? C.magenta : C.border2,
                    width: 2,
                  ),
                ),
                child: sel
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: C.magenta,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(context.l10n.privacy),
          ValueListenableBuilder<String?>(
            valueListenable: PrivacyPrefsService.error,
            builder: (_, err, __) => err == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      err,
                      style: const TextStyle(color: C.danger, fontSize: 12),
                    ),
                  ),
          ),
          PdfSectionLabel(context.l10n.whoCanChallenge),
          ValueListenableBuilder<int>(
            valueListenable: PrivacyPrefsService.challengeWho,
            builder: (_, who, __) => Column(
              children: [
                _whoTile(context.l10n.everyone, 0, who),
                _whoTile(context.l10n.friendsOnly, 1, who),
                _whoTile(context.l10n.nobody, 2, who),
              ],
            ),
          ),
          PdfSectionLabel(context.l10n.notifications),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(children: [
              ToggleRow(
                Icons.sports_esports,
                context.l10n.challengeRequests,
                notifyChallengeRequests,
              ),
              ToggleRow(
                Icons.mail_outline,
                context.l10n.matchInvitations,
                notifyMatchInvites,
              ),
              ToggleRow(
                Icons.emoji_events_outlined,
                context.l10n.matchResults,
                notifyMatchResults,
                last: true,
              ),
            ]),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: PrivacyPrefsService.saving,
            builder: (_, saving, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                saving
                    ? context.l10n.savingToCloud
                    : context.l10n.historyNeverPublic,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: C.muted,
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
