import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';
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
import 'screens/language_screen.dart';
import 'screens/more_games_screen.dart';
import 'screens/contact_about_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/logo_screen.dart';
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
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await AppStorage.init();
  await AuthService.init();
  await ConnectivityService.instance.init();
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
  };

  /// In-app play routes — never clear the stack on re-emitted SIGNED_IN.
  static const _protectFromAuthRedirect = {
    '/home',
    '/online-matching',
    '/online-room',
    '/private-room-lobby',
    '/join-private-room',
    '/offline-ai-picker',
    '/matching',
    '/game',
    '/profile',
    '/friends',
    '/ranks',
    '/history',
    '/stats',
    '/settings',
    '/shop',
    '/missions',
    '/achievements',
    '/daily',
    '/events',
    '/customize',
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

  @override
  void initState() {
    super.initState();
    // After Google / email deep-link, jump into the game once session exists.
    // Recovery OTP / magic-link goes to set-new-password instead of home.
    AuthService.client.auth.onAuthStateChange.listen((data) {
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
        // Re-emitted SIGNED_IN must not cancel matchmaking / wipe in-app stack.
        final route = _currentRouteName();
        debugPrint('Auth signedIn; currentRoute=$route');
        if (route != null && _protectFromAuthRedirect.contains(route)) {
          return;
        }
        if (route != null && _authEntryRoutes.contains(route)) {
          _nav.currentState
              ?.pushNamedAndRemoveUntil('/home', (route) => false);
        }
        // route == null → no-op (do not guess / wipe)
      } else if (data.event == AuthChangeEvent.signedOut) {
        AuthService.pendingPasswordReset = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: _nav,
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
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
            final id = ModalRoute.of(ctx)?.settings.arguments as String? ?? '';
            return PublicProfileScreen(userId: id);
          },
          '/history': (_) => const HistoryScreen(),
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
          '/settings': (_) => const SettingsScreen(),
          '/stats': (_) => const StatsScreen(),
        },
      );
}
