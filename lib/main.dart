import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models.dart';
import 'services/auth_service.dart';
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
import 'screens/offline_screen.dart';
import 'screens/daily_reward_screen.dart';
import 'screens/missions_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/tournament_screen.dart';
import 'screens/customize_screen.dart';
import 'screens/matching_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await AppStorage.init();
  await AuthService.init();
  runApp(const TicTacApp());
}

class TicTacApp extends StatefulWidget {
  const TicTacApp({super.key});
  @override
  State<TicTacApp> createState() => _TicTacAppState();
}

class _TicTacAppState extends State<TicTacApp> {
  final _nav = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // After Google / email deep-link, jump into the game once session exists.
    AuthService.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _nav.currentState
            ?.pushNamedAndRemoveUntil('/home', (route) => false);
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
          '/offline': (_) => const OfflineScreen(),
          '/daily': (_) => const DailyRewardScreen(),
          '/missions': (_) => const MissionsScreen(),
          '/achievements': (_) => const AchievementsScreen(),
          '/shop': (_) => const ShopScreen(),
          '/friends': (_) => const FriendsScreen(),
          '/events': (_) => const TournamentScreen(),
          '/customize': (_) => const CustomizeScreen(),
          '/matching': (_) => const MatchingScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/stats': (_) => const StatsScreen(),
        },
      );
}
