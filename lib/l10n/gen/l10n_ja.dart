// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIXはスピーディーな対戦型三目並べです。コンピューターと対戦したり、本物のプレイヤーとマッチしたり、友だちに挑戦してランキングを駆け上がろう。';

  @override
  String get aboutUs => 'アプリについて';

  @override
  String get accept => '承認';

  @override
  String get acceptCaps => '承諾';

  @override
  String get acceptRequestCaps => '申請を承認';

  @override
  String get accountCheckFailed => 'アカウント確認に失敗しました';

  @override
  String get accountIsSuspended => 'アカウントは停止中です。';

  @override
  String get accountRestricted =>
      'モデレーターの審査が終わるまでアカウントは制限されたままです。プレイ、マッチング、チャットは利用できません。';

  @override
  String get accountStatusUnknown => 'アカウントの状態が不明です。もう一度お試しください。';

  @override
  String get accountSuspended => 'アカウント停止';

  @override
  String get accountSuspendedSignIn =>
      'アカウントが停止されました。詳細の確認や異議申し立てにはサインインしてください。';

  @override
  String get accountSuspendedTitle => 'アカウントが停止されました';

  @override
  String get ach100Wins => '100勝';

  @override
  String get ach10Matches => '10試合';

  @override
  String get ach50Matches => '50試合';

  @override
  String get achChallenger => 'チャレンジャー';

  @override
  String get achChampion => 'チャンピオン';

  @override
  String get achFirstWin => '初勝利';

  @override
  String get achScore100 => 'スコア100';

  @override
  String get achStreak3 => '3連勝';

  @override
  String get achStreak5 => '5連勝';

  @override
  String get achSurvivor => 'サバイバー';

  @override
  String get achTop3 => 'トップ3';

  @override
  String get achievements => '実績';

  @override
  String get add => '追加';

  @override
  String get addFriend => '友だち追加';

  @override
  String get addFriendCaps => '友だち追加';

  @override
  String get advanceQuarter => '準々決勝に進出';

  @override
  String get advancedMode => 'アドバンス (4×4)';

  @override
  String get advertiserApp => '広告主のアプリ';

  @override
  String get advertiserVideo => 'ここに広告動画が流れます';

  @override
  String get all => 'すべて';

  @override
  String get allowAndInstall => '許可してインストール';

  @override
  String get allowUnknownApps =>
      'DROTIXに「不明なアプリのインストール」を許可して戻ってください。アップデートは自動でインストールされます。';

  @override
  String get alreadyPlayer => 'すでにプレイヤー？';

  @override
  String get alsoBlock => 'このプレイヤーをブロックする';

  @override
  String get alwaysTrue => 'いつでも';

  @override
  String get appUpdate => 'アプリのアップデート';

  @override
  String get appealExplain => 'アカウントを復活させるべき理由を書いてください。モデレーターが確認します。';

  @override
  String get appealFailed => '申し立てに失敗しました';

  @override
  String get appealHint => '申し立て内容を入力（20文字以上）…';

  @override
  String get appealIsUnderReview => '異議申し立てを審査中です。';

  @override
  String get appealMin20 => '申し立ては20文字以上にしてください';

  @override
  String get appealSubmitted => '申し立てを送信しました';

  @override
  String get appealSuspension => '停止への異議申し立て';

  @override
  String get appealUnderReview => '申し立て審査中';

  @override
  String get applyCodeCaps => 'コードを適用';

  @override
  String get attachRecentChat => '最近のチャットを添付';

  @override
  String get attemptingReconnect => '再接続しています…';

  @override
  String get auto => '自動';

  @override
  String get avatars => 'アバター';

  @override
  String get back => '戻る';

  @override
  String get backToEvent => 'イベントに戻る';

  @override
  String get backToEvents => 'イベントに戻る';

  @override
  String get backToEventsCaps => 'イベントに戻る';

  @override
  String get backToHome => 'ホームに戻る';

  @override
  String get backToMenu => 'メニューに戻る';

  @override
  String get backToSignIn => 'サインインに戻る';

  @override
  String balance(String n) {
    return '残高 $n';
  }

  @override
  String get balanceAfter => '参加後の残高';

  @override
  String balanceArrow(String from) {
    return '残高 $from →';
  }

  @override
  String get bestStreak => '最高連勝';

  @override
  String get bestValue => 'お得';

  @override
  String get biggerBoardsBody => '大きい盤では4つ並べると勝ち。並ばずに盤が埋まれば引き分けです。';

  @override
  String get biggerBoardsCaps => '大きな盤';

  @override
  String get biggerNeedFour => '大きい盤は4つ並べる';

  @override
  String get blockPlayer => 'ブロック';

  @override
  String get boardHiddenUntilBack => '戻るまで盤面は非表示になります。';

  @override
  String get boards => '盤面';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n コインがウォレットに追加されました';
  }

  @override
  String get bonusClaimed => 'ボーナス獲得！';

  @override
  String bonusCoinsAdded(String n) {
    return 'ボーナス +$n コイン追加';
  }

  @override
  String get bracket => 'トーナメント表';

  @override
  String get bracketInfo => 'ベスト16 · 全8試合中4試合を表示。あなたはハイライトされています。';

  @override
  String get buyCoinsCaps => 'コインを買う';

  @override
  String get byBoard => '盤面別';

  @override
  String get cameraOnlyForScan => 'カメラはコードのスキャンにのみ使用します。';

  @override
  String get cameraPermissionNeeded => 'スキャンにはカメラの許可が必要です。下にコードを入力することもできます。';

  @override
  String get cameraPermissionRequired =>
      'ルームのQRコードをスキャンするにはカメラの許可が必要です。システム設定でこのアプリのカメラを有効にしてから再試行してください。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get cancelChallenge => 'チャレンジを取り消す';

  @override
  String get cancelDownload => 'ダウンロードをキャンセル';

  @override
  String get cannotChallengeSelf => '自分にはチャレンジできません';

  @override
  String get cannotFriendSelf => '自分を友だちに追加することはできません';

  @override
  String get cantChallengeNow => '現在このプレイヤーにはチャレンジできません。';

  @override
  String get challenge => 'チャレンジ';

  @override
  String get challengeAccepted => 'チャレンジが承諾されました';

  @override
  String get challengeCancelled => 'チャレンジがキャンセルされました';

  @override
  String get challengeCaps => 'チャレンジ';

  @override
  String get challengeClosed => 'チャレンジ終了';

  @override
  String get challengeDeclined => 'チャレンジが断られました';

  @override
  String get challengeExpired => 'チャレンジの期限切れ';

  @override
  String get challengeExpiresIn60 => '60秒以内に承諾されないとチャレンジは期限切れになります。';

  @override
  String get challengePrivacy => 'チャレンジのプライバシー';

  @override
  String get challengeRequests => 'チャレンジの申請';

  @override
  String get challengeSentCoins => 'チャレンジ送信済み · 5 コイン';

  @override
  String get challengeSentFree => 'チャレンジ送信済み · 無料対戦';

  @override
  String get challenges => 'チャレンジ';

  @override
  String get championCaps => 'チャンピオン';

  @override
  String get change => '変更';

  @override
  String get chat => 'チャット';

  @override
  String get chatAfterAccept => 'お互いが承諾するとチャットできます。';

  @override
  String get chatAfterAcceptRandom => 'お互いが承諾するとチャットできます。ユーザー名以外は共有されません。';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$nameは友だちからのメッセージのみ受け付けています。';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$nameはメッセージをオフにしています。';
  }

  @override
  String get chatNotConnected => 'チャットが接続されていません';

  @override
  String get chatOn => 'チャットON';

  @override
  String get chatPrivacyNote => '対戦中のチャットに適用されます。変更はすぐに反映され、対戦中も有効です。';

  @override
  String get chatRules => 'チャットのルール';

  @override
  String get chatRulesIntro => 'テキストチャットは自動では始まりません。片方が申し込み、もう片方が承諾します。';

  @override
  String get checkAgainCaps => 'もう一度確認';

  @override
  String get checkEmail => 'メールを確認';

  @override
  String get checkEmailConfirm => 'メールを確認し、確認リンクを開いてください';

  @override
  String get checkForUpdates => 'アップデートを確認';

  @override
  String get checkInbox => '受信トレイを確認';

  @override
  String get checking => '確認中…';

  @override
  String get chooseEntryStake => '参加ベットを選択';

  @override
  String get chooseGameMode => 'ゲームモードを選択';

  @override
  String get chooseNewPassword => '新しいパスワードを設定';

  @override
  String get chooseOpponent => '対戦相手を選ぶ';

  @override
  String get claim => '受け取る';

  @override
  String claimBonusCoins(String n) {
    return 'ボーナス $n コインを受け取る';
  }

  @override
  String get claimLabel => '受け取る';

  @override
  String claimPlusCoins(String n) {
    return '+$n コインを受け取る';
  }

  @override
  String get claimVictory => '勝利を受け取る';

  @override
  String get claimsSync => '受け取りはクラウドアカウントに同期されます';

  @override
  String get classicMode => 'クラシック (3×3)';

  @override
  String get clearAll => 'すべて削除';

  @override
  String get clipboardNoCode => 'クリップボードにルームコードがありません';

  @override
  String get close => '閉じる';

  @override
  String get closeAndLose => '閉じて報酬をあきらめる';

  @override
  String get closeRoom => 'ルームを閉じる';

  @override
  String get closing => '閉じています…';

  @override
  String get cloud => 'クラウド';

  @override
  String cloudSaveFailed(String message) {
    return 'クラウド保存に失敗: $message';
  }

  @override
  String get codeSent => 'コードを送信しました';

  @override
  String get coinPacks => 'コインパック';

  @override
  String coinPacksFrom(String price) {
    return '$priceからのコインパック';
  }

  @override
  String get coins5 => '5 コイン';

  @override
  String coinsAdded(String n) {
    return '+$n コイン追加';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'コイン $delta · 残高 $balance';
  }

  @override
  String get coinsEntryFee => '参加費 5 コイン';

  @override
  String get coinsEntryFeeBody => '無料対戦を使い切った後や、賭けを上げたいときに。';

  @override
  String coinsLabel(String n) {
    return '$n コイン';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n コイン（クラウドに保存）';
  }

  @override
  String get column => '縦';

  @override
  String get comeBackTomorrow => 'また明日';

  @override
  String get completeGoogleReturnApp => 'Googleサインインを完了してアプリに戻ってください';

  @override
  String get completeGoogleSignIn => 'Googleサインインを完了して戻ってください';

  @override
  String get computer => 'コンピューター';

  @override
  String get confirm => '確認';

  @override
  String get confirmJoinCaps => '確認して参加';

  @override
  String confirmLinkSentTo(String target) {
    return '$target に確認リンクを送りました。\nこの端末でリンクを開いてから戻ってください。自動でサインインされます。';
  }

  @override
  String get confirmPassword => 'パスワード（確認）';

  @override
  String get confirmationEmailSent => '確認メールを送信しました。受信トレイを確認してください';

  @override
  String get confirmingVideo => '動画の視聴を確認しています。お待ちください。';

  @override
  String get connectingChat => 'チャットに接続中…';

  @override
  String get connectionUnstable => '接続が不安定です';

  @override
  String get connectionUnstableCaps => '接続が不安定';

  @override
  String get contactAbout => 'お問い合わせと概要';

  @override
  String get contactUsCaps => 'お問い合わせ';

  @override
  String get continueLabel => '続ける';

  @override
  String get continuePlaying => 'プレイを続ける';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String copiedValue(String label, String value) {
    return '$labelをコピーしました: $value';
  }

  @override
  String get couldNotAddCoins => 'コインを追加できませんでした';

  @override
  String get couldNotApplyReferral => '紹介コードを適用できませんでした';

  @override
  String couldNotCheck(String error) {
    return '確認できませんでした: $error';
  }

  @override
  String get couldNotJoinRoom => 'ルームに参加できませんでした';

  @override
  String get couldNotLoadPrivacy => 'プライバシー設定を読み込めません';

  @override
  String get couldNotLoadProfile => 'プロフィールを読み込めませんでした。もう一度お試しください。';

  @override
  String get couldNotOpenGoogle => 'Googleサインインを開けませんでした';

  @override
  String get couldNotSavePrivacy => 'プライバシー設定を保存できません';

  @override
  String get couldNotStopChat => 'チャットを停止できませんでした';

  @override
  String get couldNotSubmitAppeal => '申し立てを送信できませんでした';

  @override
  String get couldNotVerify => '確認できませんでした';

  @override
  String get couldNotVerifyAccount => 'アカウントの状態を確認できませんでした。もう一度お試しください。';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get createPrivateRoom => 'プライベートルームを作成';

  @override
  String get customize => 'カスタマイズ';

  @override
  String get daily => 'デイリー';

  @override
  String get dailyChest => 'デイリー宝箱';

  @override
  String get dailyLimit => '1日の上限に達しました';

  @override
  String get date => '日付';

  @override
  String dayN(String n) {
    return '$n日目';
  }

  @override
  String dayStreak(String n) {
    return '$n日連続';
  }

  @override
  String get days30 => '30日間';

  @override
  String get days7 => '7日間';

  @override
  String get debitFailed => 'コインを差し引けませんでした';

  @override
  String get declineCaps => '断る';

  @override
  String get defeat => '敗北';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get deleteAccountBody => 'コイン、スコア、履歴が完全に削除されます。';

  @override
  String get deleteAccountQuestion => 'アカウントを削除しますか？';

  @override
  String get descriptionMin10 => '説明は10文字以上にしてください';

  @override
  String get diagonal => '斜め';

  @override
  String get difficultyEasy => 'かんたん';

  @override
  String get difficultyHard => 'むずかしい';

  @override
  String get difficultyMedium => 'ふつう';

  @override
  String get doll => 'ドール';

  @override
  String get done => '達成';

  @override
  String get downloadAndInstall => 'ダウンロードしてインストール';

  @override
  String get downloading => 'ダウンロード中…';

  @override
  String downloadingPercent(String percent) {
    return 'ダウンロード中 $percent%';
  }

  @override
  String get draw => '引き分け';

  @override
  String get drawBadge => '引き分け';

  @override
  String get draws => '引き分け';

  @override
  String get duration => '期間';

  @override
  String get earned => '獲得';

  @override
  String get earnedThisWeek => '今週の獲得（入手方法別）';

  @override
  String get editProfileCaps => 'プロフィール編集';

  @override
  String get eliminatedCaps => '敗退';

  @override
  String get email => 'メール';

  @override
  String get emailNotConfirmed => 'メール未確認';

  @override
  String emailNotConfirmedBody(String email) {
    return '登録は完了しましたが、メールがまだ確認されていません。\n\n受信トレイか迷惑メールの確認リンクを開いてから、もう一度サインインしてください。\n\n$email';
  }

  @override
  String get emailSentAgain => 'メールを再送しました。受信トレイを確認してください';

  @override
  String get endsIn => '終了まで';

  @override
  String get enterCode => 'コードを入力';

  @override
  String get enterCodeFromEmail => 'メールに届いたコードを入力';

  @override
  String get enterCodeInstead => '代わりにコードを入力';

  @override
  String get enterEmailPassword => 'メールとパスワードを入力';

  @override
  String get enterFullCode => 'ルームコードをすべて入力してください';

  @override
  String get enterReferralOrSkip => '紹介コードを入力するか、今はスキップしてください';

  @override
  String get enterResetCode => 'リセットコードを入力';

  @override
  String get enterValidMobile => '有効な携帯番号を入力してください';

  @override
  String get enterValidReferral => '有効な紹介コードを入力してください';

  @override
  String get enterYourEmail => 'メールアドレスを入力';

  @override
  String get entry => '参加費';

  @override
  String get entryFee => '参加費';

  @override
  String get equip => '装備';

  @override
  String get equipped => '装備中';

  @override
  String get events => 'イベント';

  @override
  String get everyone => '全員';

  @override
  String get expertMode => 'エキスパート (5×5)';

  @override
  String get expiredMoveToHistory => '期限切れのチャレンジは履歴に移ります。';

  @override
  String get failed => '失敗';

  @override
  String get fillAllFields => 'すべて入力してください';

  @override
  String get finalRound => '決勝';

  @override
  String get findAMatch => '対戦を探す';

  @override
  String get findOpponent => '対戦相手を探す';

  @override
  String get findPrivateJoin => '検索 · プライベートルーム · 参加コード';

  @override
  String get findingOpponent => '対戦相手を探しています';

  @override
  String get findingPlayer => 'プレイヤーを探しています';

  @override
  String get firstMatchSet => 'ラウンド開始時に最初の対戦が決まります。';

  @override
  String get fiveOfFiveWatched => '5/5本視聴済み';

  @override
  String get flash => 'フラッシュ';

  @override
  String get flashUnavailable => 'フラッシュは使用できません';

  @override
  String get forgotPassword => 'パスワードを忘れた？';

  @override
  String get forgotPasswordTitle => 'パスワードを忘れた';

  @override
  String get free => '無料';

  @override
  String get freeCoins => '無料コイン';

  @override
  String get freeMatch => '無料対戦';

  @override
  String get freeMatchesPerDay => '1日3回まで無料';

  @override
  String get freeVideosToday => '今日の無料動画';

  @override
  String freeVideosUsed(String used) {
    return '今日の無料動画 $used/5 本使用済み';
  }

  @override
  String get friendChallenge => '友だちチャレンジ';

  @override
  String get friendRequestExists => '友だち申請はすでに送信済みです';

  @override
  String friendRequestSent(String name) {
    return '$nameに友だち申請を送りました';
  }

  @override
  String get friendRequestSentShort => '友だち申請を送りました';

  @override
  String get friendsCaps => '友だち';

  @override
  String get friendsLabel => '友だち';

  @override
  String get friendsOnly => '友だちのみ';

  @override
  String get fromPhoto => '写真から';

  @override
  String gameComingSoon(String game) {
    return '$game：近日公開';
  }

  @override
  String get gameOver => 'ゲーム終了';

  @override
  String get gamePaused => '一時停止中';

  @override
  String get getStarted => 'はじめる';

  @override
  String get gettingVideo => '動画を準備中…';

  @override
  String get goToMatchCaps => '対戦へ';

  @override
  String get gotIt => 'わかった';

  @override
  String get graceWindowEnded => '30秒の猶予が終わりました。勝利を受け取れます。';

  @override
  String greatRun(String name) {
    return '$nameでの健闘';
  }

  @override
  String get guard => 'ガード';

  @override
  String get guest => 'ゲスト';

  @override
  String get history => '履歴';

  @override
  String get historyNeverPublic => '対戦履歴とアクティビティが公開プロフィールに表示されることはありません。';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches試合 · $wins勝 · $losses敗 · $draws分';
  }

  @override
  String get howItWorks => 'ルール';

  @override
  String get howToPlay => '遊び方';

  @override
  String get howToPlayRules =>
      '相手より先に自分のマークを縦・横・斜めのいずれかに3つ並べましょう。大きい盤では4つ必要です。';

  @override
  String howToPlayStep(String n) {
    return '遊び方 · $n/3';
  }

  @override
  String get imReadyCaps => '準備OK';

  @override
  String get imageTooBig => '画像は2MB未満にしてください';

  @override
  String get install => 'インストール';

  @override
  String get installUpdate => 'アップデートをインストール';

  @override
  String get installed => 'インストール済み';

  @override
  String get internetRequired => 'インターネット接続が必要です。オフラインでもThe Dollとは対戦できます。';

  @override
  String get introBody1 => '3×3、4×4、5×5の盤でAIに勝とう。';

  @override
  String get introBody2 => '本物のプレイヤーとランダム対戦。コインを賭けてコインを稼ごう。';

  @override
  String get introBody3 => 'デイリー報酬、ミッション、大会でどんどん上へ。';

  @override
  String get introTitle1 => 'ドールを出し抜け';

  @override
  String get introTitle2 => '世界と対決';

  @override
  String get introTitle3 => 'ランキングを駆け上がれ';

  @override
  String get invalidRoomQr => '無効なルームQR';

  @override
  String get inviteImage => '招待画像';

  @override
  String get inviteImageBody => 'コード、QR、リンクを1枚の画像に。WhatsAppなどで送れます。';

  @override
  String isThinking(String name) {
    return '$nameが考え中';
  }

  @override
  String get joinCaps => '参加';

  @override
  String joinForCoins(String n) {
    return '$nコインで参加';
  }

  @override
  String get joinRoomCaps => 'ルームに参加';

  @override
  String get joinTheGame => 'ゲームに参加';

  @override
  String joinTournamentQuestion(String name) {
    return '$nameに参加しますか？';
  }

  @override
  String get joinWithCode => 'コードで参加';

  @override
  String get joined => '参加済み';

  @override
  String get joiningCaps => '参加中…';

  @override
  String get joiningQueue => '待機列に参加中…';

  @override
  String get joiningRoom => 'ルームに参加中…';

  @override
  String get keepWatchingCaps => '見続ける';

  @override
  String get language => '言語';

  @override
  String get languageUpdated => '言語を更新しました';

  @override
  String get last20Sent => '直近20件のメッセージが報告と一緒に送られます。';

  @override
  String get last7Games => '直近7試合';

  @override
  String lastUpdated(String date) {
    return '最終更新 $date';
  }

  @override
  String get later => 'あとで';

  @override
  String get latestVersion => '最新バージョンを使用しています。';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get leaderboardUpdated => 'ランキングを更新しました';

  @override
  String get leave => '抜ける';

  @override
  String get leaveForfeitBody => '今抜けると棄権扱いになり、相手の勝ちになります。';

  @override
  String get leaveGame => 'ゲームを抜ける';

  @override
  String get leaveMatchQuestion => '対戦を抜けますか？';

  @override
  String get leaveVideoQuestion => '動画を閉じますか？';

  @override
  String get letsPlay => '遊ぼう';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get live => 'ライブ';

  @override
  String get liveEventCaps => '開催中のイベント';

  @override
  String get loading => '読み込み中…';

  @override
  String get local => 'ローカル';

  @override
  String get locked => '未解除';

  @override
  String get logOut => 'ログアウト';

  @override
  String get loginMethod => 'ログイン方法';

  @override
  String loseCoinsIfClose(String seconds) {
    return '今閉じると10コインはもらえません。残り$seconds秒です。';
  }

  @override
  String get losses => '敗北';

  @override
  String get markAllRead => 'すべて既読にする';

  @override
  String get marks => 'マーク';

  @override
  String get match => '対戦';

  @override
  String get matchAbandonedCaps => '対戦放棄';

  @override
  String matchDuration(String duration) {
    return '対戦時間 $duration';
  }

  @override
  String get matchHistory => '対戦履歴';

  @override
  String get matchHistoryCaps => '対戦履歴';

  @override
  String get matchInvitations => '対戦の招待';

  @override
  String get matchLobby => '対戦ロビー';

  @override
  String get matchResult => '対戦結果';

  @override
  String get matchResults => '対戦結果';

  @override
  String get matchStakes => '対戦のベット';

  @override
  String get matchStartsIn => '対戦開始まで';

  @override
  String get matches => '対戦';

  @override
  String get matchmakingError => 'マッチングエラー';

  @override
  String get matchmakingFailed => 'マッチングに失敗しました';

  @override
  String get matchmakingStopped => 'マッチングを停止しました';

  @override
  String memberSince(String date) {
    return '$dateから参加';
  }

  @override
  String get messageEmpty => 'メッセージを入力してください';

  @override
  String get messagesStayForMatch => 'メッセージはこの対戦中だけ残ります';

  @override
  String minusCoins(String n) {
    return '-$n コイン';
  }

  @override
  String get misPlay30 => '30試合プレイ';

  @override
  String get misPlay5 => '5試合プレイ';

  @override
  String get misQuick => 'ランダムマッチを1回';

  @override
  String get misTourney => '大会に参加';

  @override
  String get misWin15 => '15回勝つ';

  @override
  String get misWin3 => '3回勝つ';

  @override
  String get misWin4x4 => '4×4盤で勝つ';

  @override
  String get missResets => '1日休むとリセットされます。明日また次の報酬を受け取りに来てください。';

  @override
  String get missingChallengeData => 'チャレンジ情報がありません';

  @override
  String get missingEmail => 'メールがありません。戻ってやり直してください';

  @override
  String get missions => 'ミッション';

  @override
  String missionsDone(String done, String total) {
    return 'ミッション $done/$total 達成';
  }

  @override
  String get mobileNotSupported => 'お住まいの地域では携帯番号はまだ使えません';

  @override
  String get mobileOptional => '携帯番号（任意）';

  @override
  String mode(String n) {
    return 'モード $n';
  }

  @override
  String get more => 'その他';

  @override
  String get moreGames => 'ほかのゲーム';

  @override
  String get music => '音楽';

  @override
  String nOf5(String n) {
    return '$n/5';
  }

  @override
  String get navPlay => 'プレイ';

  @override
  String get newCodeSent => '新しいコードを送信しました。受信トレイを確認してください';

  @override
  String get newHere => 'はじめて？';

  @override
  String get newMatchChallengeCaps => '新しい対戦チャレンジ！';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get newPasswordBody => '新しいパスワードを入力してください。保存後もサインインしたままです。';

  @override
  String get newVersion => '新しいバージョン';

  @override
  String get newVersionReady => 'DROTIXの新しいバージョンが利用できます。';

  @override
  String get newVideosUnlockIn => '次の無料動画まで';

  @override
  String get next => '次へ';

  @override
  String get nextCaps => '次へ';

  @override
  String get nextRound => '次のラウンド';

  @override
  String get no => 'いいえ';

  @override
  String get noChallenge => 'チャレンジはありません';

  @override
  String get noChallengesHere => 'ここにチャレンジはありません。';

  @override
  String get noCloudMatches =>
      'クラウドの対戦はまだありません。サインインしてThe Dollと対戦するとここに表示されます。';

  @override
  String get noFriendsYet => 'まだ友だちがいません。検索して追加しましょう。';

  @override
  String get noHistory => '履歴がありません';

  @override
  String get noMatchesYet => 'まだ対戦がありません';

  @override
  String get noMessagesYet => 'まだメッセージはありません。\nクイック返信も使えます。';

  @override
  String get noNotificationsYet => '通知はまだありません';

  @override
  String get noOpponentFound => '対戦相手が見つかりませんでした。もう一度お試しください';

  @override
  String get noPendingRequests => '保留中の申請はありません。';

  @override
  String get noPlayersFound => 'プレイヤーが見つかりません';

  @override
  String get noQrInPhoto => '写真にQRが見つかりません';

  @override
  String get noRankedPlayers => 'まだランキングにプレイヤーがいません。サインインして対戦すると参加できます。';

  @override
  String get noTransactions => 'まだ取引はありません。';

  @override
  String get noVideoFound => '動画が見つかりませんでした。無料回数は消費されていません。1分後にもう一度お試しください。';

  @override
  String get noVideoNow => '現在視聴できる動画はありません。後でもう一度お試しください。';

  @override
  String get noVideoRightNow => '今は動画がありません';

  @override
  String get nobody => '誰も受け付けない';

  @override
  String get nobodyBlinked => 'どちらも譲らず。';

  @override
  String nobodyBlinkedVs(String name) {
    return 'どちらも譲らず。$nameに止められました。';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$nameは現在チャレンジを受け付けていません。';
  }

  @override
  String get notEnoughCoins => 'コインが足りません';

  @override
  String get notEnoughCoinsAnother => '次のベットにはコインが足りません。';

  @override
  String get notEnoughCoinsStake => 'このベットにはコインが足りません。';

  @override
  String get notNow => '今はしない';

  @override
  String get notSignedIn => 'サインインしていません';

  @override
  String get notSignedInYet => 'まだサインインしていません。先にメールのリンクを開いてください';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name がチャレンジを承諾しました。対戦開始！';
  }

  @override
  String get notifChallengeAcceptedTitle => 'チャレンジが承諾されました';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name は今対戦中です。後でもう一度お試しください。';
  }

  @override
  String get notifChallengeBusyTitle => 'プレイヤーは対戦中です';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name がチャレンジをキャンセルしました';
  }

  @override
  String get notifChallengeCancelledTitle => 'チャレンジがキャンセルされました';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name がチャレンジを辞退しました';
  }

  @override
  String get notifChallengeDeclinedTitle => 'チャレンジが辞退されました';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name は時間内に応答しませんでした';
  }

  @override
  String get notifChallengeExpiredTitle => 'チャレンジの期限切れ';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name から対戦のチャレンジが届きました';
  }

  @override
  String get notifChallengeRequestTitle => '新しいチャレンジ';

  @override
  String get notifChannelDesc => 'チャレンジ、対戦、コインの更新';

  @override
  String get notifChannelName => 'ゲーム通知';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount コインが追加されました。残高：$balance';
  }

  @override
  String get notifCoinsCreditTitle => 'コインが追加されました';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount コインが差し引かれました。残高：$balance';
  }

  @override
  String get notifCoinsDebitTitle => 'コインが差し引かれました';

  @override
  String get notifCoinsPurchaseTitle => '購入が完了しました';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return '$amount コインを獲得しました。残高：$balance';
  }

  @override
  String get notifCoinsRewardTitle => '報酬を受け取りました';

  @override
  String get notifEmptyHint => 'チャレンジ、対戦結果、コインの更新がここに表示されます。';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name がフレンド申請を承認しました';
  }

  @override
  String get notifFriendAcceptedTitle => '新しいフレンド';

  @override
  String notifFriendRequestBody(String name) {
    return '$name からフレンド申請が届きました';
  }

  @override
  String get notifFriendRequestTitle => 'フレンド申請';

  @override
  String get notifGeneric => '新しい通知';

  @override
  String notifMatchBody(String name) {
    return '$name との対戦が終了しました';
  }

  @override
  String get notifMatchDrawTitle => '引き分け';

  @override
  String get notifMatchLostTitle => '敗北しました';

  @override
  String get notifMatchWonTitle => '勝利しました！';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name がプライベートルームに参加しました';
  }

  @override
  String get notifRoomJoinedTitle => 'プレイヤーが参加しました';

  @override
  String get notifications => '通知';

  @override
  String nowFriends(String name) {
    return '$nameと友だちになりました';
  }

  @override
  String get nowFriendsShort => '友だちになりました';

  @override
  String get officialWebsite => '公式サイト';

  @override
  String get offlineAi => 'オフラインAI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'オフライン · AI相手のみ · $size · ベット $stake';
  }

  @override
  String get offlineBanner => 'オフライン · The Dollとの対戦は利用できます';

  @override
  String get offlineBody => 'オンライン対戦と大会には接続が必要です。The Dollとの対戦はできます。';

  @override
  String get offlineProfilesNote => 'これはオフラインのAIプロフィールで、実際のプレイヤーではありません。';

  @override
  String get offlineSmart => 'オフライン・賢い相手';

  @override
  String get ok => 'OK';

  @override
  String get oneLastStepCaps => 'あと1ステップ';

  @override
  String get online => 'オンライン';

  @override
  String get onlineMatch => 'オンライン対戦';

  @override
  String get onlineMultiplayer => 'オンライン対戦';

  @override
  String get onlineOfflineAi => 'オンライン対戦 · オフラインAI';

  @override
  String onlineStake(String stake) {
    return 'オンライン · ベット $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$nameは友だちからのチャレンジのみ受け付けています。先に友だち追加してください。';
  }

  @override
  String get open => '開く';

  @override
  String get openedTheLink => 'リンクを開きました';

  @override
  String get openingInstaller => 'インストーラーを開いています…';

  @override
  String get opponent => '相手';

  @override
  String get opponentAdvances => '時間内に参加しないと相手が勝ち上がります。';

  @override
  String get opponentDisconnected => '相手の接続が切れました';

  @override
  String get opponentWins => '相手の勝ち';

  @override
  String opponentsMove(String name) {
    return '$nameの番';
  }

  @override
  String get or => 'または';

  @override
  String get orEnterCodeCaps => 'またはコードを入力';

  @override
  String get otherEvents => 'その他のイベント';

  @override
  String get owned => '所持';

  @override
  String get passAndPlay => 'パス＆プレイ';

  @override
  String get password => 'パスワード';

  @override
  String get passwordMin6 => 'パスワードは6文字以上にしてください';

  @override
  String get passwordUpdated => 'パスワードを更新しました';

  @override
  String get passwordsNoMatch => 'パスワードが一致しません';

  @override
  String get pasteCode => 'コードを貼り付け';

  @override
  String get pause => '一時停止';

  @override
  String get paused => '一時停止';

  @override
  String get perMove20s => '1手20秒';

  @override
  String get photoUpdated => '写真を更新しました';

  @override
  String get pickClosestReason => '何が起きていますか？ 最も近い理由を選んでください。';

  @override
  String get pickYourGame => 'ゲームを選ぶ';

  @override
  String get playAgain => 'もう一度遊ぶ';

  @override
  String get playAsGuest => 'ゲストでプレイ';

  @override
  String get playCaps => 'プレイ';

  @override
  String get playDollOffline => 'オフラインでThe Dollと対戦';

  @override
  String get playToBuildForm => '対戦して調子を記録しましょう。';

  @override
  String get playVsDoll => 'The Dollと対戦';

  @override
  String playVsName(String name) {
    return '$nameと対戦';
  }

  @override
  String get played => 'プレイ数';

  @override
  String get player => 'プレイヤー';

  @override
  String get player1 => 'プレイヤー1';

  @override
  String get player1Move => 'プレイヤー1の番';

  @override
  String get player1Wins => 'プレイヤー1の勝ち！';

  @override
  String get player2 => 'プレイヤー2';

  @override
  String get player2Move => 'プレイヤー2の番';

  @override
  String get player2Wins => 'プレイヤー2の勝ち！';

  @override
  String playerAdded(String name) {
    return '$nameを追加しました';
  }

  @override
  String get playerBlocked => 'ブロックしました';

  @override
  String playerIdLabel(String id) {
    return 'プレイヤー $id';
  }

  @override
  String get playerUnblocked => 'ブロックを解除しました';

  @override
  String get players => 'プレイヤー';

  @override
  String get playersLeft => '残りプレイヤー';

  @override
  String get pleaseWait => 'お待ちください…';

  @override
  String plusCoins(String n) {
    return '+$n コイン';
  }

  @override
  String get podium => '表彰台';

  @override
  String get pointAtHostQr => 'ホストのQRに向けてください。ロビーと同じコードです。';

  @override
  String get pointCameraAtQr => 'カメラをルームのQRコードに向けてください';

  @override
  String pointsWins(String points, String wins) {
    return '$points pt · $wins 勝';
  }

  @override
  String get popular => '人気';

  @override
  String get previousMatchExpired => '前の対戦は期限切れです。少し待ってからもう一度お試しください。';

  @override
  String get privacy => 'プライバシー';

  @override
  String privacyBody(String email) {
    return 'アプリの動作に必要なゲームデータ（コイン、外観アイテム、対戦履歴、設定）のみを収集します。ゲストプレイにアカウントは不要です。\n\nサインインした場合、情報は進行状況の保存と復元にのみ使います。個人データを販売することはありません。設定 → アカウントを削除 からいつでもデータを削除できます。\n\nお問い合わせ: $email';
  }

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privateOnlyYou => '非公開。あなただけが見られます。';

  @override
  String get privateRoomByUsername => 'プライベートルーム（ユーザー名）';

  @override
  String get privateRoomCaps => 'プライベートルーム';

  @override
  String get prizeAdded => '賞金を残高に追加しました';

  @override
  String get prizePool => '賞金総額';

  @override
  String get profile => 'プロフィール';

  @override
  String get profileNotFound => 'プロフィールが見つかりません';

  @override
  String get profilePrivacyNote =>
      '対戦履歴とアクティビティは非公開です。ここでの報告はプロフィールの不正用です。対戦中のチャットはチャットの報告ボタンを使ってください。';

  @override
  String get profileUpdated => 'プロフィールを更新しました';

  @override
  String progressOf(String done, String total) {
    return '$done/$total';
  }

  @override
  String get publicStatsNote => '公開されるのはランク・スコア・勝利数のみです。対戦履歴とアクティビティは非公開です。';

  @override
  String get purchaseFailed => '購入に失敗しました';

  @override
  String get purchases => '購入';

  @override
  String get purchasesComingSoon => 'コイン購入は近日対応予定です。今は「無料コイン」で動画を見てコインを獲得できます。';

  @override
  String get quarter => '準々決勝';

  @override
  String get quarterFinal => '準々決勝';

  @override
  String get quickCloseOne => '惜しい！';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'ナイス！';

  @override
  String quickMatchVsAi(String time) {
    return 'AIとクイック対戦 · $time';
  }

  @override
  String get quitMatch => '対戦をやめる';

  @override
  String get randomMatch => 'ランダムマッチ';

  @override
  String get rank => 'ランク';

  @override
  String rankScore(String rank, String score) {
    return 'ランク #$rank · スコア $score';
  }

  @override
  String get rankScoreUnknown => 'ランク – · スコア –';

  @override
  String get ranks => 'ランキング';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get ratingsSoon => '評価機能は近日公開';

  @override
  String get readOnly => '読み取り専用';

  @override
  String get readyCaps => '準備完了';

  @override
  String get reasonHarassment => '嫌がらせ・いじめ';

  @override
  String get reasonInappropriate => '性的・不適切な内容';

  @override
  String get reasonOffensive => 'ヘイト・暴言';

  @override
  String get reasonOther => 'その他';

  @override
  String get reasonSpam => 'スパム・詐欺';

  @override
  String get reasonThreatening => '脅迫・暴力';

  @override
  String get received => '受信';

  @override
  String get reconnecting => '再接続中…';

  @override
  String reference(String id) {
    return '参照番号: $id';
  }

  @override
  String get referralCode => '紹介コード';

  @override
  String get referralHint => '紹介コード（任意）';

  @override
  String get referralOnce => '紹介コードは登録直後に1回だけ使えます。';

  @override
  String get referralPrompt => '友だちから紹介コードをもらった？今入力すると50コインもらえます。';

  @override
  String get referralWorked => '紹介コードが使えました。コインはウォレットに入っていてすぐ使えます。';

  @override
  String get refresh => '更新';

  @override
  String get refreshStatus => '状況を更新';

  @override
  String get region => '地域';

  @override
  String get regionIndiaNote => 'SIM/端末から自動で判定しました。インドではインドの言語と₹の価格を表示します。';

  @override
  String regionIntlNote(String currency) {
    return 'SIM/端末から自動で判定しました。国際言語、価格は$currencyで表示します。';
  }

  @override
  String get register => '登録';

  @override
  String get released => 'リリース日';

  @override
  String get rematch => '再戦';

  @override
  String get rematchQuestion => '再戦する？';

  @override
  String get remindMe => '対戦前に通知する';

  @override
  String get reportButtonCaps => '報告ボタン';

  @override
  String get reportButtonHelp =>
      'ライブチャットの右上、「チャットを停止」の隣にあります。チャット中は常に表示されます。\nタップ → 理由を選択 → 詳細とスクショを追加 → 送信。';

  @override
  String get reportCaps => '報告';

  @override
  String get reportFailed => '報告に失敗しました';

  @override
  String reportName(String name) {
    return '$nameを報告';
  }

  @override
  String get reportOrBlock => '報告・ブロック';

  @override
  String get reportOrBlockPlayer => 'このプレイヤーを報告・ブロック';

  @override
  String get reportPlayer => 'プレイヤーを報告';

  @override
  String get requestSentCaps => '申請済み';

  @override
  String requestSentTo(String name) {
    return '$nameに申請を送りました';
  }

  @override
  String get requests => '申請';

  @override
  String requestsCount(String n) {
    return '申請 · $n';
  }

  @override
  String get requestsExpire7d => '申請は7日以内に応答がないと期限切れになります。';

  @override
  String get resendCode => 'コードを再送';

  @override
  String get resendEmail => 'メールを再送';

  @override
  String get resetCode => 'リセットコード';

  @override
  String resetCodeSentTo(String target) {
    return '$target にリセットコードを送りました。\n下に入力してください。メールのリンクを開く必要はありません。';
  }

  @override
  String get resetPassword => 'パスワードをリセット';

  @override
  String get resetPasswordBody =>
      'メールアドレスを入力するとリセットコードを送ります。アプリで入力してください。リンクを開く必要はありません。';

  @override
  String get restart => 'やり直す';

  @override
  String get result => '結果';

  @override
  String get resume => '再開';

  @override
  String get returnToMainMenu => 'メインメニューに戻る';

  @override
  String get rewardEarnedCaps => '報酬獲得';

  @override
  String get rewardFlowOverview => '報酬の流れ';

  @override
  String rewardIn(String time) {
    return '報酬まで$time';
  }

  @override
  String get rivalO => '相手：O';

  @override
  String get roomCancelled => 'ルームはキャンセルされました';

  @override
  String roomClosesIn(String time) {
    return '誰も参加しないと$time後にルームが閉じます。';
  }

  @override
  String get roomClosesSoon => '誰も参加しないとまもなくルームが閉じます。';

  @override
  String get roomClosing => 'ルームを閉じています…';

  @override
  String get roomCodeCaps => 'ルームコード';

  @override
  String get roomCodeCopied => 'ルームコードをコピーしました';

  @override
  String get roomExpired => 'ルームの期限切れ';

  @override
  String get roomOpenCaps => 'ルーム公開中';

  @override
  String get roundOf16 => 'ベスト16';

  @override
  String get roundOf16Caps => 'ベスト16';

  @override
  String roundOf16Vs(String name) {
    return 'ベスト16 · vs $name';
  }

  @override
  String get roundsWon => '勝ったラウンド';

  @override
  String get row => '横';

  @override
  String get ruleEmoji => '• 絵文字リアクションは申請なしで使え、ミュートもできます。';

  @override
  String get ruleEnds => '• 対戦が終わるとチャットも自動で終了します。';

  @override
  String get ruleStop => '• どちらのプレイヤーもいつでもチャットを止められます。';

  @override
  String get ruleVanish => '• メッセージは数秒で消え、保存されません。';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get savePassword => 'パスワードを保存';

  @override
  String get saving => '保存中…';

  @override
  String get savingToCloud => 'クラウドに保存中…';

  @override
  String get scanOrShare => 'スキャンして参加、またはリンクを共有';

  @override
  String get scanQr => 'QRをスキャン';

  @override
  String get score => 'スコア';

  @override
  String get scorePlus10 => 'スコア +10';

  @override
  String get screenshotTooBig => 'スクリーンショットは2MB未満にしてください';

  @override
  String get screenshotsOptionalCaps => 'スクリーンショット（任意）';

  @override
  String get searchPlayersHint => 'ユーザー名またはプレイヤーIDで検索';

  @override
  String get searchResults => '検索結果';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'オンライン · $size · ベット $stake · $time';
  }

  @override
  String get seatWaiting => 'プレイヤー、席が待っています。';

  @override
  String secondsLeft(String seconds) {
    return '残り$seconds秒';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return '応答まで残り$seconds秒';
  }

  @override
  String get selectDifficulty => '難易度を選択';

  @override
  String get selectOpponent => '対戦相手を選択';

  @override
  String get selectReportReason => '報告の理由を選んでください';

  @override
  String get semi => '準決勝';

  @override
  String get send => '送信';

  @override
  String get sendChallenge => 'チャレンジを送る';

  @override
  String get sendResetCode => 'リセットコードを送信';

  @override
  String get sending => '送信中…';

  @override
  String get sendingMove => '手を送信中…';

  @override
  String get sent => '送信済み';

  @override
  String serverTournamentsDemo(String error) {
    return 'サーバーの大会を利用できないためデモを表示しています。\n$error';
  }

  @override
  String get sessionExpiredReset => 'セッションが切れました。新しいコードをリクエストしてください';

  @override
  String get settings => '設定';

  @override
  String get shareComingSoon => '共有は近日対応';

  @override
  String get shareInviteCaps => '招待を共有';

  @override
  String get shareOnWhatsApp => 'WhatsAppで共有';

  @override
  String get shareProfile => 'プロフィールを共有';

  @override
  String shareWin(String url) {
    return 'DROTIXで勝ったよ！ 私に勝てる？ 今すぐプレイ: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'DROTIXで$nameに勝ったよ！ 私に勝てる？ 今すぐプレイ: $url';
  }

  @override
  String get shop => 'ショップ';

  @override
  String get showHidePassword => 'パスワードの表示/非表示';

  @override
  String get signIn => 'サインイン';

  @override
  String get signInChangePhoto => '写真を変更するにはサインインしてください';

  @override
  String get signInFindFriends => '友だちを探すにはサインインしてください';

  @override
  String get signInMatchmaking => 'オンラインマッチにはサインインが必要です';

  @override
  String get signInNotifications => '通知を見るにはサインインしてください';

  @override
  String get signInOnline => 'オンライン対戦にはサインインしてください';

  @override
  String get signInRandomMatch => 'サインインすると本物のプレイヤーとランダムマッチで遊べます';

  @override
  String get signInRequired => 'サインインが必要です';

  @override
  String get signInSearchPlayers => 'サインインするとプレイヤー検索や友だちのクラウド同期ができます。';

  @override
  String get signInToAddFriends => '友だちを追加するにはサインインしてください';

  @override
  String get signInToChallenge => 'このプレイヤーにチャレンジするにはサインインしてください';

  @override
  String get signInWalletHistory => 'ウォレット履歴を見るにはサインインしてください。';

  @override
  String get signInWithEmail => 'メールでサインイン';

  @override
  String get signOut => 'サインアウト';

  @override
  String get signUp => '新規登録';

  @override
  String get skip => 'スキップ';

  @override
  String get skipForNow => '今はスキップ';

  @override
  String get somethingWentWrong => '問題が発生しました';

  @override
  String somethingWentWrongDetail(String error) {
    return '問題が発生しました: $error';
  }

  @override
  String get soundDisabled => 'サウンドOFF';

  @override
  String get soundEffects => '効果音';

  @override
  String get soundEnabled => 'サウンドON';

  @override
  String get spent => '使用';

  @override
  String get sponsored => 'スポンサー';

  @override
  String stakeDot(String n) {
    return 'ベット · $n';
  }

  @override
  String get stakeReturned => 'ベットを返却しました';

  @override
  String stakeRoom(String stake, String room) {
    return 'ベット $stake · $room…';
  }

  @override
  String get start => 'スタート';

  @override
  String get startPlayingCaps => 'プレイ開始';

  @override
  String get starterPack => 'スターターパック';

  @override
  String get starting => '開始中…';

  @override
  String get startsInCaps => '開始まで';

  @override
  String get stats => '統計';

  @override
  String statusLabel(String status) {
    return '状態: $status';
  }

  @override
  String get stayInApp => 'アプリを開いたままにしてください。対戦の準備ができたらお知らせします。';

  @override
  String get stillOffline => 'まだオフラインです。接続を確認してもう一度お試しください。';

  @override
  String get stopChat => 'チャットを停止';

  @override
  String get submitAppeal => '異議を申し立てる';

  @override
  String get submitReportCaps => '報告を送信';

  @override
  String submittedAt(String date) {
    return '送信日時: $date';
  }

  @override
  String get submitting => '送信中…';

  @override
  String get submittingCaps => '送信中…';

  @override
  String get supportEmail => 'サポートメール';

  @override
  String suspendedAt(String date) {
    return '停止日時: $date';
  }

  @override
  String get suspendedByModerator => '報告を審査した結果、モデレーターがこのアカウントを停止しました。';

  @override
  String get suspendedRules => '停止中は対戦、ルーム参加、チャットができません。審査のために異議申し立てを1回行えます。';

  @override
  String get t20Seconds => '1手20秒';

  @override
  String get tDrawReplays => '引き分けはやり直し';

  @override
  String get tSingleElim => 'シングルエリミネーション：1回負けたら敗退';

  @override
  String get tSingleElimFee => 'シングルエリミネーション。1ラウンド負けると敗退し、参加費は返金されません。';

  @override
  String get tagline => 'いちばん危険な小さなゲーム';

  @override
  String get takeTurnsBody => 'あなたと相手が1手ずつマークを置きます。空いているマスをタップして置きましょう。';

  @override
  String get takeTurnsCaps => '交互に置く';

  @override
  String get takesFewSeconds => '通常は数秒で完了します。';

  @override
  String get tapEmptySquare => '空いているマスをタップ';

  @override
  String get tbd => '未定';

  @override
  String get tellUsMin10 => '何があったか教えてください（10文字以上）';

  @override
  String get termsAccountBody => 'サインイン情報は安全に管理してください。アカウントでの行動はご自身の責任です。';

  @override
  String get termsAccountTitle => '2. アカウント';

  @override
  String get termsChangesBody => '本規約は変更されることがあります。引き続き利用すると変更に同意したものとみなします。';

  @override
  String get termsChangesTitle => '5. 変更';

  @override
  String get termsCoinsBody => 'コインは換金価値のない仮想アイテムで、お金と交換できません。';

  @override
  String get termsCoinsTitle => '3. 仮想コイン';

  @override
  String get termsFairBody => '不正行為・暴言・嫌がらせは禁止です。ルール違反のアカウントは停止することがあります。';

  @override
  String get termsFairTitle => '4. フェアプレーとチャット';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsUsingBody => '本規約を守り、フェアにプレイしてください。';

  @override
  String get termsUsingTitle => '1. DROTIXの利用';

  @override
  String get theirTurnCaps => '相手の番';

  @override
  String get threeInRowBody => '相手より先に、自分のマークを横・縦・斜めに3つ並べましょう。';

  @override
  String get threeInRowCaps => '3つ並べる';

  @override
  String timeDaysAgo(String n) {
    return '$n日前';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n時間前';
  }

  @override
  String get timeJustNow => 'たった今';

  @override
  String timeMinutesAgo(String n) {
    return '$n分前';
  }

  @override
  String get timeSkipped => '時間切れになると手番はスキップされます。';

  @override
  String timesUp(String who) {
    return '時間切れ · $who';
  }

  @override
  String get today => '今日';

  @override
  String get todayCaps => '今日';

  @override
  String get top16 => 'トップ16';

  @override
  String get totalCoinsCaps => 'コイン合計';

  @override
  String get tournament => '大会';

  @override
  String get tryAgain => '再試行';

  @override
  String get tryAgainCaps => '再試行';

  @override
  String get twoPlayers => '2人で1台';

  @override
  String get txChallengeEntry => 'チャレンジ参加費';

  @override
  String get txCoinPurchase => 'コイン購入';

  @override
  String txDailyBonus(String time) {
    return 'デイリーボーナス · $time';
  }

  @override
  String get txDailyReward => 'デイリー報酬';

  @override
  String get txFreeVideo => '無料動画の報酬';

  @override
  String get txMatchWin => '対戦勝利';

  @override
  String txPurchasing(String time) {
    return 'コイン購入 · $time';
  }

  @override
  String txReferral(String time) {
    return '紹介コード · $time';
  }

  @override
  String txTournament(String time) {
    return '大会 · $time';
  }

  @override
  String get txTournamentPrize => '大会賞金';

  @override
  String txWatchingAds(String time) {
    return '広告視聴 · $time';
  }

  @override
  String get txWelcomeBonus => 'ウェルカムボーナス';

  @override
  String txWinning(String time) {
    return '対戦に勝利 · $time';
  }

  @override
  String get typeMessage => 'メッセージを入力';

  @override
  String get unblockPlayer => 'ブロック解除';

  @override
  String get unblockToAdd => '追加するにはブロックを解除してください';

  @override
  String get unblockToChallenge => 'チャレンジするにはブロックを解除してください';

  @override
  String unlockFor(String n) {
    return '解除 · $n コイン';
  }

  @override
  String get unlocked => '解除済み';

  @override
  String unlockedCount(String n, String total) {
    return '$n/$total 解除';
  }

  @override
  String get unranked => 'ランク外';

  @override
  String get upTo3Images => '最大3枚。運営チームのみ閲覧できます。';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String get updateFailed => '更新に失敗しました';

  @override
  String get updateOnAppStore => 'App Storeでアップデート';

  @override
  String get updateRequired => 'アップデートが必要です';

  @override
  String get updatesOnlyMobile => 'アップデートはAndroidとiOSで利用できます。';

  @override
  String get useChatReport => '証拠付きで報告するには、対戦中に チャット → 報告 を使ってください。';

  @override
  String get username => 'ユーザー名';

  @override
  String get usernameHint => 'ユーザー名（a-z、0-9、_）';

  @override
  String get verifyCode => 'コードを確認';

  @override
  String get verifyFailBody => '接続が弱い場合や、すでに受け取り済みの場合に起こります。コインは安全です。';

  @override
  String get verifying => '確認中…';

  @override
  String get verifyingReward => '報酬を確認中';

  @override
  String versionLabel(String version) {
    return 'バージョン $version';
  }

  @override
  String get versionUnsupported => 'このバージョンはサポートが終了しました。プレイを続けるにはアップデートしてください。';

  @override
  String get vibration => 'バイブレーション';

  @override
  String get victory => '勝利';

  @override
  String get videoLength => '動画は約15〜30秒です。最後まで見るとコインがもらえます。';

  @override
  String get videos => '動画';

  @override
  String get viewAppealStatus => '申し立ての状況を見る';

  @override
  String get viewBracket => 'トーナメント表';

  @override
  String get viewBracketCaps => 'トーナメント表';

  @override
  String get viewProfile => 'プロフィールを見る';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String get waitingCaps => '待機中';

  @override
  String waitingForAccept(String name) {
    return '$nameの承諾を待っています…';
  }

  @override
  String get waitingForFriend => '友だちを待っています...';

  @override
  String get waitingOtherMatches => '他の対戦待ち';

  @override
  String get waitingRoundOpen => 'ラウンド開始待ち';

  @override
  String get wallet => 'ウォレット';

  @override
  String get walletBalance => 'ウォレット残高';

  @override
  String get walletCaps => 'ウォレット';

  @override
  String get walletUnavailable => 'ウォレットを利用できません';

  @override
  String watchAnotherLeft(String n) {
    return 'もう1本見る（残り$n）';
  }

  @override
  String get watchBracketCaps => 'トーナメント表を見る';

  @override
  String get watchFullVideo => 'ボーナスコインを受け取るには動画を最後まで見てください。';

  @override
  String get watchNowCaps => '今すぐ見る';

  @override
  String get watchShortVideo => '短い動画を見る';

  @override
  String watchShortVideoToGet(String n) {
    return '短い動画を見て +$n ゲット';
  }

  @override
  String get watchVideo => '動画を見る';

  @override
  String get watchVideoCoins => '動画を見て10コインゲット';

  @override
  String get weekly => 'ウィークリー';

  @override
  String get weeklyChest => 'ウィークリー宝箱';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get welcomeBonusCaps => 'ウェルカムボーナス';

  @override
  String welcomeName(String name) {
    return 'ようこそ、$name';
  }

  @override
  String get whatHappenedCaps => '何があったか';

  @override
  String get whatHappenedHint => '何があったか、このプレイヤーを報告する理由を教えてください';

  @override
  String get whatsNewCaps => '新機能';

  @override
  String get whoCanChallenge => 'チャレンジを受け付ける相手';

  @override
  String get whoCanMessage => 'メッセージを受け取る相手';

  @override
  String get winRate => '勝率';

  @override
  String get winner => '勝者';

  @override
  String get wins => '勝利';

  @override
  String winsThisRound(String name) {
    return 'このラウンドは$nameの勝ち。';
  }

  @override
  String get yesDelete => 'はい、削除';

  @override
  String get yesterday => '昨日';

  @override
  String get yesterdayCaps => '昨日';

  @override
  String get you => 'あなた';

  @override
  String youBeat(String name) {
    return '$nameに勝ちました。';
  }

  @override
  String get youFinished => 'あなたの順位';

  @override
  String get youLose => 'あなたの負け';

  @override
  String youMark(String mark) {
    return 'あなた · $mark';
  }

  @override
  String get youWin => 'あなたの勝ち！';

  @override
  String get youWinCaps => '勝利';

  @override
  String get youX => 'あなた：X';

  @override
  String yourBalance(String n) {
    return '残高: $n コイン';
  }

  @override
  String get yourEmail => 'あなたのメール';

  @override
  String get yourMatchReadyCaps => '対戦の準備完了';

  @override
  String get yourMove => 'あなたの番';

  @override
  String get yourNextMatch => '次の対戦';

  @override
  String get yourTurnCaps => 'あなたの番';

  @override
  String get youreInCaps => '参加完了';

  @override
  String get youreInViewBracket => '参加済み — トーナメント表を見る';

  @override
  String get youreOffline => 'オフラインです';
}
