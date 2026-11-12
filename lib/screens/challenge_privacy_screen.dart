import 'package:flutter/material.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../widgets/pdf_ui.dart';

/// PDF page 12 — Challenge privacy.
class ChallengePrivacyScreen extends StatefulWidget {
  const ChallengePrivacyScreen({super.key});

  @override
  State<ChallengePrivacyScreen> createState() => _ChallengePrivacyScreenState();
}

class _ChallengePrivacyScreenState extends State<ChallengePrivacyScreen> {
  int who = 0;
  final challengeReq = ValueNotifier(true);
  final matchInvites = ValueNotifier(true);
  final matchResults = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    who = AppStorage.challengePrivacyWho;
  }

  @override
  void dispose() {
    challengeReq.dispose();
    matchInvites.dispose();
    matchResults.dispose();
    super.dispose();
  }

  Widget _whoTile(String label, int i) {
    final sel = who == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          setState(() => who = i);
          await AppStorage.setChallengePrivacyWho(i);
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: C.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sel ? C.magenta : C.border, width: sel ? 1.6 : 1),
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
          const TopBar('Privacy'),
          const PdfSectionLabel('Who can challenge you'),
          _whoTile('Everyone', 0),
          _whoTile('Friends only', 1),
          _whoTile('Nobody', 2),
          const PdfSectionLabel('Notifications'),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(children: [
              ToggleRow(Icons.sports_esports, 'Challenge requests', challengeReq),
              ToggleRow(Icons.mail_outline, 'Match invitations', matchInvites),
              ToggleRow(Icons.emoji_events_outlined, 'Match results', matchResults,
                  last: true),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              'Your match history and activity are never shown on your public profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: C.muted, height: 1.4, fontSize: 13),
            ),
          ),
        ]),
      ),
    );
  }
}
