import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/moderation_models.dart';
import '../services/moderation_service.dart';
import '../theme.dart';
import 'extras.dart';

Future<void> openReportUserSheet(
  BuildContext context, {
  required String roomId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: C.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(ctx).height * 0.78,
        child: ReportUserPanel(roomId: roomId),
      ),
    ),
  );
}

class ReportUserPanel extends StatefulWidget {
  final String roomId;
  const ReportUserPanel({super.key, required this.roomId});

  @override
  State<ReportUserPanel> createState() => _ReportUserPanelState();
}

class _ReportUserPanelState extends State<ReportUserPanel> {
  String? _reason;
  final _desc = TextEditingController();
  Uint8List? _bytes;
  bool _submitting = false;
  String? _localError;

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    setState(() => _localError = null);
    try {
      final bytes = await ModerationService.pickScreenshot();
      if (!mounted || bytes == null) return;
      setState(() => _bytes = bytes);
    } catch (e) {
      setState(() => _localError = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (_reason == null) {
      setState(() => _localError = 'Select a reason');
      return;
    }
    if (_desc.text.trim().length < 10) {
      setState(() => _localError = 'Description must be at least 10 characters');
      return;
    }
    if (_bytes == null) {
      setState(() => _localError = 'Screenshot is required');
      return;
    }
    setState(() {
      _submitting = true;
      _localError = null;
    });
    final id = await ModerationService.submitReport(
      roomId: widget.roomId,
      reasonCode: _reason!,
      description: _desc.text,
      screenshotBytes: _bytes!,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (id == null) {
      setState(() =>
          _localError = ModerationService.error.value ?? 'Report failed');
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted. Thank you.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: C.border2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
          child: Row(
            children: [
              const Expanded(
                child: Text('Report opponent',
                    style:
                        TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: C.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              const Text('Reason',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in ReportReason.all)
                    ChoiceChip(
                      label: Text(r.label, style: const TextStyle(fontSize: 12)),
                      selected: _reason == r.code,
                      onSelected: (_) => setState(() => _reason = r.code),
                      selectedColor: C.magenta.withValues(alpha: 0.35),
                      backgroundColor: C.bg,
                      labelStyle: TextStyle(
                        color: _reason == r.code ? C.text : C.muted,
                      ),
                      side: BorderSide(
                        color: _reason == r.code ? C.magenta : C.border2,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Description',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _desc,
                maxLines: 4,
                maxLength: 2000,
                style: const TextStyle(color: C.text),
                decoration: InputDecoration(
                  hintText: 'Describe what happened…',
                  hintStyle: const TextStyle(color: C.muted),
                  filled: true,
                  fillColor: C.bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: C.border2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Screenshot (required)',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (_bytes != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.memory(_bytes!,
                      height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: _pick,
                      child: const Text('Replace',
                          style: TextStyle(color: C.teal)),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _bytes = null),
                      child: const Text('Remove',
                          style: TextStyle(color: C.danger)),
                    ),
                  ],
                ),
              ] else
                OutlinedButton.icon(
                  onPressed: _pick,
                  icon: const Icon(Icons.image_outlined, color: C.teal),
                  label: const Text('Attach screenshot',
                      style: TextStyle(color: C.teal)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: C.border2),
                  ),
                ),
              if (_localError != null) ...[
                const SizedBox(height: 12),
                Text(_localError!,
                    style: const TextStyle(color: C.magenta, fontSize: 13)),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: SmallButton(
                  _submitting ? 'Submitting…' : 'Submit report',
                  onTap: _submitting ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
