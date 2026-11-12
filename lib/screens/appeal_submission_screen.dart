import 'package:flutter/material.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AppealSubmissionScreen extends StatefulWidget {
  const AppealSubmissionScreen({super.key});

  @override
  State<AppealSubmissionScreen> createState() => _AppealSubmissionScreenState();
}

class _AppealSubmissionScreenState extends State<AppealSubmissionScreen> {
  final _msg = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final id = await ModerationService.submitAppeal(_msg.text);
    if (!mounted) return;
    setState(() => _sending = false);
    if (id == null) {
      setState(() =>
          _error = ModerationService.error.value ?? 'Could not submit appeal');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/appeal-under-review',
      (r) => false,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBar('Appeal suspension'),
          const SizedBox(height: 16),
          const Text(
            'Explain why your account should be reinstated. '
            'A moderator will review your message.',
            style: TextStyle(color: C.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _msg,
            minLines: 6,
            maxLines: 10,
            maxLength: 2000,
            style: const TextStyle(color: C.text),
            decoration: InputDecoration(
              hintText: 'Write your appeal (min 20 characters)…',
              hintStyle: const TextStyle(color: C.muted),
              filled: true,
              fillColor: C.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: C.border2),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: C.magenta)),
          ],
          const Spacer(),
          FilledButton(
            onPressed: _sending ? null : _submit,
            child: Text(_sending ? 'Submitting…' : 'Submit appeal'),
          ),
          const SizedBox(height: 8),
          GhostButton('Back', onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
