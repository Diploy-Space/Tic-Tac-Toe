// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX 是一款快节奏的三子连线竞技游戏。对战电脑、匹配真人玩家、挑战好友，冲上排行榜。';

  @override
  String get aboutUs => '关于我们';

  @override
  String get accept => '接受';

  @override
  String get acceptCaps => '接受';

  @override
  String get acceptRequestCaps => '接受请求';

  @override
  String get accountCheckFailed => '账户检查失败';

  @override
  String get accountIsSuspended => '你的账户已被停用。';

  @override
  String get accountRestricted => '在版主完成审核前，你的账户仍受限制，游戏、匹配和聊天均不可用。';

  @override
  String get accountStatusUnknown => '账户状态未知，请重试。';

  @override
  String get accountSuspended => '账户已停用';

  @override
  String get accountSuspendedSignIn => '你的账户已被停用。登录以查看详情或申诉。';

  @override
  String get accountSuspendedTitle => '你的账户已被停用';

  @override
  String get ach100Wins => '100 胜';

  @override
  String get ach10Matches => '10 局';

  @override
  String get ach50Matches => '50 局';

  @override
  String get achChallenger => '挑战者';

  @override
  String get achChampion => '冠军';

  @override
  String get achFirstWin => '首胜';

  @override
  String get achScore100 => '100 分';

  @override
  String get achStreak3 => '三连胜';

  @override
  String get achStreak5 => '五连胜';

  @override
  String get achSurvivor => '幸存者';

  @override
  String get achTop3 => '前三';

  @override
  String get achievements => '成就';

  @override
  String get add => '添加';

  @override
  String get addFriend => '添加好友';

  @override
  String get addFriendCaps => '添加好友';

  @override
  String get advanceQuarter => '你晋级 8 强';

  @override
  String get advancedMode => '进阶模式 (4×4)';

  @override
  String get advertiserApp => '广告主应用';

  @override
  String get advertiserVideo => '广告视频在此播放';

  @override
  String get all => '全部';

  @override
  String get allowAndInstall => '允许并安装';

  @override
  String get allowUnknownApps => '请为 DROTIX 开启“安装未知应用”权限后返回，更新将自动安装。';

  @override
  String get alreadyPlayer => '已有账号？';

  @override
  String get alsoBlock => '同时屏蔽该玩家';

  @override
  String get alwaysTrue => '始终适用';

  @override
  String get appUpdate => '应用更新';

  @override
  String get appealExplain => '请说明为什么应恢复你的账户，版主会审核你的留言。';

  @override
  String get appealFailed => '申诉失败';

  @override
  String get appealHint => '填写申诉内容（至少 20 个字符）…';

  @override
  String get appealIsUnderReview => '你的申诉正在审核中。';

  @override
  String get appealMin20 => '申诉至少需要 20 个字符';

  @override
  String get appealSubmitted => '申诉已成功提交';

  @override
  String get appealSuspension => '申诉停用';

  @override
  String get appealUnderReview => '申诉审核中';

  @override
  String get applyCodeCaps => '使用邀请码';

  @override
  String get attachRecentChat => '附上最近的聊天消息';

  @override
  String get attemptingReconnect => '正在尝试重新连接…';

  @override
  String get auto => '自动';

  @override
  String get avatars => '头像';

  @override
  String get back => '返回';

  @override
  String get backToEvent => '返回活动';

  @override
  String get backToEvents => '返回活动';

  @override
  String get backToEventsCaps => '返回活动';

  @override
  String get backToHome => '返回首页';

  @override
  String get backToMenu => '返回菜单';

  @override
  String get backToSignIn => '返回登录';

  @override
  String balance(String n) {
    return '余额 $n';
  }

  @override
  String get balanceAfter => '报名后余额';

  @override
  String balanceArrow(String from) {
    return '余额 $from →';
  }

  @override
  String get bestStreak => '最高连胜';

  @override
  String get bestValue => '超值';

  @override
  String get biggerBoardsBody => '大棋盘需要连成四子才能获胜。棋盘下满仍无连线则为平局。';

  @override
  String get biggerBoardsCaps => '更大的棋盘';

  @override
  String get biggerNeedFour => '大棋盘需要四子连线';

  @override
  String get blockPlayer => '屏蔽玩家';

  @override
  String get boardHiddenUntilBack => '在你回来之前，棋盘将被隐藏。';

  @override
  String get boards => '棋盘';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n 金币已存入钱包';
  }

  @override
  String get bonusClaimed => '奖励已领取！';

  @override
  String bonusCoinsAdded(String n) {
    return '已添加 +$n 奖励金币';
  }

  @override
  String get bracket => '对阵表';

  @override
  String get bracketInfo => '16 强 · 共 8 场，显示 4 场，你已高亮。';

  @override
  String get buyCoinsCaps => '购买金币';

  @override
  String get byBoard => '按棋盘';

  @override
  String get cameraOnlyForScan => '相机仅用于扫描房间码。';

  @override
  String get cameraPermissionNeeded => '扫码需要相机权限。你也可以在下方输入房间码。';

  @override
  String get cameraPermissionRequired => '扫描房间二维码需要相机权限。请在系统设置中为本应用开启相机后重试。';

  @override
  String get cancel => '取消';

  @override
  String get cancelChallenge => '取消挑战';

  @override
  String get cancelDownload => '取消下载';

  @override
  String get cannotChallengeSelf => '不能挑战自己';

  @override
  String get cannotFriendSelf => '不能添加自己为好友';

  @override
  String get cantChallengeNow => '你现在无法挑战该玩家。';

  @override
  String get challenge => '挑战';

  @override
  String get challengeAccepted => '挑战已接受';

  @override
  String get challengeCancelled => '挑战已取消';

  @override
  String get challengeCaps => '发起挑战';

  @override
  String get challengeClosed => '挑战已关闭';

  @override
  String get challengeDeclined => '挑战被拒绝';

  @override
  String get challengeExpired => '挑战已过期';

  @override
  String get challengeExpiresIn60 => '挑战若 60 秒内未被接受将失效。';

  @override
  String get challengePrivacy => '挑战隐私';

  @override
  String get challengeRequests => '挑战请求';

  @override
  String get challengeSentCoins => '挑战已发送 · 5 金币';

  @override
  String get challengeSentFree => '挑战已发送 · 免费对局';

  @override
  String get challenges => '挑战';

  @override
  String get championCaps => '冠军';

  @override
  String get change => '更改';

  @override
  String get chat => '聊天';

  @override
  String get chatAfterAccept => '双方同意后即可聊天。';

  @override
  String get chatAfterAcceptRandom => '双方同意后即可聊天，除用户名外不共享任何信息。';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name 只接收好友的消息。';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name 已关闭消息。';
  }

  @override
  String get chatNotConnected => '聊天未连接';

  @override
  String get chatOn => '聊天已开启';

  @override
  String get chatPrivacyNote => '适用于对局聊天。更改立即生效，对局中也一样。';

  @override
  String get chatRules => '聊天规则';

  @override
  String get chatRulesIntro => '文字聊天不会自动开启：一方发起，另一方同意后才开始。';

  @override
  String get checkAgainCaps => '再次检查';

  @override
  String get checkEmail => '查看邮件';

  @override
  String get checkEmailConfirm => '请查收邮件并打开验证链接';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get checkInbox => '查看收件箱';

  @override
  String get checking => '正在检查…';

  @override
  String get chooseEntryStake => '选择入场筹码';

  @override
  String get chooseGameMode => '选择游戏模式';

  @override
  String get chooseNewPassword => '设置新密码';

  @override
  String get chooseOpponent => '选择对手';

  @override
  String get claim => '领取';

  @override
  String claimBonusCoins(String n) {
    return '领取 $n 奖励金币';
  }

  @override
  String get claimLabel => '领取';

  @override
  String claimPlusCoins(String n) {
    return '领取 +$n 金币';
  }

  @override
  String get claimVictory => '领取胜利';

  @override
  String get claimsSync => '领取记录会同步到云端账户';

  @override
  String get classicMode => '经典模式 (3×3)';

  @override
  String get clearAll => '全部清除';

  @override
  String get clipboardNoCode => '剪贴板中没有房间码';

  @override
  String get close => '关闭';

  @override
  String get closeAndLose => '关闭并放弃奖励';

  @override
  String get closeRoom => '关闭房间';

  @override
  String get closing => '正在关闭…';

  @override
  String get cloud => '云端';

  @override
  String cloudSaveFailed(String message) {
    return '云端保存失败：$message';
  }

  @override
  String get codeSent => '验证码已发送';

  @override
  String get coinPacks => '金币礼包';

  @override
  String coinPacksFrom(String price) {
    return '金币礼包 $price 起';
  }

  @override
  String get coins5 => '5 金币';

  @override
  String coinsAdded(String n) {
    return '已添加 +$n 金币';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return '金币 $delta · 余额 $balance';
  }

  @override
  String get coinsEntryFee => '入场费 5 金币';

  @override
  String get coinsEntryFeeBody => '免费次数用完后使用，或用于加注。';

  @override
  String coinsLabel(String n) {
    return '$n 金币';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n 金币（已同步云端）';
  }

  @override
  String get column => '竖线';

  @override
  String get comeBackTomorrow => '明天再来';

  @override
  String get completeGoogleReturnApp => '完成 Google 登录后返回应用';

  @override
  String get completeGoogleSignIn => '完成 Google 登录后返回';

  @override
  String get computer => '电脑';

  @override
  String get confirm => '确认';

  @override
  String get confirmJoinCaps => '确认报名';

  @override
  String confirmLinkSentTo(String target) {
    return '我们已向 $target 发送验证链接。\n请在本设备上打开链接后返回，将自动登录。';
  }

  @override
  String get confirmPassword => '确认密码';

  @override
  String get confirmationEmailSent => '验证邮件已发送，请查收';

  @override
  String get confirmingVideo => '正在确认视频已看完，请稍候。';

  @override
  String get connectingChat => '正在连接聊天…';

  @override
  String get connectionUnstable => '连接不稳定';

  @override
  String get connectionUnstableCaps => '连接不稳定';

  @override
  String get contactAbout => '联系与关于';

  @override
  String get contactUsCaps => '联系我们';

  @override
  String get continueLabel => '继续';

  @override
  String get continuePlaying => '继续游戏';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String copiedValue(String label, String value) {
    return '已复制$label：$value';
  }

  @override
  String get couldNotAddCoins => '无法添加金币';

  @override
  String get couldNotApplyReferral => '无法使用邀请码';

  @override
  String couldNotCheck(String error) {
    return '检查失败：$error';
  }

  @override
  String get couldNotJoinRoom => '无法加入房间';

  @override
  String get couldNotLoadPrivacy => '无法加载隐私设置';

  @override
  String get couldNotLoadProfile => '无法加载你的资料，请重试。';

  @override
  String get couldNotOpenGoogle => '无法打开 Google 登录';

  @override
  String get couldNotSavePrivacy => '无法保存隐私设置';

  @override
  String get couldNotStopChat => '无法关闭聊天';

  @override
  String get couldNotSubmitAppeal => '无法提交申诉';

  @override
  String get couldNotVerify => '无法验证';

  @override
  String get couldNotVerifyAccount => '无法验证账户状态，请重试。';

  @override
  String get createAccount => '创建账户';

  @override
  String get createPrivateRoom => '创建私人房间';

  @override
  String get customize => '自定义';

  @override
  String get daily => '每日';

  @override
  String get dailyChest => '每日宝箱';

  @override
  String get dailyLimit => '已达每日上限';

  @override
  String get date => '日期';

  @override
  String dayN(String n) {
    return '第 $n 天';
  }

  @override
  String dayStreak(String n) {
    return '连续 $n 天';
  }

  @override
  String get days30 => '30 天';

  @override
  String get days7 => '7 天';

  @override
  String get debitFailed => '无法扣除金币';

  @override
  String get declineCaps => '拒绝';

  @override
  String get defeat => '失败';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountBody => '这将永久删除你的金币、分数和记录。';

  @override
  String get deleteAccountQuestion => '删除账户？';

  @override
  String get descriptionMin10 => '描述至少需要 10 个字符';

  @override
  String get diagonal => '斜线';

  @override
  String get difficultyEasy => '简单';

  @override
  String get difficultyHard => '困难';

  @override
  String get difficultyMedium => '中等';

  @override
  String get doll => '玩偶';

  @override
  String get done => '已完成';

  @override
  String get downloadAndInstall => '下载并安装';

  @override
  String get downloading => '正在下载…';

  @override
  String downloadingPercent(String percent) {
    return '正在下载 $percent%';
  }

  @override
  String get draw => '平局';

  @override
  String get drawBadge => '平局';

  @override
  String get draws => '平局';

  @override
  String get duration => '时间范围';

  @override
  String get earned => '获得';

  @override
  String get earnedThisWeek => '本周收入（按来源）';

  @override
  String get editProfileCaps => '编辑资料';

  @override
  String get eliminatedCaps => '已淘汰';

  @override
  String get email => '邮箱';

  @override
  String get emailNotConfirmed => '邮箱未验证';

  @override
  String emailNotConfirmedBody(String email) {
    return '注册成功，但邮箱尚未验证。\n\n请在收件箱或垃圾邮件中打开验证链接，然后重新登录。\n\n$email';
  }

  @override
  String get emailSentAgain => '邮件已重新发送，请查收';

  @override
  String get endsIn => '距结束';

  @override
  String get enterCode => '输入验证码';

  @override
  String get enterCodeFromEmail => '请输入邮件中的验证码';

  @override
  String get enterCodeInstead => '改为输入房间码';

  @override
  String get enterEmailPassword => '请输入邮箱和密码';

  @override
  String get enterFullCode => '请输入完整的房间码';

  @override
  String get enterReferralOrSkip => '请输入邀请码，或暂时跳过';

  @override
  String get enterResetCode => '输入重置码';

  @override
  String get enterValidMobile => '请输入有效的手机号';

  @override
  String get enterValidReferral => '请输入有效的邀请码';

  @override
  String get enterYourEmail => '请输入邮箱';

  @override
  String get entry => '报名费';

  @override
  String get entryFee => '报名费';

  @override
  String get equip => '装备';

  @override
  String get equipped => '已装备';

  @override
  String get events => '活动';

  @override
  String get everyone => '所有人';

  @override
  String get expertMode => '专家模式 (5×5)';

  @override
  String get expiredMoveToHistory => '过期的挑战会移到历史中。';

  @override
  String get failed => '失败';

  @override
  String get fillAllFields => '请填写所有字段';

  @override
  String get finalRound => '决赛';

  @override
  String get findAMatch => '寻找对局';

  @override
  String get findOpponent => '寻找对手';

  @override
  String get findPrivateJoin => '匹配 · 私人房间 · 加入码';

  @override
  String get findingOpponent => '正在寻找对手';

  @override
  String get findingPlayer => '正在寻找玩家';

  @override
  String get firstMatchSet => '轮次开启时将安排你的首场对局。';

  @override
  String get fiveOfFiveWatched => '已看 5/5 个视频';

  @override
  String get flash => '闪光灯';

  @override
  String get flashUnavailable => '闪光灯不可用';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get forgotPasswordTitle => '忘记密码';

  @override
  String get free => '免费';

  @override
  String get freeCoins => '免费金币';

  @override
  String get freeMatch => '免费对局';

  @override
  String get freeMatchesPerDay => '每天 3 局免费';

  @override
  String get freeVideosToday => '今日免费视频';

  @override
  String freeVideosUsed(String used) {
    return '今日已观看 $used/5 个免费视频';
  }

  @override
  String get friendChallenge => '好友挑战';

  @override
  String get friendRequestExists => '好友请求已存在';

  @override
  String friendRequestSent(String name) {
    return '已向 $name 发送好友请求';
  }

  @override
  String get friendRequestSentShort => '好友请求已发送';

  @override
  String get friendsCaps => '已是好友';

  @override
  String get friendsLabel => '好友';

  @override
  String get friendsOnly => '仅好友';

  @override
  String get fromPhoto => '从照片';

  @override
  String gameComingSoon(String game) {
    return '$game：即将推出';
  }

  @override
  String get gameOver => '游戏结束';

  @override
  String get gamePaused => '游戏已暂停';

  @override
  String get getStarted => '开始';

  @override
  String get gettingVideo => '正在获取视频…';

  @override
  String get goToMatchCaps => '进入对局';

  @override
  String get gotIt => '知道了';

  @override
  String get graceWindowEnded => '30 秒等待时间已结束，你可以领取胜利。';

  @override
  String greatRun(String name) {
    return '在 $name 中表现出色';
  }

  @override
  String get guard => '守卫';

  @override
  String get guest => '游客';

  @override
  String get history => '历史';

  @override
  String get historyNeverPublic => '你的对局记录和动态永远不会显示在公开资料中。';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches 局 · $wins 胜 · $losses 负 · $draws 平';
  }

  @override
  String get howItWorks => '规则说明';

  @override
  String get howToPlay => '玩法说明';

  @override
  String get howToPlayRules => '抢在对手之前，把你的三个棋子连成一线（横、竖或斜）。大棋盘需要连成四个。';

  @override
  String howToPlayStep(String n) {
    return '玩法 · $n/3';
  }

  @override
  String get imReadyCaps => '我准备好了';

  @override
  String get imageTooBig => '图片须小于 2 MB';

  @override
  String get install => '安装';

  @override
  String get installUpdate => '安装更新';

  @override
  String get installed => '已安装';

  @override
  String get internetRequired => '需要网络连接。你仍可以离线对战 The Doll。';

  @override
  String get introBody1 => '在 3×3、4×4 或 5×5 棋盘上击败 AI。';

  @override
  String get introBody2 => '与真人随机对战。下注金币，赢取金币。';

  @override
  String get introBody3 => '每日奖励、任务和锦标赛助你不断上升。';

  @override
  String get introTitle1 => '智胜玩偶';

  @override
  String get introTitle2 => '与世界对决';

  @override
  String get introTitle3 => '攀登排行榜';

  @override
  String get invalidRoomQr => '无效的房间二维码';

  @override
  String get inviteImage => '邀请图片';

  @override
  String get inviteImageBody => '房间码、二维码和链接合成一张图，可通过 WhatsApp 等发送。';

  @override
  String isThinking(String name) {
    return '$name 正在思考';
  }

  @override
  String get joinCaps => '加入';

  @override
  String joinForCoins(String n) {
    return '支付 $n 金币报名';
  }

  @override
  String get joinRoomCaps => '加入房间';

  @override
  String get joinTheGame => '加入游戏';

  @override
  String joinTournamentQuestion(String name) {
    return '报名 $name？';
  }

  @override
  String get joinWithCode => '输入代码加入';

  @override
  String get joined => '已报名';

  @override
  String get joiningCaps => '正在加入…';

  @override
  String get joiningQueue => '正在加入队列…';

  @override
  String get joiningRoom => '正在加入房间…';

  @override
  String get keepWatchingCaps => '继续观看';

  @override
  String get language => '语言';

  @override
  String get languageUpdated => '语言已更新';

  @override
  String get last20Sent => '最近 20 条消息将随举报一起提交。';

  @override
  String get last7Games => '最近 7 局';

  @override
  String lastUpdated(String date) {
    return '最后更新：$date';
  }

  @override
  String get later => '稍后';

  @override
  String get latestVersion => '你使用的是最新版本。';

  @override
  String get leaderboard => '排行榜';

  @override
  String get leaderboardUpdated => '排行榜已更新';

  @override
  String get leave => '离开';

  @override
  String get leaveForfeitBody => '现在离开将判负，对手获胜。';

  @override
  String get leaveGame => '离开游戏';

  @override
  String get leaveMatchQuestion => '离开对局？';

  @override
  String get leaveVideoQuestion => '要离开视频吗？';

  @override
  String get letsPlay => '开始吧';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get live => '实时';

  @override
  String get liveEventCaps => '实时活动';

  @override
  String get loading => '加载中…';

  @override
  String get local => '本地';

  @override
  String get locked => '未解锁';

  @override
  String get logOut => '退出登录';

  @override
  String get loginMethod => '登录方式';

  @override
  String loseCoinsIfClose(String seconds) {
    return '现在关闭将无法获得 10 金币，还剩 $seconds 秒。';
  }

  @override
  String get losses => '负场';

  @override
  String get markAllRead => '全部标为已读';

  @override
  String get marks => '棋子';

  @override
  String get match => '对局';

  @override
  String get matchAbandonedCaps => '对局已放弃';

  @override
  String matchDuration(String duration) {
    return '对局时长 $duration';
  }

  @override
  String get matchHistory => '对局记录';

  @override
  String get matchHistoryCaps => '对局记录';

  @override
  String get matchInvitations => '对局邀请';

  @override
  String get matchLobby => '对局大厅';

  @override
  String get matchResult => '对局结果';

  @override
  String get matchResults => '对局结果';

  @override
  String get matchStakes => '对局筹码';

  @override
  String get matchStartsIn => '对局即将开始';

  @override
  String get matches => '对局';

  @override
  String get matchmakingError => '匹配出错';

  @override
  String get matchmakingFailed => '匹配失败';

  @override
  String get matchmakingStopped => '匹配已停止';

  @override
  String memberSince(String date) {
    return '$date 加入';
  }

  @override
  String get messageEmpty => '消息不能为空';

  @override
  String get messagesStayForMatch => '消息仅在本局保留';

  @override
  String minusCoins(String n) {
    return '-$n 金币';
  }

  @override
  String get misPlay30 => '玩 30 局';

  @override
  String get misPlay5 => '玩 5 局';

  @override
  String get misQuick => '玩一局随机匹配';

  @override
  String get misTourney => '参加一场锦标赛';

  @override
  String get misWin15 => '赢 15 局';

  @override
  String get misWin3 => '赢 3 局';

  @override
  String get misWin4x4 => '在 4×4 棋盘上获胜';

  @override
  String get missResets => '漏签一天将重新计算。明天再来领下一份奖励。';

  @override
  String get missingChallengeData => '缺少挑战数据';

  @override
  String get missingEmail => '缺少邮箱，请返回重试';

  @override
  String get missions => '任务';

  @override
  String missionsDone(String done, String total) {
    return '已完成 $done/$total 个任务';
  }

  @override
  String get mobileNotSupported => '你所在地区暂不支持手机号';

  @override
  String get mobileOptional => '手机号（可选）';

  @override
  String mode(String n) {
    return '模式 $n';
  }

  @override
  String get more => '更多';

  @override
  String get moreGames => '更多游戏';

  @override
  String get music => '音乐';

  @override
  String nOf5(String n) {
    return '$n/5';
  }

  @override
  String get navPlay => '对战';

  @override
  String get newCodeSent => '新验证码已发送，请查收';

  @override
  String get newHere => '新用户？';

  @override
  String get newMatchChallengeCaps => '新的对局挑战！';

  @override
  String get newPassword => '新密码';

  @override
  String get newPasswordBody => '为你的账户输入新密码，保存后将保持登录。';

  @override
  String get newVersion => '新版本';

  @override
  String get newVersionReady => 'DROTIX 新版本已就绪。';

  @override
  String get newVideosUnlockIn => '新的免费视频将在以下时间后解锁';

  @override
  String get next => '下一步';

  @override
  String get nextCaps => '下一步';

  @override
  String get nextRound => '下一轮';

  @override
  String get no => '否';

  @override
  String get noChallenge => '没有挑战';

  @override
  String get noChallengesHere => '这里没有挑战。';

  @override
  String get noCloudMatches => '还没有云端对局。登录后对战 The Doll 即可上榜。';

  @override
  String get noFriendsYet => '还没有好友，搜索添加吧。';

  @override
  String get noHistory => '暂无记录';

  @override
  String get noMatchesYet => '还没有对局';

  @override
  String get noMessagesYet => '还没有消息。\n也可以使用快捷回复。';

  @override
  String get noNotificationsYet => '暂无通知';

  @override
  String get noOpponentFound => '未找到对手，请重试';

  @override
  String get noPendingRequests => '没有待处理的请求。';

  @override
  String get noPlayersFound => '未找到玩家';

  @override
  String get noQrInPhoto => '照片中未找到二维码';

  @override
  String get noRankedPlayers => '还没有上榜玩家。登录并游戏即可上榜。';

  @override
  String get noTransactions => '暂无交易记录。';

  @override
  String get noVideoFound => '暂时没有可用视频，你的免费次数未被消耗，请一分钟后再试。';

  @override
  String get noVideoNow => '暂无可用视频，请稍后再试。';

  @override
  String get noVideoRightNow => '暂无视频';

  @override
  String get nobody => '任何人都不可以';

  @override
  String get nobodyBlinked => '势均力敌。';

  @override
  String nobodyBlinkedVs(String name) {
    return '势均力敌，$name 挡住了你。';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name 目前不接受挑战。';
  }

  @override
  String get notEnoughCoins => '金币不足';

  @override
  String get notEnoughCoinsAnother => '金币不足，无法再次下注。';

  @override
  String get notEnoughCoinsStake => '金币不足，无法下注。';

  @override
  String get notNow => '暂不';

  @override
  String get notSignedIn => '未登录';

  @override
  String get notSignedInYet => '尚未登录，请先打开邮件中的链接';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name 接受了你的挑战，对战即将开始！';
  }

  @override
  String get notifChallengeAcceptedTitle => '挑战已接受';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name 正在对战中，请稍后再试。';
  }

  @override
  String get notifChallengeBusyTitle => '玩家正忙';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name 取消了挑战';
  }

  @override
  String get notifChallengeCancelledTitle => '挑战已取消';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name 拒绝了你的挑战';
  }

  @override
  String get notifChallengeDeclinedTitle => '挑战被拒绝';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name 未及时回应';
  }

  @override
  String get notifChallengeExpiredTitle => '挑战已过期';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name 向你发起了对战挑战';
  }

  @override
  String get notifChallengeRequestTitle => '新挑战';

  @override
  String get notifChannelDesc => '挑战、对战和金币变动';

  @override
  String get notifChannelName => '游戏提醒';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '已添加 $amount 金币。余额：$balance';
  }

  @override
  String get notifCoinsCreditTitle => '金币已到账';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '已扣除 $amount 金币。余额：$balance';
  }

  @override
  String get notifCoinsDebitTitle => '金币已扣除';

  @override
  String get notifCoinsPurchaseTitle => '购买完成';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return '你获得了 $amount 金币。余额：$balance';
  }

  @override
  String get notifCoinsRewardTitle => '已获得奖励';

  @override
  String get notifEmptyHint => '挑战、对战结果和金币变动会显示在这里。';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name 接受了你的好友请求';
  }

  @override
  String get notifFriendAcceptedTitle => '新好友';

  @override
  String notifFriendRequestBody(String name) {
    return '$name 想加你为好友';
  }

  @override
  String get notifFriendRequestTitle => '好友请求';

  @override
  String get notifGeneric => '新通知';

  @override
  String notifMatchBody(String name) {
    return '你与 $name 的对战已结束';
  }

  @override
  String get notifMatchDrawTitle => '平局';

  @override
  String get notifMatchLostTitle => '你输了';

  @override
  String get notifMatchWonTitle => '你赢了！';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name 加入了你的私人房间';
  }

  @override
  String get notifRoomJoinedTitle => '玩家已加入';

  @override
  String get notifications => '通知';

  @override
  String nowFriends(String name) {
    return '你和 $name 已成为好友';
  }

  @override
  String get nowFriendsShort => '你们已成为好友';

  @override
  String get officialWebsite => '官方网站';

  @override
  String get offlineAi => '离线 AI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return '无网络 · 仅 AI 对手 · $size · 筹码 $stake';
  }

  @override
  String get offlineBanner => '离线 · 仍可对战 The Doll';

  @override
  String get offlineBody => '在线对战和锦标赛需要联网。你仍可以对战 The Doll。';

  @override
  String get offlineProfilesNote => '这些是离线 AI 角色，不是真实的在线玩家。';

  @override
  String get offlineSmart => '离线，智能对手';

  @override
  String get ok => '确定';

  @override
  String get oneLastStepCaps => '最后一步';

  @override
  String get online => '在线';

  @override
  String get onlineMatch => '在线对战';

  @override
  String get onlineMultiplayer => '在线多人对战';

  @override
  String get onlineOfflineAi => '在线玩家 · 离线 AI';

  @override
  String onlineStake(String stake) {
    return '在线 · 筹码 $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name 只接受好友的挑战，请先添加好友。';
  }

  @override
  String get open => '打开';

  @override
  String get openedTheLink => '我已打开链接';

  @override
  String get openingInstaller => '正在打开安装程序…';

  @override
  String get opponent => '对手';

  @override
  String get opponentAdvances => '若未按时加入，对手将晋级。';

  @override
  String get opponentDisconnected => '对手已断开';

  @override
  String get opponentWins => '对手获胜';

  @override
  String opponentsMove(String name) {
    return '轮到 $name';
  }

  @override
  String get or => '或';

  @override
  String get orEnterCodeCaps => '或输入房间码';

  @override
  String get otherEvents => '其他活动';

  @override
  String get owned => '已拥有';

  @override
  String get passAndPlay => '轮流对战';

  @override
  String get password => '密码';

  @override
  String get passwordMin6 => '密码至少需要 6 个字符';

  @override
  String get passwordUpdated => '密码已更新';

  @override
  String get passwordsNoMatch => '两次密码不一致';

  @override
  String get pasteCode => '粘贴房间码';

  @override
  String get pause => '暂停';

  @override
  String get paused => '已暂停';

  @override
  String get perMove20s => '每步 20 秒';

  @override
  String get photoUpdated => '头像已更新';

  @override
  String get pickClosestReason => '发生了什么？请选择最接近的原因。';

  @override
  String get pickYourGame => '选择游戏';

  @override
  String get playAgain => '再来一局';

  @override
  String get playAsGuest => '以游客身份游玩';

  @override
  String get playCaps => '开始';

  @override
  String get playDollOffline => '离线对战 The Doll';

  @override
  String get playToBuildForm => '玩一局来积累近期战绩。';

  @override
  String get playVsDoll => '对战 The Doll';

  @override
  String playVsName(String name) {
    return '对战 $name';
  }

  @override
  String get played => '已玩';

  @override
  String get player => '玩家';

  @override
  String get player1 => '玩家 1';

  @override
  String get player1Move => '轮到玩家 1';

  @override
  String get player1Wins => '玩家 1 获胜！';

  @override
  String get player2 => '玩家 2';

  @override
  String get player2Move => '轮到玩家 2';

  @override
  String get player2Wins => '玩家 2 获胜！';

  @override
  String playerAdded(String name) {
    return '已添加 $name';
  }

  @override
  String get playerBlocked => '已屏蔽该玩家';

  @override
  String playerIdLabel(String id) {
    return '玩家 $id';
  }

  @override
  String get playerUnblocked => '已解除屏蔽';

  @override
  String get players => '玩家';

  @override
  String get playersLeft => '剩余玩家';

  @override
  String get pleaseWait => '请稍候…';

  @override
  String plusCoins(String n) {
    return '+$n 金币';
  }

  @override
  String get podium => '领奖台';

  @override
  String get pointAtHostQr => '对准房主的二维码，与大厅中的房间码相同。';

  @override
  String get pointCameraAtQr => '将相机对准房间二维码';

  @override
  String pointsWins(String points, String wins) {
    return '$points 分 · $wins 胜';
  }

  @override
  String get popular => '热门';

  @override
  String get previousMatchExpired => '上一局已过期，请稍后再试。';

  @override
  String get privacy => '隐私';

  @override
  String privacyBody(String email) {
    return '我们只收集运行应用所需的游戏数据（金币、外观、对局记录和设置）。以游客身份游玩无需账户。\n\n登录后，你的信息仅用于保存和恢复进度。我们不会出售个人数据。你可以随时在“设置 → 删除账户”中删除数据。\n\n联系方式：$email';
  }

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privateOnlyYou => '私密，仅你可见。';

  @override
  String get privateRoomByUsername => '私人房间（按用户名）';

  @override
  String get privateRoomCaps => '私人房间';

  @override
  String get prizeAdded => '奖金已存入余额';

  @override
  String get prizePool => '奖池';

  @override
  String get profile => '个人资料';

  @override
  String get profileNotFound => '未找到资料';

  @override
  String get profilePrivacyNote => '对局记录和动态保持私密。此处举报用于资料滥用；对局聊天请使用聊天中的举报按钮。';

  @override
  String get profileUpdated => '资料已更新';

  @override
  String progressOf(String done, String total) {
    return '$done/$total';
  }

  @override
  String get publicStatsNote => '仅公开排名、分数和胜场，对局记录和动态保持私密。';

  @override
  String get purchaseFailed => '购买失败';

  @override
  String get purchases => '购买';

  @override
  String get purchasesComingSoon => '金币购买即将推出。现在可在“免费金币”中观看视频获得金币。';

  @override
  String get quarter => '8 强';

  @override
  String get quarterFinal => '8 强赛';

  @override
  String get quickCloseOne => '好险！';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => '好棋！';

  @override
  String quickMatchVsAi(String time) {
    return '快速对战 AI · $time';
  }

  @override
  String get quitMatch => '退出对局';

  @override
  String get randomMatch => '随机匹配';

  @override
  String get rank => '排名';

  @override
  String rankScore(String rank, String score) {
    return '排名 #$rank · 分数 $score';
  }

  @override
  String get rankScoreUnknown => '排名 – · 分数 –';

  @override
  String get ranks => '排行';

  @override
  String get rateApp => '给应用评分';

  @override
  String get ratingsSoon => '评分功能即将推出';

  @override
  String get readOnly => '只读';

  @override
  String get readyCaps => '已准备';

  @override
  String get reasonHarassment => '骚扰或霸凌';

  @override
  String get reasonInappropriate => '色情或不当内容';

  @override
  String get reasonOffensive => '仇恨言论或辱骂';

  @override
  String get reasonOther => '其他';

  @override
  String get reasonSpam => '垃圾信息或诈骗';

  @override
  String get reasonThreatening => '威胁或暴力';

  @override
  String get received => '收到的';

  @override
  String get reconnecting => '正在重新连接…';

  @override
  String reference(String id) {
    return '编号：$id';
  }

  @override
  String get referralCode => '邀请码';

  @override
  String get referralHint => '邀请码（可选）';

  @override
  String get referralOnce => '邀请码只能在注册后立即使用一次。';

  @override
  String get referralPrompt => '有好友的邀请码吗？现在输入可得 50 金币。';

  @override
  String get referralWorked => '邀请码已生效，金币已存入钱包，可以使用了。';

  @override
  String get refresh => '刷新';

  @override
  String get refreshStatus => '刷新状态';

  @override
  String get region => '地区';

  @override
  String get regionIndiaNote => '已根据你的 SIM 卡/设备自动识别。印度地区显示印度语言，价格以 ₹ 计。';

  @override
  String regionIntlNote(String currency) {
    return '已根据你的 SIM 卡/设备自动识别。国际语言，价格以 $currency 计。';
  }

  @override
  String get register => '注册';

  @override
  String get released => '发布日期';

  @override
  String get rematch => '再战';

  @override
  String get rematchQuestion => '再来一局？';

  @override
  String get remindMe => '对局开始前提醒我';

  @override
  String get reportButtonCaps => '举报按钮';

  @override
  String get reportButtonHelp =>
      '位于实时聊天右上角，“关闭聊天”旁边。聊天开启时始终可见。\n点击 → 选择原因 → 添加详情和截图 → 提交。';

  @override
  String get reportCaps => '举报';

  @override
  String get reportFailed => '举报失败';

  @override
  String reportName(String name) {
    return '举报 $name';
  }

  @override
  String get reportOrBlock => '举报或屏蔽';

  @override
  String get reportOrBlockPlayer => '举报或屏蔽该玩家';

  @override
  String get reportPlayer => '举报玩家';

  @override
  String get requestSentCaps => '已发送请求';

  @override
  String requestSentTo(String name) {
    return '已向 $name 发送请求';
  }

  @override
  String get requests => '请求';

  @override
  String requestsCount(String n) {
    return '请求 · $n';
  }

  @override
  String get requestsExpire7d => '请求 7 天内未处理将过期。';

  @override
  String get resendCode => '重新发送验证码';

  @override
  String get resendEmail => '重新发送邮件';

  @override
  String get resetCode => '重置码';

  @override
  String resetCodeSentTo(String target) {
    return '我们已向 $target 发送重置码。\n在下方输入即可，无需打开邮件链接。';
  }

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetPasswordBody => '输入邮箱，我们会发送重置码。在应用中输入该码即可，无需打开邮件链接。';

  @override
  String get restart => '重新开始';

  @override
  String get result => '结果';

  @override
  String get resume => '继续';

  @override
  String get returnToMainMenu => '返回主菜单';

  @override
  String get rewardEarnedCaps => '已获得奖励';

  @override
  String get rewardFlowOverview => '奖励流程概览';

  @override
  String rewardIn(String time) {
    return '$time 后获得奖励';
  }

  @override
  String get rivalO => '对手：O';

  @override
  String get roomCancelled => '房间已取消';

  @override
  String roomClosesIn(String time) {
    return '若无人加入，房间将在 $time 后关闭。';
  }

  @override
  String get roomClosesSoon => '若无人加入，房间即将关闭。';

  @override
  String get roomClosing => '房间正在关闭…';

  @override
  String get roomCodeCaps => '房间码';

  @override
  String get roomCodeCopied => '房间码已复制';

  @override
  String get roomExpired => '房间已过期';

  @override
  String get roomOpenCaps => '房间开放中';

  @override
  String get roundOf16 => '16 强';

  @override
  String get roundOf16Caps => '16 强';

  @override
  String roundOf16Vs(String name) {
    return '16 强 · 对战 $name';
  }

  @override
  String get roundsWon => '获胜轮数';

  @override
  String get row => '横线';

  @override
  String get ruleEmoji => '• 表情回应无需请求，可以静音。';

  @override
  String get ruleEnds => '• 对局结束时聊天自动结束。';

  @override
  String get ruleStop => '• 任意一方都可随时关闭聊天。';

  @override
  String get ruleVanish => '• 消息几秒后消失，永不保存。';

  @override
  String get saveChanges => '保存更改';

  @override
  String get savePassword => '保存密码';

  @override
  String get saving => '正在保存…';

  @override
  String get savingToCloud => '正在保存到云端…';

  @override
  String get scanOrShare => '扫码加入，或分享链接';

  @override
  String get scanQr => '扫描二维码';

  @override
  String get score => '分数';

  @override
  String get scorePlus10 => '分数 +10';

  @override
  String get screenshotTooBig => '截图须小于 2 MB';

  @override
  String get screenshotsOptionalCaps => '截图（可选）';

  @override
  String get searchPlayersHint => '按用户名或玩家 ID 搜索';

  @override
  String get searchResults => '搜索结果';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return '在线 · $size · 筹码 $stake · $time';
  }

  @override
  String get seatWaiting => '玩家，你的座位在等你。';

  @override
  String secondsLeft(String seconds) {
    return '剩余 $seconds 秒';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return '剩余 $seconds 秒可回应';
  }

  @override
  String get selectDifficulty => '选择难度';

  @override
  String get selectOpponent => '请选择对手';

  @override
  String get selectReportReason => '请选择举报原因';

  @override
  String get semi => '4 强';

  @override
  String get send => '发送';

  @override
  String get sendChallenge => '发送挑战';

  @override
  String get sendResetCode => '发送重置码';

  @override
  String get sending => '正在发送…';

  @override
  String get sendingMove => '正在发送落子…';

  @override
  String get sent => '已发送';

  @override
  String serverTournamentsDemo(String error) {
    return '服务器锦标赛不可用，正在显示演示。\n$error';
  }

  @override
  String get sessionExpiredReset => '会话已过期，请重新获取重置码';

  @override
  String get settings => '设置';

  @override
  String get shareComingSoon => '分享功能即将推出';

  @override
  String get shareInviteCaps => '分享邀请';

  @override
  String get shareOnWhatsApp => '分享到 WhatsApp';

  @override
  String get shareProfile => '分享资料';

  @override
  String shareWin(String url) {
    return '我刚赢了一局 DROTIX！你能赢我吗？立即开玩：$url';
  }

  @override
  String shareWinVs(String name, String url) {
    return '我刚在 DROTIX 中击败了 $name！你能赢我吗？立即开玩：$url';
  }

  @override
  String get shop => '商店';

  @override
  String get showHidePassword => '显示或隐藏密码';

  @override
  String get signIn => '登录';

  @override
  String get signInChangePhoto => '登录后即可更换头像';

  @override
  String get signInFindFriends => '登录后即可查找好友';

  @override
  String get signInMatchmaking => '在线匹配需要登录';

  @override
  String get signInNotifications => '登录以查看你的通知';

  @override
  String get signInOnline => '登录后即可在线对战';

  @override
  String get signInRandomMatch => '登录后即可与真人随机匹配';

  @override
  String get signInRequired => '需要登录';

  @override
  String get signInSearchPlayers => '登录后即可搜索玩家并将好友同步到云端。';

  @override
  String get signInToAddFriends => '登录后即可添加好友';

  @override
  String get signInToChallenge => '登录后即可挑战该玩家';

  @override
  String get signInWalletHistory => '登录后即可查看钱包记录。';

  @override
  String get signInWithEmail => '使用邮箱登录';

  @override
  String get signOut => '退出';

  @override
  String get signUp => '注册';

  @override
  String get skip => '跳过';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get somethingWentWrong => '出了点问题';

  @override
  String somethingWentWrongDetail(String error) {
    return '出了点问题：$error';
  }

  @override
  String get soundDisabled => '声音关闭';

  @override
  String get soundEffects => '音效';

  @override
  String get soundEnabled => '声音开启';

  @override
  String get spent => '支出';

  @override
  String get sponsored => '赞助';

  @override
  String stakeDot(String n) {
    return '筹码 · $n';
  }

  @override
  String get stakeReturned => '筹码已退还';

  @override
  String stakeRoom(String stake, String room) {
    return '筹码 $stake · $room…';
  }

  @override
  String get start => '开始';

  @override
  String get startPlayingCaps => '开始游戏';

  @override
  String get starterPack => '新手礼包';

  @override
  String get starting => '正在开始…';

  @override
  String get startsInCaps => '即将开始';

  @override
  String get stats => '统计';

  @override
  String statusLabel(String status) {
    return '状态：$status';
  }

  @override
  String get stayInApp => '请留在应用内，对局准备好时我们会提醒你。';

  @override
  String get stillOffline => '仍处于离线状态，请检查网络后重试。';

  @override
  String get stopChat => '关闭聊天';

  @override
  String get submitAppeal => '提交申诉';

  @override
  String get submitReportCaps => '提交举报';

  @override
  String submittedAt(String date) {
    return '提交时间：$date';
  }

  @override
  String get submitting => '正在提交…';

  @override
  String get submittingCaps => '正在提交…';

  @override
  String get supportEmail => '客服邮箱';

  @override
  String suspendedAt(String date) {
    return '停用时间：$date';
  }

  @override
  String get suspendedByModerator => '版主在审核举报后停用了此账户。';

  @override
  String get suspendedRules => '停用期间无法进行对局、加入房间或聊天。你可以提交一次申诉。';

  @override
  String get t20Seconds => '每步 20 秒';

  @override
  String get tDrawReplays => '平局则重赛该轮';

  @override
  String get tSingleElim => '单败淘汰：输一局即出局';

  @override
  String get tSingleElimFee => '单败淘汰。输掉一轮即出局，报名费不退还。';

  @override
  String get tagline => '最致命的小游戏';

  @override
  String get takeTurnsBody => '你和对手每回合各落一子。点击空格即可落子。';

  @override
  String get takeTurnsCaps => '轮流落子';

  @override
  String get takesFewSeconds => '通常只需几秒钟。';

  @override
  String get tapEmptySquare => '点击空格';

  @override
  String get tbd => '待定';

  @override
  String get tellUsMin10 => '请描述发生了什么（至少 10 个字符）';

  @override
  String get termsAccountBody => '请妥善保管登录信息，你需对账户内的活动负责。';

  @override
  String get termsAccountTitle => '2. 你的账户';

  @override
  String get termsChangesBody => '我们可能会更新这些条款。继续使用即表示你接受更新。';

  @override
  String get termsChangesTitle => '5. 条款变更';

  @override
  String get termsCoinsBody => '金币是虚拟物品，没有现金价值，不能兑换成钱。';

  @override
  String get termsCoinsTitle => '3. 虚拟金币';

  @override
  String get termsFairBody => '禁止作弊、辱骂或骚扰。违规账户可能会被停用。';

  @override
  String get termsFairTitle => '4. 公平游戏与聊天';

  @override
  String get termsOfService => '服务条款';

  @override
  String get termsUsingBody => '你必须遵守这些条款并公平游戏。';

  @override
  String get termsUsingTitle => '1. 使用 DROTIX';

  @override
  String get theirTurnCaps => '对手回合';

  @override
  String get threeInRowBody => '抢在对手之前，把三个棋子连成横线、竖线或斜线。';

  @override
  String get threeInRowCaps => '三子连线';

  @override
  String timeDaysAgo(String n) {
    return '$n 天前';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n 小时前';
  }

  @override
  String get timeJustNow => '刚刚';

  @override
  String timeMinutesAgo(String n) {
    return '$n 分钟前';
  }

  @override
  String get timeSkipped => '超时将跳过本步。';

  @override
  String timesUp(String who) {
    return '时间到 · $who';
  }

  @override
  String get today => '今天';

  @override
  String get todayCaps => '今天';

  @override
  String get top16 => '前 16';

  @override
  String get totalCoinsCaps => '金币总数';

  @override
  String get tournament => '锦标赛';

  @override
  String get tryAgain => '重试';

  @override
  String get tryAgainCaps => '重试';

  @override
  String get twoPlayers => '两人同机对战';

  @override
  String get txChallengeEntry => '挑战入场费';

  @override
  String get txCoinPurchase => '购买金币';

  @override
  String txDailyBonus(String time) {
    return '每日奖励 · $time';
  }

  @override
  String get txDailyReward => '每日奖励';

  @override
  String get txFreeVideo => '免费视频奖励';

  @override
  String get txMatchWin => '对局获胜';

  @override
  String txPurchasing(String time) {
    return '购买金币 · $time';
  }

  @override
  String txReferral(String time) {
    return '邀请码 · $time';
  }

  @override
  String txTournament(String time) {
    return '锦标赛 · $time';
  }

  @override
  String get txTournamentPrize => '锦标赛奖金';

  @override
  String txWatchingAds(String time) {
    return '观看广告 · $time';
  }

  @override
  String get txWelcomeBonus => '欢迎奖励';

  @override
  String txWinning(String time) {
    return '赢得对局 · $time';
  }

  @override
  String get typeMessage => '输入消息';

  @override
  String get unblockPlayer => '解除屏蔽';

  @override
  String get unblockToAdd => '解除屏蔽后才能添加';

  @override
  String get unblockToChallenge => '解除屏蔽后才能挑战';

  @override
  String unlockFor(String n) {
    return '解锁 · $n 金币';
  }

  @override
  String get unlocked => '已解锁';

  @override
  String unlockedCount(String n, String total) {
    return '已解锁 $n/$total';
  }

  @override
  String get unranked => '未上榜';

  @override
  String get upTo3Images => '最多 3 张图片，仅我们的团队可见。';

  @override
  String get updateAvailable => '有可用更新';

  @override
  String get updateFailed => '更新失败';

  @override
  String get updateOnAppStore => '在 App Store 更新';

  @override
  String get updateRequired => '需要更新';

  @override
  String get updatesOnlyMobile => '更新仅适用于 Android 和 iOS。';

  @override
  String get useChatReport => '在对局中使用“聊天 → 举报”，可附带证据。';

  @override
  String get username => '用户名';

  @override
  String get usernameHint => '用户名（a-z、0-9、_）';

  @override
  String get verifyCode => '验证';

  @override
  String get verifyFailBody => '网络较差或奖励已领取时可能出现此情况。你的金币是安全的。';

  @override
  String get verifying => '正在验证…';

  @override
  String get verifyingReward => '正在验证奖励';

  @override
  String versionLabel(String version) {
    return '版本 $version';
  }

  @override
  String get versionUnsupported => '此版本已不再支持，请更新后继续游戏。';

  @override
  String get vibration => '振动';

  @override
  String get victory => '胜利';

  @override
  String get videoLength => '视频约 15 到 30 秒，看完即可获得金币。';

  @override
  String get videos => '视频';

  @override
  String get viewAppealStatus => '查看申诉状态';

  @override
  String get viewBracket => '查看对阵';

  @override
  String get viewBracketCaps => '查看对阵';

  @override
  String get viewProfile => '查看资料';

  @override
  String vsName(String name) {
    return '对战 $name';
  }

  @override
  String get waitingCaps => '等待中';

  @override
  String waitingForAccept(String name) {
    return '等待 $name 接受…';
  }

  @override
  String get waitingForFriend => '正在等待好友...';

  @override
  String get waitingOtherMatches => '等待其他对局';

  @override
  String get waitingRoundOpen => '等待轮次开启';

  @override
  String get wallet => '钱包';

  @override
  String get walletBalance => '钱包余额';

  @override
  String get walletCaps => '钱包';

  @override
  String get walletUnavailable => '钱包不可用';

  @override
  String watchAnotherLeft(String n) {
    return '再看一个（剩 $n 个）';
  }

  @override
  String get watchBracketCaps => '观看对阵';

  @override
  String get watchFullVideo => '看完整个视频即可领取奖励金币。';

  @override
  String get watchNowCaps => '立即观看';

  @override
  String get watchShortVideo => '观看一段短视频';

  @override
  String watchShortVideoToGet(String n) {
    return '观看短视频获得 +$n';
  }

  @override
  String get watchVideo => '观看视频';

  @override
  String get watchVideoCoins => '观看视频，获得 10 金币';

  @override
  String get weekly => '每周';

  @override
  String get weeklyChest => '每周宝箱';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get welcomeBonusCaps => '欢迎奖励';

  @override
  String welcomeName(String name) {
    return '欢迎，$name';
  }

  @override
  String get whatHappenedCaps => '发生了什么';

  @override
  String get whatHappenedHint => '请说明发生了什么以及举报该玩家的原因';

  @override
  String get whatsNewCaps => '更新内容';

  @override
  String get whoCanChallenge => '谁可以挑战你';

  @override
  String get whoCanMessage => '谁可以给你发消息';

  @override
  String get winRate => '胜率';

  @override
  String get winner => '胜者';

  @override
  String get wins => '胜场';

  @override
  String winsThisRound(String name) {
    return '$name 赢下了这一局。';
  }

  @override
  String get yesDelete => '是，删除';

  @override
  String get yesterday => '昨天';

  @override
  String get yesterdayCaps => '昨天';

  @override
  String get you => '你';

  @override
  String youBeat(String name) {
    return '你击败了 $name。';
  }

  @override
  String get youFinished => '你的名次';

  @override
  String get youLose => '你输了';

  @override
  String youMark(String mark) {
    return '你 · $mark';
  }

  @override
  String get youWin => '你赢了！';

  @override
  String get youWinCaps => '你赢了';

  @override
  String get youX => '你：X';

  @override
  String yourBalance(String n) {
    return '你的余额：$n 金币';
  }

  @override
  String get yourEmail => '你的邮箱';

  @override
  String get yourMatchReadyCaps => '你的对局已就绪';

  @override
  String get yourMove => '轮到你';

  @override
  String get yourNextMatch => '你的下一场';

  @override
  String get yourTurnCaps => '你的回合';

  @override
  String get youreInCaps => '报名成功';

  @override
  String get youreInViewBracket => '已报名 — 查看对阵';

  @override
  String get youreOffline => '你已离线';
}
