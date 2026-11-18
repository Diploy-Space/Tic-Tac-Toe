import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import '../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _send() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      _toast(context.l10n.enterYourEmail);
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.resetPassword(email);
      if (!mounted) return;
      setState(() => _sent = true);
      Navigator.pushNamed(context, '/verify', arguments: {
        'email': email,
        'mode': 'recovery',
      });
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
          TopBar(context.l10n.forgotPasswordTitle),
          const SizedBox(height: 8),
          const Align(
              alignment: Alignment.centerLeft,
              child: IconCircle(Icons.lock_outline, size: 84)),
          Heading(context.l10n.resetPassword),
          Text(context.l10n.resetPasswordBody,
              style: const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          AppField(
              icon: Icons.mail_outline,
              hint: context.l10n.email,
              type: TextInputType.emailAddress,
              controller: _email,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _send()),
          PrimaryButton(
              _loading
                  ? context.l10n.sending
                  : _sent
                      ? context.l10n.codeSent
                      : context.l10n.sendResetCode,
              onTap: _loading ? null : _send),
          const Spacer(),
          Center(
              child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  child: Text.rich(TextSpan(
                      text: '',
                      style: const TextStyle(color: C.muted, fontSize: 13),
                      children: [
                        TextSpan(
                            text: context.l10n.backToSignIn,
                            style: const TextStyle(
                                color: C.pinkText, fontWeight: FontWeight.w700))
                      ])))),
        ]),
      ),
    );
  }
}
