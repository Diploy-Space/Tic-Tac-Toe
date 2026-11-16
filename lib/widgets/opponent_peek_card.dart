import 'package:flutter/material.dart';

import '../models/challenge_args.dart';
import '../models/cloud_match.dart';
import '../models/friendship.dart';
import '../services/auth_service.dart';
import '../services/friend_repository.dart';
import '../services/match_repository.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import 'extras.dart';
import 'report_user_sheet.dart';

/// Shows [OpponentPeekCard] as a popover anchored under [link]
/// (a `CompositedTransformTarget` around the opponent's seat).
/// Tapping anywhere outside closes it. Returns the entry so callers can
/// remove it early (e.g. on dispose).
OverlayEntry showOpponentPeek(
  BuildContext context, {
  required LayerLink link,
  required bool alignRight,
  required String userId,
  required String name,
  String? avatarUrl,
  String? roomId,
}) {
  late OverlayEntry entry;
  void close() {
    if (entry.mounted) entry.remove();
  }

  entry = OverlayEntry(
    builder: (_) => Stack(children: [
      Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: close,
        ),
      ),
      CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        targetAnchor: alignRight ? Alignment.bottomRight : Alignment.bottomLeft,
        followerAnchor: alignRight ? Alignment.topRight : Alignment.topLeft,
        offset: const Offset(0, 8),
        child: Material(
          color: Colors.transparent,
          child: OpponentPeekCard(
            userId: userId,
            name: name,
            avatarUrl: avatarUrl,
            roomId: roomId,
            onClose: close,
          ),
        ),
      ),
    ]),
  );
  Overlay.of(context).insert(entry);
  return entry;
}

/// Compact opponent card: avatar, name, "#rank · pts · wins", Add + ⋯.
class OpponentPeekCard extends StatefulWidget {
  final String userId;
  final String name;
  final String? avatarUrl;
  final String? roomId;
  final VoidCallback onClose;
  const OpponentPeekCard({
    super.key,
    required this.userId,
    required this.name,
    required this.onClose,
    this.avatarUrl,
    this.roomId,
  });

  @override
  State<OpponentPeekCard> createState() => _OpponentPeekCardState();
}

class _OpponentPeekCardState extends State<OpponentPeekCard> {
  LeaderboardEntry? _stats;

  /// loading | none | pending | incoming | declined | friends
  String _friend = 'loading';
  String? _friendshipId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final me = AuthService.user?.id;
    LeaderboardEntry? stats;
    List<Friendship> mine = const [];
    await Future.wait([
      MatchRepository.fetchLeaderboardEntry(widget.userId)
          .then((v) => stats = v)
          .catchError((_) => null),
      if (me != null)
        FriendRepository.fetchMine()
            .then((v) => mine = v)
            .catchError((_) => const <Friendship>[]),
    ]);
    if (!mounted) return;
    var state = 'none';
    for (final f in mine) {
      if (f.otherUserId != widget.userId) continue;
      _friendshipId = f.id;
      if (f.status == 'accepted') {
        state = 'friends';
      } else if (f.status == 'pending') {
        state = f.requesterId == me ? 'pending' : 'incoming';
      } else {
        state = 'declined';
      }
    }
    setState(() {
      _stats = stats;
      _friend = state;
    });
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _add() async {
    if (_busy) return;
    if (!AuthService.isSignedIn) {
      _toast('Sign in to add friends');
      return;
    }
    setState(() => _busy = true);
    try {
      if (_friend == 'incoming' && _friendshipId != null) {
        await FriendRepository.accept(_friendshipId!);
        _friend = 'friends';
        _toast('You and ${widget.name} are now friends');
      } else {
        if (_friend == 'declined' && _friendshipId != null) {
          await FriendRepository.remove(_friendshipId!);
        }
        await FriendRepository.sendRequest(widget.userId);
        _friend = 'pending';
        _toast('Friend request sent to ${widget.name}');
      }
    } catch (e) {
      SfxService.play(Sfx.error);
      final msg = e.toString().replaceFirst('Exception: ', '');
      if (msg.contains('already exists')) _friend = 'pending';
      _toast(msg);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _more(BuildContext anchor) async {
    final box = anchor.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(anchor).context.findRenderObject() as RenderBox;
    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(box.size.bottomLeft(Offset.zero), ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final pick = await showMenu<String>(
      context: context,
      position: pos,
      color: C.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: C.border),
      ),
      items: [
        const PopupMenuItem(
          value: 'profile',
          child: Row(children: [
            Icon(Icons.person_outline, size: 20, color: C.muted),
            SizedBox(width: 10),
            Text('View profile'),
          ]),
        ),
        if (widget.roomId != null)
          const PopupMenuItem(
            value: 'report',
            child: Row(children: [
              Icon(Icons.outlined_flag, size: 20, color: C.danger),
              SizedBox(width: 10),
              Text('Report player'),
            ]),
          ),
      ],
    );
    if (!mounted || pick == null) return;
    final nav = Navigator.of(context);
    final ctx = context;
    widget.onClose();
    if (pick == 'profile') {
      final s = _stats;
      nav.pushNamed('/public-profile',
          arguments: PublicProfileArgs(
            userId: widget.userId,
            username: widget.name,
            avatarUrl: widget.avatarUrl,
            rank: s?.rank,
            score: s?.score,
            wins: s?.wins,
          ));
    } else if (pick == 'report' && ctx.mounted) {
      openReportUserSheet(ctx,
          roomId: widget.roomId!,
          opponentName: widget.name,
          opponentId: widget.userId);
    }
  }

  Widget _addButton() {
    final (label, icon, enabled) = switch (_friend) {
      'friends' => ('Friends', Icons.how_to_reg_outlined, false),
      'pending' => ('Sent', Icons.schedule, false),
      'incoming' => ('Accept', Icons.person_add_alt_1_outlined, true),
      'loading' => ('Add', Icons.person_add_alt_1_outlined, false),
      _ => ('Add', Icons.person_add_alt_1_outlined, true),
    };
    const ink = Color(0xFF04201F);
    return SizedBox(
      height: 36,
      child: FilledButton(
        onPressed: enabled && !_busy ? _add : null,
        style: FilledButton.styleFrom(
          backgroundColor: C.teal,
          foregroundColor: ink,
          disabledBackgroundColor: C.surface2,
          disabledForegroundColor: C.muted,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _busy
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: ink))
            : Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 18),
                const SizedBox(width: 6),
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _stats;
    final line = s == null
        ? (_friend == 'loading' ? 'Loading…' : 'Unranked')
        : '${s.rank > 0 ? '#${s.rank} · ' : ''}${s.score} pts · ${s.wins} wins';
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (_, v, child) => Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.scale(
              scale: .9 + .1 * v, alignment: Alignment.topCenter, child: child)),
      child: Container(
        width: 250,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: C.magenta, width: 1.5),
          boxShadow: [
            BoxShadow(
                color: C.magenta.withValues(alpha: .3), blurRadius: 18),
            const BoxShadow(color: Colors.black54, blurRadius: 12),
          ],
        ),
        child: Row(children: [
          ClipOval(child: ProfileAvatar(url: widget.avatarUrl, size: 40)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(line,
                    maxLines: 2,
                    style: const TextStyle(color: C.muted, fontSize: 11.5)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _addButton(),
          const SizedBox(width: 6),
          Builder(
            builder: (b) => InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _more(b),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: C.border2),
                ),
                child: const Icon(Icons.more_horiz, size: 18, color: C.muted),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
