import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';
import 'models.dart';
import 'services/sfx_service.dart';
import 'services/app_locale_service.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'services/storage.dart';
import 'theme.dart';
import 'screens/landing_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/public_profile_screen.dart';
import 'screens/history_screen.dart';
import 'screens/match_history_screen.dart';
import 'screens/language_screen.dart';
import 'screens/more_games_screen.dart';
import 'screens/contact_about_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'screens/app_update_screen.dart';
import 'services/app_update_service.dart';
import 'screens/logo_screen.dart' show LogoScreen, LogoSplashScreen;
import 'screens/intro_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_code_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/offline_screen.dart';
import 'screens/daily_reward_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/tournament_screen.dart';
import 'screens/customize_screen.dart';
import 'screens/matching_screen.dart';
import 'screens/offline_ai_picker_screen.dart';
import 'screens/online_matching_screen.dart';
import 'screens/online_game_screen.dart';
import 'screens/private_room_lobby_screen.dart';
import 'screens/join_private_room_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/account_suspension_screen.dart';
import 'screens/appeal_submission_screen.dart';
import 'screens/appeal_under_review_screen.dart';
import 'screens/admin_moderation_screen.dart';
import 'screens/admin_tournament_screen.dart';
import 'screens/challenge_stake_screen.dart';
import 'screens/challenge_waiting_screen.dart';
import 'screens/challenge_incoming_screen.dart';
import 'screens/challenges_list_screen.dart';
import 'screens/match_lobby_screen.dart';
import 'screens/match_connection_screens.dart';
import 'screens/challenge_privacy_screen.dart';
import 'screens/chat_rules_screen.dart';
import 'screens/ephemeral_chat_demo_screen.dart';
import 'screens/tournament_flow_screens.dart';
import 'screens/shop_reward_flow_screens.dart';
import 'screens/ad_placement_screen.dart';
import 'screens/referral_code_screen.dart';
import 'screens/referral_success_screen.dart';
import 'services/referral_service.dart';
import 'models/challenge_args.dart';
import 'models/moderation_models.dart';
import 'services/moderation_service.dart';
import 'services/rewarded_ad_service.dart';
import 'services/privacy_prefs_service.dart';
import 'services/challenge_flow_service.dart';
import 'services/notification_service.dart';
import 'screens/notifications_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await AppStorage.init();
  PrivacyPrefsService.bind();
  await AppLocaleService.init();
  await AuthService.init();
  await ConnectivityService.instance.init();
  // Fire-and-forget so cold start is not blocked by AdMob.
  unawaited(RewardedAdService.instance.init());
  unawaited(PrivacyPrefsService.refresh());
  unawaited(SfxService.init());
  // Local channel + FCM (push is skipped until Firebase is configured).
  unawaited(NotificationService.init().then((_) {
    if (AuthService.isSignedIn) return NotificationService.start();
  }));
  runApp(const TicTacApp());
}

class TicTacApp extends StatefulWidget {
  const TicTacApp({super.key});
  @override
  State<TicTacApp> createState() => _TicTacAppState();
}

class _TicTacAppState extends State<TicTacApp> {
  final _nav = GlobalKey<NavigatorState>();
  bool _incomingOpen = false;
  late final NavigatorObserver _challengeNavObserver;

  /// Only these screens may be replaced by post-login `/home` redirect.
  static const _authEntryRoutes = {
    '/',
    '/signin',
    '/signup',
    '/verify',
    '/forgot',
    '/intro',
    '/logo',
    '/referral-code',
  };

