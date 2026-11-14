import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'l10n/app_localizations.dart';
import 'models.dart';
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
import 'screens/private_room_qr_scanner_screen.dart';
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
import 'screens/how_to_play_flow_screen.dart';
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
  runApp(const TicTacApp());
}

class TicTacApp extends StatefulWidget {
  const TicTacApp({super.key});
  @override
  State<TicTacApp> createState() => _TicTacAppState();
}

class _TicTacAppState extends State<TicTacApp> {
  final _nav = GlobalKey<NavigatorState>();

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

  Future<void> _routeSignedIn() async {
    final route = _currentRouteName();
    debugPrint('Auth signedIn; currentRoute=$route');
    if (route != null && _moderationRoutes.contains(route)) return;
    if (route != null && _protectFromAuthRedirect.contains(route)) return;

    final status = ModerationService.status.value ??
        await ModerationService.refresh();
    var dest = _destinationForModeration(status);
    if (dest == '/home' && await ReferralService.shouldShowPrompt()) {
      dest = '/referral-code';
    }
    if (route != null && _authEntryRoutes.contains(route)) {
      _nav.currentState?.pushNamedAndRemoveUntil(dest, (r) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    ModerationService.onForceSuspended = () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _nav.currentState?.pushNamedAndRemoveUntil('/', (r) => false);
        final ctx = _nav.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text(
                'Your account was suspended. Sign in to view details or appeal.',
              ),
            ),
          );
        }
      });
    };

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
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        locale: AppLocaleService.materialSafeLocale,
        supportedLocales: AppLocaleService.supportedLocales,
        localeResolutionCallback: (device, supported) {
          return AppLocaleService.materialSafeLocale;
        },
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: introSeen.value ? '/' : '/intro',
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
          '/match-lobby': (_) => const MatchLobbyScreen(),
          '/connection-unstable': (_) => const ConnectionUnstableScreen(),
          '/match-abandoned': (_) => const MatchAbandonedScreen(),
          '/match-result': (_) => const MatchResultScreen(),
          '/challenge-privacy': (_) => const ChallengePrivacyScreen(),
          '/chat-rules': (_) => const ChatRulesScreen(),
          '/ephemeral-chat': (_) => const EphemeralChatDemoScreen(),
          '/how-to-play': (_) => const Scaffold(
                backgroundColor: Color(0xFF0A0A0C),
                body: Center(child: HowToPlayFlowScreen()),
              ),
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
          '/shop-ad-player': (_) => const ShopAdPlayerScreen(),
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
          '/scan-private-room': (_) => const PrivateRoomQrScannerScreen(),
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
