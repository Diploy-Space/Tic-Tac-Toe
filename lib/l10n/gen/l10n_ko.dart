// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX는 빠르고 경쟁적인 틱택토 게임이에요. 컴퓨터와 대결하고, 실제 플레이어와 매치하고, 친구에게 도전해 랭킹을 올려보세요.';

  @override
  String get aboutUs => '소개';

  @override
  String get accept => '수락';

  @override
  String get acceptCaps => '수락';

  @override
  String get acceptRequestCaps => '요청 수락';

  @override
  String get accountCheckFailed => '계정 확인 실패';

  @override
  String get accountIsSuspended => '계정이 정지되었어요.';

  @override
  String get accountRestricted =>
      '운영자 검토가 끝날 때까지 계정이 제한돼요. 게임, 매칭, 채팅은 잠겨 있어요.';

  @override
  String get accountStatusUnknown => '계정 상태를 알 수 없어요. 다시 시도하세요.';

  @override
  String get accountSuspended => '계정 정지';

  @override
  String get accountSuspendedSignIn => '계정이 정지되었습니다. 자세히 보거나 이의를 제기하려면 로그인하세요.';

  @override
  String get accountSuspendedTitle => '계정이 정지되었어요';

  @override
  String get ach100Wins => '100승';

  @override
  String get ach10Matches => '10경기';

  @override
  String get ach50Matches => '50경기';

  @override
  String get achChallenger => '도전자';

  @override
  String get achChampion => '챔피언';

  @override
  String get achFirstWin => '첫 승리';

  @override
  String get achScore100 => '100점';

  @override
  String get achStreak3 => '3연승';

  @override
  String get achStreak5 => '5연승';

  @override
  String get achSurvivor => '생존자';

  @override
  String get achTop3 => '톱 3';

  @override
  String get achievements => '업적';

  @override
  String get add => '추가';

  @override
  String get addFriend => '친구 추가';

  @override
  String get addFriendCaps => '친구 추가';

  @override
  String get advanceQuarter => '8강 진출';

  @override
  String get advancedMode => '고급 모드 (4×4)';

  @override
  String get advertiserApp => '광고주 앱';

  @override
  String get advertiserVideo => '여기서 광고 영상이 재생돼요';

  @override
  String get all => '전체';

  @override
  String get allowAndInstall => '허용 후 설치';

  @override
  String get allowUnknownApps =>
      'DROTIX에 \'출처를 알 수 없는 앱 설치\'를 허용한 뒤 돌아오세요. 업데이트가 자동으로 설치돼요.';

  @override
  String get alreadyPlayer => '이미 계정이 있나요?';

  @override
  String get alsoBlock => '이 플레이어도 차단';

  @override
  String get alwaysTrue => '항상 적용';

  @override
  String get appUpdate => '앱 업데이트';

  @override
  String get appealExplain => '계정을 복구해야 하는 이유를 적어주세요. 운영자가 검토해요.';

  @override
  String get appealFailed => '이의 신청 실패';

  @override
  String get appealHint => '이의 신청 내용 작성 (20자 이상)…';

  @override
  String get appealIsUnderReview => '이의 신청을 검토 중이에요.';

  @override
  String get appealMin20 => '이의 신청은 20자 이상이어야 해요';

  @override
  String get appealSubmitted => '이의 신청이 접수됐어요';

  @override
  String get appealSuspension => '정지 이의 신청';

  @override
  String get appealUnderReview => '이의 신청 검토 중';

  @override
  String get applyCodeCaps => '코드 적용';

  @override
  String get attachRecentChat => '최근 채팅 메시지 첨부';

  @override
  String get attemptingReconnect => '다시 연결하는 중…';

  @override
  String get auto => '자동';

  @override
  String get avatars => '아바타';

  @override
  String get back => '뒤로';

  @override
  String get backToEvent => '이벤트로 돌아가기';

  @override
  String get backToEvents => '이벤트로 돌아가기';

  @override
  String get backToEventsCaps => '이벤트로 돌아가기';

  @override
  String get backToHome => '홈으로';

  @override
  String get backToMenu => '메뉴로';

  @override
  String get backToSignIn => '로그인으로 돌아가기';

  @override
  String balance(String n) {
    return '잔액 $n';
  }

  @override
  String get balanceAfter => '참가 후 잔액';

  @override
  String balanceArrow(String from) {
    return '잔액 $from →';
  }

  @override
  String get bestStreak => '최고 연승';

  @override
  String get bestValue => '최고의 가치';

  @override
  String get biggerBoardsBody => '큰 보드에서는 네 개를 이어야 이겨요. 줄 없이 보드가 차면 무승부예요.';

  @override
  String get biggerBoardsCaps => '더 큰 보드';

  @override
  String get biggerNeedFour => '큰 보드는 네 개를 이어야 해요';

  @override
  String get blockPlayer => '차단';

  @override
  String get boardHiddenUntilBack => '돌아올 때까지 보드가 숨겨집니다.';

  @override
  String get boards => '보드';

  @override
  String bonusAddedToWallet(String n) {
    return '코인 +$n개가 지갑에 추가됨';
  }

  @override
  String get bonusClaimed => '보너스 받음!';

  @override
  String bonusCoinsAdded(String n) {
    return '보너스 코인 +$n개 추가됨';
  }

  @override
  String get bracket => '대진표';

  @override
  String get bracketInfo => '16강 · 8경기 중 4경기 표시. 내 경기가 강조돼요.';

  @override
  String get buyCoinsCaps => '코인 구매';

  @override
  String get byBoard => '보드별';

  @override
  String get cameraOnlyForScan => '카메라는 코드 스캔에만 사용됩니다.';

  @override
  String get cameraPermissionNeeded => '스캔하려면 카메라 권한이 필요해요. 아래에 코드를 입력해도 됩니다.';

  @override
  String get cameraPermissionRequired =>
      '방 QR 코드를 스캔하려면 카메라 권한이 필요합니다. 시스템 설정에서 이 앱의 카메라를 켠 뒤 다시 시도하세요.';

  @override
  String get cancel => '취소';

  @override
  String get cancelChallenge => '도전 취소';

  @override
  String get cancelDownload => '다운로드 취소';

  @override
  String get cannotChallengeSelf => '자기 자신에게 도전할 수 없어요';

  @override
  String get cannotFriendSelf => '자기 자신을 친구로 추가할 수 없어요';

  @override
  String get cantChallengeNow => '지금은 이 플레이어에게 도전할 수 없어요.';

  @override
  String get challenge => '도전';

  @override
  String get challengeAccepted => '도전이 수락됨';

  @override
  String get challengeCancelled => '도전이 취소됨';

  @override
  String get challengeCaps => '도전하기';

  @override
  String get challengeClosed => '도전 종료';

  @override
  String get challengeDeclined => '도전이 거절됨';

  @override
  String get challengeExpired => '도전이 만료됨';

  @override
  String get challengeExpiresIn60 => '60초 안에 수락하지 않으면 도전이 만료됩니다.';

  @override
  String get challengePrivacy => '도전 개인정보';

  @override
  String get challengeRequests => '도전 요청';

  @override
  String get challengeSentCoins => '도전 보냄 · 코인 5개';

  @override
  String get challengeSentFree => '도전 보냄 · 무료 매치';

  @override
  String get challenges => '도전';

  @override
  String get championCaps => '챔피언';

  @override
  String get change => '변경';

  @override
  String get chat => '채팅';

  @override
  String get chatAfterAccept => '두 사람이 수락하면 채팅할 수 있어요.';

  @override
  String get chatAfterAcceptRandom => '두 사람이 수락하면 채팅해요. 사용자 이름 외에는 공유되지 않아요.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name님은 친구의 메시지만 받아요.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name님은 메시지를 꺼 두었어요.';
  }

  @override
  String get chatNotConnected => '채팅이 연결되지 않았어요';

  @override
  String get chatOn => '채팅 켜짐';

  @override
  String get chatPrivacyNote => '매치 채팅에 적용돼요. 변경 사항은 매치 중에도 바로 적용돼요.';

  @override
  String get chatRules => '채팅 규칙';

  @override
  String get chatRulesIntro => '텍스트 채팅은 자동으로 시작되지 않아요. 한 명이 요청하고 상대가 수락해야 해요.';

  @override
  String get checkAgainCaps => '다시 확인';

  @override
  String get checkEmail => '이메일 확인';

  @override
  String get checkEmailConfirm => '이메일을 확인하고 인증 링크를 여세요';

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String get checkInbox => '받은편지함 확인';

  @override
  String get checking => '확인 중…';

  @override
  String get chooseEntryStake => '참가 판돈 선택';

  @override
  String get chooseGameMode => '게임 모드 선택';

  @override
  String get chooseNewPassword => '새 비밀번호를 정하세요';

  @override
  String get chooseOpponent => '상대 선택';

  @override
  String get claim => '받기';

  @override
  String claimBonusCoins(String n) {
    return '보너스 코인 $n개 받기';
  }

  @override
  String get claimLabel => '받기';

  @override
  String claimPlusCoins(String n) {
    return '코인 +$n개 받기';
  }

  @override
  String get claimVictory => '승리 가져가기';

  @override
  String get claimsSync => '받은 보상은 클라우드 계정에 동기화돼요';

  @override
  String get classicMode => '클래식 모드 (3×3)';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get clipboardNoCode => '클립보드에 방 코드가 없습니다';

  @override
  String get close => '닫기';

  @override
  String get closeAndLose => '닫고 보상 포기';

  @override
  String get closeRoom => '방 닫기';

  @override
  String get closing => '닫는 중…';

  @override
  String get cloud => '클라우드';

  @override
  String cloudSaveFailed(String message) {
    return '클라우드 저장 실패: $message';
  }

  @override
  String get codeSent => '코드를 보냈어요';

  @override
  String get coinPacks => '코인 팩';

  @override
  String coinPacksFrom(String price) {
    return '$price부터 코인 팩';
  }

  @override
  String get coins5 => '코인 5개';

  @override
  String coinsAdded(String n) {
    return '코인 +$n개 추가됨';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return '코인 $delta · 잔액 $balance';
  }

  @override
  String get coinsEntryFee => '참가비 코인 5개';

  @override
  String get coinsEntryFeeBody => '무료 매치를 다 쓴 뒤나 판돈을 올릴 때 사용해요.';

  @override
  String coinsLabel(String n) {
    return '코인 $n개';
  }

  @override
  String coinsSavedCloud(String n) {
    return '코인 +$n개 (클라우드 저장)';
  }

  @override
  String get column => '세로';

  @override
  String get comeBackTomorrow => '내일 다시 오세요';

  @override
  String get completeGoogleReturnApp => 'Google 로그인을 마치고 앱으로 돌아오세요';

  @override
  String get completeGoogleSignIn => 'Google 로그인을 마치고 돌아오세요';

  @override
  String get computer => '컴퓨터';

  @override
  String get confirm => '확인';

  @override
  String get confirmJoinCaps => '확인 후 참가';

  @override
  String confirmLinkSentTo(String target) {
    return '$target(으)로 인증 링크를 보냈어요.\n이 기기에서 링크를 연 뒤 돌아오면 자동으로 로그인돼요.';
  }

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get confirmationEmailSent => '인증 메일을 보냈어요 — 받은편지함을 확인하세요';

  @override
  String get confirmingVideo => '영상 시청을 확인하고 있어요. 잠시만 기다려 주세요.';

  @override
  String get connectingChat => '채팅 연결 중…';

  @override
  String get connectionUnstable => '연결이 불안정합니다';

  @override
  String get connectionUnstableCaps => '연결 불안정';

  @override
  String get contactAbout => '문의 및 정보';

  @override
  String get contactUsCaps => '문의하기';

  @override
  String get continueLabel => '계속';

  @override
  String get continuePlaying => '계속 플레이';

  @override
  String get continueWithGoogle => 'Google로 계속';

  @override
  String copiedValue(String label, String value) {
    return '$label 복사됨: $value';
  }

  @override
  String get couldNotAddCoins => '코인을 추가할 수 없습니다';

  @override
  String get couldNotApplyReferral => '추천 코드를 적용할 수 없어요';

  @override
  String couldNotCheck(String error) {
    return '확인할 수 없어요: $error';
  }

  @override
  String get couldNotJoinRoom => '방에 참가할 수 없습니다';

  @override
  String get couldNotLoadPrivacy => '개인정보 설정을 불러올 수 없어요';

  @override
  String get couldNotLoadProfile => '프로필을 불러올 수 없어요. 다시 시도하세요.';

  @override
  String get couldNotOpenGoogle => 'Google 로그인을 열 수 없어요';

  @override
  String get couldNotSavePrivacy => '개인정보 설정을 저장할 수 없어요';

  @override
  String get couldNotStopChat => '채팅을 중지할 수 없습니다';

  @override
  String get couldNotSubmitAppeal => '이의 신청을 보낼 수 없어요';

  @override
  String get couldNotVerify => '확인할 수 없었어요';

  @override
  String get couldNotVerifyAccount => '계정 상태를 확인할 수 없습니다. 다시 시도하세요.';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get createPrivateRoom => '비공개 방 만들기';

  @override
  String get customize => '꾸미기';

  @override
  String get daily => '일일';

  @override
  String get dailyChest => '일일 상자';

  @override
  String get dailyLimit => '일일 한도 도달';

  @override
  String get date => '날짜';

  @override
  String dayN(String n) {
    return '$n일차';
  }

  @override
  String dayStreak(String n) {
    return '$n일 연속';
  }

  @override
  String get days30 => '30일';

  @override
  String get days7 => '7일';

  @override
  String get debitFailed => '코인을 차감할 수 없어요';

  @override
  String get declineCaps => '거절';

  @override
  String get defeat => '패배';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountBody => '코인, 점수, 기록이 영구적으로 삭제됩니다.';

  @override
  String get deleteAccountQuestion => '계정을 삭제할까요?';

  @override
  String get descriptionMin10 => '설명은 10자 이상이어야 해요';

  @override
  String get diagonal => '대각선';

  @override
  String get difficultyEasy => '쉬움';

  @override
  String get difficultyHard => '어려움';

  @override
  String get difficultyMedium => '보통';

  @override
  String get doll => '인형';

  @override
  String get done => '완료';

  @override
  String get downloadAndInstall => '다운로드 및 설치';

  @override
  String get downloading => '다운로드 중…';

  @override
  String downloadingPercent(String percent) {
    return '다운로드 중 $percent%';
  }

  @override
  String get draw => '무승부';

  @override
  String get drawBadge => '무승부';

  @override
  String get draws => '무승부';

  @override
  String get duration => '기간';

  @override
  String get earned => '획득';

  @override
  String get earnedThisWeek => '이번 주 획득량 (출처별)';

  @override
  String get editProfileCaps => '프로필 편집';

  @override
  String get eliminatedCaps => '탈락';

  @override
  String get email => '이메일';

  @override
  String get emailNotConfirmed => '이메일 미인증';

  @override
  String emailNotConfirmedBody(String email) {
    return '가입은 완료됐지만 이메일 인증이 아직 안 됐어요.\n\n받은편지함이나 스팸함의 인증 링크를 연 뒤 다시 로그인하세요.\n\n$email';
  }

  @override
  String get emailSentAgain => '이메일을 다시 보냈어요 — 받은편지함을 확인하세요';

  @override
  String get endsIn => '종료까지';

  @override
  String get enterCode => '코드 입력';

  @override
  String get enterCodeFromEmail => '이메일로 받은 코드를 입력하세요';

  @override
  String get enterCodeInstead => '대신 코드 입력';

  @override
  String get enterEmailPassword => '이메일과 비밀번호를 입력하세요';

  @override
  String get enterFullCode => '방 코드를 모두 입력하세요';

  @override
  String get enterReferralOrSkip => '추천 코드를 입력하거나 지금은 건너뛰세요';

  @override
  String get enterResetCode => '재설정 코드 입력';

  @override
  String get enterValidMobile => '올바른 휴대폰 번호를 입력하세요';

  @override
  String get enterValidReferral => '올바른 추천 코드를 입력하세요';

  @override
  String get enterYourEmail => '이메일을 입력하세요';

  @override
  String get entry => '참가비';

  @override
  String get entryFee => '참가비';

  @override
  String get equip => '장착';

  @override
  String get equipped => '장착됨';

  @override
  String get events => '이벤트';

  @override
  String get everyone => '모두';

  @override
  String get expertMode => '전문가 모드 (5×5)';

  @override
  String get expiredMoveToHistory => '만료된 도전은 기록으로 이동해요.';

  @override
  String get failed => '실패';

  @override
  String get fillAllFields => '모든 항목을 입력하세요';

  @override
  String get finalRound => '결승';

  @override
  String get findAMatch => '매치 찾기';

  @override
  String get findOpponent => '상대 찾기';

  @override
  String get findPrivateJoin => '찾기 · 비공개 방 · 참가 코드';

  @override
  String get findingOpponent => '상대를 찾는 중';

  @override
  String get findingPlayer => '플레이어를 찾는 중';

  @override
  String get firstMatchSet => '라운드가 열리면 첫 매치가 정해져요.';

  @override
  String get fiveOfFiveWatched => '영상 5/5개 시청';

  @override
  String get flash => '플래시';

  @override
  String get flashUnavailable => '플래시를 사용할 수 없음';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get forgotPasswordTitle => '비밀번호 찾기';

  @override
  String get free => '무료';

  @override
  String get freeCoins => '무료 코인';

  @override
  String get freeMatch => '무료 매치';

  @override
  String get freeMatchesPerDay => '하루 무료 매치 3회';

  @override
  String get freeVideosToday => '오늘의 무료 영상';

  @override
  String freeVideosUsed(String used) {
    return '오늘 무료 영상 5개 중 $used개 사용';
  }

  @override
  String get friendChallenge => '친구 도전';

  @override
  String get friendRequestExists => '이미 친구 요청이 있어요';

  @override
  String friendRequestSent(String name) {
    return '$name님에게 친구 요청을 보냈어요';
  }

  @override
  String get friendRequestSentShort => '친구 요청을 보냈어요';

  @override
  String get friendsCaps => '친구';

  @override
  String get friendsLabel => '친구';

  @override
  String get friendsOnly => '친구만';

  @override
  String get fromPhoto => '사진에서';

  @override
  String gameComingSoon(String game) {
    return '$game: 곧 출시';
  }

  @override
  String get gameOver => '게임 종료';

  @override
  String get gamePaused => '게임 일시정지';

  @override
  String get getStarted => '시작하기';

  @override
  String get gettingVideo => '영상을 불러오는 중…';

  @override
  String get goToMatchCaps => '매치로 이동';

  @override
  String get gotIt => '알겠어요';

  @override
  String get graceWindowEnded => '30초 유예 시간이 끝났어요. 승리를 가져갈 수 있어요.';

  @override
  String greatRun(String name) {
    return '$name에서 멋진 활약';
  }

  @override
  String get guard => '가드';

  @override
  String get guest => '게스트';

  @override
  String get history => '기록';

  @override
  String get historyNeverPublic => '매치 기록과 활동은 공개 프로필에 절대 표시되지 않아요.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches경기 · $wins승 · $losses패 · $draws무';
  }

  @override
  String get howItWorks => '진행 방식';

  @override
  String get howToPlay => '게임 방법';

  @override
  String get howToPlayRules =>
      '상대보다 먼저 내 표시 3개를 가로, 세로 또는 대각선으로 놓으세요. 큰 보드에서는 4개가 필요해요.';

  @override
  String howToPlayStep(String n) {
    return '게임 방법 · $n/3';
  }

  @override
  String get imReadyCaps => '준비 완료';

  @override
  String get imageTooBig => '이미지는 2MB 미만이어야 해요';

  @override
  String get install => '설치';

  @override
  String get installUpdate => '업데이트 설치';

  @override
  String get installed => '설치됨';

  @override
  String get internetRequired => '인터넷 연결이 필요합니다. 오프라인에서도 The Doll과 대결할 수 있어요.';

  @override
  String get introBody1 => '3×3, 4×4, 5×5 보드에서 AI를 이겨보세요.';

  @override
  String get introBody2 => '실제 플레이어와 랜덤 매치. 코인을 걸고 코인을 따세요.';

  @override
  String get introBody3 => '일일 보상, 미션, 토너먼트로 계속 올라가세요.';

  @override
  String get introTitle1 => '인형을 이겨라';

  @override
  String get introTitle2 => '세계와 대결';

  @override
  String get introTitle3 => '랭킹을 올려라';

  @override
  String get invalidRoomQr => '잘못된 방 QR';

  @override
  String get inviteImage => '초대 이미지';

  @override
  String get inviteImageBody => '코드, QR, 링크를 한 장에. WhatsApp 등으로 보내세요.';

  @override
  String isThinking(String name) {
    return '$name이(가) 생각 중';
  }

  @override
  String get joinCaps => '참가';

  @override
  String joinForCoins(String n) {
    return '코인 $n개로 참가';
  }

  @override
  String get joinRoomCaps => '방 참가';

  @override
  String get joinTheGame => '게임에 참여하세요';

  @override
  String joinTournamentQuestion(String name) {
    return '$name에 참가할까요?';
  }

  @override
  String get joinWithCode => '코드로 참가';

  @override
  String get joined => '참가함';

  @override
  String get joiningCaps => '참가 중…';

  @override
  String get joiningQueue => '대기열 참가 중…';

  @override
  String get joiningRoom => '방에 참가 중…';

  @override
  String get keepWatchingCaps => '계속 보기';

  @override
  String get language => '언어';

  @override
  String get languageUpdated => '언어가 변경되었습니다';

  @override
  String get last20Sent => '최근 메시지 20개가 신고와 함께 전송돼요.';

  @override
  String get last7Games => '최근 7게임';

  @override
  String lastUpdated(String date) {
    return '최종 업데이트 $date';
  }

  @override
  String get later => '나중에';

  @override
  String get latestVersion => '최신 버전을 사용 중이에요.';

  @override
  String get leaderboard => '랭킹';

  @override
  String get leaderboardUpdated => '랭킹 업데이트됨';

  @override
  String get leave => '나가기';

  @override
  String get leaveForfeitBody => '지금 나가면 기권 처리되어 상대가 승리합니다.';

  @override
  String get leaveGame => '게임 나가기';

  @override
  String get leaveMatchQuestion => '매치에서 나갈까요?';

  @override
  String get leaveVideoQuestion => '영상을 나갈까요?';

  @override
  String get letsPlay => '시작해요';

  @override
  String get linkCopied => '링크 복사됨';

  @override
  String get live => '라이브';

  @override
  String get liveEventCaps => '라이브 이벤트';

  @override
  String get loading => '불러오는 중…';

  @override
  String get local => '로컬';

  @override
  String get locked => '잠김';

  @override
  String get logOut => '로그아웃';

  @override
  String get loginMethod => '로그인 방법';

  @override
  String loseCoinsIfClose(String seconds) {
    return '지금 닫으면 코인 10개를 받을 수 없어요. $seconds초 남았어요.';
  }

  @override
  String get losses => '패배';

  @override
  String get markAllRead => '모두 읽음 표시';

  @override
  String get marks => '마크';

  @override
  String get match => '매치';

  @override
  String get matchAbandonedCaps => '매치 중단됨';

  @override
  String matchDuration(String duration) {
    return '매치 시간 $duration';
  }

  @override
  String get matchHistory => '매치 기록';

  @override
  String get matchHistoryCaps => '매치 기록';

  @override
  String get matchInvitations => '매치 초대';

  @override
  String get matchLobby => '매치 로비';

  @override
  String get matchResult => '매치 결과';

  @override
  String get matchResults => '매치 결과';

  @override
  String get matchStakes => '매치 판돈';

  @override
  String get matchStartsIn => '매치 시작까지';

  @override
  String get matches => '매치';

  @override
  String get matchmakingError => '매칭 오류';

  @override
  String get matchmakingFailed => '매칭 실패';

  @override
  String get matchmakingStopped => '매칭이 중단됨';

  @override
  String memberSince(String date) {
    return '$date부터 회원';
  }

  @override
  String get messageEmpty => '메시지를 입력하세요';

  @override
  String get messagesStayForMatch => '메시지는 이 매치 동안만 남아요';

  @override
  String minusCoins(String n) {
    return '코인 -$n개';
  }

  @override
  String get misPlay30 => '30경기 플레이';

  @override
  String get misPlay5 => '5경기 플레이';

  @override
  String get misQuick => '랜덤 매치 1회';

  @override
  String get misTourney => '토너먼트 참가';

  @override
  String get misWin15 => '15번 승리하기';

  @override
  String get misWin3 => '3번 승리하기';

  @override
  String get misWin4x4 => '4×4 보드에서 승리';

  @override
  String get missResets => '하루 빠지면 초기화돼요. 내일 다음 보상을 받으러 오세요.';

  @override
  String get missingChallengeData => '도전 정보가 없습니다';

  @override
  String get missingEmail => '이메일이 없어요 — 돌아가서 다시 시도하세요';

  @override
  String get missions => '미션';

  @override
  String missionsDone(String done, String total) {
    return '미션 $done/$total 완료';
  }

  @override
  String get mobileNotSupported => '해당 지역에서는 아직 휴대폰 번호를 지원하지 않아요';

  @override
  String get mobileOptional => '휴대폰 번호 (선택)';

  @override
  String mode(String n) {
    return '모드 $n';
  }

  @override
  String get more => '더보기';

  @override
  String get moreGames => '더 많은 게임';

  @override
  String get music => '음악';

  @override
  String nOf5(String n) {
    return '$n/5';
  }

  @override
  String get navPlay => '플레이';

  @override
  String get newCodeSent => '새 코드를 보냈어요 — 받은편지함을 확인하세요';

  @override
  String get newHere => '처음이세요?';

  @override
  String get newMatchChallengeCaps => '새 매치 도전!';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get newPasswordBody => '계정의 새 비밀번호를 입력하세요. 저장 후에도 로그인이 유지돼요.';

  @override
  String get newVersion => '새 버전';

  @override
  String get newVersionReady => 'DROTIX 새 버전이 준비됐어요.';

  @override
  String get newVideosUnlockIn => '새 무료 영상까지';

  @override
  String get next => '다음';

  @override
  String get nextCaps => '다음';

  @override
  String get nextRound => '다음 라운드';

  @override
  String get no => '아니요';

  @override
  String get noChallenge => '도전 없음';

  @override
  String get noChallengesHere => '여기에 도전이 없어요.';

  @override
  String get noCloudMatches =>
      '아직 클라우드 매치가 없어요. 로그인 후 The Doll과 대결하면 여기에 표시돼요.';

  @override
  String get noFriendsYet => '아직 친구가 없어요 — 검색해서 추가하세요.';

  @override
  String get noHistory => '기록이 없어요';

  @override
  String get noMatchesYet => '아직 매치가 없어요';

  @override
  String get noMessagesYet => '아직 메시지가 없어요.\n빠른 답장도 쓸 수 있어요.';

  @override
  String get noNotificationsYet => '아직 알림이 없습니다';

  @override
  String get noOpponentFound => '상대를 찾지 못했어요 — 다시 시도하세요';

  @override
  String get noPendingRequests => '대기 중인 요청이 없어요.';

  @override
  String get noPlayersFound => '플레이어를 찾을 수 없습니다';

  @override
  String get noQrInPhoto => '사진에서 QR을 찾지 못했어요';

  @override
  String get noRankedPlayers => '아직 순위에 오른 플레이어가 없어요. 로그인하고 플레이해서 참여하세요.';

  @override
  String get noTransactions => '아직 거래 내역이 없어요.';

  @override
  String get noVideoFound => '영상을 찾지 못했어요. 무료 영상은 차감되지 않았어요. 1분 후 다시 시도하세요.';

  @override
  String get noVideoNow => '지금은 볼 수 있는 영상이 없어요. 나중에 다시 시도하세요.';

  @override
  String get noVideoRightNow => '지금은 영상이 없어요';

  @override
  String get nobody => '아무도';

  @override
  String get nobodyBlinked => '아무도 물러서지 않았어요.';

  @override
  String nobodyBlinkedVs(String name) {
    return '아무도 물러서지 않았어요. $name이(가) 막아냈어요.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name님은 지금 도전을 받지 않아요.';
  }

  @override
  String get notEnoughCoins => '코인이 부족해요';

  @override
  String get notEnoughCoinsAnother => '다음 판돈에 필요한 코인이 부족합니다.';

  @override
  String get notEnoughCoinsStake => '이 판돈에 필요한 코인이 부족합니다.';

  @override
  String get notNow => '나중에';

  @override
  String get notSignedIn => '로그인하지 않음';

  @override
  String get notSignedInYet => '아직 로그인되지 않았어요 — 먼저 이메일 링크를 여세요';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name님이 도전을 수락했습니다. 대결 시작!';
  }

  @override
  String get notifChallengeAcceptedTitle => '도전이 수락되었습니다';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name님은 지금 대결 중입니다. 나중에 다시 시도하세요.';
  }

  @override
  String get notifChallengeBusyTitle => '플레이어가 바쁩니다';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name님이 도전을 취소했습니다';
  }

  @override
  String get notifChallengeCancelledTitle => '도전이 취소되었습니다';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name님이 도전을 거절했습니다';
  }

  @override
  String get notifChallengeDeclinedTitle => '도전이 거절되었습니다';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name님이 제시간에 응답하지 않았습니다';
  }

  @override
  String get notifChallengeExpiredTitle => '도전이 만료되었습니다';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name님이 대결을 신청했습니다';
  }

  @override
  String get notifChallengeRequestTitle => '새 도전';

  @override
  String get notifChannelDesc => '도전, 대결, 코인 내역';

  @override
  String get notifChannelName => '게임 알림';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount 코인이 추가되었습니다. 잔액: $balance';
  }

  @override
  String get notifCoinsCreditTitle => '코인이 추가되었습니다';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount 코인이 차감되었습니다. 잔액: $balance';
  }

  @override
  String get notifCoinsDebitTitle => '코인이 차감되었습니다';

  @override
  String get notifCoinsPurchaseTitle => '구매 완료';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return '$amount 코인을 획득했습니다. 잔액: $balance';
  }

  @override
  String get notifCoinsRewardTitle => '보상을 받았습니다';

  @override
  String get notifEmptyHint => '도전, 대결 결과, 코인 내역이 여기에 표시됩니다.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name님이 친구 요청을 수락했습니다';
  }

  @override
  String get notifFriendAcceptedTitle => '새 친구';

  @override
  String notifFriendRequestBody(String name) {
    return '$name님이 친구가 되고 싶어 합니다';
  }

  @override
  String get notifFriendRequestTitle => '친구 요청';

  @override
  String get notifGeneric => '새 알림';

  @override
  String notifMatchBody(String name) {
    return '$name님과의 대결이 끝났습니다';
  }

  @override
  String get notifMatchDrawTitle => '무승부';

  @override
  String get notifMatchLostTitle => '패배했습니다';

  @override
  String get notifMatchWonTitle => '승리했습니다!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name님이 비공개 방에 참가했습니다';
  }

  @override
  String get notifRoomJoinedTitle => '플레이어가 참가했습니다';

  @override
  String get notifications => '알림';

  @override
  String nowFriends(String name) {
    return '$name님과 친구가 되었어요';
  }

  @override
  String get nowFriendsShort => '이제 친구예요';

  @override
  String get officialWebsite => '공식 웹사이트';

  @override
  String get offlineAi => '오프라인 AI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return '인터넷 없음 · AI 상대만 · $size · 판돈 $stake';
  }

  @override
  String get offlineBanner => '오프라인 · The Doll과의 대결은 계속 가능';

  @override
  String get offlineBody => '온라인 매치와 토너먼트는 연결이 필요해요. The Doll과는 계속 대결할 수 있어요.';

  @override
  String get offlineProfilesNote => '오프라인 AI 프로필이에요 — 실제 온라인 플레이어가 아니에요.';

  @override
  String get offlineSmart => '오프라인, 똑똑한 상대';

  @override
  String get ok => '확인';

  @override
  String get oneLastStepCaps => '마지막 단계';

  @override
  String get online => '온라인';

  @override
  String get onlineMatch => '온라인 매치';

  @override
  String get onlineMultiplayer => '온라인 멀티플레이';

  @override
  String get onlineOfflineAi => '온라인 플레이어 · 오프라인 AI';

  @override
  String onlineStake(String stake) {
    return '온라인 · 판돈 $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name님은 친구의 도전만 받아요. 먼저 친구로 추가하세요.';
  }

  @override
  String get open => '열기';

  @override
  String get openedTheLink => '링크를 열었어요';

  @override
  String get openingInstaller => '설치 프로그램 여는 중…';

  @override
  String get opponent => '상대';

  @override
  String get opponentAdvances => '제때 참가하지 않으면 상대가 진출해요.';

  @override
  String get opponentDisconnected => '상대 연결이 끊김';

  @override
  String get opponentWins => '상대 승리';

  @override
  String opponentsMove(String name) {
    return '$name 차례';
  }

  @override
  String get or => '또는';

  @override
  String get orEnterCodeCaps => '또는 코드 입력';

  @override
  String get otherEvents => '다른 이벤트';

  @override
  String get owned => '보유';

  @override
  String get passAndPlay => '패스 & 플레이';

  @override
  String get password => '비밀번호';

  @override
  String get passwordMin6 => '비밀번호는 6자 이상이어야 해요';

  @override
  String get passwordUpdated => '비밀번호가 변경되었어요';

  @override
  String get passwordsNoMatch => '비밀번호가 일치하지 않아요';

  @override
  String get pasteCode => '코드 붙여넣기';

  @override
  String get pause => '일시정지';

  @override
  String get paused => '일시정지';

  @override
  String get perMove20s => '한 수 20초';

  @override
  String get photoUpdated => '사진이 변경되었어요';

  @override
  String get pickClosestReason => '무슨 일인가요? 가장 가까운 사유를 고르세요.';

  @override
  String get pickYourGame => '게임 선택';

  @override
  String get playAgain => '다시 하기';

  @override
  String get playAsGuest => '게스트로 플레이';

  @override
  String get playCaps => '플레이';

  @override
  String get playDollOffline => '오프라인으로 The Doll과 대결';

  @override
  String get playToBuildForm => '매치를 해서 최근 기록을 쌓아보세요.';

  @override
  String get playVsDoll => 'The Doll과 대결';

  @override
  String playVsName(String name) {
    return '$name과(와) 대결';
  }

  @override
  String get played => '플레이';

  @override
  String get player => '플레이어';

  @override
  String get player1 => '플레이어 1';

  @override
  String get player1Move => '플레이어 1 차례';

  @override
  String get player1Wins => '플레이어 1 승리!';

  @override
  String get player2 => '플레이어 2';

  @override
  String get player2Move => '플레이어 2 차례';

  @override
  String get player2Wins => '플레이어 2 승리!';

  @override
  String playerAdded(String name) {
    return '$name님을 추가했어요';
  }

  @override
  String get playerBlocked => '차단했어요';

  @override
  String playerIdLabel(String id) {
    return '플레이어 $id';
  }

  @override
  String get playerUnblocked => '차단을 해제했어요';

  @override
  String get players => '플레이어';

  @override
  String get playersLeft => '남은 플레이어';

  @override
  String get pleaseWait => '잠시만요…';

  @override
  String plusCoins(String n) {
    return '코인 +$n개';
  }

  @override
  String get podium => '시상대';

  @override
  String get pointAtHostQr => '호스트의 QR을 비추세요. 로비와 같은 코드입니다.';

  @override
  String get pointCameraAtQr => '카메라를 방 QR 코드에 맞추세요';

  @override
  String pointsWins(String points, String wins) {
    return '$points점 · $wins승';
  }

  @override
  String get popular => '인기';

  @override
  String get previousMatchExpired => '이전 매치가 만료되었습니다. 잠시 후 다시 시도하세요.';

  @override
  String get privacy => '개인정보';

  @override
  String privacyBody(String email) {
    return '앱 운영에 필요한 게임 데이터(코인, 꾸미기 아이템, 매치 기록, 설정)만 수집해요. 게스트로 플레이할 때는 계정이 필요 없어요.\n\n로그인하면 정보는 진행 상황을 저장하고 복원하는 데만 쓰여요. 개인정보를 판매하지 않아요. 설정 → 계정 삭제에서 언제든 데이터를 지울 수 있어요.\n\n문의: $email';
  }

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privateOnlyYou => '비공개. 나만 볼 수 있어요.';

  @override
  String get privateRoomByUsername => '비공개 방 (사용자 이름)';

  @override
  String get privateRoomCaps => '비공개 방';

  @override
  String get prizeAdded => '상금이 잔액에 추가됐어요';

  @override
  String get prizePool => '상금';

  @override
  String get profile => '프로필';

  @override
  String get profileNotFound => '프로필을 찾을 수 없어요';

  @override
  String get profilePrivacyNote =>
      '매치 기록과 활동은 비공개예요. 여기 신고는 프로필 악용용이며, 매치 채팅은 채팅의 신고 버튼을 사용하세요.';

  @override
  String get profileUpdated => '프로필이 업데이트되었어요';

  @override
  String progressOf(String done, String total) {
    return '$done/$total';
  }

  @override
  String get publicStatsNote => '순위, 점수, 승리만 공개돼요. 매치 기록과 활동은 비공개예요.';

  @override
  String get purchaseFailed => '구매 실패';

  @override
  String get purchases => '구매';

  @override
  String get purchasesComingSoon =>
      '코인 구매는 곧 제공돼요. 지금은 무료 코인에서 영상을 보고 코인을 받으세요.';

  @override
  String get quarter => '8강';

  @override
  String get quarterFinal => '8강';

  @override
  String get quickCloseOne => '아슬아슬했어!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => '좋은 수!';

  @override
  String quickMatchVsAi(String time) {
    return 'AI와 빠른 매치 · $time';
  }

  @override
  String get quitMatch => '매치 나가기';

  @override
  String get randomMatch => '랜덤 매치';

  @override
  String get rank => '순위';

  @override
  String rankScore(String rank, String score) {
    return '순위 #$rank · 점수 $score';
  }

  @override
  String get rankScoreUnknown => '순위 – · 점수 –';

  @override
  String get ranks => '랭킹';

  @override
  String get rateApp => '앱 평가하기';

  @override
  String get ratingsSoon => '평가 기능이 곧 제공됩니다';

  @override
  String get readOnly => '읽기 전용';

  @override
  String get readyCaps => '준비 완료';

  @override
  String get reasonHarassment => '괴롭힘 또는 따돌림';

  @override
  String get reasonInappropriate => '성적이거나 부적절한 콘텐츠';

  @override
  String get reasonOffensive => '혐오 발언 또는 욕설';

  @override
  String get reasonOther => '기타';

  @override
  String get reasonSpam => '스팸 또는 사기';

  @override
  String get reasonThreatening => '위협 또는 폭력';

  @override
  String get received => '받은 도전';

  @override
  String get reconnecting => '다시 연결 중…';

  @override
  String reference(String id) {
    return '참조: $id';
  }

  @override
  String get referralCode => '추천 코드';

  @override
  String get referralHint => '추천 코드 (선택)';

  @override
  String get referralOnce => '추천 코드는 가입 직후 한 번만 쓸 수 있어요.';

  @override
  String get referralPrompt => '친구에게 추천 코드를 받았나요? 지금 입력하고 코인 50개를 받으세요.';

  @override
  String get referralWorked => '추천 코드가 적용됐어요. 코인이 지갑에 들어왔어요.';

  @override
  String get refresh => '새로고침';

  @override
  String get refreshStatus => '상태 새로고침';

  @override
  String get region => '지역';

  @override
  String get regionIndiaNote =>
      'SIM/기기에서 자동으로 감지했습니다. 인도에서는 인도 언어와 ₹ 가격이 표시됩니다.';

  @override
  String regionIntlNote(String currency) {
    return 'SIM/기기에서 자동으로 감지했습니다. 국제 언어, 가격은 $currency로 표시됩니다.';
  }

  @override
  String get register => '가입하기';

  @override
  String get released => '출시일';

  @override
  String get rematch => '재대결';

  @override
  String get rematchQuestion => '재대결?';

  @override
  String get remindMe => '매치 전에 알림';

  @override
  String get reportButtonCaps => '신고 버튼';

  @override
  String get reportButtonHelp =>
      '라이브 채팅 오른쪽 위, \'채팅 중지\' 옆에 있어요. 채팅이 켜져 있는 동안 항상 보여요.\n탭 → 사유 선택 → 내용과 스크린샷 추가 → 제출.';

  @override
  String get reportCaps => '신고';

  @override
  String get reportFailed => '신고 실패';

  @override
  String reportName(String name) {
    return '$name 신고';
  }

  @override
  String get reportOrBlock => '신고 또는 차단';

  @override
  String get reportOrBlockPlayer => '이 플레이어 신고 또는 차단';

  @override
  String get reportPlayer => '플레이어 신고';

  @override
  String get requestSentCaps => '요청 보냄';

  @override
  String requestSentTo(String name) {
    return '$name님에게 요청을 보냈어요';
  }

  @override
  String get requests => '요청';

  @override
  String requestsCount(String n) {
    return '요청 · $n';
  }

  @override
  String get requestsExpire7d => '요청은 7일 동안 응답이 없으면 만료돼요.';

  @override
  String get resendCode => '코드 다시 보내기';

  @override
  String get resendEmail => '이메일 다시 보내기';

  @override
  String get resetCode => '재설정 코드';

  @override
  String resetCodeSentTo(String target) {
    return '$target(으)로 재설정 코드를 보냈어요.\n아래에 입력하세요 — 이메일 링크는 열 필요 없어요.';
  }

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get resetPasswordBody =>
      '이메일을 입력하면 재설정 코드를 보내드려요. 앱에 코드를 입력하세요 — 링크는 열 필요 없어요.';

  @override
  String get restart => '다시 시작';

  @override
  String get result => '결과';

  @override
  String get resume => '계속하기';

  @override
  String get returnToMainMenu => '메인 메뉴로';

  @override
  String get rewardEarnedCaps => '보상 획득';

  @override
  String get rewardFlowOverview => '보상 흐름 개요';

  @override
  String rewardIn(String time) {
    return '보상까지 $time';
  }

  @override
  String get rivalO => '상대: O';

  @override
  String get roomCancelled => '방이 취소됨';

  @override
  String roomClosesIn(String time) {
    return '아무도 참가하지 않으면 $time 후 방이 닫힙니다.';
  }

  @override
  String get roomClosesSoon => '아무도 참가하지 않으면 방이 곧 닫힙니다.';

  @override
  String get roomClosing => '방을 닫는 중…';

  @override
  String get roomCodeCaps => '방 코드';

  @override
  String get roomCodeCopied => '방 코드 복사됨';

  @override
  String get roomExpired => '방이 만료됨';

  @override
  String get roomOpenCaps => '방 열림';

  @override
  String get roundOf16 => '16강';

  @override
  String get roundOf16Caps => '16강';

  @override
  String roundOf16Vs(String name) {
    return '16강 · vs $name';
  }

  @override
  String get roundsWon => '이긴 라운드';

  @override
  String get row => '가로';

  @override
  String get ruleEmoji => '• 이모지 반응은 요청 없이 쓸 수 있고 음소거할 수 있어요.';

  @override
  String get ruleEnds => '• 매치가 끝나면 채팅도 자동으로 끝나요.';

  @override
  String get ruleStop => '• 누구든 언제든지 채팅을 중지할 수 있어요.';

  @override
  String get ruleVanish => '• 메시지는 몇 초 후 사라지고 저장되지 않아요.';

  @override
  String get saveChanges => '변경사항 저장';

  @override
  String get savePassword => '비밀번호 저장';

  @override
  String get saving => '저장 중…';

  @override
  String get savingToCloud => '클라우드에 저장 중…';

  @override
  String get scanOrShare => '스캔해서 참가하거나 링크를 공유하세요';

  @override
  String get scanQr => 'QR 스캔';

  @override
  String get score => '점수';

  @override
  String get scorePlus10 => '점수 +10';

  @override
  String get screenshotTooBig => '스크린샷은 2MB 미만이어야 해요';

  @override
  String get screenshotsOptionalCaps => '스크린샷 (선택)';

  @override
  String get searchPlayersHint => '사용자 이름 또는 플레이어 ID로 검색';

  @override
  String get searchResults => '검색 결과';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return '온라인 · $size · 판돈 $stake · $time';
  }

  @override
  String get seatWaiting => '플레이어, 자리가 기다리고 있어요.';

  @override
  String secondsLeft(String seconds) {
    return '$seconds초 남음';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return '응답까지 $seconds초 남음';
  }

  @override
  String get selectDifficulty => '난이도 선택';

  @override
  String get selectOpponent => '상대를 선택하세요';

  @override
  String get selectReportReason => '신고 사유를 선택하세요';

  @override
  String get semi => '4강';

  @override
  String get send => '보내기';

  @override
  String get sendChallenge => '도전 보내기';

  @override
  String get sendResetCode => '재설정 코드 보내기';

  @override
  String get sending => '보내는 중…';

  @override
  String get sendingMove => '수를 보내는 중…';

  @override
  String get sent => '보냄';

  @override
  String serverTournamentsDemo(String error) {
    return '서버 토너먼트를 쓸 수 없어 데모를 보여줘요.\n$error';
  }

  @override
  String get sessionExpiredReset => '세션이 만료됐어요 — 새 코드를 요청하세요';

  @override
  String get settings => '설정';

  @override
  String get shareComingSoon => '공유 기능 곧 제공';

  @override
  String get shareInviteCaps => '초대 공유';

  @override
  String get shareOnWhatsApp => 'WhatsApp으로 공유';

  @override
  String get shareProfile => '프로필 공유';

  @override
  String shareWin(String url) {
    return '방금 DROTIX에서 이겼어요! 저를 이길 수 있나요? 지금 플레이: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return '방금 DROTIX에서 $name을(를) 이겼어요! 저를 이길 수 있나요? 지금 플레이: $url';
  }

  @override
  String get shop => '상점';

  @override
  String get showHidePassword => '비밀번호 표시/숨기기';

  @override
  String get signIn => '로그인';

  @override
  String get signInChangePhoto => '사진을 바꾸려면 로그인하세요';

  @override
  String get signInFindFriends => '친구를 찾으려면 로그인하세요';

  @override
  String get signInMatchmaking => '온라인 매칭은 로그인이 필요합니다';

  @override
  String get signInNotifications => '알림을 보려면 로그인하세요';

  @override
  String get signInOnline => '온라인 멀티플레이를 하려면 로그인하세요';

  @override
  String get signInRandomMatch => '실제 플레이어와 랜덤 매치를 하려면 로그인하세요';

  @override
  String get signInRequired => '로그인이 필요합니다';

  @override
  String get signInSearchPlayers => '로그인하면 플레이어 검색과 친구 클라우드 동기화를 할 수 있어요.';

  @override
  String get signInToAddFriends => '친구를 추가하려면 로그인하세요';

  @override
  String get signInToChallenge => '이 플레이어에게 도전하려면 로그인하세요';

  @override
  String get signInWalletHistory => '지갑 기록을 보려면 로그인하세요.';

  @override
  String get signInWithEmail => '이메일로 로그인';

  @override
  String get signOut => '로그아웃';

  @override
  String get signUp => '회원가입';

  @override
  String get skip => '건너뛰기';

  @override
  String get skipForNow => '지금은 건너뛰기';

  @override
  String get somethingWentWrong => '문제가 발생했어요';

  @override
  String somethingWentWrongDetail(String error) {
    return '문제가 발생했어요: $error';
  }

  @override
  String get soundDisabled => '소리 꺼짐';

  @override
  String get soundEffects => '효과음';

  @override
  String get soundEnabled => '소리 켜짐';

  @override
  String get spent => '사용';

  @override
  String get sponsored => '스폰서';

  @override
  String stakeDot(String n) {
    return '판돈 · $n';
  }

  @override
  String get stakeReturned => '판돈 반환됨';

  @override
  String stakeRoom(String stake, String room) {
    return '판돈 $stake · $room…';
  }

  @override
  String get start => '시작';

  @override
  String get startPlayingCaps => '플레이 시작';

  @override
  String get starterPack => '스타터 팩';

  @override
  String get starting => '시작 중…';

  @override
  String get startsInCaps => '시작까지';

  @override
  String get stats => '통계';

  @override
  String statusLabel(String status) {
    return '상태: $status';
  }

  @override
  String get stayInApp => '앱에 머물러 주세요. 매치가 준비되면 알려드릴게요.';

  @override
  String get stillOffline => '아직 오프라인이에요. 연결을 확인하고 다시 시도하세요.';

  @override
  String get stopChat => '채팅 중지';

  @override
  String get submitAppeal => '이의 신청';

  @override
  String get submitReportCaps => '신고 제출';

  @override
  String submittedAt(String date) {
    return '제출 일시: $date';
  }

  @override
  String get submitting => '제출 중…';

  @override
  String get submittingCaps => '제출 중…';

  @override
  String get supportEmail => '지원 이메일';

  @override
  String suspendedAt(String date) {
    return '정지 일시: $date';
  }

  @override
  String get suspendedByModerator => '신고 검토 후 운영자가 이 계정을 정지했어요.';

  @override
  String get suspendedRules =>
      '정지 기간에는 매치, 방 참가, 채팅을 할 수 없어요. 검토를 위해 이의 신청을 한 번 할 수 있어요.';

  @override
  String get t20Seconds => '한 수당 20초';

  @override
  String get tDrawReplays => '무승부면 라운드를 다시 해요';

  @override
  String get tSingleElim => '싱글 엘리미네이션: 한 번 지면 탈락';

  @override
  String get tSingleElimFee => '싱글 엘리미네이션. 한 라운드라도 지면 탈락하고 참가비는 돌려받지 못해요.';

  @override
  String get tagline => '가장 치명적인 작은 게임';

  @override
  String get takeTurnsBody => '나와 상대가 차례마다 하나씩 표시를 둬요. 빈 칸을 탭해서 두세요.';

  @override
  String get takeTurnsCaps => '번갈아 두기';

  @override
  String get takesFewSeconds => '보통 몇 초면 돼요.';

  @override
  String get tapEmptySquare => '빈 칸을 탭하세요';

  @override
  String get tbd => '미정';

  @override
  String get tellUsMin10 => '무슨 일이 있었는지 알려주세요 (10자 이상)';

  @override
  String get termsAccountBody => '로그인 정보를 안전하게 지키세요. 계정 활동의 책임은 본인에게 있어요.';

  @override
  String get termsAccountTitle => '2. 내 계정';

  @override
  String get termsChangesBody => '약관은 변경될 수 있어요. 계속 이용하면 변경에 동의한 것으로 봐요.';

  @override
  String get termsChangesTitle => '5. 변경 사항';

  @override
  String get termsCoinsBody => '코인은 현금 가치가 없는 가상 아이템이며 돈으로 바꿀 수 없어요.';

  @override
  String get termsCoinsTitle => '3. 가상 코인';

  @override
  String get termsFairBody => '부정행위, 욕설, 괴롭힘은 금지예요. 규칙을 어긴 계정은 정지될 수 있어요.';

  @override
  String get termsFairTitle => '4. 공정한 플레이와 채팅';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get termsUsingBody => '이 약관을 지키고 공정하게 플레이해야 해요.';

  @override
  String get termsUsingTitle => '1. DROTIX 이용';

  @override
  String get theirTurnCaps => '상대 차례';

  @override
  String get threeInRowBody => '상대보다 먼저 내 표시 3개를 가로, 세로, 대각선으로 놓으세요.';

  @override
  String get threeInRowCaps => '한 줄에 세 개';

  @override
  String timeDaysAgo(String n) {
    return '$n일 전';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n시간 전';
  }

  @override
  String get timeJustNow => '방금';

  @override
  String timeMinutesAgo(String n) {
    return '$n분 전';
  }

  @override
  String get timeSkipped => '시간이 다 되면 차례를 건너뛰어요.';

  @override
  String timesUp(String who) {
    return '시간 종료 · $who';
  }

  @override
  String get today => '오늘';

  @override
  String get todayCaps => '오늘';

  @override
  String get top16 => '톱 16';

  @override
  String get totalCoinsCaps => '총 코인';

  @override
  String get tournament => '토너먼트';

  @override
  String get tryAgain => '다시 시도';

  @override
  String get tryAgainCaps => '다시 시도';

  @override
  String get twoPlayers => '두 명, 휴대폰 하나';

  @override
  String get txChallengeEntry => '도전 참가비';

  @override
  String get txCoinPurchase => '코인 구매';

  @override
  String txDailyBonus(String time) {
    return '일일 보너스 · $time';
  }

  @override
  String get txDailyReward => '일일 보상';

  @override
  String get txFreeVideo => '무료 영상 보상';

  @override
  String get txMatchWin => '매치 승리';

  @override
  String txPurchasing(String time) {
    return '코인 구매 · $time';
  }

  @override
  String txReferral(String time) {
    return '추천 코드 · $time';
  }

  @override
  String txTournament(String time) {
    return '토너먼트 · $time';
  }

  @override
  String get txTournamentPrize => '토너먼트 상금';

  @override
  String txWatchingAds(String time) {
    return '광고 시청 · $time';
  }

  @override
  String get txWelcomeBonus => '환영 보너스';

  @override
  String txWinning(String time) {
    return '매치 승리 · $time';
  }

  @override
  String get typeMessage => '메시지 입력';

  @override
  String get unblockPlayer => '차단 해제';

  @override
  String get unblockToAdd => '추가하려면 차단을 해제하세요';

  @override
  String get unblockToChallenge => '도전하려면 차단을 해제하세요';

  @override
  String unlockFor(String n) {
    return '잠금 해제 · 코인 $n개';
  }

  @override
  String get unlocked => '잠금 해제됨';

  @override
  String unlockedCount(String n, String total) {
    return '$n/$total 잠금 해제';
  }

  @override
  String get unranked => '순위 없음';

  @override
  String get upTo3Images => '최대 3장. 운영팀만 볼 수 있어요.';

  @override
  String get updateAvailable => '업데이트 가능';

  @override
  String get updateFailed => '업데이트 실패';

  @override
  String get updateOnAppStore => 'App Store에서 업데이트';

  @override
  String get updateRequired => '업데이트 필요';

  @override
  String get updatesOnlyMobile => '업데이트는 Android와 iOS에서 제공돼요.';

  @override
  String get useChatReport => '증거가 있는 신고는 매치 중 채팅 → 신고를 이용하세요.';

  @override
  String get username => '사용자 이름';

  @override
  String get usernameHint => '사용자 이름 (a-z, 0-9, _)';

  @override
  String get verifyCode => '코드 확인';

  @override
  String get verifyFailBody => '연결이 약하거나 이미 보상을 받은 경우 생길 수 있어요. 코인은 안전해요.';

  @override
  String get verifying => '확인 중…';

  @override
  String get verifyingReward => '보상 확인 중';

  @override
  String versionLabel(String version) {
    return '버전 $version';
  }

  @override
  String get versionUnsupported => '이 버전은 더 이상 지원되지 않아요. 계속하려면 업데이트하세요.';

  @override
  String get vibration => '진동';

  @override
  String get victory => '승리';

  @override
  String get videoLength => '영상은 약 15~30초예요. 끝까지 보면 코인을 받아요.';

  @override
  String get videos => '영상';

  @override
  String get viewAppealStatus => '이의 신청 상태 보기';

  @override
  String get viewBracket => '대진표 보기';

  @override
  String get viewBracketCaps => '대진표 보기';

  @override
  String get viewProfile => '프로필 보기';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String get waitingCaps => '대기 중';

  @override
  String waitingForAccept(String name) {
    return '$name의 수락을 기다리는 중…';
  }

  @override
  String get waitingForFriend => '친구를 기다리는 중...';

  @override
  String get waitingOtherMatches => '다른 매치 대기 중';

  @override
  String get waitingRoundOpen => '라운드 시작 대기 중';

  @override
  String get wallet => '지갑';

  @override
  String get walletBalance => '지갑 잔액';

  @override
  String get walletCaps => '지갑';

  @override
  String get walletUnavailable => '지갑을 사용할 수 없어요';

  @override
  String watchAnotherLeft(String n) {
    return '하나 더 보기 ($n개 남음)';
  }

  @override
  String get watchBracketCaps => '대진표 보기';

  @override
  String get watchFullVideo => '보너스 코인을 받으려면 영상을 끝까지 보세요.';

  @override
  String get watchNowCaps => '지금 보기';

  @override
  String get watchShortVideo => '짧은 영상 보기';

  @override
  String watchShortVideoToGet(String n) {
    return '짧은 영상 보고 +$n 받기';
  }

  @override
  String get watchVideo => '영상 보기';

  @override
  String get watchVideoCoins => '영상 보고 코인 10개 받기';

  @override
  String get weekly => '주간';

  @override
  String get weeklyChest => '주간 상자';

  @override
  String get welcomeBack => '다시 오신 걸 환영해요';

  @override
  String get welcomeBonusCaps => '환영 보너스';

  @override
  String welcomeName(String name) {
    return '환영해요, $name';
  }

  @override
  String get whatHappenedCaps => '무슨 일이 있었나요';

  @override
  String get whatHappenedHint => '무슨 일이 있었고 왜 이 플레이어를 신고하는지 알려주세요';

  @override
  String get whatsNewCaps => '새로운 기능';

  @override
  String get whoCanChallenge => '나에게 도전할 수 있는 사람';

  @override
  String get whoCanMessage => '나에게 메시지를 보낼 수 있는 사람';

  @override
  String get winRate => '승률';

  @override
  String get winner => '승자';

  @override
  String get wins => '승리';

  @override
  String winsThisRound(String name) {
    return '이번 라운드는 $name 승리.';
  }

  @override
  String get yesDelete => '네, 삭제';

  @override
  String get yesterday => '어제';

  @override
  String get yesterdayCaps => '어제';

  @override
  String get you => '나';

  @override
  String youBeat(String name) {
    return '$name을(를) 이겼어요.';
  }

  @override
  String get youFinished => '최종 순위';

  @override
  String get youLose => '패배했어요';

  @override
  String youMark(String mark) {
    return '나 · $mark';
  }

  @override
  String get youWin => '승리했어요!';

  @override
  String get youWinCaps => '승리';

  @override
  String get youX => '나: X';

  @override
  String yourBalance(String n) {
    return '잔액: 코인 $n개';
  }

  @override
  String get yourEmail => '내 이메일';

  @override
  String get yourMatchReadyCaps => '매치 준비 완료';

  @override
  String get yourMove => '내 차례';

  @override
  String get yourNextMatch => '다음 매치';

  @override
  String get yourTurnCaps => '내 차례';

  @override
  String get youreInCaps => '참가 완료';

  @override
  String get youreInViewBracket => '참가 완료 — 대진표 보기';

  @override
  String get youreOffline => '오프라인 상태예요';
}
