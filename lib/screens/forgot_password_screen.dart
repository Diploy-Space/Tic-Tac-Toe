import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

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
      _toast('Enter your email');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.resetPassword(email);
      if (!mounted) return;
      setState(() => _sent = true);
      Navigator.pushNamed(context, '/verify', arguments: email);
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
          const TopBar('Forgot password'),
          const SizedBox(height: 8),
          const Align(
              alignment: Alignment.centerLeft,
              child: IconCircle(Icons.lock_outline, size: 84)),
          const Heading('Reset password'),
          const Text(
              'Enter your email and we’ll send a reset link. Open it on this device to continue.',
              style: TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          AppField(
              icon: Icons.mail_outline,
              hint: 'Email',
              type: TextInputType.emailAddress,
              controller: _email,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _send()),
          PrimaryButton(
              _loading
                  ? 'Sending…'
                  : _sent
                      ? 'Email sent'
                      : 'Send reset link',
              onTap: _loading ? null : _send),
          const Spacer(),
          Center(
              child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                  child: const Text.rich(TextSpan(
                      text: 'Back to ',
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