  /// In-app play routes — never clear the stack on re-emitted SIGNED_IN.
  static const _protectFromAuthRedirect = {
    '/home',
    '/online-matching',
    '/online-room',
    '/private-room-lobby',
    '/join-private-room',
    '/scan-private-room',
    '/edit-profile',
    '/wallet',
    '/offline-ai-picker',
    '/matching',
    '/game',
    '/profile',
    '/friends',
    '/ranks',
    '/history',
    '/match-history',
    '/stats',
    '/settings',
    '/shop',
    '/missions',
    '/achievements',
    '/daily',
    '/events',
    '/customize',
    '/account-suspended',
    '/appeal-submit',
    '/appeal-under-review',
    '/admin-moderation',
    '/admin-tournament',
    '/challenge-stake',
    '/challenge-waiting',
    '/challenge-incoming',
    '/challenges',
    '/notifications',
    '/notification',
    '/match-lobby',
    '/connection-unstable',
    '/match-abandoned',
    '/match-result',
    '/challenge-privacy',
    '/chat-rules',
    '/ephemeral-chat',
    '/how-to-play',
    '/tournament-join-confirm',
    '/tournament-joined',
    '/tournament-bracket',
    '/tournament-ready',
    '/tournament-match',
    '/tournament-round-result',
    '/tournament-champion',
    '/ad-placement',
    '/reward-flow',
    '/shop-ad-loading',
    '/shop-ad-player',
    '/shop-ad-verifying',
    '/shop-reward-earned',
    '/shop-daily-limit',
    '/shop-no-video',
    '/shop-verify-fail',
    '/referral-code',
    '/referral-success',
  };

  static const _moderationRoutes = {
    '/account-suspended',
    '/appeal-submit',
    '/appeal-under-review',
  };

  String? _currentRouteName() {
    final nav = _nav.currentState;
    if (nav == null) return null;
    // Prefer ModalRoute name from navigator context (safer than popUntil).
    final ctx = _nav.currentContext;
    if (ctx != null) {
      final named = ModalRoute.of(ctx)?.settings.name;
      if (named != null) return named;
    }
    String? name;
    nav.popUntil((route) {
      name = route.settings.name;
      return true;
    });
    return name;
  }

  @override
  void dispose() {
    ChallengeFlowService.setIncomingHandler(null);
    ChallengeFlowService.setOutgoingResolvedHandler(null);
    ConnectivityService.instance.dispose();
    super.dispose();
  }

  String _destinationForModeration(ModerationStatus? s) {
    if (s?.accountStatus == AccountStatus.suspended) {
      return '/account-suspended';
    }
    if (s?.accountStatus == AccountStatus.underReview ||
        (s?.hasActiveAppeal ?? false)) {
      return '/appeal-under-review';
    }
    return '/home';
  }

  /// First run → intro. Signed in → Home. Otherwise → Landing.
  static String get _startRoute {
    if (!introSeen.value) return '/intro';
    return AuthService.isSignedIn ? '/home' : '/';
  }

  /// On launch: if this version is below the minimum supported one in
  /// Supabase `update.json`, block the app with the update screen.
  /// Returns true when the app was blocked for a required update.
  Future<bool> _checkRequiredUpdate() async {
    if (!AppUpdateService.supported) return false;
    try {
      final r = await AppUpdateService.check();
      if (r.isRequired) {
        _nav.currentState?.pushNamedAndRemoveUntil('/app-update', (_) => false,
            arguments: r);
        return true;
      }
    } catch (e) {
      debugPrint('Startup update check: $e');
    }
    return false;
  }

  /// Opened straight into Home: still send suspended / under-review
  /// accounts to their moderation screen.
  Future<void> _checkModerationOnStart() async {
    if (_startRoute != '/home') return;
    try {
      final status =
          ModerationService.status.value ?? await ModerationService.refresh();
      final dest = _destinationForModeration(status);
      if (dest != '/home') {
        _nav.currentState?.pushNamedAndRemoveUntil(dest, (r) => false);
      }
    } catch (e) {
      debugPrint('Start moderation check: $e');
    }
  }

