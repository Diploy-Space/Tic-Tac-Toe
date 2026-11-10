import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';

class PublicProfileScreen extends StatefulWidget {
  final String userId;
  const PublicProfileScreen({super.key, required this.userId});

  @override
  State<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  UserProfile? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final p = await ProfileService.loadPublic(widget.userId);
      if (!mounted) return;
      setState(() {
        _profile = p;
        _loading = false;
        if (p == null) _error = 'Profile not found';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: staggered([
          const TopBar('Player'),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            AppCard(
              child: Text(_error!, style: const TextStyle(color: C.muted)),
            )
          else if (_profile != null)
            AppCard(
              borderColor: C.magenta,
              child: Column(
                children: [
                  Row(
                    children: [
                      ProfileAvatar(
                        url: _profile!.avatarUrl,
                        size: 64,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Tag('Public profile'),
                            Text(
                              _profile!.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Joined ${_profile!.createdAt.toLocal().toString().split(' ').first}',
                    style: const TextStyle(color: C.muted, fontSize: 13),
                  ),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}
