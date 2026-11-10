import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

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
      _toast('Password must be at least 6 characters');
      return;
    }
    if (pw != conf) {
      _toast('Passwords do not match');
      return;
    }
    if (!AuthService.isSignedIn) {
      _toast('Session expired — request a new reset code');
      Navigator.pushNamedAndRemoveUntil(context, '/forgot', (r) => false);
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.updatePassword(pw);
      if (!mounted) return;
      _toast('Password updated');
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
          const TopBar('New password'),
          const SizedBox(height: 8),
          const Align(
              alignment: Alignment.centerLeft,
              child: IconCircle(Icons.lock_reset, size: 84)),
          const Heading('Choose a new password'),
          const Text(
              'Enter a new password for your account. You’ll stay signed in after saving.',
              style: TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          AppField(
              icon: Icons.lock_outline,
              hint: 'New password',
              obscure: true,
              controller: _password,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: 'Confirm password',
              obscure: true,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save()),
          PrimaryButton(_loading ? 'Saving…' : 'Save password',
              onTap: _loading ? null : _save),
        ]),
      ),
    );
  }
}