  Future<void> _routeSignedIn() async {
    final route = _currentRouteName();
    debugPrint('Auth signedIn; currentRoute=$route');
    if (route != null && _moderationRoutes.contains(route)) return;
    if (route != null && _protectFromAuthRedirect.contains(route)) return;

    final status =
        ModerationService.status.value ?? await ModerationService.refresh();
    var dest = _destinationForModeration(status);
    if (dest == '/home' && await ReferralService.shouldShowPrompt()) {
      dest = '/referral-code';
    }
    if (route != null && _authEntryRoutes.contains(route)) {
      _nav.currentState?.pushNamedAndRemoveUntil(dest, (r) => false);
    }
  }

  void _syncChallengeBusy() {
    final route = _currentRouteName();
    final busy =
        route != null && ChallengeFlowService.busyRoutes.contains(route);
    ChallengeFlowService.setBusyClient(busy);
  }

  void _presentIncomingChallenge(ChallengeItem c) {
    final route = _currentRouteName();
    final busy =
        route != null && ChallengeFlowService.busyRoutes.contains(route);
    ChallengeFlowService.setBusyClient(busy);
    if (busy) {
      // In a match: no popup; the challenger is told this player is busy.
      unawaited(ChallengeFlowService.declineBusy(c.id));
      return;
    }
    if (route == '/challenge-incoming' || _incomingOpen) return;
    final nav = _nav.currentState;
    if (nav == null) return;
    _incomingOpen = true;
    SfxService.play(Sfx.challengeIncoming);
    nav
        .pushNamed('/challenge-incoming', arguments: c)
        .whenComplete(() => _incomingOpen = false);
  }

