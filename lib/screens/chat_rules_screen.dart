import 'package:flutter/material.dart';
import '../services/privacy_prefs_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pdf_ui.dart';
import '../l10n/app_localizations.dart';

/// PDF page 13 — Chat rules + who can send you messages.
///
/// The choice is synced like Challenge privacy (Supabase when signed in,
/// local cache otherwise) and enforced by the server on every chat message.
class ChatRulesScreen extends StatefulWidget {
  const ChatRulesScreen({super.key});

  @override
  State<ChatRulesScreen> createState() => _ChatRulesScreenState();
}

class _ChatRulesScreenState extends State<ChatRulesScreen> {
  @override
  void initState() {
    super.initState();
    PrivacyPrefsService.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(context.l10n.chatRules),
          Text(
            context.l10n.chatRulesIntro,
            style: const TextStyle(color: C.muted, height: 1.4),
          ),
          _rule(context.l10n.friendChallenge, context.l10n.chatAfterAccept),
          _rule(
              context.l10n.privateRoomByUsername, context.l10n.chatAfterAccept),
          _rule(context.l10n.randomMatch, context.l10n.chatAfterAcceptRandom),
          PdfSectionLabel(context.l10n.whoCanMessage),
          ValueListenableBuilder<int>(
            valueListenable: PrivacyPrefsService.chatWho,
            builder: (_, who, __) => Column(children: [
              _whoTile(context.l10n.everyone, 0, who),
              _whoTile(context.l10n.friendsOnly, 1, who),
              _whoTile(context.l10n.nobody, 2, who),
            ]),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: PrivacyPrefsService.saving,
            builder: (_, saving, __) => ValueListenableBuilder<String?>(
              valueListenable: PrivacyPrefsService.error,
              builder: (_, err, ___) => Text(
                err ??
                    (saving
                        ? context.l10n.savingToCloud
                        : context.l10n.chatPrivacyNote),
                style: TextStyle(
                    color: err != null ? C.danger : C.muted, fontSize: 12),
              ),
            ),
          ),
          PdfSectionLabel(context.l10n.alwaysTrue),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.ruleEmoji),
                const SizedBox(height: 10),
                Text(context.l10n.ruleStop),
                const SizedBox(height: 10),
                Text(context.l10n.ruleVanish),
                const SizedBox(height: 10),
                Text(context.l10n.ruleEnds),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  /// Same radio tile as Challenge privacy.
  Widget _whoTile(String label, int i, int who) {
    final sel = who == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => PrivacyPrefsService.setChatWho(i),
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

  static Widget _rule(String title, String body) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 6),
            Text(body, style: const TextStyle(color: C.muted, height: 1.35)),
          ],
        ),
      );
}
