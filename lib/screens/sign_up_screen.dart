import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

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
    final username = _username.text.trim();
    final password = _password.text;
    final confirm = _confirm.text;
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      _toast('Fill in all fields');
      return;
    }
    if (password.length < 6) {
      _toast('Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      _toast('Passwords do not match');
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
        _toast('Check your email and open the confirmation link');
        Navigator.pushNamed(context, '/verify', arguments: email);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
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
          const TopBar('Sign up'),
          const Align(
              alignment: Alignment.centerLeft, child: GuardFace(size: 80)),
          const Heading('Join the game'),
          AppField(
              icon: Icons.mail_outline,
              hint: 'Email',
              type: TextInputType.emailAddress,
              controller: _email,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.person_outline,
              hint: 'Username',
              controller: _username,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: 'Password',
              obscure: true,
              controller: _password,
              textInputAction: TextInputAction.next),
          AppField(
              icon: Icons.lock_outline,
              hint: 'Confirm password',
              obscure: true,
              controller: _confirm,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _signUp()),
          PrimaryButton(_loading ? 'Please wait…' : 'Create account',
              onTap: _loading ? null : _signUp),
          const Spacer(),
          Center(
              child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  child: const Text.rich(TextSpan(
                      text: 'Already a player? ',
                      style: TextStyle(color: C.muted, fontSize: 13),
                      children: [
                        TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                                color: C.pinkText,
                                fontWeight: FontWeight.w700))
                      ])))),
        ]),
      ),
    );
  }
}
