// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX — быстрая соревновательная игра «три в ряд». Играйте с компьютером, сражайтесь с реальными игроками, вызывайте друзей и поднимайтесь в рейтинге.';

  @override
  String get aboutUs => 'О нас';

  @override
  String get accept => 'Принять';

  @override
  String get acceptCaps => 'ПРИНЯТЬ';

  @override
  String get acceptRequestCaps => 'ПРИНЯТЬ ЗАПРОС';

  @override
  String get accountCheckFailed => 'Не удалось проверить аккаунт';

  @override
  String get accountIsSuspended => 'Ваш аккаунт заблокирован.';

  @override
  String get accountRestricted =>
      'Аккаунт ограничен до окончания проверки. Игра, подбор и чат недоступны.';

  @override
  String get accountStatusUnknown =>
      'Статус аккаунта неизвестен. Попробуйте ещё раз.';

  @override
  String get accountSuspended => 'Аккаунт заблокирован';

  @override
  String get accountSuspendedSignIn =>
      'Ваш аккаунт заблокирован. Войдите, чтобы узнать подробности или подать апелляцию.';

  @override
  String get accountSuspendedTitle => 'Ваш аккаунт заблокирован';

  @override
  String get ach100Wins => '100 побед';

  @override
  String get ach10Matches => '10 матчей';

  @override
  String get ach50Matches => '50 матчей';

  @override
  String get achChallenger => 'Претендент';

  @override
  String get achChampion => 'Чемпион';

  @override
  String get achFirstWin => 'Первая победа';

  @override
  String get achScore100 => '100 очков';

  @override
  String get achStreak3 => 'Серия из 3';

  @override
  String get achStreak5 => 'Серия из 5';

  @override
  String get achSurvivor => 'Выживший';

  @override
  String get achTop3 => 'Топ-3';

  @override
  String get achievements => 'Достижения';

  @override
  String get add => 'Добавить';

  @override
  String get addFriend => 'Добавить в друзья';

  @override
  String get addFriendCaps => 'ДОБАВИТЬ В ДРУЗЬЯ';

  @override
  String get advanceQuarter => 'Вы вышли в четвертьфинал';

  @override
  String get advancedMode => 'Продвинутый (4×4)';

  @override
  String get advertiserApp => 'Приложение рекламодателя';

  @override
  String get advertiserVideo => 'Здесь идёт рекламное видео';

  @override
  String get all => 'Все';

  @override
  String get allowAndInstall => 'Разрешить и установить';

  @override
  String get allowUnknownApps =>
      'Разрешите DROTIX «Установку неизвестных приложений» и вернитесь — обновление установится само.';

  @override
  String get alreadyPlayer => 'Уже играете?';

  @override
  String get alsoBlock => 'Также заблокировать игрока';

  @override
  String get alwaysTrue => 'Всегда';

  @override
  String get appUpdate => 'Обновление приложения';

  @override
  String get appealExplain =>
      'Объясните, почему аккаунт нужно восстановить. Модератор рассмотрит ваше сообщение.';

  @override
  String get appealFailed => 'Апелляция не отправлена';

  @override
  String get appealHint => 'Напишите апелляцию (не менее 20 символов)…';

  @override
  String get appealIsUnderReview => 'Ваша апелляция на рассмотрении.';

  @override
  String get appealMin20 => 'Апелляция должна быть не короче 20 символов';

  @override
  String get appealSubmitted => 'Апелляция отправлена';

  @override
  String get appealSuspension => 'Обжаловать блокировку';

  @override
  String get appealUnderReview => 'Апелляция на рассмотрении';

  @override
  String get applyCodeCaps => 'ПРИМЕНИТЬ КОД';

  @override
  String get attachRecentChat => 'Приложить последние сообщения';

  @override
  String get attemptingReconnect => 'Переподключение…';

  @override
  String get auto => 'Авто';

  @override
  String get avatars => 'Аватары';

  @override
  String get back => 'Назад';

  @override
  String get backToEvent => 'К событию';

  @override
  String get backToEvents => 'К событиям';

  @override
  String get backToEventsCaps => 'К СОБЫТИЯМ';

  @override
  String get backToHome => 'На главную';

  @override
  String get backToMenu => 'В меню';

  @override
  String get backToSignIn => 'Назад ко входу';

  @override
  String balance(String n) {
    return 'Баланс $n';
  }

  @override
  String get balanceAfter => 'Баланс после';

  @override
  String balanceArrow(String from) {
    return 'Баланс $from →';
  }

  @override
  String get bestStreak => 'Лучшая серия';

  @override
  String get bestValue => 'Выгоднее всего';

  @override
  String get biggerBoardsBody =>
      'На больших полях нужно четыре в ряд. Если поле заполнено без ряда — ничья.';

  @override
  String get biggerBoardsCaps => 'БОЛЬШИЕ ПОЛЯ';

  @override
  String get biggerNeedFour => 'На больших полях нужно четыре в ряд';

  @override
  String get blockPlayer => 'Заблокировать';

  @override
  String get boardHiddenUntilBack => 'Поле скрыто, пока вы не вернётесь.';

  @override
  String get boards => 'Поля';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n монет зачислено в кошелёк';
  }

  @override
  String get bonusClaimed => 'Бонус получен!';

  @override
  String bonusCoinsAdded(String n) {
    return 'Добавлено +$n бонусных монет';
  }

  @override
  String get bracket => 'Сетка';

  @override
  String get bracketInfo => '1/8 финала · 8 матчей, показано 4. Вы выделены.';

  @override
  String get buyCoinsCaps => 'КУПИТЬ МОНЕТЫ';

  @override
  String get byBoard => 'По полю';

  @override
  String get cameraOnlyForScan =>
      'Камера используется только для сканирования кода.';

  @override
  String get cameraPermissionNeeded =>
      'Для сканирования нужен доступ к камере. Можно ввести код ниже.';

  @override
  String get cameraPermissionRequired =>
      'Для сканирования QR-кода комнаты нужен доступ к камере. Включите камеру для приложения в настройках и попробуйте снова.';

  @override
  String get cancel => 'Отмена';

  @override
  String get cancelChallenge => 'Отменить вызов';

  @override
  String get cancelDownload => 'Отменить загрузку';

  @override
  String get cannotChallengeSelf => 'Нельзя вызвать самого себя';

  @override
  String get cannotFriendSelf => 'Нельзя добавить себя в друзья';

  @override
  String get cantChallengeNow => 'Сейчас нельзя вызвать этого игрока.';

  @override
  String get challenge => 'Вызов';

  @override
  String get challengeAccepted => 'Вызов принят';

  @override
  String get challengeCancelled => 'Вызов отменён';

  @override
  String get challengeCaps => 'ВЫЗВАТЬ';

  @override
  String get challengeClosed => 'Вызов закрыт';

  @override
  String get challengeDeclined => 'Вызов отклонён';

  @override
  String get challengeExpired => 'Срок вызова истёк';

  @override
  String get challengeExpiresIn60 =>
      'Вызов истечёт через 60 секунд, если его не примут.';

  @override
  String get challengePrivacy => 'Приватность вызовов';

  @override
  String get challengeRequests => 'Запросы на вызов';

  @override
  String get challengeSentCoins => 'Вызов отправлен · 5 монет';

  @override
  String get challengeSentFree => 'Вызов отправлен · Бесплатный матч';

  @override
  String get challenges => 'Вызовы';

  @override
  String get championCaps => 'ЧЕМПИОН';

  @override
  String get change => 'Изменить';

  @override
  String get chat => 'Чат';

  @override
  String get chatAfterAccept => 'Чат — после согласия обоих.';

  @override
  String get chatAfterAcceptRandom =>
      'Чат — после согласия обоих. Кроме имени ничего не передаётся.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name принимает сообщения только от друзей.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name отключил сообщения.';
  }

  @override
  String get chatNotConnected => 'Чат не подключён';

  @override
  String get chatOn => 'Чат включён';

  @override
  String get chatPrivacyNote =>
      'Действует для чата в матче. Изменения применяются сразу, даже во время игры.';

  @override
  String get chatRules => 'Правила чата';

  @override
  String get chatRulesIntro =>
      'Чат не начинается сам. Один игрок предлагает, другой должен согласиться.';

  @override
  String get checkAgainCaps => 'ПРОВЕРИТЬ СНОВА';

  @override
  String get checkEmail => 'Проверьте почту';

  @override
  String get checkEmailConfirm =>
      'Проверьте почту и откройте ссылку подтверждения';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get checkInbox => 'Проверьте входящие';

  @override
  String get checking => 'Проверка…';

  @override
  String get chooseEntryStake => 'Выберите ставку';

  @override
  String get chooseGameMode => 'Выберите режим игры';

  @override
  String get chooseNewPassword => 'Придумайте новый пароль';

  @override
  String get chooseOpponent => 'Выберите соперника';

  @override
  String get claim => 'ЗАБРАТЬ';

  @override
  String claimBonusCoins(String n) {
    return 'Получить $n бонусных монет';
  }

  @override
  String get claimLabel => 'Забрать';

  @override
  String claimPlusCoins(String n) {
    return 'Забрать +$n монет';
  }

  @override
  String get claimVictory => 'Забрать победу';

  @override
  String get claimsSync => 'Награды синхронизируются с аккаунтом';

  @override
  String get classicMode => 'Классика (3×3)';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get clipboardNoCode => 'В буфере обмена нет кода комнаты';

  @override
  String get close => 'Закрыть';

  @override
  String get closeAndLose => 'Закрыть без награды';

  @override
  String get closeRoom => 'Закрыть комнату';

  @override
  String get closing => 'Закрытие…';

  @override
  String get cloud => 'Облако';

  @override
  String cloudSaveFailed(String message) {
    return 'Ошибка облачного сохранения: $message';
  }

  @override
  String get codeSent => 'Код отправлен';

  @override
  String get coinPacks => 'Наборы монет';

  @override
  String coinPacksFrom(String price) {
    return 'НАБОРЫ ОТ $price';
  }

  @override
  String get coins5 => '5 монет';

  @override
  String coinsAdded(String n) {
    return 'Добавлено +$n монет';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Монеты $delta · Баланс $balance';
  }

  @override
  String get coinsEntryFee => 'Взнос 5 монет';

  @override
  String get coinsEntryFeeBody =>
      'Используется, когда бесплатные матчи закончились, или чтобы поднять ставку.';

  @override
  String coinsLabel(String n) {
    return '$n монет';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n монет (сохранено в облаке)';
  }

  @override
  String get column => 'Столбец';

  @override
  String get comeBackTomorrow => 'Приходите завтра';

  @override
  String get completeGoogleReturnApp =>
      'Завершите вход через Google и вернитесь в приложение';

  @override
  String get completeGoogleSignIn => 'Завершите вход через Google и вернитесь';

  @override
  String get computer => 'Компьютер';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get confirmJoinCaps => 'ПОДТВЕРДИТЬ';

  @override
  String confirmLinkSentTo(String target) {
    return 'Мы отправили ссылку на $target.\nОткройте её на этом устройстве и вернитесь — вход выполнится автоматически.';
  }

  @override
  String get confirmPassword => 'Повторите пароль';

  @override
  String get confirmationEmailSent => 'Письмо отправлено — проверьте почту';

  @override
  String get confirmingVideo => 'Подтверждаем просмотр. Подождите.';

  @override
  String get connectingChat => 'Подключение чата…';

  @override
  String get connectionUnstable => 'Нестабильное соединение';

  @override
  String get connectionUnstableCaps => 'НЕСТАБИЛЬНОЕ СОЕДИНЕНИЕ';

  @override
  String get contactAbout => 'Контакты и о приложении';

  @override
  String get contactUsCaps => 'КОНТАКТЫ';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get continuePlaying => 'Продолжить игру';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String copiedValue(String label, String value) {
    return '$label скопирован: $value';
  }

  @override
  String get couldNotAddCoins => 'Не удалось добавить монеты';

  @override
  String get couldNotApplyReferral => 'Не удалось применить код';

  @override
  String couldNotCheck(String error) {
    return 'Не удалось проверить: $error';
  }

  @override
  String get couldNotJoinRoom => 'Не удалось войти в комнату';

  @override
  String get couldNotLoadPrivacy => 'Не удалось загрузить настройки';

  @override
  String get couldNotLoadProfile =>
      'Не удалось загрузить профиль. Попробуйте ещё раз.';

  @override
  String get couldNotOpenGoogle => 'Не удалось открыть вход через Google';

  @override
  String get couldNotSavePrivacy => 'Не удалось сохранить настройки';

  @override
  String get couldNotStopChat => 'Не удалось остановить чат';

  @override
  String get couldNotSubmitAppeal => 'Не удалось подать апелляцию';

  @override
  String get couldNotVerify => 'Не удалось подтвердить';

  @override
  String get couldNotVerifyAccount =>
      'Не удалось проверить статус аккаунта. Попробуйте ещё раз.';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get createPrivateRoom => 'Создать приватную комнату';

  @override
  String get customize => 'Оформление';

  @override
  String get daily => 'Ежедневно';

  @override
  String get dailyChest => 'Ежедневный сундук';

  @override
  String get dailyLimit => 'ДНЕВНОЙ ЛИМИТ ИСЧЕРПАН';

  @override
  String get date => 'Дата';

  @override
  String dayN(String n) {
    return 'День $n';
  }

  @override
  String dayStreak(String n) {
    return 'Серия $n дн.';
  }

  @override
  String get days30 => '30 дней';

  @override
  String get days7 => '7 дней';

  @override
  String get debitFailed => 'Не удалось списать монеты';

  @override
  String get declineCaps => 'ОТКЛОНИТЬ';

  @override
  String get defeat => 'ПОРАЖЕНИЕ';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountBody =>
      'Ваши монеты, очки и история будут удалены навсегда.';

  @override
  String get deleteAccountQuestion => 'Удалить аккаунт?';

  @override
  String get descriptionMin10 => 'Описание должно быть не короче 10 символов';

  @override
  String get diagonal => 'Диагональ';

  @override
  String get difficultyEasy => 'Легко';

  @override
  String get difficultyHard => 'Сложно';

  @override
  String get difficultyMedium => 'Средне';

  @override
  String get doll => 'Кукла';

  @override
  String get done => 'Готово';

  @override
  String get downloadAndInstall => 'Скачать и установить';

  @override
  String get downloading => 'Загрузка…';

  @override
  String downloadingPercent(String percent) {
    return 'Загрузка $percent%';
  }

  @override
  String get draw => 'Ничья';

  @override
  String get drawBadge => 'НИЧЬЯ';

  @override
  String get draws => 'Ничьи';

  @override
  String get duration => 'Период';

  @override
  String get earned => 'Получено';

  @override
  String get earnedThisWeek => 'Заработано за неделю по источникам';

  @override
  String get editProfileCaps => 'РЕДАКТИРОВАТЬ ПРОФИЛЬ';

  @override
  String get eliminatedCaps => 'ВЫБЫЛИ';

  @override
  String get email => 'Эл. почта';

  @override
  String get emailNotConfirmed => 'Почта не подтверждена';

  @override
  String emailNotConfirmedBody(String email) {
    return 'Регистрация прошла, но почта ещё не подтверждена.\n\nОткройте ссылку подтверждения во входящих или в спаме, затем войдите снова.\n\n$email';
  }

  @override
  String get emailSentAgain => 'Письмо отправлено снова — проверьте почту';

  @override
  String get endsIn => 'До конца';

  @override
  String get enterCode => 'Введите код';

  @override
  String get enterCodeFromEmail => 'Введите код из письма';

  @override
  String get enterCodeInstead => 'Ввести код вручную';

  @override
  String get enterEmailPassword => 'Введите почту и пароль';

  @override
  String get enterFullCode => 'Введите полный код комнаты';

  @override
  String get enterReferralOrSkip => 'Введите реферальный код или пропустите';

  @override
  String get enterResetCode => 'Введите код сброса';

  @override
  String get enterValidMobile => 'Введите правильный номер телефона';

  @override
  String get enterValidReferral => 'Введите правильный реферальный код';

  @override
  String get enterYourEmail => 'Введите почту';

  @override
  String get entry => 'Взнос';

  @override
  String get entryFee => 'Взнос';

  @override
  String get equip => 'Выбрать';

  @override
  String get equipped => 'Используется';

  @override
  String get events => 'События';

  @override
  String get everyone => 'Все';

  @override
  String get expertMode => 'Эксперт (5×5)';

  @override
  String get expiredMoveToHistory => 'Истёкшие вызовы попадают в Историю.';

  @override
  String get failed => 'Ошибка';

  @override
  String get fillAllFields => 'Заполните все поля';

  @override
  String get finalRound => 'Финал';

  @override
  String get findAMatch => 'Найти матч';

  @override
  String get findOpponent => 'Найти соперника';

  @override
  String get findPrivateJoin => 'Поиск · приватная комната · код';

  @override
  String get findingOpponent => 'Поиск соперника';

  @override
  String get findingPlayer => 'Поиск игрока';

  @override
  String get firstMatchSet => 'Первый матч назначат, когда откроется раунд.';

  @override
  String get fiveOfFiveWatched => 'Просмотрено 5 из 5';

  @override
  String get flash => 'Вспышка';

  @override
  String get flashUnavailable => 'Вспышка недоступна';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get forgotPasswordTitle => 'Забыли пароль';

  @override
  String get free => 'Бесплатно';

  @override
  String get freeCoins => 'БЕСПЛАТНЫЕ МОНЕТЫ';

  @override
  String get freeMatch => 'Бесплатный матч';

  @override
  String get freeMatchesPerDay => '3 бесплатных матча в день';

  @override
  String get freeVideosToday => 'Бесплатные видео сегодня';

  @override
  String freeVideosUsed(String used) {
    return 'Сегодня использовано $used из 5 бесплатных видео';
  }

  @override
  String get friendChallenge => 'Вызов друга';

  @override
  String get friendRequestExists => 'Запрос в друзья уже отправлен';

  @override
  String friendRequestSent(String name) {
    return 'Запрос в друзья отправлен: $name';
  }

  @override
  String get friendRequestSentShort => 'Запрос в друзья отправлен';

  @override
  String get friendsCaps => 'ДРУЗЬЯ';

  @override
  String get friendsLabel => 'Друзья';

  @override
  String get friendsOnly => 'Только друзья';

  @override
  String get fromPhoto => 'Из фото';

  @override
  String gameComingSoon(String game) {
    return '$game: скоро';
  }

  @override
  String get gameOver => 'Игра окончена';

  @override
  String get gamePaused => 'Игра на паузе';

  @override
  String get getStarted => 'Начать';

  @override
  String get gettingVideo => 'Загружаем видео…';

  @override
  String get goToMatchCaps => 'К МАТЧУ';

  @override
  String get gotIt => 'Понятно';

  @override
  String get graceWindowEnded =>
      '30 секунд ожидания истекли. Можно забрать победу.';

  @override
  String greatRun(String name) {
    return 'Отличное выступление в $name';
  }

  @override
  String get guard => 'Страж';

  @override
  String get guest => 'Гость';

  @override
  String get history => 'История';

  @override
  String get historyNeverPublic =>
      'История матчей и активность никогда не видны в публичном профиле.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches матчей · $wins побед · $losses поражений · $draws ничьих';
  }

  @override
  String get howItWorks => 'Как это работает';

  @override
  String get howToPlay => 'Как играть';

  @override
  String get howToPlayRules =>
      'Выстройте три своих знака в ряд — по горизонтали, вертикали или диагонали — раньше соперника. На больших полях нужно четыре.';

  @override
  String howToPlayStep(String n) {
    return 'КАК ИГРАТЬ · $n/3';
  }

  @override
  String get imReadyCaps => 'Я ГОТОВ';

  @override
  String get imageTooBig => 'Изображение должно быть меньше 2 МБ';

  @override
  String get install => 'Установить';

  @override
  String get installUpdate => 'Установить обновление';

  @override
  String get installed => 'Установлена';

  @override
  String get internetRequired =>
      'Нужно подключение к интернету. Против The Doll можно играть и офлайн.';

  @override
  String get introBody1 => 'Обыграйте ИИ на полях 3×3, 4×4 или 5×5.';

  @override
  String get introBody2 =>
      'Случайные матчи с реальными игроками. Ставьте монеты — выигрывайте монеты.';

  @override
  String get introBody3 =>
      'Ежедневные награды, задания и турниры помогут расти.';

  @override
  String get introTitle1 => 'Перехитри Куклу';

  @override
  String get introTitle2 => 'Сразись с миром';

  @override
  String get introTitle3 => 'Поднимайтесь в рейтинге';

  @override
  String get invalidRoomQr => 'Неверный QR комнаты';

  @override
  String get inviteImage => 'Картинка-приглашение';

  @override
  String get inviteImageBody =>
      'Код, QR и ссылка на одной картинке. Отправьте в WhatsApp или куда угодно.';

  @override
  String isThinking(String name) {
    return '$name думает';
  }

  @override
  String get joinCaps => 'ВОЙТИ';

  @override
  String joinForCoins(String n) {
    return 'ВСТУПИТЬ ЗА $n МОНЕТ';
  }

  @override
  String get joinRoomCaps => 'ВОЙТИ В КОМНАТУ';

  @override
  String get joinTheGame => 'Присоединяйтесь';

  @override
  String joinTournamentQuestion(String name) {
    return 'Вступить в $name?';
  }

  @override
  String get joinWithCode => 'Войти по коду';

  @override
  String get joined => 'Участвуете';

  @override
  String get joiningCaps => 'ВХОД…';

  @override
  String get joiningQueue => 'Вход в очередь…';

  @override
  String get joiningRoom => 'Вход в комнату…';

  @override
  String get keepWatchingCaps => 'ДОСМОТРЕТЬ';

  @override
  String get language => 'Язык';

  @override
  String get languageUpdated => 'Язык изменён';

  @override
  String get last20Sent =>
      'Последние 20 сообщений отправятся вместе с жалобой.';

  @override
  String get last7Games => 'Последние 7 игр';

  @override
  String lastUpdated(String date) {
    return 'Обновлено $date';
  }

  @override
  String get later => 'Позже';

  @override
  String get latestVersion => 'У вас последняя версия.';

  @override
  String get leaderboard => 'Рейтинг';

  @override
  String get leaderboardUpdated => 'Рейтинг обновлён';

  @override
  String get leave => 'Выйти';

  @override
  String get leaveForfeitBody =>
      'Выход сейчас засчитывается как поражение. Победит соперник.';

  @override
  String get leaveGame => 'Покинуть игру';

  @override
  String get leaveMatchQuestion => 'Покинуть матч?';

  @override
  String get leaveVideoQuestion => 'Закрыть видео?';

  @override
  String get letsPlay => 'Играем';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String get live => 'В сети';

  @override
  String get liveEventCaps => 'ИДЁТ СОБЫТИЕ';

  @override
  String get loading => 'Загрузка…';

  @override
  String get local => 'Локально';

  @override
  String get locked => 'Закрыто';

  @override
  String get logOut => 'Выйти';

  @override
  String get loginMethod => 'Способ входа';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'Если закрыть сейчас, 10 монет не начислятся. Осталось $seconds с.';
  }

  @override
  String get losses => 'Поражения';

  @override
  String get markAllRead => 'Отметить все как прочитанные';

  @override
  String get marks => 'Знаки';

  @override
  String get match => 'Матч';

  @override
  String get matchAbandonedCaps => 'МАТЧ ПОКИНУТ';

  @override
  String matchDuration(String duration) {
    return 'Длительность $duration';
  }

  @override
  String get matchHistory => 'История матчей';

  @override
  String get matchHistoryCaps => 'ИСТОРИЯ МАТЧЕЙ';

  @override
  String get matchInvitations => 'Приглашения в матч';

  @override
  String get matchLobby => 'Лобби матча';

  @override
  String get matchResult => 'Итог матча';

  @override
  String get matchResults => 'Результаты матчей';

  @override
  String get matchStakes => 'Ставки матча';

  @override
  String get matchStartsIn => 'Матч начнётся через';

  @override
  String get matches => 'Матчи';

  @override
  String get matchmakingError => 'Ошибка подбора';

  @override
  String get matchmakingFailed => 'Подбор не удался';

  @override
  String get matchmakingStopped => 'Подбор остановлен';

  @override
  String memberSince(String date) {
    return 'С нами с $date';
  }

  @override
  String get messageEmpty => 'Сообщение не может быть пустым';

  @override
  String get messagesStayForMatch => 'Сообщения хранятся только в этом матче';

  @override
  String minusCoins(String n) {
    return '-$n монет';
  }

  @override
  String get misPlay30 => 'Сыграйте 30 матчей';

  @override
  String get misPlay5 => 'Сыграйте 5 матчей';

  @override
  String get misQuick => 'Сыграйте случайный матч';

  @override
  String get misTourney => 'Вступите в турнир';

  @override
  String get misWin15 => 'Выиграйте 15 игр';

  @override
  String get misWin3 => 'Выиграйте 3 игры';

  @override
  String get misWin4x4 => 'Победите на поле 4×4';

  @override
  String get missResets =>
      'Пропустите день — серия сбросится. Возвращайтесь завтра за наградой.';

  @override
  String get missingChallengeData => 'Нет данных вызова';

  @override
  String get missingEmail => 'Нет почты — вернитесь и попробуйте снова';

  @override
  String get missions => 'Задания';

  @override
  String missionsDone(String done, String total) {
    return 'Выполнено $done из $total';
  }

  @override
  String get mobileNotSupported =>
      'Номера телефонов пока не поддерживаются в вашем регионе';

  @override
  String get mobileOptional => 'Номер телефона (необязательно)';

  @override
  String mode(String n) {
    return 'Режим $n';
  }

  @override
  String get more => 'Ещё';

  @override
  String get moreGames => 'Другие игры';

  @override
  String get music => 'Музыка';

  @override
  String nOf5(String n) {
    return '$n из 5';
  }

  @override
  String get navPlay => 'Играть';

  @override
  String get newCodeSent => 'Новый код отправлен — проверьте почту';

  @override
  String get newHere => 'Впервые?';

  @override
  String get newMatchChallengeCaps => 'НОВЫЙ ВЫЗОВ!';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get newPasswordBody =>
      'Введите новый пароль. После сохранения вы останетесь в аккаунте.';

  @override
  String get newVersion => 'Новая версия';

  @override
  String get newVersionReady => 'Новая версия DROTIX готова.';

  @override
  String get newVideosUnlockIn => 'Новые видео через';

  @override
  String get next => 'Далее';

  @override
  String get nextCaps => 'ДАЛЕЕ';

  @override
  String get nextRound => 'Следующий раунд';

  @override
  String get no => 'Нет';

  @override
  String get noChallenge => 'Нет вызова';

  @override
  String get noChallengesHere => 'Здесь нет вызовов.';

  @override
  String get noCloudMatches =>
      'Облачных матчей пока нет. Войдите и сыграйте против The Doll, чтобы попасть сюда.';

  @override
  String get noFriendsYet => 'Друзей пока нет — найдите и добавьте.';

  @override
  String get noHistory => 'История пуста';

  @override
  String get noMatchesYet => 'Матчей пока нет';

  @override
  String get noMessagesYet =>
      'Сообщений пока нет.\nМожно использовать быстрые ответы.';

  @override
  String get noNotificationsYet => 'Уведомлений пока нет';

  @override
  String get noOpponentFound => 'Соперник не найден — попробуйте ещё раз';

  @override
  String get noPendingRequests => 'Нет входящих запросов.';

  @override
  String get noPlayersFound => 'Игроки не найдены';

  @override
  String get noQrInPhoto => 'На фото нет QR-кода';

  @override
  String get noRankedPlayers =>
      'В рейтинге пока никого. Войдите и играйте, чтобы попасть в него.';

  @override
  String get noTransactions => 'Операций пока нет.';

  @override
  String get noVideoFound =>
      'Видео не найдено. Бесплатное видео не списано. Попробуйте через минуту.';

  @override
  String get noVideoNow => 'Сейчас нет доступных видео. Попробуйте позже.';

  @override
  String get noVideoRightNow => 'Сейчас нет видео';

  @override
  String get nobody => 'Никто';

  @override
  String get nobodyBlinked => 'Никто не уступил.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Никто не уступил. $name вас сдержал.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name сейчас не принимает вызовы.';
  }

  @override
  String get notEnoughCoins => 'Недостаточно монет';

  @override
  String get notEnoughCoinsAnother => 'Недостаточно монет для новой ставки.';

  @override
  String get notEnoughCoinsStake => 'Недостаточно монет для этой ставки.';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get notSignedIn => 'Вход не выполнен';

  @override
  String get notSignedInYet => 'Вход ещё не выполнен — сначала откройте ссылку';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name принял ваш вызов. Матч начинается!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Вызов принят';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name сейчас в матче. Попробуйте позже.';
  }

  @override
  String get notifChallengeBusyTitle => 'Игрок занят';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name отменил вызов';
  }

  @override
  String get notifChallengeCancelledTitle => 'Вызов отменён';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name отклонил ваш вызов';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Вызов отклонён';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name не ответил вовремя';
  }

  @override
  String get notifChallengeExpiredTitle => 'Вызов истёк';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name вызывает вас на матч';
  }

  @override
  String get notifChallengeRequestTitle => 'Новый вызов';

  @override
  String get notifChannelDesc => 'Вызовы, матчи и монеты';

  @override
  String get notifChannelName => 'Игровые оповещения';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return 'Начислено $amount монет. Баланс: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Монеты начислены';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return 'Списано $amount монет. Баланс: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Монеты списаны';

  @override
  String get notifCoinsPurchaseTitle => 'Покупка завершена';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'Вы получили $amount монет. Баланс: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Награда получена';

  @override
  String get notifEmptyHint =>
      'Здесь появятся вызовы, результаты матчей и изменения монет.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name принял ваш запрос в друзья';
  }

  @override
  String get notifFriendAcceptedTitle => 'Новый друг';

  @override
  String notifFriendRequestBody(String name) {
    return '$name хочет добавить вас в друзья';
  }

  @override
  String get notifFriendRequestTitle => 'Запрос в друзья';

  @override
  String get notifGeneric => 'Новое уведомление';

  @override
  String notifMatchBody(String name) {
    return 'Ваш матч с $name завершён';
  }

  @override
  String get notifMatchDrawTitle => 'Ничья';

  @override
  String get notifMatchLostTitle => 'Вы проиграли';

  @override
  String get notifMatchWonTitle => 'Вы победили!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name вошёл в вашу приватную комнату';
  }

  @override
  String get notifRoomJoinedTitle => 'Игрок присоединился';

  @override
  String get notifications => 'Уведомления';

  @override
  String nowFriends(String name) {
    return 'Вы и $name теперь друзья';
  }

  @override
  String get nowFriendsShort => 'Теперь вы друзья';

  @override
  String get officialWebsite => 'Официальный сайт';

  @override
  String get offlineAi => 'Офлайн-ИИ';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'Нет интернета · только ИИ · $size · ставка $stake';
  }

  @override
  String get offlineBanner => 'Офлайн · игра против The Doll работает';

  @override
  String get offlineBody =>
      'Для онлайн-матчей и турниров нужно подключение. Против The Doll играть можно.';

  @override
  String get offlineProfilesNote =>
      'Это офлайн-профили ИИ, а не реальные игроки.';

  @override
  String get offlineSmart => 'Офлайн, умный соперник';

  @override
  String get ok => 'ОК';

  @override
  String get oneLastStepCaps => 'ПОСЛЕДНИЙ ШАГ';

  @override
  String get online => 'Онлайн';

  @override
  String get onlineMatch => 'Онлайн-матч';

  @override
  String get onlineMultiplayer => 'Онлайн-игра';

  @override
  String get onlineOfflineAi => 'Игроки онлайн · ИИ офлайн';

  @override
  String onlineStake(String stake) {
    return 'Онлайн · Ставка $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name принимает вызовы только от друзей. Сначала добавьте в друзья.';
  }

  @override
  String get open => 'Открыть';

  @override
  String get openedTheLink => 'Я открыл ссылку';

  @override
  String get openingInstaller => 'Открываем установщик…';

  @override
  String get opponent => 'Соперник';

  @override
  String get opponentAdvances => 'Не успеете — соперник пройдёт дальше.';

  @override
  String get opponentDisconnected => 'Соперник отключился';

  @override
  String get opponentWins => 'Победил соперник';

  @override
  String opponentsMove(String name) {
    return 'Ход: $name';
  }

  @override
  String get or => 'Или';

  @override
  String get orEnterCodeCaps => 'ИЛИ ВВЕДИТЕ КОД';

  @override
  String get otherEvents => 'Другие события';

  @override
  String get owned => 'Куплено';

  @override
  String get passAndPlay => 'Передай и играй';

  @override
  String get password => 'Пароль';

  @override
  String get passwordMin6 => 'Пароль должен быть не короче 6 символов';

  @override
  String get passwordUpdated => 'Пароль обновлён';

  @override
  String get passwordsNoMatch => 'Пароли не совпадают';

  @override
  String get pasteCode => 'Вставить код';

  @override
  String get pause => 'Пауза';

  @override
  String get paused => 'Пауза';

  @override
  String get perMove20s => '20 с на ход';

  @override
  String get photoUpdated => 'Фото обновлено';

  @override
  String get pickClosestReason => 'Что случилось? Выберите подходящую причину.';

  @override
  String get pickYourGame => 'Выберите игру';

  @override
  String get playAgain => 'Сыграть ещё';

  @override
  String get playAsGuest => 'Играть как гость';

  @override
  String get playCaps => 'ИГРАТЬ';

  @override
  String get playDollOffline => 'Играть против The Doll офлайн';

  @override
  String get playToBuildForm => 'Сыграйте матч, чтобы увидеть форму.';

  @override
  String get playVsDoll => 'Играть против The Doll';

  @override
  String playVsName(String name) {
    return 'Играть против $name';
  }

  @override
  String get played => 'Сыграно';

  @override
  String get player => 'Игрок';

  @override
  String get player1 => 'Игрок 1';

  @override
  String get player1Move => 'Ход игрока 1';

  @override
  String get player1Wins => 'Победил игрок 1!';

  @override
  String get player2 => 'Игрок 2';

  @override
  String get player2Move => 'Ход игрока 2';

  @override
  String get player2Wins => 'Победил игрок 2!';

  @override
  String playerAdded(String name) {
    return '$name добавлен';
  }

  @override
  String get playerBlocked => 'Игрок заблокирован';

  @override
  String playerIdLabel(String id) {
    return 'ИГРОК $id';
  }

  @override
  String get playerUnblocked => 'Игрок разблокирован';

  @override
  String get players => 'Игроки';

  @override
  String get playersLeft => 'Осталось игроков';

  @override
  String get pleaseWait => 'Подождите…';

  @override
  String plusCoins(String n) {
    return '+$n монет';
  }

  @override
  String get podium => 'Пьедестал';

  @override
  String get pointAtHostQr =>
      'Наведите на QR хозяина — это тот же код, что в лобби.';

  @override
  String get pointCameraAtQr => 'Наведите камеру на QR-код комнаты';

  @override
  String pointsWins(String points, String wins) {
    return '$points очк. · $wins побед';
  }

  @override
  String get popular => 'Популярный';

  @override
  String get previousMatchExpired =>
      'Предыдущий матч истёк. Попробуйте чуть позже.';

  @override
  String get privacy => 'Приватность';

  @override
  String privacyBody(String email) {
    return 'Мы собираем только игровые данные, нужные для работы приложения (монеты, оформление, история матчей и настройки). Для игры гостем аккаунт не нужен.\n\nЕсли вы входите в аккаунт, данные используются только для сохранения и восстановления прогресса. Мы не продаём личные данные. Удалить данные можно в любой момент: Настройки → Удалить аккаунт.\n\nКонтакт: $email';
  }

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privateOnlyYou => 'Приватно. Видно только вам.';

  @override
  String get privateRoomByUsername => 'Приватная комната (по имени)';

  @override
  String get privateRoomCaps => 'ПРИВАТНАЯ КОМНАТА';

  @override
  String get prizeAdded => 'Приз зачислен на баланс';

  @override
  String get prizePool => 'Призовой фонд';

  @override
  String get profile => 'Профиль';

  @override
  String get profileNotFound => 'Профиль не найден';

  @override
  String get profilePrivacyNote =>
      'История матчей и активность скрыты. Жалоба здесь — на профиль; на чат в матче жалуйтесь кнопкой в чате.';

  @override
  String get profileUpdated => 'Профиль обновлён';

  @override
  String progressOf(String done, String total) {
    return '$done из $total';
  }

  @override
  String get publicStatsNote =>
      'Публичны только ранг, очки и победы. История матчей и активность скрыты.';

  @override
  String get purchaseFailed => 'Покупка не удалась';

  @override
  String get purchases => 'Покупки';

  @override
  String get purchasesComingSoon =>
      'Покупка монет скоро появится. Сейчас монеты можно получить за видео в разделе «Бесплатные монеты».';

  @override
  String get quarter => '1/4';

  @override
  String get quarterFinal => 'Четвертьфинал';

  @override
  String get quickCloseOne => 'Чуть-чуть!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'Хороший ход!';

  @override
  String quickMatchVsAi(String time) {
    return 'Быстрый матч с ИИ · $time';
  }

  @override
  String get quitMatch => 'Выйти из матча';

  @override
  String get randomMatch => 'Случайный матч';

  @override
  String get rank => 'Ранг';

  @override
  String rankScore(String rank, String score) {
    return 'Ранг #$rank · Очки $score';
  }

  @override
  String get rankScoreUnknown => 'Ранг – · Очки –';

  @override
  String get ranks => 'Рейтинг';

  @override
  String get rateApp => 'Оценить приложение';

  @override
  String get ratingsSoon => 'Оценки скоро появятся';

  @override
  String get readOnly => 'только чтение';

  @override
  String get readyCaps => 'ГОТОВ';

  @override
  String get reasonHarassment => 'Травля или оскорбления';

  @override
  String get reasonInappropriate => 'Сексуальный или неуместный контент';

  @override
  String get reasonOffensive => 'Язык вражды или оскорбления';

  @override
  String get reasonOther => 'Другое';

  @override
  String get reasonSpam => 'Спам или мошенничество';

  @override
  String get reasonThreatening => 'Угрозы или насилие';

  @override
  String get received => 'Входящие';

  @override
  String get reconnecting => 'Переподключение…';

  @override
  String reference(String id) {
    return 'Номер: $id';
  }

  @override
  String get referralCode => 'Реферальный код';

  @override
  String get referralHint => 'Реферальный код (необязательно)';

  @override
  String get referralOnce =>
      'Реферальный код можно использовать один раз, сразу после регистрации.';

  @override
  String get referralPrompt =>
      'Есть код от друга? Введите сейчас и получите 50 монет.';

  @override
  String get referralWorked => 'Код сработал. Монеты уже в кошельке.';

  @override
  String get refresh => 'Обновить';

  @override
  String get refreshStatus => 'Обновить статус';

  @override
  String get region => 'Регион';

  @override
  String get regionIndiaNote =>
      'Определено автоматически по SIM-карте или устройству. В Индии — индийские языки и цены в ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Определено автоматически по SIM-карте или устройству. Международные языки, цены в $currency.';
  }

  @override
  String get register => 'Регистрация';

  @override
  String get released => 'Выпущена';

  @override
  String get rematch => 'Реванш';

  @override
  String get rematchQuestion => 'Реванш?';

  @override
  String get remindMe => 'Напомнить перед матчем';

  @override
  String get reportButtonCaps => 'КНОПКА ЖАЛОБЫ';

  @override
  String get reportButtonHelp =>
      'В правом верхнем углу чата, рядом с «Остановить чат». Видна, пока чат включён.\nНажмите → выберите причину → добавьте детали и скриншоты → отправьте.';

  @override
  String get reportCaps => 'ЖАЛОБА';

  @override
  String get reportFailed => 'Не удалось отправить жалобу';

  @override
  String reportName(String name) {
    return 'Пожаловаться на $name';
  }

  @override
  String get reportOrBlock => 'Пожаловаться или заблокировать';

  @override
  String get reportOrBlockPlayer => 'Пожаловаться или заблокировать игрока';

  @override
  String get reportPlayer => 'Пожаловаться';

  @override
  String get requestSentCaps => 'ЗАПРОС ОТПРАВЛЕН';

  @override
  String requestSentTo(String name) {
    return 'Запрос отправлен: $name';
  }

  @override
  String get requests => 'Запросы';

  @override
  String requestsCount(String n) {
    return 'Запросы · $n';
  }

  @override
  String get requestsExpire7d => 'Запросы истекают через 7 дней без ответа.';

  @override
  String get resendCode => 'Отправить код снова';

  @override
  String get resendEmail => 'Отправить письмо снова';

  @override
  String get resetCode => 'Код сброса';

  @override
  String resetCodeSentTo(String target) {
    return 'Мы отправили код на $target.\nВведите его ниже — ссылку открывать не нужно.';
  }

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get resetPasswordBody =>
      'Введите почту — мы пришлём код сброса. Введите его в приложении, ссылку открывать не нужно.';

  @override
  String get restart => 'Начать заново';

  @override
  String get result => 'Итог';

  @override
  String get resume => 'Продолжить';

  @override
  String get returnToMainMenu => 'В главное меню';

  @override
  String get rewardEarnedCaps => 'НАГРАДА ПОЛУЧЕНА';

  @override
  String get rewardFlowOverview => 'Обзор наград';

  @override
  String rewardIn(String time) {
    return 'Награда через $time';
  }

  @override
  String get rivalO => 'Соперник: O';

  @override
  String get roomCancelled => 'Комната отменена';

  @override
  String roomClosesIn(String time) {
    return 'Комната закроется через $time, если никто не войдёт.';
  }

  @override
  String get roomClosesSoon => 'Комната скоро закроется, если никто не войдёт.';

  @override
  String get roomClosing => 'Комната закрывается…';

  @override
  String get roomCodeCaps => 'КОД КОМНАТЫ';

  @override
  String get roomCodeCopied => 'Код комнаты скопирован';

  @override
  String get roomExpired => 'Комната истекла';

  @override
  String get roomOpenCaps => 'КОМНАТА ОТКРЫТА';

  @override
  String get roundOf16 => '1/8 финала';

  @override
  String get roundOf16Caps => '1/8 ФИНАЛА';

  @override
  String roundOf16Vs(String name) {
    return '1/8 финала · против $name';
  }

  @override
  String get roundsWon => 'Выиграно раундов';

  @override
  String get row => 'Ряд';

  @override
  String get ruleEmoji =>
      '• Эмодзи-реакции работают без запроса, их можно заглушить.';

  @override
  String get ruleEnds => '• Чат завершается вместе с матчем.';

  @override
  String get ruleStop => '• Любой игрок может остановить чат в любой момент.';

  @override
  String get ruleVanish =>
      '• Сообщения исчезают через секунды и не сохраняются.';

  @override
  String get saveChanges => 'Сохранить';

  @override
  String get savePassword => 'Сохранить пароль';

  @override
  String get saving => 'Сохранение…';

  @override
  String get savingToCloud => 'Сохранение в облако…';

  @override
  String get scanOrShare => 'Отсканируйте или поделитесь ссылкой';

  @override
  String get scanQr => 'Сканировать QR';

  @override
  String get score => 'Очки';

  @override
  String get scorePlus10 => 'Очки +10';

  @override
  String get screenshotTooBig => 'Скриншот должен быть меньше 2 МБ';

  @override
  String get screenshotsOptionalCaps => 'СКРИНШОТЫ (НЕОБЯЗАТЕЛЬНО)';

  @override
  String get searchPlayersHint => 'Поиск по имени или ID игрока';

  @override
  String get searchResults => 'Результаты поиска';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'Онлайн · $size · ставка $stake · $time';
  }

  @override
  String get seatWaiting => 'Игрок, ваше место ждёт.';

  @override
  String secondsLeft(String seconds) {
    return 'Осталось $seconds с';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'Осталось $seconds с на ответ';
  }

  @override
  String get selectDifficulty => 'Выберите сложность';

  @override
  String get selectOpponent => 'Выберите соперника';

  @override
  String get selectReportReason => 'Выберите причину жалобы';

  @override
  String get semi => '1/2';

  @override
  String get send => 'Отправить';

  @override
  String get sendChallenge => 'Отправить вызов';

  @override
  String get sendResetCode => 'Отправить код';

  @override
  String get sending => 'Отправка…';

  @override
  String get sendingMove => 'Отправка хода…';

  @override
  String get sent => 'Отправлено';

  @override
  String serverTournamentsDemo(String error) {
    return 'Серверные турниры недоступны — показываем демо.\n$error';
  }

  @override
  String get sessionExpiredReset => 'Сессия истекла — запросите новый код';

  @override
  String get settings => 'Настройки';

  @override
  String get shareComingSoon => 'Скоро можно будет поделиться';

  @override
  String get shareInviteCaps => 'ПОДЕЛИТЬСЯ ПРИГЛАШЕНИЕМ';

  @override
  String get shareOnWhatsApp => 'Поделиться в WhatsApp';

  @override
  String get shareProfile => 'Поделиться профилем';

  @override
  String shareWin(String url) {
    return 'Я только что выиграл матч в DROTIX! Сможешь меня победить? Играй: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'Я только что обыграл $name в DROTIX! Сможешь меня победить? Играй: $url';
  }

  @override
  String get shop => 'Магазин';

  @override
  String get showHidePassword => 'Показать или скрыть пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get signInChangePhoto => 'Войдите, чтобы сменить фото';

  @override
  String get signInFindFriends => 'Войдите, чтобы искать друзей';

  @override
  String get signInMatchmaking => 'Для онлайн-подбора нужно войти';

  @override
  String get signInNotifications => 'Войдите, чтобы увидеть уведомления';

  @override
  String get signInOnline => 'Войдите, чтобы играть онлайн';

  @override
  String get signInRandomMatch =>
      'Войдите, чтобы играть случайные матчи с реальными игроками';

  @override
  String get signInRequired => 'Нужно войти';

  @override
  String get signInSearchPlayers =>
      'Войдите, чтобы искать игроков и синхронизировать друзей.';

  @override
  String get signInToAddFriends => 'Войдите, чтобы добавлять друзей';

  @override
  String get signInToChallenge => 'Войдите, чтобы вызвать игрока';

  @override
  String get signInWalletHistory => 'Войдите, чтобы увидеть историю кошелька.';

  @override
  String get signInWithEmail => 'Войти по почте';

  @override
  String get signOut => 'Выйти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get skip => 'Пропустить';

  @override
  String get skipForNow => 'Пропустить';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Что-то пошло не так: $error';
  }

  @override
  String get soundDisabled => 'Звук выключен';

  @override
  String get soundEffects => 'Звуковые эффекты';

  @override
  String get soundEnabled => 'Звук включён';

  @override
  String get spent => 'Потрачено';

  @override
  String get sponsored => 'Реклама';

  @override
  String stakeDot(String n) {
    return 'Ставка · $n';
  }

  @override
  String get stakeReturned => 'Ставка возвращена';

  @override
  String stakeRoom(String stake, String room) {
    return 'Ставка $stake · $room…';
  }

  @override
  String get start => 'Начать';

  @override
  String get startPlayingCaps => 'НАЧАТЬ ИГРУ';

  @override
  String get starterPack => 'Стартовый набор';

  @override
  String get starting => 'Запуск…';

  @override
  String get startsInCaps => 'НАЧАЛО ЧЕРЕЗ';

  @override
  String get stats => 'Статистика';

  @override
  String statusLabel(String status) {
    return 'Статус: $status';
  }

  @override
  String get stayInApp =>
      'Не закрывайте приложение. Мы сообщим, когда матч будет готов.';

  @override
  String get stillOffline =>
      'Всё ещё офлайн. Проверьте подключение и попробуйте снова.';

  @override
  String get stopChat => 'Остановить чат';

  @override
  String get submitAppeal => 'Подать апелляцию';

  @override
  String get submitReportCaps => 'ОТПРАВИТЬ ЖАЛОБУ';

  @override
  String submittedAt(String date) {
    return 'Отправлена: $date';
  }

  @override
  String get submitting => 'Отправка…';

  @override
  String get submittingCaps => 'ОТПРАВКА…';

  @override
  String get supportEmail => 'Почта поддержки';

  @override
  String suspendedAt(String date) {
    return 'Заблокирован: $date';
  }

  @override
  String get suspendedByModerator =>
      'Модератор заблокировал аккаунт после проверки жалобы.';

  @override
  String get suspendedRules =>
      'Во время блокировки нельзя играть, входить в комнаты и пользоваться чатом. Можно подать одну апелляцию.';

  @override
  String get t20Seconds => '20 секунд на ход';

  @override
  String get tDrawReplays => 'Ничья — раунд переигрывается';

  @override
  String get tSingleElim => 'Олимпийская система: проиграл — выбыл';

  @override
  String get tSingleElimFee =>
      'Олимпийская система. Проиграли раунд — выбыли, взнос не возвращается.';

  @override
  String get tagline => 'Самая опасная маленькая игра';

  @override
  String get takeTurnsBody =>
      'Вы и соперник по очереди ставите по одному знаку. Нажмите на пустую клетку, чтобы сходить.';

  @override
  String get takeTurnsCaps => 'ХОДИТЕ ПО ОЧЕРЕДИ';

  @override
  String get takesFewSeconds => 'Обычно это занимает несколько секунд.';

  @override
  String get tapEmptySquare => 'Нажмите на пустую клетку';

  @override
  String get tbd => 'Не определён';

  @override
  String get tellUsMin10 => 'Опишите, что произошло (не менее 10 символов)';

  @override
  String get termsAccountBody =>
      'Храните данные для входа в безопасности. Вы отвечаете за действия в аккаунте.';

  @override
  String get termsAccountTitle => '2. Ваш аккаунт';

  @override
  String get termsChangesBody =>
      'Мы можем обновлять условия. Продолжая пользоваться, вы их принимаете.';

  @override
  String get termsChangesTitle => '5. Изменения';

  @override
  String get termsCoinsBody =>
      'Монеты — виртуальные предметы без денежной ценности, их нельзя обменять на деньги.';

  @override
  String get termsCoinsTitle => '3. Виртуальные монеты';

  @override
  String get termsFairBody =>
      'Никакого читерства, оскорблений и травли. Нарушителей мы можем заблокировать.';

  @override
  String get termsFairTitle => '4. Честная игра и чат';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get termsUsingBody => 'Соблюдайте эти условия и играйте честно.';

  @override
  String get termsUsingTitle => '1. Использование DROTIX';

  @override
  String get theirTurnCaps => 'ХОД СОПЕРНИКА';

  @override
  String get threeInRowBody =>
      'Выстройте три знака в ряд, столбец или по диагонали раньше соперника.';

  @override
  String get threeInRowCaps => 'ТРИ В РЯД';

  @override
  String timeDaysAgo(String n) {
    return '$n дн назад';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n ч назад';
  }

  @override
  String get timeJustNow => 'Только что';

  @override
  String timeMinutesAgo(String n) {
    return '$n мин назад';
  }

  @override
  String get timeSkipped => 'Время вышло — ход пропускается.';

  @override
  String timesUp(String who) {
    return 'Время вышло · $who';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get todayCaps => 'СЕГОДНЯ';

  @override
  String get top16 => 'Топ-16';

  @override
  String get totalCoinsCaps => 'ВСЕГО МОНЕТ';

  @override
  String get tournament => 'Турнир';

  @override
  String get tryAgain => 'Повторить';

  @override
  String get tryAgainCaps => 'ПОВТОРИТЬ';

  @override
  String get twoPlayers => 'Два игрока, один телефон';

  @override
  String get txChallengeEntry => 'Взнос за вызов';

  @override
  String get txCoinPurchase => 'Покупка монет';

  @override
  String txDailyBonus(String time) {
    return 'Ежедневный бонус · $time';
  }

  @override
  String get txDailyReward => 'Ежедневная награда';

  @override
  String get txFreeVideo => 'Награда за видео';

  @override
  String get txMatchWin => 'Победа в матче';

  @override
  String txPurchasing(String time) {
    return 'Покупка монет · $time';
  }

  @override
  String txReferral(String time) {
    return 'Реферальный код · $time';
  }

  @override
  String txTournament(String time) {
    return 'Турнир · $time';
  }

  @override
  String get txTournamentPrize => 'Приз турнира';

  @override
  String txWatchingAds(String time) {
    return 'Просмотр рекламы · $time';
  }

  @override
  String get txWelcomeBonus => 'Приветственный бонус';

  @override
  String txWinning(String time) {
    return 'Победы в матчах · $time';
  }

  @override
  String get typeMessage => 'Введите сообщение';

  @override
  String get unblockPlayer => 'Разблокировать';

  @override
  String get unblockToAdd => 'Разблокируйте игрока, чтобы добавить';

  @override
  String get unblockToChallenge => 'Разблокируйте игрока, чтобы вызвать';

  @override
  String unlockFor(String n) {
    return 'Открыть · $n монет';
  }

  @override
  String get unlocked => 'Открыто';

  @override
  String unlockedCount(String n, String total) {
    return 'Открыто $n из $total';
  }

  @override
  String get unranked => 'Без рейтинга';

  @override
  String get upTo3Images => 'До 3 изображений. Их видит только наша команда.';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get updateFailed => 'Не удалось обновить';

  @override
  String get updateOnAppStore => 'Обновить в App Store';

  @override
  String get updateRequired => 'Требуется обновление';

  @override
  String get updatesOnlyMobile => 'Обновления доступны на Android и iOS.';

  @override
  String get useChatReport =>
      'Для жалоб с доказательствами используйте Чат → Жалоба во время матча.';

  @override
  String get username => 'Имя пользователя';

  @override
  String get usernameHint => 'Имя (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Проверить код';

  @override
  String get verifyFailBody =>
      'Так бывает при слабом соединении или если награда уже получена. Ваши монеты в безопасности.';

  @override
  String get verifying => 'Проверка…';

  @override
  String get verifyingReward => 'Проверяем награду';

  @override
  String versionLabel(String version) {
    return 'Версия $version';
  }

  @override
  String get versionUnsupported =>
      'Эта версия больше не поддерживается. Обновитесь, чтобы играть дальше.';

  @override
  String get vibration => 'Вибрация';

  @override
  String get victory => 'ПОБЕДА';

  @override
  String get videoLength =>
      'Видео длится 15–30 секунд. Досмотрите до конца, чтобы получить монеты.';

  @override
  String get videos => 'Видео';

  @override
  String get viewAppealStatus => 'Статус апелляции';

  @override
  String get viewBracket => 'Турнирная сетка';

  @override
  String get viewBracketCaps => 'СЕТКА';

  @override
  String get viewProfile => 'Профиль';

  @override
  String vsName(String name) {
    return 'против $name';
  }

  @override
  String get waitingCaps => 'ОЖИДАНИЕ';

  @override
  String waitingForAccept(String name) {
    return 'Ждём, пока $name примет…';
  }

  @override
  String get waitingForFriend => 'Ждём друга...';

  @override
  String get waitingOtherMatches => 'Ждём другие матчи';

  @override
  String get waitingRoundOpen => 'Ждём начала раунда';

  @override
  String get wallet => 'Кошелёк';

  @override
  String get walletBalance => 'Баланс кошелька';

  @override
  String get walletCaps => 'КОШЕЛЁК';

  @override
  String get walletUnavailable => 'Кошелёк недоступен';

  @override
  String watchAnotherLeft(String n) {
    return 'ЕЩЁ ОДНО (ОСТАЛОСЬ $n)';
  }

  @override
  String get watchBracketCaps => 'СМОТРЕТЬ СЕТКУ';

  @override
  String get watchFullVideo =>
      'Досмотрите видео до конца, чтобы получить бонусные монеты.';

  @override
  String get watchNowCaps => 'СМОТРЕТЬ';

  @override
  String get watchShortVideo => 'Посмотрите короткое видео';

  @override
  String watchShortVideoToGet(String n) {
    return 'Посмотрите короткое видео и получите +$n';
  }

  @override
  String get watchVideo => 'СМОТРЕТЬ ВИДЕО';

  @override
  String get watchVideoCoins => 'Посмотрите видео — получите 10 монет';

  @override
  String get weekly => 'Еженедельно';

  @override
  String get weeklyChest => 'Еженедельный сундук';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get welcomeBonusCaps => 'ПРИВЕТСТВЕННЫЙ БОНУС';

  @override
  String welcomeName(String name) {
    return 'Добро пожаловать, $name';
  }

  @override
  String get whatHappenedCaps => 'ЧТО СЛУЧИЛОСЬ';

  @override
  String get whatHappenedHint =>
      'Опишите, что произошло и почему вы жалуетесь на игрока';

  @override
  String get whatsNewCaps => 'ЧТО НОВОГО';

  @override
  String get whoCanChallenge => 'Кто может вас вызвать';

  @override
  String get whoCanMessage => 'Кто может писать вам';

  @override
  String get winRate => 'Процент побед';

  @override
  String get winner => 'ПОБЕДИТЕЛЬ';

  @override
  String get wins => 'Победы';

  @override
  String winsThisRound(String name) {
    return '$name выигрывает этот раунд.';
  }

  @override
  String get yesDelete => 'Да, удалить';

  @override
  String get yesterday => 'Вчера';

  @override
  String get yesterdayCaps => 'ВЧЕРА';

  @override
  String get you => 'Вы';

  @override
  String youBeat(String name) {
    return 'Вы обыграли $name.';
  }

  @override
  String get youFinished => 'Ваше место';

  @override
  String get youLose => 'Вы проиграли';

  @override
  String youMark(String mark) {
    return 'Вы · $mark';
  }

  @override
  String get youWin => 'Вы победили!';

  @override
  String get youWinCaps => 'ВЫ ПОБЕДИЛИ';

  @override
  String get youX => 'Вы: X';

  @override
  String yourBalance(String n) {
    return 'Ваш баланс: $n монет';
  }

  @override
  String get yourEmail => 'вашу почту';

  @override
  String get yourMatchReadyCaps => 'ВАШ МАТЧ ГОТОВ';

  @override
  String get yourMove => 'Ваш ход';

  @override
  String get yourNextMatch => 'Ваш следующий матч';

  @override
  String get yourTurnCaps => 'ВАШ ХОД';

  @override
  String get youreInCaps => 'ВЫ В ИГРЕ';

  @override
  String get youreInViewBracket => 'ВЫ УЧАСТВУЕТЕ — СЕТКА';

  @override
  String get youreOffline => 'Вы офлайн';
}
