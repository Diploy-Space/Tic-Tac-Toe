import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/referral_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../l10n/app_localizations.dart';

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
    _poll = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!mounted || _isRecovery) return;
      if (!AuthService.isSignedIn) return;
      _poll?.cancel();
      final showReferral = await ReferralService.shouldShowPrompt();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        showReferral ? '/referral-code' : '/home',
        (r) => false,
      );
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
      _toast(context.l10n.missingEmail);
      return;
    }
    try {
      if (_isRecovery) {
        await AuthService.resetPassword(email);
      } else {
        await AuthService.resendSignupConfirmation(email);
      }
      _toast(
          _isRecovery ? context.l10n.newCodeSent : context.l10n.emailSentAgain);
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    }
  }

  Future<void> _verifyOtp() async {
    final token = _otp.text.trim();
    if (email.isEmpty) {
      _toast(context.l10n.missingEmail);
      return;
    }
    if (token.length < 6 || token.length > 10) {
      _toast(context.l10n.enterCodeFromEmail);
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
    final target = email.isEmpty ? context.l10n.yourEmail : email;
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          TopBar(
              _isRecovery ? context.l10n.enterCode : context.l10n.checkEmail),
          const SizedBox(height: 8),
          Heading(_isRecovery
              ? context.l10n.enterResetCode
              : context.l10n.checkInbox),
          Text(
              _isRecovery
                  ? context.l10n.resetCodeSentTo(target)
                  : context.l10n.confirmLinkSentTo(target),
              style:
                  const TextStyle(color: C.muted, fontSize: 14, height: 1.5)),
          if (_isRecovery) ...[
            AppField(
                icon: Icons.pin_outlined,
                hint: context.l10n.resetCode,
                type: TextInputType.number,
                controller: _otp,
                obscure: false,
                obscureToggle: false,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verifyOtp()),
            PrimaryButton(
                _loading ? context.l10n.verifying : context.l10n.verifyCode,
                onTap: _loading ? null : _verifyOtp),
          ] else
            ValueListenableBuilder<bool>(
                valueListenable: authSignedIn,
                builder: (_, signedIn, __) => signedIn
                    ? PrimaryButton(context.l10n.continueLabel,
                        onTap: () async {
                        final show = await ReferralService.shouldShowPrompt();
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          show ? '/referral-code' : '/home',
                          (r) => false,
                        );
                      })
                    : PrimaryButton(context.l10n.openedTheLink,
                        onTap: () async {
                        if (AuthService.isSignedIn) {
                          final show = await ReferralService.shouldShowPrompt();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            show ? '/referral-code' : '/home',
                            (r) => false,
                          );
                        } else {
                          _toast(context.l10n.notSignedInYet);
                        }
                      })),
          Center(
              child: TextButton(
                  onPressed: _resend,
                  child: Text(
                      _isRecovery
                          ? context.l10n.resendCode
                          : context.l10n.resendEmail,
                      style: const TextStyle(color: C.muted)))),
          Center(
              child: TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/signin', (r) => false),
                  child: Text(context.l10n.backToSignIn,
                      style: const TextStyle(color: C.pinkText)))),
        ], gap: 18),
      ),
    );
  }
}
