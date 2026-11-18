import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Notification history (challenges, matches, coins, friends).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    NotificationService.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(
            l.notifications,
            trailing: ValueListenableBuilder<int>(
              valueListenable: NotificationService.unread,
              builder: (_, n, __) => n == 0
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: NotificationService.markAllRead,
                      child: Text(l.markAllRead,
                          style: const TextStyle(
                              color: C.teal, fontWeight: FontWeight.w700)),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: !AuthService.isSignedIn
                ? _Empty(text: l.signInNotifications)
                : ValueListenableBuilder<List<AppNotification>>(
                    valueListenable: NotificationService.items,
                    builder: (_, list, __) {
                      if (list.isEmpty) {
                        return _Empty(
                            text: l.noNotificationsYet,
                            hint: l.notifEmptyHint);
                      }
                      return RefreshIndicator(
                        color: C.magenta,
                        onRefresh: NotificationService.refresh,
                        child: ListView.separated(
                          itemCount: list.length + 1,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            if (i == list.length) {
                              return Center(
                                child: TextButton(
                                  onPressed: NotificationService.clearAll,
                                  child: Text(l.clearAll,
                                      style:
                                          const TextStyle(color: C.muted)),
                                ),
                              );
                            }
                            return NotificationTile(list[i]);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text, this.hint});
  final String text;
  final String? hint;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_none, color: C.muted, size: 48),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16)),
            if (hint != null) ...[
              const SizedBox(height: 6),
              Text(hint!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: C.muted, height: 1.35)),
            ],
          ],
        ),
      );
}

/// Icon + accent colour per notification kind.
(IconData, Color) notificationStyle(AppNotification n) => switch (n.type) {
      'challenge_request' => (Icons.sports_esports_outlined, C.magenta),
      'challenge_accepted' => (Icons.check_circle_outline, C.teal),
      'challenge_busy' => (Icons.hourglass_top_rounded, C.coin),
      'challenge_declined' ||
      'challenge_expired' ||
      'challenge_cancelled' =>
        (Icons.cancel_outlined, C.muted),
      'room_joined' => (Icons.meeting_room_outlined, C.teal),
      'match_result' => (Icons.emoji_events_outlined, C.coin),
      'coins_debit' => (Icons.remove_circle_outline, C.danger),
      'friend_request' || 'friend_accepted' => (Icons.person_add_alt, C.teal),
      _ when n.isCoins => (Icons.monetization_on_outlined, C.coin),
      _ => (Icons.notifications_none, C.muted),
    };

/// Icon for a notification; coin updates use the app's currency mark
/// (same symbol as the coin chip / wallet).
Widget notificationIcon(AppNotification n, double size) {
  final (icon, color) = notificationStyle(n);
  if (n.isCoins) return CurrencyMark(size: size * 0.9, color: color);
  return Icon(icon, color: color, size: size);
}

String timeAgo(BuildContext context, DateTime t) {
  final l = context.l10n;
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return l.timeJustNow;
  if (d.inHours < 1) return l.timeMinutesAgo('${d.inMinutes}');
  if (d.inDays < 1) return l.timeHoursAgo('${d.inHours}');
  return l.timeDaysAgo('${d.inDays}');
}

class NotificationTile extends StatelessWidget {
  const NotificationTile(this.n, {super.key});
  final AppNotification n;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (icon, color) = notificationStyle(n);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => NotificationService.open(n),
      child: AppCard(
        borderColor: n.isRead ? C.border : color.withValues(alpha: 0.55),
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: notificationIcon(n, 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(n.localizedTitle(l),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(width: 8),
                    Text(timeAgo(context, n.createdAt),
                        style: const TextStyle(color: C.muted, fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  Text(n.localizedBody(l),
                      style: const TextStyle(color: C.muted, height: 1.35)),
                ],
              ),
            ),
            if (!n.isRead) ...[
              const SizedBox(width: 8),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 8,
                height: 8,
                decoration:
                    const BoxDecoration(color: C.magenta, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Top banner for a new notification while the app is open.
class InAppNotificationBanner extends StatelessWidget {
  const InAppNotificationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppNotification?>(
      valueListenable: NotificationService.banner,
      builder: (context, n, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, a) => SlideTransition(
            position: Tween(begin: const Offset(0, -1), end: Offset.zero)
                .animate(a),
            child: FadeTransition(opacity: a, child: child),
          ),
          child: n == null
              ? const SizedBox.shrink(key: ValueKey('none'))
              : SafeArea(
                  key: ValueKey(n.id),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Dismissible(
                      key: ValueKey('d${n.id}'),
                      direction: DismissDirection.up,
                      onDismissed: (_) => NotificationService.hideBanner(),
                      child: Material(
                        color: Colors.transparent,
                        child: _BannerCard(n),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard(this.n);
  final AppNotification n;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final (icon, color) = notificationStyle(n);
    return GestureDetector(
      onTap: () => NotificationService.open(n),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.45), blurRadius: 16),
          ],
        ),
        child: Row(children: [
          SizedBox(
              width: 24,
              child: Center(child: notificationIcon(n, 24))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(n.localizedTitle(l),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: C.text, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(n.localizedBody(l),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: C.muted, fontSize: 13)),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

/// Details of one notification + a button to the related screen.
class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final a = ModalRoute.of(context)?.settings.arguments;
    final n = a is AppNotification ? a : null;
    if (n == null) {
      return AppScaffold(
          child: Column(children: [
        TopBar(l.notifications),
        Expanded(child: _Empty(text: l.notifGeneric)),
      ]));
    }
    final (icon, color) = notificationStyle(n);
    final ml = MaterialLocalizations.of(context);
    final when = '${ml.formatMediumDate(n.createdAt)} · '
        '${ml.formatTimeOfDay(TimeOfDay.fromDateTime(n.createdAt))}';
    final route = n.route;
    final action = switch (route) {
      '/wallet' => l.wallet,
      '/challenges' => l.challenges,
      '/friends' => l.friendsLabel,
      '/match-history' => l.matchHistory,
      _ => null,
    };
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(l.notifications),
          const SizedBox(height: 24),
          AppCard(
            borderColor: color.withValues(alpha: 0.6),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: notificationIcon(n, 34),
                ),
                const SizedBox(height: 16),
                Text(n.localizedTitle(l),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 20)),
                const SizedBox(height: 10),
                Text(n.localizedBody(l),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: C.text, fontSize: 15, height: 1.4)),
                const SizedBox(height: 14),
                Text(when,
                    style: const TextStyle(color: C.muted, fontSize: 12)),
              ],
            ),
          ),
          const Spacer(),
          if (action != null)
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, route),
                style: FilledButton.styleFrom(
                  backgroundColor: C.magenta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(action,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
        ],
      ),
    );
  }
}
