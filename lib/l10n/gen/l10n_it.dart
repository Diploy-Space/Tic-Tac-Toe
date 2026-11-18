// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class L10nIt extends L10n {
  L10nIt([String locale = 'it']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX è un tris veloce e competitivo. Gioca contro il computer, sfida giocatori veri e amici e scala la classifica.';

  @override
  String get aboutUs => 'Chi siamo';

  @override
  String get accept => 'Accetta';

  @override
  String get acceptCaps => 'ACCETTA';

  @override
  String get acceptRequestCaps => 'ACCETTA RICHIESTA';

  @override
  String get accountCheckFailed => 'Verifica account non riuscita';

  @override
  String get accountIsSuspended => 'Il tuo account è sospeso.';

  @override
  String get accountRestricted =>
      'L\'account resta limitato finché un moderatore non termina la revisione. Gioco, matchmaking e chat restano bloccati.';

  @override
  String get accountStatusUnknown =>
      'Stato dell\'account sconosciuto. Riprova.';

  @override
  String get accountSuspended => 'Account sospeso';

  @override
  String get accountSuspendedSignIn =>
      'Il tuo account è stato sospeso. Accedi per vedere i dettagli o fare ricorso.';

  @override
  String get accountSuspendedTitle => 'Il tuo account è stato sospeso';

  @override
  String get ach100Wins => '100 vittorie';

  @override
  String get ach10Matches => '10 partite';

  @override
  String get ach50Matches => '50 partite';

  @override
  String get achChallenger => 'Sfidante';

  @override
  String get achChampion => 'Campione';

  @override
  String get achFirstWin => 'Prima vittoria';

  @override
  String get achScore100 => '100 punti';

  @override
  String get achStreak3 => 'Serie di 3';

  @override
  String get achStreak5 => 'Serie di 5';

  @override
  String get achSurvivor => 'Sopravvissuto';

  @override
  String get achTop3 => 'Top 3';

  @override
  String get achievements => 'Obiettivi';

  @override
  String get add => 'Aggiungi';

  @override
  String get addFriend => 'Aggiungi amico';

  @override
  String get addFriendCaps => 'AGGIUNGI AMICO';

  @override
  String get advanceQuarter => 'Passi ai quarti di finale';

  @override
  String get advancedMode => 'Modalità avanzata (4×4)';

  @override
  String get advertiserApp => 'App dell\'inserzionista';

  @override
  String get advertiserVideo => 'Qui viene riprodotto il video pubblicitario';

  @override
  String get all => 'Tutti';

  @override
  String get allowAndInstall => 'Consenti e installa';

  @override
  String get allowUnknownApps =>
      'Consenti \"Installa app sconosciute\" per DROTIX e torna qui. L\'aggiornamento si installerà da solo.';

  @override
  String get alreadyPlayer => 'Già giocatore?';

  @override
  String get alsoBlock => 'Blocca anche questo giocatore';

  @override
  String get alwaysTrue => 'Sempre valido';

  @override
  String get appUpdate => 'Aggiornamento app';

  @override
  String get appealExplain =>
      'Spiega perché il tuo account dovrebbe essere riattivato. Un moderatore esaminerà il messaggio.';

  @override
  String get appealFailed => 'Ricorso non riuscito';

  @override
  String get appealHint => 'Scrivi il ricorso (min. 20 caratteri)…';

  @override
  String get appealIsUnderReview => 'Il tuo ricorso è in revisione.';

  @override
  String get appealMin20 => 'Il ricorso deve avere almeno 20 caratteri';

  @override
  String get appealSubmitted => 'Ricorso inviato';

  @override
  String get appealSuspension => 'Ricorso contro la sospensione';

  @override
  String get appealUnderReview => 'Ricorso in revisione';

  @override
  String get applyCodeCaps => 'APPLICA CODICE';

  @override
  String get attachRecentChat => 'Allega i messaggi recenti';

  @override
  String get attemptingReconnect => 'Tentativo di riconnessione…';

  @override
  String get auto => 'Auto';

  @override
  String get avatars => 'Avatar';

  @override
  String get back => 'Indietro';

  @override
  String get backToEvent => 'Torna all\'evento';

  @override
  String get backToEvents => 'Torna agli eventi';

  @override
  String get backToEventsCaps => 'TORNA AGLI EVENTI';

  @override
  String get backToHome => 'Torna alla home';

  @override
  String get backToMenu => 'Torna al menu';

  @override
  String get backToSignIn => 'Torna all\'accesso';

  @override
  String balance(String n) {
    return 'Saldo $n';
  }

  @override
  String get balanceAfter => 'Saldo dopo';

  @override
  String balanceArrow(String from) {
    return 'Saldo $from →';
  }

  @override
  String get bestStreak => 'Miglior serie';

  @override
  String get bestValue => 'Miglior valore';

  @override
  String get biggerBoardsBody =>
      'Sulle griglie più grandi ne servono quattro in fila. Se la griglia si riempie senza file, è pareggio.';

  @override
  String get biggerBoardsCaps => 'GRIGLIE PIÙ GRANDI';

  @override
  String get biggerNeedFour => 'Le griglie grandi richiedono quattro in fila';

  @override
  String get blockPlayer => 'Blocca giocatore';

  @override
  String get boardHiddenUntilBack =>
      'La griglia resta nascosta finché non torni.';

  @override
  String get boards => 'Griglie';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n monete aggiunte al portafoglio';
  }

  @override
  String get bonusClaimed => 'Bonus riscattato!';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n monete bonus aggiunte';
  }

  @override
  String get bracket => 'Tabellone';

  @override
  String get bracketInfo => 'Ottavi · 8 partite, 4 mostrate. Sei evidenziato.';

  @override
  String get buyCoinsCaps => 'ACQUISTA MONETE';

  @override
  String get byBoard => 'Per griglia';

  @override
  String get cameraOnlyForScan =>
      'La fotocamera serve solo a scansionare il codice.';

  @override
  String get cameraPermissionNeeded =>
      'Serve il permesso della fotocamera per scansionare. Puoi anche inserire il codice qui sotto.';

  @override
  String get cameraPermissionRequired =>
      'Serve il permesso della fotocamera per scansionare il QR della stanza. Attivalo nelle impostazioni di sistema e riprova.';

  @override
  String get cancel => 'Annulla';

  @override
  String get cancelChallenge => 'Annulla sfida';

  @override
  String get cancelDownload => 'Annulla download';

  @override
  String get cannotChallengeSelf => 'Non puoi sfidare te stesso';

  @override
  String get cannotFriendSelf => 'Non puoi aggiungere te stesso come amico';

  @override
  String get cantChallengeNow =>
      'Al momento non puoi sfidare questo giocatore.';

  @override
  String get challenge => 'Sfida';

  @override
  String get challengeAccepted => 'Sfida accettata';

  @override
  String get challengeCancelled => 'Sfida annullata';

  @override
  String get challengeCaps => 'SFIDA';

  @override
  String get challengeClosed => 'Sfida chiusa';

  @override
  String get challengeDeclined => 'Sfida rifiutata';

  @override
  String get challengeExpired => 'Sfida scaduta';

  @override
  String get challengeExpiresIn60 =>
      'La sfida scade dopo 60 secondi se non viene accettata.';

  @override
  String get challengePrivacy => 'Privacy delle sfide';

  @override
  String get challengeRequests => 'Richieste di sfida';

  @override
  String get challengeSentCoins => 'Sfida inviata · 5 monete';

  @override
  String get challengeSentFree => 'Sfida inviata · Partita gratis';

  @override
  String get challenges => 'Sfide';

  @override
  String get championCaps => 'CAMPIONE';

  @override
  String get change => 'Cambia';

  @override
  String get chat => 'Chat';

  @override
  String get chatAfterAccept => 'Chat dopo che entrambi accettano.';

  @override
  String get chatAfterAcceptRandom =>
      'Chat dopo che entrambi accettano. Si condivide solo il nome utente.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name accetta messaggi solo dagli amici.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name ha disattivato i messaggi.';
  }

  @override
  String get chatNotConnected => 'La chat non è connessa';

  @override
  String get chatOn => 'Chat attiva';

  @override
  String get chatPrivacyNote =>
      'Vale per la chat in partita. Le modifiche valgono subito, anche durante una partita.';

  @override
  String get chatRules => 'Regole della chat';

  @override
  String get chatRulesIntro =>
      'La chat non parte mai da sola. Un giocatore chiede, l\'altro deve accettare.';

  @override
  String get checkAgainCaps => 'RICONTROLLA';

  @override
  String get checkEmail => 'Controlla l\'email';

  @override
  String get checkEmailConfirm =>
      'Controlla la posta e apri il link di conferma';

  @override
  String get checkForUpdates => 'Cerca aggiornamenti';

  @override
  String get checkInbox => 'Controlla la posta in arrivo';

  @override
  String get checking => 'Verifica in corso…';

  @override
  String get chooseEntryStake => 'Scegli la puntata d\'ingresso';

  @override
  String get chooseGameMode => 'Scegli la modalità di gioco';

  @override
  String get chooseNewPassword => 'Scegli una nuova password';

  @override
  String get chooseOpponent => 'Scegli un avversario';

  @override
  String get claim => 'RISCATTA';

  @override
  String claimBonusCoins(String n) {
    return 'Riscatta $n monete bonus';
  }

  @override
  String get claimLabel => 'Riscatta';

  @override
  String claimPlusCoins(String n) {
    return 'Riscatta +$n monete';
  }

  @override
  String get claimVictory => 'Reclama la vittoria';

  @override
  String get claimsSync => 'I premi si sincronizzano con il tuo account';

  @override
  String get classicMode => 'Modalità classica (3×3)';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get clipboardNoCode => 'Negli appunti non c\'è un codice stanza';

  @override
  String get close => 'Chiudi';

  @override
  String get closeAndLose => 'Chiudi e perdi il premio';

  @override
  String get closeRoom => 'Chiudi stanza';

  @override
  String get closing => 'Chiusura…';

  @override
  String get cloud => 'Cloud';

  @override
  String cloudSaveFailed(String message) {
    return 'Salvataggio cloud non riuscito: $message';
  }

  @override
  String get codeSent => 'Codice inviato';

  @override
  String get coinPacks => 'Pacchetti di monete';

  @override
  String coinPacksFrom(String price) {
    return 'PACCHETTI DA $price';
  }

  @override
  String get coins5 => '5 monete';

  @override
  String coinsAdded(String n) {
    return '+$n monete aggiunte';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Monete $delta · Saldo $balance';
  }

  @override
  String get coinsEntryFee => 'Ingresso da 5 monete';

  @override
  String get coinsEntryFeeBody =>
      'Si usa quando finiscono le partite gratis o per alzare la posta.';

  @override
  String coinsLabel(String n) {
    return '$n monete';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n monete (salvate nel cloud)';
  }

  @override
  String get column => 'Colonna';

  @override
  String get comeBackTomorrow => 'Torna domani';

  @override
  String get completeGoogleReturnApp =>
      'Completa l\'accesso Google e torna all\'app';

  @override
  String get completeGoogleSignIn => 'Completa l\'accesso Google e torna qui';

  @override
  String get computer => 'Computer';

  @override
  String get confirm => 'Conferma';

  @override
  String get confirmJoinCaps => 'CONFERMA E PARTECIPA';

  @override
  String confirmLinkSentTo(String target) {
    return 'Abbiamo inviato un link di conferma a $target.\nAprilo su questo dispositivo e torna qui — accederai automaticamente.';
  }

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get confirmationEmailSent =>
      'Email di conferma inviata — controlla la posta';

  @override
  String get confirmingVideo =>
      'Stiamo confermando la visione del video. Attendi.';

  @override
  String get connectingChat => 'Connessione alla chat…';

  @override
  String get connectionUnstable => 'Connessione instabile';

  @override
  String get connectionUnstableCaps => 'CONNESSIONE INSTABILE';

  @override
  String get contactAbout => 'Contatti e info';

  @override
  String get contactUsCaps => 'CONTATTI';

  @override
  String get continueLabel => 'Continua';

  @override
  String get continuePlaying => 'Continua a giocare';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String copiedValue(String label, String value) {
    return '$label copiato: $value';
  }

  @override
  String get couldNotAddCoins => 'Impossibile aggiungere le monete';

  @override
  String get couldNotApplyReferral => 'Impossibile applicare il codice';

  @override
  String couldNotCheck(String error) {
    return 'Impossibile verificare: $error';
  }

  @override
  String get couldNotJoinRoom => 'Impossibile entrare nella stanza';

  @override
  String get couldNotLoadPrivacy => 'Impossibile caricare la privacy';

  @override
  String get couldNotLoadProfile => 'Impossibile caricare il profilo. Riprova.';

  @override
  String get couldNotOpenGoogle => 'Impossibile aprire l\'accesso Google';

  @override
  String get couldNotSavePrivacy => 'Impossibile salvare la privacy';

  @override
  String get couldNotStopChat => 'Impossibile fermare la chat';

  @override
  String get couldNotSubmitAppeal => 'Impossibile inviare il ricorso';

  @override
  String get couldNotVerify => 'Non siamo riusciti a verificarlo';

  @override
  String get couldNotVerifyAccount =>
      'Impossibile verificare lo stato dell\'account. Riprova.';

  @override
  String get createAccount => 'Crea account';

  @override
  String get createPrivateRoom => 'Crea stanza privata';

  @override
  String get customize => 'Personalizza';

  @override
  String get daily => 'Giornaliero';

  @override
  String get dailyChest => 'Forziere giornaliero';

  @override
  String get dailyLimit => 'LIMITE GIORNALIERO RAGGIUNTO';

  @override
  String get date => 'Data';

  @override
  String dayN(String n) {
    return 'Giorno $n';
  }

  @override
  String dayStreak(String n) {
    return 'Serie di $n giorni';
  }

  @override
  String get days30 => '30 giorni';

  @override
  String get days7 => '7 giorni';

  @override
  String get debitFailed => 'Impossibile addebitare le monete';

  @override
  String get declineCaps => 'RIFIUTA';

  @override
  String get defeat => 'SCONFITTA';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountBody =>
      'Monete, punteggio e cronologia verranno eliminati per sempre.';

  @override
  String get deleteAccountQuestion => 'Eliminare l\'account?';

  @override
  String get descriptionMin10 =>
      'La descrizione deve avere almeno 10 caratteri';

  @override
  String get diagonal => 'Diagonale';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyMedium => 'Medio';

  @override
  String get doll => 'Bambola';

  @override
  String get done => 'Fatto';

  @override
  String get downloadAndInstall => 'Scarica e installa';

  @override
  String get downloading => 'Download in corso…';

  @override
  String downloadingPercent(String percent) {
    return 'Download $percent%';
  }

  @override
  String get draw => 'Pareggio';

  @override
  String get drawBadge => 'PAREGGIO';

  @override
  String get draws => 'Pareggi';

  @override
  String get duration => 'Periodo';

  @override
  String get earned => 'Guadagnati';

  @override
  String get earnedThisWeek => 'Guadagnato questa settimana, per fonte';

  @override
  String get editProfileCaps => 'MODIFICA PROFILO';

  @override
  String get eliminatedCaps => 'ELIMINATO';

  @override
  String get email => 'Email';

  @override
  String get emailNotConfirmed => 'Email non confermata';

  @override
  String emailNotConfirmedBody(String email) {
    return 'La registrazione è riuscita, ma l\'email non è ancora confermata.\n\nApri il link di conferma nella posta in arrivo o nello spam, poi accedi di nuovo.\n\n$email';
  }

  @override
  String get emailSentAgain => 'Email inviata di nuovo — controlla la posta';

  @override
  String get endsIn => 'Termina tra';

  @override
  String get enterCode => 'Inserisci codice';

  @override
  String get enterCodeFromEmail => 'Inserisci il codice dell\'email';

  @override
  String get enterCodeInstead => 'Inserisci il codice';

  @override
  String get enterEmailPassword => 'Inserisci email e password';

  @override
  String get enterFullCode => 'Inserisci il codice completo';

  @override
  String get enterReferralOrSkip =>
      'Inserisci un codice invito o salta per ora';

  @override
  String get enterResetCode => 'Inserisci il codice di reset';

  @override
  String get enterValidMobile => 'Inserisci un numero di cellulare valido';

  @override
  String get enterValidReferral => 'Inserisci un codice invito valido';

  @override
  String get enterYourEmail => 'Inserisci la tua email';

  @override
  String get entry => 'Ingresso';

  @override
  String get entryFee => 'Quota d\'ingresso';

  @override
  String get equip => 'Equipaggia';

  @override
  String get equipped => 'Equipaggiato';

  @override
  String get events => 'Eventi';

  @override
  String get everyone => 'Tutti';

  @override
  String get expertMode => 'Modalità esperto (5×5)';

  @override
  String get expiredMoveToHistory =>
      'Le sfide scadute finiscono nella Cronologia.';

  @override
  String get failed => 'Non riuscito';

  @override
  String get fillAllFields => 'Compila tutti i campi';

  @override
  String get finalRound => 'Finale';

  @override
  String get findAMatch => 'Trova una partita';

  @override
  String get findOpponent => 'Trova avversario';

  @override
  String get findPrivateJoin => 'Cerca · stanza privata · codice';

  @override
  String get findingOpponent => 'Ricerca avversario';

  @override
  String get findingPlayer => 'Ricerca giocatore';

  @override
  String get firstMatchSet =>
      'La prima partita viene decisa all\'apertura del round.';

  @override
  String get fiveOfFiveWatched => '5 di 5 video guardati';

  @override
  String get flash => 'Flash';

  @override
  String get flashUnavailable => 'Flash non disponibile';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get forgotPasswordTitle => 'Password dimenticata';

  @override
  String get free => 'Gratis';

  @override
  String get freeCoins => 'MONETE GRATIS';

  @override
  String get freeMatch => 'Partita gratis';

  @override
  String get freeMatchesPerDay => '3 partite gratis al giorno';

  @override
  String get freeVideosToday => 'Video gratis di oggi';

  @override
  String freeVideosUsed(String used) {
    return '$used di 5 video gratis usati oggi';
  }

  @override
  String get friendChallenge => 'Sfida tra amici';

  @override
  String get friendRequestExists => 'Esiste già una richiesta di amicizia';

  @override
  String friendRequestSent(String name) {
    return 'Richiesta di amicizia inviata a $name';
  }

  @override
  String get friendRequestSentShort => 'Richiesta di amicizia inviata';

  @override
  String get friendsCaps => 'AMICI';

  @override
  String get friendsLabel => 'Amici';

  @override
  String get friendsOnly => 'Solo amici';

  @override
  String get fromPhoto => 'Da foto';

  @override
  String gameComingSoon(String game) {
    return '$game: in arrivo';
  }

  @override
  String get gameOver => 'Partita finita';

  @override
  String get gamePaused => 'Gioco in pausa';

  @override
  String get getStarted => 'Inizia';

  @override
  String get gettingVideo => 'Caricamento del video…';

  @override
  String get goToMatchCaps => 'VAI ALLA PARTITA';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get graceWindowEnded =>
      'I 30 secondi di attesa sono finiti. Puoi reclamare la vittoria.';

  @override
  String greatRun(String name) {
    return 'Bel percorso in $name';
  }

  @override
  String get guard => 'Guardia';

  @override
  String get guest => 'Ospite';

  @override
  String get history => 'Cronologia';

  @override
  String get historyNeverPublic =>
      'Cronologia e attività non compaiono mai nel profilo pubblico.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches partite · $wins vittorie · $losses sconfitte · $draws pareggi';
  }

  @override
  String get howItWorks => 'Come funziona';

  @override
  String get howToPlay => 'Come si gioca';

  @override
  String get howToPlayRules =>
      'Allinea tre dei tuoi simboli in orizzontale, verticale o diagonale prima del tuo avversario. Sulle griglie più grandi ne servono quattro.';

  @override
  String howToPlayStep(String n) {
    return 'COME SI GIOCA · $n/3';
  }

  @override
  String get imReadyCaps => 'SONO PRONTO';

  @override
  String get imageTooBig => 'L\'immagine deve essere inferiore a 2 MB';

  @override
  String get install => 'Installa';

  @override
  String get installUpdate => 'Installa aggiornamento';

  @override
  String get installed => 'Installata';

  @override
  String get internetRequired =>
      'Serve una connessione a Internet. Puoi comunque giocare offline contro The Doll.';

  @override
  String get introBody1 => 'Batti l\'IA su griglie 3×3, 4×4 o 5×5.';

  @override
  String get introBody2 =>
      'Partite casuali con giocatori veri. Punta monete, vinci monete.';

  @override
  String get introBody3 =>
      'Premi giornalieri, missioni e tornei ti fanno salire.';

  @override
  String get introTitle1 => 'Batti la Bambola';

  @override
  String get introTitle2 => 'Sfida il mondo';

  @override
  String get introTitle3 => 'Scala la classifica';

  @override
  String get invalidRoomQr => 'QR stanza non valido';

  @override
  String get inviteImage => 'Immagine d\'invito';

  @override
  String get inviteImageBody =>
      'Codice, QR e link in un\'unica immagine. Inviala su WhatsApp o dove vuoi.';

  @override
  String isThinking(String name) {
    return '$name sta pensando';
  }

  @override
  String get joinCaps => 'ENTRA';

  @override
  String joinForCoins(String n) {
    return 'ISCRIVITI PER $n MONETE';
  }

  @override
  String get joinRoomCaps => 'ENTRA NELLA STANZA';

  @override
  String get joinTheGame => 'Unisciti al gioco';

  @override
  String joinTournamentQuestion(String name) {
    return 'Partecipare a $name?';
  }

  @override
  String get joinWithCode => 'Entra con codice';

  @override
  String get joined => 'Iscritto';

  @override
  String get joiningCaps => 'INGRESSO…';

  @override
  String get joiningQueue => 'Ingresso in coda…';

  @override
  String get joiningRoom => 'Ingresso nella stanza…';

  @override
  String get keepWatchingCaps => 'CONTINUA A GUARDARE';

  @override
  String get language => 'Lingua';

  @override
  String get languageUpdated => 'Lingua aggiornata';

  @override
  String get last20Sent =>
      'Gli ultimi 20 messaggi vengono inviati con la segnalazione.';

  @override
  String get last7Games => 'Ultime 7 partite';

  @override
  String lastUpdated(String date) {
    return 'Ultimo aggiornamento $date';
  }

  @override
  String get later => 'Più tardi';

  @override
  String get latestVersion => 'Stai usando l\'ultima versione.';

  @override
  String get leaderboard => 'Classifica';

  @override
  String get leaderboardUpdated => 'Classifica aggiornata';

  @override
  String get leave => 'Esci';

  @override
  String get leaveForfeitBody =>
      'Uscire ora vale come resa. Vince il tuo avversario.';

  @override
  String get leaveGame => 'Esci dal gioco';

  @override
  String get leaveMatchQuestion => 'Abbandonare la partita?';

  @override
  String get leaveVideoQuestion => 'Uscire dal video?';

  @override
  String get letsPlay => 'Giochiamo';

  @override
  String get linkCopied => 'Link copiato';

  @override
  String get live => 'Live';

  @override
  String get liveEventCaps => 'EVENTO LIVE';

  @override
  String get loading => 'Caricamento…';

  @override
  String get local => 'Locale';

  @override
  String get locked => 'Bloccato';

  @override
  String get logOut => 'Esci';

  @override
  String get loginMethod => 'Metodo di accesso';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'Se chiudi ora non riceverai le 10 monete. Mancano $seconds secondi.';
  }

  @override
  String get losses => 'Sconfitte';

  @override
  String get markAllRead => 'Segna tutto come letto';

  @override
  String get marks => 'Simboli';

  @override
  String get match => 'Partita';

  @override
  String get matchAbandonedCaps => 'PARTITA ABBANDONATA';

  @override
  String matchDuration(String duration) {
    return 'Durata $duration';
  }

  @override
  String get matchHistory => 'Cronologia partite';

  @override
  String get matchHistoryCaps => 'CRONOLOGIA PARTITE';

  @override
  String get matchInvitations => 'Inviti alle partite';

  @override
  String get matchLobby => 'Lobby della partita';

  @override
  String get matchResult => 'Risultato';

  @override
  String get matchResults => 'Risultati partite';

  @override
  String get matchStakes => 'Puntate della partita';

  @override
  String get matchStartsIn => 'La partita inizia tra';

  @override
  String get matches => 'Partite';

  @override
  String get matchmakingError => 'Errore di matchmaking';

  @override
  String get matchmakingFailed => 'Matchmaking non riuscito';

  @override
  String get matchmakingStopped => 'Matchmaking interrotto';

  @override
  String memberSince(String date) {
    return 'Membro dal $date';
  }

  @override
  String get messageEmpty => 'Il messaggio non può essere vuoto';

  @override
  String get messagesStayForMatch =>
      'I messaggi restano solo per questa partita';

  @override
  String minusCoins(String n) {
    return '-$n monete';
  }

  @override
  String get misPlay30 => 'Gioca 30 partite';

  @override
  String get misPlay5 => 'Gioca 5 partite';

  @override
  String get misQuick => 'Gioca una partita casuale';

  @override
  String get misTourney => 'Partecipa a un torneo';

  @override
  String get misWin15 => 'Vinci 15 partite';

  @override
  String get misWin3 => 'Vinci 3 partite';

  @override
  String get misWin4x4 => 'Vinci su una griglia 4×4';

  @override
  String get missResets =>
      'Se salti un giorno si azzera. Torna domani per il prossimo premio.';

  @override
  String get missingChallengeData => 'Dati della sfida mancanti';

  @override
  String get missingEmail => 'Email mancante — torna indietro e riprova';

  @override
  String get missions => 'Missioni';

  @override
  String missionsDone(String done, String total) {
    return '$done di $total missioni completate';
  }

  @override
  String get mobileNotSupported =>
      'I numeri di cellulare non sono ancora supportati nella tua regione';

  @override
  String get mobileOptional => 'Numero di cellulare (facoltativo)';

  @override
  String mode(String n) {
    return 'Modalità $n';
  }

  @override
  String get more => 'Altro';

  @override
  String get moreGames => 'Altri giochi';

  @override
  String get music => 'Musica';

  @override
  String nOf5(String n) {
    return '$n di 5';
  }

  @override
  String get navPlay => 'Gioca';

  @override
  String get newCodeSent => 'Nuovo codice inviato — controlla la posta';

  @override
  String get newHere => 'Nuovo?';

  @override
  String get newMatchChallengeCaps => 'NUOVA SFIDA!';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get newPasswordBody =>
      'Inserisci una nuova password. Resterai connesso dopo il salvataggio.';

  @override
  String get newVersion => 'Nuova versione';

  @override
  String get newVersionReady => 'È pronta una nuova versione di DROTIX.';

  @override
  String get newVideosUnlockIn => 'Nuovi video gratis tra';

  @override
  String get next => 'Avanti';

  @override
  String get nextCaps => 'AVANTI';

  @override
  String get nextRound => 'Prossimo round';

  @override
  String get no => 'No';

  @override
  String get noChallenge => 'Nessuna sfida';

  @override
  String get noChallengesHere => 'Nessuna sfida qui.';

  @override
  String get noCloudMatches =>
      'Ancora nessuna partita nel cloud. Gioca contro The Doll da connesso per comparire qui.';

  @override
  String get noFriendsYet => 'Ancora nessun amico — cerca per aggiungerne.';

  @override
  String get noHistory => 'Nessuna cronologia';

  @override
  String get noMatchesYet => 'Ancora nessuna partita';

  @override
  String get noMessagesYet =>
      'Ancora nessun messaggio.\nVanno bene anche le risposte rapide.';

  @override
  String get noNotificationsYet => 'Ancora nessuna notifica';

  @override
  String get noOpponentFound => 'Nessun avversario trovato — riprova';

  @override
  String get noPendingRequests => 'Nessuna richiesta in sospeso.';

  @override
  String get noPlayersFound => 'Nessun giocatore trovato';

  @override
  String get noQrInPhoto => 'Nessun QR trovato nella foto';

  @override
  String get noRankedPlayers =>
      'Ancora nessun giocatore in classifica. Accedi e gioca per entrare.';

  @override
  String get noTransactions => 'Ancora nessuna transazione.';

  @override
  String get noVideoFound =>
      'Nessun video trovato. Il video gratis non è stato usato. Riprova tra un minuto.';

  @override
  String get noVideoNow => 'Nessun video disponibile ora. Riprova più tardi.';

  @override
  String get noVideoRightNow => 'Nessun video al momento';

  @override
  String get nobody => 'Nessuno';

  @override
  String get nobodyBlinked => 'Nessuno ha ceduto.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Nessuno ha ceduto. $name ti ha fermato.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name al momento non accetta sfide.';
  }

  @override
  String get notEnoughCoins => 'Monete insufficienti';

  @override
  String get notEnoughCoinsAnother =>
      'Monete insufficienti per un\'altra puntata.';

  @override
  String get notEnoughCoinsStake => 'Monete insufficienti per questa puntata.';

  @override
  String get notNow => 'Non ora';

  @override
  String get notSignedIn => 'Non hai effettuato l\'accesso';

  @override
  String get notSignedInYet =>
      'Accesso non ancora eseguito — apri prima il link';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name ha accettato la tua sfida. La partita inizia!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Sfida accettata';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name è in partita ora. Riprova più tardi.';
  }

  @override
  String get notifChallengeBusyTitle => 'Giocatore occupato';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name ha annullato la sfida';
  }

  @override
  String get notifChallengeCancelledTitle => 'Sfida annullata';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name ha rifiutato la tua sfida';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Sfida rifiutata';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name non ha risposto in tempo';
  }

  @override
  String get notifChallengeExpiredTitle => 'Sfida scaduta';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name ti ha sfidato a una partita';
  }

  @override
  String get notifChallengeRequestTitle => 'Nuova sfida';

  @override
  String get notifChannelDesc => 'Sfide, partite e monete';

  @override
  String get notifChannelName => 'Avvisi di gioco';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount monete aggiunte. Saldo: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Monete aggiunte';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount monete detratte. Saldo: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Monete detratte';

  @override
  String get notifCoinsPurchaseTitle => 'Acquisto completato';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'Hai guadagnato $amount monete. Saldo: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Ricompensa ricevuta';

  @override
  String get notifEmptyHint =>
      'Qui vedrai sfide, risultati delle partite e movimenti di monete.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name ha accettato la tua richiesta di amicizia';
  }

  @override
  String get notifFriendAcceptedTitle => 'Nuovo amico';

  @override
  String notifFriendRequestBody(String name) {
    return '$name vuole essere tuo amico';
  }

  @override
  String get notifFriendRequestTitle => 'Richiesta di amicizia';

  @override
  String get notifGeneric => 'Nuova notifica';

  @override
  String notifMatchBody(String name) {
    return 'La tua partita contro $name è finita';
  }

  @override
  String get notifMatchDrawTitle => 'Pareggio';

  @override
  String get notifMatchLostTitle => 'Hai perso';

  @override
  String get notifMatchWonTitle => 'Hai vinto!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name è entrato nella tua stanza privata';
  }

  @override
  String get notifRoomJoinedTitle => 'Giocatore entrato';

  @override
  String get notifications => 'Notifiche';

  @override
  String nowFriends(String name) {
    return 'Tu e $name ora siete amici';
  }

  @override
  String get nowFriendsShort => 'Ora siete amici';

  @override
  String get officialWebsite => 'Sito ufficiale';

  @override
  String get offlineAi => 'IA offline';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'Niente internet · Solo avversari IA · $size · Puntata $stake';
  }

  @override
  String get offlineBanner => 'Offline · Puoi ancora giocare contro The Doll';

  @override
  String get offlineBody =>
      'Partite online e tornei richiedono una connessione. Puoi comunque giocare contro The Doll.';

  @override
  String get offlineProfilesNote =>
      'Sono profili IA offline, non giocatori reali.';

  @override
  String get offlineSmart => 'Offline, avversario furbo';

  @override
  String get ok => 'OK';

  @override
  String get oneLastStepCaps => 'UN ULTIMO PASSO';

  @override
  String get online => 'Online';

  @override
  String get onlineMatch => 'Partita online';

  @override
  String get onlineMultiplayer => 'Multigiocatore online';

  @override
  String get onlineOfflineAi => 'Giocatori online · IA offline';

  @override
  String onlineStake(String stake) {
    return 'Online · Puntata $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name accetta sfide solo dagli amici. Aggiungilo prima.';
  }

  @override
  String get open => 'Apri';

  @override
  String get openedTheLink => 'Ho aperto il link';

  @override
  String get openingInstaller => 'Apertura del programma di installazione…';

  @override
  String get opponent => 'Avversario';

  @override
  String get opponentAdvances =>
      'Se non entri in tempo, passa il tuo avversario.';

  @override
  String get opponentDisconnected => 'L\'avversario si è disconnesso';

  @override
  String get opponentWins => 'Vince l\'avversario';

  @override
  String opponentsMove(String name) {
    return 'Tocca a $name';
  }

  @override
  String get or => 'Oppure';

  @override
  String get orEnterCodeCaps => 'OPPURE INSERISCI IL CODICE';

  @override
  String get otherEvents => 'Altri eventi';

  @override
  String get owned => 'Posseduto';

  @override
  String get passAndPlay => 'Passa e gioca';

  @override
  String get password => 'Password';

  @override
  String get passwordMin6 => 'La password deve avere almeno 6 caratteri';

  @override
  String get passwordUpdated => 'Password aggiornata';

  @override
  String get passwordsNoMatch => 'Le password non corrispondono';

  @override
  String get pasteCode => 'Incolla codice';

  @override
  String get pause => 'Pausa';

  @override
  String get paused => 'In pausa';

  @override
  String get perMove20s => '20 s per mossa';

  @override
  String get photoUpdated => 'Foto aggiornata';

  @override
  String get pickClosestReason =>
      'Cosa sta succedendo? Scegli il motivo più vicino.';

  @override
  String get pickYourGame => 'Scegli il gioco';

  @override
  String get playAgain => 'Gioca ancora';

  @override
  String get playAsGuest => 'Gioca come ospite';

  @override
  String get playCaps => 'GIOCA';

  @override
  String get playDollOffline => 'Gioca offline contro The Doll';

  @override
  String get playToBuildForm => 'Gioca una partita per vedere la tua forma.';

  @override
  String get playVsDoll => 'Gioca contro The Doll';

  @override
  String playVsName(String name) {
    return 'Gioca contro $name';
  }

  @override
  String get played => 'Giocate';

  @override
  String get player => 'Giocatore';

  @override
  String get player1 => 'Giocatore 1';

  @override
  String get player1Move => 'Tocca al giocatore 1';

  @override
  String get player1Wins => 'Vince il giocatore 1!';

  @override
  String get player2 => 'Giocatore 2';

  @override
  String get player2Move => 'Tocca al giocatore 2';

  @override
  String get player2Wins => 'Vince il giocatore 2!';

  @override
  String playerAdded(String name) {
    return '$name aggiunto';
  }

  @override
  String get playerBlocked => 'Giocatore bloccato';

  @override
  String playerIdLabel(String id) {
    return 'GIOCATORE $id';
  }

  @override
  String get playerUnblocked => 'Giocatore sbloccato';

  @override
  String get players => 'Giocatori';

  @override
  String get playersLeft => 'Giocatori rimasti';

  @override
  String get pleaseWait => 'Attendi…';

  @override
  String plusCoins(String n) {
    return '+$n monete';
  }

  @override
  String get podium => 'Podio';

  @override
  String get pointAtHostQr =>
      'Inquadra il QR dell\'host. È lo stesso codice della lobby.';

  @override
  String get pointCameraAtQr => 'Inquadra il QR della stanza';

  @override
  String pointsWins(String points, String wins) {
    return '$points pt · $wins vittorie';
  }

  @override
  String get popular => 'Popolare';

  @override
  String get previousMatchExpired =>
      'La partita precedente è scaduta. Riprova tra poco.';

  @override
  String get privacy => 'Privacy';

  @override
  String privacyBody(String email) {
    return 'Raccogliamo solo i dati di gioco necessari al funzionamento dell\'app (monete, oggetti estetici, cronologia e impostazioni). Per giocare come ospite non serve un account.\n\nSe accedi, i tuoi dati servono solo a salvare e ripristinare i progressi. Non vendiamo dati personali. Puoi eliminarli quando vuoi da Impostazioni → Elimina account.\n\nContatti: $email';
  }

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get privateOnlyYou => 'Privato. Solo tu puoi vederlo.';

  @override
  String get privateRoomByUsername => 'Stanza privata (per nome)';

  @override
  String get privateRoomCaps => 'STANZA PRIVATA';

  @override
  String get prizeAdded => 'Premio aggiunto al saldo';

  @override
  String get prizePool => 'Montepremi';

  @override
  String get profile => 'Profilo';

  @override
  String get profileNotFound => 'Profilo non trovato';

  @override
  String get profilePrivacyNote =>
      'Cronologia e attività restano private. La segnalazione è per abusi del profilo; per la chat in partita usa il pulsante Segnala della chat.';

  @override
  String get profileUpdated => 'Profilo aggiornato';

  @override
  String progressOf(String done, String total) {
    return '$done di $total';
  }

  @override
  String get publicStatsNote =>
      'Solo posizione, punti e vittorie sono pubblici. Cronologia e attività restano private.';

  @override
  String get purchaseFailed => 'Acquisto non riuscito';

  @override
  String get purchases => 'Acquisti';

  @override
  String get purchasesComingSoon =>
      'L\'acquisto di monete arriverà presto. Guarda un video in Monete gratis per ottenerle subito.';

  @override
  String get quarter => 'Quarti';

  @override
  String get quarterFinal => 'Quarti di finale';

  @override
  String get quickCloseOne => 'Per un pelo!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'Bella mossa!';

  @override
  String quickMatchVsAi(String time) {
    return 'Partita rapida contro IA · $time';
  }

  @override
  String get quitMatch => 'Abbandona partita';

  @override
  String get randomMatch => 'Partita casuale';

  @override
  String get rank => 'Posizione';

  @override
  String rankScore(String rank, String score) {
    return 'Posizione #$rank · Punti $score';
  }

  @override
  String get rankScoreUnknown => 'Posizione – · Punti –';

  @override
  String get ranks => 'Classifica';

  @override
  String get rateApp => 'Valuta l\'app';

  @override
  String get ratingsSoon => 'Le valutazioni arriveranno presto';

  @override
  String get readOnly => 'sola lettura';

  @override
  String get readyCaps => 'PRONTO';

  @override
  String get reasonHarassment => 'Molestie o bullismo';

  @override
  String get reasonInappropriate => 'Contenuti sessuali o inappropriati';

  @override
  String get reasonOffensive => 'Incitamento all\'odio o insulti';

  @override
  String get reasonOther => 'Altro';

  @override
  String get reasonSpam => 'Spam o truffe';

  @override
  String get reasonThreatening => 'Minacce o violenza';

  @override
  String get received => 'Ricevute';

  @override
  String get reconnecting => 'Riconnessione…';

  @override
  String reference(String id) {
    return 'Riferimento: $id';
  }

  @override
  String get referralCode => 'Codice invito';

  @override
  String get referralHint => 'Codice invito (facoltativo)';

  @override
  String get referralOnce =>
      'Il codice invito si può usare una sola volta, subito dopo l\'iscrizione.';

  @override
  String get referralPrompt =>
      'Hai un codice da un amico? Inseriscilo ora e ottieni 50 monete.';

  @override
  String get referralWorked =>
      'Il codice ha funzionato. Le monete sono nel tuo portafoglio.';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get refreshStatus => 'Aggiorna stato';

  @override
  String get region => 'Regione';

  @override
  String get regionIndiaNote =>
      'Rilevato automaticamente da SIM o dispositivo. In India lingue indiane e prezzi in ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Rilevato automaticamente da SIM o dispositivo. Lingue internazionali, prezzi in $currency.';
  }

  @override
  String get register => 'Registrati';

  @override
  String get released => 'Rilasciata';

  @override
  String get rematch => 'Rivincita';

  @override
  String get rematchQuestion => 'Rivincita?';

  @override
  String get remindMe => 'Ricordamelo prima della partita';

  @override
  String get reportButtonCaps => 'PULSANTE SEGNALA';

  @override
  String get reportButtonHelp =>
      'In alto a destra nella chat dal vivo, accanto a Ferma chat. Sempre visibile con la chat attiva.\nTocca → scegli un motivo → aggiungi dettagli e screenshot → invia.';

  @override
  String get reportCaps => 'SEGNALA';

  @override
  String get reportFailed => 'Segnalazione non riuscita';

  @override
  String reportName(String name) {
    return 'Segnala $name';
  }

  @override
  String get reportOrBlock => 'Segnala o blocca';

  @override
  String get reportOrBlockPlayer => 'Segnala o blocca questo giocatore';

  @override
  String get reportPlayer => 'Segnala giocatore';

  @override
  String get requestSentCaps => 'RICHIESTA INVIATA';

  @override
  String requestSentTo(String name) {
    return 'Richiesta inviata a $name';
  }

  @override
  String get requests => 'Richieste';

  @override
  String requestsCount(String n) {
    return 'Richieste · $n';
  }

  @override
  String get requestsExpire7d =>
      'Le richieste scadono dopo 7 giorni senza risposta.';

  @override
  String get resendCode => 'Invia di nuovo il codice';

  @override
  String get resendEmail => 'Invia di nuovo l\'email';

  @override
  String get resetCode => 'Codice di reset';

  @override
  String resetCodeSentTo(String target) {
    return 'Abbiamo inviato un codice a $target.\nInseriscilo qui sotto — non serve aprire il link.';
  }

  @override
  String get resetPassword => 'Reimposta password';

  @override
  String get resetPasswordBody =>
      'Inserisci la tua email e ti invieremo un codice. Digitalo nell\'app — non serve aprire il link.';

  @override
  String get restart => 'Ricomincia';

  @override
  String get result => 'Risultato';

  @override
  String get resume => 'Riprendi';

  @override
  String get returnToMainMenu => 'Torna al menu principale';

  @override
  String get rewardEarnedCaps => 'PREMIO OTTENUTO';

  @override
  String get rewardFlowOverview => 'Panoramica dei premi';

  @override
  String rewardIn(String time) {
    return 'Premio tra $time';
  }

  @override
  String get rivalO => 'Avversario: O';

  @override
  String get roomCancelled => 'Stanza annullata';

  @override
  String roomClosesIn(String time) {
    return 'La stanza si chiude tra $time se nessuno entra.';
  }

  @override
  String get roomClosesSoon => 'La stanza si chiuderà presto se nessuno entra.';

  @override
  String get roomClosing => 'La stanza si sta chiudendo…';

  @override
  String get roomCodeCaps => 'CODICE STANZA';

  @override
  String get roomCodeCopied => 'Codice stanza copiato';

  @override
  String get roomExpired => 'Stanza scaduta';

  @override
  String get roomOpenCaps => 'STANZA APERTA';

  @override
  String get roundOf16 => 'Ottavi';

  @override
  String get roundOf16Caps => 'OTTAVI';

  @override
  String roundOf16Vs(String name) {
    return 'Ottavi · contro $name';
  }

  @override
  String get roundsWon => 'Round vinti';

  @override
  String get row => 'Riga';

  @override
  String get ruleEmoji =>
      '• Le reazioni emoji funzionano senza richiesta e si possono silenziare.';

  @override
  String get ruleEnds => '• La chat termina automaticamente a fine partita.';

  @override
  String get ruleStop =>
      '• Ogni giocatore può fermare la chat in qualsiasi momento.';

  @override
  String get ruleVanish =>
      '• I messaggi spariscono in pochi secondi e non vengono mai salvati.';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get savePassword => 'Salva password';

  @override
  String get saving => 'Salvataggio…';

  @override
  String get savingToCloud => 'Salvataggio nel cloud…';

  @override
  String get scanOrShare => 'Scansiona per entrare o condividi il link';

  @override
  String get scanQr => 'Scansiona QR';

  @override
  String get score => 'Punti';

  @override
  String get scorePlus10 => 'Punti +10';

  @override
  String get screenshotTooBig => 'Lo screenshot deve essere inferiore a 2 MB';

  @override
  String get screenshotsOptionalCaps => 'SCREENSHOT (FACOLTATIVI)';

  @override
  String get searchPlayersHint => 'Cerca per nome utente o ID giocatore';

  @override
  String get searchResults => 'Risultati';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'Online · $size · puntata $stake · $time';
  }

  @override
  String get seatWaiting => 'Giocatore, il tuo posto ti aspetta.';

  @override
  String secondsLeft(String seconds) {
    return 'Restano ${seconds}s';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'Restano ${seconds}s per rispondere';
  }

  @override
  String get selectDifficulty => 'Scegli la difficoltà';

  @override
  String get selectOpponent => 'Seleziona un avversario';

  @override
  String get selectReportReason => 'Scegli un motivo';

  @override
  String get semi => 'Semi';

  @override
  String get send => 'Invia';

  @override
  String get sendChallenge => 'Invia sfida';

  @override
  String get sendResetCode => 'Invia codice';

  @override
  String get sending => 'Invio…';

  @override
  String get sendingMove => 'Invio della mossa…';

  @override
  String get sent => 'Inviata';

  @override
  String serverTournamentsDemo(String error) {
    return 'Tornei del server non disponibili — mostro una demo.\n$error';
  }

  @override
  String get sessionExpiredReset =>
      'Sessione scaduta — richiedi un nuovo codice';

  @override
  String get settings => 'Impostazioni';

  @override
  String get shareComingSoon => 'Condivisione in arrivo';

  @override
  String get shareInviteCaps => 'CONDIVIDI INVITO';

  @override
  String get shareOnWhatsApp => 'Condividi su WhatsApp';

  @override
  String get shareProfile => 'Condividi profilo';

  @override
  String shareWin(String url) {
    return 'Ho appena vinto una partita a DROTIX! Pensi di battermi? Gioca ora: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'Ho appena battuto $name su DROTIX! Pensi di battermi? Gioca ora: $url';
  }

  @override
  String get shop => 'Negozio';

  @override
  String get showHidePassword => 'Mostra o nascondi password';

  @override
  String get signIn => 'Accedi';

  @override
  String get signInChangePhoto => 'Accedi per cambiare foto';

  @override
  String get signInFindFriends => 'Accedi per trovare amici';

  @override
  String get signInMatchmaking => 'Accedi per il matchmaking online';

  @override
  String get signInNotifications => 'Accedi per vedere le tue notifiche';

  @override
  String get signInOnline => 'Accedi per giocare online';

  @override
  String get signInRandomMatch =>
      'Accedi per giocare partite casuali contro giocatori veri';

  @override
  String get signInRequired => 'Accesso richiesto';

  @override
  String get signInSearchPlayers =>
      'Accedi per cercare giocatori e sincronizzare gli amici nel cloud.';

  @override
  String get signInToAddFriends => 'Accedi per aggiungere amici';

  @override
  String get signInToChallenge => 'Accedi per sfidare questo giocatore';

  @override
  String get signInWalletHistory =>
      'Accedi per vedere la cronologia del portafoglio.';

  @override
  String get signInWithEmail => 'Accedi con email';

  @override
  String get signOut => 'Esci';

  @override
  String get signUp => 'Registrati';

  @override
  String get skip => 'Salta';

  @override
  String get skipForNow => 'Salta per ora';

  @override
  String get somethingWentWrong => 'Qualcosa è andato storto';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Qualcosa è andato storto: $error';
  }

  @override
  String get soundDisabled => 'Audio disattivato';

  @override
  String get soundEffects => 'Effetti sonori';

  @override
  String get soundEnabled => 'Audio attivo';

  @override
  String get spent => 'Spesi';

  @override
  String get sponsored => 'Sponsorizzato';

  @override
  String stakeDot(String n) {
    return 'Puntata · $n';
  }

  @override
  String get stakeReturned => 'Puntata restituita';

  @override
  String stakeRoom(String stake, String room) {
    return 'Puntata $stake · $room…';
  }

  @override
  String get start => 'Inizia';

  @override
  String get startPlayingCaps => 'INIZIA A GIOCARE';

  @override
  String get starterPack => 'Pacchetto base';

  @override
  String get starting => 'Avvio…';

  @override
  String get startsInCaps => 'INIZIA TRA';

  @override
  String get stats => 'Statistiche';

  @override
  String statusLabel(String status) {
    return 'Stato: $status';
  }

  @override
  String get stayInApp =>
      'Resta nell\'app. Ti avviseremo quando la partita è pronta.';

  @override
  String get stillOffline =>
      'Ancora offline. Controlla la connessione e riprova.';

  @override
  String get stopChat => 'Ferma chat';

  @override
  String get submitAppeal => 'Invia ricorso';

  @override
  String get submitReportCaps => 'INVIA SEGNALAZIONE';

  @override
  String submittedAt(String date) {
    return 'Inviato: $date';
  }

  @override
  String get submitting => 'Invio…';

  @override
  String get submittingCaps => 'INVIO…';

  @override
  String get supportEmail => 'Email di supporto';

  @override
  String suspendedAt(String date) {
    return 'Sospeso: $date';
  }

  @override
  String get suspendedByModerator =>
      'Un moderatore ha sospeso l\'account dopo aver esaminato una segnalazione.';

  @override
  String get suspendedRules =>
      'Durante la sospensione non puoi giocare, entrare nelle stanze o usare la chat. Puoi inviare un ricorso.';

  @override
  String get t20Seconds => '20 secondi per mossa';

  @override
  String get tDrawReplays => 'In caso di pareggio si rigioca il round';

  @override
  String get tSingleElim => 'Eliminazione diretta: perdi una volta e sei fuori';

  @override
  String get tSingleElimFee =>
      'Eliminazione diretta. Se perdi un round sei fuori e la quota non viene restituita.';

  @override
  String get tagline => 'Il piccolo gioco più letale';

  @override
  String get takeTurnsBody =>
      'Tu e il tuo avversario mettete un simbolo a turno. Tocca una casella vuota per giocare.';

  @override
  String get takeTurnsCaps => 'A TURNO';

  @override
  String get takesFewSeconds => 'Di solito servono pochi secondi.';

  @override
  String get tapEmptySquare => 'Tocca una casella vuota';

  @override
  String get tbd => 'Da definire';

  @override
  String get tellUsMin10 => 'Raccontaci cos\'è successo (almeno 10 caratteri)';

  @override
  String get termsAccountBody =>
      'Tieni al sicuro l\'accesso. Sei responsabile dell\'attività del tuo account.';

  @override
  String get termsAccountTitle => '2. Il tuo account';

  @override
  String get termsChangesBody =>
      'Possiamo aggiornare questi termini. Continuare a usare l\'app significa accettarli.';

  @override
  String get termsChangesTitle => '5. Modifiche';

  @override
  String get termsCoinsBody =>
      'Le monete sono oggetti virtuali senza valore in denaro e non possono essere convertite in soldi.';

  @override
  String get termsCoinsTitle => '3. Monete virtuali';

  @override
  String get termsFairBody =>
      'Niente imbrogli, insulti o molestie. Possiamo sospendere gli account che violano le regole.';

  @override
  String get termsFairTitle => '4. Fair play e chat';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get termsUsingBody =>
      'Devi rispettare questi termini e giocare lealmente.';

  @override
  String get termsUsingTitle => '1. Uso di DROTIX';

  @override
  String get theirTurnCaps => 'TOCCA ALL\'AVVERSARIO';

  @override
  String get threeInRowBody =>
      'Allinea tre simboli in riga, colonna o diagonale prima del tuo avversario.';

  @override
  String get threeInRowCaps => 'TRIS';

  @override
  String timeDaysAgo(String n) {
    return '$n g fa';
  }

  @override
  String timeHoursAgo(String n) {
    return '$n h fa';
  }

  @override
  String get timeJustNow => 'Adesso';

  @override
  String timeMinutesAgo(String n) {
    return '$n min fa';
  }

  @override
  String get timeSkipped => 'Se finisce il tempo, la mossa viene saltata.';

  @override
  String timesUp(String who) {
    return 'Tempo scaduto · $who';
  }

  @override
  String get today => 'Oggi';

  @override
  String get todayCaps => 'OGGI';

  @override
  String get top16 => 'Top 16';

  @override
  String get totalCoinsCaps => 'MONETE TOTALI';

  @override
  String get tournament => 'Torneo';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get tryAgainCaps => 'RIPROVA';

  @override
  String get twoPlayers => 'Due giocatori, un telefono';

  @override
  String get txChallengeEntry => 'Ingresso sfida';

  @override
  String get txCoinPurchase => 'Acquisto monete';

  @override
  String txDailyBonus(String time) {
    return 'Bonus giornaliero · $time';
  }

  @override
  String get txDailyReward => 'Premio giornaliero';

  @override
  String get txFreeVideo => 'Premio video';

  @override
  String get txMatchWin => 'Vittoria';

  @override
  String txPurchasing(String time) {
    return 'Acquisto monete · $time';
  }

  @override
  String txReferral(String time) {
    return 'Codice invito · $time';
  }

  @override
  String txTournament(String time) {
    return 'Torneo · $time';
  }

  @override
  String get txTournamentPrize => 'Premio torneo';

  @override
  String txWatchingAds(String time) {
    return 'Annunci guardati · $time';
  }

  @override
  String get txWelcomeBonus => 'Bonus di benvenuto';

  @override
  String txWinning(String time) {
    return 'Partite vinte · $time';
  }

  @override
  String get typeMessage => 'Scrivi un messaggio';

  @override
  String get unblockPlayer => 'Sblocca giocatore';

  @override
  String get unblockToAdd => 'Sblocca il giocatore per aggiungerlo';

  @override
  String get unblockToChallenge => 'Sblocca il giocatore per sfidarlo';

  @override
  String unlockFor(String n) {
    return 'Sblocca · $n monete';
  }

  @override
  String get unlocked => 'Sbloccato';

  @override
  String unlockedCount(String n, String total) {
    return '$n di $total sbloccati';
  }

  @override
  String get unranked => 'Non classificato';

  @override
  String get upTo3Images =>
      'Fino a 3 immagini. Solo il nostro team può vederle.';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String get updateFailed => 'Aggiornamento non riuscito';

  @override
  String get updateOnAppStore => 'Aggiorna dall\'App Store';

  @override
  String get updateRequired => 'Aggiornamento necessario';

  @override
  String get updatesOnlyMobile =>
      'Gli aggiornamenti sono disponibili su Android e iOS.';

  @override
  String get useChatReport =>
      'Usa Chat → Segnala durante la partita per segnalazioni con prove.';

  @override
  String get username => 'Nome utente';

  @override
  String get usernameHint => 'Nome utente (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Verifica codice';

  @override
  String get verifyFailBody =>
      'Può succedere con una connessione debole o se il premio è già stato riscattato. Le monete sono al sicuro.';

  @override
  String get verifying => 'Verifica…';

  @override
  String get verifyingReward => 'Verifica del premio';

  @override
  String versionLabel(String version) {
    return 'Versione $version';
  }

  @override
  String get versionUnsupported =>
      'Questa versione non è più supportata. Aggiorna per continuare a giocare.';

  @override
  String get vibration => 'Vibrazione';

  @override
  String get victory => 'VITTORIA';

  @override
  String get videoLength =>
      'Il video dura circa 15-30 secondi. Guardalo fino alla fine per ricevere le monete.';

  @override
  String get videos => 'Video';

  @override
  String get viewAppealStatus => 'Stato del ricorso';

  @override
  String get viewBracket => 'Vedi tabellone';

  @override
  String get viewBracketCaps => 'VEDI TABELLONE';

  @override
  String get viewProfile => 'Vedi profilo';

  @override
  String vsName(String name) {
    return 'contro $name';
  }

  @override
  String get waitingCaps => 'IN ATTESA';

  @override
  String waitingForAccept(String name) {
    return 'In attesa che $name accetti…';
  }

  @override
  String get waitingForFriend => 'In attesa di un amico...';

  @override
  String get waitingOtherMatches => 'In attesa delle altre partite';

  @override
  String get waitingRoundOpen => 'In attesa dell\'apertura del round';

  @override
  String get wallet => 'Portafoglio';

  @override
  String get walletBalance => 'Saldo portafoglio';

  @override
  String get walletCaps => 'PORTAFOGLIO';

  @override
  String get walletUnavailable => 'Portafoglio non disponibile';

  @override
  String watchAnotherLeft(String n) {
    return 'GUARDANE UN ALTRO (NE RESTANO $n)';
  }

  @override
  String get watchBracketCaps => 'SEGUI IL TABELLONE';

  @override
  String get watchFullVideo =>
      'Guarda tutto il video per ricevere le monete bonus.';

  @override
  String get watchNowCaps => 'GUARDA ORA';

  @override
  String get watchShortVideo => 'Guarda un breve video';

  @override
  String watchShortVideoToGet(String n) {
    return 'Guarda un breve video per ottenere +$n';
  }

  @override
  String get watchVideo => 'GUARDA VIDEO';

  @override
  String get watchVideoCoins => 'Guarda un video, ottieni 10 monete';

  @override
  String get weekly => 'Settimanale';

  @override
  String get weeklyChest => 'Forziere settimanale';

  @override
  String get welcomeBack => 'Bentornato';

  @override
  String get welcomeBonusCaps => 'BONUS DI BENVENUTO';

  @override
  String welcomeName(String name) {
    return 'Benvenuto, $name';
  }

  @override
  String get whatHappenedCaps => 'COSA È SUCCESSO';

  @override
  String get whatHappenedHint =>
      'Racconta cos\'è successo e perché segnali questo giocatore';

  @override
  String get whatsNewCaps => 'NOVITÀ';

  @override
  String get whoCanChallenge => 'Chi può sfidarti';

  @override
  String get whoCanMessage => 'Chi può inviarti messaggi';

  @override
  String get winRate => 'Percentuale vittorie';

  @override
  String get winner => 'VINCITORE';

  @override
  String get wins => 'Vittorie';

  @override
  String winsThisRound(String name) {
    return '$name vince questo round.';
  }

  @override
  String get yesDelete => 'Sì, elimina';

  @override
  String get yesterday => 'Ieri';

  @override
  String get yesterdayCaps => 'IERI';

  @override
  String get you => 'Tu';

  @override
  String youBeat(String name) {
    return 'Hai battuto $name.';
  }

  @override
  String get youFinished => 'Il tuo piazzamento';

  @override
  String get youLose => 'Hai perso';

  @override
  String youMark(String mark) {
    return 'Tu · $mark';
  }

  @override
  String get youWin => 'Hai vinto!';

  @override
  String get youWinCaps => 'HAI VINTO';

  @override
  String get youX => 'Tu: X';

  @override
  String yourBalance(String n) {
    return 'Il tuo saldo: $n monete';
  }

  @override
  String get yourEmail => 'la tua email';

  @override
  String get yourMatchReadyCaps => 'LA TUA PARTITA È PRONTA';

  @override
  String get yourMove => 'Tocca a te';

  @override
  String get yourNextMatch => 'La tua prossima partita';

  @override
  String get yourTurnCaps => 'TOCCA A TE';

  @override
  String get youreInCaps => 'SEI DENTRO';

  @override
  String get youreInViewBracket => 'SEI DENTRO — VEDI TABELLONE';

  @override
  String get youreOffline => 'Sei offline';
}
