// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class L10nHi extends L10n {
  L10nHi([String locale = 'hi']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX एक तेज़, प्रतिस्पर्धी तीन-एक-लाइन गेम है। कंप्यूटर से खेलें, असली खिलाड़ियों से मैच करें, दोस्तों को चुनौती दें और लीडरबोर्ड में ऊपर चढ़ें।';

  @override
  String get aboutUs => 'हमारे बारे में';

  @override
  String get accept => 'स्वीकारें';

  @override
  String get acceptCaps => 'स्वीकारें';

  @override
  String get acceptRequestCaps => 'रिक्वेस्ट स्वीकारें';

  @override
  String get accountCheckFailed => 'खाते की जाँच विफल';

  @override
  String get accountIsSuspended => 'आपका खाता निलंबित है।';

  @override
  String get accountRestricted =>
      'मॉडरेटर की समीक्षा पूरी होने तक आपका खाता प्रतिबंधित रहेगा। खेल, मैचमेकिंग और चैट बंद रहेंगे।';

  @override
  String get accountStatusUnknown => 'खाते की स्थिति अज्ञात। फिर कोशिश करें।';

  @override
  String get accountSuspended => 'खाता निलंबित';

  @override
  String get accountSuspendedSignIn =>
      'आपका खाता निलंबित कर दिया गया है। विवरण देखने या अपील करने के लिए साइन इन करें।';

  @override
  String get accountSuspendedTitle => 'आपका खाता निलंबित कर दिया गया है';

  @override
  String get ach100Wins => '100 जीत';

  @override
  String get ach10Matches => '10 मैच';

  @override
  String get ach50Matches => '50 मैच';

  @override
  String get achChallenger => 'चैलेंजर';

  @override
  String get achChampion => 'चैंपियन';

  @override
  String get achFirstWin => 'पहली जीत';

  @override
  String get achScore100 => 'स्कोर 100';

  @override
  String get achStreak3 => 'लगातार 3 जीत';

  @override
  String get achStreak5 => 'लगातार 5 जीत';

  @override
  String get achSurvivor => 'सर्वाइवर';

  @override
  String get achTop3 => 'टॉप 3';

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String get add => 'जोड़ें';

  @override
  String get addFriend => 'दोस्त जोड़ें';

  @override
  String get addFriendCaps => 'दोस्त जोड़ें';

  @override
  String get advanceQuarter => 'आप क्वार्टर-फ़ाइनल में पहुँचे';

  @override
  String get advancedMode => 'एडवांस्ड मोड (4×4)';

  @override
  String get advertiserApp => 'विज्ञापनदाता ऐप';

  @override
  String get advertiserVideo => 'विज्ञापन वीडियो यहाँ चलेगा';

  @override
  String get all => 'सभी';

  @override
  String get allowAndInstall => 'अनुमति दें और इंस्टॉल करें';

  @override
  String get allowUnknownApps =>
      'DROTIX के लिए \"अज्ञात ऐप इंस्टॉल करें\" की अनुमति दें, फिर वापस आएँ। अपडेट अपने-आप इंस्टॉल होगा।';

  @override
  String get alreadyPlayer => 'पहले से खिलाड़ी हैं?';

  @override
  String get alsoBlock => 'इस खिलाड़ी को ब्लॉक भी करें';

  @override
  String get alwaysTrue => 'हमेशा लागू';

  @override
  String get appUpdate => 'ऐप अपडेट';

  @override
  String get appealExplain =>
      'बताएँ कि आपका खाता क्यों बहाल किया जाना चाहिए। एक मॉडरेटर आपका संदेश देखेगा।';

  @override
  String get appealFailed => 'अपील विफल';

  @override
  String get appealHint => 'अपनी अपील लिखें (कम से कम 20 अक्षर)…';

  @override
  String get appealIsUnderReview => 'आपकी अपील की समीक्षा हो रही है।';

  @override
  String get appealMin20 => 'अपील कम से कम 20 अक्षर की होनी चाहिए';

  @override
  String get appealSubmitted => 'अपील सफलतापूर्वक भेजी गई';

  @override
  String get appealSuspension => 'निलंबन के ख़िलाफ़ अपील';

  @override
  String get appealUnderReview => 'अपील की समीक्षा जारी';

  @override
  String get applyCodeCaps => 'कोड लागू करें';

  @override
  String get attachRecentChat => 'हाल के चैट संदेश जोड़ें';

  @override
  String get attemptingReconnect => 'फिर से जुड़ने की कोशिश…';

  @override
  String get auto => 'स्वतः';

  @override
  String get avatars => 'अवतार';

  @override
  String get back => 'वापस';

  @override
  String get backToEvent => 'इवेंट पर वापस';

  @override
  String get backToEvents => 'इवेंट पर वापस';

  @override
  String get backToEventsCaps => 'इवेंट पर वापस';

  @override
  String get backToHome => 'होम पर वापस';

  @override
  String get backToMenu => 'मेन्यू पर वापस';

  @override
  String get backToSignIn => 'साइन इन पर वापस';

  @override
  String balance(String n) {
    return 'बैलेंस $n';
  }

  @override
  String get balanceAfter => 'बाद का बैलेंस';

  @override
  String balanceArrow(String from) {
    return 'बैलेंस $from →';
  }

  @override
  String get bestStreak => 'सर्वश्रेष्ठ लगातार जीत';

  @override
  String get bestValue => 'सबसे फायदेमंद';

  @override
  String get biggerBoardsBody =>
      'बड़े बोर्ड पर जीतने के लिए चार एक लाइन में चाहिए। बिना लाइन के बोर्ड भर जाए तो ड्रॉ है।';

  @override
  String get biggerBoardsCaps => 'बड़े बोर्ड';

  @override
  String get biggerNeedFour => 'बड़े बोर्ड पर चार एक लाइन में चाहिए';

  @override
  String get blockPlayer => 'खिलाड़ी को ब्लॉक करें';

  @override
  String get boardHiddenUntilBack => 'आपके वापस आने तक बोर्ड छिपा है।';

  @override
  String get boards => 'बोर्ड';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n कॉइन आपके वॉलेट में जुड़ गए';
  }

  @override
  String get bonusClaimed => 'बोनस मिल गया!';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n बोनस कॉइन जोड़े गए';
  }

  @override
  String get bracket => 'ब्रैकेट';

  @override
  String get bracketInfo => 'अंतिम 16 · 8 मैच, 4 दिखाए गए। आप हाइलाइट हैं।';

  @override
  String get buyCoinsCaps => 'कॉइन खरीदें';

  @override
  String get byBoard => 'बोर्ड के अनुसार';

  @override
  String get cameraOnlyForScan =>
      'कैमरा सिर्फ़ कोड स्कैन करने के लिए इस्तेमाल होता है।';

  @override
  String get cameraPermissionNeeded =>
      'स्कैन के लिए कैमरा अनुमति चाहिए। आप नीचे कोड भी डाल सकते हैं।';

  @override
  String get cameraPermissionRequired =>
      'रूम QR कोड स्कैन करने के लिए कैमरा अनुमति ज़रूरी है। सिस्टम सेटिंग्स में इस ऐप के लिए कैमरा चालू करें, फिर कोशिश करें।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get cancelChallenge => 'चुनौती रद्द करें';

  @override
  String get cancelDownload => 'डाउनलोड रद्द करें';

  @override
  String get cannotChallengeSelf => 'आप खुद को चुनौती नहीं दे सकते';

  @override
  String get cannotFriendSelf => 'आप खुद को दोस्त नहीं बना सकते';

  @override
  String get cantChallengeNow => 'आप अभी इस खिलाड़ी को चुनौती नहीं दे सकते।';

  @override
  String get challenge => 'चुनौती';

  @override
  String get challengeAccepted => 'चुनौती स्वीकार हुई';

  @override
  String get challengeCancelled => 'चुनौती रद्द हुई';

  @override
  String get challengeCaps => 'चुनौती दें';

  @override
  String get challengeClosed => 'चुनौती बंद';

  @override
  String get challengeDeclined => 'चुनौती अस्वीकार हुई';

  @override
  String get challengeExpired => 'चुनौती की समय-सीमा खत्म';

  @override
  String get challengeExpiresIn60 =>
      'स्वीकार न होने पर चुनौती 60 सेकंड में खत्म हो जाएगी।';

  @override
  String get challengePrivacy => 'चुनौती गोपनीयता';

  @override
  String get challengeRequests => 'चुनौती अनुरोध';

  @override
  String get challengeSentCoins => 'चुनौती भेजी · 5 कॉइन';

  @override
  String get challengeSentFree => 'चुनौती भेजी · मुफ़्त मैच';

  @override
  String get challenges => 'चुनौतियाँ';

  @override
  String get championCaps => 'चैंपियन';

  @override
  String get change => 'बदलें';

  @override
  String get chat => 'चैट';

  @override
  String get chatAfterAccept => 'दोनों खिलाड़ियों के स्वीकार करने के बाद चैट।';

  @override
  String get chatAfterAcceptRandom =>
      'दोनों के स्वीकार करने के बाद चैट। यूज़रनेम के अलावा कुछ साझा नहीं होता।';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name सिर्फ़ दोस्तों के संदेश लेता है।';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name ने संदेश बंद कर रखे हैं।';
  }

  @override
  String get chatNotConnected => 'चैट कनेक्ट नहीं है';

  @override
  String get chatOn => 'चैट चालू';

  @override
  String get chatPrivacyNote =>
      'मैच चैट पर लागू। बदलाव तुरंत लागू होते हैं, मैच के दौरान भी।';

  @override
  String get chatRules => 'चैट नियम';

  @override
  String get chatRulesIntro =>
      'टेक्स्ट चैट अपने-आप शुरू नहीं होती। एक खिलाड़ी पूछता है, दूसरे को स्वीकार करना होता है।';

  @override
  String get checkAgainCaps => 'फिर जाँचें';

  @override
  String get checkEmail => 'ईमेल देखें';

  @override
  String get checkEmailConfirm => 'अपना ईमेल देखें और पुष्टि लिंक खोलें';

  @override
  String get checkForUpdates => 'अपडेट देखें';

  @override
  String get checkInbox => 'अपना इनबॉक्स देखें';

  @override
  String get checking => 'जाँच हो रही है…';

  @override
  String get chooseEntryStake => 'अपना एंट्री दांव चुनें';

  @override
  String get chooseGameMode => 'अपना गेम मोड चुनें';

  @override
  String get chooseNewPassword => 'नया पासवर्ड चुनें';

  @override
  String get chooseOpponent => 'विरोधी चुनें';

  @override
  String get claim => 'पाएँ';

  @override
  String claimBonusCoins(String n) {
    return '$n बोनस कॉइन पाएँ';
  }

  @override
  String get claimLabel => 'लें';

  @override
  String claimPlusCoins(String n) {
    return '+$n कॉइन लें';
  }

  @override
  String get claimVictory => 'जीत का दावा करें';

  @override
  String get claimsSync => 'क्लेम आपके क्लाउड खाते में सिंक होते हैं';

  @override
  String get classicMode => 'क्लासिक मोड (3×3)';

  @override
  String get clearAll => 'सब हटाएँ';

  @override
  String get clipboardNoCode => 'क्लिपबोर्ड में रूम कोड नहीं है';

  @override
  String get close => 'बंद करें';

  @override
  String get closeAndLose => 'बंद करें और इनाम खोएँ';

  @override
  String get closeRoom => 'रूम बंद करें';

  @override
  String get closing => 'बंद हो रहा है…';

  @override
  String get cloud => 'क्लाउड';

  @override
  String cloudSaveFailed(String message) {
    return 'क्लाउड सेव विफल: $message';
  }

  @override
  String get codeSent => 'कोड भेजा गया';

  @override
  String get coinPacks => 'कॉइन पैक';

  @override
  String coinPacksFrom(String price) {
    return 'कॉइन पैक $price से';
  }

  @override
  String get coins5 => '5 कॉइन';

  @override
  String coinsAdded(String n) {
    return '+$n कॉइन जोड़े गए';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'कॉइन $delta · बैलेंस $balance';
  }

  @override
  String get coinsEntryFee => '5 कॉइन एंट्री फ़ीस';

  @override
  String get coinsEntryFeeBody =>
      'मुफ़्त मैच खत्म होने के बाद, या दांव बढ़ाने के लिए।';

  @override
  String coinsLabel(String n) {
    return '$n कॉइन';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n कॉइन (क्लाउड में सेव)';
  }

  @override
  String get column => 'कॉलम';

  @override
  String get comeBackTomorrow => 'कल फिर आएँ';

  @override
  String get completeGoogleReturnApp =>
      'Google साइन इन पूरा करें, फिर ऐप पर लौटें';

  @override
  String get completeGoogleSignIn => 'Google साइन इन पूरा करें, फिर वापस आएँ';

  @override
  String get computer => 'कंप्यूटर';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get confirmJoinCaps => 'पुष्टि करें और जुड़ें';

  @override
  String confirmLinkSentTo(String target) {
    return 'हमने $target पर पुष्टि लिंक भेजा है।\nइसी डिवाइस पर लिंक खोलें, फिर यहाँ लौटें — आप अपने-आप साइन इन हो जाएँगे।';
  }

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get confirmationEmailSent => 'पुष्टि ईमेल भेजा गया — इनबॉक्स देखें';

  @override
  String get confirmingVideo =>
      'पुष्टि कर रहे हैं कि वीडियो देखा गया। कृपया प्रतीक्षा करें।';

  @override
  String get connectingChat => 'चैट जुड़ रही है…';

  @override
  String get connectionUnstable => 'कनेक्शन अस्थिर है';

  @override
  String get connectionUnstableCaps => 'कनेक्शन अस्थिर';

  @override
  String get contactAbout => 'संपर्क और जानकारी';

  @override
  String get contactUsCaps => 'संपर्क करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get continuePlaying => 'खेलना जारी रखें';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String copiedValue(String label, String value) {
    return '$label कॉपी हुआ: $value';
  }

  @override
  String get couldNotAddCoins => 'कॉइन नहीं जुड़ सके';

  @override
  String get couldNotApplyReferral => 'रेफ़रल कोड लागू नहीं हो सका';

  @override
  String couldNotCheck(String error) {
    return 'जाँच नहीं हो सकी: $error';
  }

  @override
  String get couldNotJoinRoom => 'रूम से नहीं जुड़ सके';

  @override
  String get couldNotLoadPrivacy => 'गोपनीयता सेटिंग लोड नहीं हुई';

  @override
  String get couldNotLoadProfile =>
      'आपकी प्रोफ़ाइल लोड नहीं हो सकी। फिर कोशिश करें।';

  @override
  String get couldNotOpenGoogle => 'Google साइन इन नहीं खुल सका';

  @override
  String get couldNotSavePrivacy => 'गोपनीयता सेटिंग सेव नहीं हुई';

  @override
  String get couldNotStopChat => 'चैट बंद नहीं हो सकी';

  @override
  String get couldNotSubmitAppeal => 'अपील नहीं भेजी जा सकी';

  @override
  String get couldNotVerify => 'हम इसकी पुष्टि नहीं कर सके';

  @override
  String get couldNotVerifyAccount =>
      'खाते की स्थिति जाँच नहीं सकी। फिर से कोशिश करें।';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get createPrivateRoom => 'प्राइवेट रूम बनाएँ';

  @override
  String get customize => 'कस्टमाइज़ करें';

  @override
  String get daily => 'दैनिक';

  @override
  String get dailyChest => 'दैनिक संदूक';

  @override
  String get dailyLimit => 'दैनिक सीमा पूरी';

  @override
  String get date => 'तारीख';

  @override
  String dayN(String n) {
    return 'दिन $n';
  }

  @override
  String dayStreak(String n) {
    return '$n दिन की लगातार';
  }

  @override
  String get days30 => '30 दिन';

  @override
  String get days7 => '7 दिन';

  @override
  String get debitFailed => 'कॉइन नहीं कटे';

  @override
  String get declineCaps => 'अस्वीकारें';

  @override
  String get defeat => 'हार';

  @override
  String get deleteAccount => 'खाता हटाएँ';

  @override
  String get deleteAccountBody =>
      'इससे आपके कॉइन, स्कोर और इतिहास हमेशा के लिए हट जाएँगे।';

  @override
  String get deleteAccountQuestion => 'खाता हटाएँ?';

  @override
  String get descriptionMin10 => 'विवरण कम से कम 10 अक्षर का होना चाहिए';

  @override
  String get diagonal => 'तिरछी';

  @override
  String get difficultyEasy => 'आसान';

  @override
  String get difficultyHard => 'कठिन';

  @override
  String get difficultyMedium => 'मध्यम';

  @override
  String get doll => 'डॉल';

  @override
  String get done => 'पूरा';

  @override
  String get downloadAndInstall => 'डाउनलोड और इंस्टॉल करें';

  @override
  String get downloading => 'डाउनलोड हो रहा है…';

  @override
  String downloadingPercent(String percent) {
    return 'डाउनलोड हो रहा है $percent%';
  }

  @override
  String get draw => 'ड्रॉ';

  @override
  String get drawBadge => 'ड्रॉ';

  @override
  String get draws => 'ड्रॉ';

  @override
  String get duration => 'अवधि';

  @override
  String get earned => 'कमाए';

  @override
  String get earnedThisWeek => 'इस हफ़्ते की कमाई, स्रोत के अनुसार';

  @override
  String get editProfileCaps => 'प्रोफ़ाइल संपादित करें';

  @override
  String get eliminatedCaps => 'बाहर';

  @override
  String get email => 'ईमेल';

  @override
  String get emailNotConfirmed => 'ईमेल की पुष्टि नहीं हुई';

  @override
  String emailNotConfirmedBody(String email) {
    return 'आपका रजिस्ट्रेशन हो गया, लेकिन ईमेल की पुष्टि अभी नहीं हुई।\n\nइनबॉक्स या स्पैम में पुष्टि लिंक खोलें, फिर दोबारा साइन इन करें।\n\n$email';
  }

  @override
  String get emailSentAgain => 'ईमेल फिर भेजा गया — इनबॉक्स देखें';

  @override
  String get endsIn => 'खत्म होगा';

  @override
  String get enterCode => 'कोड डालें';

  @override
  String get enterCodeFromEmail => 'ईमेल में आया कोड डालें';

  @override
  String get enterCodeInstead => 'इसके बजाय कोड डालें';

  @override
  String get enterEmailPassword => 'ईमेल और पासवर्ड डालें';

  @override
  String get enterFullCode => 'पूरा रूम कोड डालें';

  @override
  String get enterReferralOrSkip => 'रेफ़रल कोड डालें, या अभी के लिए छोड़ें';

  @override
  String get enterResetCode => 'रीसेट कोड डालें';

  @override
  String get enterValidMobile => 'सही मोबाइल नंबर डालें';

  @override
  String get enterValidReferral => 'सही रेफ़रल कोड डालें';

  @override
  String get enterYourEmail => 'अपना ईमेल डालें';

  @override
  String get entry => 'प्रवेश';

  @override
  String get entryFee => 'प्रवेश शुल्क';

  @override
  String get equip => 'लगाएँ';

  @override
  String get equipped => 'लगाया हुआ';

  @override
  String get events => 'इवेंट';

  @override
  String get everyone => 'सभी';

  @override
  String get expertMode => 'एक्सपर्ट मोड (5×5)';

  @override
  String get expiredMoveToHistory =>
      'समाप्त चुनौतियाँ इतिहास में चली जाती हैं।';

  @override
  String get failed => 'विफल';

  @override
  String get fillAllFields => 'सभी फ़ील्ड भरें';

  @override
  String get finalRound => 'फ़ाइनल';

  @override
  String get findAMatch => 'मैच खोजें';

  @override
  String get findOpponent => 'विरोधी खोजें';

  @override
  String get findPrivateJoin => 'खोजें · प्राइवेट रूम · जॉइन कोड';

  @override
  String get findingOpponent => 'विरोधी खोज रहे हैं';

  @override
  String get findingPlayer => 'खिलाड़ी खोज रहे हैं';

  @override
  String get firstMatchSet => 'राउंड खुलते ही आपका पहला मैच तय होगा।';

  @override
  String get fiveOfFiveWatched => '5 में से 5 वीडियो देखे';

  @override
  String get flash => 'फ़्लैश';

  @override
  String get flashUnavailable => 'फ़्लैश उपलब्ध नहीं';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get forgotPasswordTitle => 'पासवर्ड भूल गए';

  @override
  String get free => 'मुफ़्त';

  @override
  String get freeCoins => 'मुफ़्त कॉइन';

  @override
  String get freeMatch => 'मुफ़्त मैच';

  @override
  String get freeMatchesPerDay => 'हर दिन 3 मुफ़्त मैच';

  @override
  String get freeVideosToday => 'आज के मुफ़्त वीडियो';

  @override
  String freeVideosUsed(String used) {
    return 'आज 5 में से $used मुफ़्त वीडियो इस्तेमाल हुए';
  }

  @override
  String get friendChallenge => 'दोस्त की चुनौती';

  @override
  String get friendRequestExists => 'फ़्रेंड रिक्वेस्ट पहले से है';

  @override
  String friendRequestSent(String name) {
    return '$name को फ़्रेंड रिक्वेस्ट भेजी गई';
  }

  @override
  String get friendRequestSentShort => 'फ़्रेंड रिक्वेस्ट भेजी गई';

  @override
  String get friendsCaps => 'दोस्त';

  @override
  String get friendsLabel => 'दोस्त';

  @override
  String get friendsOnly => 'सिर्फ़ दोस्त';

  @override
  String get fromPhoto => 'फ़ोटो से';

  @override
  String gameComingSoon(String game) {
    return '$game: जल्द आ रहा है';
  }

  @override
  String get gameOver => 'खेल खत्म';

  @override
  String get gamePaused => 'गेम रुका';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get gettingVideo => 'आपका वीडियो ला रहे हैं…';

  @override
  String get goToMatchCaps => 'मैच पर जाएँ';

  @override
  String get gotIt => 'समझ गया';

  @override
  String get graceWindowEnded =>
      '30 सेकंड का समय खत्म हो गया। आप जीत का दावा कर सकते हैं।';

  @override
  String greatRun(String name) {
    return '$name में शानदार प्रदर्शन';
  }

  @override
  String get guard => 'गार्ड';

  @override
  String get guest => 'मेहमान';

  @override
  String get history => 'इतिहास';

  @override
  String get historyNeverPublic =>
      'आपका मैच इतिहास और गतिविधि कभी आपकी सार्वजनिक प्रोफ़ाइल पर नहीं दिखती।';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches मैच · $wins जीत · $losses हार · $draws ड्रॉ';
  }

  @override
  String get howItWorks => 'यह कैसे काम करता है';

  @override
  String get howToPlay => 'कैसे खेलें';

  @override
  String get howToPlayRules =>
      'अपने तीन निशान एक लाइन में लगाएँ — आड़ी, खड़ी या तिरछी — विरोधी से पहले। बड़े बोर्ड पर चार एक लाइन में चाहिए।';

  @override
  String howToPlayStep(String n) {
    return 'कैसे खेलें · $n/3';
  }

  @override
  String get imReadyCaps => 'मैं तैयार हूँ';

  @override
  String get imageTooBig => 'इमेज 2 MB से कम होनी चाहिए';

  @override
  String get install => 'इंस्टॉल करें';

  @override
  String get installUpdate => 'अपडेट इंस्टॉल करें';

  @override
  String get installed => 'इंस्टॉल है';

  @override
  String get internetRequired =>
      'इंटरनेट कनेक्शन ज़रूरी है। आप ऑफ़लाइन द डॉल से अब भी खेल सकते हैं।';

  @override
  String get introBody1 => '3×3, 4×4 या 5×5 बोर्ड पर AI को हराएँ।';

  @override
  String get introBody2 =>
      'असली खिलाड़ियों से रैंडम मैच। कॉइन लगाएँ, कॉइन जीतें।';

  @override
  String get introBody3 =>
      'दैनिक इनाम, मिशन और टूर्नामेंट आपको आगे बढ़ाते रहेंगे।';

  @override
  String get introTitle1 => 'डॉल को मात दें';

  @override
  String get introTitle2 => 'दुनिया से मुकाबला';

  @override
  String get introTitle3 => 'रैंक में ऊपर चढ़ें';

  @override
  String get invalidRoomQr => 'अमान्य रूम QR';

  @override
  String get inviteImage => 'आमंत्रण इमेज';

  @override
  String get inviteImageBody =>
      'कोड, QR और लिंक एक ही तस्वीर में। WhatsApp या कहीं भी भेजें।';

  @override
  String isThinking(String name) {
    return '$name सोच रहा है';
  }

  @override
  String get joinCaps => 'जुड़ें';

  @override
  String joinForCoins(String n) {
    return '$n कॉइन में जुड़ें';
  }

  @override
  String get joinRoomCaps => 'रूम से जुड़ें';

  @override
  String get joinTheGame => 'गेम से जुड़ें';

  @override
  String joinTournamentQuestion(String name) {
    return '$name में शामिल हों?';
  }

  @override
  String get joinWithCode => 'कोड से जुड़ें';

  @override
  String get joined => 'शामिल';

  @override
  String get joiningCaps => 'जुड़ रहे हैं…';

  @override
  String get joiningQueue => 'कतार में शामिल हो रहे हैं…';

  @override
  String get joiningRoom => 'रूम से जुड़ रहे हैं…';

  @override
  String get keepWatchingCaps => 'देखते रहें';

  @override
  String get language => 'भाषा';

  @override
  String get languageUpdated => 'भाषा बदल गई';

  @override
  String get last20Sent => 'आख़िरी 20 संदेश आपकी रिपोर्ट के साथ भेजे जाते हैं।';

  @override
  String get last7Games => 'पिछले 7 गेम';

  @override
  String lastUpdated(String date) {
    return 'अंतिम अपडेट $date';
  }

  @override
  String get later => 'बाद में';

  @override
  String get latestVersion => 'आप नवीनतम संस्करण इस्तेमाल कर रहे हैं।';

  @override
  String get leaderboard => 'लीडरबोर्ड';

  @override
  String get leaderboardUpdated => 'लीडरबोर्ड अपडेट हुआ';

  @override
  String get leave => 'छोड़ें';

  @override
  String get leaveForfeitBody =>
      'अभी छोड़ने पर हार मानी जाएगी। आपका विरोधी जीतेगा।';

  @override
  String get leaveGame => 'गेम छोड़ें';

  @override
  String get leaveMatchQuestion => 'मैच छोड़ें?';

  @override
  String get leaveVideoQuestion => 'वीडियो छोड़ें?';

  @override
  String get letsPlay => 'चलो खेलें';

  @override
  String get linkCopied => 'लिंक कॉपी हुआ';

  @override
  String get live => 'लाइव';

  @override
  String get liveEventCaps => 'लाइव इवेंट';

  @override
  String get loading => 'लोड हो रहा है…';

  @override
  String get local => 'लोकल';

  @override
  String get locked => 'लॉक';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get loginMethod => 'लॉगिन तरीका';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'अभी बंद करने पर आपको 10 कॉइन नहीं मिलेंगे। $seconds सेकंड बचे हैं।';
  }

  @override
  String get losses => 'हार';

  @override
  String get markAllRead => 'सभी को पढ़ा हुआ करें';

  @override
  String get marks => 'निशान';

  @override
  String get match => 'मैच';

  @override
  String get matchAbandonedCaps => 'मैच छोड़ दिया गया';

  @override
  String matchDuration(String duration) {
    return 'मैच अवधि $duration';
  }

  @override
  String get matchHistory => 'मैच इतिहास';

  @override
  String get matchHistoryCaps => 'मैच इतिहास';

  @override
  String get matchInvitations => 'मैच आमंत्रण';

  @override
  String get matchLobby => 'मैच लॉबी';

  @override
  String get matchResult => 'मैच परिणाम';

  @override
  String get matchResults => 'मैच परिणाम';

  @override
  String get matchStakes => 'मैच दांव';

  @override
  String get matchStartsIn => 'मैच शुरू होगा';

  @override
  String get matches => 'मैच';

  @override
  String get matchmakingError => 'मैचमेकिंग त्रुटि';

  @override
  String get matchmakingFailed => 'मैचमेकिंग विफल';

  @override
  String get matchmakingStopped => 'मैचमेकिंग रुकी';

  @override
  String memberSince(String date) {
    return '$date से सदस्य';
  }

  @override
  String get messageEmpty => 'संदेश खाली नहीं हो सकता';

  @override
  String get messagesStayForMatch => 'संदेश सिर्फ़ इस मैच तक रहेंगे';

  @override
  String minusCoins(String n) {
    return '-$n कॉइन';
  }

  @override
  String get misPlay30 => '30 मैच खेलें';

  @override
  String get misPlay5 => '5 मैच खेलें';

  @override
  String get misQuick => 'एक रैंडम मैच खेलें';

  @override
  String get misTourney => 'एक टूर्नामेंट में शामिल हों';

  @override
  String get misWin15 => '15 गेम जीतें';

  @override
  String get misWin3 => '3 गेम जीतें';

  @override
  String get misWin4x4 => '4×4 बोर्ड पर जीतें';

  @override
  String get missResets =>
      'एक दिन छूटा तो फिर से शुरू होगा। अगले इनाम के लिए कल आएँ।';

  @override
  String get missingChallengeData => 'चुनौती की जानकारी नहीं मिली';

  @override
  String get missingEmail => 'ईमेल नहीं मिला — वापस जाकर फिर कोशिश करें';

  @override
  String get missions => 'मिशन';

  @override
  String missionsDone(String done, String total) {
    return '$total में से $done मिशन पूरे';
  }

  @override
  String get mobileNotSupported =>
      'आपके क्षेत्र में अभी मोबाइल नंबर समर्थित नहीं हैं';

  @override
  String get mobileOptional => 'मोबाइल नंबर (वैकल्पिक)';

  @override
  String mode(String n) {
    return 'मोड $n';
  }

  @override
  String get more => 'और';

  @override
  String get moreGames => 'और गेम';

  @override
  String get music => 'संगीत';

  @override
  String nOf5(String n) {
    return '5 में से $n';
  }

  @override
  String get navPlay => 'खेलें';

  @override
  String get newCodeSent => 'नया कोड भेजा गया — इनबॉक्स देखें';

  @override
  String get newHere => 'नए हैं?';

  @override
  String get newMatchChallengeCaps => 'नई मैच चुनौती!';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get newPasswordBody =>
      'अपने खाते के लिए नया पासवर्ड डालें। सेव करने के बाद आप साइन इन रहेंगे।';

  @override
  String get newVersion => 'नया संस्करण';

  @override
  String get newVersionReady => 'DROTIX का नया संस्करण तैयार है।';

  @override
  String get newVideosUnlockIn => 'नए मुफ़्त वीडियो खुलेंगे';

  @override
  String get next => 'आगे';

  @override
  String get nextCaps => 'आगे';

  @override
  String get nextRound => 'अगला राउंड';

  @override
  String get no => 'नहीं';

  @override
  String get noChallenge => 'कोई चुनौती नहीं';

  @override
  String get noChallengesHere => 'यहाँ कोई चुनौती नहीं।';

  @override
  String get noCloudMatches =>
      'अभी कोई क्लाउड मैच नहीं। यहाँ दिखने के लिए साइन इन करके द डॉल से खेलें।';

  @override
  String get noFriendsYet =>
      'अभी कोई दोस्त नहीं — किसी को जोड़ने के लिए खोजें।';

  @override
  String get noHistory => 'कोई इतिहास नहीं मिला';

  @override
  String get noMatchesYet => 'अभी कोई मैच नहीं';

  @override
  String get noMessagesYet =>
      'अभी कोई संदेश नहीं।\nक्विक रिप्लाई भी काम करते हैं।';

  @override
  String get noNotificationsYet => 'अभी कोई सूचना नहीं';

  @override
  String get noOpponentFound => 'कोई विरोधी नहीं मिला — फिर कोशिश करें';

  @override
  String get noPendingRequests => 'कोई बाकी रिक्वेस्ट नहीं।';

  @override
  String get noPlayersFound => 'कोई खिलाड़ी नहीं मिला';

  @override
  String get noQrInPhoto => 'फ़ोटो में कोई QR नहीं मिला';

  @override
  String get noRankedPlayers =>
      'अभी कोई रैंक वाला खिलाड़ी नहीं। बोर्ड में आने के लिए साइन इन करके खेलें।';

  @override
  String get noTransactions => 'अभी कोई लेन-देन नहीं।';

  @override
  String get noVideoFound =>
      'हमें आपके लिए वीडियो नहीं मिला। आपका मुफ़्त वीडियो इस्तेमाल नहीं हुआ। एक मिनट में फिर कोशिश करें।';

  @override
  String get noVideoNow => 'अभी कोई वीडियो उपलब्ध नहीं है। बाद में कोशिश करें।';

  @override
  String get noVideoRightNow => 'अभी कोई वीडियो नहीं';

  @override
  String get nobody => 'कोई नहीं';

  @override
  String get nobodyBlinked => 'कोई नहीं झुका।';

  @override
  String nobodyBlinkedVs(String name) {
    return 'कोई नहीं झुका। $name ने आपको रोक लिया।';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name अभी चुनौतियाँ स्वीकार नहीं कर रहा।';
  }

  @override
  String get notEnoughCoins => 'पर्याप्त कॉइन नहीं';

  @override
  String get notEnoughCoinsAnother =>
      'दूसरे दांव के लिए पर्याप्त कॉइन नहीं हैं।';

  @override
  String get notEnoughCoinsStake => 'इस दांव के लिए पर्याप्त कॉइन नहीं हैं।';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get notSignedIn => 'साइन इन नहीं है';

  @override
  String get notSignedInYet => 'अभी साइन इन नहीं हुआ — पहले ईमेल लिंक खोलें';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name ने आपकी चुनौती स्वीकार की। मैच शुरू हो रहा है!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'चुनौती स्वीकार हुई';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name अभी एक मैच में है। बाद में फिर कोशिश करें।';
  }

  @override
  String get notifChallengeBusyTitle => 'खिलाड़ी व्यस्त है';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name ने चुनौती रद्द कर दी';
  }

  @override
  String get notifChallengeCancelledTitle => 'चुनौती रद्द हुई';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name ने आपकी चुनौती अस्वीकार कर दी';
  }

  @override
  String get notifChallengeDeclinedTitle => 'चुनौती अस्वीकार हुई';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name ने समय पर जवाब नहीं दिया';
  }

  @override
  String get notifChallengeExpiredTitle => 'चुनौती समाप्त हुई';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name ने आपको मैच के लिए चुनौती दी';
  }

  @override
  String get notifChallengeRequestTitle => 'नई चुनौती';

  @override
  String get notifChannelDesc => 'चुनौतियाँ, मैच और सिक्कों की जानकारी';

  @override
  String get notifChannelName => 'गेम अलर्ट';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount सिक्के जोड़े गए। बैलेंस: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'सिक्के जोड़े गए';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount सिक्के कटे। बैलेंस: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'सिक्के कटे';

  @override
  String get notifCoinsPurchaseTitle => 'खरीद पूरी हुई';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'आपने $amount सिक्के कमाए। बैलेंस: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'इनाम मिला';

  @override
  String get notifEmptyHint =>
      'चुनौतियाँ, मैच के नतीजे और सिक्कों की जानकारी यहाँ दिखेगी।';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name ने आपकी फ्रेंड रिक्वेस्ट स्वीकार की';
  }

  @override
  String get notifFriendAcceptedTitle => 'नया दोस्त';

  @override
  String notifFriendRequestBody(String name) {
    return '$name आपका दोस्त बनना चाहता है';
  }

  @override
  String get notifFriendRequestTitle => 'फ्रेंड रिक्वेस्ट';

  @override
  String get notifGeneric => 'नई सूचना';

  @override
  String notifMatchBody(String name) {
    return '$name के साथ आपका मैच खत्म हुआ';
  }

  @override
  String get notifMatchDrawTitle => 'ड्रॉ';

  @override
  String get notifMatchLostTitle => 'आप हार गए';

  @override
  String get notifMatchWonTitle => 'आप जीत गए!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name आपके प्राइवेट रूम में जुड़ गया';
  }

  @override
  String get notifRoomJoinedTitle => 'खिलाड़ी जुड़ गया';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String nowFriends(String name) {
    return 'आप और $name अब दोस्त हैं';
  }

  @override
  String get nowFriendsShort => 'अब आप दोस्त हैं';

  @override
  String get officialWebsite => 'आधिकारिक वेबसाइट';

  @override
  String get offlineAi => 'ऑफ़लाइन AI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'इंटरनेट नहीं · सिर्फ़ AI विरोधी · $size · दांव $stake';
  }

  @override
  String get offlineBanner => 'ऑफ़लाइन · द डॉल से खेलना अब भी चलेगा';

  @override
  String get offlineBody =>
      'ऑनलाइन मैच और टूर्नामेंट के लिए कनेक्शन चाहिए। आप अब भी द डॉल से खेल सकते हैं।';

  @override
  String get offlineProfilesNote =>
      'ये ऑफ़लाइन AI प्रोफ़ाइल हैं — असली ऑनलाइन खिलाड़ी नहीं।';

  @override
  String get offlineSmart => 'ऑफ़लाइन, स्मार्ट विरोधी';

  @override
  String get ok => 'ठीक है';

  @override
  String get oneLastStepCaps => 'बस एक आख़िरी कदम';

  @override
  String get online => 'ऑनलाइन';

  @override
  String get onlineMatch => 'ऑनलाइन मैच';

  @override
  String get onlineMultiplayer => 'ऑनलाइन मल्टीप्लेयर';

  @override
  String get onlineOfflineAi => 'ऑनलाइन खिलाड़ी · ऑफ़लाइन AI';

  @override
  String onlineStake(String stake) {
    return 'ऑनलाइन · दांव $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name सिर्फ़ दोस्तों की चुनौती स्वीकार करता है। पहले उन्हें जोड़ें।';
  }

  @override
  String get open => 'खोलें';

  @override
  String get openedTheLink => 'मैंने लिंक खोल लिया';

  @override
  String get openingInstaller => 'इंस्टॉलर खुल रहा है…';

  @override
  String get opponent => 'विरोधी';

  @override
  String get opponentAdvances =>
      'समय पर नहीं जुड़े तो आपका विरोधी आगे बढ़ जाएगा।';

  @override
  String get opponentDisconnected => 'विरोधी डिस्कनेक्ट हो गया';

  @override
  String get opponentWins => 'विरोधी जीता';

  @override
  String opponentsMove(String name) {
    return '$name की चाल';
  }

  @override
  String get or => 'या';

  @override
  String get orEnterCodeCaps => 'या कोड डालें';

  @override
  String get otherEvents => 'अन्य इवेंट';

  @override
  String get owned => 'आपका';

  @override
  String get passAndPlay => 'पास एंड प्ले';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordMin6 => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get passwordUpdated => 'पासवर्ड बदल गया';

  @override
  String get passwordsNoMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get pasteCode => 'कोड पेस्ट करें';

  @override
  String get pause => 'रोकें';

  @override
  String get paused => 'रुका हुआ';

  @override
  String get perMove20s => 'हर चाल 20 सेकंड';

  @override
  String get photoUpdated => 'फ़ोटो अपडेट हुई';

  @override
  String get pickClosestReason => 'क्या हो रहा है? सबसे नज़दीकी कारण चुनें।';

  @override
  String get pickYourGame => 'अपना गेम चुनें';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get playAsGuest => 'मेहमान के रूप में खेलें';

  @override
  String get playCaps => 'खेलें';

  @override
  String get playDollOffline => 'ऑफ़लाइन द डॉल से खेलें';

  @override
  String get playToBuildForm => 'अपनी फ़ॉर्म बनाने के लिए एक मैच खेलें।';

  @override
  String get playVsDoll => 'द डॉल से खेलें';

  @override
  String playVsName(String name) {
    return '$name से खेलें';
  }

  @override
  String get played => 'खेले';

  @override
  String get player => 'खिलाड़ी';

  @override
  String get player1 => 'खिलाड़ी 1';

  @override
  String get player1Move => 'खिलाड़ी 1 की चाल';

  @override
  String get player1Wins => 'खिलाड़ी 1 जीता!';

  @override
  String get player2 => 'खिलाड़ी 2';

  @override
  String get player2Move => 'खिलाड़ी 2 की चाल';

  @override
  String get player2Wins => 'खिलाड़ी 2 जीता!';

  @override
  String playerAdded(String name) {
    return '$name जोड़ा गया';
  }

  @override
  String get playerBlocked => 'खिलाड़ी ब्लॉक हुआ';

  @override
  String playerIdLabel(String id) {
    return 'खिलाड़ी $id';
  }

  @override
  String get playerUnblocked => 'खिलाड़ी अनब्लॉक हुआ';

  @override
  String get players => 'खिलाड़ी';

  @override
  String get playersLeft => 'बचे खिलाड़ी';

  @override
  String get pleaseWait => 'कृपया प्रतीक्षा करें…';

  @override
  String plusCoins(String n) {
    return '+$n कॉइन';
  }

  @override
  String get podium => 'पोडियम';

  @override
  String get pointAtHostQr => 'होस्ट के QR की ओर करें। लॉबी वाला ही कोड है।';

  @override
  String get pointCameraAtQr => 'कैमरा रूम QR कोड की ओर करें';

  @override
  String pointsWins(String points, String wins) {
    return '$points अंक · $wins जीत';
  }

  @override
  String get popular => 'लोकप्रिय';

  @override
  String get previousMatchExpired =>
      'पिछला मैच समाप्त हो गया। थोड़ी देर में फिर कोशिश करें।';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String privacyBody(String email) {
    return 'हम सिर्फ़ ऐप चलाने के लिए ज़रूरी गेम डेटा (कॉइन, कॉस्मेटिक्स, मैच इतिहास और सेटिंग्स) लेते हैं। मेहमान के रूप में खेलने के लिए खाता ज़रूरी नहीं।\n\nसाइन इन करने पर आपकी जानकारी सिर्फ़ प्रगति सेव और वापस लाने में इस्तेमाल होती है। हम निजी डेटा नहीं बेचते। आप सेटिंग्स → खाता हटाएँ से कभी भी डेटा हटा सकते हैं।\n\nसंपर्क: $email';
  }

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privateOnlyYou => 'निजी। सिर्फ़ आप इसे देख सकते हैं।';

  @override
  String get privateRoomByUsername => 'प्राइवेट रूम (यूज़रनेम से)';

  @override
  String get privateRoomCaps => 'प्राइवेट रूम';

  @override
  String get prizeAdded => 'इनाम आपके बैलेंस में जुड़ा';

  @override
  String get prizePool => 'इनाम राशि';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get profileNotFound => 'प्रोफ़ाइल नहीं मिली';

  @override
  String get profilePrivacyNote =>
      'मैच इतिहास और गतिविधि निजी रहती है। रिपोर्ट प्रोफ़ाइल के दुरुपयोग के लिए है; मैच चैट की रिपोर्ट चैट के रिपोर्ट बटन से करें।';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हुई';

  @override
  String progressOf(String done, String total) {
    return '$total में से $done';
  }

  @override
  String get publicStatsNote =>
      'सिर्फ़ रैंक, स्कोर और जीत सार्वजनिक हैं। मैच इतिहास और गतिविधि निजी रहती है।';

  @override
  String get purchaseFailed => 'खरीदारी विफल';

  @override
  String get purchases => 'खरीदारी';

  @override
  String get purchasesComingSoon =>
      'कॉइन खरीदारी जल्द आ रही है। अभी कॉइन पाने के लिए मुफ़्त कॉइन में वीडियो देखें।';

  @override
  String get quarter => 'क्वार्टर';

  @override
  String get quarterFinal => 'क्वार्टर-फ़ाइनल';

  @override
  String get quickCloseOne => 'बाल-बाल बचे!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'बढ़िया चाल!';

  @override
  String quickMatchVsAi(String time) {
    return 'AI से क्विक मैच · $time';
  }

  @override
  String get quitMatch => 'मैच छोड़ें';

  @override
  String get randomMatch => 'रैंडम मैच';

  @override
  String get rank => 'रैंक';

  @override
  String rankScore(String rank, String score) {
    return 'रैंक #$rank · स्कोर $score';
  }

  @override
  String get rankScoreUnknown => 'रैंक – · स्कोर –';

  @override
  String get ranks => 'रैंक';

  @override
  String get rateApp => 'ऐप रेट करें';

  @override
  String get ratingsSoon => 'रेटिंग जल्द आ रही है';

  @override
  String get readOnly => 'केवल पढ़ने के लिए';

  @override
  String get readyCaps => 'तैयार';

  @override
  String get reasonHarassment => 'उत्पीड़न या धमकाना';

  @override
  String get reasonInappropriate => 'यौन या अनुचित सामग्री';

  @override
  String get reasonOffensive => 'नफ़रत भरी बातें या गाली';

  @override
  String get reasonOther => 'कुछ और';

  @override
  String get reasonSpam => 'स्पैम या धोखाधड़ी';

  @override
  String get reasonThreatening => 'धमकी या हिंसा';

  @override
  String get received => 'मिली';

  @override
  String get reconnecting => 'फिर से जुड़ रहा है…';

  @override
  String reference(String id) {
    return 'संदर्भ: $id';
  }

  @override
  String get referralCode => 'रेफ़रल कोड';

  @override
  String get referralHint => 'रेफ़रल कोड (वैकल्पिक)';

  @override
  String get referralOnce =>
      'रेफ़रल कोड सिर्फ़ एक बार, साइन अप के तुरंत बाद इस्तेमाल हो सकता है।';

  @override
  String get referralPrompt =>
      'किसी दोस्त से रेफ़रल कोड मिला? अभी डालें और 50 कॉइन पाएँ।';

  @override
  String get referralWorked =>
      'आपका रेफ़रल कोड काम कर गया। कॉइन आपके वॉलेट में हैं और इस्तेमाल के लिए तैयार हैं।';

  @override
  String get refresh => 'रीफ़्रेश करें';

  @override
  String get refreshStatus => 'स्थिति रीफ़्रेश करें';

  @override
  String get region => 'क्षेत्र';

  @override
  String get regionIndiaNote =>
      'आपके सिम / डिवाइस से अपने-आप पता चला। भारत में भारतीय भाषाएँ और कीमतें ₹ में दिखती हैं।';

  @override
  String regionIntlNote(String currency) {
    return 'आपके सिम / डिवाइस से अपने-आप पता चला। अंतरराष्ट्रीय भाषाएँ, कीमतें $currency में।';
  }

  @override
  String get register => 'रजिस्टर करें';

  @override
  String get released => 'जारी';

  @override
  String get rematch => 'फिर से मुकाबला';

  @override
  String get rematchQuestion => 'फिर से मुकाबला?';

  @override
  String get remindMe => 'मेरे मैच से पहले याद दिलाएँ';

  @override
  String get reportButtonCaps => 'रिपोर्ट बटन';

  @override
  String get reportButtonHelp =>
      'लाइव चैट में ऊपर दाईं ओर, \"चैट बंद करें\" के पास। चैट चालू रहने तक हमेशा दिखता है।\nटैप करें → कारण चुनें → विवरण और स्क्रीनशॉट जोड़ें → भेजें।';

  @override
  String get reportCaps => 'रिपोर्ट';

  @override
  String get reportFailed => 'रिपोर्ट विफल';

  @override
  String reportName(String name) {
    return '$name की रिपोर्ट करें';
  }

  @override
  String get reportOrBlock => 'रिपोर्ट या ब्लॉक करें';

  @override
  String get reportOrBlockPlayer => 'इस खिलाड़ी की रिपोर्ट करें या ब्लॉक करें';

  @override
  String get reportPlayer => 'खिलाड़ी की रिपोर्ट करें';

  @override
  String get requestSentCaps => 'रिक्वेस्ट भेजी';

  @override
  String requestSentTo(String name) {
    return '$name को रिक्वेस्ट भेजी';
  }

  @override
  String get requests => 'रिक्वेस्ट';

  @override
  String requestsCount(String n) {
    return 'रिक्वेस्ट · $n';
  }

  @override
  String get requestsExpire7d =>
      'जवाब न मिलने पर रिक्वेस्ट 7 दिन बाद खत्म हो जाती हैं।';

  @override
  String get resendCode => 'कोड फिर भेजें';

  @override
  String get resendEmail => 'ईमेल फिर भेजें';

  @override
  String get resetCode => 'रीसेट कोड';

  @override
  String resetCodeSentTo(String target) {
    return 'हमने $target पर रीसेट कोड भेजा है।\nउसे नीचे लिखें — ईमेल लिंक खोलने की ज़रूरत नहीं।';
  }

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get resetPasswordBody =>
      'अपना ईमेल डालें, हम रीसेट कोड भेजेंगे। वह कोड ऐप में लिखें — ईमेल लिंक खोलने की ज़रूरत नहीं।';

  @override
  String get restart => 'फिर से शुरू';

  @override
  String get result => 'परिणाम';

  @override
  String get resume => 'फिर शुरू करें';

  @override
  String get returnToMainMenu => 'मुख्य मेन्यू पर लौटें';

  @override
  String get rewardEarnedCaps => 'इनाम मिला';

  @override
  String get rewardFlowOverview => 'इनाम प्रक्रिया का अवलोकन';

  @override
  String rewardIn(String time) {
    return 'इनाम $time में';
  }

  @override
  String get rivalO => 'विरोधी: O';

  @override
  String get roomCancelled => 'रूम रद्द';

  @override
  String roomClosesIn(String time) {
    return 'कोई न जुड़े तो रूम $time में बंद होगा।';
  }

  @override
  String get roomClosesSoon => 'कोई न जुड़े तो रूम जल्द बंद हो जाएगा।';

  @override
  String get roomClosing => 'रूम बंद हो रहा है…';

  @override
  String get roomCodeCaps => 'रूम कोड';

  @override
  String get roomCodeCopied => 'रूम कोड कॉपी हुआ';

  @override
  String get roomExpired => 'रूम की समय-सीमा खत्म';

  @override
  String get roomOpenCaps => 'रूम खुला';

  @override
  String get roundOf16 => 'अंतिम 16';

  @override
  String get roundOf16Caps => 'अंतिम 16';

  @override
  String roundOf16Vs(String name) {
    return 'अंतिम 16 · बनाम $name';
  }

  @override
  String get roundsWon => 'जीते राउंड';

  @override
  String get row => 'पंक्ति';

  @override
  String get ruleEmoji =>
      '• इमोजी रिएक्शन बिना अनुरोध के चलते हैं और म्यूट किए जा सकते हैं।';

  @override
  String get ruleEnds => '• मैच खत्म होने पर चैट अपने-आप खत्म हो जाती है।';

  @override
  String get ruleStop => '• कोई भी खिलाड़ी कभी भी चैट बंद कर सकता है।';

  @override
  String get ruleVanish =>
      '• संदेश कुछ सेकंड में गायब हो जाते हैं और कभी सेव नहीं होते।';

  @override
  String get saveChanges => 'बदलाव सेव करें';

  @override
  String get savePassword => 'पासवर्ड सेव करें';

  @override
  String get saving => 'सेव हो रहा है…';

  @override
  String get savingToCloud => 'क्लाउड में सेव हो रहा है…';

  @override
  String get scanOrShare => 'जुड़ने के लिए स्कैन करें या लिंक शेयर करें';

  @override
  String get scanQr => 'QR स्कैन करें';

  @override
  String get score => 'स्कोर';

  @override
  String get scorePlus10 => 'स्कोर +10';

  @override
  String get screenshotTooBig => 'स्क्रीनशॉट 2 MB से कम होना चाहिए';

  @override
  String get screenshotsOptionalCaps => 'स्क्रीनशॉट (वैकल्पिक)';

  @override
  String get searchPlayersHint => 'यूज़रनेम या प्लेयर ID से खोजें';

  @override
  String get searchResults => 'खोज परिणाम';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'ऑनलाइन · $size · दांव $stake · $time';
  }

  @override
  String get seatWaiting => 'खिलाड़ी, आपकी सीट इंतज़ार कर रही है।';

  @override
  String secondsLeft(String seconds) {
    return '$seconds सेकंड बचे';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'जवाब देने के लिए $seconds सेकंड बचे';
  }

  @override
  String get selectDifficulty => 'कठिनाई चुनें';

  @override
  String get selectOpponent => 'विरोधी चुनें';

  @override
  String get selectReportReason => 'रिपोर्ट का कारण चुनें';

  @override
  String get semi => 'सेमी';

  @override
  String get send => 'भेजें';

  @override
  String get sendChallenge => 'चुनौती भेजें';

  @override
  String get sendResetCode => 'रीसेट कोड भेजें';

  @override
  String get sending => 'भेज रहे हैं…';

  @override
  String get sendingMove => 'चाल भेजी जा रही है…';

  @override
  String get sent => 'भेजा';

  @override
  String serverTournamentsDemo(String error) {
    return 'सर्वर टूर्नामेंट उपलब्ध नहीं — डेमो दिखा रहे हैं।\n$error';
  }

  @override
  String get sessionExpiredReset => 'सत्र समाप्त — नया रीसेट कोड मँगाएँ';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get shareComingSoon => 'शेयर जल्द आ रहा है';

  @override
  String get shareInviteCaps => 'आमंत्रण शेयर करें';

  @override
  String get shareOnWhatsApp => 'WhatsApp पर शेयर करें';

  @override
  String get shareProfile => 'प्रोफ़ाइल शेयर करें';

  @override
  String shareWin(String url) {
    return 'मैंने अभी DROTIX का एक मैच जीता! क्या आप मुझे हरा सकते हैं? अभी खेलें: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'मैंने अभी DROTIX में $name को हराया! क्या आप मुझे हरा सकते हैं? अभी खेलें: $url';
  }

  @override
  String get shop => 'दुकान';

  @override
  String get showHidePassword => 'पासवर्ड दिखाएँ या छिपाएँ';

  @override
  String get signIn => 'साइन इन';

  @override
  String get signInChangePhoto => 'फ़ोटो बदलने के लिए साइन इन करें';

  @override
  String get signInFindFriends => 'दोस्त खोजने के लिए साइन इन करें';

  @override
  String get signInMatchmaking => 'ऑनलाइन मैचमेकिंग के लिए साइन इन ज़रूरी है';

  @override
  String get signInNotifications => 'अपनी सूचनाएँ देखने के लिए साइन इन करें';

  @override
  String get signInOnline => 'ऑनलाइन मल्टीप्लेयर खेलने के लिए साइन इन करें';

  @override
  String get signInRandomMatch =>
      'असली खिलाड़ियों से रैंडम मैच खेलने के लिए साइन इन करें';

  @override
  String get signInRequired => 'साइन इन ज़रूरी है';

  @override
  String get signInSearchPlayers =>
      'खिलाड़ी खोजने और दोस्तों को क्लाउड में सिंक करने के लिए साइन इन करें।';

  @override
  String get signInToAddFriends => 'दोस्त जोड़ने के लिए साइन इन करें';

  @override
  String get signInToChallenge =>
      'इस खिलाड़ी को चुनौती देने के लिए साइन इन करें';

  @override
  String get signInWalletHistory => 'वॉलेट इतिहास देखने के लिए साइन इन करें।';

  @override
  String get signInWithEmail => 'ईमेल से साइन इन करें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signUp => 'साइन अप';

  @override
  String get skip => 'छोड़ें';

  @override
  String get skipForNow => 'अभी छोड़ें';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String somethingWentWrongDetail(String error) {
    return 'कुछ गलत हो गया: $error';
  }

  @override
  String get soundDisabled => 'आवाज़ बंद';

  @override
  String get soundEffects => 'ध्वनि प्रभाव';

  @override
  String get soundEnabled => 'आवाज़ चालू';

  @override
  String get spent => 'खर्च';

  @override
  String get sponsored => 'प्रायोजित';

  @override
  String stakeDot(String n) {
    return 'दांव · $n';
  }

  @override
  String get stakeReturned => 'दांव वापस मिला';

  @override
  String stakeRoom(String stake, String room) {
    return 'दांव $stake · $room…';
  }

  @override
  String get start => 'शुरू करें';

  @override
  String get startPlayingCaps => 'खेलना शुरू करें';

  @override
  String get starterPack => 'स्टार्टर पैक';

  @override
  String get starting => 'शुरू हो रहा है…';

  @override
  String get startsInCaps => 'शुरू होगा';

  @override
  String get stats => 'आँकड़े';

  @override
  String statusLabel(String status) {
    return 'स्थिति: $status';
  }

  @override
  String get stayInApp => 'ऐप में बने रहें। मैच तैयार होने पर हम आपको बताएँगे।';

  @override
  String get stillOffline =>
      'अभी भी ऑफ़लाइन। कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get stopChat => 'चैट बंद करें';

  @override
  String get submitAppeal => 'अपील भेजें';

  @override
  String get submitReportCaps => 'रिपोर्ट भेजें';

  @override
  String submittedAt(String date) {
    return 'भेजा गया: $date';
  }

  @override
  String get submitting => 'भेज रहे हैं…';

  @override
  String get submittingCaps => 'भेज रहे हैं…';

  @override
  String get supportEmail => 'सहायता ईमेल';

  @override
  String suspendedAt(String date) {
    return 'निलंबित: $date';
  }

  @override
  String get suspendedByModerator =>
      'रिपोर्ट की समीक्षा के बाद एक मॉडरेटर ने यह खाता निलंबित किया।';

  @override
  String get suspendedRules =>
      'निलंबन के दौरान आप मैच नहीं खेल सकते, रूम में नहीं जुड़ सकते और चैट नहीं कर सकते। आप समीक्षा के लिए एक अपील भेज सकते हैं।';

  @override
  String get t20Seconds => 'हर चाल के लिए 20 सेकंड';

  @override
  String get tDrawReplays => 'ड्रॉ होने पर राउंड फिर से खेला जाता है';

  @override
  String get tSingleElim => 'सिंगल एलिमिनेशन: एक बार हारे तो बाहर';

  @override
  String get tSingleElimFee =>
      'सिंगल एलिमिनेशन। एक राउंड हारे तो बाहर, और प्रवेश शुल्क वापस नहीं मिलेगा।';

  @override
  String get tagline => 'सबसे खतरनाक छोटा गेम';

  @override
  String get takeTurnsBody =>
      'आप और आपका विरोधी हर बारी एक निशान लगाते हैं। चाल चलने के लिए खाली खाने पर टैप करें।';

  @override
  String get takeTurnsCaps => 'बारी-बारी खेलें';

  @override
  String get takesFewSeconds => 'इसमें आमतौर पर कुछ सेकंड लगते हैं।';

  @override
  String get tapEmptySquare => 'खाली खाने पर टैप करें';

  @override
  String get tbd => 'तय नहीं';

  @override
  String get tellUsMin10 => 'कृपया बताएँ क्या हुआ (कम से कम 10 अक्षर)';

  @override
  String get termsAccountBody =>
      'अपना साइन इन सुरक्षित रखें। आपके खाते की गतिविधि की ज़िम्मेदारी आपकी है।';

  @override
  String get termsAccountTitle => '2. आपका खाता';

  @override
  String get termsChangesBody =>
      'हम इन शर्तों को अपडेट कर सकते हैं। इस्तेमाल जारी रखने का मतलब है कि आप बदलाव स्वीकार करते हैं।';

  @override
  String get termsChangesTitle => '5. बदलाव';

  @override
  String get termsCoinsBody =>
      'कॉइन वर्चुअल वस्तुएँ हैं, इनका कोई नकद मूल्य नहीं है और इन्हें पैसों में नहीं बदला जा सकता।';

  @override
  String get termsCoinsTitle => '3. वर्चुअल कॉइन';

  @override
  String get termsFairBody =>
      'धोखाधड़ी, गाली या उत्पीड़न नहीं। नियम तोड़ने वाले खाते हम निलंबित कर सकते हैं।';

  @override
  String get termsFairTitle => '4. निष्पक्ष खेल और चैट';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get termsUsingBody =>
      'आपको इन शर्तों का पालन करना और निष्पक्ष खेलना होगा।';

  @override
  String get termsUsingTitle => '1. DROTIX का उपयोग';

  @override
  String get theirTurnCaps => 'उनकी बारी';

  @override
  String get threeInRowBody =>
      'विरोधी से पहले अपने तीन निशान आड़ी, खड़ी या तिरछी लाइन में लगाएँ।';

  @override
  String get threeInRowCaps => 'तीन एक लाइन में';

  @override
  String timeDaysAgo(String n) {
    return '$n दिन पहले';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n घंटे पहले';
  }

  @override
  String get timeJustNow => 'अभी-अभी';

  @override
  String timeMinutesAgo(String n) {
    return '$n मिनट पहले';
  }

  @override
  String get timeSkipped => 'समय खत्म होने पर चाल छूट जाती है।';

  @override
  String timesUp(String who) {
    return 'समय खत्म · $who';
  }

  @override
  String get today => 'आज';

  @override
  String get todayCaps => 'आज';

  @override
  String get top16 => 'टॉप 16';

  @override
  String get totalCoinsCaps => 'कुल कॉइन';

  @override
  String get tournament => 'टूर्नामेंट';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get tryAgainCaps => 'फिर कोशिश करें';

  @override
  String get twoPlayers => 'दो खिलाड़ी, एक फ़ोन';

  @override
  String get txChallengeEntry => 'चुनौती एंट्री';

  @override
  String get txCoinPurchase => 'कॉइन खरीद';

  @override
  String txDailyBonus(String time) {
    return 'दैनिक बोनस · $time';
  }

  @override
  String get txDailyReward => 'दैनिक इनाम';

  @override
  String get txFreeVideo => 'मुफ़्त वीडियो इनाम';

  @override
  String get txMatchWin => 'मैच जीत';

  @override
  String txPurchasing(String time) {
    return 'कॉइन खरीदकर · $time';
  }

  @override
  String txReferral(String time) {
    return 'रेफ़रल कोड · $time';
  }

  @override
  String txTournament(String time) {
    return 'टूर्नामेंट · $time';
  }

  @override
  String get txTournamentPrize => 'टूर्नामेंट इनाम';

  @override
  String txWatchingAds(String time) {
    return 'विज्ञापन देखकर · $time';
  }

  @override
  String get txWelcomeBonus => 'स्वागत बोनस';

  @override
  String txWinning(String time) {
    return 'मैच जीतकर · $time';
  }

  @override
  String get typeMessage => 'संदेश लिखें';

  @override
  String get unblockPlayer => 'खिलाड़ी को अनब्लॉक करें';

  @override
  String get unblockToAdd => 'जोड़ने के लिए इस खिलाड़ी को अनब्लॉक करें';

  @override
  String get unblockToChallenge =>
      'चुनौती देने के लिए इस खिलाड़ी को अनब्लॉक करें';

  @override
  String unlockFor(String n) {
    return 'अनलॉक · $n कॉइन';
  }

  @override
  String get unlocked => 'अनलॉक';

  @override
  String unlockedCount(String n, String total) {
    return '$total में से $n अनलॉक';
  }

  @override
  String get unranked => 'बिना रैंक';

  @override
  String get upTo3Images =>
      'अधिकतम 3 तस्वीरें। सिर्फ़ हमारी टीम इन्हें देख सकती है।';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get updateFailed => 'अपडेट विफल';

  @override
  String get updateOnAppStore => 'App Store पर अपडेट करें';

  @override
  String get updateRequired => 'अपडेट ज़रूरी है';

  @override
  String get updatesOnlyMobile => 'अपडेट Android और iOS पर उपलब्ध हैं।';

  @override
  String get useChatReport =>
      'सबूत के साथ रिपोर्ट के लिए लाइव मैच में चैट → रिपोर्ट इस्तेमाल करें।';

  @override
  String get username => 'यूज़रनेम';

  @override
  String get usernameHint => 'यूज़रनेम (a-z, 0-9, _)';

  @override
  String get verifyCode => 'कोड सत्यापित करें';

  @override
  String get verifyFailBody =>
      'कमज़ोर कनेक्शन पर, या इनाम पहले ही लेने पर ऐसा हो सकता है। आपके कॉइन सुरक्षित हैं।';

  @override
  String get verifying => 'जाँच हो रही है…';

  @override
  String get verifyingReward => 'आपका इनाम जाँच रहे हैं';

  @override
  String versionLabel(String version) {
    return 'संस्करण $version';
  }

  @override
  String get versionUnsupported =>
      'यह संस्करण अब समर्थित नहीं है। खेलते रहने के लिए अपडेट करें।';

  @override
  String get vibration => 'कंपन';

  @override
  String get victory => 'जीत';

  @override
  String get videoLength =>
      'वीडियो लगभग 15 से 30 सेकंड का है। कॉइन पाने के लिए आख़िर तक देखें।';

  @override
  String get videos => 'वीडियो';

  @override
  String get viewAppealStatus => 'अपील की स्थिति देखें';

  @override
  String get viewBracket => 'ब्रैकेट देखें';

  @override
  String get viewBracketCaps => 'ब्रैकेट देखें';

  @override
  String get viewProfile => 'प्रोफ़ाइल देखें';

  @override
  String vsName(String name) {
    return 'बनाम $name';
  }

  @override
  String get waitingCaps => 'इंतज़ार';

  @override
  String waitingForAccept(String name) {
    return '$name के स्वीकार करने का इंतज़ार…';
  }

  @override
  String get waitingForFriend => 'दोस्त का इंतज़ार...';

  @override
  String get waitingOtherMatches => 'दूसरे मैचों का इंतज़ार';

  @override
  String get waitingRoundOpen => 'राउंड खुलने का इंतज़ार';

  @override
  String get wallet => 'वॉलेट';

  @override
  String get walletBalance => 'वॉलेट बैलेंस';

  @override
  String get walletCaps => 'वॉलेट';

  @override
  String get walletUnavailable => 'वॉलेट उपलब्ध नहीं';

  @override
  String watchAnotherLeft(String n) {
    return 'एक और देखें ($n बचे)';
  }

  @override
  String get watchBracketCaps => 'ब्रैकेट देखें';

  @override
  String get watchFullVideo => 'बोनस कॉइन पाने के लिए पूरा वीडियो देखें।';

  @override
  String get watchNowCaps => 'अभी देखें';

  @override
  String get watchShortVideo => 'एक छोटा वीडियो देखें';

  @override
  String watchShortVideoToGet(String n) {
    return '+$n पाने के लिए छोटा वीडियो देखें';
  }

  @override
  String get watchVideo => 'वीडियो देखें';

  @override
  String get watchVideoCoins => 'वीडियो देखें, 10 कॉइन पाएँ';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get weeklyChest => 'साप्ताहिक संदूक';

  @override
  String get welcomeBack => 'फिर से स्वागत है';

  @override
  String get welcomeBonusCaps => 'स्वागत बोनस';

  @override
  String welcomeName(String name) {
    return 'स्वागत है, $name';
  }

  @override
  String get whatHappenedCaps => 'क्या हुआ';

  @override
  String get whatHappenedHint =>
      'बताएँ क्या हुआ और आप इस खिलाड़ी की रिपोर्ट क्यों कर रहे हैं';

  @override
  String get whatsNewCaps => 'नया क्या है';

  @override
  String get whoCanChallenge => 'आपको कौन चुनौती दे सकता है';

  @override
  String get whoCanMessage => 'आपको कौन संदेश भेज सकता है';

  @override
  String get winRate => 'जीत दर';

  @override
  String get winner => 'विजेता';

  @override
  String get wins => 'जीत';

  @override
  String winsThisRound(String name) {
    return '$name ने यह राउंड जीता।';
  }

  @override
  String get yesDelete => 'हाँ, हटाएँ';

  @override
  String get yesterday => 'कल';

  @override
  String get yesterdayCaps => 'कल';

  @override
  String get you => 'आप';

  @override
  String youBeat(String name) {
    return 'आपने $name को हराया।';
  }

  @override
  String get youFinished => 'आपकी स्थिति';

  @override
  String get youLose => 'आप हार गए';

  @override
  String youMark(String mark) {
    return 'आप · $mark';
  }

  @override
  String get youWin => 'आप जीत गए!';

  @override
  String get youWinCaps => 'आप जीते';

  @override
  String get youX => 'आप: X';

  @override
  String yourBalance(String n) {
    return 'आपका बैलेंस: $n कॉइन';
  }

  @override
  String get yourEmail => 'आपके ईमेल';

  @override
  String get yourMatchReadyCaps => 'आपका मैच तैयार है';

  @override
  String get yourMove => 'आपकी चाल';

  @override
  String get yourNextMatch => 'आपका अगला मैच';

  @override
  String get yourTurnCaps => 'आपकी बारी';

  @override
  String get youreInCaps => 'आप शामिल हैं';

  @override
  String get youreInViewBracket => 'आप शामिल हैं — ब्रैकेट देखें';

  @override
  String get youreOffline => 'आप ऑफ़लाइन हैं';
}
