import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../l10n/app_localizations.dart';
import '../models.dart';
import 'app_locale_service.dart';
import 'auth_service.dart';
import 'wallet_service.dart';

/// One row of `public.notifications`.
class AppNotification {
  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    this.readAt,
  });

  final String id;
  final String type;
  final String title; // English fallback from the server
  final String body;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  DateTime? readAt;

  bool get isRead => readAt != null;

  factory AppNotification.fromRow(Map<String, dynamic> r) => AppNotification(
        id: '${r['id']}',
        type: '${r['type'] ?? ''}',
        title: '${r['title'] ?? ''}',
        body: '${r['body'] ?? ''}',
        data: r['data'] is Map
            ? Map<String, dynamic>.from(r['data'] as Map)
            : const <String, dynamic>{},
        createdAt:
            DateTime.tryParse('${r['created_at'] ?? ''}')?.toLocal() ??
                DateTime.now(),
        readAt: DateTime.tryParse('${r['read_at'] ?? ''}')?.toLocal(),
      );

  String get _name => '${data['name'] ?? ''}';
  String get _amount => '${data['amount'] ?? ''}';
  String get _balance => '${data['balance'] ?? ''}';

  bool get isCoins => type.startsWith('coins_');
  bool get isChallenge => type.startsWith('challenge_');

  /// Title in the app's language (same keys as the push templates).
  String localizedTitle(L10n l) => switch (type) {
        'challenge_request' => l.notifChallengeRequestTitle,
        'challenge_accepted' => l.notifChallengeAcceptedTitle,
        'challenge_declined' => l.notifChallengeDeclinedTitle,
        'challenge_busy' => l.notifChallengeBusyTitle,
        'challenge_expired' => l.notifChallengeExpiredTitle,
        'challenge_cancelled' => l.notifChallengeCancelledTitle,
        'room_joined' => l.notifRoomJoinedTitle,
        'match_result' => switch ('${data['result']}') {
            'win' => l.notifMatchWonTitle,
            'loss' => l.notifMatchLostTitle,
            _ => l.notifMatchDrawTitle,
          },
        'coins_debit' => l.notifCoinsDebitTitle,
        'coins_purchase' => l.notifCoinsPurchaseTitle,
        'coins_reward' => l.notifCoinsRewardTitle,
        'coins_credit' => l.notifCoinsCreditTitle,
        'friend_request' => l.notifFriendRequestTitle,
        'friend_accepted' => l.notifFriendAcceptedTitle,
        _ => title.isNotEmpty ? title : l.notifGeneric,
      };

  String localizedBody(L10n l) => switch (type) {
        'challenge_request' => l.notifChallengeRequestBody(_name),
        'challenge_accepted' => l.notifChallengeAcceptedBody(_name),
        'challenge_declined' => l.notifChallengeDeclinedBody(_name),
        'challenge_busy' => l.notifChallengeBusyBody(_name),
        'challenge_expired' => l.notifChallengeExpiredBody(_name),
        'challenge_cancelled' => l.notifChallengeCancelledBody(_name),
        'room_joined' => l.notifRoomJoinedBody(_name),
        'match_result' => l.notifMatchBody(_name),
        'coins_debit' => l.notifCoinsDebitBody(_amount, _balance),
        'coins_purchase' ||
        'coins_credit' =>
          l.notifCoinsAddedBody(_amount, _balance),
        'coins_reward' => l.notifCoinsRewardBody(_amount, _balance),
        'friend_request' => l.notifFriendRequestBody(_name),
        'friend_accepted' => l.notifFriendAcceptedBody(_name),
        _ => body,
      };

  /// Route opened when the notification is tapped.
  String get route => switch (type) {
        'challenge_request' ||
        'challenge_accepted' ||
        'challenge_declined' ||
        'challenge_busy' ||
        'challenge_expired' ||
        'challenge_cancelled' =>
          '/challenges',
        'match_result' => '/match-history',
        'friend_request' || 'friend_accepted' => '/friends',
        _ when isCoins => '/wallet',
        _ => '/notifications',
      };
}

