import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/moderation_models.dart';
import '../services/auth_service.dart';
import '../services/game_chat_service.dart';
import '../services/moderation_service.dart';
import '../services/online_realtime_service.dart';
import '../services/storage.dart';
import '../theme.dart';

/// Opens PDF-matching report flow: reason sheet → details → sent modal.
Future<void> openReportUserSheet(
  BuildContext context, {
  required String roomId,
  String opponentName = 'Opponent',
  String? opponentId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ReportReasonSheet(
      roomId: roomId,
      opponentName: opponentName,
      opponentId: opponentId,
    ),
  );
}

// ─── Step 1: reason picker (bottom sheet) ───────────────────────────────────

class _ReportReasonSheet extends StatefulWidget {
  final String roomId;
  final String opponentName;
  final String? opponentId;
  const _ReportReasonSheet({
    required this.roomId,
    required this.opponentName,
    this.opponentId,
  });

  @override
  State<_ReportReasonSheet> createState() => _ReportReasonSheetState();
}

class _ReportReasonSheetState extends State<_ReportReasonSheet> {
  String? _reason;

  void _next() {
    if (_reason == null) return;
    final code = _reason!;
    final roomId = widget.roomId;
    final oppName = widget.opponentName;
    final oppId = widget.opponentId;
    final rootNav = Navigator.of(context, rootNavigator: true);
    Navigator.pop(context); // close reason sheet
    rootNav.push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => ReportDetailsScreen(
          roomId: roomId,
          opponentName: oppName,
          opponentId: oppId,
          reasonCode: code,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.opponentName.trim().isEmpty
        ? 'Opponent'
        : widget.opponentName.trim();
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report $name',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'What is happening? Pick the closest reason.',
                      style: TextStyle(color: C.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  children: [
                    for (final r in ReportReason.all) ...[
                      _ReasonRow(
                        label: r.label,
                        selected: _reason == r.code,
                        onTap: () => setState(() => _reason = r.code),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _reason == null ? null : _next,
                        style: FilledButton.styleFrom(
                          backgroundColor: C.magenta,
                          disabledBackgroundColor:
                              C.magenta.withValues(alpha: 0.35),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: C.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ReasonRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? C.magenta : C.border2,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected ? C.text : C.muted,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? C.magenta : C.border2,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: C.magenta,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Step 2: details screen ─────────────────────────────────────────────────

class ReportDetailsScreen extends StatefulWidget {
  final String roomId;
  final String opponentName;
  final String? opponentId;
  final String reasonCode;

  const ReportDetailsScreen({
    super.key,
    required this.roomId,
    required this.opponentName,
    required this.reasonCode,
    this.opponentId,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final _desc = TextEditingController();
  final List<Uint8List> _shots = [];
  bool _attachChat = true;
  bool _blockPlayer = true;
  bool _busy = false;
  String? _error;

  ReportReason get _reason =>
      ReportReason.byCode(widget.reasonCode) ?? ReportReason.all.first;

  @override
  void dispose() {
    _desc.dispose();
    super.dispose();
  }

  Future<void> _addShot() async {
    if (_shots.length >= 3) return;
    try {
      final bytes = await ModerationService.pickScreenshot();
      if (!mounted || bytes == null) return;
      setState(() => _shots.add(bytes));
    } catch (e) {
      setState(() => _error = AuthService.messageFromError(e));
    }
  }

  String _buildDescription() {
    final buf = StringBuffer(_desc.text.trim());
    if (_attachChat) {
      final msgs = GameChatService.messages.value;
      final take = msgs.length <= 20 ? msgs : msgs.sublist(msgs.length - 20);
      if (take.isNotEmpty) {
        buf.writeln('\n\n--- Recent chat (last ${take.length}) ---');
        final myId = AuthService.user?.id;
        for (final m in take) {
          final who = m.isMine(myId) ? 'You' : 'Opponent';
          buf.writeln('$who: ${m.message}');
        }
      }
    }
    return buf.toString();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (_desc.text.trim().length < 10) {
      setState(() =>
          _error = 'Please tell us what happened (at least 10 characters)');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final id = await ModerationService.submitReport(
      roomId: widget.roomId,
      reasonCode: widget.reasonCode,
      description: _buildDescription(),
      screenshots: _shots,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (id == null) {
      setState(() =>
          _error = ModerationService.error.value ?? 'Report failed');
      return;
    }
    final oid = widget.opponentId?.trim();
    if (_blockPlayer && oid != null && oid.isNotEmpty) {
      await AppStorage.blockPlayer(oid);
    }
    // Close chat + leave the live match, then go straight Home.
    await GameChatService.detach();
    final room = OnlineRealtimeService.state.value;
    if (room != null && !room.isFinished) {
      await OnlineRealtimeService.forfeit();
    }
    await OnlineRealtimeService.detach();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil('/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  _BackBox(onTap: () => Navigator.pop(context)),
                  const Expanded(
                    child: Text(
                      'REPORT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: C.magenta.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: C.magenta.withValues(alpha: 0.55)),
                        ),
                        child: Text(
                          _reason.label,
                          style: const TextStyle(
                            color: C.magenta,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: C.teal,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Change',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'WHAT HAPPENED',
                    style: TextStyle(
                      color: C.magenta,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                    decoration: BoxDecoration(
                      color: C.surface2,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _desc,
                          maxLines: 5,
                          maxLength: 500,
                          style: const TextStyle(color: C.text, height: 1.35),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText:
                                'Tell us what happened and why you are reporting this player',
                            hintStyle: TextStyle(color: C.muted, fontSize: 14),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_desc.text.length} / 500',
                            style: const TextStyle(
                                color: C.muted, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'SCREENSHOTS (OPTIONAL)',
                    style: TextStyle(
                      color: C.magenta,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (var i = 0; i < _shots.length; i++) ...[
                        _ShotThumb(
                          bytes: _shots[i],
                          onRemove: () =>
                              setState(() => _shots.removeAt(i)),
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (_shots.length < 3)
                        _AddShotSlot(onTap: _addShot),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Up to 3 images. Only our team can see them.',
                    style: TextStyle(color: C.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  _ToggleRow(
                    title: 'Attach recent chat messages',
                    subtitle:
                        'The last 20 messages are sent with your report.',
                    value: _attachChat,
                    onChanged: (v) => setState(() => _attachChat = v),
                  ),
                  const SizedBox(height: 10),
                  _ToggleRow(
                    title: 'Also block this player',
                    value: _blockPlayer,
                    onChanged: (v) => setState(() => _blockPlayer = v),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Text(_error!,
                        style: const TextStyle(color: C.danger, fontSize: 13)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _busy ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: C.magenta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _busy ? 'SUBMITTING…' : 'SUBMIT REPORT',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
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

class _BackBox extends StatelessWidget {
  final VoidCallback onTap;
  const _BackBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: C.border2),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
    );
  }
}

class _ShotThumb extends StatelessWidget {
  final Uint8List bytes;
  final VoidCallback onRemove;
  const _ShotThumb({required this.bytes, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: -6,
          top: -6,
          child: Material(
            color: C.magenta,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: const SizedBox(
                width: 22,
                height: 22,
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddShotSlot extends StatelessWidget {
  final VoidCallback onTap;
  const _AddShotSlot({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          painter: _DashedBorderPainter(color: C.border2, radius: 12),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: C.text, size: 22),
                SizedBox(height: 2),
                Text('Add',
                    style: TextStyle(color: C.muted, fontSize: 11)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()..addRRect(r);
    // Simple dashed via path metrics.
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = (d + 5).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(d, next), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(color: C.muted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: C.teal,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
