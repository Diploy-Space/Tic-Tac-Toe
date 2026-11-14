import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../services/auth_service.dart';
import '../services/referral_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Post-signup: enter optional referral code or skip to home.
class ReferralCodeScreen extends StatefulWidget {
  const ReferralCodeScreen({super.key});

  @override
  State<ReferralCodeScreen> createState() => _ReferralCodeScreenState();
}

class _ReferralCodeScreenState extends State<ReferralCodeScreen> {
  final _code = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  String get _username {
    final n = authDisplayName.value.trim();
    return n.isEmpty || n == 'Guest' ? 'player' : n;
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  }

  Future<void> _skip() async {
    setState(() => _loading = true);
    try {
      await ReferralService.skip();
      await _goHome();
    } catch (e) {
      _toast(AuthService.messageFromError(e));
      await _goHome();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _apply() async {
    final raw = _code.text.trim();
    if (raw.isEmpty) {
      _toast('Enter a referral code, or skip for now');
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ReferralService.applyCode(raw);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/referral-success',
        (r) => false,
        arguments: {
          'code': res.code,
          'bonus': res.bonus,
          'balance': res.balance,
        },
      );
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      doll: false,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'D',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'ONE LAST STEP',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: C.teal,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<String>(
            valueListenable: authDisplayName,
            builder: (_, __, ___) => Text(
              'Welcome, $_username',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Got a referral code from a friend? Enter it now and get 50 coins.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: C.muted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: C.border2),
            ),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9_]')),
                LengthLimitingTextInputFormatter(20),
                _UpperCaseTextFormatter(),
              ],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Referral code (optional)',
                hintStyle: TextStyle(
                  color: C.muted,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _loading ? null : _apply(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: _loading ? null : _apply,
              style: FilledButton.styleFrom(
                backgroundColor: C.magenta,
                foregroundColor: Colors.white,
                disabledBackgroundColor: C.magenta.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _loading ? 'Please wait…' : 'APPLY CODE',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              onPressed: _loading ? null : _skip,
              style: OutlinedButton.styleFrom(
                foregroundColor: C.text,
                side: const BorderSide(color: Color(0xFF4A4A55), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Skip for now',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'You can only use a referral code once, right after signing up.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: C.muted,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