/// Central notification system.
///
/// - History: `public.notifications` (created by DB triggers for challenges,
///   room joins, online results, every wallet transaction, friends).
/// - In-app: Realtime INSERTs → [items] / [unread] + a top [banner].
/// - Push: FCM token in `public.push_tokens`; the `send-push` Edge Function
///   delivers while the app is in background or closed.
class NotificationService {
  NotificationService._();

  static final ValueNotifier<List<AppNotification>> items =
      ValueNotifier<List<AppNotification>>(const []);
  static final ValueNotifier<int> unread = ValueNotifier<int>(0);

  /// Latest notification to show as an in-app banner (null = hidden).
  static final ValueNotifier<AppNotification?> banner =
      ValueNotifier<AppNotification?>(null);

  /// Set by the app: opens a route for a tapped notification / push.
  /// Set by the app: shows a tapped notification (banner, history row,
  /// system push) — challenge popup or the details page.
  static void Function(AppNotification n)? onOpen;

  /// Set by the app: true while the player is inside a match (no banners for
  /// coin updates then — they still land in history).
  static bool Function()? isInMatch;

  static bool _initDone = false;
  static bool pushAvailable = false;
  static RealtimeChannel? _channel;
  static String? _uid;
  static String? _token;
  static final _local = FlutterLocalNotificationsPlugin();
  static final List<StreamSubscription> _subs = [];
  static Timer? _bannerTimer;

  static SupabaseClient get _db => AuthService.client;

  /// Types the app already shows in its own UI (challenge popup / lobby /
  /// challenger snackbar) — no extra banner for those.
  static const _noBannerTypes = {
    'challenge_request',
    'challenge_accepted',
    'challenge_declined',
    'challenge_busy',
    'challenge_expired',
    'challenge_cancelled',
  };

  // ---- setup --------------------------------------------------------------

  /// Once per app start. Safe without Firebase config (push stays off).
  static Future<void> init() async {
    if (_initDone) return;
    _initDone = true;
    await _initLocal();
    await _initFirebase();
    notificationsOn.addListener(_onToggle);
    AppLocaleService.languageCode.addListener(_onLanguage);
  }

