import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/app_update_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

class ContactAboutScreen extends StatelessWidget {
  const ContactAboutScreen({super.key});

  /// Fallback only; the real version comes from the installed package.
  static const appVersion = '1.0.2';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      doll: false,
      child: SingleChildScrollView(
        child: staggered([
          TopBar(context.l10n.aboutUs),
          Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: const AppLogoMark(size: 92),
            ),
            const SizedBox(height: 14),
            const Text(
              'DROTIX',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<InstalledVersion>(
              future: AppUpdateService.installedVersion(),
              builder: (_, snap) => Text(
                  context.l10n.versionLabel(snap.data?.name ?? appVersion),
                  style: const TextStyle(color: C.muted, fontSize: 13)),
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.aboutDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(color: C.muted, fontSize: 15, height: 1.55),
            ),
          ]),
          const ContactUsCard(),
          const CheckForUpdatesButton(),
        ]),
      ),
    );
  }
}

/// "CONTACT US" card shared by About and Terms. Tapping a value copies it.
class ContactUsCard extends StatelessWidget {
  const ContactUsCard({super.key});

  static const website = 'playdrotix.in';
  static const supportEmail = 'support@playdrotix.in';

  void _copy(BuildContext context, String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          SnackBar(content: Text(context.l10n.copiedValue(label, value))));
  }

  Widget _row(BuildContext context, String label, String value) => InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _copy(context, label, value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(children: [
            Text(label, style: const TextStyle(color: C.muted, fontSize: 14)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: C.teal,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: C.teal,
                ),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contactUsCaps,
              style: const TextStyle(
                color: C.teal,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 6),
            _row(context, context.l10n.officialWebsite, website),
            _row(context, context.l10n.supportEmail, supportEmail),
          ],
        ),
      );
}

/// Checks Supabase for a newer release. Opens the update screen when there
/// is one, otherwise says the app is up to date.
class CheckForUpdatesButton extends StatefulWidget {
  const CheckForUpdatesButton({super.key});

  @override
  State<CheckForUpdatesButton> createState() => _CheckForUpdatesButtonState();
}

class _CheckForUpdatesButtonState extends State<CheckForUpdatesButton> {
  bool _checking = false;
  String? _status; // last result line under the button
  bool _statusOk = true;

  Future<void> _check() async {
    if (_checking) return;
    if (!AppUpdateService.supported) {
      setState(() {
        _status = context.l10n.updatesOnlyMobile;
        _statusOk = false;
      });
      return;
    }
    setState(() {
      _checking = true;
      _status = null;
    });
    try {
      final r = await AppUpdateService.check();
      if (!mounted) return;
      setState(() => _checking = false);
      if (r.hasUpdate) {
        await Navigator.pushNamed(context, '/app-update', arguments: r);
      } else {
        setState(() {
          _status = context.l10n.latestVersion;
          _statusOk = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _checking = false;
        _status =
            e is UpdateException ? e.message : context.l10n.couldNotCheck('$e');
        _statusOk = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: _checking ? null : _check,
            style: OutlinedButton.styleFrom(
              foregroundColor: C.teal,
              backgroundColor: C.teal.withValues(alpha: .08),
              side: BorderSide(color: C.teal.withValues(alpha: .8)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _checking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: C.teal))
                  : const Icon(Icons.system_update_rounded,
                      size: 20, color: C.teal),
              const SizedBox(width: 10),
              Text(
                  _checking
                      ? context.l10n.checking
                      : context.l10n.checkForUpdates,
                  style: const TextStyle(
                      color: C.teal,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
            ]),
          ),
        ),
        if (_status != null) ...[
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(_statusOk ? Icons.check_circle_rounded : Icons.info_outline,
                size: 16, color: _statusOk ? C.teal : C.danger),
            const SizedBox(width: 6),
            Flexible(
              child: Text(_status!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _statusOk ? C.teal : C.danger, fontSize: 13)),
            ),
          ]),
        ],
      ]);
}
