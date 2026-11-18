import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _signUp() async {
    final email = _email.text.trim();
    final username = ProfileService.normalizeUsername(_username.text);
    final password = _password.text;
    final confirm = _confirm.text;
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      _toast(context.l10n.fillAllFields);
      return;
    }
    final usernameErr = ProfileService.validateUsername(username);
    if (usernameErr != null) {
      _toast(usernameErr);
      return;
    }
    if (password.length < 6) {
      _toast(context.l10n.passwordMin6);
      return;
    }
    if (password != confirm) {
      _toast(context.l10n.passwordsNoMatch);
      return;
    }
    setState(() => _loading = true);
    try {
      final needsConfirm = await AuthService.signUp(
        email: email,
        password: password,
        username: username,
      );
      if (!mounted) return;
      if (needsConfirm) {
        _toast(context.l10n.checkEmailConfirm);
        Navigator.pushNamed(context, '/verify', arguments: email);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/referral-code', (r) => false);
      }
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
          TopBar(context.l10n.signUp),
          const Align(
              alignment: Alignment.centerLeft, child: GuardFace(size: 80)),
          Heading(context.l10n.joinTheGame),
          AppField(
              icon: Icons.mail_outline,
              hint: context.l10n.email,
              type: TextInputType.emailAddress,
              controller: _email,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.person_outline,
              hint: context.l10n.usernameHint,
              controller: _username,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: context.l10n.password,
              obscure: true,
              controller: _password,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: context.l10n.confirmPassword,
              obscure: true,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _signUp()),
          PrimaryButton(
              _loading ? context.l10n.pleaseWait : context.l10n.createAccount,
              onTap: _loading ? null : _signUp),
          const Spacer(),
          Center(
              child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  child: Text.rich(TextSpan(
                      text: '${context.l10n.alreadyPlayer} ',
                      style: const TextStyle(color: C.muted, fontSize: 13),
                      children: [
                        TextSpan(
                            text: context.l10n.signIn,
                            style: const TextStyle(
                                color: C.pinkText, fontWeight: FontWeight.w700))
                      ])))),
        ]),
      ),
    );
  }
}
