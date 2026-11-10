import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Holding / OTP screen.
/// - [mode] `signup`: magic-link confirmation (open email link).
/// - [mode] `recovery`: type the 6-digit code from the reset email.
class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});
  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  Timer? _poll;
  final _otp = TextEditingController();
  String email = '';
  String mode = 'signup'; // signup | recovery
  bool _loading = false;

  bool get _isRecovery => mode == 'recovery';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is String && arg.isNotEmpty) {
      email = arg;
      mode = 'signup';
    } else if (arg is Map) {
      final e = arg['email'];
      final m = arg['mode'];
      if (e is String && e.isNotEmpty) email = e;
      if (m is String && m.isNotEmpty) mode = m;
    }
  }

  @override
  void initState() {
    super.initState();
    _poll = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || _isRecovery) return;
      if (AuthService.isSignedIn) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _otp.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _resend() async {
    if (email.isEmpty) {
      _toast('Missing email — go back and try again');
      return;
    }
    try {
      if (_isRecovery) {
        await AuthService.resetPassword(email);
      } else {
        await AuthService.resendSignupConfirmation(email);
      }
      _toast(_isRecovery
          ? 'New code sent — check your inbox'
          : 'Email sent again — check your inbox');
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    }
  }

  Future<void> _verifyOtp() async {
    final token = _otp.text.trim();
    if (email.isEmpty) {
      _toast('Missing email — go back and try again');
      return;
    }
    if (token.length < 6 || token.length > 10) {
      _toast('Enter the code from your email');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.verifyRecoveryOtp(email: email, token: token);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/reset-password', (r) => false);
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = email.isEmpty ? 'your email' : email;
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(_isRecovery ? 'Enter code' : 'Check email'),
          const SizedBox(height: 8),
          Heading(_isRecovery ? 'Enter reset code' : 'Check your inbox'),
          Text(
              _isRecovery
                  ? 'We sent a reset code to $target.\n'
                      'Type it below — you don’t need to open the email link.'
                  : 'We sent a confirmation link to $target.\n'
                      'Open the link on this device, then return here — you’ll be signed in automatically.',
              style: const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          if (_isRecovery) ...[
            AppField(
                icon: Icons.pin_outlined,
                hint: 'Reset code',
                type: TextInputType.number,
                controller: _otp,
                obscure: false,
                obscureToggle: false,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verifyOtp()),
            PrimaryButton(_loading ? 'Verifying…' : 'Verify code',
                onTap: _loading ? null : _verifyOtp),
          ] else
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
                            _toast(
                                'Not signed in yet — open the email link first');
                          }
                        })),
          Center(
              child: TextButton(
                  onPressed: _resend,
                  child: Text(_isRecovery ? 'Resend code' : 'Resend email',
                      style: const TextStyle(color: C.muted)))),
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
