// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX is a fast, competitive game of three in a row. Play the computer, match with real players, challenge friends and climb the leaderboard.';

  @override
  String get aboutUs => 'About us';

  @override
  String get accept => 'Accept';

  @override
  String get acceptCaps => 'ACCEPT';

  @override
  String get acceptRequestCaps => 'ACCEPT REQUEST';

  @override
  String get accountCheckFailed => 'Account check failed';

  @override
  String get accountIsSuspended => 'Your account is suspended.';

  @override
  String get accountRestricted =>
      'Your account remains restricted until a moderator finishes review. Gameplay, matchmaking, and chat stay locked.';

  @override
  String get accountStatusUnknown => 'Account status unknown. Try again.';

  @override
  String get accountSuspended => 'Account suspended';

  @override
  String get accountSuspendedSignIn =>
      'Your account was suspended. Sign in to view details or appeal.';

  @override
  String get accountSuspendedTitle => 'Your account has been suspended';

  @override
  String get ach100Wins => '100 wins';

  @override
  String get ach10Matches => '10 matches';

  @override
  String get ach50Matches => '50 matches';

  @override
  String get achChallenger => 'Challenger';

  @override
  String get achChampion => 'Champion';

  @override
  String get achFirstWin => 'First win';

  @override
  String get achScore100 => 'Score 100';

  @override
  String get achStreak3 => 'Win streak 3';

  @override
  String get achStreak5 => 'Win streak 5';

  @override
  String get achSurvivor => 'Survivor';

  @override
  String get achTop3 => 'Top 3';

  @override
  String get achievements => 'Achievements';

  @override
  String get add => 'Add';

  @override
  String get addFriend => 'Add friend';

  @override
  String get addFriendCaps => 'ADD FRIEND';

  @override
  String get advanceQuarter => 'You advance to the Quarter-final';

  @override
  String get advancedMode => 'Advanced mode (4×4)';

  @override
  String get advertiserApp => 'Advertiser app';

  @override
  String get advertiserVideo => 'Advertiser video plays here';

  @override
  String get all => 'All';

  @override
  String get allowAndInstall => 'Allow & install';

  @override
  String get allowUnknownApps =>
      'Allow \"Install unknown apps\" for DROTIX, then come back. The update installs automatically.';

  @override
  String get alreadyPlayer => 'Already a player?';

  @override
  String get alsoBlock => 'Also block this player';

  @override
  String get alwaysTrue => 'Always true';

  @override
  String get appUpdate => 'App update';

  @override
  String get appealExplain =>
      'Explain why your account should be reinstated. A moderator will review your message.';

  @override
  String get appealFailed => 'Appeal failed';

  @override
  String get appealHint => 'Write your appeal (min 20 characters)…';

  @override
  String get appealIsUnderReview => 'Your appeal is under review.';

  @override
  String get appealMin20 => 'Appeal must be at least 20 characters';

  @override
  String get appealSubmitted => 'Appeal submitted successfully';

  @override
  String get appealSuspension => 'Appeal suspension';

  @override
  String get appealUnderReview => 'Appeal under review';

  @override
  String get applyCodeCaps => 'APPLY CODE';

  @override
  String get attachRecentChat => 'Attach recent chat messages';

  @override
  String get attemptingReconnect => 'Attempting to reconnect…';

  @override
  String get auto => 'Auto';

  @override
  String get avatars => 'Avatars';

  @override
  String get back => 'Back';

  @override
  String get backToEvent => 'Back to event';

  @override
  String get backToEvents => 'Back to events';

  @override
  String get backToEventsCaps => 'BACK TO EVENTS';

  @override
  String get backToHome => 'Back to home';

  @override
  String get backToMenu => 'Back to menu';

  @override
  String get backToSignIn => 'Back to Sign in';

  @override
  String balance(String n) {
    return 'Balance $n';
  }

  @override
  String get balanceAfter => 'Balance after';

  @override
  String balanceArrow(String from) {
    return 'Balance $from →';
  }

  @override
  String get bestStreak => 'Best streak';

  @override
  String get bestValue => 'Best value';

  @override
  String get biggerBoardsBody =>
      'On larger boards you need four in a row to win. If the board fills up with no line, it is a draw.';

  @override
  String get biggerBoardsCaps => 'BIGGER BOARDS';

  @override
  String get biggerNeedFour => 'Bigger boards need four in a row';

  @override
  String get blockPlayer => 'Block player';

  @override
  String get boardHiddenUntilBack => 'The board is hidden until you are back.';

  @override
  String get boards => 'Boards';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n coins added to your wallet';
  }

  @override
  String get bonusClaimed => 'Bonus claimed!';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n bonus coins added';
  }

  @override
  String get bracket => 'Bracket';

  @override
  String get bracketInfo =>
      'Round of 16 · 8 matches, 4 shown. You are highlighted.';

  @override
  String get buyCoinsCaps => 'BUY COINS';

  @override
  String get byBoard => 'By board';

  @override
  String get cameraOnlyForScan => 'The camera is only used to scan the code.';

  @override
  String get cameraPermissionNeeded =>
      'Camera permission needed to scan. You can still enter the code below.';

  @override
  String get cameraPermissionRequired =>
      'Camera permission is required to scan a room QR code. Enable Camera for this app in system settings, then try again.';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelChallenge => 'Cancel challenge';

  @override
  String get cancelDownload => 'Cancel download';

  @override
  String get cannotChallengeSelf => 'You cannot challenge yourself';

  @override
  String get cannotFriendSelf => 'You cannot add yourself as a friend';

  @override
  String get cantChallengeNow => 'You can\'t challenge this player right now.';

  @override
  String get challenge => 'Challenge';

  @override
  String get challengeAccepted => 'Challenge accepted';

  @override
  String get challengeCancelled => 'Challenge cancelled';

  @override
  String get challengeCaps => 'CHALLENGE';

  @override
  String get challengeClosed => 'Challenge closed';

  @override
  String get challengeDeclined => 'Challenge declined';

  @override
  String get challengeExpired => 'Challenge expired';

  @override
  String get challengeExpiresIn60 =>
      'Challenge expires in 60 seconds if not accepted.';

  @override
  String get challengePrivacy => 'Challenge privacy';

  @override
  String get challengeRequests => 'Challenge requests';

  @override
  String get challengeSentCoins => 'Challenge sent · 5 coins';

  @override
  String get challengeSentFree => 'Challenge sent · Free match';

  @override
  String get challenges => 'Challenges';

  @override
  String get championCaps => 'CHAMPION';

  @override
  String get change => 'Change';

  @override
  String get chat => 'Chat';

  @override
  String get chatAfterAccept => 'Chat after both players accept the request.';

  @override
  String get chatAfterAcceptRandom =>
      'Chat after both players accept. Nothing is shared beyond the username.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name only accepts messages from friends.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name has turned off messages.';
  }

  @override
  String get chatNotConnected => 'Chat is not connected';

  @override
  String get chatOn => 'Chat on';

  @override
  String get chatPrivacyNote =>
      'Applies to in-match chat. Changes work right away, even during a match.';

  @override
  String get chatRules => 'Chat rules';

  @override
  String get chatRulesIntro =>
      'Text chat never starts on its own. One player asks, the other must accept.';

  @override
  String get checkAgainCaps => 'CHECK AGAIN';

  @override
  String get checkEmail => 'Check email';

  @override
  String get checkEmailConfirm =>
      'Check your email and open the confirmation link';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkInbox => 'Check your inbox';

  @override
  String get checking => 'Checking…';

  @override
  String get chooseEntryStake => 'Choose your entry stake';

  @override
  String get chooseGameMode => 'Choose your game mode';

  @override
  String get chooseNewPassword => 'Choose a new password';

  @override
  String get chooseOpponent => 'Choose an opponent';

  @override
  String get claim => 'CLAIM';

  @override
  String claimBonusCoins(String n) {
    return 'Claim $n Bonus Coins';
  }

  @override
  String get claimLabel => 'Claim';

  @override
  String claimPlusCoins(String n) {
    return 'Claim +$n coins';
  }

  @override
  String get claimVictory => 'Claim victory';

  @override
  String get claimsSync => 'Claims sync to your cloud account';

  @override
  String get classicMode => 'Classic mode (3×3)';

  @override
  String get clearAll => 'Clear all';

  @override
  String get clipboardNoCode => 'Clipboard has no room code';

  @override
  String get close => 'Close';

  @override
  String get closeAndLose => 'Close and lose reward';

  @override
  String get closeRoom => 'Close room';

  @override
  String get closing => 'Closing…';

  @override
  String get cloud => 'Cloud';

  @override
  String cloudSaveFailed(String message) {
    return 'Cloud save failed: $message';
  }

  @override
  String get codeSent => 'Code sent';

  @override
  String get coinPacks => 'Coin packs';

  @override
  String coinPacksFrom(String price) {
    return 'COIN PACKS FROM $price';
  }

  @override
  String get coins5 => '5 coins';

  @override
  String coinsAdded(String n) {
    return '+$n coins added';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Coins $delta · Balance $balance';
  }

  @override
  String get coinsEntryFee => '5 coins entry fee';

  @override
  String get coinsEntryFeeBody =>
      'Used after free matches run out, or to raise the stakes.';

  @override
  String coinsLabel(String n) {
    return '$n coins';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n coins (saved to cloud)';
  }

  @override
  String get column => 'Column';

  @override
  String get comeBackTomorrow => 'Come back tomorrow';

  @override
  String get completeGoogleReturnApp =>
      'Complete Google sign-in, then return to the app';

  @override
  String get completeGoogleSignIn => 'Complete Google sign-in, then return';

  @override
  String get computer => 'Computer';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmJoinCaps => 'CONFIRM & JOIN';

  @override
  String confirmLinkSentTo(String target) {
    return 'We sent a confirmation link to $target.\nOpen the link on this device, then return here — you’ll be signed in automatically.';
  }

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmationEmailSent =>
      'Confirmation email sent — check your inbox';

  @override
  String get confirmingVideo =>
      'Confirming the video was watched. Please wait.';

  @override
  String get connectingChat => 'Connecting chat…';

  @override
  String get connectionUnstable => 'Connection unstable';

  @override
  String get connectionUnstableCaps => 'CONNECTION UNSTABLE';

  @override
  String get contactAbout => 'Contact & about';

  @override
  String get contactUsCaps => 'CONTACT US';

  @override
  String get continueLabel => 'Continue';

  @override
  String get continuePlaying => 'Continue playing';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String copiedValue(String label, String value) {
    return '$label copied: $value';
  }

  @override
  String get couldNotAddCoins => 'Could not add coins';

  @override
  String get couldNotApplyReferral => 'Could not apply referral code';

  @override
  String couldNotCheck(String error) {
    return 'Could not check: $error';
  }

  @override
  String get couldNotJoinRoom => 'Could not join room';

  @override
  String get couldNotLoadPrivacy => 'Could not load privacy settings';

  @override
  String get couldNotLoadProfile => 'Could not load your profile. Try again.';

  @override
  String get couldNotOpenGoogle => 'Could not open Google sign-in';

  @override
  String get couldNotSavePrivacy => 'Could not save privacy settings';

  @override
  String get couldNotStopChat => 'Could not stop chat';

  @override
  String get couldNotSubmitAppeal => 'Could not submit appeal';

  @override
  String get couldNotVerify => 'We could not verify it';

  @override
  String get couldNotVerifyAccount =>
      'Could not verify account status. Try again.';

  @override
  String get createAccount => 'Create account';

  @override
  String get createPrivateRoom => 'Create private room';

  @override
  String get customize => 'Customize';

  @override
  String get daily => 'Daily';

  @override
  String get dailyChest => 'Daily chest';

  @override
  String get dailyLimit => 'DAILY LIMIT REACHED';

  @override
  String get date => 'Date';

  @override
  String dayN(String n) {
    return 'Day $n';
  }

  @override
  String dayStreak(String n) {
    return '$n-day streak';
  }

  @override
  String get days30 => '30 days';

  @override
  String get days7 => '7 days';

  @override
  String get debitFailed => 'Could not take coins';

  @override
  String get declineCaps => 'DECLINE';

  @override
  String get defeat => 'DEFEAT';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountBody =>
      'This removes your coins, score and history for good.';

  @override
  String get deleteAccountQuestion => 'Delete account?';

  @override
  String get descriptionMin10 => 'Description must be at least 10 characters';

  @override
  String get diagonal => 'Diagonal';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get doll => 'Doll';

  @override
  String get done => 'Done';

  @override
  String get downloadAndInstall => 'Download & Install';

  @override
  String get downloading => 'Downloading…';

  @override
  String downloadingPercent(String percent) {
    return 'Downloading $percent%';
  }

  @override
  String get draw => 'Draw';

  @override
  String get drawBadge => 'DRAW';

  @override
  String get draws => 'Draws';

  @override
  String get duration => 'Duration';

  @override
  String get earned => 'Earned';

  @override
  String get earnedThisWeek => 'Earned this week, by source';

  @override
  String get editProfileCaps => 'EDIT PROFILE';

  @override
  String get eliminatedCaps => 'ELIMINATED';

  @override
  String get email => 'Email';

  @override
  String get emailNotConfirmed => 'Email not confirmed';

  @override
  String emailNotConfirmedBody(String email) {
    return 'Your registration worked, but your email isn\'t confirmed yet.\n\nOpen the confirmation link in your Inbox or Spam folder, then sign in again.\n\n$email';
  }

  @override
  String get emailSentAgain => 'Email sent again — check your inbox';

  @override
  String get endsIn => 'Ends in';

  @override
  String get enterCode => 'Enter code';

  @override
  String get enterCodeFromEmail => 'Enter the code from your email';

  @override
  String get enterCodeInstead => 'Enter code instead';

  @override
  String get enterEmailPassword => 'Enter email and password';

  @override
  String get enterFullCode => 'Enter the full room code';

  @override
  String get enterReferralOrSkip => 'Enter a referral code, or skip for now';

  @override
  String get enterResetCode => 'Enter reset code';

  @override
  String get enterValidMobile => 'Enter a valid mobile number';

  @override
  String get enterValidReferral => 'Enter a valid referral code';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get entry => 'Entry';

  @override
  String get entryFee => 'Entry fee';

  @override
  String get equip => 'Equip';

  @override
  String get equipped => 'Equipped';

  @override
  String get events => 'Events';

  @override
  String get everyone => 'Everyone';

  @override
  String get expertMode => 'Expert mode (5×5)';

  @override
  String get expiredMoveToHistory => 'Expired challenges move to History.';

  @override
  String get failed => 'Failed';

  @override
  String get fillAllFields => 'Fill in all fields';

  @override
  String get finalRound => 'Final';

  @override
  String get findAMatch => 'Find a match';

  @override
  String get findOpponent => 'Find opponent';

  @override
  String get findPrivateJoin => 'Find · private room · join code';

  @override
  String get findingOpponent => 'Finding an opponent';

  @override
  String get findingPlayer => 'Finding a player';

  @override
  String get firstMatchSet => 'Your first match is set when the round opens.';

  @override
  String get fiveOfFiveWatched => '5 of 5 videos watched';

  @override
  String get flash => 'Flash';

  @override
  String get flashUnavailable => 'Flash not available';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get free => 'Free';

  @override
  String get freeCoins => 'FREE COINS';

  @override
  String get freeMatch => 'Free match';

  @override
  String get freeMatchesPerDay => '3 free matches per day';

  @override
  String get freeVideosToday => 'Free videos today';

  @override
  String freeVideosUsed(String used) {
    return '$used of 5 free videos used today';
  }

  @override
  String get friendChallenge => 'Friend challenge';

  @override
  String get friendRequestExists => 'Friend request already exists';

  @override
  String friendRequestSent(String name) {
    return 'Friend request sent to $name';
  }

  @override
  String get friendRequestSentShort => 'Friend request sent';

  @override
  String get friendsCaps => 'FRIENDS';

  @override
  String get friendsLabel => 'Friends';

  @override
  String get friendsOnly => 'Friends only';

  @override
  String get fromPhoto => 'From photo';

  @override
  String gameComingSoon(String game) {
    return '$game: coming soon';
  }

  @override
  String get gameOver => 'Game over';

  @override
  String get gamePaused => 'Game paused';

  @override
  String get getStarted => 'Get started';

  @override
  String get gettingVideo => 'Getting your video…';

  @override
  String get goToMatchCaps => 'GO TO MATCH';

  @override
  String get gotIt => 'Got it';

  @override
  String get graceWindowEnded =>
      'The 30 second grace window has ended. You can claim the win.';

  @override
  String greatRun(String name) {
    return 'Great run in the $name';
  }

  @override
  String get guard => 'Guard';

  @override
  String get guest => 'Guest';

  @override
  String get history => 'History';

  @override
  String get historyNeverPublic =>
      'Your match history and activity are never shown on your public profile.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches matches · $wins wins · $losses losses · $draws draws';
  }

  @override
  String get howItWorks => 'How it works';

  @override
  String get howToPlay => 'How to play';

  @override
  String get howToPlayRules =>
      'Place three of your marks in a row, horizontal, vertical or diagonal, before your rival does. On bigger boards you need four in a row.';

  @override
  String howToPlayStep(String n) {
    return 'HOW TO PLAY · $n/3';
  }

  @override
  String get imReadyCaps => 'I\'M READY';

  @override
  String get imageTooBig => 'Image must be under 2 MB';

  @override
  String get install => 'Install';

  @override
  String get installUpdate => 'Install update';

  @override
  String get installed => 'Installed';

  @override
  String get internetRequired =>
      'Internet connection required. You can still play vs The Doll offline.';

  @override
  String get introBody1 => 'Beat the AI on 3×3, 4×4 or 5×5 boards.';

  @override
  String get introBody2 =>
      'Random matches with real players. Stake coins, win coins.';

  @override
  String get introBody3 =>
      'Daily rewards, missions and tournaments keep you moving up.';

  @override
  String get introTitle1 => 'Outsmart the Doll';

  @override
  String get introTitle2 => 'Duel the world';

  @override
  String get introTitle3 => 'Climb the ranks';

  @override
  String get invalidRoomQr => 'Invalid room QR';

  @override
  String get inviteImage => 'Invite image';

  @override
  String get inviteImageBody =>
      'Code, QR and link in one picture. Send it on WhatsApp or anywhere.';

  @override
  String isThinking(String name) {
    return '$name is thinking';
  }

  @override
  String get joinCaps => 'JOIN';

  @override
  String joinForCoins(String n) {
    return 'JOIN FOR $n COINS';
  }

  @override
  String get joinRoomCaps => 'JOIN ROOM';

  @override
  String get joinTheGame => 'Join the game';

  @override
  String joinTournamentQuestion(String name) {
    return 'Join $name?';
  }

  @override
  String get joinWithCode => 'Join with code';

  @override
  String get joined => 'Joined';

  @override
  String get joiningCaps => 'JOINING…';

  @override
  String get joiningQueue => 'Joining queue…';

  @override
  String get joiningRoom => 'Joining room…';

  @override
  String get keepWatchingCaps => 'KEEP WATCHING';

  @override
  String get language => 'Language';

  @override
  String get languageUpdated => 'Language updated';

  @override
  String get last20Sent => 'The last 20 messages are sent with your report.';

  @override
  String get last7Games => 'Last 7 games';

  @override
  String lastUpdated(String date) {
    return 'Last updated $date';
  }

  @override
  String get later => 'Later';

  @override
  String get latestVersion => 'You are using the latest version.';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get leaderboardUpdated => 'Leaderboard updated';

  @override
  String get leave => 'Leave';

  @override
  String get leaveForfeitBody =>
      'Leaving now counts as a forfeit. Your opponent wins.';

  @override
  String get leaveGame => 'Leave game';

  @override
  String get leaveMatchQuestion => 'Leave match?';

  @override
  String get leaveVideoQuestion => 'Leave the video?';

  @override
  String get letsPlay => 'Let\'s play';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get live => 'Live';

  @override
  String get liveEventCaps => 'LIVE EVENT';

  @override
  String get loading => 'Loading…';

  @override
  String get local => 'Local';

  @override
  String get locked => 'Locked';

  @override
  String get logOut => 'Log out';

  @override
  String get loginMethod => 'Login method';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'You will not get your 10 coins if you close it now. $seconds seconds left.';
  }

  @override
  String get losses => 'Losses';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get marks => 'Marks';

  @override
  String get match => 'Match';

  @override
  String get matchAbandonedCaps => 'MATCH ABANDONED';

  @override
  String matchDuration(String duration) {
    return 'Match duration $duration';
  }

  @override
  String get matchHistory => 'Match History';

  @override
  String get matchHistoryCaps => 'MATCH HISTORY';

  @override
  String get matchInvitations => 'Match invitations';

  @override
  String get matchLobby => 'Match lobby';

  @override
  String get matchResult => 'Match result';

  @override
  String get matchResults => 'Match results';

  @override
  String get matchStakes => 'Match stakes';

  @override
  String get matchStartsIn => 'Match starts in';

  @override
  String get matches => 'Matches';

  @override
  String get matchmakingError => 'Matchmaking error';

  @override
  String get matchmakingFailed => 'Matchmaking failed';

  @override
  String get matchmakingStopped => 'Matchmaking stopped';

  @override
  String memberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get messageEmpty => 'Message cannot be empty';

  @override
  String get messagesStayForMatch => 'Messages stay for this match';

  @override
  String minusCoins(String n) {
    return '-$n coins';
  }

  @override
  String get misPlay30 => 'Play 30 matches';

  @override
  String get misPlay5 => 'Play 5 matches';

  @override
  String get misQuick => 'Play a random match';

  @override
  String get misTourney => 'Join a tournament';

  @override
  String get misWin15 => 'Win 15 games';

  @override
  String get misWin3 => 'Win 3 games';

  @override
  String get misWin4x4 => 'Win on a 4×4 board';

  @override
  String get missResets =>
      'Miss a day and it resets. Come back tomorrow for the next reward.';

  @override
  String get missingChallengeData => 'Missing challenge data';

  @override
  String get missingEmail => 'Missing email — go back and try again';

  @override
  String get missions => 'Missions';

  @override
  String missionsDone(String done, String total) {
    return '$done of $total missions done';
  }

  @override
  String get mobileNotSupported =>
      'Mobile numbers are not supported in your region yet';

  @override
  String get mobileOptional => 'Mobile number (optional)';

  @override
  String mode(String n) {
    return 'Mode $n';
  }

  @override
  String get more => 'More';

  @override
  String get moreGames => 'More games';

  @override
  String get music => 'Music';

  @override
  String nOf5(String n) {
    return '$n of 5';
  }

  @override
  String get navPlay => 'Play';

  @override
  String get newCodeSent => 'New code sent — check your inbox';

  @override
  String get newHere => 'New here?';

  @override
  String get newMatchChallengeCaps => 'NEW MATCH CHALLENGE!';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordBody =>
      'Enter a new password for your account. You’ll stay signed in after saving.';

  @override
  String get newVersion => 'New version';

  @override
  String get newVersionReady => 'A new version of DROTIX is ready.';

  @override
  String get newVideosUnlockIn => 'New free videos unlock in';

  @override
  String get next => 'Next';

  @override
  String get nextCaps => 'NEXT';

  @override
  String get nextRound => 'Next round';

  @override
  String get no => 'No';

  @override
  String get noChallenge => 'No challenge';

  @override
  String get noChallengesHere => 'No challenges here.';

  @override
  String get noCloudMatches =>
      'No cloud matches yet. Play vs The Doll while signed in to appear here.';

  @override
  String get noFriendsYet => 'No friends yet — search to add someone.';

  @override
  String get noHistory => 'No history found';

  @override
  String get noMatchesYet => 'No matches yet';

  @override
  String get noMessagesYet => 'No messages yet.\nQuick replies work too.';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get noOpponentFound => 'No opponent found — try again';

  @override
  String get noPendingRequests => 'No pending requests.';

  @override
  String get noPlayersFound => 'No players found';

  @override
  String get noQrInPhoto => 'No QR found in photo';

  @override
  String get noRankedPlayers =>
      'No ranked players yet. Sign in and play to join the board.';

  @override
  String get noTransactions => 'No transactions yet.';

  @override
  String get noVideoFound =>
      'We could not find a video for you. Your free video was not used. Try again in a minute.';

  @override
  String get noVideoNow => 'No video available right now. Try again later.';

  @override
  String get noVideoRightNow => 'No video right now';

  @override
  String get nobody => 'Nobody';

  @override
  String get nobodyBlinked => 'Nobody blinked.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Nobody blinked. $name held you off.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name is not accepting challenges right now.';
  }

  @override
  String get notEnoughCoins => 'Not enough coins';

  @override
  String get notEnoughCoinsAnother => 'Not enough coins for another stake.';

  @override
  String get notEnoughCoinsStake => 'Not enough coins for this stake.';

  @override
  String get notNow => 'Not now';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get notSignedInYet => 'Not signed in yet — open the email link first';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name accepted your challenge. Match starting!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Challenge accepted';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name is in a match right now. Try again later.';
  }

  @override
  String get notifChallengeBusyTitle => 'Player is busy';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name cancelled the challenge';
  }

  @override
  String get notifChallengeCancelledTitle => 'Challenge cancelled';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name declined your challenge';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Challenge declined';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name did not respond in time';
  }

  @override
  String get notifChallengeExpiredTitle => 'Challenge expired';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name challenged you to a match';
  }

  @override
  String get notifChallengeRequestTitle => 'New challenge';

  @override
  String get notifChannelDesc => 'Challenges, matches and coin updates';

  @override
  String get notifChannelName => 'Game alerts';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount coins added. Balance: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Coins added';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount coins deducted. Balance: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Coins deducted';

  @override
  String get notifCoinsPurchaseTitle => 'Purchase complete';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'You earned $amount coins. Balance: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Reward received';

  @override
  String get notifEmptyHint =>
      'Challenges, match results and coin updates will show up here.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name accepted your friend request';
  }

  @override
  String get notifFriendAcceptedTitle => 'New friend';

  @override
  String notifFriendRequestBody(String name) {
    return '$name wants to be your friend';
  }

  @override
  String get notifFriendRequestTitle => 'Friend request';

  @override
  String get notifGeneric => 'New notification';

  @override
  String notifMatchBody(String name) {
    return 'Your match vs $name has ended';
  }

  @override
  String get notifMatchDrawTitle => 'Draw';

  @override
  String get notifMatchLostTitle => 'You lost';

  @override
  String get notifMatchWonTitle => 'You won!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name joined your private room';
  }

  @override
  String get notifRoomJoinedTitle => 'Player joined';

  @override
  String get notifications => 'Notifications';

  @override
  String nowFriends(String name) {
    return 'You and $name are now friends';
  }

  @override
  String get nowFriendsShort => 'You are now friends';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get offlineAi => 'Offline AI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'No internet · AI rivals only · $size · Stake $stake';
  }

  @override
  String get offlineBanner => 'Offline · Play vs The Doll still works';

  @override
  String get offlineBody =>
      'Online matches and tournaments need a connection. You can still play against The Doll.';

  @override
  String get offlineProfilesNote =>
      'These are offline AI profiles — not real online players.';

  @override
  String get offlineSmart => 'Offline, smart opponent';

  @override
  String get ok => 'OK';

  @override
  String get oneLastStepCaps => 'ONE LAST STEP';

  @override
  String get online => 'Online';

  @override
  String get onlineMatch => 'Online match';

  @override
  String get onlineMultiplayer => 'Online multiplayer';

  @override
  String get onlineOfflineAi => 'Online players · Offline AI';

  @override
  String onlineStake(String stake) {
    return 'Online · Stake $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name only accepts challenges from friends. Add them first.';
  }

  @override
  String get open => 'Open';

  @override
  String get openedTheLink => 'I’ve opened the link';

  @override
  String get openingInstaller => 'Opening installer…';

  @override
  String get opponent => 'Opponent';

  @override
  String get opponentAdvances =>
      'If you do not join in time, your opponent advances.';

  @override
  String get opponentDisconnected => 'Opponent disconnected';

  @override
  String get opponentWins => 'Opponent wins';

  @override
  String opponentsMove(String name) {
    return '$name\'s move';
  }

  @override
  String get or => 'Or';

  @override
  String get orEnterCodeCaps => 'OR ENTER THE CODE';

  @override
  String get otherEvents => 'Other events';

  @override
  String get owned => 'Owned';

  @override
  String get passAndPlay => 'Pass & Play';

  @override
  String get password => 'Password';

  @override
  String get passwordMin6 => 'Password must be at least 6 characters';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get passwordsNoMatch => 'Passwords do not match';

  @override
  String get pasteCode => 'Paste code';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Paused';

  @override
  String get perMove20s => '20s per move';

  @override
  String get photoUpdated => 'Photo updated';

  @override
  String get pickClosestReason => 'What is happening? Pick the closest reason.';

  @override
  String get pickYourGame => 'Pick your game';

  @override
  String get playAgain => 'Play again';

  @override
  String get playAsGuest => 'Play as guest';

  @override
  String get playCaps => 'PLAY';

  @override
  String get playDollOffline => 'Play vs The Doll offline';

  @override
  String get playToBuildForm => 'Play a match to build your form.';

  @override
  String get playVsDoll => 'Play vs The Doll';

  @override
  String playVsName(String name) {
    return 'Play vs $name';
  }

  @override
  String get played => 'Played';

  @override
  String get player => 'Player';

  @override
  String get player1 => 'Player 1';

  @override
  String get player1Move => 'Player 1\'s move';

  @override
  String get player1Wins => 'Player 1 wins!';

  @override
  String get player2 => 'Player 2';

  @override
  String get player2Move => 'Player 2\'s move';

  @override
  String get player2Wins => 'Player 2 wins!';

  @override
  String playerAdded(String name) {
    return '$name added';
  }

  @override
  String get playerBlocked => 'Player blocked';

  @override
  String playerIdLabel(String id) {
    return 'PLAYER $id';
  }

  @override
  String get playerUnblocked => 'Player unblocked';

  @override
  String get players => 'Players';

  @override
  String get playersLeft => 'Players left';

  @override
  String get pleaseWait => 'Please wait…';

  @override
  String plusCoins(String n) {
    return '+$n coins';
  }

  @override
  String get podium => 'Podium';

  @override
  String get pointAtHostQr => 'Point at the host’s QR. Same code as the lobby.';

  @override
  String get pointCameraAtQr => 'Point your camera at the room QR code';

  @override
  String pointsWins(String points, String wins) {
    return '$points pts · $wins wins';
  }

  @override
  String get popular => 'Popular';

  @override
  String get previousMatchExpired =>
      'Previous match expired. Try again in a moment.';

  @override
  String get privacy => 'Privacy';

  @override
  String privacyBody(String email) {
    return 'We collect only the gameplay data needed to run the app (coins, cosmetics, match history and settings). Guest play does not require an account.\n\nIf you sign in, your details are used only to save and restore your progress. We do not sell personal data. You can delete your data anytime from Settings → Delete account.\n\nContact: $email';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privateOnlyYou => 'Private. Only you can see this.';

  @override
  String get privateRoomByUsername => 'Private room (by username)';

  @override
  String get privateRoomCaps => 'PRIVATE ROOM';

  @override
  String get prizeAdded => 'Prize added to your balance';

  @override
  String get prizePool => 'Prize pool';

  @override
  String get profile => 'Profile';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get profilePrivacyNote =>
      'Match history and activity stay private. Reporting is for profile abuse; in-match chat reports use the chat Report button.';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String progressOf(String done, String total) {
    return '$done of $total';
  }

  @override
  String get publicStatsNote =>
      'Only rank, score and wins are public. Match history and activity stay private.';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get purchases => 'Purchases';

  @override
  String get purchasesComingSoon =>
      'Coin purchases are coming soon. Watch a video in Free Coins to earn coins now.';

  @override
  String get quarter => 'Quarter';

  @override
  String get quarterFinal => 'Quarter-final';

  @override
  String get quickCloseOne => 'Close one!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'Good move!';

  @override
  String quickMatchVsAi(String time) {
    return 'Quick match vs AI · $time';
  }

  @override
  String get quitMatch => 'Quit match';

  @override
  String get randomMatch => 'Random match';

  @override
  String get rank => 'Rank';

  @override
  String rankScore(String rank, String score) {
    return 'Rank #$rank · Score $score';
  }

  @override
  String get rankScoreUnknown => 'Rank – · Score –';

  @override
  String get ranks => 'Ranks';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get ratingsSoon => 'Ratings are coming soon';

  @override
  String get readOnly => 'read only';

  @override
  String get readyCaps => 'READY';

  @override
  String get reasonHarassment => 'Harassment or bullying';

  @override
  String get reasonInappropriate => 'Sexual or inappropriate content';

  @override
  String get reasonOffensive => 'Hate speech or abuse';

  @override
  String get reasonOther => 'Something else';

  @override
  String get reasonSpam => 'Spam or scams';

  @override
  String get reasonThreatening => 'Threats or violence';

  @override
  String get received => 'Received';

  @override
  String get reconnecting => 'Reconnecting…';

  @override
  String reference(String id) {
    return 'Reference: $id';
  }

  @override
  String get referralCode => 'Referral code';

  @override
  String get referralHint => 'Referral code (optional)';

  @override
  String get referralOnce =>
      'You can only use a referral code once, right after signing up.';

  @override
  String get referralPrompt =>
      'Got a referral code from a friend? Enter it now and get 50 coins.';

  @override
  String get referralWorked =>
      'Your referral code worked. The coins are in your wallet and ready to use.';

  @override
  String get refresh => 'Refresh';

  @override
  String get refreshStatus => 'Refresh status';

  @override
  String get region => 'Region';

  @override
  String get regionIndiaNote =>
      'Detected automatically from your SIM / device. India shows Indian languages and prices in ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Detected automatically from your SIM / device. International languages, prices in $currency.';
  }

  @override
  String get register => 'Register';

  @override
  String get released => 'Released';

  @override
  String get rematch => 'Rematch';

  @override
  String get rematchQuestion => 'Rematch?';

  @override
  String get remindMe => 'Remind me before my match';

  @override
  String get reportButtonCaps => 'REPORT BUTTON';

  @override
  String get reportButtonHelp =>
      'Top right of the live chat, next to Stop chat. Always visible while chat is on.\nTap → pick a reason → add details and screenshots → submit.';

  @override
  String get reportCaps => 'REPORT';

  @override
  String get reportFailed => 'Report failed';

  @override
  String reportName(String name) {
    return 'Report $name';
  }

  @override
  String get reportOrBlock => 'Report or block';

  @override
  String get reportOrBlockPlayer => 'Report or block this player';

  @override
  String get reportPlayer => 'Report player';

  @override
  String get requestSentCaps => 'REQUEST SENT';

  @override
  String requestSentTo(String name) {
    return 'Request sent to $name';
  }

  @override
  String get requests => 'Requests';

  @override
  String requestsCount(String n) {
    return 'Requests · $n';
  }

  @override
  String get requestsExpire7d =>
      'Requests expire after 7 days if not answered.';

  @override
  String get resendCode => 'Resend code';

  @override
  String get resendEmail => 'Resend email';

  @override
  String get resetCode => 'Reset code';

  @override
  String resetCodeSentTo(String target) {
    return 'We sent a reset code to $target.\nType it below — you don’t need to open the email link.';
  }

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordBody =>
      'Enter your email and we’ll send a reset code. Type that code in the app — no need to open the email link.';

  @override
  String get restart => 'Restart';

  @override
  String get result => 'Result';

  @override
  String get resume => 'Resume';

  @override
  String get returnToMainMenu => 'Return to main menu';

  @override
  String get rewardEarnedCaps => 'REWARD EARNED';

  @override
  String get rewardFlowOverview => 'Reward flow overview';

  @override
  String rewardIn(String time) {
    return 'Reward in $time';
  }

  @override
  String get rivalO => 'Rival: O';

  @override
  String get roomCancelled => 'Room cancelled';

  @override
  String roomClosesIn(String time) {
    return 'Room closes in $time if nobody joins.';
  }

  @override
  String get roomClosesSoon => 'Room closes soon if nobody joins.';

  @override
  String get roomClosing => 'Room is closing…';

  @override
  String get roomCodeCaps => 'ROOM CODE';

  @override
  String get roomCodeCopied => 'Room code copied';

  @override
  String get roomExpired => 'Room expired';

  @override
  String get roomOpenCaps => 'ROOM OPEN';

  @override
  String get roundOf16 => 'Round of 16';

  @override
  String get roundOf16Caps => 'ROUND OF 16';

  @override
  String roundOf16Vs(String name) {
    return 'Round of 16 · vs $name';
  }

  @override
  String get roundsWon => 'Rounds won';

  @override
  String get row => 'Row';

  @override
  String get ruleEmoji =>
      '• Emoji reactions work without a request, and can be muted.';

  @override
  String get ruleEnds => '• Chat ends automatically when the match ends.';

  @override
  String get ruleStop => '• Either player can stop the chat at any time.';

  @override
  String get ruleVanish => '• Messages vanish in seconds and are never saved.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get savePassword => 'Save password';

  @override
  String get saving => 'Saving…';

  @override
  String get savingToCloud => 'Saving to cloud…';

  @override
  String get scanOrShare => 'Scan to join, or share the link';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get score => 'Score';

  @override
  String get scorePlus10 => 'Score +10';

  @override
  String get screenshotTooBig => 'Screenshot must be under 2 MB';

  @override
  String get screenshotsOptionalCaps => 'SCREENSHOTS (OPTIONAL)';

  @override
  String get searchPlayersHint => 'Search by username or Player ID';

  @override
  String get searchResults => 'Search results';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'Online · $size · stake $stake · $time';
  }

  @override
  String get seatWaiting => 'Player, your seat is waiting.';

  @override
  String secondsLeft(String seconds) {
    return '${seconds}s left';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return '${seconds}s left to respond';
  }

  @override
  String get selectDifficulty => 'Select difficulty';

  @override
  String get selectOpponent => 'Select an opponent';

  @override
  String get selectReportReason => 'Select a report reason';

  @override
  String get semi => 'Semi';

  @override
  String get send => 'Send';

  @override
  String get sendChallenge => 'Send challenge';

  @override
  String get sendResetCode => 'Send reset code';

  @override
  String get sending => 'Sending…';

  @override
  String get sendingMove => 'Sending move…';

  @override
  String get sent => 'Sent';

  @override
  String serverTournamentsDemo(String error) {
    return 'Server tournaments unavailable — showing demo.\n$error';
  }

  @override
  String get sessionExpiredReset =>
      'Session expired — request a new reset code';

  @override
  String get settings => 'Settings';

  @override
  String get shareComingSoon => 'Share coming soon';

  @override
  String get shareInviteCaps => 'SHARE INVITE';

  @override
  String get shareOnWhatsApp => 'Share on WhatsApp';

  @override
  String get shareProfile => 'Share profile';

  @override
  String shareWin(String url) {
    return 'I just won a match of DROTIX! Think you can beat me? Play now: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'I just won a match of DROTIX against $name! Think you can beat me? Play now: $url';
  }

  @override
  String get shop => 'Shop';

  @override
  String get showHidePassword => 'Show or hide password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInChangePhoto => 'Sign in to change photo';

  @override
  String get signInFindFriends => 'Sign in to find friends';

  @override
  String get signInMatchmaking => 'Sign in required for online matchmaking';

  @override
  String get signInNotifications => 'Sign in to see your notifications';

  @override
  String get signInOnline => 'Sign in to play online multiplayer';

  @override
  String get signInRandomMatch =>
      'Sign in to play Random Match against real players';

  @override
  String get signInRequired => 'Sign in required';

  @override
  String get signInSearchPlayers =>
      'Sign in to search players and sync friends to the cloud.';

  @override
  String get signInToAddFriends => 'Sign in to add friends';

  @override
  String get signInToChallenge => 'Sign in to challenge this player';

  @override
  String get signInWalletHistory => 'Sign in to see your wallet history.';

  @override
  String get signInWithEmail => 'Sign in with email';

  @override
  String get signOut => 'Sign out';

  @override
  String get signUp => 'Sign up';

  @override
  String get skip => 'Skip';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Something went wrong: $error';
  }

  @override
  String get soundDisabled => 'Sound disabled';

  @override
  String get soundEffects => 'Sound effects';

  @override
  String get soundEnabled => 'Sound enabled';

  @override
  String get spent => 'Spent';

  @override
  String get sponsored => 'Sponsored';

  @override
  String stakeDot(String n) {
    return 'Stake · $n';
  }

  @override
  String get stakeReturned => 'Stake returned';

  @override
  String stakeRoom(String stake, String room) {
    return 'Stake $stake · $room…';
  }

  @override
  String get start => 'Start';

  @override
  String get startPlayingCaps => 'START PLAYING';

  @override
  String get starterPack => 'Starter pack';

  @override
  String get starting => 'Starting…';

  @override
  String get startsInCaps => 'STARTS IN';

  @override
  String get stats => 'Stats';

  @override
  String statusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get stayInApp =>
      'Stay in the app. We will alert you when your match is ready.';

  @override
  String get stillOffline =>
      'Still offline. Check your connection and try again.';

  @override
  String get stopChat => 'Stop chat';

  @override
  String get submitAppeal => 'Submit appeal';

  @override
  String get submitReportCaps => 'SUBMIT REPORT';

  @override
  String submittedAt(String date) {
    return 'Submitted: $date';
  }

  @override
  String get submitting => 'Submitting…';

  @override
  String get submittingCaps => 'SUBMITTING…';

  @override
  String get supportEmail => 'Support email';

  @override
  String suspendedAt(String date) {
    return 'Suspended: $date';
  }

  @override
  String get suspendedByModerator =>
      'A moderator suspended this account after a report review.';

  @override
  String get suspendedRules =>
      'You cannot play matches, join rooms, or use chat while suspended. You may submit one appeal for review.';

  @override
  String get t20Seconds => '20 seconds per move';

  @override
  String get tDrawReplays => 'A draw replays the round';

  @override
  String get tSingleElim => 'Single elimination: lose once and you are out';

  @override
  String get tSingleElimFee =>
      'Single elimination. If you lose a round you are out, and the entry fee is not returned.';

  @override
  String get tagline => 'The deadliest little game';

  @override
  String get takeTurnsBody =>
      'You and your rival place one mark each turn. Tap an empty square to make your move.';

  @override
  String get takeTurnsCaps => 'TAKE TURNS';

  @override
  String get takesFewSeconds => 'This usually takes a few seconds.';

  @override
  String get tapEmptySquare => 'Tap an empty square';

  @override
  String get tbd => 'TBD';

  @override
  String get tellUsMin10 =>
      'Please tell us what happened (at least 10 characters)';

  @override
  String get termsAccountBody =>
      'Keep your sign-in secure. You are responsible for activity on your account.';

  @override
  String get termsAccountTitle => '2. Your account';

  @override
  String get termsChangesBody =>
      'We may update these terms. Continued use means you accept the updates.';

  @override
  String get termsChangesTitle => '5. Changes';

  @override
  String get termsCoinsBody =>
      'Coins are virtual items with no cash value and cannot be exchanged for money.';

  @override
  String get termsCoinsTitle => '3. Virtual coins';

  @override
  String get termsFairBody =>
      'No cheating, abuse or harassment. We may suspend accounts that break the rules.';

  @override
  String get termsFairTitle => '4. Fair play and chat';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get termsUsingBody => 'You must follow these terms and play fairly.';

  @override
  String get termsUsingTitle => '1. Using DROTIX';

  @override
  String get theirTurnCaps => 'THEIR TURN';

  @override
  String get threeInRowBody =>
      'Line up three of your marks in a row, in a column or on a diagonal before your rival does.';

  @override
  String get threeInRowCaps => 'THREE IN A ROW';

  @override
  String timeDaysAgo(String n) {
    return '${n}d ago';
  }

  @override
  String timeHoursAgo(String n) {
    return '${n}h ago';
  }

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(String n) {
    return '${n}m ago';
  }

  @override
  String get timeSkipped => 'Run out of time and the move is skipped.';

  @override
  String timesUp(String who) {
    return 'Time\'s up · $who';
  }

  @override
  String get today => 'Today';

  @override
  String get todayCaps => 'TODAY';

  @override
  String get top16 => 'Top 16';

  @override
  String get totalCoinsCaps => 'TOTAL COINS';

  @override
  String get tournament => 'Tournament';

  @override
  String get tryAgain => 'Try again';

  @override
  String get tryAgainCaps => 'TRY AGAIN';

  @override
  String get twoPlayers => 'Two players, one phone';

  @override
  String get txChallengeEntry => 'Challenge entry';

  @override
  String get txCoinPurchase => 'Coin purchase';

  @override
  String txDailyBonus(String time) {
    return 'Daily bonus · $time';
  }

  @override
  String get txDailyReward => 'Daily reward';

  @override
  String get txFreeVideo => 'Free video reward';

  @override
  String get txMatchWin => 'Match win';

  @override
  String txPurchasing(String time) {
    return 'Purchasing coins · $time';
  }

  @override
  String txReferral(String time) {
    return 'Referral code · $time';
  }

  @override
  String txTournament(String time) {
    return 'Tournament · $time';
  }

  @override
  String get txTournamentPrize => 'Tournament prize';

  @override
  String txWatchingAds(String time) {
    return 'Watching ads · $time';
  }

  @override
  String get txWelcomeBonus => 'Welcome bonus';

  @override
  String txWinning(String time) {
    return 'Winning matches · $time';
  }

  @override
  String get typeMessage => 'Type a message';

  @override
  String get unblockPlayer => 'Unblock player';

  @override
  String get unblockToAdd => 'Unblock this player to add them';

  @override
  String get unblockToChallenge => 'Unblock this player to challenge';

  @override
  String unlockFor(String n) {
    return 'Unlock · $n coins';
  }

  @override
  String get unlocked => 'Unlocked';

  @override
  String unlockedCount(String n, String total) {
    return '$n of $total unlocked';
  }

  @override
  String get unranked => 'Unranked';

  @override
  String get upTo3Images => 'Up to 3 images. Only our team can see them.';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get updateOnAppStore => 'Update on the App Store';

  @override
  String get updateRequired => 'Update required';

  @override
  String get updatesOnlyMobile => 'Updates are available on Android and iOS.';

  @override
  String get useChatReport =>
      'Use Chat → Report during a live match for evidence-based reports.';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'Username (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get verifyFailBody =>
      'This can happen on a weak connection, or if the reward was already claimed. Your coins are safe.';

  @override
  String get verifying => 'Verifying…';

  @override
  String get verifyingReward => 'Verifying your reward';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get versionUnsupported =>
      'This version is no longer supported. Update to keep playing.';

  @override
  String get vibration => 'Vibration';

  @override
  String get victory => 'VICTORY';

  @override
  String get videoLength =>
      'The video is about 15 to 30 seconds. Watch it to the end to get your coins.';

  @override
  String get videos => 'Videos';

  @override
  String get viewAppealStatus => 'View appeal status';

  @override
  String get viewBracket => 'View bracket';

  @override
  String get viewBracketCaps => 'VIEW BRACKET';

  @override
  String get viewProfile => 'View profile';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String get waitingCaps => 'WAITING';

  @override
  String waitingForAccept(String name) {
    return 'Waiting for $name to accept…';
  }

  @override
  String get waitingForFriend => 'Waiting for a friend...';

  @override
  String get waitingOtherMatches => 'Waiting for other matches';

  @override
  String get waitingRoundOpen => 'Waiting for the round to open';

  @override
  String get wallet => 'Wallet';

  @override
  String get walletBalance => 'Wallet balance';

  @override
  String get walletCaps => 'WALLET';

  @override
  String get walletUnavailable => 'Wallet unavailable';

  @override
  String watchAnotherLeft(String n) {
    return 'WATCH ANOTHER ($n LEFT)';
  }

  @override
  String get watchBracketCaps => 'WATCH THE BRACKET';

  @override
  String get watchFullVideo =>
      'Watch the full video to claim your bonus coins.';

  @override
  String get watchNowCaps => 'WATCH NOW';

  @override
  String get watchShortVideo => 'Watch a short video';

  @override
  String watchShortVideoToGet(String n) {
    return 'Watch a short video to get +$n';
  }

  @override
  String get watchVideo => 'WATCH VIDEO';

  @override
  String get watchVideoCoins => 'Watch a video, get 10 coins';

  @override
  String get weekly => 'Weekly';

  @override
  String get weeklyChest => 'Weekly chest';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get welcomeBonusCaps => 'WELCOME BONUS';

  @override
  String welcomeName(String name) {
    return 'Welcome, $name';
  }

  @override
  String get whatHappenedCaps => 'WHAT HAPPENED';

  @override
  String get whatHappenedHint =>
      'Tell us what happened and why you are reporting this player';

  @override
  String get whatsNewCaps => 'WHAT\'S NEW';

  @override
  String get whoCanChallenge => 'Who can challenge you';

  @override
  String get whoCanMessage => 'Who can send you messages';

  @override
  String get winRate => 'Win rate';

  @override
  String get winner => 'WINNER';

  @override
  String get wins => 'Wins';

  @override
  String winsThisRound(String name) {
    return '$name wins this round.';
  }

  @override
  String get yesDelete => 'Yes, delete';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yesterdayCaps => 'YESTERDAY';

  @override
  String get you => 'You';

  @override
  String youBeat(String name) {
    return 'You beat $name.';
  }

  @override
  String get youFinished => 'You finished';

  @override
  String get youLose => 'You lose';

  @override
  String youMark(String mark) {
    return 'You · $mark';
  }

  @override
  String get youWin => 'You win!';

  @override
  String get youWinCaps => 'YOU WIN';

  @override
  String get youX => 'You: X';

  @override
  String yourBalance(String n) {
    return 'Your balance: $n coins';
  }

  @override
  String get yourEmail => 'your email';

  @override
  String get yourMatchReadyCaps => 'YOUR MATCH IS READY';

  @override
  String get yourMove => 'Your move';

  @override
  String get yourNextMatch => 'Your next match';

  @override
  String get yourTurnCaps => 'YOUR TURN';

  @override
  String get youreInCaps => 'YOU\'RE IN';

  @override
  String get youreInViewBracket => 'YOU\'RE IN — VIEW BRACKET';

  @override
  String get youreOffline => 'You’re offline';
}
