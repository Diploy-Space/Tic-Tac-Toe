// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX ist ein schnelles, kompetitives Drei-in-einer-Reihe-Spiel. Spiele gegen den Computer, tritt gegen echte Spieler an, fordere Freunde heraus und steige in der Rangliste auf.';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get accept => 'Annehmen';

  @override
  String get acceptCaps => 'ANNEHMEN';

  @override
  String get acceptRequestCaps => 'ANFRAGE ANNEHMEN';

  @override
  String get accountCheckFailed => 'Kontoprüfung fehlgeschlagen';

  @override
  String get accountIsSuspended => 'Dein Konto ist gesperrt.';

  @override
  String get accountRestricted =>
      'Dein Konto bleibt eingeschränkt, bis ein Moderator die Prüfung abschließt. Spiel, Matchmaking und Chat bleiben gesperrt.';

  @override
  String get accountStatusUnknown =>
      'Kontostatus unbekannt. Versuche es erneut.';

  @override
  String get accountSuspended => 'Konto gesperrt';

  @override
  String get accountSuspendedSignIn =>
      'Dein Konto wurde gesperrt. Melde dich an, um Details zu sehen oder Einspruch einzulegen.';

  @override
  String get accountSuspendedTitle => 'Dein Konto wurde gesperrt';

  @override
  String get ach100Wins => '100 Siege';

  @override
  String get ach10Matches => '10 Spiele';

  @override
  String get ach50Matches => '50 Spiele';

  @override
  String get achChallenger => 'Herausforderer';

  @override
  String get achChampion => 'Champion';

  @override
  String get achFirstWin => 'Erster Sieg';

  @override
  String get achScore100 => '100 Punkte';

  @override
  String get achStreak3 => '3er-Serie';

  @override
  String get achStreak5 => '5er-Serie';

  @override
  String get achSurvivor => 'Überlebender';

  @override
  String get achTop3 => 'Top 3';

  @override
  String get achievements => 'Erfolge';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addFriend => 'Freund hinzufügen';

  @override
  String get addFriendCaps => 'FREUND HINZUFÜGEN';

  @override
  String get advanceQuarter => 'Du stehst im Viertelfinale';

  @override
  String get advancedMode => 'Fortgeschritten (4×4)';

  @override
  String get advertiserApp => 'App des Werbetreibenden';

  @override
  String get advertiserVideo => 'Hier läuft das Werbevideo';

  @override
  String get all => 'Alle';

  @override
  String get allowAndInstall => 'Erlauben & installieren';

  @override
  String get allowUnknownApps =>
      'Erlaube „Unbekannte Apps installieren“ für DROTIX und kehre zurück. Das Update installiert sich automatisch.';

  @override
  String get alreadyPlayer => 'Schon dabei?';

  @override
  String get alsoBlock => 'Diesen Spieler auch blockieren';

  @override
  String get alwaysTrue => 'Gilt immer';

  @override
  String get appUpdate => 'App-Update';

  @override
  String get appealExplain =>
      'Erkläre, warum dein Konto wieder freigeschaltet werden sollte. Ein Moderator prüft deine Nachricht.';

  @override
  String get appealFailed => 'Einspruch fehlgeschlagen';

  @override
  String get appealHint => 'Schreibe deinen Einspruch (mind. 20 Zeichen)…';

  @override
  String get appealIsUnderReview => 'Dein Einspruch wird geprüft.';

  @override
  String get appealMin20 => 'Der Einspruch braucht mindestens 20 Zeichen';

  @override
  String get appealSubmitted => 'Einspruch erfolgreich eingereicht';

  @override
  String get appealSuspension => 'Gegen Sperre Einspruch einlegen';

  @override
  String get appealUnderReview => 'Einspruch wird geprüft';

  @override
  String get applyCodeCaps => 'CODE EINLÖSEN';

  @override
  String get attachRecentChat => 'Letzte Chatnachrichten anhängen';

  @override
  String get attemptingReconnect => 'Verbindung wird wiederhergestellt…';

  @override
  String get auto => 'Auto';

  @override
  String get avatars => 'Avatare';

  @override
  String get back => 'Zurück';

  @override
  String get backToEvent => 'Zurück zum Event';

  @override
  String get backToEvents => 'Zurück zu den Events';

  @override
  String get backToEventsCaps => 'ZURÜCK ZU DEN EVENTS';

  @override
  String get backToHome => 'Zurück zum Start';

  @override
  String get backToMenu => 'Zurück zum Menü';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String balance(String n) {
    return 'Guthaben $n';
  }

  @override
  String get balanceAfter => 'Guthaben danach';

  @override
  String balanceArrow(String from) {
    return 'Guthaben $from →';
  }

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get bestValue => 'Bester Wert';

  @override
  String get biggerBoardsBody =>
      'Auf größeren Feldern brauchst du vier in einer Reihe. Ist das Feld ohne Reihe voll, ist es unentschieden.';

  @override
  String get biggerBoardsCaps => 'GRÖSSERE FELDER';

  @override
  String get biggerNeedFour => 'Größere Felder brauchen vier in einer Reihe';

  @override
  String get blockPlayer => 'Spieler blockieren';

  @override
  String get boardHiddenUntilBack =>
      'Das Spielfeld ist ausgeblendet, bis du zurück bist.';

  @override
  String get boards => 'Spielfelder';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n Münzen zu deinem Wallet hinzugefügt';
  }

  @override
  String get bonusClaimed => 'Bonus erhalten!';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n Bonusmünzen hinzugefügt';
  }

  @override
  String get bracket => 'Turnierbaum';

  @override
  String get bracketInfo =>
      'Achtelfinale · 8 Spiele, 4 angezeigt. Du bist hervorgehoben.';

  @override
  String get buyCoinsCaps => 'MÜNZEN KAUFEN';

  @override
  String get byBoard => 'Nach Brett';

  @override
  String get cameraOnlyForScan =>
      'Die Kamera wird nur zum Scannen des Codes genutzt.';

  @override
  String get cameraPermissionNeeded =>
      'Zum Scannen wird die Kamera benötigt. Du kannst den Code auch unten eingeben.';

  @override
  String get cameraPermissionRequired =>
      'Zum Scannen des Raum-QR-Codes wird die Kamera benötigt. Aktiviere sie in den Systemeinstellungen und versuche es erneut.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancelChallenge => 'Herausforderung abbrechen';

  @override
  String get cancelDownload => 'Download abbrechen';

  @override
  String get cannotChallengeSelf => 'Du kannst dich nicht selbst herausfordern';

  @override
  String get cannotFriendSelf => 'Du kannst dich nicht selbst hinzufügen';

  @override
  String get cantChallengeNow =>
      'Du kannst diesen Spieler gerade nicht herausfordern.';

  @override
  String get challenge => 'Herausforderung';

  @override
  String get challengeAccepted => 'Herausforderung angenommen';

  @override
  String get challengeCancelled => 'Herausforderung abgebrochen';

  @override
  String get challengeCaps => 'HERAUSFORDERN';

  @override
  String get challengeClosed => 'Herausforderung beendet';

  @override
  String get challengeDeclined => 'Herausforderung abgelehnt';

  @override
  String get challengeExpired => 'Herausforderung abgelaufen';

  @override
  String get challengeExpiresIn60 =>
      'Die Herausforderung läuft nach 60 Sekunden ab, wenn sie nicht angenommen wird.';

  @override
  String get challengePrivacy => 'Privatsphäre bei Herausforderungen';

  @override
  String get challengeRequests => 'Herausforderungsanfragen';

  @override
  String get challengeSentCoins => 'Herausforderung gesendet · 5 Münzen';

  @override
  String get challengeSentFree => 'Herausforderung gesendet · Gratis-Spiel';

  @override
  String get challenges => 'Herausforderungen';

  @override
  String get championCaps => 'CHAMPION';

  @override
  String get change => 'Ändern';

  @override
  String get chat => 'Chat';

  @override
  String get chatAfterAccept => 'Chat, nachdem beide zugestimmt haben.';

  @override
  String get chatAfterAcceptRandom =>
      'Chat, nachdem beide zugestimmt haben. Nur der Name wird geteilt.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name nimmt nur Nachrichten von Freunden an.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name hat Nachrichten deaktiviert.';
  }

  @override
  String get chatNotConnected => 'Chat ist nicht verbunden';

  @override
  String get chatOn => 'Chat an';

  @override
  String get chatPrivacyNote =>
      'Gilt für den Chat im Spiel. Änderungen wirken sofort, auch während eines Matches.';

  @override
  String get chatRules => 'Chat-Regeln';

  @override
  String get chatRulesIntro =>
      'Der Text-Chat startet nie von selbst. Ein Spieler fragt, der andere muss zustimmen.';

  @override
  String get checkAgainCaps => 'ERNEUT PRÜFEN';

  @override
  String get checkEmail => 'E-Mail prüfen';

  @override
  String get checkEmailConfirm =>
      'Sieh in deine E-Mails und öffne den Bestätigungslink';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkInbox => 'Sieh in deinen Posteingang';

  @override
  String get checking => 'Wird geprüft…';

  @override
  String get chooseEntryStake => 'Einsatz wählen';

  @override
  String get chooseGameMode => 'Spielmodus wählen';

  @override
  String get chooseNewPassword => 'Neues Passwort wählen';

  @override
  String get chooseOpponent => 'Gegner wählen';

  @override
  String get claim => 'HOLEN';

  @override
  String claimBonusCoins(String n) {
    return '$n Bonusmünzen holen';
  }

  @override
  String get claimLabel => 'Abholen';

  @override
  String claimPlusCoins(String n) {
    return '+$n Münzen abholen';
  }

  @override
  String get claimVictory => 'Sieg beanspruchen';

  @override
  String get claimsSync => 'Abholungen werden mit deinem Konto synchronisiert';

  @override
  String get classicMode => 'Klassisch (3×3)';

  @override
  String get clearAll => 'Alle löschen';

  @override
  String get clipboardNoCode => 'Kein Raumcode in der Zwischenablage';

  @override
  String get close => 'Schließen';

  @override
  String get closeAndLose => 'Schließen und Belohnung verlieren';

  @override
  String get closeRoom => 'Raum schließen';

  @override
  String get closing => 'Wird geschlossen…';

  @override
  String get cloud => 'Cloud';

  @override
  String cloudSaveFailed(String message) {
    return 'Cloud-Speichern fehlgeschlagen: $message';
  }

  @override
  String get codeSent => 'Code gesendet';

  @override
  String get coinPacks => 'Münzpakete';

  @override
  String coinPacksFrom(String price) {
    return 'PAKETE AB $price';
  }

  @override
  String get coins5 => '5 Münzen';

  @override
  String coinsAdded(String n) {
    return '+$n Münzen hinzugefügt';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Münzen $delta · Guthaben $balance';
  }

  @override
  String get coinsEntryFee => '5 Münzen Startgeld';

  @override
  String get coinsEntryFeeBody =>
      'Wird genutzt, wenn die Gratis-Spiele aufgebraucht sind, oder um den Einsatz zu erhöhen.';

  @override
  String coinsLabel(String n) {
    return '$n Münzen';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n Münzen (in der Cloud gespeichert)';
  }

  @override
  String get column => 'Spalte';

  @override
  String get comeBackTomorrow => 'Komm morgen wieder';

  @override
  String get completeGoogleReturnApp =>
      'Schließe die Google-Anmeldung ab und kehre zur App zurück';

  @override
  String get completeGoogleSignIn =>
      'Schließe die Google-Anmeldung ab und kehre zurück';

  @override
  String get computer => 'Computer';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get confirmJoinCaps => 'BESTÄTIGEN & BEITRETEN';

  @override
  String confirmLinkSentTo(String target) {
    return 'Wir haben einen Bestätigungslink an $target gesendet.\nÖffne ihn auf diesem Gerät und kehre zurück – du wirst automatisch angemeldet.';
  }

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get confirmationEmailSent =>
      'Bestätigungs-E-Mail gesendet – sieh im Posteingang nach';

  @override
  String get confirmingVideo =>
      'Wir bestätigen, dass das Video angesehen wurde. Bitte warten.';

  @override
  String get connectingChat => 'Chat wird verbunden…';

  @override
  String get connectionUnstable => 'Verbindung instabil';

  @override
  String get connectionUnstableCaps => 'VERBINDUNG INSTABIL';

  @override
  String get contactAbout => 'Kontakt & Info';

  @override
  String get contactUsCaps => 'KONTAKT';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get continuePlaying => 'Weiterspielen';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String copiedValue(String label, String value) {
    return '$label kopiert: $value';
  }

  @override
  String get couldNotAddCoins => 'Münzen konnten nicht hinzugefügt werden';

  @override
  String get couldNotApplyReferral => 'Code konnte nicht eingelöst werden';

  @override
  String couldNotCheck(String error) {
    return 'Prüfung fehlgeschlagen: $error';
  }

  @override
  String get couldNotJoinRoom => 'Beitritt zum Raum fehlgeschlagen';

  @override
  String get couldNotLoadPrivacy => 'Datenschutz-Einstellungen nicht geladen';

  @override
  String get couldNotLoadProfile =>
      'Profil konnte nicht geladen werden. Versuche es erneut.';

  @override
  String get couldNotOpenGoogle =>
      'Google-Anmeldung konnte nicht geöffnet werden';

  @override
  String get couldNotSavePrivacy =>
      'Datenschutz-Einstellungen nicht gespeichert';

  @override
  String get couldNotStopChat => 'Chat konnte nicht beendet werden';

  @override
  String get couldNotSubmitAppeal => 'Einspruch konnte nicht gesendet werden';

  @override
  String get couldNotVerify => 'Wir konnten es nicht bestätigen';

  @override
  String get couldNotVerifyAccount =>
      'Kontostatus konnte nicht geprüft werden. Versuche es erneut.';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get createPrivateRoom => 'Privaten Raum erstellen';

  @override
  String get customize => 'Anpassen';

  @override
  String get daily => 'Täglich';

  @override
  String get dailyChest => 'Tägliche Truhe';

  @override
  String get dailyLimit => 'TAGESLIMIT ERREICHT';

  @override
  String get date => 'Datum';

  @override
  String dayN(String n) {
    return 'Tag $n';
  }

  @override
  String dayStreak(String n) {
    return '$n-Tage-Serie';
  }

  @override
  String get days30 => '30 Tage';

  @override
  String get days7 => '7 Tage';

  @override
  String get debitFailed => 'Münzen konnten nicht abgebucht werden';

  @override
  String get declineCaps => 'ABLEHNEN';

  @override
  String get defeat => 'NIEDERLAGE';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountBody =>
      'Dadurch werden deine Münzen, dein Punktestand und dein Verlauf endgültig gelöscht.';

  @override
  String get deleteAccountQuestion => 'Konto löschen?';

  @override
  String get descriptionMin10 =>
      'Die Beschreibung braucht mindestens 10 Zeichen';

  @override
  String get diagonal => 'Diagonale';

  @override
  String get difficultyEasy => 'Leicht';

  @override
  String get difficultyHard => 'Schwer';

  @override
  String get difficultyMedium => 'Mittel';

  @override
  String get doll => 'Puppe';

  @override
  String get done => 'Erledigt';

  @override
  String get downloadAndInstall => 'Herunterladen & installieren';

  @override
  String get downloading => 'Wird heruntergeladen…';

  @override
  String downloadingPercent(String percent) {
    return 'Wird geladen $percent %';
  }

  @override
  String get draw => 'Unentschieden';

  @override
  String get drawBadge => 'UNENTSCHIEDEN';

  @override
  String get draws => 'Remis';

  @override
  String get duration => 'Zeitraum';

  @override
  String get earned => 'Verdient';

  @override
  String get earnedThisWeek => 'Diese Woche verdient, nach Quelle';

  @override
  String get editProfileCaps => 'PROFIL BEARBEITEN';

  @override
  String get eliminatedCaps => 'AUSGESCHIEDEN';

  @override
  String get email => 'E-Mail';

  @override
  String get emailNotConfirmed => 'E-Mail nicht bestätigt';

  @override
  String emailNotConfirmedBody(String email) {
    return 'Deine Registrierung hat geklappt, aber deine E-Mail ist noch nicht bestätigt.\n\nÖffne den Bestätigungslink im Posteingang oder Spam und melde dich dann erneut an.\n\n$email';
  }

  @override
  String get emailSentAgain =>
      'E-Mail erneut gesendet – sieh im Posteingang nach';

  @override
  String get endsIn => 'Endet in';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String get enterCodeFromEmail => 'Gib den Code aus deiner E-Mail ein';

  @override
  String get enterCodeInstead => 'Stattdessen Code eingeben';

  @override
  String get enterEmailPassword => 'E-Mail und Passwort eingeben';

  @override
  String get enterFullCode => 'Gib den vollständigen Raumcode ein';

  @override
  String get enterReferralOrSkip =>
      'Gib einen Empfehlungscode ein oder überspringe vorerst';

  @override
  String get enterResetCode => 'Reset-Code eingeben';

  @override
  String get enterValidMobile => 'Gib eine gültige Handynummer ein';

  @override
  String get enterValidReferral => 'Gib einen gültigen Empfehlungscode ein';

  @override
  String get enterYourEmail => 'Gib deine E-Mail ein';

  @override
  String get entry => 'Startgeld';

  @override
  String get entryFee => 'Startgebühr';

  @override
  String get equip => 'Ausrüsten';

  @override
  String get equipped => 'Ausgerüstet';

  @override
  String get events => 'Events';

  @override
  String get everyone => 'Alle';

  @override
  String get expertMode => 'Experte (5×5)';

  @override
  String get expiredMoveToHistory =>
      'Abgelaufene Herausforderungen landen im Verlauf.';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get fillAllFields => 'Alle Felder ausfüllen';

  @override
  String get finalRound => 'Finale';

  @override
  String get findAMatch => 'Spiel suchen';

  @override
  String get findOpponent => 'Gegner finden';

  @override
  String get findPrivateJoin => 'Suchen · privater Raum · Code';

  @override
  String get findingOpponent => 'Gegner wird gesucht';

  @override
  String get findingPlayer => 'Spieler wird gesucht';

  @override
  String get firstMatchSet =>
      'Dein erstes Match wird festgelegt, wenn die Runde startet.';

  @override
  String get fiveOfFiveWatched => '5 von 5 Videos angesehen';

  @override
  String get flash => 'Blitz';

  @override
  String get flashUnavailable => 'Blitz nicht verfügbar';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen';

  @override
  String get free => 'Gratis';

  @override
  String get freeCoins => 'GRATIS-MÜNZEN';

  @override
  String get freeMatch => 'Gratis-Spiel';

  @override
  String get freeMatchesPerDay => '3 Gratis-Spiele pro Tag';

  @override
  String get freeVideosToday => 'Gratis-Videos heute';

  @override
  String freeVideosUsed(String used) {
    return '$used von 5 Gratis-Videos heute genutzt';
  }

  @override
  String get friendChallenge => 'Freundes-Herausforderung';

  @override
  String get friendRequestExists => 'Freundschaftsanfrage existiert bereits';

  @override
  String friendRequestSent(String name) {
    return 'Freundschaftsanfrage an $name gesendet';
  }

  @override
  String get friendRequestSentShort => 'Freundschaftsanfrage gesendet';

  @override
  String get friendsCaps => 'FREUNDE';

  @override
  String get friendsLabel => 'Freunde';

  @override
  String get friendsOnly => 'Nur Freunde';

  @override
  String get fromPhoto => 'Aus Foto';

  @override
  String gameComingSoon(String game) {
    return '$game: bald verfügbar';
  }

  @override
  String get gameOver => 'Spiel vorbei';

  @override
  String get gamePaused => 'Spiel pausiert';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get gettingVideo => 'Dein Video wird geladen…';

  @override
  String get goToMatchCaps => 'ZUM MATCH';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get graceWindowEnded =>
      'Die 30-Sekunden-Frist ist abgelaufen. Du kannst den Sieg beanspruchen.';

  @override
  String greatRun(String name) {
    return 'Starker Auftritt bei $name';
  }

  @override
  String get guard => 'Wächter';

  @override
  String get guest => 'Gast';

  @override
  String get history => 'Verlauf';

  @override
  String get historyNeverPublic =>
      'Dein Spielverlauf und deine Aktivität erscheinen nie im öffentlichen Profil.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches Spiele · $wins Siege · $losses Niederlagen · $draws Remis';
  }

  @override
  String get howItWorks => 'So funktioniert\'s';

  @override
  String get howToPlay => 'Spielanleitung';

  @override
  String get howToPlayRules =>
      'Bring drei deiner Zeichen in eine Reihe – waagerecht, senkrecht oder diagonal – bevor es dein Gegner tut. Auf größeren Feldern brauchst du vier.';

  @override
  String howToPlayStep(String n) {
    return 'SO GEHT\'S · $n/3';
  }

  @override
  String get imReadyCaps => 'ICH BIN BEREIT';

  @override
  String get imageTooBig => 'Bild muss kleiner als 2 MB sein';

  @override
  String get install => 'Installieren';

  @override
  String get installUpdate => 'Update installieren';

  @override
  String get installed => 'Installiert';

  @override
  String get internetRequired =>
      'Internetverbindung erforderlich. Offline kannst du weiterhin gegen The Doll spielen.';

  @override
  String get introBody1 => 'Besiege die KI auf 3×3-, 4×4- oder 5×5-Feldern.';

  @override
  String get introBody2 =>
      'Zufallsspiele gegen echte Spieler. Münzen setzen, Münzen gewinnen.';

  @override
  String get introBody3 =>
      'Tägliche Belohnungen, Missionen und Turniere bringen dich weiter nach oben.';

  @override
  String get introTitle1 => 'Überliste die Puppe';

  @override
  String get introTitle2 => 'Fordere die Welt heraus';

  @override
  String get introTitle3 => 'Steige in der Rangliste auf';

  @override
  String get invalidRoomQr => 'Ungültiger Raum-QR';

  @override
  String get inviteImage => 'Einladungsbild';

  @override
  String get inviteImageBody =>
      'Code, QR und Link in einem Bild. Per WhatsApp oder überallhin senden.';

  @override
  String isThinking(String name) {
    return '$name überlegt';
  }

  @override
  String get joinCaps => 'BEITRETEN';

  @override
  String joinForCoins(String n) {
    return 'FÜR $n MÜNZEN BEITRETEN';
  }

  @override
  String get joinRoomCaps => 'RAUM BEITRETEN';

  @override
  String get joinTheGame => 'Mach mit';

  @override
  String joinTournamentQuestion(String name) {
    return '$name beitreten?';
  }

  @override
  String get joinWithCode => 'Mit Code beitreten';

  @override
  String get joined => 'Angemeldet';

  @override
  String get joiningCaps => 'BEITRITT…';

  @override
  String get joiningQueue => 'Warteschlange wird betreten…';

  @override
  String get joiningRoom => 'Raum wird betreten…';

  @override
  String get keepWatchingCaps => 'WEITERSCHAUEN';

  @override
  String get language => 'Sprache';

  @override
  String get languageUpdated => 'Sprache aktualisiert';

  @override
  String get last20Sent =>
      'Die letzten 20 Nachrichten werden mit deiner Meldung gesendet.';

  @override
  String get last7Games => 'Letzte 7 Spiele';

  @override
  String lastUpdated(String date) {
    return 'Zuletzt aktualisiert: $date';
  }

  @override
  String get later => 'Später';

  @override
  String get latestVersion => 'Du nutzt die neueste Version.';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get leaderboardUpdated => 'Rangliste aktualisiert';

  @override
  String get leave => 'Verlassen';

  @override
  String get leaveForfeitBody =>
      'Wenn du jetzt gehst, zählt das als Aufgabe. Dein Gegner gewinnt.';

  @override
  String get leaveGame => 'Spiel verlassen';

  @override
  String get leaveMatchQuestion => 'Spiel verlassen?';

  @override
  String get leaveVideoQuestion => 'Video verlassen?';

  @override
  String get letsPlay => 'Los geht\'s';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get live => 'Live';

  @override
  String get liveEventCaps => 'LIVE-EVENT';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get local => 'Lokal';

  @override
  String get locked => 'Gesperrt';

  @override
  String get logOut => 'Abmelden';

  @override
  String get loginMethod => 'Anmeldemethode';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'Wenn du jetzt schließt, bekommst du keine 10 Münzen. Noch $seconds Sekunden.';
  }

  @override
  String get losses => 'Niederlagen';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get marks => 'Zeichen';

  @override
  String get match => 'Spiel';

  @override
  String get matchAbandonedCaps => 'SPIEL ABGEBROCHEN';

  @override
  String matchDuration(String duration) {
    return 'Spieldauer $duration';
  }

  @override
  String get matchHistory => 'Spielverlauf';

  @override
  String get matchHistoryCaps => 'SPIELVERLAUF';

  @override
  String get matchInvitations => 'Spieleinladungen';

  @override
  String get matchLobby => 'Spiel-Lobby';

  @override
  String get matchResult => 'Spielergebnis';

  @override
  String get matchResults => 'Spielergebnisse';

  @override
  String get matchStakes => 'Einsätze';

  @override
  String get matchStartsIn => 'Spiel beginnt in';

  @override
  String get matches => 'Spiele';

  @override
  String get matchmakingError => 'Matchmaking-Fehler';

  @override
  String get matchmakingFailed => 'Matchmaking fehlgeschlagen';

  @override
  String get matchmakingStopped => 'Matchmaking gestoppt';

  @override
  String memberSince(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get messageEmpty => 'Nachricht darf nicht leer sein';

  @override
  String get messagesStayForMatch => 'Nachrichten gelten nur für dieses Spiel';

  @override
  String minusCoins(String n) {
    return '-$n Münzen';
  }

  @override
  String get misPlay30 => 'Spiele 30 Matches';

  @override
  String get misPlay5 => 'Spiele 5 Matches';

  @override
  String get misQuick => 'Spiele ein Zufallsspiel';

  @override
  String get misTourney => 'Nimm an einem Turnier teil';

  @override
  String get misWin15 => 'Gewinne 15 Spiele';

  @override
  String get misWin3 => 'Gewinne 3 Spiele';

  @override
  String get misWin4x4 => 'Gewinne auf einem 4×4-Feld';

  @override
  String get missResets =>
      'Verpasst du einen Tag, beginnt es neu. Komm morgen für die nächste Belohnung wieder.';

  @override
  String get missingChallengeData => 'Herausforderungsdaten fehlen';

  @override
  String get missingEmail => 'E-Mail fehlt – geh zurück und versuche es erneut';

  @override
  String get missions => 'Missionen';

  @override
  String missionsDone(String done, String total) {
    return '$done von $total Missionen erledigt';
  }

  @override
  String get mobileNotSupported =>
      'Handynummern werden in deiner Region noch nicht unterstützt';

  @override
  String get mobileOptional => 'Handynummer (optional)';

  @override
  String mode(String n) {
    return 'Modus $n';
  }

  @override
  String get more => 'Mehr';

  @override
  String get moreGames => 'Weitere Spiele';

  @override
  String get music => 'Musik';

  @override
  String nOf5(String n) {
    return '$n von 5';
  }

  @override
  String get navPlay => 'Spielen';

  @override
  String get newCodeSent => 'Neuer Code gesendet – sieh im Posteingang nach';

  @override
  String get newHere => 'Neu hier?';

  @override
  String get newMatchChallengeCaps => 'NEUE HERAUSFORDERUNG!';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get newPasswordBody =>
      'Gib ein neues Passwort ein. Du bleibst nach dem Speichern angemeldet.';

  @override
  String get newVersion => 'Neue Version';

  @override
  String get newVersionReady => 'Eine neue Version von DROTIX ist da.';

  @override
  String get newVideosUnlockIn => 'Neue Gratis-Videos in';

  @override
  String get next => 'Weiter';

  @override
  String get nextCaps => 'WEITER';

  @override
  String get nextRound => 'Nächste Runde';

  @override
  String get no => 'Nein';

  @override
  String get noChallenge => 'Keine Herausforderung';

  @override
  String get noChallengesHere => 'Hier gibt es keine Herausforderungen.';

  @override
  String get noCloudMatches =>
      'Noch keine Cloud-Spiele. Spiele angemeldet gegen The Doll, um hier zu erscheinen.';

  @override
  String get noFriendsYet =>
      'Noch keine Freunde – suche, um jemanden hinzuzufügen.';

  @override
  String get noHistory => 'Kein Verlauf gefunden';

  @override
  String get noMatchesYet => 'Noch keine Spiele';

  @override
  String get noMessagesYet =>
      'Noch keine Nachrichten.\nSchnellantworten gehen auch.';

  @override
  String get noNotificationsYet => 'Noch keine Benachrichtigungen';

  @override
  String get noOpponentFound => 'Kein Gegner gefunden – versuche es erneut';

  @override
  String get noPendingRequests => 'Keine offenen Anfragen.';

  @override
  String get noPlayersFound => 'Keine Spieler gefunden';

  @override
  String get noQrInPhoto => 'Kein QR im Foto gefunden';

  @override
  String get noRankedPlayers =>
      'Noch keine Spieler in der Rangliste. Melde dich an und spiele, um dabei zu sein.';

  @override
  String get noTransactions => 'Noch keine Transaktionen.';

  @override
  String get noVideoFound =>
      'Wir haben kein Video gefunden. Dein Gratis-Video wurde nicht verbraucht. Versuche es in einer Minute erneut.';

  @override
  String get noVideoNow =>
      'Gerade ist kein Video verfügbar. Versuche es später.';

  @override
  String get noVideoRightNow => 'Gerade kein Video';

  @override
  String get nobody => 'Niemand';

  @override
  String get nobodyBlinked => 'Keiner hat nachgegeben.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Keiner hat nachgegeben. $name hat dich gestoppt.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name nimmt gerade keine Herausforderungen an.';
  }

  @override
  String get notEnoughCoins => 'Nicht genug Münzen';

  @override
  String get notEnoughCoinsAnother =>
      'Nicht genug Münzen für einen weiteren Einsatz.';

  @override
  String get notEnoughCoinsStake => 'Nicht genug Münzen für diesen Einsatz.';

  @override
  String get notNow => 'Nicht jetzt';

  @override
  String get notSignedIn => 'Nicht angemeldet';

  @override
  String get notSignedInYet =>
      'Noch nicht angemeldet – öffne zuerst den E-Mail-Link';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name hat deine Herausforderung angenommen. Das Match beginnt!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Herausforderung angenommen';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name ist gerade in einem Match. Versuch es später noch einmal.';
  }

  @override
  String get notifChallengeBusyTitle => 'Spieler ist beschäftigt';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name hat die Herausforderung abgebrochen';
  }

  @override
  String get notifChallengeCancelledTitle => 'Herausforderung abgebrochen';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name hat deine Herausforderung abgelehnt';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Herausforderung abgelehnt';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name hat nicht rechtzeitig reagiert';
  }

  @override
  String get notifChallengeExpiredTitle => 'Herausforderung abgelaufen';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name hat dich zu einem Match herausgefordert';
  }

  @override
  String get notifChallengeRequestTitle => 'Neue Herausforderung';

  @override
  String get notifChannelDesc => 'Herausforderungen, Matches und Münzen';

  @override
  String get notifChannelName => 'Spiel-Benachrichtigungen';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount Münzen hinzugefügt. Guthaben: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Münzen hinzugefügt';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount Münzen abgezogen. Guthaben: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Münzen abgezogen';

  @override
  String get notifCoinsPurchaseTitle => 'Kauf abgeschlossen';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'Du hast $amount Münzen verdient. Guthaben: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Belohnung erhalten';

  @override
  String get notifEmptyHint =>
      'Herausforderungen, Match-Ergebnisse und Münz-Updates erscheinen hier.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name hat deine Freundschaftsanfrage angenommen';
  }

  @override
  String get notifFriendAcceptedTitle => 'Neuer Freund';

  @override
  String notifFriendRequestBody(String name) {
    return '$name möchte dein Freund sein';
  }

  @override
  String get notifFriendRequestTitle => 'Freundschaftsanfrage';

  @override
  String get notifGeneric => 'Neue Benachrichtigung';

  @override
  String notifMatchBody(String name) {
    return 'Dein Match gegen $name ist beendet';
  }

  @override
  String get notifMatchDrawTitle => 'Unentschieden';

  @override
  String get notifMatchLostTitle => 'Du hast verloren';

  @override
  String get notifMatchWonTitle => 'Du hast gewonnen!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name ist deinem privaten Raum beigetreten';
  }

  @override
  String get notifRoomJoinedTitle => 'Spieler beigetreten';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String nowFriends(String name) {
    return 'Du und $name seid jetzt Freunde';
  }

  @override
  String get nowFriendsShort => 'Ihr seid jetzt Freunde';

  @override
  String get officialWebsite => 'Offizielle Website';

  @override
  String get offlineAi => 'Offline-KI';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'Kein Internet · Nur KI-Gegner · $size · Einsatz $stake';
  }

  @override
  String get offlineBanner => 'Offline · Spielen gegen The Doll geht weiterhin';

  @override
  String get offlineBody =>
      'Online-Spiele und Turniere brauchen eine Verbindung. Gegen The Doll kannst du weiterhin spielen.';

  @override
  String get offlineProfilesNote =>
      'Das sind Offline-KI-Profile – keine echten Online-Spieler.';

  @override
  String get offlineSmart => 'Offline, kluger Gegner';

  @override
  String get ok => 'OK';

  @override
  String get oneLastStepCaps => 'NOCH EIN SCHRITT';

  @override
  String get online => 'Online';

  @override
  String get onlineMatch => 'Online-Spiel';

  @override
  String get onlineMultiplayer => 'Online-Mehrspieler';

  @override
  String get onlineOfflineAi => 'Online-Spieler · Offline-KI';

  @override
  String onlineStake(String stake) {
    return 'Online · Einsatz $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name nimmt nur Herausforderungen von Freunden an. Füge ihn zuerst hinzu.';
  }

  @override
  String get open => 'Öffnen';

  @override
  String get openedTheLink => 'Ich habe den Link geöffnet';

  @override
  String get openingInstaller => 'Installer wird geöffnet…';

  @override
  String get opponent => 'Gegner';

  @override
  String get opponentAdvances =>
      'Trittst du nicht rechtzeitig bei, kommt dein Gegner weiter.';

  @override
  String get opponentDisconnected => 'Gegner getrennt';

  @override
  String get opponentWins => 'Gegner gewinnt';

  @override
  String opponentsMove(String name) {
    return '$name ist dran';
  }

  @override
  String get or => 'Oder';

  @override
  String get orEnterCodeCaps => 'ODER CODE EINGEBEN';

  @override
  String get otherEvents => 'Weitere Events';

  @override
  String get owned => 'Im Besitz';

  @override
  String get passAndPlay => 'Weitergeben & spielen';

  @override
  String get password => 'Passwort';

  @override
  String get passwordMin6 => 'Das Passwort braucht mindestens 6 Zeichen';

  @override
  String get passwordUpdated => 'Passwort aktualisiert';

  @override
  String get passwordsNoMatch => 'Passwörter stimmen nicht überein';

  @override
  String get pasteCode => 'Code einfügen';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'Pausiert';

  @override
  String get perMove20s => '20 s pro Zug';

  @override
  String get photoUpdated => 'Foto aktualisiert';

  @override
  String get pickClosestReason => 'Was ist los? Wähle den passendsten Grund.';

  @override
  String get pickYourGame => 'Spiel wählen';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get playAsGuest => 'Als Gast spielen';

  @override
  String get playCaps => 'SPIELEN';

  @override
  String get playDollOffline => 'Offline gegen The Doll spielen';

  @override
  String get playToBuildForm => 'Spiele ein Match, um deine Form zu sehen.';

  @override
  String get playVsDoll => 'Gegen The Doll spielen';

  @override
  String playVsName(String name) {
    return 'Gegen $name spielen';
  }

  @override
  String get played => 'Gespielt';

  @override
  String get player => 'Spieler';

  @override
  String get player1 => 'Spieler 1';

  @override
  String get player1Move => 'Spieler 1 ist dran';

  @override
  String get player1Wins => 'Spieler 1 gewinnt!';

  @override
  String get player2 => 'Spieler 2';

  @override
  String get player2Move => 'Spieler 2 ist dran';

  @override
  String get player2Wins => 'Spieler 2 gewinnt!';

  @override
  String playerAdded(String name) {
    return '$name hinzugefügt';
  }

  @override
  String get playerBlocked => 'Spieler blockiert';

  @override
  String playerIdLabel(String id) {
    return 'SPIELER $id';
  }

  @override
  String get playerUnblocked => 'Spieler entsperrt';

  @override
  String get players => 'Spieler';

  @override
  String get playersLeft => 'Verbleibende Spieler';

  @override
  String get pleaseWait => 'Bitte warten…';

  @override
  String plusCoins(String n) {
    return '+$n Münzen';
  }

  @override
  String get podium => 'Podium';

  @override
  String get pointAtHostQr =>
      'Richte die Kamera auf den QR des Hosts – derselbe Code wie in der Lobby.';

  @override
  String get pointCameraAtQr => 'Richte die Kamera auf den Raum-QR-Code';

  @override
  String pointsWins(String points, String wins) {
    return '$points Pkt. · $wins Siege';
  }

  @override
  String get popular => 'Beliebt';

  @override
  String get previousMatchExpired =>
      'Das letzte Spiel ist abgelaufen. Versuche es gleich noch einmal.';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String privacyBody(String email) {
    return 'Wir erheben nur die Spieldaten, die die App braucht (Münzen, Kosmetik, Spielverlauf und Einstellungen). Als Gast brauchst du kein Konto.\n\nWenn du dich anmeldest, werden deine Daten nur zum Speichern und Wiederherstellen deines Fortschritts genutzt. Wir verkaufen keine persönlichen Daten. Du kannst deine Daten jederzeit unter Einstellungen → Konto löschen entfernen.\n\nKontakt: $email';
  }

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get privateOnlyYou => 'Privat. Nur du siehst das.';

  @override
  String get privateRoomByUsername => 'Privater Raum (per Name)';

  @override
  String get privateRoomCaps => 'PRIVATER RAUM';

  @override
  String get prizeAdded => 'Preis deinem Guthaben gutgeschrieben';

  @override
  String get prizePool => 'Preisgeld';

  @override
  String get profile => 'Profil';

  @override
  String get profileNotFound => 'Profil nicht gefunden';

  @override
  String get profilePrivacyNote =>
      'Spielverlauf und Aktivität bleiben privat. Melden ist für Profilmissbrauch; für Chats im Spiel nutze den Melde-Button im Chat.';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String progressOf(String done, String total) {
    return '$done von $total';
  }

  @override
  String get publicStatsNote =>
      'Nur Rang, Punkte und Siege sind öffentlich. Spielverlauf und Aktivität bleiben privat.';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get purchases => 'Käufe';

  @override
  String get purchasesComingSoon =>
      'Münzkäufe kommen bald. Sieh dir unter Gratis-Münzen ein Video an, um jetzt Münzen zu bekommen.';

  @override
  String get quarter => 'Viertelfinale';

  @override
  String get quarterFinal => 'Viertelfinale';

  @override
  String get quickCloseOne => 'Knapp!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'Guter Zug!';

  @override
  String quickMatchVsAi(String time) {
    return 'Schnellspiel gegen KI · $time';
  }

  @override
  String get quitMatch => 'Spiel verlassen';

  @override
  String get randomMatch => 'Zufallsspiel';

  @override
  String get rank => 'Rang';

  @override
  String rankScore(String rank, String score) {
    return 'Rang #$rank · Punkte $score';
  }

  @override
  String get rankScoreUnknown => 'Rang – · Punkte –';

  @override
  String get ranks => 'Rangliste';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get ratingsSoon => 'Bewertungen kommen bald';

  @override
  String get readOnly => 'nur lesbar';

  @override
  String get readyCaps => 'BEREIT';

  @override
  String get reasonHarassment => 'Belästigung oder Mobbing';

  @override
  String get reasonInappropriate => 'Sexuelle oder unangemessene Inhalte';

  @override
  String get reasonOffensive => 'Hassrede oder Beleidigung';

  @override
  String get reasonOther => 'Etwas anderes';

  @override
  String get reasonSpam => 'Spam oder Betrug';

  @override
  String get reasonThreatening => 'Drohungen oder Gewalt';

  @override
  String get received => 'Erhalten';

  @override
  String get reconnecting => 'Verbinde neu…';

  @override
  String reference(String id) {
    return 'Referenz: $id';
  }

  @override
  String get referralCode => 'Empfehlungscode';

  @override
  String get referralHint => 'Empfehlungscode (optional)';

  @override
  String get referralOnce =>
      'Ein Empfehlungscode ist nur einmal direkt nach der Registrierung nutzbar.';

  @override
  String get referralPrompt =>
      'Code von einem Freund bekommen? Jetzt eingeben und 50 Münzen erhalten.';

  @override
  String get referralWorked =>
      'Dein Code hat funktioniert. Die Münzen sind in deinem Wallet bereit.';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get refreshStatus => 'Status aktualisieren';

  @override
  String get region => 'Region';

  @override
  String get regionIndiaNote =>
      'Automatisch über SIM bzw. Gerät erkannt. In Indien: indische Sprachen und Preise in ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Automatisch über SIM bzw. Gerät erkannt. Internationale Sprachen, Preise in $currency.';
  }

  @override
  String get register => 'Registrieren';

  @override
  String get released => 'Veröffentlicht';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchQuestion => 'Revanche?';

  @override
  String get remindMe => 'Vor meinem Match erinnern';

  @override
  String get reportButtonCaps => 'MELDE-BUTTON';

  @override
  String get reportButtonHelp =>
      'Oben rechts im Live-Chat, neben „Chat beenden“. Immer sichtbar, solange der Chat an ist.\nTippen → Grund wählen → Details und Screenshots hinzufügen → absenden.';

  @override
  String get reportCaps => 'MELDEN';

  @override
  String get reportFailed => 'Meldung fehlgeschlagen';

  @override
  String reportName(String name) {
    return '$name melden';
  }

  @override
  String get reportOrBlock => 'Melden oder blockieren';

  @override
  String get reportOrBlockPlayer => 'Diesen Spieler melden oder blockieren';

  @override
  String get reportPlayer => 'Spieler melden';

  @override
  String get requestSentCaps => 'ANFRAGE GESENDET';

  @override
  String requestSentTo(String name) {
    return 'Anfrage an $name gesendet';
  }

  @override
  String get requests => 'Anfragen';

  @override
  String requestsCount(String n) {
    return 'Anfragen · $n';
  }

  @override
  String get requestsExpire7d =>
      'Anfragen verfallen nach 7 Tagen ohne Antwort.';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get resendEmail => 'E-Mail erneut senden';

  @override
  String get resetCode => 'Reset-Code';

  @override
  String resetCodeSentTo(String target) {
    return 'Wir haben einen Code an $target gesendet.\nGib ihn unten ein – du musst den Link nicht öffnen.';
  }

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get resetPasswordBody =>
      'Gib deine E-Mail ein, wir senden dir einen Code. Gib ihn in der App ein – den Link musst du nicht öffnen.';

  @override
  String get restart => 'Neu starten';

  @override
  String get result => 'Ergebnis';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get returnToMainMenu => 'Zurück zum Hauptmenü';

  @override
  String get rewardEarnedCaps => 'BELOHNUNG ERHALTEN';

  @override
  String get rewardFlowOverview => 'Übersicht der Belohnungen';

  @override
  String rewardIn(String time) {
    return 'Belohnung in $time';
  }

  @override
  String get rivalO => 'Gegner: O';

  @override
  String get roomCancelled => 'Raum abgebrochen';

  @override
  String roomClosesIn(String time) {
    return 'Der Raum schließt in $time, wenn niemand beitritt.';
  }

  @override
  String get roomClosesSoon => 'Der Raum schließt bald, wenn niemand beitritt.';

  @override
  String get roomClosing => 'Raum wird geschlossen…';

  @override
  String get roomCodeCaps => 'RAUMCODE';

  @override
  String get roomCodeCopied => 'Raumcode kopiert';

  @override
  String get roomExpired => 'Raum abgelaufen';

  @override
  String get roomOpenCaps => 'RAUM OFFEN';

  @override
  String get roundOf16 => 'Achtelfinale';

  @override
  String get roundOf16Caps => 'ACHTELFINALE';

  @override
  String roundOf16Vs(String name) {
    return 'Achtelfinale · gegen $name';
  }

  @override
  String get roundsWon => 'Gewonnene Runden';

  @override
  String get row => 'Reihe';

  @override
  String get ruleEmoji =>
      '• Emoji-Reaktionen gehen ohne Anfrage und lassen sich stummschalten.';

  @override
  String get ruleEnds => '• Der Chat endet automatisch mit dem Spiel.';

  @override
  String get ruleStop => '• Jeder Spieler kann den Chat jederzeit beenden.';

  @override
  String get ruleVanish =>
      '• Nachrichten verschwinden nach Sekunden und werden nie gespeichert.';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get savePassword => 'Passwort speichern';

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get savingToCloud => 'Wird in der Cloud gespeichert…';

  @override
  String get scanOrShare => 'Zum Beitreten scannen oder Link teilen';

  @override
  String get scanQr => 'QR scannen';

  @override
  String get score => 'Punkte';

  @override
  String get scorePlus10 => 'Punkte +10';

  @override
  String get screenshotTooBig => 'Screenshot muss kleiner als 2 MB sein';

  @override
  String get screenshotsOptionalCaps => 'SCREENSHOTS (OPTIONAL)';

  @override
  String get searchPlayersHint => 'Nach Benutzername oder Spieler-ID suchen';

  @override
  String get searchResults => 'Suchergebnisse';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'Online · $size · Einsatz $stake · $time';
  }

  @override
  String get seatWaiting => 'Spieler, dein Platz wartet.';

  @override
  String secondsLeft(String seconds) {
    return 'Noch $seconds s';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'Noch $seconds s zum Antworten';
  }

  @override
  String get selectDifficulty => 'Schwierigkeit wählen';

  @override
  String get selectOpponent => 'Gegner auswählen';

  @override
  String get selectReportReason => 'Wähle einen Grund';

  @override
  String get semi => 'Halbfinale';

  @override
  String get send => 'Senden';

  @override
  String get sendChallenge => 'Herausforderung senden';

  @override
  String get sendResetCode => 'Code senden';

  @override
  String get sending => 'Wird gesendet…';

  @override
  String get sendingMove => 'Zug wird gesendet…';

  @override
  String get sent => 'Gesendet';

  @override
  String serverTournamentsDemo(String error) {
    return 'Server-Turniere nicht verfügbar – Demo wird angezeigt.\n$error';
  }

  @override
  String get sessionExpiredReset =>
      'Sitzung abgelaufen – fordere einen neuen Code an';

  @override
  String get settings => 'Einstellungen';

  @override
  String get shareComingSoon => 'Teilen kommt bald';

  @override
  String get shareInviteCaps => 'EINLADUNG TEILEN';

  @override
  String get shareOnWhatsApp => 'Auf WhatsApp teilen';

  @override
  String get shareProfile => 'Profil teilen';

  @override
  String shareWin(String url) {
    return 'Ich habe gerade ein DROTIX-Spiel gewonnen! Glaubst du, du schlägst mich? Jetzt spielen: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'Ich habe gerade $name in DROTIX besiegt! Glaubst du, du schlägst mich? Jetzt spielen: $url';
  }

  @override
  String get shop => 'Shop';

  @override
  String get showHidePassword => 'Passwort ein- oder ausblenden';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signInChangePhoto => 'Melde dich an, um das Foto zu ändern';

  @override
  String get signInFindFriends => 'Melde dich an, um Freunde zu finden';

  @override
  String get signInMatchmaking => 'Für Online-Matchmaking anmelden';

  @override
  String get signInNotifications =>
      'Melde dich an, um deine Benachrichtigungen zu sehen';

  @override
  String get signInOnline => 'Melde dich für den Online-Mehrspielermodus an';

  @override
  String get signInRandomMatch =>
      'Melde dich an, um Zufallsspiele gegen echte Spieler zu spielen';

  @override
  String get signInRequired => 'Anmeldung erforderlich';

  @override
  String get signInSearchPlayers =>
      'Melde dich an, um Spieler zu suchen und Freunde zu synchronisieren.';

  @override
  String get signInToAddFriends => 'Melde dich an, um Freunde hinzuzufügen';

  @override
  String get signInToChallenge =>
      'Melde dich an, um diesen Spieler herauszufordern';

  @override
  String get signInWalletHistory =>
      'Melde dich an, um deinen Wallet-Verlauf zu sehen.';

  @override
  String get signInWithEmail => 'Mit E-Mail anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signUp => 'Registrieren';

  @override
  String get skip => 'Überspringen';

  @override
  String get skipForNow => 'Vorerst überspringen';

  @override
  String get somethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Etwas ist schiefgelaufen: $error';
  }

  @override
  String get soundDisabled => 'Ton aus';

  @override
  String get soundEffects => 'Soundeffekte';

  @override
  String get soundEnabled => 'Ton an';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get sponsored => 'Gesponsert';

  @override
  String stakeDot(String n) {
    return 'Einsatz · $n';
  }

  @override
  String get stakeReturned => 'Einsatz zurückerstattet';

  @override
  String stakeRoom(String stake, String room) {
    return 'Einsatz $stake · $room…';
  }

  @override
  String get start => 'Starten';

  @override
  String get startPlayingCaps => 'LOSSPIELEN';

  @override
  String get starterPack => 'Startpaket';

  @override
  String get starting => 'Wird gestartet…';

  @override
  String get startsInCaps => 'BEGINNT IN';

  @override
  String get stats => 'Statistiken';

  @override
  String statusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get stayInApp =>
      'Bleib in der App. Wir melden uns, wenn dein Match bereit ist.';

  @override
  String get stillOffline =>
      'Immer noch offline. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get stopChat => 'Chat beenden';

  @override
  String get submitAppeal => 'Einspruch einreichen';

  @override
  String get submitReportCaps => 'MELDUNG SENDEN';

  @override
  String submittedAt(String date) {
    return 'Eingereicht: $date';
  }

  @override
  String get submitting => 'Wird gesendet…';

  @override
  String get submittingCaps => 'WIRD GESENDET…';

  @override
  String get supportEmail => 'Support-E-Mail';

  @override
  String suspendedAt(String date) {
    return 'Gesperrt: $date';
  }

  @override
  String get suspendedByModerator =>
      'Ein Moderator hat das Konto nach Prüfung einer Meldung gesperrt.';

  @override
  String get suspendedRules =>
      'Während der Sperre kannst du nicht spielen, Räumen beitreten oder chatten. Du kannst einen Einspruch einreichen.';

  @override
  String get t20Seconds => '20 Sekunden pro Zug';

  @override
  String get tDrawReplays => 'Bei Unentschieden wird die Runde wiederholt';

  @override
  String get tSingleElim => 'K.-o.-System: Wer einmal verliert, ist raus';

  @override
  String get tSingleElimFee =>
      'K.-o.-System. Wer eine Runde verliert, ist raus, das Startgeld gibt es nicht zurück.';

  @override
  String get tagline => 'Das gefährlichste kleine Spiel';

  @override
  String get takeTurnsBody =>
      'Du und dein Gegner setzt abwechselnd ein Zeichen. Tippe auf ein leeres Feld, um zu ziehen.';

  @override
  String get takeTurnsCaps => 'ABWECHSELND';

  @override
  String get takesFewSeconds => 'Das dauert meist nur ein paar Sekunden.';

  @override
  String get tapEmptySquare => 'Tippe auf ein leeres Feld';

  @override
  String get tbd => 'Offen';

  @override
  String get tellUsMin10 =>
      'Bitte beschreibe, was passiert ist (mind. 10 Zeichen)';

  @override
  String get termsAccountBody =>
      'Halte deine Anmeldung sicher. Du bist für die Aktivität deines Kontos verantwortlich.';

  @override
  String get termsAccountTitle => '2. Dein Konto';

  @override
  String get termsChangesBody =>
      'Wir können diese Bedingungen ändern. Wer weiter spielt, akzeptiert die Änderungen.';

  @override
  String get termsChangesTitle => '5. Änderungen';

  @override
  String get termsCoinsBody =>
      'Münzen sind virtuelle Gegenstände ohne Geldwert und können nicht in Geld umgetauscht werden.';

  @override
  String get termsCoinsTitle => '3. Virtuelle Münzen';

  @override
  String get termsFairBody =>
      'Kein Schummeln, keine Beleidigungen oder Belästigung. Wir können Konten sperren, die gegen Regeln verstoßen.';

  @override
  String get termsFairTitle => '4. Fairplay und Chat';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get termsUsingBody =>
      'Du musst diese Bedingungen einhalten und fair spielen.';

  @override
  String get termsUsingTitle => '1. Nutzung von DROTIX';

  @override
  String get theirTurnCaps => 'GEGNER IST DRAN';

  @override
  String get threeInRowBody =>
      'Bringe drei Zeichen in eine Reihe, Spalte oder Diagonale, bevor es dein Gegner tut.';

  @override
  String get threeInRowCaps => 'DREI IN EINER REIHE';

  @override
  String timeDaysAgo(String n) {
    return 'vor $n T.';
  }

  @override
  String timeHoursAgo(String n) {
    return 'vor $n Std.';
  }

  @override
  String get timeJustNow => 'Gerade eben';

  @override
  String timeMinutesAgo(String n) {
    return 'vor $n Min.';
  }

  @override
  String get timeSkipped => 'Läuft die Zeit ab, wird der Zug übersprungen.';

  @override
  String timesUp(String who) {
    return 'Zeit abgelaufen · $who';
  }

  @override
  String get today => 'Heute';

  @override
  String get todayCaps => 'HEUTE';

  @override
  String get top16 => 'Top 16';

  @override
  String get totalCoinsCaps => 'MÜNZEN GESAMT';

  @override
  String get tournament => 'Turnier';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get tryAgainCaps => 'ERNEUT VERSUCHEN';

  @override
  String get twoPlayers => 'Zwei Spieler, ein Handy';

  @override
  String get txChallengeEntry => 'Herausforderungs-Einsatz';

  @override
  String get txCoinPurchase => 'Münzkauf';

  @override
  String txDailyBonus(String time) {
    return 'Tagesbonus · $time';
  }

  @override
  String get txDailyReward => 'Tägliche Belohnung';

  @override
  String get txFreeVideo => 'Video-Belohnung';

  @override
  String get txMatchWin => 'Spielsieg';

  @override
  String txPurchasing(String time) {
    return 'Münzen gekauft · $time';
  }

  @override
  String txReferral(String time) {
    return 'Empfehlungscode · $time';
  }

  @override
  String txTournament(String time) {
    return 'Turnier · $time';
  }

  @override
  String get txTournamentPrize => 'Turnierpreis';

  @override
  String txWatchingAds(String time) {
    return 'Werbung angesehen · $time';
  }

  @override
  String get txWelcomeBonus => 'Willkommensbonus';

  @override
  String txWinning(String time) {
    return 'Spiele gewonnen · $time';
  }

  @override
  String get typeMessage => 'Nachricht eingeben';

  @override
  String get unblockPlayer => 'Spieler entsperren';

  @override
  String get unblockToAdd => 'Entsperre diesen Spieler, um ihn hinzuzufügen';

  @override
  String get unblockToChallenge =>
      'Entsperre den Spieler, um ihn herauszufordern';

  @override
  String unlockFor(String n) {
    return 'Freischalten · $n Münzen';
  }

  @override
  String get unlocked => 'Freigeschaltet';

  @override
  String unlockedCount(String n, String total) {
    return '$n von $total freigeschaltet';
  }

  @override
  String get unranked => 'Ohne Rang';

  @override
  String get upTo3Images => 'Bis zu 3 Bilder. Nur unser Team sieht sie.';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get updateFailed => 'Aktualisierung fehlgeschlagen';

  @override
  String get updateOnAppStore => 'Im App Store aktualisieren';

  @override
  String get updateRequired => 'Update erforderlich';

  @override
  String get updatesOnlyMobile => 'Updates gibt es für Android und iOS.';

  @override
  String get useChatReport =>
      'Nutze im laufenden Spiel Chat → Melden für Meldungen mit Belegen.';

  @override
  String get username => 'Benutzername';

  @override
  String get usernameHint => 'Benutzername (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Code prüfen';

  @override
  String get verifyFailBody =>
      'Das kann bei schwacher Verbindung passieren oder wenn die Belohnung schon abgeholt wurde. Deine Münzen sind sicher.';

  @override
  String get verifying => 'Wird geprüft…';

  @override
  String get verifyingReward => 'Belohnung wird geprüft';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get versionUnsupported =>
      'Diese Version wird nicht mehr unterstützt. Aktualisiere, um weiterzuspielen.';

  @override
  String get vibration => 'Vibration';

  @override
  String get victory => 'SIEG';

  @override
  String get videoLength =>
      'Das Video dauert etwa 15 bis 30 Sekunden. Schau es bis zum Ende, um deine Münzen zu bekommen.';

  @override
  String get videos => 'Videos';

  @override
  String get viewAppealStatus => 'Einspruchsstatus ansehen';

  @override
  String get viewBracket => 'Turnierbaum ansehen';

  @override
  String get viewBracketCaps => 'TURNIERBAUM';

  @override
  String get viewProfile => 'Profil ansehen';

  @override
  String vsName(String name) {
    return 'gegen $name';
  }

  @override
  String get waitingCaps => 'WARTET';

  @override
  String waitingForAccept(String name) {
    return 'Warte, bis $name annimmt…';
  }

  @override
  String get waitingForFriend => 'Warte auf einen Freund...';

  @override
  String get waitingOtherMatches => 'Warte auf andere Spiele';

  @override
  String get waitingRoundOpen => 'Warten auf den Rundenstart';

  @override
  String get wallet => 'Wallet';

  @override
  String get walletBalance => 'Wallet-Guthaben';

  @override
  String get walletCaps => 'WALLET';

  @override
  String get walletUnavailable => 'Wallet nicht verfügbar';

  @override
  String watchAnotherLeft(String n) {
    return 'NOCH EINS ($n ÜBRIG)';
  }

  @override
  String get watchBracketCaps => 'TURNIERBAUM VERFOLGEN';

  @override
  String get watchFullVideo =>
      'Sieh dir das ganze Video an, um deine Bonusmünzen zu erhalten.';

  @override
  String get watchNowCaps => 'JETZT ANSEHEN';

  @override
  String get watchShortVideo => 'Sieh dir ein kurzes Video an';

  @override
  String watchShortVideoToGet(String n) {
    return 'Kurzes Video ansehen und +$n erhalten';
  }

  @override
  String get watchVideo => 'VIDEO ANSEHEN';

  @override
  String get watchVideoCoins => 'Video ansehen, 10 Münzen erhalten';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get weeklyChest => 'Wöchentliche Truhe';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get welcomeBonusCaps => 'WILLKOMMENSBONUS';

  @override
  String welcomeName(String name) {
    return 'Willkommen, $name';
  }

  @override
  String get whatHappenedCaps => 'WAS IST PASSIERT';

  @override
  String get whatHappenedHint =>
      'Beschreibe, was passiert ist und warum du diesen Spieler meldest';

  @override
  String get whatsNewCaps => 'NEU';

  @override
  String get whoCanChallenge => 'Wer dich herausfordern darf';

  @override
  String get whoCanMessage => 'Wer dir Nachrichten senden darf';

  @override
  String get winRate => 'Siegquote';

  @override
  String get winner => 'SIEGER';

  @override
  String get wins => 'Siege';

  @override
  String winsThisRound(String name) {
    return '$name gewinnt diese Runde.';
  }

  @override
  String get yesDelete => 'Ja, löschen';

  @override
  String get yesterday => 'Gestern';

  @override
  String get yesterdayCaps => 'GESTERN';

  @override
  String get you => 'Du';

  @override
  String youBeat(String name) {
    return 'Du hast $name besiegt.';
  }

  @override
  String get youFinished => 'Deine Platzierung';

  @override
  String get youLose => 'Du hast verloren';

  @override
  String youMark(String mark) {
    return 'Du · $mark';
  }

  @override
  String get youWin => 'Du hast gewonnen!';

  @override
  String get youWinCaps => 'DU GEWINNST';

  @override
  String get youX => 'Du: X';

  @override
  String yourBalance(String n) {
    return 'Dein Guthaben: $n Münzen';
  }

  @override
  String get yourEmail => 'deine E-Mail';

  @override
  String get yourMatchReadyCaps => 'DEIN MATCH IST BEREIT';

  @override
  String get yourMove => 'Du bist dran';

  @override
  String get yourNextMatch => 'Dein nächstes Match';

  @override
  String get yourTurnCaps => 'DU BIST DRAN';

  @override
  String get youreInCaps => 'DU BIST DABEI';

  @override
  String get youreInViewBracket => 'DU BIST DABEI — TURNIERBAUM';

  @override
  String get youreOffline => 'Du bist offline';
}
