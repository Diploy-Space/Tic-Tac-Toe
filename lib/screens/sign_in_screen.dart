import 'package:flutter/material.dart';
import '../models/moderation_models.dart';
import '../services/auth_service.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/painters.dart';
import '../l10n/app_localizations.dart';

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

  void _routeAfterAuth() {
    final s = ModerationService.status.value;
    if (s?.accountStatus == AccountStatus.suspended) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/account-suspended', (r) => false);
      return;
    }
    if (s?.accountStatus == AccountStatus.underReview ||
        (s?.hasActiveAppeal ?? false)) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/appeal-under-review', (r) => false);
      return;
    }
    _goHome();
  }

  Future<void> _signIn() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      _toast(context.l10n.enterEmailPassword);
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.signIn(email: email, password: password);
      if (!mounted) return;
      _routeAfterAuth();
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
        title: Text(context.l10n.emailNotConfirmed),
        content: Text(
          context.l10n.emailNotConfirmedBody(email),
          style: const TextStyle(color: C.muted, height: 1.4),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.l10n.ok,
                  style: const TextStyle(color: C.muted))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.l10n.resendEmail,
                  style: const TextStyle(color: C.pinkText))),
        ],
      ),
    );
    if (resend == true) {
      try {
        await AuthService.resendSignupConfirmation(email);
        _toast(context.l10n.confirmationEmailSent);
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
        _toast(context.l10n.couldNotOpenGoogle);
      } else {
        _toast(context.l10n.completeGoogleReturnApp);
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
            FadeUp(index: 0, child: TopBar(context.l10n.signIn)),
            const SizedBox(height: 28),
            const FadeUp(
              index: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GuardFace(size: 68),
              ),
            ),
            const SizedBox(height: 18),
            FadeUp(
              index: 2,
              child: Heading(context.l10n.welcomeBack, size: 30),
            ),
            const SizedBox(height: 8),
            FadeUp(
              index: 3,
              child: Text(
                context.l10n.seatWaiting,
                style: const TextStyle(
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
                hint: context.l10n.email,
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
                hint: context.l10n.password,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      context.l10n.forgotPassword,
                      style: const TextStyle(
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
                _loading ? context.l10n.pleaseWait : context.l10n.signIn,
                onTap: _loading ? null : _signIn,
                color: const Color(0xFFD4156B),
              ),
            ),
            const SizedBox(height: 16),
            FadeUp(
              index: 8,
              child: Center(
                child: Text(
                  context.l10n.or,
                  style: const TextStyle(
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
              child: GhostButton(context.l10n.continueWithGoogle,
                  onTap: _loading ? null : _google),
            ),
            const Spacer(),
            FadeUp(
              index: 10,
              child: Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                  child: Text.rich(
                    TextSpan(
                      text: '${context.l10n.newHere} ',
                      style: const TextStyle(
                        color: C.muted,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: context.l10n.register,
                          style: const TextStyle(
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