  static Future<void> _initLocal() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
    try {
      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          final p = r.payload;
          if (p == null) return;
          try {
            final m = Map<String, dynamic>.from(jsonDecode(p) as Map);
            unawaited(_openData(m));
          } catch (_) {}
        },
      );
      await _createChannel();
    } catch (e) {
      debugPrint('NotificationService local init: $e');
    }
  }

  /// Channel the FCM pushes use (AndroidManifest default + send-push).
  static Future<void> _createChannel() async {
    final android = _local.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(AndroidNotificationChannel(
      'drotix_events',
      l10nNow.notifChannelName,
      description: l10nNow.notifChannelDesc,
      importance: Importance.high,
    ));
  }

  static Future<void> _initFirebase() async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
    try {
      await Firebase.initializeApp();
      pushAvailable = true;
    } catch (e) {
      // No google-services.json / GoogleService-Info.plist yet.
      debugPrint('Push disabled (Firebase not configured): $e');
      return;
    }
    final fm = FirebaseMessaging.instance;
    // Classic FCM registration token (works with the HTTP v1 `token` field).
    // ignore: deprecated_member_use
    _subs.add(fm.onTokenRefresh.listen((t) {
      _token = t;
      unawaited(_registerToken());
    }));
    _subs.add(FirebaseMessaging.onMessage.listen(_onForegroundPush));
    _subs.add(FirebaseMessaging.onMessageOpenedApp
        .listen((m) => unawaited(_openData(_payload(m)))));
    if (kDebugMode) {
      // Debug builds only: copy this token into Firebase Console →
      // Messaging → "Send test message" to push to this phone.
      unawaited(() async {
        try {
          await fm.requestPermission(alert: true, badge: true, sound: true);
          // ignore: deprecated_member_use
          final t = await fm.getToken();
          debugPrint('FCM TOKEN: $t');
        } catch (e) {
          debugPrint('FCM TOKEN error: $e');
        }
      }());
    }
    try {
      final initial = await fm.getInitialMessage(); // tapped while closed
      if (initial != null) {
        Future.delayed(const Duration(milliseconds: 900),
            () => unawaited(_openData(_payload(initial))));
      }
    } catch (_) {}
  }

  /// App open. Our own notifications (with a history `id`) already arrive via
  /// Realtime as an in-app banner; anything else (e.g. a Firebase Console
  /// campaign) is shown as a system notification, because Android does not
  /// display FCM notifications while the app is in the foreground.
  static void _onForegroundPush(RemoteMessage m) {
    if ((m.data['id'] ?? '').toString().isNotEmpty) {
      unawaited(refresh());
      return;
    }
    final n = m.notification;
    if (n == null || !notificationsOn.value) return;
    unawaited(_local
        .show(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000 % 0x7fffffff,
          title: n.title,
          body: n.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'drotix_events',
              l10nNow.notifChannelName,
              channelDescription: l10nNow.notifChannelDesc,
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
                presentAlert: true, presentSound: true),
          ),
          payload: jsonEncode(_payload(m)),
        )
        .catchError((Object e) => debugPrint('local notification: $e')));
  }

  // ---- session ------------------------------------------------------------

  /// After sign-in: history, realtime, push token.
  static Future<void> start() async {
    final uid = AuthService.user?.id;
    if (uid == null) return;
    if (_uid == uid && _channel != null) {
      // Firebase may have finished initialising since the first start().
      await _registerToken();
      return;
    }
    await _unsubscribe();
    _uid = uid;
    await refresh();
    _channel = _db.channel('notifications-$uid')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: uid,
        ),
        callback: (p) => _onInsert(p.newRecord),
      )
      ..subscribe();
    await _registerToken();
  }

  /// Before sign-out (still authenticated): this device stops receiving
  /// pushes for the account.
  static Future<void> beforeSignOut() async {
    final t = _token;
    if (t == null || !AuthService.isSignedIn) return;
    try {
      await _db.rpc('unregister_push_token', params: {'p_token': t});
    } catch (e) {
      debugPrint('unregister_push_token: $e');
    }
  }

  /// After sign-out.
  static Future<void> clear() async {
    await _unsubscribe();
    _uid = null;
    items.value = const [];
    unread.value = 0;
    banner.value = null;
  }

  static Future<void> _unsubscribe() async {
    final c = _channel;
    _channel = null;
    if (c != null) {
      try {
        await _db.removeChannel(c);
      } catch (_) {}
    }
  }

  static Future<void> refresh() async {
    final uid = AuthService.user?.id;
    if (uid == null) return;
    try {
      final rows = await _db
          .from('notifications')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false)
          .limit(100);
      items.value = List.unmodifiable([
        for (final r in rows as List)
          AppNotification.fromRow(Map<String, dynamic>.from(r as Map)),
      ]);
      _recount();
    } catch (e) {
      debugPrint('NotificationService.refresh: $e');
    }
  }

  // ---- push token -----------------------------------------------------------

  static Future<void> _registerToken() async {
    if (!pushAvailable || !AuthService.isSignedIn) return;
    if (!notificationsOn.value) return;
    try {
      final fm = FirebaseMessaging.instance;
      final perm = await fm.requestPermission(
          alert: true, badge: true, sound: true);
      if (perm.authorizationStatus == AuthorizationStatus.denied) return;
      // ignore: deprecated_member_use
      _token ??= await fm.getToken();
      final t = _token;
      if (t == null) return;
      await _db.rpc('register_push_token', params: {
        'p_token': t,
        'p_platform': Platform.isIOS ? 'ios' : 'android',
        'p_locale': AppLocaleService.languageCode.value,
      });
    } catch (e) {
      debugPrint('register_push_token: $e');
    }
  }

  static void _onToggle() {
    if (notificationsOn.value) {
      unawaited(_registerToken());
    } else {
      unawaited(beforeSignOut());
    }
  }

  /// Push texts follow the app language.
  static void _onLanguage() {
    unawaited(_registerToken());
    unawaited(_createChannel().catchError((_) {}));
  }

  // ---- in-app ---------------------------------------------------------------

  static void _onInsert(Map<String, dynamic> row) {
    final n = AppNotification.fromRow(row);
    if (items.value.any((e) => e.id == n.id)) return;
    items.value = List.unmodifiable([n, ...items.value]);
    _recount();
    if (n.isCoins) unawaited(WalletService.refresh());
    if (!notificationsOn.value) return;
    if (_noBannerTypes.contains(n.type)) return;
    if (n.isCoins && (isInMatch?.call() ?? false)) return;
    showBanner(n);
  }

  static void showBanner(AppNotification n) {
    _bannerTimer?.cancel();
    banner.value = n;
    _bannerTimer = Timer(const Duration(seconds: 4), hideBanner);
  }

  static void hideBanner() {
    _bannerTimer?.cancel();
    banner.value = null;
  }

  static void open(AppNotification n) {
    hideBanner();
    unawaited(markRead([n.id]));
    onOpen?.call(n);
  }

  /// Tapped system push: use the stored row when we have it (exact time,
  /// texts), otherwise build one from the push payload.
  static Future<void> _openData(Map<String, dynamic> data) async {
    final id = '${data['id'] ?? ''}';
    AppNotification? n;
    if (id.isNotEmpty) {
      n = _find(id);
      if (n == null && AuthService.isSignedIn) {
        await refresh();
        n = _find(id);
      }
      unawaited(markRead([id]));
    }
    n ??= AppNotification(
      id: id,
      type: '${data['type'] ?? ''}',
      title: '${data['title'] ?? ''}',
      body: '${data['body'] ?? ''}',
      data: data,
      createdAt: DateTime.now(),
    );
    onOpen?.call(n);
  }

  /// Push data plus its visible title/body (Console messages carry no
  /// history row, so the details page shows these).
  static Map<String, dynamic> _payload(RemoteMessage m) => {
        ...m.data,
        if (m.notification?.title != null) 'title': m.notification!.title,
        if (m.notification?.body != null) 'body': m.notification!.body,
      };

  static AppNotification? _find(String id) {
    for (final e in items.value) {
      if (e.id == id) return e;
    }
    return null;
  }

  static void _recount() {
    unread.value = items.value.where((n) => !n.isRead).length;
  }

  static Future<void> markRead(List<String> ids) async {
    var changed = false;
    for (final n in items.value) {
      if (ids.contains(n.id) && !n.isRead) {
        n.readAt = DateTime.now();
        changed = true;
      }
    }
    if (changed) {
      items.value = List.unmodifiable([...items.value]);
      _recount();
    }
    if (!AuthService.isSignedIn || ids.isEmpty) return;
    try {
      await _db.rpc('mark_notifications_read', params: {'p_ids': ids});
    } catch (e) {
      debugPrint('mark_notifications_read: $e');
    }
  }

  static Future<void> markAllRead() async {
    for (final n in items.value) {
      n.readAt ??= DateTime.now();
    }
    items.value = List.unmodifiable([...items.value]);
    _recount();
    if (!AuthService.isSignedIn) return;
    try {
      await _db.rpc('mark_notifications_read');
    } catch (e) {
      debugPrint('mark_notifications_read(all): $e');
    }
  }

  static Future<void> clearAll() async {
    items.value = const [];
    _recount();
    if (!AuthService.isSignedIn) return;
    try {
      await _db.rpc('clear_my_notifications');
    } catch (e) {
      debugPrint('clear_my_notifications: $e');
    }
  }

  /// Tests only.
  @visibleForTesting
  static void debugInsert(Map<String, dynamic> row) => _onInsert(row);
}
