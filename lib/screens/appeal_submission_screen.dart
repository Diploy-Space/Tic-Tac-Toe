import 'package:flutter/material.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../l10n/app_localizations.dart';

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
      setState(() => _error =
          ModerationService.error.value ?? context.l10n.couldNotSubmitAppeal);
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
          TopBar(context.l10n.appealSuspension),
          const SizedBox(height: 16),
          Text(
            context.l10n.appealExplain,
            style: const TextStyle(color: C.muted, height: 1.4),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _msg,
            minLines: 6,
            maxLines: 10,
            maxLength: 2000,
            style: const TextStyle(color: C.text),
            decoration: InputDecoration(
              hintText: context.l10n.appealHint,
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
            child: Text(
                _sending ? context.l10n.submitting : context.l10n.submitAppeal),
          ),
          const SizedBox(height: 8),
          GhostButton(context.l10n.back, onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
