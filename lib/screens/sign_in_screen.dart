import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goHome() =>
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      _toast('Enter email and password');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.signIn(email: email, password: password);
      if (!mounted) return;
      _goHome();
    } catch (e) {
      if (!mounted) return;
      if (AuthService.isEmailNotConfirmed(e)) {
        await _showConfirmDialog(email);
      } else {
        _toast(AuthService.messageFromError(e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _showConfirmDialog(String email) async {
    final resend = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: C.surface,
        title: const Text('Email not confirmed'),
        content: Text(
          'Register সফল হয়েছে, কিন্তু email এখনো confirm হয়নি.\n\n'
          'Inbox / Spam এ confirmation link খুলে confirm করো, তারপর আবার Sign in করো.\n\n$email',
          style: const TextStyle(color: C.muted, height: 1.4),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('OK', style: TextStyle(color: C.muted))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Resend email',
                  style: TextStyle(color: C.pinkText))),
        ],
      ),
    );
    if (resend == true) {
      try {
        await AuthService.resendSignupConfirmation(email);
        _toast('Confirmation email পাঠানো হয়েছে — inbox চেক করো');
        if (!mounted) return;
        Navigator.pushNamed(context, '/verify', arguments: email);
      } catch (err) {
        _toast(AuthService.messageFromError(err));
      }
    }
  }

  Future<void> _google() async {
    setState(() => _loading = true);
    try {
      final launched = await AuthService.signInWithGoogle();
      if (!launched) {
        _toast('Could not open Google sign-in');
      } else {
        _toast('Complete Google sign-in, then return to the app');
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
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: ScrollFill(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FadeUp(index: 0, child: TopBar('Sign in')),
            const SizedBox(height: 28),
            const FadeUp(
              index: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GuardFace(size: 68),
              ),
            ),
            const SizedBox(height: 18),
            const FadeUp(
              index: 2,
              child: Heading('Welcome back', size: 30),
            ),
            const SizedBox(height: 8),
            const FadeUp(
              index: 3,
              child: Text(
                'Player, your seat is waiting.',
                style: TextStyle(
                  color: C.muted,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 22),
            FadeUp(
              index: 4,
              child: AppField(
                icon: Icons.mail_outline,
                hint: 'Email',
                type: TextInputType.emailAddress,
                controller: _email,
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 14),
            FadeUp(
              index: 5,
              child: AppField(
                icon: Icons.lock_outline,
                hint: 'Password',
                obscure: true,
                obscureToggle: false,
                controller: _password,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _signIn(),
              ),
            ),
            const SizedBox(height: 10),
            FadeUp(
              index: 6,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/forgot'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: C.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            FadeUp(
              index: 7,
              child: PrimaryButton(
                _loading ? 'Please wait…' : 'Sign in',
                onTap: _loading ? null : _signIn,
                color: const Color(0xFFD4156B),
              ),
            ),
            const SizedBox(height: 16),
            const FadeUp(
              index: 8,
              child: Center(
                child: Text(
                  'Or',
                  style: TextStyle(
                    color: C.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeUp(
              index: 9,
              child: GhostButton('Continue with Google',
                  onTap: _loading ? null : _google),
            ),
            const Spacer(),
            FadeUp(
              index: 10,
              child: Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: const Text.rich(
                    TextSpan(
                      text: 'New here? ',
                      style: TextStyle(
                        color: C.muted,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            color: Color(0xFFD4156B),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