  @override
  void initState() {
    super.initState();
    _challengeNavObserver = _ChallengeNavObserver(onChange: _syncChallengeBusy);
    ChallengeFlowService.setIncomingHandler(_presentIncomingChallenge);
    NotificationService.onOpen = (n) async {
      final nav = _nav.currentState;
      if (nav == null) return;
      // Never pull the player out of a running match.
      final cur = _currentRouteName();
      if (cur != null && ChallengeFlowService.busyRoutes.contains(cur)) return;
      // Still-open challenge → straight to the Accept / Decline popup.
      if (n.type == 'challenge_request' && AuthService.isSignedIn) {
        final id = '${n.data['challenge_id'] ?? ''}';
        await ChallengeFlowService.refresh();
        for (final c in ChallengeFlowService.items.value) {
          if (c.id == id &&
              !c.outgoing &&
              c.status == ChallengeItemStatus.pending &&
              c.secondsLeft > 0) {
            if (_currentRouteName() == '/challenge-incoming' || _incomingOpen) {
              return;
            }
            _incomingOpen = true;
            _nav.currentState
                ?.pushNamed('/challenge-incoming', arguments: c)
                .whenComplete(() => _incomingOpen = false);
            return;
          }
        }
      }
      _nav.currentState?.pushNamed('/notification', arguments: n);
    };
    NotificationService.isInMatch = () {
      final cur = _currentRouteName();
      return cur != null && ChallengeFlowService.busyRoutes.contains(cur);
    };
    ChallengeFlowService.setOutgoingResolvedHandler((c) {
      final route = _currentRouteName();
      if (route == '/challenge-waiting') return;
      if (c.status == ChallengeItemStatus.accepted) {
        // No "accepted" toast: the challenger goes straight into the match.
        final busy =
            route != null && ChallengeFlowService.busyRoutes.contains(route);
        if (c.roomId != null && !busy) {
          SfxService.play(Sfx.matchFound);
          _nav.currentState
              ?.pushNamed('/match-lobby', arguments: c.lobbyArgs());
        }
        return;
      }
      final ctx = _nav.currentContext;
      if (ctx == null) return;
      final msg = switch (c.status) {
        ChallengeItemStatus.declined when c.declinedBusy =>
          l10nNow.notifChallengeBusyBody(c.opponentName),
        ChallengeItemStatus.declined => l10nNow.challengeDeclined,
        ChallengeItemStatus.expired => l10nNow.challengeExpired,
        ChallengeItemStatus.cancelled => l10nNow.challengeCancelled,
        _ => null,
      };
      if (msg == null) return;
      SfxService.play(Sfx.notification);
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
    });
    if (AuthService.isSignedIn) {
      unawaited(ChallengeFlowService.start());
    }
    ModerationService.onForceSuspended = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nav.currentState?.pushNamedAndRemoveUntil('/', (r) => false);
        final ctx = _nav.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(l10nNow.accountSuspendedSignIn)),
          );
        }
      });
    };

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // A required update wins over everything else.
      if (await _checkRequiredUpdate()) return;
      await _checkModerationOnStart();
    });

    // After Google / email deep-link, jump into the game once session exists.
    // Recovery OTP / magic-link goes to set-new-password instead of home.
    AuthService.client.auth.onAuthStateChange.listen((data) async {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        AuthService.pendingPasswordReset = true;
        _nav.currentState
            ?.pushNamedAndRemoveUntil('/reset-password', (route) => false);
      } else if (data.event == AuthChangeEvent.signedIn) {
        if (AuthService.pendingPasswordReset) {
          _nav.currentState
              ?.pushNamedAndRemoveUntil('/reset-password', (route) => false);
          return;
        }
        await _routeSignedIn();
      } else if (data.event == AuthChangeEvent.signedOut) {
        AuthService.pendingPasswordReset = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
        valueListenable: AppLocaleService.revision,
        builder: (_, __, ___) => MaterialApp(
          navigatorKey: _nav,
          navigatorObservers: [_challengeNavObserver],
          title: 'DROTIX',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(),
          // Selected language; the whole app rebuilds when it changes.
          locale: Locale(AppLocaleService.languageCode.value),
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
          // In-app notification banner above every screen.
          builder: (context, child) => Stack(children: [
            if (child != null) child,
            const Positioned(
                top: 0, left: 0, right: 0, child: InAppNotificationBanner()),
          ]),
          initialRoute: _startRoute,
          // Only the start screen — no Landing underneath Home.
          onGenerateInitialRoutes: (name) => [
            MaterialPageRoute(
              settings: RouteSettings(name: name),
              builder: (_) => switch (name) {
                '/intro' => const IntroScreen(),
                '/home' => const HomeScreen(),
                _ => const LandingScreen(),
              },
            ),
          ],
          routes: {
            '/': (_) => const LandingScreen(),
            '/signin': (_) => const SignInScreen(),
            '/signup': (_) => const SignUpScreen(),
            '/home': (_) => const HomeScreen(),
            '/game': (_) => const GameScreen(),
            '/ranks': (_) => const LeaderboardScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/public-profile': (ctx) {
              final args = PublicProfileArgs.fromRoute(
                ModalRoute.of(ctx)?.settings.arguments,
              );
              return PublicProfileScreen(userId: args.userId);
            },
            '/challenge-stake': (_) => const ChallengeStakeScreen(),
            '/challenge-waiting': (_) => const ChallengeWaitingScreen(),
            '/challenge-incoming': (_) => const ChallengeIncomingScreen(),
            '/challenges': (_) => const ChallengesListScreen(),
            '/notifications': (_) => const NotificationsScreen(),
            '/notification': (_) => const NotificationDetailScreen(),
            '/match-lobby': (_) => const MatchLobbyScreen(),
            '/connection-unstable': (_) => const ConnectionUnstableScreen(),
            '/match-abandoned': (_) => const MatchAbandonedScreen(),
            '/match-result': (_) => const MatchResultScreen(),
            '/challenge-privacy': (_) => const ChallengePrivacyScreen(),
            '/chat-rules': (_) => const ChatRulesScreen(),
            '/ephemeral-chat': (_) => const EphemeralChatDemoScreen(),
            '/how-to-play': (_) => const HowToPlayScreen(),
            '/tournament-join-confirm': (_) =>
                const TournamentJoinConfirmScreen(),
            '/tournament-joined': (_) => const TournamentJoinedScreen(),
            '/tournament-bracket': (_) => const TournamentBracketScreen(),
            '/tournament-ready': (_) => const TournamentReadyScreen(),
            '/tournament-match': (_) => const TournamentMatchDemoScreen(),
            '/tournament-round-result': (_) =>
                const TournamentRoundResultScreen(),
            '/tournament-champion': (_) => const TournamentChampionScreen(),
            '/shop-ad-loading': (_) => const ShopAdLoadingScreen(),
            // Mock player replaced by the real AdMob flow.
            '/shop-ad-player': (_) => const ShopAdLoadingScreen(),
            '/shop-ad-verifying': (_) => const ShopAdVerifyingScreen(),
            '/shop-reward-earned': (_) => const ShopRewardEarnedScreen(),
            '/shop-daily-limit': (_) => const ShopDailyLimitScreen(),
            '/shop-no-video': (_) => const ShopNoVideoScreen(),
            '/shop-verify-fail': (_) => const ShopVerifyFailScreen(),
            '/ad-placement': (_) => const AdPlacementScreen(),
            '/reward-flow': (_) => const RewardFlowOverviewScreen(),
            '/logo-splash': (_) => const LogoSplashScreen(),
            '/history': (_) => const HistoryScreen(),
            '/match-history': (_) => const MatchHistoryScreen(),
            '/referral-code': (_) => const ReferralCodeScreen(),
            '/referral-success': (_) => const ReferralSuccessScreen(),
            '/language': (_) => const LanguageScreen(),
            '/games': (_) => const MoreGamesScreen(),
            '/contact': (_) => const ContactAboutScreen(),
            '/privacy': (_) => const PrivacyScreen(),
            '/terms': (_) => const TermsScreen(),
            '/app-update': (_) => const AppUpdateScreen(),
            '/logo': (_) => const LogoScreen(),
            '/intro': (_) => const IntroScreen(),
            '/forgot': (_) => const ForgotPasswordScreen(),
            '/verify': (_) => const VerifyCodeScreen(),
            '/reset-password': (_) => const ResetPasswordScreen(),
            '/offline': (_) => const OfflineScreen(),
            '/daily': (_) => const DailyRewardScreen(),
            '/missions': (_) => const MissionsScreen(),
            '/achievements': (_) => const AchievementsScreen(),
            '/shop': (_) => const ShopScreen(),
            '/friends': (_) => const FriendsScreen(),
            '/events': (_) => const TournamentScreen(),
            '/customize': (_) => const CustomizeScreen(),
            '/matching': (_) => const MatchingScreen(),
            '/offline-ai-picker': (_) => const OfflineAiPickerScreen(),
            '/online-matching': (_) => const OnlineMatchingScreen(),
            '/online-room': (_) => const OnlineGameScreen(),
            '/private-room-lobby': (_) => const PrivateRoomLobbyScreen(),
            '/join-private-room': (_) => const JoinPrivateRoomScreen(),
            // Same JOIN ROOM UI (camera + code) as design.
            '/scan-private-room': (_) => const JoinPrivateRoomScreen(),
            '/edit-profile': (_) => const EditProfileScreen(),
            '/wallet': (_) => const WalletScreen(),
            '/settings': (_) => const SettingsScreen(),
            '/stats': (_) => const StatsScreen(),
            '/account-suspended': (_) => const AccountSuspensionScreen(),
            '/appeal-submit': (_) => const AppealSubmissionScreen(),
            '/appeal-under-review': (_) => const AppealUnderReviewScreen(),
            '/admin-moderation': (_) => const AdminModerationScreen(),
            '/admin-tournament': (_) => const AdminTournamentScreen(),
          },
        ),
      );
}

class _ChallengeNavObserver extends NavigatorObserver {
  final VoidCallback onChange;
  _ChallengeNavObserver({required this.onChange});

  void _notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange());
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _notify();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _notify();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _notify();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _notify();
}
