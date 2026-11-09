# Tic Tac Toe (Flutter)

Dark geometric survival-game theme: magenta + teal, circle / triangle / square motifs,
original characters (The Doll, masked guard, Player 042) drawn in code with CustomPainter,
animated screens, playable game (3x3, 4x4, 5x5).

## Run
1. Install Flutter (3.22+ recommended).
2. In this folder, generate the platform folders once:
   `flutter create --platforms=android,ios --project-name tic_tac_game .`
   (it keeps lib/ and pubspec.yaml)
3. `flutter pub get`
4. `flutter run`
5. App icon: `dart run flutter_launcher_icons`

The Outfit font is loaded with the google_fonts package (needs internet on first run).
To work offline, download Outfit, put it in assets/fonts and declare it in pubspec.yaml.

## Screens (lib/screens) - 35 designs, all coded
- Start: intro_screen (3 slides, first launch) · landing_screen (animated splash) · sign_in · sign_up ·
  forgot_password · verify_code · offline
- Play: home · game (+ pause and result popups) · matching (radar) · dialogs.dart (difficulty, game mode,
  random-match stake, how to play, pause, result, delete account)
- Retention: daily_reward · missions · achievements · tournament (route /events) · friends · shop · customize
- Player: leaderboard · profile · stats · history · settings · language · more_games · contact_about · privacy
- logo_screen (long-press the title on the landing screen)

Shared UI is in lib/widgets (common.dart, extras.dart, painters.dart). Global state is in lib/models.dart.

## Before you publish
- Replace [YOUR PHONE], [YOUR EMAIL], [YOUR TEAM NAME], [YOUR PRIVACY POLICY TEXT] (search for TODO).
- Connect real auth, leaderboard, history, missions, friends, stats and tournament data
  (models.dart holds simple local state; sample data is marked with TODO comments).
- Shop: connect in_app_purchase and a rewarded-ads SDK. Prices show as [PRICE] until then.
- Random matches are simulated (4 second search). Add real matchmaking and a connectivity check
  (connectivity_plus) that opens /offline.
- Customize: board colours and avatars are applied in the app; mark skins are stored but not drawn yet.
- Add shared_preferences so onboarding and settings are remembered.
- Apple and Google restrict random-reward mechanics; keep daily rewards and missions deterministic.
- Never show other players' emails on the leaderboard.
- Characters and colours are inspired by a TV show's mood, not copied. Do not add the show's
  name, logo or real masks/characters.
