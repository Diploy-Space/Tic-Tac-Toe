import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_bn.dart';
import 'l10n_de.dart';
import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_fr.dart';
import 'l10n_gu.dart';
import 'l10n_hi.dart';
import 'l10n_it.dart';
import 'l10n_ja.dart';
import 'l10n_kn.dart';
import 'l10n_ko.dart';
import 'l10n_ml.dart';
import 'l10n_mr.dart';
import 'l10n_or.dart';
import 'l10n_pa.dart';
import 'l10n_pt.dart';
import 'l10n_ru.dart';
import 'l10n_ta.dart';
import 'l10n_te.dart';
import 'l10n_ur.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('gu'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('or'),
    Locale('pa'),
    Locale('pt'),
    Locale('ru'),
    Locale('ta'),
    Locale('te'),
    Locale('ur'),
    Locale('zh')
  ];

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'DROTIX is a fast, competitive game of three in a row. Play the computer, match with real players, challenge friends and climb the leaderboard.'**
  String get aboutDescription;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @acceptCaps.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT'**
  String get acceptCaps;

  /// No description provided for @acceptRequestCaps.
  ///
  /// In en, this message translates to:
  /// **'ACCEPT REQUEST'**
  String get acceptRequestCaps;

  /// No description provided for @accountCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Account check failed'**
  String get accountCheckFailed;

  /// No description provided for @accountIsSuspended.
  ///
  /// In en, this message translates to:
  /// **'Your account is suspended.'**
  String get accountIsSuspended;

  /// No description provided for @accountRestricted.
  ///
  /// In en, this message translates to:
  /// **'Your account remains restricted until a moderator finishes review. Gameplay, matchmaking, and chat stay locked.'**
  String get accountRestricted;

  /// No description provided for @accountStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Account status unknown. Try again.'**
  String get accountStatusUnknown;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get accountSuspended;

  /// No description provided for @accountSuspendedSignIn.
  ///
  /// In en, this message translates to:
  /// **'Your account was suspended. Sign in to view details or appeal.'**
  String get accountSuspendedSignIn;

  /// No description provided for @accountSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your account has been suspended'**
  String get accountSuspendedTitle;

  /// No description provided for @ach100Wins.
  ///
  /// In en, this message translates to:
  /// **'100 wins'**
  String get ach100Wins;

  /// No description provided for @ach10Matches.
  ///
  /// In en, this message translates to:
  /// **'10 matches'**
  String get ach10Matches;

  /// No description provided for @ach50Matches.
  ///
  /// In en, this message translates to:
  /// **'50 matches'**
  String get ach50Matches;

  /// No description provided for @achChallenger.
  ///
  /// In en, this message translates to:
  /// **'Challenger'**
  String get achChallenger;

  /// No description provided for @achChampion.
  ///
  /// In en, this message translates to:
  /// **'Champion'**
  String get achChampion;

  /// No description provided for @achFirstWin.
  ///
  /// In en, this message translates to:
  /// **'First win'**
  String get achFirstWin;

  /// No description provided for @achScore100.
  ///
  /// In en, this message translates to:
  /// **'Score 100'**
  String get achScore100;

  /// No description provided for @achStreak3.
  ///
  /// In en, this message translates to:
  /// **'Win streak 3'**
  String get achStreak3;

  /// No description provided for @achStreak5.
  ///
  /// In en, this message translates to:
  /// **'Win streak 5'**
  String get achStreak5;

  /// No description provided for @achSurvivor.
  ///
  /// In en, this message translates to:
  /// **'Survivor'**
  String get achSurvivor;

  /// No description provided for @achTop3.
  ///
  /// In en, this message translates to:
  /// **'Top 3'**
  String get achTop3;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add friend'**
  String get addFriend;

  /// No description provided for @addFriendCaps.
  ///
  /// In en, this message translates to:
  /// **'ADD FRIEND'**
  String get addFriendCaps;

  /// No description provided for @advanceQuarter.
  ///
  /// In en, this message translates to:
  /// **'You advance to the Quarter-final'**
  String get advanceQuarter;

  /// No description provided for @advancedMode.
  ///
  /// In en, this message translates to:
  /// **'Advanced mode (4×4)'**
  String get advancedMode;

  /// No description provided for @advertiserApp.
  ///
  /// In en, this message translates to:
  /// **'Advertiser app'**
  String get advertiserApp;

  /// No description provided for @advertiserVideo.
  ///
  /// In en, this message translates to:
  /// **'Advertiser video plays here'**
  String get advertiserVideo;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allowAndInstall.
  ///
  /// In en, this message translates to:
  /// **'Allow & install'**
  String get allowAndInstall;

  /// No description provided for @allowUnknownApps.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Install unknown apps\" for DROTIX, then come back. The update installs automatically.'**
  String get allowUnknownApps;

  /// No description provided for @alreadyPlayer.
  ///
  /// In en, this message translates to:
  /// **'Already a player?'**
  String get alreadyPlayer;

  /// No description provided for @alsoBlock.
  ///
  /// In en, this message translates to:
  /// **'Also block this player'**
  String get alsoBlock;

  /// No description provided for @alwaysTrue.
  ///
  /// In en, this message translates to:
  /// **'Always true'**
  String get alwaysTrue;

  /// No description provided for @appUpdate.
  ///
  /// In en, this message translates to:
  /// **'App update'**
  String get appUpdate;

  /// No description provided for @appealExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain why your account should be reinstated. A moderator will review your message.'**
  String get appealExplain;

  /// No description provided for @appealFailed.
  ///
  /// In en, this message translates to:
  /// **'Appeal failed'**
  String get appealFailed;

  /// No description provided for @appealHint.
  ///
  /// In en, this message translates to:
  /// **'Write your appeal (min 20 characters)…'**
  String get appealHint;

  /// No description provided for @appealIsUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your appeal is under review.'**
  String get appealIsUnderReview;

  /// No description provided for @appealMin20.
  ///
  /// In en, this message translates to:
  /// **'Appeal must be at least 20 characters'**
  String get appealMin20;

  /// No description provided for @appealSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Appeal submitted successfully'**
  String get appealSubmitted;

  /// No description provided for @appealSuspension.
  ///
  /// In en, this message translates to:
  /// **'Appeal suspension'**
  String get appealSuspension;

  /// No description provided for @appealUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Appeal under review'**
  String get appealUnderReview;

  /// No description provided for @applyCodeCaps.
  ///
  /// In en, this message translates to:
  /// **'APPLY CODE'**
  String get applyCodeCaps;

  /// No description provided for @attachRecentChat.
  ///
  /// In en, this message translates to:
  /// **'Attach recent chat messages'**
  String get attachRecentChat;

  /// No description provided for @attemptingReconnect.
  ///
  /// In en, this message translates to:
  /// **'Attempting to reconnect…'**
  String get attemptingReconnect;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @avatars.
  ///
  /// In en, this message translates to:
  /// **'Avatars'**
  String get avatars;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backToEvent.
  ///
  /// In en, this message translates to:
  /// **'Back to event'**
  String get backToEvent;

  /// No description provided for @backToEvents.
  ///
  /// In en, this message translates to:
  /// **'Back to events'**
  String get backToEvents;

  /// No description provided for @backToEventsCaps.
  ///
  /// In en, this message translates to:
  /// **'BACK TO EVENTS'**
  String get backToEventsCaps;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to menu'**
  String get backToMenu;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign in'**
  String get backToSignIn;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance {n}'**
  String balance(String n);

  /// No description provided for @balanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Balance after'**
  String get balanceAfter;

  /// No description provided for @balanceArrow.
  ///
  /// In en, this message translates to:
  /// **'Balance {from} →'**
  String balanceArrow(String from);

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get bestStreak;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best value'**
  String get bestValue;

  /// No description provided for @biggerBoardsBody.
  ///
  /// In en, this message translates to:
  /// **'On larger boards you need four in a row to win. If the board fills up with no line, it is a draw.'**
  String get biggerBoardsBody;

  /// No description provided for @biggerBoardsCaps.
  ///
  /// In en, this message translates to:
  /// **'BIGGER BOARDS'**
  String get biggerBoardsCaps;

  /// No description provided for @biggerNeedFour.
  ///
  /// In en, this message translates to:
  /// **'Bigger boards need four in a row'**
  String get biggerNeedFour;

  /// No description provided for @blockPlayer.
  ///
  /// In en, this message translates to:
  /// **'Block player'**
  String get blockPlayer;

  /// No description provided for @boardHiddenUntilBack.
  ///
  /// In en, this message translates to:
  /// **'The board is hidden until you are back.'**
  String get boardHiddenUntilBack;

  /// No description provided for @boards.
  ///
  /// In en, this message translates to:
  /// **'Boards'**
  String get boards;

  /// No description provided for @bonusAddedToWallet.
  ///
  /// In en, this message translates to:
  /// **'+{n} coins added to your wallet'**
  String bonusAddedToWallet(String n);

  /// No description provided for @bonusClaimed.
  ///
  /// In en, this message translates to:
  /// **'Bonus claimed!'**
  String get bonusClaimed;

  /// No description provided for @bonusCoinsAdded.
  ///
  /// In en, this message translates to:
  /// **'+{n} bonus coins added'**
  String bonusCoinsAdded(String n);

  /// No description provided for @bracket.
  ///
  /// In en, this message translates to:
  /// **'Bracket'**
  String get bracket;

  /// No description provided for @bracketInfo.
  ///
  /// In en, this message translates to:
  /// **'Round of 16 · 8 matches, 4 shown. You are highlighted.'**
  String get bracketInfo;

  /// No description provided for @buyCoinsCaps.
  ///
  /// In en, this message translates to:
  /// **'BUY COINS'**
  String get buyCoinsCaps;

  /// No description provided for @byBoard.
  ///
  /// In en, this message translates to:
  /// **'By board'**
  String get byBoard;

  /// No description provided for @cameraOnlyForScan.
  ///
  /// In en, this message translates to:
  /// **'The camera is only used to scan the code.'**
  String get cameraOnlyForScan;

  /// No description provided for @cameraPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Camera permission needed to scan. You can still enter the code below.'**
  String get cameraPermissionNeeded;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan a room QR code. Enable Camera for this app in system settings, then try again.'**
  String get cameraPermissionRequired;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelChallenge.
  ///
  /// In en, this message translates to:
  /// **'Cancel challenge'**
  String get cancelChallenge;

  /// No description provided for @cancelDownload.
  ///
  /// In en, this message translates to:
  /// **'Cancel download'**
  String get cancelDownload;

  /// No description provided for @cannotChallengeSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot challenge yourself'**
  String get cannotChallengeSelf;

  /// No description provided for @cannotFriendSelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot add yourself as a friend'**
  String get cannotFriendSelf;

  /// No description provided for @cantChallengeNow.
  ///
  /// In en, this message translates to:
  /// **'You can\'t challenge this player right now.'**
  String get cantChallengeNow;

  /// No description provided for @challenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challenge;

  /// No description provided for @challengeAccepted.
  ///
  /// In en, this message translates to:
  /// **'Challenge accepted'**
  String get challengeAccepted;

  /// No description provided for @challengeCancelled.
  ///
  /// In en, this message translates to:
  /// **'Challenge cancelled'**
  String get challengeCancelled;

  /// No description provided for @challengeCaps.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE'**
  String get challengeCaps;

  /// No description provided for @challengeClosed.
  ///
  /// In en, this message translates to:
  /// **'Challenge closed'**
  String get challengeClosed;

  /// No description provided for @challengeDeclined.
  ///
  /// In en, this message translates to:
  /// **'Challenge declined'**
  String get challengeDeclined;

  /// No description provided for @challengeExpired.
  ///
  /// In en, this message translates to:
  /// **'Challenge expired'**
  String get challengeExpired;

  /// No description provided for @challengeExpiresIn60.
  ///
  /// In en, this message translates to:
  /// **'Challenge expires in 60 seconds if not accepted.'**
  String get challengeExpiresIn60;

  /// No description provided for @challengePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Challenge privacy'**
  String get challengePrivacy;

  /// No description provided for @challengeRequests.
  ///
  /// In en, this message translates to:
  /// **'Challenge requests'**
  String get challengeRequests;

  /// No description provided for @challengeSentCoins.
  ///
  /// In en, this message translates to:
  /// **'Challenge sent · 5 coins'**
  String get challengeSentCoins;

  /// No description provided for @challengeSentFree.
  ///
  /// In en, this message translates to:
  /// **'Challenge sent · Free match'**
  String get challengeSentFree;

  /// No description provided for @challenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get challenges;

  /// No description provided for @championCaps.
  ///
  /// In en, this message translates to:
  /// **'CHAMPION'**
  String get championCaps;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatAfterAccept.
  ///
  /// In en, this message translates to:
  /// **'Chat after both players accept the request.'**
  String get chatAfterAccept;

  /// No description provided for @chatAfterAcceptRandom.
  ///
  /// In en, this message translates to:
  /// **'Chat after both players accept. Nothing is shared beyond the username.'**
  String get chatAfterAcceptRandom;

  /// No description provided for @chatBlockedFriendsOnly.
  ///
  /// In en, this message translates to:
  /// **'{name} only accepts messages from friends.'**
  String chatBlockedFriendsOnly(String name);

  /// No description provided for @chatBlockedNobody.
  ///
  /// In en, this message translates to:
  /// **'{name} has turned off messages.'**
  String chatBlockedNobody(String name);

  /// No description provided for @chatNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Chat is not connected'**
  String get chatNotConnected;

  /// No description provided for @chatOn.
  ///
  /// In en, this message translates to:
  /// **'Chat on'**
  String get chatOn;

  /// No description provided for @chatPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Applies to in-match chat. Changes work right away, even during a match.'**
  String get chatPrivacyNote;

  /// No description provided for @chatRules.
  ///
  /// In en, this message translates to:
  /// **'Chat rules'**
  String get chatRules;

  /// No description provided for @chatRulesIntro.
  ///
  /// In en, this message translates to:
  /// **'Text chat never starts on its own. One player asks, the other must accept.'**
  String get chatRulesIntro;

  /// No description provided for @checkAgainCaps.
  ///
  /// In en, this message translates to:
  /// **'CHECK AGAIN'**
  String get checkAgainCaps;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check email'**
  String get checkEmail;

  /// No description provided for @checkEmailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Check your email and open the confirmation link'**
  String get checkEmailConfirm;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @checkInbox.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get checkInbox;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checking;

  /// No description provided for @chooseEntryStake.
  ///
  /// In en, this message translates to:
  /// **'Choose your entry stake'**
  String get chooseEntryStake;

  /// No description provided for @chooseGameMode.
  ///
  /// In en, this message translates to:
  /// **'Choose your game mode'**
  String get chooseGameMode;

  /// No description provided for @chooseNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get chooseNewPassword;

  /// No description provided for @chooseOpponent.
  ///
  /// In en, this message translates to:
  /// **'Choose an opponent'**
  String get chooseOpponent;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'CLAIM'**
  String get claim;

  /// No description provided for @claimBonusCoins.
  ///
  /// In en, this message translates to:
  /// **'Claim {n} Bonus Coins'**
  String claimBonusCoins(String n);

  /// No description provided for @claimLabel.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claimLabel;

  /// No description provided for @claimPlusCoins.
  ///
  /// In en, this message translates to:
  /// **'Claim +{n} coins'**
  String claimPlusCoins(String n);

  /// No description provided for @claimVictory.
  ///
  /// In en, this message translates to:
  /// **'Claim victory'**
  String get claimVictory;

  /// No description provided for @claimsSync.
  ///
  /// In en, this message translates to:
  /// **'Claims sync to your cloud account'**
  String get claimsSync;

  /// No description provided for @classicMode.
  ///
  /// In en, this message translates to:
  /// **'Classic mode (3×3)'**
  String get classicMode;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @clipboardNoCode.
  ///
  /// In en, this message translates to:
  /// **'Clipboard has no room code'**
  String get clipboardNoCode;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @closeAndLose.
  ///
  /// In en, this message translates to:
  /// **'Close and lose reward'**
  String get closeAndLose;

  /// No description provided for @closeRoom.
  ///
  /// In en, this message translates to:
  /// **'Close room'**
  String get closeRoom;

  /// No description provided for @closing.
  ///
  /// In en, this message translates to:
  /// **'Closing…'**
  String get closing;

  /// No description provided for @cloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// No description provided for @cloudSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Cloud save failed: {message}'**
  String cloudSaveFailed(String message);

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code sent'**
  String get codeSent;

  /// No description provided for @coinPacks.
  ///
  /// In en, this message translates to:
  /// **'Coin packs'**
  String get coinPacks;

  /// No description provided for @coinPacksFrom.
  ///
  /// In en, this message translates to:
  /// **'COIN PACKS FROM {price}'**
  String coinPacksFrom(String price);

  /// No description provided for @coins5.
  ///
  /// In en, this message translates to:
  /// **'5 coins'**
  String get coins5;

  /// No description provided for @coinsAdded.
  ///
  /// In en, this message translates to:
  /// **'+{n} coins added'**
  String coinsAdded(String n);

  /// No description provided for @coinsBalance.
  ///
  /// In en, this message translates to:
  /// **'Coins {delta} · Balance {balance}'**
  String coinsBalance(String delta, String balance);

  /// No description provided for @coinsEntryFee.
  ///
  /// In en, this message translates to:
  /// **'5 coins entry fee'**
  String get coinsEntryFee;

  /// No description provided for @coinsEntryFeeBody.
  ///
  /// In en, this message translates to:
  /// **'Used after free matches run out, or to raise the stakes.'**
  String get coinsEntryFeeBody;

  /// No description provided for @coinsLabel.
  ///
  /// In en, this message translates to:
  /// **'{n} coins'**
  String coinsLabel(String n);

  /// No description provided for @coinsSavedCloud.
  ///
  /// In en, this message translates to:
  /// **'+{n} coins (saved to cloud)'**
  String coinsSavedCloud(String n);

  /// No description provided for @column.
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get column;

  /// No description provided for @comeBackTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow'**
  String get comeBackTomorrow;

  /// No description provided for @completeGoogleReturnApp.
  ///
  /// In en, this message translates to:
  /// **'Complete Google sign-in, then return to the app'**
  String get completeGoogleReturnApp;

  /// No description provided for @completeGoogleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Complete Google sign-in, then return'**
  String get completeGoogleSignIn;

  /// No description provided for @computer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computer;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmJoinCaps.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM & JOIN'**
  String get confirmJoinCaps;

  /// No description provided for @confirmLinkSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {target}.\nOpen the link on this device, then return here — you’ll be signed in automatically.'**
  String confirmLinkSentTo(String target);

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent — check your inbox'**
  String get confirmationEmailSent;

  /// No description provided for @confirmingVideo.
  ///
  /// In en, this message translates to:
  /// **'Confirming the video was watched. Please wait.'**
  String get confirmingVideo;

  /// No description provided for @connectingChat.
  ///
  /// In en, this message translates to:
  /// **'Connecting chat…'**
  String get connectingChat;

  /// No description provided for @connectionUnstable.
  ///
  /// In en, this message translates to:
  /// **'Connection unstable'**
  String get connectionUnstable;

  /// No description provided for @connectionUnstableCaps.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION UNSTABLE'**
  String get connectionUnstableCaps;

  /// No description provided for @contactAbout.
  ///
  /// In en, this message translates to:
  /// **'Contact & about'**
  String get contactAbout;

  /// No description provided for @contactUsCaps.
  ///
  /// In en, this message translates to:
  /// **'CONTACT US'**
  String get contactUsCaps;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @continuePlaying.
  ///
  /// In en, this message translates to:
  /// **'Continue playing'**
  String get continuePlaying;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @copiedValue.
  ///
  /// In en, this message translates to:
  /// **'{label} copied: {value}'**
  String copiedValue(String label, String value);

  /// No description provided for @couldNotAddCoins.
  ///
  /// In en, this message translates to:
  /// **'Could not add coins'**
  String get couldNotAddCoins;

  /// No description provided for @couldNotApplyReferral.
  ///
  /// In en, this message translates to:
  /// **'Could not apply referral code'**
  String get couldNotApplyReferral;

  /// No description provided for @couldNotCheck.
  ///
  /// In en, this message translates to:
  /// **'Could not check: {error}'**
  String couldNotCheck(String error);

  /// No description provided for @couldNotJoinRoom.
  ///
  /// In en, this message translates to:
  /// **'Could not join room'**
  String get couldNotJoinRoom;

  /// No description provided for @couldNotLoadPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Could not load privacy settings'**
  String get couldNotLoadPrivacy;

  /// No description provided for @couldNotLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile. Try again.'**
  String get couldNotLoadProfile;

  /// No description provided for @couldNotOpenGoogle.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google sign-in'**
  String get couldNotOpenGoogle;

  /// No description provided for @couldNotSavePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Could not save privacy settings'**
  String get couldNotSavePrivacy;

  /// No description provided for @couldNotStopChat.
  ///
  /// In en, this message translates to:
  /// **'Could not stop chat'**
  String get couldNotStopChat;

  /// No description provided for @couldNotSubmitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Could not submit appeal'**
  String get couldNotSubmitAppeal;

  /// No description provided for @couldNotVerify.
  ///
  /// In en, this message translates to:
  /// **'We could not verify it'**
  String get couldNotVerify;

  /// No description provided for @couldNotVerifyAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not verify account status. Try again.'**
  String get couldNotVerifyAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createPrivateRoom.
  ///
  /// In en, this message translates to:
  /// **'Create private room'**
  String get createPrivateRoom;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @dailyChest.
  ///
  /// In en, this message translates to:
  /// **'Daily chest'**
  String get dailyChest;

  /// No description provided for @dailyLimit.
  ///
  /// In en, this message translates to:
  /// **'DAILY LIMIT REACHED'**
  String get dailyLimit;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dayN.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String dayN(String n);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{n}-day streak'**
  String dayStreak(String n);

  /// No description provided for @days30.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get days30;

  /// No description provided for @days7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get days7;

  /// No description provided for @debitFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not take coins'**
  String get debitFailed;

  /// No description provided for @declineCaps.
  ///
  /// In en, this message translates to:
  /// **'DECLINE'**
  String get declineCaps;

  /// No description provided for @defeat.
  ///
  /// In en, this message translates to:
  /// **'DEFEAT'**
  String get defeat;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'This removes your coins, score and history for good.'**
  String get deleteAccountBody;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @descriptionMin10.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get descriptionMin10;

  /// No description provided for @diagonal.
  ///
  /// In en, this message translates to:
  /// **'Diagonal'**
  String get diagonal;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @doll.
  ///
  /// In en, this message translates to:
  /// **'Doll'**
  String get doll;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @downloadAndInstall.
  ///
  /// In en, this message translates to:
  /// **'Download & Install'**
  String get downloadAndInstall;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get downloading;

  /// No description provided for @downloadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Downloading {percent}%'**
  String downloadingPercent(String percent);

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @drawBadge.
  ///
  /// In en, this message translates to:
  /// **'DRAW'**
  String get drawBadge;

  /// No description provided for @draws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get draws;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earned;

  /// No description provided for @earnedThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Earned this week, by source'**
  String get earnedThisWeek;

  /// No description provided for @editProfileCaps.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileCaps;

  /// No description provided for @eliminatedCaps.
  ///
  /// In en, this message translates to:
  /// **'ELIMINATED'**
  String get eliminatedCaps;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed'**
  String get emailNotConfirmed;

  /// No description provided for @emailNotConfirmedBody.
  ///
  /// In en, this message translates to:
  /// **'Your registration worked, but your email isn\'t confirmed yet.\n\nOpen the confirmation link in your Inbox or Spam folder, then sign in again.\n\n{email}'**
  String emailNotConfirmedBody(String email);

  /// No description provided for @emailSentAgain.
  ///
  /// In en, this message translates to:
  /// **'Email sent again — check your inbox'**
  String get emailSentAgain;

  /// No description provided for @endsIn.
  ///
  /// In en, this message translates to:
  /// **'Ends in'**
  String get endsIn;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @enterCodeFromEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your email'**
  String get enterCodeFromEmail;

  /// No description provided for @enterCodeInstead.
  ///
  /// In en, this message translates to:
  /// **'Enter code instead'**
  String get enterCodeInstead;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter email and password'**
  String get enterEmailPassword;

  /// No description provided for @enterFullCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the full room code'**
  String get enterFullCode;

  /// No description provided for @enterReferralOrSkip.
  ///
  /// In en, this message translates to:
  /// **'Enter a referral code, or skip for now'**
  String get enterReferralOrSkip;

  /// No description provided for @enterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter reset code'**
  String get enterResetCode;

  /// No description provided for @enterValidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number'**
  String get enterValidMobile;

  /// No description provided for @enterValidReferral.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid referral code'**
  String get enterValidReferral;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @entryFee.
  ///
  /// In en, this message translates to:
  /// **'Entry fee'**
  String get entryFee;

  /// No description provided for @equip.
  ///
  /// In en, this message translates to:
  /// **'Equip'**
  String get equip;

  /// No description provided for @equipped.
  ///
  /// In en, this message translates to:
  /// **'Equipped'**
  String get equipped;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @everyone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get everyone;

  /// No description provided for @expertMode.
  ///
  /// In en, this message translates to:
  /// **'Expert mode (5×5)'**
  String get expertMode;

  /// No description provided for @expiredMoveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Expired challenges move to History.'**
  String get expiredMoveToHistory;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields'**
  String get fillAllFields;

  /// No description provided for @finalRound.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get finalRound;

  /// No description provided for @findAMatch.
  ///
  /// In en, this message translates to:
  /// **'Find a match'**
  String get findAMatch;

  /// No description provided for @findOpponent.
  ///
  /// In en, this message translates to:
  /// **'Find opponent'**
  String get findOpponent;

  /// No description provided for @findPrivateJoin.
  ///
  /// In en, this message translates to:
  /// **'Find · private room · join code'**
  String get findPrivateJoin;

  /// No description provided for @findingOpponent.
  ///
  /// In en, this message translates to:
  /// **'Finding an opponent'**
  String get findingOpponent;

  /// No description provided for @findingPlayer.
  ///
  /// In en, this message translates to:
  /// **'Finding a player'**
  String get findingPlayer;

  /// No description provided for @firstMatchSet.
  ///
  /// In en, this message translates to:
  /// **'Your first match is set when the round opens.'**
  String get firstMatchSet;

  /// No description provided for @fiveOfFiveWatched.
  ///
  /// In en, this message translates to:
  /// **'5 of 5 videos watched'**
  String get fiveOfFiveWatched;

  /// No description provided for @flash.
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get flash;

  /// No description provided for @flashUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Flash not available'**
  String get flashUnavailable;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @freeCoins.
  ///
  /// In en, this message translates to:
  /// **'FREE COINS'**
  String get freeCoins;

  /// No description provided for @freeMatch.
  ///
  /// In en, this message translates to:
  /// **'Free match'**
  String get freeMatch;

  /// No description provided for @freeMatchesPerDay.
  ///
  /// In en, this message translates to:
  /// **'3 free matches per day'**
  String get freeMatchesPerDay;

  /// No description provided for @freeVideosToday.
  ///
  /// In en, this message translates to:
  /// **'Free videos today'**
  String get freeVideosToday;

  /// No description provided for @freeVideosUsed.
  ///
  /// In en, this message translates to:
  /// **'{used} of 5 free videos used today'**
  String freeVideosUsed(String used);

  /// No description provided for @friendChallenge.
  ///
  /// In en, this message translates to:
  /// **'Friend challenge'**
  String get friendChallenge;

  /// No description provided for @friendRequestExists.
  ///
  /// In en, this message translates to:
  /// **'Friend request already exists'**
  String get friendRequestExists;

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent to {name}'**
  String friendRequestSent(String name);

  /// No description provided for @friendRequestSentShort.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent'**
  String get friendRequestSentShort;

  /// No description provided for @friendsCaps.
  ///
  /// In en, this message translates to:
  /// **'FRIENDS'**
  String get friendsCaps;

  /// No description provided for @friendsLabel.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsLabel;

  /// No description provided for @friendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Friends only'**
  String get friendsOnly;

  /// No description provided for @fromPhoto.
  ///
  /// In en, this message translates to:
  /// **'From photo'**
  String get fromPhoto;

  /// No description provided for @gameComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{game}: coming soon'**
  String gameComingSoon(String game);

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get gameOver;

  /// No description provided for @gamePaused.
  ///
  /// In en, this message translates to:
  /// **'Game paused'**
  String get gamePaused;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @gettingVideo.
  ///
  /// In en, this message translates to:
  /// **'Getting your video…'**
  String get gettingVideo;

  /// No description provided for @goToMatchCaps.
  ///
  /// In en, this message translates to:
  /// **'GO TO MATCH'**
  String get goToMatchCaps;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @graceWindowEnded.
  ///
  /// In en, this message translates to:
  /// **'The 30 second grace window has ended. You can claim the win.'**
  String get graceWindowEnded;

  /// No description provided for @greatRun.
  ///
  /// In en, this message translates to:
  /// **'Great run in the {name}'**
  String greatRun(String name);

  /// No description provided for @guard.
  ///
  /// In en, this message translates to:
  /// **'Guard'**
  String get guard;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyNeverPublic.
  ///
  /// In en, this message translates to:
  /// **'Your match history and activity are never shown on your public profile.'**
  String get historyNeverPublic;

  /// No description provided for @historySummary.
  ///
  /// In en, this message translates to:
  /// **'{matches} matches · {wins} wins · {losses} losses · {draws} draws'**
  String historySummary(
      String matches, String wins, String losses, String draws);

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @howToPlay.
  ///
  /// In en, this message translates to:
  /// **'How to play'**
  String get howToPlay;

  /// No description provided for @howToPlayRules.
  ///
  /// In en, this message translates to:
  /// **'Place three of your marks in a row, horizontal, vertical or diagonal, before your rival does. On bigger boards you need four in a row.'**
  String get howToPlayRules;

  /// No description provided for @howToPlayStep.
  ///
  /// In en, this message translates to:
  /// **'HOW TO PLAY · {n}/3'**
  String howToPlayStep(String n);

  /// No description provided for @imReadyCaps.
  ///
  /// In en, this message translates to:
  /// **'I\'M READY'**
  String get imReadyCaps;

  /// No description provided for @imageTooBig.
  ///
  /// In en, this message translates to:
  /// **'Image must be under 2 MB'**
  String get imageTooBig;

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @installUpdate.
  ///
  /// In en, this message translates to:
  /// **'Install update'**
  String get installUpdate;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @internetRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet connection required. You can still play vs The Doll offline.'**
  String get internetRequired;

  /// No description provided for @introBody1.
  ///
  /// In en, this message translates to:
  /// **'Beat the AI on 3×3, 4×4 or 5×5 boards.'**
  String get introBody1;

  /// No description provided for @introBody2.
  ///
  /// In en, this message translates to:
  /// **'Random matches with real players. Stake coins, win coins.'**
  String get introBody2;

  /// No description provided for @introBody3.
  ///
  /// In en, this message translates to:
  /// **'Daily rewards, missions and tournaments keep you moving up.'**
  String get introBody3;

  /// No description provided for @introTitle1.
  ///
  /// In en, this message translates to:
  /// **'Outsmart the Doll'**
  String get introTitle1;

  /// No description provided for @introTitle2.
  ///
  /// In en, this message translates to:
  /// **'Duel the world'**
  String get introTitle2;

  /// No description provided for @introTitle3.
  ///
  /// In en, this message translates to:
  /// **'Climb the ranks'**
  String get introTitle3;

  /// No description provided for @invalidRoomQr.
  ///
  /// In en, this message translates to:
  /// **'Invalid room QR'**
  String get invalidRoomQr;

  /// No description provided for @inviteImage.
  ///
  /// In en, this message translates to:
  /// **'Invite image'**
  String get inviteImage;

  /// No description provided for @inviteImageBody.
  ///
  /// In en, this message translates to:
  /// **'Code, QR and link in one picture. Send it on WhatsApp or anywhere.'**
  String get inviteImageBody;

  /// No description provided for @isThinking.
  ///
  /// In en, this message translates to:
  /// **'{name} is thinking'**
  String isThinking(String name);

  /// No description provided for @joinCaps.
  ///
  /// In en, this message translates to:
  /// **'JOIN'**
  String get joinCaps;

  /// No description provided for @joinForCoins.
  ///
  /// In en, this message translates to:
  /// **'JOIN FOR {n} COINS'**
  String joinForCoins(String n);

  /// No description provided for @joinRoomCaps.
  ///
  /// In en, this message translates to:
  /// **'JOIN ROOM'**
  String get joinRoomCaps;

  /// No description provided for @joinTheGame.
  ///
  /// In en, this message translates to:
  /// **'Join the game'**
  String get joinTheGame;

  /// No description provided for @joinTournamentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Join {name}?'**
  String joinTournamentQuestion(String name);

  /// No description provided for @joinWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join with code'**
  String get joinWithCode;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @joiningCaps.
  ///
  /// In en, this message translates to:
  /// **'JOINING…'**
  String get joiningCaps;

  /// No description provided for @joiningQueue.
  ///
  /// In en, this message translates to:
  /// **'Joining queue…'**
  String get joiningQueue;

  /// No description provided for @joiningRoom.
  ///
  /// In en, this message translates to:
  /// **'Joining room…'**
  String get joiningRoom;

  /// No description provided for @keepWatchingCaps.
  ///
  /// In en, this message translates to:
  /// **'KEEP WATCHING'**
  String get keepWatchingCaps;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated'**
  String get languageUpdated;

  /// No description provided for @last20Sent.
  ///
  /// In en, this message translates to:
  /// **'The last 20 messages are sent with your report.'**
  String get last20Sent;

  /// No description provided for @last7Games.
  ///
  /// In en, this message translates to:
  /// **'Last 7 games'**
  String get last7Games;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {date}'**
  String lastUpdated(String date);

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version.'**
  String get latestVersion;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @leaderboardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard updated'**
  String get leaderboardUpdated;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @leaveForfeitBody.
  ///
  /// In en, this message translates to:
  /// **'Leaving now counts as a forfeit. Your opponent wins.'**
  String get leaveForfeitBody;

  /// No description provided for @leaveGame.
  ///
  /// In en, this message translates to:
  /// **'Leave game'**
  String get leaveGame;

  /// No description provided for @leaveMatchQuestion.
  ///
  /// In en, this message translates to:
  /// **'Leave match?'**
  String get leaveMatchQuestion;

  /// No description provided for @leaveVideoQuestion.
  ///
  /// In en, this message translates to:
  /// **'Leave the video?'**
  String get leaveVideoQuestion;

  /// No description provided for @letsPlay.
  ///
  /// In en, this message translates to:
  /// **'Let\'s play'**
  String get letsPlay;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopied;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @liveEventCaps.
  ///
  /// In en, this message translates to:
  /// **'LIVE EVENT'**
  String get liveEventCaps;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @loginMethod.
  ///
  /// In en, this message translates to:
  /// **'Login method'**
  String get loginMethod;

  /// No description provided for @loseCoinsIfClose.
  ///
  /// In en, this message translates to:
  /// **'You will not get your 10 coins if you close it now. {seconds} seconds left.'**
  String loseCoinsIfClose(String seconds);

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @marks.
  ///
  /// In en, this message translates to:
  /// **'Marks'**
  String get marks;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get match;

  /// No description provided for @matchAbandonedCaps.
  ///
  /// In en, this message translates to:
  /// **'MATCH ABANDONED'**
  String get matchAbandonedCaps;

  /// No description provided for @matchDuration.
  ///
  /// In en, this message translates to:
  /// **'Match duration {duration}'**
  String matchDuration(String duration);

  /// No description provided for @matchHistory.
  ///
  /// In en, this message translates to:
  /// **'Match History'**
  String get matchHistory;

  /// No description provided for @matchHistoryCaps.
  ///
  /// In en, this message translates to:
  /// **'MATCH HISTORY'**
  String get matchHistoryCaps;

  /// No description provided for @matchInvitations.
  ///
  /// In en, this message translates to:
  /// **'Match invitations'**
  String get matchInvitations;

  /// No description provided for @matchLobby.
  ///
  /// In en, this message translates to:
  /// **'Match lobby'**
  String get matchLobby;

  /// No description provided for @matchResult.
  ///
  /// In en, this message translates to:
  /// **'Match result'**
  String get matchResult;

  /// No description provided for @matchResults.
  ///
  /// In en, this message translates to:
  /// **'Match results'**
  String get matchResults;

  /// No description provided for @matchStakes.
  ///
  /// In en, this message translates to:
  /// **'Match stakes'**
  String get matchStakes;

  /// No description provided for @matchStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Match starts in'**
  String get matchStartsIn;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @matchmakingError.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking error'**
  String get matchmakingError;

  /// No description provided for @matchmakingFailed.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking failed'**
  String get matchmakingFailed;

  /// No description provided for @matchmakingStopped.
  ///
  /// In en, this message translates to:
  /// **'Matchmaking stopped'**
  String get matchmakingStopped;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(String date);

  /// No description provided for @messageEmpty.
  ///
  /// In en, this message translates to:
  /// **'Message cannot be empty'**
  String get messageEmpty;

  /// No description provided for @messagesStayForMatch.
  ///
  /// In en, this message translates to:
  /// **'Messages stay for this match'**
  String get messagesStayForMatch;

  /// No description provided for @minusCoins.
  ///
  /// In en, this message translates to:
  /// **'-{n} coins'**
  String minusCoins(String n);

  /// No description provided for @misPlay30.
  ///
  /// In en, this message translates to:
  /// **'Play 30 matches'**
  String get misPlay30;

  /// No description provided for @misPlay5.
  ///
  /// In en, this message translates to:
  /// **'Play 5 matches'**
  String get misPlay5;

  /// No description provided for @misQuick.
  ///
  /// In en, this message translates to:
  /// **'Play a random match'**
  String get misQuick;

  /// No description provided for @misTourney.
  ///
  /// In en, this message translates to:
  /// **'Join a tournament'**
  String get misTourney;

  /// No description provided for @misWin15.
  ///
  /// In en, this message translates to:
  /// **'Win 15 games'**
  String get misWin15;

  /// No description provided for @misWin3.
  ///
  /// In en, this message translates to:
  /// **'Win 3 games'**
  String get misWin3;

  /// No description provided for @misWin4x4.
  ///
  /// In en, this message translates to:
  /// **'Win on a 4×4 board'**
  String get misWin4x4;

  /// No description provided for @missResets.
  ///
  /// In en, this message translates to:
  /// **'Miss a day and it resets. Come back tomorrow for the next reward.'**
  String get missResets;

  /// No description provided for @missingChallengeData.
  ///
  /// In en, this message translates to:
  /// **'Missing challenge data'**
  String get missingChallengeData;

  /// No description provided for @missingEmail.
  ///
  /// In en, this message translates to:
  /// **'Missing email — go back and try again'**
  String get missingEmail;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// No description provided for @missionsDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} missions done'**
  String missionsDone(String done, String total);

  /// No description provided for @mobileNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Mobile numbers are not supported in your region yet'**
  String get mobileNotSupported;

  /// No description provided for @mobileOptional.
  ///
  /// In en, this message translates to:
  /// **'Mobile number (optional)'**
  String get mobileOptional;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode {n}'**
  String mode(String n);

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @moreGames.
  ///
  /// In en, this message translates to:
  /// **'More games'**
  String get moreGames;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @nOf5.
  ///
  /// In en, this message translates to:
  /// **'{n} of 5'**
  String nOf5(String n);

  /// No description provided for @navPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get navPlay;

  /// No description provided for @newCodeSent.
  ///
  /// In en, this message translates to:
  /// **'New code sent — check your inbox'**
  String get newCodeSent;

  /// No description provided for @newHere.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get newHere;

  /// No description provided for @newMatchChallengeCaps.
  ///
  /// In en, this message translates to:
  /// **'NEW MATCH CHALLENGE!'**
  String get newMatchChallengeCaps;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password for your account. You’ll stay signed in after saving.'**
  String get newPasswordBody;

  /// No description provided for @newVersion.
  ///
  /// In en, this message translates to:
  /// **'New version'**
  String get newVersion;

  /// No description provided for @newVersionReady.
  ///
  /// In en, this message translates to:
  /// **'A new version of DROTIX is ready.'**
  String get newVersionReady;

  /// No description provided for @newVideosUnlockIn.
  ///
  /// In en, this message translates to:
  /// **'New free videos unlock in'**
  String get newVideosUnlockIn;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @nextCaps.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get nextCaps;

  /// No description provided for @nextRound.
  ///
  /// In en, this message translates to:
  /// **'Next round'**
  String get nextRound;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noChallenge.
  ///
  /// In en, this message translates to:
  /// **'No challenge'**
  String get noChallenge;

  /// No description provided for @noChallengesHere.
  ///
  /// In en, this message translates to:
  /// **'No challenges here.'**
  String get noChallengesHere;

  /// No description provided for @noCloudMatches.
  ///
  /// In en, this message translates to:
  /// **'No cloud matches yet. Play vs The Doll while signed in to appear here.'**
  String get noCloudMatches;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet — search to add someone.'**
  String get noFriendsYet;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history found'**
  String get noHistory;

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatchesYet;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.\nQuick replies work too.'**
  String get noMessagesYet;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @noOpponentFound.
  ///
  /// In en, this message translates to:
  /// **'No opponent found — try again'**
  String get noOpponentFound;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get noPendingRequests;

  /// No description provided for @noPlayersFound.
  ///
  /// In en, this message translates to:
  /// **'No players found'**
  String get noPlayersFound;

  /// No description provided for @noQrInPhoto.
  ///
  /// In en, this message translates to:
  /// **'No QR found in photo'**
  String get noQrInPhoto;

  /// No description provided for @noRankedPlayers.
  ///
  /// In en, this message translates to:
  /// **'No ranked players yet. Sign in and play to join the board.'**
  String get noRankedPlayers;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get noTransactions;

  /// No description provided for @noVideoFound.
  ///
  /// In en, this message translates to:
  /// **'We could not find a video for you. Your free video was not used. Try again in a minute.'**
  String get noVideoFound;

  /// No description provided for @noVideoNow.
  ///
  /// In en, this message translates to:
  /// **'No video available right now. Try again later.'**
  String get noVideoNow;

  /// No description provided for @noVideoRightNow.
  ///
  /// In en, this message translates to:
  /// **'No video right now'**
  String get noVideoRightNow;

  /// No description provided for @nobody.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get nobody;

  /// No description provided for @nobodyBlinked.
  ///
  /// In en, this message translates to:
  /// **'Nobody blinked.'**
  String get nobodyBlinked;

  /// No description provided for @nobodyBlinkedVs.
  ///
  /// In en, this message translates to:
  /// **'Nobody blinked. {name} held you off.'**
  String nobodyBlinkedVs(String name);

  /// No description provided for @notAcceptingChallenges.
  ///
  /// In en, this message translates to:
  /// **'{name} is not accepting challenges right now.'**
  String notAcceptingChallenges(String name);

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get notEnoughCoins;

  /// No description provided for @notEnoughCoinsAnother.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins for another stake.'**
  String get notEnoughCoinsAnother;

  /// No description provided for @notEnoughCoinsStake.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins for this stake.'**
  String get notEnoughCoinsStake;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @notSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get notSignedIn;

  /// No description provided for @notSignedInYet.
  ///
  /// In en, this message translates to:
  /// **'Not signed in yet — open the email link first'**
  String get notSignedInYet;

  /// No description provided for @notifChallengeAcceptedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} accepted your challenge. Match starting!'**
  String notifChallengeAcceptedBody(String name);

  /// No description provided for @notifChallengeAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge accepted'**
  String get notifChallengeAcceptedTitle;

  /// No description provided for @notifChallengeBusyBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is in a match right now. Try again later.'**
  String notifChallengeBusyBody(String name);

  /// No description provided for @notifChallengeBusyTitle.
  ///
  /// In en, this message translates to:
  /// **'Player is busy'**
  String get notifChallengeBusyTitle;

  /// No description provided for @notifChallengeCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled the challenge'**
  String notifChallengeCancelledBody(String name);

  /// No description provided for @notifChallengeCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge cancelled'**
  String get notifChallengeCancelledTitle;

  /// No description provided for @notifChallengeDeclinedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} declined your challenge'**
  String notifChallengeDeclinedBody(String name);

  /// No description provided for @notifChallengeDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge declined'**
  String get notifChallengeDeclinedTitle;

  /// No description provided for @notifChallengeExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'{name} did not respond in time'**
  String notifChallengeExpiredBody(String name);

  /// No description provided for @notifChallengeExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge expired'**
  String get notifChallengeExpiredTitle;

  /// No description provided for @notifChallengeRequestBody.
  ///
  /// In en, this message translates to:
  /// **'{name} challenged you to a match'**
  String notifChallengeRequestBody(String name);

  /// No description provided for @notifChallengeRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'New challenge'**
  String get notifChallengeRequestTitle;

  /// No description provided for @notifChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Challenges, matches and coin updates'**
  String get notifChannelDesc;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Game alerts'**
  String get notifChannelName;

  /// No description provided for @notifCoinsAddedBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} coins added. Balance: {balance}'**
  String notifCoinsAddedBody(String amount, String balance);

  /// No description provided for @notifCoinsCreditTitle.
  ///
  /// In en, this message translates to:
  /// **'Coins added'**
  String get notifCoinsCreditTitle;

  /// No description provided for @notifCoinsDebitBody.
  ///
  /// In en, this message translates to:
  /// **'{amount} coins deducted. Balance: {balance}'**
  String notifCoinsDebitBody(String amount, String balance);

  /// No description provided for @notifCoinsDebitTitle.
  ///
  /// In en, this message translates to:
  /// **'Coins deducted'**
  String get notifCoinsDebitTitle;

  /// No description provided for @notifCoinsPurchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase complete'**
  String get notifCoinsPurchaseTitle;

  /// No description provided for @notifCoinsRewardBody.
  ///
  /// In en, this message translates to:
  /// **'You earned {amount} coins. Balance: {balance}'**
  String notifCoinsRewardBody(String amount, String balance);

  /// No description provided for @notifCoinsRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Reward received'**
  String get notifCoinsRewardTitle;

  /// No description provided for @notifEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Challenges, match results and coin updates will show up here.'**
  String get notifEmptyHint;

  /// No description provided for @notifFriendAcceptedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} accepted your friend request'**
  String notifFriendAcceptedBody(String name);

  /// No description provided for @notifFriendAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'New friend'**
  String get notifFriendAcceptedTitle;

  /// No description provided for @notifFriendRequestBody.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to be your friend'**
  String notifFriendRequestBody(String name);

  /// No description provided for @notifFriendRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Friend request'**
  String get notifFriendRequestTitle;

  /// No description provided for @notifGeneric.
  ///
  /// In en, this message translates to:
  /// **'New notification'**
  String get notifGeneric;

  /// No description provided for @notifMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Your match vs {name} has ended'**
  String notifMatchBody(String name);

  /// No description provided for @notifMatchDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get notifMatchDrawTitle;

  /// No description provided for @notifMatchLostTitle.
  ///
  /// In en, this message translates to:
  /// **'You lost'**
  String get notifMatchLostTitle;

  /// No description provided for @notifMatchWonTitle.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get notifMatchWonTitle;

  /// No description provided for @notifRoomJoinedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} joined your private room'**
  String notifRoomJoinedBody(String name);

  /// No description provided for @notifRoomJoinedTitle.
  ///
  /// In en, this message translates to:
  /// **'Player joined'**
  String get notifRoomJoinedTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @nowFriends.
  ///
  /// In en, this message translates to:
  /// **'You and {name} are now friends'**
  String nowFriends(String name);

  /// No description provided for @nowFriendsShort.
  ///
  /// In en, this message translates to:
  /// **'You are now friends'**
  String get nowFriendsShort;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialWebsite;

  /// No description provided for @offlineAi.
  ///
  /// In en, this message translates to:
  /// **'Offline AI'**
  String get offlineAi;

  /// No description provided for @offlineAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No internet · AI rivals only · {size} · Stake {stake}'**
  String offlineAiSubtitle(String size, String stake);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline · Play vs The Doll still works'**
  String get offlineBanner;

  /// No description provided for @offlineBody.
  ///
  /// In en, this message translates to:
  /// **'Online matches and tournaments need a connection. You can still play against The Doll.'**
  String get offlineBody;

  /// No description provided for @offlineProfilesNote.
  ///
  /// In en, this message translates to:
  /// **'These are offline AI profiles — not real online players.'**
  String get offlineProfilesNote;

  /// No description provided for @offlineSmart.
  ///
  /// In en, this message translates to:
  /// **'Offline, smart opponent'**
  String get offlineSmart;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @oneLastStepCaps.
  ///
  /// In en, this message translates to:
  /// **'ONE LAST STEP'**
  String get oneLastStepCaps;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @onlineMatch.
  ///
  /// In en, this message translates to:
  /// **'Online match'**
  String get onlineMatch;

  /// No description provided for @onlineMultiplayer.
  ///
  /// In en, this message translates to:
  /// **'Online multiplayer'**
  String get onlineMultiplayer;

  /// No description provided for @onlineOfflineAi.
  ///
  /// In en, this message translates to:
  /// **'Online players · Offline AI'**
  String get onlineOfflineAi;

  /// No description provided for @onlineStake.
  ///
  /// In en, this message translates to:
  /// **'Online · Stake {stake}'**
  String onlineStake(String stake);

  /// No description provided for @onlyFriendsChallenges.
  ///
  /// In en, this message translates to:
  /// **'{name} only accepts challenges from friends. Add them first.'**
  String onlyFriendsChallenges(String name);

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @openedTheLink.
  ///
  /// In en, this message translates to:
  /// **'I’ve opened the link'**
  String get openedTheLink;

  /// No description provided for @openingInstaller.
  ///
  /// In en, this message translates to:
  /// **'Opening installer…'**
  String get openingInstaller;

  /// No description provided for @opponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// No description provided for @opponentAdvances.
  ///
  /// In en, this message translates to:
  /// **'If you do not join in time, your opponent advances.'**
  String get opponentAdvances;

  /// No description provided for @opponentDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Opponent disconnected'**
  String get opponentDisconnected;

  /// No description provided for @opponentWins.
  ///
  /// In en, this message translates to:
  /// **'Opponent wins'**
  String get opponentWins;

  /// No description provided for @opponentsMove.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s move'**
  String opponentsMove(String name);

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @orEnterCodeCaps.
  ///
  /// In en, this message translates to:
  /// **'OR ENTER THE CODE'**
  String get orEnterCodeCaps;

  /// No description provided for @otherEvents.
  ///
  /// In en, this message translates to:
  /// **'Other events'**
  String get otherEvents;

  /// No description provided for @owned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// No description provided for @passAndPlay.
  ///
  /// In en, this message translates to:
  /// **'Pass & Play'**
  String get passAndPlay;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMin6;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @passwordsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNoMatch;

  /// No description provided for @pasteCode.
  ///
  /// In en, this message translates to:
  /// **'Paste code'**
  String get pasteCode;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @perMove20s.
  ///
  /// In en, this message translates to:
  /// **'20s per move'**
  String get perMove20s;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get photoUpdated;

  /// No description provided for @pickClosestReason.
  ///
  /// In en, this message translates to:
  /// **'What is happening? Pick the closest reason.'**
  String get pickClosestReason;

  /// No description provided for @pickYourGame.
  ///
  /// In en, this message translates to:
  /// **'Pick your game'**
  String get pickYourGame;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @playAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Play as guest'**
  String get playAsGuest;

  /// No description provided for @playCaps.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get playCaps;

  /// No description provided for @playDollOffline.
  ///
  /// In en, this message translates to:
  /// **'Play vs The Doll offline'**
  String get playDollOffline;

  /// No description provided for @playToBuildForm.
  ///
  /// In en, this message translates to:
  /// **'Play a match to build your form.'**
  String get playToBuildForm;

  /// No description provided for @playVsDoll.
  ///
  /// In en, this message translates to:
  /// **'Play vs The Doll'**
  String get playVsDoll;

  /// No description provided for @playVsName.
  ///
  /// In en, this message translates to:
  /// **'Play vs {name}'**
  String playVsName(String name);

  /// No description provided for @played.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get played;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @player1.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get player1;

  /// No description provided for @player1Move.
  ///
  /// In en, this message translates to:
  /// **'Player 1\'s move'**
  String get player1Move;

  /// No description provided for @player1Wins.
  ///
  /// In en, this message translates to:
  /// **'Player 1 wins!'**
  String get player1Wins;

  /// No description provided for @player2.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get player2;

  /// No description provided for @player2Move.
  ///
  /// In en, this message translates to:
  /// **'Player 2\'s move'**
  String get player2Move;

  /// No description provided for @player2Wins.
  ///
  /// In en, this message translates to:
  /// **'Player 2 wins!'**
  String get player2Wins;

  /// No description provided for @playerAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String playerAdded(String name);

  /// No description provided for @playerBlocked.
  ///
  /// In en, this message translates to:
  /// **'Player blocked'**
  String get playerBlocked;

  /// No description provided for @playerIdLabel.
  ///
  /// In en, this message translates to:
  /// **'PLAYER {id}'**
  String playerIdLabel(String id);

  /// No description provided for @playerUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Player unblocked'**
  String get playerUnblocked;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @playersLeft.
  ///
  /// In en, this message translates to:
  /// **'Players left'**
  String get playersLeft;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get pleaseWait;

  /// No description provided for @plusCoins.
  ///
  /// In en, this message translates to:
  /// **'+{n} coins'**
  String plusCoins(String n);

  /// No description provided for @podium.
  ///
  /// In en, this message translates to:
  /// **'Podium'**
  String get podium;

  /// No description provided for @pointAtHostQr.
  ///
  /// In en, this message translates to:
  /// **'Point at the host’s QR. Same code as the lobby.'**
  String get pointAtHostQr;

  /// No description provided for @pointCameraAtQr.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the room QR code'**
  String get pointCameraAtQr;

  /// No description provided for @pointsWins.
  ///
  /// In en, this message translates to:
  /// **'{points} pts · {wins} wins'**
  String pointsWins(String points, String wins);

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @previousMatchExpired.
  ///
  /// In en, this message translates to:
  /// **'Previous match expired. Try again in a moment.'**
  String get previousMatchExpired;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'We collect only the gameplay data needed to run the app (coins, cosmetics, match history and settings). Guest play does not require an account.\n\nIf you sign in, your details are used only to save and restore your progress. We do not sell personal data. You can delete your data anytime from Settings → Delete account.\n\nContact: {email}'**
  String privacyBody(String email);

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privateOnlyYou.
  ///
  /// In en, this message translates to:
  /// **'Private. Only you can see this.'**
  String get privateOnlyYou;

  /// No description provided for @privateRoomByUsername.
  ///
  /// In en, this message translates to:
  /// **'Private room (by username)'**
  String get privateRoomByUsername;

  /// No description provided for @privateRoomCaps.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE ROOM'**
  String get privateRoomCaps;

  /// No description provided for @prizeAdded.
  ///
  /// In en, this message translates to:
  /// **'Prize added to your balance'**
  String get prizeAdded;

  /// No description provided for @prizePool.
  ///
  /// In en, this message translates to:
  /// **'Prize pool'**
  String get prizePool;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @profilePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Match history and activity stay private. Reporting is for profile abuse; in-match chat reports use the chat Report button.'**
  String get profilePrivacyNote;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @progressOf.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String progressOf(String done, String total);

  /// No description provided for @publicStatsNote.
  ///
  /// In en, this message translates to:
  /// **'Only rank, score and wins are public. Match history and activity stay private.'**
  String get publicStatsNote;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @purchasesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coin purchases are coming soon. Watch a video in Free Coins to earn coins now.'**
  String get purchasesComingSoon;

  /// No description provided for @quarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get quarter;

  /// No description provided for @quarterFinal.
  ///
  /// In en, this message translates to:
  /// **'Quarter-final'**
  String get quarterFinal;

  /// No description provided for @quickCloseOne.
  ///
  /// In en, this message translates to:
  /// **'Close one!'**
  String get quickCloseOne;

  /// No description provided for @quickGg.
  ///
  /// In en, this message translates to:
  /// **'GG'**
  String get quickGg;

  /// No description provided for @quickGoodMove.
  ///
  /// In en, this message translates to:
  /// **'Good move!'**
  String get quickGoodMove;

  /// No description provided for @quickMatchVsAi.
  ///
  /// In en, this message translates to:
  /// **'Quick match vs AI · {time}'**
  String quickMatchVsAi(String time);

  /// No description provided for @quitMatch.
  ///
  /// In en, this message translates to:
  /// **'Quit match'**
  String get quitMatch;

  /// No description provided for @randomMatch.
  ///
  /// In en, this message translates to:
  /// **'Random match'**
  String get randomMatch;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @rankScore.
  ///
  /// In en, this message translates to:
  /// **'Rank #{rank} · Score {score}'**
  String rankScore(String rank, String score);

  /// No description provided for @rankScoreUnknown.
  ///
  /// In en, this message translates to:
  /// **'Rank – · Score –'**
  String get rankScoreUnknown;

  /// No description provided for @ranks.
  ///
  /// In en, this message translates to:
  /// **'Ranks'**
  String get ranks;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateApp;

  /// No description provided for @ratingsSoon.
  ///
  /// In en, this message translates to:
  /// **'Ratings are coming soon'**
  String get ratingsSoon;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'read only'**
  String get readOnly;

  /// No description provided for @readyCaps.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get readyCaps;

  /// No description provided for @reasonHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get reasonHarassment;

  /// No description provided for @reasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Sexual or inappropriate content'**
  String get reasonInappropriate;

  /// No description provided for @reasonOffensive.
  ///
  /// In en, this message translates to:
  /// **'Hate speech or abuse'**
  String get reasonOffensive;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reasonOther;

  /// No description provided for @reasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or scams'**
  String get reasonSpam;

  /// No description provided for @reasonThreatening.
  ///
  /// In en, this message translates to:
  /// **'Threats or violence'**
  String get reasonThreatening;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get reconnecting;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference: {id}'**
  String reference(String id);

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral code'**
  String get referralCode;

  /// No description provided for @referralHint.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get referralHint;

  /// No description provided for @referralOnce.
  ///
  /// In en, this message translates to:
  /// **'You can only use a referral code once, right after signing up.'**
  String get referralOnce;

  /// No description provided for @referralPrompt.
  ///
  /// In en, this message translates to:
  /// **'Got a referral code from a friend? Enter it now and get 50 coins.'**
  String get referralPrompt;

  /// No description provided for @referralWorked.
  ///
  /// In en, this message translates to:
  /// **'Your referral code worked. The coins are in your wallet and ready to use.'**
  String get referralWorked;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @refreshStatus.
  ///
  /// In en, this message translates to:
  /// **'Refresh status'**
  String get refreshStatus;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @regionIndiaNote.
  ///
  /// In en, this message translates to:
  /// **'Detected automatically from your SIM / device. India shows Indian languages and prices in ₹.'**
  String get regionIndiaNote;

  /// No description provided for @regionIntlNote.
  ///
  /// In en, this message translates to:
  /// **'Detected automatically from your SIM / device. International languages, prices in {currency}.'**
  String regionIntlNote(String currency);

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @released.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get released;

  /// No description provided for @rematch.
  ///
  /// In en, this message translates to:
  /// **'Rematch'**
  String get rematch;

  /// No description provided for @rematchQuestion.
  ///
  /// In en, this message translates to:
  /// **'Rematch?'**
  String get rematchQuestion;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me before my match'**
  String get remindMe;

  /// No description provided for @reportButtonCaps.
  ///
  /// In en, this message translates to:
  /// **'REPORT BUTTON'**
  String get reportButtonCaps;

  /// No description provided for @reportButtonHelp.
  ///
  /// In en, this message translates to:
  /// **'Top right of the live chat, next to Stop chat. Always visible while chat is on.\nTap → pick a reason → add details and screenshots → submit.'**
  String get reportButtonHelp;

  /// No description provided for @reportCaps.
  ///
  /// In en, this message translates to:
  /// **'REPORT'**
  String get reportCaps;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Report failed'**
  String get reportFailed;

  /// No description provided for @reportName.
  ///
  /// In en, this message translates to:
  /// **'Report {name}'**
  String reportName(String name);

  /// No description provided for @reportOrBlock.
  ///
  /// In en, this message translates to:
  /// **'Report or block'**
  String get reportOrBlock;

  /// No description provided for @reportOrBlockPlayer.
  ///
  /// In en, this message translates to:
  /// **'Report or block this player'**
  String get reportOrBlockPlayer;

  /// No description provided for @reportPlayer.
  ///
  /// In en, this message translates to:
  /// **'Report player'**
  String get reportPlayer;

  /// No description provided for @requestSentCaps.
  ///
  /// In en, this message translates to:
  /// **'REQUEST SENT'**
  String get requestSentCaps;

  /// No description provided for @requestSentTo.
  ///
  /// In en, this message translates to:
  /// **'Request sent to {name}'**
  String requestSentTo(String name);

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @requestsCount.
  ///
  /// In en, this message translates to:
  /// **'Requests · {n}'**
  String requestsCount(String n);

  /// No description provided for @requestsExpire7d.
  ///
  /// In en, this message translates to:
  /// **'Requests expire after 7 days if not answered.'**
  String get requestsExpire7d;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get resendEmail;

  /// No description provided for @resetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset code'**
  String get resetCode;

  /// No description provided for @resetCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a reset code to {target}.\nType it below — you don’t need to open the email link.'**
  String resetCodeSentTo(String target);

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send a reset code. Type that code in the app — no need to open the email link.'**
  String get resetPasswordBody;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @returnToMainMenu.
  ///
  /// In en, this message translates to:
  /// **'Return to main menu'**
  String get returnToMainMenu;

  /// No description provided for @rewardEarnedCaps.
  ///
  /// In en, this message translates to:
  /// **'REWARD EARNED'**
  String get rewardEarnedCaps;

  /// No description provided for @rewardFlowOverview.
  ///
  /// In en, this message translates to:
  /// **'Reward flow overview'**
  String get rewardFlowOverview;

  /// No description provided for @rewardIn.
  ///
  /// In en, this message translates to:
  /// **'Reward in {time}'**
  String rewardIn(String time);

  /// No description provided for @rivalO.
  ///
  /// In en, this message translates to:
  /// **'Rival: O'**
  String get rivalO;

  /// No description provided for @roomCancelled.
  ///
  /// In en, this message translates to:
  /// **'Room cancelled'**
  String get roomCancelled;

  /// No description provided for @roomClosesIn.
  ///
  /// In en, this message translates to:
  /// **'Room closes in {time} if nobody joins.'**
  String roomClosesIn(String time);

  /// No description provided for @roomClosesSoon.
  ///
  /// In en, this message translates to:
  /// **'Room closes soon if nobody joins.'**
  String get roomClosesSoon;

  /// No description provided for @roomClosing.
  ///
  /// In en, this message translates to:
  /// **'Room is closing…'**
  String get roomClosing;

  /// No description provided for @roomCodeCaps.
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get roomCodeCaps;

  /// No description provided for @roomCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Room code copied'**
  String get roomCodeCopied;

  /// No description provided for @roomExpired.
  ///
  /// In en, this message translates to:
  /// **'Room expired'**
  String get roomExpired;

  /// No description provided for @roomOpenCaps.
  ///
  /// In en, this message translates to:
  /// **'ROOM OPEN'**
  String get roomOpenCaps;

  /// No description provided for @roundOf16.
  ///
  /// In en, this message translates to:
  /// **'Round of 16'**
  String get roundOf16;

  /// No description provided for @roundOf16Caps.
  ///
  /// In en, this message translates to:
  /// **'ROUND OF 16'**
  String get roundOf16Caps;

  /// No description provided for @roundOf16Vs.
  ///
  /// In en, this message translates to:
  /// **'Round of 16 · vs {name}'**
  String roundOf16Vs(String name);

  /// No description provided for @roundsWon.
  ///
  /// In en, this message translates to:
  /// **'Rounds won'**
  String get roundsWon;

  /// No description provided for @row.
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get row;

  /// No description provided for @ruleEmoji.
  ///
  /// In en, this message translates to:
  /// **'• Emoji reactions work without a request, and can be muted.'**
  String get ruleEmoji;

  /// No description provided for @ruleEnds.
  ///
  /// In en, this message translates to:
  /// **'• Chat ends automatically when the match ends.'**
  String get ruleEnds;

  /// No description provided for @ruleStop.
  ///
  /// In en, this message translates to:
  /// **'• Either player can stop the chat at any time.'**
  String get ruleStop;

  /// No description provided for @ruleVanish.
  ///
  /// In en, this message translates to:
  /// **'• Messages vanish in seconds and are never saved.'**
  String get ruleVanish;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @savingToCloud.
  ///
  /// In en, this message translates to:
  /// **'Saving to cloud…'**
  String get savingToCloud;

  /// No description provided for @scanOrShare.
  ///
  /// In en, this message translates to:
  /// **'Scan to join, or share the link'**
  String get scanOrShare;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @scorePlus10.
  ///
  /// In en, this message translates to:
  /// **'Score +10'**
  String get scorePlus10;

  /// No description provided for @screenshotTooBig.
  ///
  /// In en, this message translates to:
  /// **'Screenshot must be under 2 MB'**
  String get screenshotTooBig;

  /// No description provided for @screenshotsOptionalCaps.
  ///
  /// In en, this message translates to:
  /// **'SCREENSHOTS (OPTIONAL)'**
  String get screenshotsOptionalCaps;

  /// No description provided for @searchPlayersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by username or Player ID'**
  String get searchPlayersHint;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @searchingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Online · {size} · stake {stake} · {time}'**
  String searchingSubtitle(String size, String stake, String time);

  /// No description provided for @seatWaiting.
  ///
  /// In en, this message translates to:
  /// **'Player, your seat is waiting.'**
  String get seatWaiting;

  /// No description provided for @secondsLeft.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s left'**
  String secondsLeft(String seconds);

  /// No description provided for @secondsLeftToRespond.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s left to respond'**
  String secondsLeftToRespond(String seconds);

  /// No description provided for @selectDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Select difficulty'**
  String get selectDifficulty;

  /// No description provided for @selectOpponent.
  ///
  /// In en, this message translates to:
  /// **'Select an opponent'**
  String get selectOpponent;

  /// No description provided for @selectReportReason.
  ///
  /// In en, this message translates to:
  /// **'Select a report reason'**
  String get selectReportReason;

  /// No description provided for @semi.
  ///
  /// In en, this message translates to:
  /// **'Semi'**
  String get semi;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @sendChallenge.
  ///
  /// In en, this message translates to:
  /// **'Send challenge'**
  String get sendChallenge;

  /// No description provided for @sendResetCode.
  ///
  /// In en, this message translates to:
  /// **'Send reset code'**
  String get sendResetCode;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sending;

  /// No description provided for @sendingMove.
  ///
  /// In en, this message translates to:
  /// **'Sending move…'**
  String get sendingMove;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @serverTournamentsDemo.
  ///
  /// In en, this message translates to:
  /// **'Server tournaments unavailable — showing demo.\n{error}'**
  String serverTournamentsDemo(String error);

  /// No description provided for @sessionExpiredReset.
  ///
  /// In en, this message translates to:
  /// **'Session expired — request a new reset code'**
  String get sessionExpiredReset;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share coming soon'**
  String get shareComingSoon;

  /// No description provided for @shareInviteCaps.
  ///
  /// In en, this message translates to:
  /// **'SHARE INVITE'**
  String get shareInviteCaps;

  /// No description provided for @shareOnWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get shareOnWhatsApp;

  /// No description provided for @shareProfile.
  ///
  /// In en, this message translates to:
  /// **'Share profile'**
  String get shareProfile;

  /// No description provided for @shareWin.
  ///
  /// In en, this message translates to:
  /// **'I just won a match of DROTIX! Think you can beat me? Play now: {url}'**
  String shareWin(String url);

  /// No description provided for @shareWinVs.
  ///
  /// In en, this message translates to:
  /// **'I just won a match of DROTIX against {name}! Think you can beat me? Play now: {url}'**
  String shareWinVs(String name, String url);

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @showHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Show or hide password'**
  String get showHidePassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Sign in to change photo'**
  String get signInChangePhoto;

  /// No description provided for @signInFindFriends.
  ///
  /// In en, this message translates to:
  /// **'Sign in to find friends'**
  String get signInFindFriends;

  /// No description provided for @signInMatchmaking.
  ///
  /// In en, this message translates to:
  /// **'Sign in required for online matchmaking'**
  String get signInMatchmaking;

  /// No description provided for @signInNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your notifications'**
  String get signInNotifications;

  /// No description provided for @signInOnline.
  ///
  /// In en, this message translates to:
  /// **'Sign in to play online multiplayer'**
  String get signInOnline;

  /// No description provided for @signInRandomMatch.
  ///
  /// In en, this message translates to:
  /// **'Sign in to play Random Match against real players'**
  String get signInRandomMatch;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get signInRequired;

  /// No description provided for @signInSearchPlayers.
  ///
  /// In en, this message translates to:
  /// **'Sign in to search players and sync friends to the cloud.'**
  String get signInSearchPlayers;

  /// No description provided for @signInToAddFriends.
  ///
  /// In en, this message translates to:
  /// **'Sign in to add friends'**
  String get signInToAddFriends;

  /// No description provided for @signInToChallenge.
  ///
  /// In en, this message translates to:
  /// **'Sign in to challenge this player'**
  String get signInToChallenge;

  /// No description provided for @signInWalletHistory.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your wallet history.'**
  String get signInWalletHistory;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get signInWithEmail;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @somethingWentWrongDetail.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String somethingWentWrongDetail(String error);

  /// No description provided for @soundDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sound disabled'**
  String get soundDisabled;

  /// No description provided for @soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound effects'**
  String get soundEffects;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound enabled'**
  String get soundEnabled;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @sponsored.
  ///
  /// In en, this message translates to:
  /// **'Sponsored'**
  String get sponsored;

  /// No description provided for @stakeDot.
  ///
  /// In en, this message translates to:
  /// **'Stake · {n}'**
  String stakeDot(String n);

  /// No description provided for @stakeReturned.
  ///
  /// In en, this message translates to:
  /// **'Stake returned'**
  String get stakeReturned;

  /// No description provided for @stakeRoom.
  ///
  /// In en, this message translates to:
  /// **'Stake {stake} · {room}…'**
  String stakeRoom(String stake, String room);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @startPlayingCaps.
  ///
  /// In en, this message translates to:
  /// **'START PLAYING'**
  String get startPlayingCaps;

  /// No description provided for @starterPack.
  ///
  /// In en, this message translates to:
  /// **'Starter pack'**
  String get starterPack;

  /// No description provided for @starting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get starting;

  /// No description provided for @startsInCaps.
  ///
  /// In en, this message translates to:
  /// **'STARTS IN'**
  String get startsInCaps;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusLabel(String status);

  /// No description provided for @stayInApp.
  ///
  /// In en, this message translates to:
  /// **'Stay in the app. We will alert you when your match is ready.'**
  String get stayInApp;

  /// No description provided for @stillOffline.
  ///
  /// In en, this message translates to:
  /// **'Still offline. Check your connection and try again.'**
  String get stillOffline;

  /// No description provided for @stopChat.
  ///
  /// In en, this message translates to:
  /// **'Stop chat'**
  String get stopChat;

  /// No description provided for @submitAppeal.
  ///
  /// In en, this message translates to:
  /// **'Submit appeal'**
  String get submitAppeal;

  /// No description provided for @submitReportCaps.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT REPORT'**
  String get submitReportCaps;

  /// No description provided for @submittedAt.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String submittedAt(String date);

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// No description provided for @submittingCaps.
  ///
  /// In en, this message translates to:
  /// **'SUBMITTING…'**
  String get submittingCaps;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support email'**
  String get supportEmail;

  /// No description provided for @suspendedAt.
  ///
  /// In en, this message translates to:
  /// **'Suspended: {date}'**
  String suspendedAt(String date);

  /// No description provided for @suspendedByModerator.
  ///
  /// In en, this message translates to:
  /// **'A moderator suspended this account after a report review.'**
  String get suspendedByModerator;

  /// No description provided for @suspendedRules.
  ///
  /// In en, this message translates to:
  /// **'You cannot play matches, join rooms, or use chat while suspended. You may submit one appeal for review.'**
  String get suspendedRules;

  /// No description provided for @t20Seconds.
  ///
  /// In en, this message translates to:
  /// **'20 seconds per move'**
  String get t20Seconds;

  /// No description provided for @tDrawReplays.
  ///
  /// In en, this message translates to:
  /// **'A draw replays the round'**
  String get tDrawReplays;

  /// No description provided for @tSingleElim.
  ///
  /// In en, this message translates to:
  /// **'Single elimination: lose once and you are out'**
  String get tSingleElim;

  /// No description provided for @tSingleElimFee.
  ///
  /// In en, this message translates to:
  /// **'Single elimination. If you lose a round you are out, and the entry fee is not returned.'**
  String get tSingleElimFee;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'The deadliest little game'**
  String get tagline;

  /// No description provided for @takeTurnsBody.
  ///
  /// In en, this message translates to:
  /// **'You and your rival place one mark each turn. Tap an empty square to make your move.'**
  String get takeTurnsBody;

  /// No description provided for @takeTurnsCaps.
  ///
  /// In en, this message translates to:
  /// **'TAKE TURNS'**
  String get takeTurnsCaps;

  /// No description provided for @takesFewSeconds.
  ///
  /// In en, this message translates to:
  /// **'This usually takes a few seconds.'**
  String get takesFewSeconds;

  /// No description provided for @tapEmptySquare.
  ///
  /// In en, this message translates to:
  /// **'Tap an empty square'**
  String get tapEmptySquare;

  /// No description provided for @tbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get tbd;

  /// No description provided for @tellUsMin10.
  ///
  /// In en, this message translates to:
  /// **'Please tell us what happened (at least 10 characters)'**
  String get tellUsMin10;

  /// No description provided for @termsAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your sign-in secure. You are responsible for activity on your account.'**
  String get termsAccountBody;

  /// No description provided for @termsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Your account'**
  String get termsAccountTitle;

  /// No description provided for @termsChangesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update these terms. Continued use means you accept the updates.'**
  String get termsChangesBody;

  /// No description provided for @termsChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Changes'**
  String get termsChangesTitle;

  /// No description provided for @termsCoinsBody.
  ///
  /// In en, this message translates to:
  /// **'Coins are virtual items with no cash value and cannot be exchanged for money.'**
  String get termsCoinsBody;

  /// No description provided for @termsCoinsTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Virtual coins'**
  String get termsCoinsTitle;

  /// No description provided for @termsFairBody.
  ///
  /// In en, this message translates to:
  /// **'No cheating, abuse or harassment. We may suspend accounts that break the rules.'**
  String get termsFairBody;

  /// No description provided for @termsFairTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Fair play and chat'**
  String get termsFairTitle;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get termsOfService;

  /// No description provided for @termsUsingBody.
  ///
  /// In en, this message translates to:
  /// **'You must follow these terms and play fairly.'**
  String get termsUsingBody;

  /// No description provided for @termsUsingTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Using DROTIX'**
  String get termsUsingTitle;

  /// No description provided for @theirTurnCaps.
  ///
  /// In en, this message translates to:
  /// **'THEIR TURN'**
  String get theirTurnCaps;

  /// No description provided for @threeInRowBody.
  ///
  /// In en, this message translates to:
  /// **'Line up three of your marks in a row, in a column or on a diagonal before your rival does.'**
  String get threeInRowBody;

  /// No description provided for @threeInRowCaps.
  ///
  /// In en, this message translates to:
  /// **'THREE IN A ROW'**
  String get threeInRowCaps;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String timeDaysAgo(String n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String timeHoursAgo(String n);

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String timeMinutesAgo(String n);

  /// No description provided for @timeSkipped.
  ///
  /// In en, this message translates to:
  /// **'Run out of time and the move is skipped.'**
  String get timeSkipped;

  /// No description provided for @timesUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up · {who}'**
  String timesUp(String who);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @todayCaps.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayCaps;

  /// No description provided for @top16.
  ///
  /// In en, this message translates to:
  /// **'Top 16'**
  String get top16;

  /// No description provided for @totalCoinsCaps.
  ///
  /// In en, this message translates to:
  /// **'TOTAL COINS'**
  String get totalCoinsCaps;

  /// No description provided for @tournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get tournament;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @tryAgainCaps.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgainCaps;

  /// No description provided for @twoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Two players, one phone'**
  String get twoPlayers;

  /// No description provided for @txChallengeEntry.
  ///
  /// In en, this message translates to:
  /// **'Challenge entry'**
  String get txChallengeEntry;

  /// No description provided for @txCoinPurchase.
  ///
  /// In en, this message translates to:
  /// **'Coin purchase'**
  String get txCoinPurchase;

  /// No description provided for @txDailyBonus.
  ///
  /// In en, this message translates to:
  /// **'Daily bonus · {time}'**
  String txDailyBonus(String time);

  /// No description provided for @txDailyReward.
  ///
  /// In en, this message translates to:
  /// **'Daily reward'**
  String get txDailyReward;

  /// No description provided for @txFreeVideo.
  ///
  /// In en, this message translates to:
  /// **'Free video reward'**
  String get txFreeVideo;

  /// No description provided for @txMatchWin.
  ///
  /// In en, this message translates to:
  /// **'Match win'**
  String get txMatchWin;

  /// No description provided for @txPurchasing.
  ///
  /// In en, this message translates to:
  /// **'Purchasing coins · {time}'**
  String txPurchasing(String time);

  /// No description provided for @txReferral.
  ///
  /// In en, this message translates to:
  /// **'Referral code · {time}'**
  String txReferral(String time);

  /// No description provided for @txTournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament · {time}'**
  String txTournament(String time);

  /// No description provided for @txTournamentPrize.
  ///
  /// In en, this message translates to:
  /// **'Tournament prize'**
  String get txTournamentPrize;

  /// No description provided for @txWatchingAds.
  ///
  /// In en, this message translates to:
  /// **'Watching ads · {time}'**
  String txWatchingAds(String time);

  /// No description provided for @txWelcomeBonus.
  ///
  /// In en, this message translates to:
  /// **'Welcome bonus'**
  String get txWelcomeBonus;

  /// No description provided for @txWinning.
  ///
  /// In en, this message translates to:
  /// **'Winning matches · {time}'**
  String txWinning(String time);

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeMessage;

  /// No description provided for @unblockPlayer.
  ///
  /// In en, this message translates to:
  /// **'Unblock player'**
  String get unblockPlayer;

  /// No description provided for @unblockToAdd.
  ///
  /// In en, this message translates to:
  /// **'Unblock this player to add them'**
  String get unblockToAdd;

  /// No description provided for @unblockToChallenge.
  ///
  /// In en, this message translates to:
  /// **'Unblock this player to challenge'**
  String get unblockToChallenge;

  /// No description provided for @unlockFor.
  ///
  /// In en, this message translates to:
  /// **'Unlock · {n} coins'**
  String unlockFor(String n);

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @unlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{n} of {total} unlocked'**
  String unlockedCount(String n, String total);

  /// No description provided for @unranked.
  ///
  /// In en, this message translates to:
  /// **'Unranked'**
  String get unranked;

  /// No description provided for @upTo3Images.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 images. Only our team can see them.'**
  String get upTo3Images;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailable;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @updateOnAppStore.
  ///
  /// In en, this message translates to:
  /// **'Update on the App Store'**
  String get updateOnAppStore;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequired;

  /// No description provided for @updatesOnlyMobile.
  ///
  /// In en, this message translates to:
  /// **'Updates are available on Android and iOS.'**
  String get updatesOnlyMobile;

  /// No description provided for @useChatReport.
  ///
  /// In en, this message translates to:
  /// **'Use Chat → Report during a live match for evidence-based reports.'**
  String get useChatReport;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username (a-z, 0-9, _)'**
  String get usernameHint;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @verifyFailBody.
  ///
  /// In en, this message translates to:
  /// **'This can happen on a weak connection, or if the reward was already claimed. Your coins are safe.'**
  String get verifyFailBody;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get verifying;

  /// No description provided for @verifyingReward.
  ///
  /// In en, this message translates to:
  /// **'Verifying your reward'**
  String get verifyingReward;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @versionUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported. Update to keep playing.'**
  String get versionUnsupported;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'VICTORY'**
  String get victory;

  /// No description provided for @videoLength.
  ///
  /// In en, this message translates to:
  /// **'The video is about 15 to 30 seconds. Watch it to the end to get your coins.'**
  String get videoLength;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @viewAppealStatus.
  ///
  /// In en, this message translates to:
  /// **'View appeal status'**
  String get viewAppealStatus;

  /// No description provided for @viewBracket.
  ///
  /// In en, this message translates to:
  /// **'View bracket'**
  String get viewBracket;

  /// No description provided for @viewBracketCaps.
  ///
  /// In en, this message translates to:
  /// **'VIEW BRACKET'**
  String get viewBracketCaps;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfile;

  /// No description provided for @vsName.
  ///
  /// In en, this message translates to:
  /// **'vs {name}'**
  String vsName(String name);

  /// No description provided for @waitingCaps.
  ///
  /// In en, this message translates to:
  /// **'WAITING'**
  String get waitingCaps;

  /// No description provided for @waitingForAccept.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to accept…'**
  String waitingForAccept(String name);

  /// No description provided for @waitingForFriend.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a friend...'**
  String get waitingForFriend;

  /// No description provided for @waitingOtherMatches.
  ///
  /// In en, this message translates to:
  /// **'Waiting for other matches'**
  String get waitingOtherMatches;

  /// No description provided for @waitingRoundOpen.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the round to open'**
  String get waitingRoundOpen;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get walletBalance;

  /// No description provided for @walletCaps.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get walletCaps;

  /// No description provided for @walletUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Wallet unavailable'**
  String get walletUnavailable;

  /// No description provided for @watchAnotherLeft.
  ///
  /// In en, this message translates to:
  /// **'WATCH ANOTHER ({n} LEFT)'**
  String watchAnotherLeft(String n);

  /// No description provided for @watchBracketCaps.
  ///
  /// In en, this message translates to:
  /// **'WATCH THE BRACKET'**
  String get watchBracketCaps;

  /// No description provided for @watchFullVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch the full video to claim your bonus coins.'**
  String get watchFullVideo;

  /// No description provided for @watchNowCaps.
  ///
  /// In en, this message translates to:
  /// **'WATCH NOW'**
  String get watchNowCaps;

  /// No description provided for @watchShortVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch a short video'**
  String get watchShortVideo;

  /// No description provided for @watchShortVideoToGet.
  ///
  /// In en, this message translates to:
  /// **'Watch a short video to get +{n}'**
  String watchShortVideoToGet(String n);

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'WATCH VIDEO'**
  String get watchVideo;

  /// No description provided for @watchVideoCoins.
  ///
  /// In en, this message translates to:
  /// **'Watch a video, get 10 coins'**
  String get watchVideoCoins;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @weeklyChest.
  ///
  /// In en, this message translates to:
  /// **'Weekly chest'**
  String get weeklyChest;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBonusCaps.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BONUS'**
  String get welcomeBonusCaps;

  /// No description provided for @welcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeName(String name);

  /// No description provided for @whatHappenedCaps.
  ///
  /// In en, this message translates to:
  /// **'WHAT HAPPENED'**
  String get whatHappenedCaps;

  /// No description provided for @whatHappenedHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what happened and why you are reporting this player'**
  String get whatHappenedHint;

  /// No description provided for @whatsNewCaps.
  ///
  /// In en, this message translates to:
  /// **'WHAT\'S NEW'**
  String get whatsNewCaps;

  /// No description provided for @whoCanChallenge.
  ///
  /// In en, this message translates to:
  /// **'Who can challenge you'**
  String get whoCanChallenge;

  /// No description provided for @whoCanMessage.
  ///
  /// In en, this message translates to:
  /// **'Who can send you messages'**
  String get whoCanMessage;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win rate'**
  String get winRate;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'WINNER'**
  String get winner;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @winsThisRound.
  ///
  /// In en, this message translates to:
  /// **'{name} wins this round.'**
  String winsThisRound(String name);

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete'**
  String get yesDelete;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @yesterdayCaps.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterdayCaps;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @youBeat.
  ///
  /// In en, this message translates to:
  /// **'You beat {name}.'**
  String youBeat(String name);

  /// No description provided for @youFinished.
  ///
  /// In en, this message translates to:
  /// **'You finished'**
  String get youFinished;

  /// No description provided for @youLose.
  ///
  /// In en, this message translates to:
  /// **'You lose'**
  String get youLose;

  /// No description provided for @youMark.
  ///
  /// In en, this message translates to:
  /// **'You · {mark}'**
  String youMark(String mark);

  /// No description provided for @youWin.
  ///
  /// In en, this message translates to:
  /// **'You win!'**
  String get youWin;

  /// No description provided for @youWinCaps.
  ///
  /// In en, this message translates to:
  /// **'YOU WIN'**
  String get youWinCaps;

  /// No description provided for @youX.
  ///
  /// In en, this message translates to:
  /// **'You: X'**
  String get youX;

  /// No description provided for @yourBalance.
  ///
  /// In en, this message translates to:
  /// **'Your balance: {n} coins'**
  String yourBalance(String n);

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'your email'**
  String get yourEmail;

  /// No description provided for @yourMatchReadyCaps.
  ///
  /// In en, this message translates to:
  /// **'YOUR MATCH IS READY'**
  String get yourMatchReadyCaps;

  /// No description provided for @yourMove.
  ///
  /// In en, this message translates to:
  /// **'Your move'**
  String get yourMove;

  /// No description provided for @yourNextMatch.
  ///
  /// In en, this message translates to:
  /// **'Your next match'**
  String get yourNextMatch;

  /// No description provided for @yourTurnCaps.
  ///
  /// In en, this message translates to:
  /// **'YOUR TURN'**
  String get yourTurnCaps;

  /// No description provided for @youreInCaps.
  ///
  /// In en, this message translates to:
  /// **'YOU\'RE IN'**
  String get youreInCaps;

  /// No description provided for @youreInViewBracket.
  ///
  /// In en, this message translates to:
  /// **'YOU\'RE IN — VIEW BRACKET'**
  String get youreInViewBracket;

  /// No description provided for @youreOffline.
  ///
  /// In en, this message translates to:
  /// **'You’re offline'**
  String get youreOffline;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'de',
        'en',
        'es',
        'fr',
        'gu',
        'hi',
        'it',
        'ja',
        'kn',
        'ko',
        'ml',
        'mr',
        'or',
        'pa',
        'pt',
        'ru',
        'ta',
        'te',
        'ur',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'bn':
      return L10nBn();
    case 'de':
      return L10nDe();
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
    case 'fr':
      return L10nFr();
    case 'gu':
      return L10nGu();
    case 'hi':
      return L10nHi();
    case 'it':
      return L10nIt();
    case 'ja':
      return L10nJa();
    case 'kn':
      return L10nKn();
    case 'ko':
      return L10nKo();
    case 'ml':
      return L10nMl();
    case 'mr':
      return L10nMr();
    case 'or':
      return L10nOr();
    case 'pa':
      return L10nPa();
    case 'pt':
      return L10nPt();
    case 'ru':
      return L10nRu();
    case 'ta':
      return L10nTa();
    case 'te':
      return L10nTe();
    case 'ur':
      return L10nUr();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
