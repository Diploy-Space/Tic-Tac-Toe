import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Post-signup / reset password holding screen.
/// Supabase email flows use a magic link; this screen explains next steps.
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  Timer? _poll;
  String email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.isNotEmpty) email = arg;
  }

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      if (AuthService.isSignedIn) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _resend() async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing email — go back and try again')));
      return;
    }
    try {
      await AuthService.resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email sent again — check your inbox')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.messageFromError(e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = email.isEmpty ? 'your email' : email;
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Check email'),
          const SizedBox(height: 8),
          const Heading('Check your inbox'),
          Text(
              'We sent a confirmation / reset link to $target.\n'
              'Open the link on this device, then return here — you’ll be signed in automatically.',
              style: const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          ValueListenableBuilder<bool>(
              valueListenable: authSignedIn,
              builder: (_, signedIn, __) => signedIn
                  ? PrimaryButton('Continue',
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (r) => false))
                  : PrimaryButton('I’ve opened the link',
                      onTap: () {
                        if (AuthService.isSignedIn) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (r) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Not signed in yet — open the email link first')));
                        }
                      })),
          Center(
              child: TextButton(
                  onPressed: _resend,
                  child: const Text('Resend email',
                      style: TextStyle(color: C.muted)))),
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/signin', (r) => false),
                  child: const Text('Back to Sign in',
                      style: TextStyle(color: C.pinkText)))),
        ], gap: 18),
      ),
    );
  }
}
