import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../l10n/app_localizations.dart';

/// After recovery OTP, user sets a new password while a recovery session is active.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _save() async {
    final pw = _password.text;
    final conf = _confirm.text;
    if (pw.length < 6) {
      _toast(context.l10n.passwordMin6);
      return;
    }
    if (pw != conf) {
      _toast(context.l10n.passwordsNoMatch);
      return;
    }
    if (!AuthService.isSignedIn) {
      _toast(context.l10n.sessionExpiredReset);
      Navigator.pushNamedAndRemoveUntil(context, '/forgot', (r) => false);
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.updatePassword(pw);
      if (!mounted) return;
      _toast(context.l10n.passwordUpdated);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ScrollFill(
        child: staggered([
          TopBar(context.l10n.newPassword),
          const SizedBox(height: 8),
          const Align(
              alignment: Alignment.centerLeft,
              child: IconCircle(Icons.lock_reset, size: 84)),
          Heading(context.l10n.chooseNewPassword),
          Text(context.l10n.newPasswordBody,
              style: const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          AppField(
              icon: Icons.lock_outline,
              hint: context.l10n.newPassword,
              obscure: true,
              controller: _password,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: context.l10n.confirmPassword,
              obscure: true,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save()),
          PrimaryButton(
              _loading ? context.l10n.saving : context.l10n.savePassword,
              onTap: _loading ? null : _save),
        ]),
      ),
    );
  }
}
