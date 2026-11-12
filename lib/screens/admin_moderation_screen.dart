import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Lightweight admin console (RPC-gated via profiles.is_admin). No separate app.
class AdminModerationScreen extends StatefulWidget {
  const AdminModerationScreen({super.key});

  @override
  State<AdminModerationScreen> createState() => _AdminModerationScreenState();
}

class _AdminModerationScreenState extends State<AdminModerationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  List<Map<String, dynamic>> _reports = const [];
  List<Map<String, dynamic>> _appeals = const [];
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final db = Supabase.instance.client;
      final rRaw = await db.rpc('admin_list_reports', params: {'p_limit': 50});
      final aRaw = await db.rpc('admin_list_appeals', params: {'p_limit': 50});
      final r = _asMap(rRaw);
      final a = _asMap(aRaw);
      if (r == null || '${r['status']}' != 'ok') {
        throw Exception(r?['message'] ?? 'Cannot load reports');
      }
      if (a == null || '${a['status']}' != 'ok') {
        throw Exception(a?['message'] ?? 'Cannot load appeals');
      }
      setState(() {
        _reports = _listOfMaps(r['reports']);
        _appeals = _listOfMaps(a['appeals']);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = AuthService.messageFromError(e);
      });
    }
  }

  Future<void> _suspend(Map<String, dynamic> report) async {
    final reason = await _askText('Suspend reason',
        initial: '${report['reason'] ?? 'Policy violation'}');
    if (reason == null || reason.trim().isEmpty) return;
    try {
      final raw = await Supabase.instance.client.rpc(
        'admin_suspend_user',
        params: {
          'p_user_id': report['reported_user_id'],
          'p_reason': reason.trim(),
          'p_report_id': report['id'],
          'p_admin_notes': null,
        },
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        throw Exception(map?['message'] ?? 'Suspend failed');
      }
      _toast('User suspended');
      await _load();
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    }
  }

  Future<void> _setReportStatus(Map<String, dynamic> report, String status) async {
    try {
      final raw = await Supabase.instance.client.rpc(
        'admin_update_report',
        params: {
          'p_report_id': report['id'],
          'p_status': status,
          'p_admin_notes': null,
        },
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        throw Exception(map?['message'] ?? 'Update failed');
      }
      await _load();
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    }
  }

  Future<void> _reviewAppeal(Map<String, dynamic> appeal, String decision) async {
    final notes = await _askText('Admin notes (optional)', initial: '');
    try {
      final raw = await Supabase.instance.client.rpc(
        'admin_review_appeal',
        params: {
          'p_appeal_id': appeal['id'],
          'p_decision': decision,
          'p_admin_notes': notes,
        },
      );
      final map = _asMap(raw);
      if (map == null || '${map['status']}' != 'ok') {
        throw Exception(map?['message'] ?? 'Review failed');
      }
      _toast(decision == 'approved' ? 'Appeal approved — account reinstated' : 'Appeal rejected');
      await _load();
    } catch (e) {
      _toast(AuthService.messageFromError(e));
    }
  }

  Future<String?> _askText(String title, {required String initial}) async {
    final c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: C.surface,
        title: Text(title),
        content: TextField(
          controller: c,
          maxLines: 3,
          style: const TextStyle(color: C.text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: C.muted))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, c.text),
              child: const Text('OK', style: TextStyle(color: C.pinkText))),
        ],
      ),
    );
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        children: [
          const TopBar('Admin moderation'),
          TabBar(
            controller: _tabs,
            labelColor: C.teal,
            unselectedLabelColor: C.muted,
            tabs: const [Tab(text: 'Reports'), Tab(text: 'Appeals')],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!, style: const TextStyle(color: C.magenta)),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabs,
                    children: [
                      _reportsList(),
                      _appealsList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _reportsList() {
    if (_reports.isEmpty) {
      return const Center(child: Text('No reports', style: TextStyle(color: C.muted)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final r = _reports[i];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${r['reason']} · ${r['status']}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Reporter: ${r['reporter_username'] ?? r['reporter_id']}\n'
                'Reported: ${r['reported_username'] ?? r['reported_user_id']}\n'
                'Room: ${r['room_id']}\n'
                '${r['description']}',
                style: const TextStyle(color: C.muted, height: 1.35, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text('Evidence: ${r['screenshot_path']}',
                  style: const TextStyle(color: C.muted, fontSize: 11)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () => _setReportStatus(r, 'under_review'),
                    child: const Text('Under review'),
                  ),
                  TextButton(
                    onPressed: () => _setReportStatus(r, 'dismissed'),
                    child: const Text('Dismiss'),
                  ),
                  TextButton(
                    onPressed: () => _suspend(r),
                    child: const Text('Suspend user',
                        style: TextStyle(color: C.danger)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _appealsList() {
    if (_appeals.isEmpty) {
      return const Center(child: Text('No appeals', style: TextStyle(color: C.muted)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _appeals.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final a = _appeals[i];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${a['username']} · ${a['status']}',
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Suspension: ${a['suspension_reason']}\n${a['appeal_message']}',
                style: const TextStyle(color: C.muted, height: 1.35, fontSize: 13),
              ),
              if ('${a['status']}' == 'pending' ||
                  '${a['status']}' == 'under_review')
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _reviewAppeal(a, 'approved'),
                      child: const Text('Approve',
                          style: TextStyle(color: C.teal)),
                    ),
                    TextButton(
                      onPressed: () => _reviewAppeal(a, 'rejected'),
                      child: const Text('Reject',
                          style: TextStyle(color: C.danger)),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
