// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX est un morpion rapide et compétitif. Jouez contre l\'ordinateur, affrontez de vrais joueurs, défiez vos amis et grimpez au classement.';

  @override
  String get aboutUs => 'À propos';

  @override
  String get accept => 'Accepter';

  @override
  String get acceptCaps => 'ACCEPTER';

  @override
  String get acceptRequestCaps => 'ACCEPTER LA DEMANDE';

  @override
  String get accountCheckFailed => 'Échec de la vérification du compte';

  @override
  String get accountIsSuspended => 'Votre compte est suspendu.';

  @override
  String get accountRestricted =>
      'Votre compte reste restreint jusqu\'à la fin de l\'examen. Jeu, matchmaking et chat restent bloqués.';

  @override
  String get accountStatusUnknown => 'État du compte inconnu. Réessayez.';

  @override
  String get accountSuspended => 'Compte suspendu';

  @override
  String get accountSuspendedSignIn =>
      'Votre compte a été suspendu. Connectez-vous pour voir les détails ou faire appel.';

  @override
  String get accountSuspendedTitle => 'Votre compte a été suspendu';

  @override
  String get ach100Wins => '100 victoires';

  @override
  String get ach10Matches => '10 matchs';

  @override
  String get ach50Matches => '50 matchs';

  @override
  String get achChallenger => 'Challenger';

  @override
  String get achChampion => 'Champion';

  @override
  String get achFirstWin => 'Première victoire';

  @override
  String get achScore100 => 'Score 100';

  @override
  String get achStreak3 => 'Série de 3';

  @override
  String get achStreak5 => 'Série de 5';

  @override
  String get achSurvivor => 'Survivant';

  @override
  String get achTop3 => 'Top 3';

  @override
  String get achievements => 'Succès';

  @override
  String get add => 'Ajouter';

  @override
  String get addFriend => 'Ajouter en ami';

  @override
  String get addFriendCaps => 'AJOUTER EN AMI';

  @override
  String get advanceQuarter => 'Vous passez en quart de finale';

  @override
  String get advancedMode => 'Mode avancé (4×4)';

  @override
  String get advertiserApp => 'Appli de l\'annonceur';

  @override
  String get advertiserVideo => 'La vidéo publicitaire s\'affiche ici';

  @override
  String get all => 'Tout';

  @override
  String get allowAndInstall => 'Autoriser et installer';

  @override
  String get allowUnknownApps =>
      'Autorisez « Installer des applis inconnues » pour DROTIX, puis revenez. La mise à jour s\'installera automatiquement.';

  @override
  String get alreadyPlayer => 'Déjà joueur ?';

  @override
  String get alsoBlock => 'Bloquer aussi ce joueur';

  @override
  String get alwaysTrue => 'Toujours';

  @override
  String get appUpdate => 'Mise à jour de l\'appli';

  @override
  String get appealExplain =>
      'Expliquez pourquoi votre compte devrait être rétabli. Un modérateur examinera votre message.';

  @override
  String get appealFailed => 'Échec de l\'appel';

  @override
  String get appealHint => 'Rédigez votre appel (20 caractères min.)…';

  @override
  String get appealIsUnderReview => 'Votre appel est en cours d\'examen.';

  @override
  String get appealMin20 => 'L\'appel doit contenir au moins 20 caractères';

  @override
  String get appealSubmitted => 'Appel envoyé avec succès';

  @override
  String get appealSuspension => 'Contester la suspension';

  @override
  String get appealUnderReview => 'Appel en cours d\'examen';

  @override
  String get applyCodeCaps => 'APPLIQUER LE CODE';

  @override
  String get attachRecentChat => 'Joindre les messages récents';

  @override
  String get attemptingReconnect => 'Tentative de reconnexion…';

  @override
  String get auto => 'Auto';

  @override
  String get avatars => 'Avatars';

  @override
  String get back => 'Retour';

  @override
  String get backToEvent => 'Retour à l\'événement';

  @override
  String get backToEvents => 'Retour aux événements';

  @override
  String get backToEventsCaps => 'RETOUR AUX ÉVÉNEMENTS';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get backToMenu => 'Retour au menu';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String balance(String n) {
    return 'Solde $n';
  }

  @override
  String get balanceAfter => 'Solde après';

  @override
  String balanceArrow(String from) {
    return 'Solde $from →';
  }

  @override
  String get bestStreak => 'Meilleure série';

  @override
  String get bestValue => 'Meilleure offre';

  @override
  String get biggerBoardsBody =>
      'Sur les grands plateaux, il faut en aligner quatre. Si le plateau se remplit sans ligne, c\'est nul.';

  @override
  String get biggerBoardsCaps => 'GRANDS PLATEAUX';

  @override
  String get biggerNeedFour => 'Les grands plateaux exigent quatre d\'affilée';

  @override
  String get blockPlayer => 'Bloquer le joueur';

  @override
  String get boardHiddenUntilBack =>
      'Le plateau est masqué jusqu\'à votre retour.';

  @override
  String get boards => 'Plateaux';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n pièces ajoutées à votre portefeuille';
  }

  @override
  String get bonusClaimed => 'Bonus obtenu !';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n pièces bonus ajoutées';
  }

  @override
  String get bracket => 'Tableau';

  @override
  String get bracketInfo =>
      'Huitièmes · 8 matchs, 4 affichés. Vous êtes en surbrillance.';

  @override
  String get buyCoinsCaps => 'ACHETER DES PIÈCES';

  @override
  String get byBoard => 'Par plateau';

  @override
  String get cameraOnlyForScan =>
      'La caméra sert uniquement à scanner le code.';

  @override
  String get cameraPermissionNeeded =>
      'Autorisation de la caméra requise pour scanner. Vous pouvez aussi saisir le code ci-dessous.';

  @override
  String get cameraPermissionRequired =>
      'L\'accès à la caméra est requis pour scanner le QR du salon. Activez-le dans les réglages système, puis réessayez.';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancelChallenge => 'Annuler le défi';

  @override
  String get cancelDownload => 'Annuler le téléchargement';

  @override
  String get cannotChallengeSelf => 'Vous ne pouvez pas vous défier vous-même';

  @override
  String get cannotFriendSelf => 'Vous ne pouvez pas vous ajouter en ami';

  @override
  String get cantChallengeNow =>
      'Vous ne pouvez pas défier ce joueur pour le moment.';

  @override
  String get challenge => 'Défi';

  @override
  String get challengeAccepted => 'Défi accepté';

  @override
  String get challengeCancelled => 'Défi annulé';

  @override
  String get challengeCaps => 'DÉFIER';

  @override
  String get challengeClosed => 'Défi clos';

  @override
  String get challengeDeclined => 'Défi refusé';

  @override
  String get challengeExpired => 'Défi expiré';

  @override
  String get challengeExpiresIn60 =>
      'Le défi expire dans 60 secondes s\'il n\'est pas accepté.';

  @override
  String get challengePrivacy => 'Confidentialité des défis';

  @override
  String get challengeRequests => 'Demandes de défi';

  @override
  String get challengeSentCoins => 'Défi envoyé · 5 pièces';

  @override
  String get challengeSentFree => 'Défi envoyé · Match gratuit';

  @override
  String get challenges => 'Défis';

  @override
  String get championCaps => 'CHAMPION';

  @override
  String get change => 'Modifier';

  @override
  String get chat => 'Chat';

  @override
  String get chatAfterAccept => 'Chat après acceptation par les deux joueurs.';

  @override
  String get chatAfterAcceptRandom =>
      'Chat après acceptation des deux. Seul le pseudo est partagé.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name n\'accepte que les messages de ses amis.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name a désactivé les messages.';
  }

  @override
  String get chatNotConnected => 'Le chat n\'est pas connecté';

  @override
  String get chatOn => 'Chat activé';

  @override
  String get chatPrivacyNote =>
      'S\'applique au chat en match. Les changements sont immédiats, même pendant un match.';

  @override
  String get chatRules => 'Règles du chat';

  @override
  String get chatRulesIntro =>
      'Le chat ne démarre jamais tout seul. Un joueur demande, l\'autre doit accepter.';

  @override
  String get checkAgainCaps => 'VÉRIFIER À NOUVEAU';

  @override
  String get checkEmail => 'Vérifiez vos e-mails';

  @override
  String get checkEmailConfirm =>
      'Consultez vos e-mails et ouvrez le lien de confirmation';

  @override
  String get checkForUpdates => 'Rechercher des mises à jour';

  @override
  String get checkInbox => 'Vérifiez votre boîte de réception';

  @override
  String get checking => 'Vérification…';

  @override
  String get chooseEntryStake => 'Choisissez votre mise d\'entrée';

  @override
  String get chooseGameMode => 'Choisissez le mode de jeu';

  @override
  String get chooseNewPassword => 'Choisissez un nouveau mot de passe';

  @override
  String get chooseOpponent => 'Choisissez un adversaire';

  @override
  String get claim => 'OBTENIR';

  @override
  String claimBonusCoins(String n) {
    return 'Obtenez $n pièces bonus';
  }

  @override
  String get claimLabel => 'Obtenir';

  @override
  String claimPlusCoins(String n) {
    return 'Obtenir +$n pièces';
  }

  @override
  String get claimVictory => 'Réclamer la victoire';

  @override
  String get claimsSync => 'Les récompenses se synchronisent avec votre compte';

  @override
  String get classicMode => 'Mode classique (3×3)';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get clipboardNoCode => 'Aucun code de salon dans le presse-papiers';

  @override
  String get close => 'Fermer';

  @override
  String get closeAndLose => 'Fermer et perdre la récompense';

  @override
  String get closeRoom => 'Fermer le salon';

  @override
  String get closing => 'Fermeture…';

  @override
  String get cloud => 'Cloud';

  @override
  String cloudSaveFailed(String message) {
    return 'Échec de la sauvegarde cloud : $message';
  }

  @override
  String get codeSent => 'Code envoyé';

  @override
  String get coinPacks => 'Packs de pièces';

  @override
  String coinPacksFrom(String price) {
    return 'PACKS À PARTIR DE $price';
  }

  @override
  String get coins5 => '5 pièces';

  @override
  String coinsAdded(String n) {
    return '+$n pièces ajoutées';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Pièces $delta · Solde $balance';
  }

  @override
  String get coinsEntryFee => 'Entrée à 5 pièces';

  @override
  String get coinsEntryFeeBody =>
      'Utilisé quand les matchs gratuits sont épuisés, ou pour augmenter la mise.';

  @override
  String coinsLabel(String n) {
    return '$n pièces';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n pièces (enregistré dans le cloud)';
  }

  @override
  String get column => 'Colonne';

  @override
  String get comeBackTomorrow => 'Revenez demain';

  @override
  String get completeGoogleReturnApp =>
      'Terminez la connexion Google, puis revenez à l\'appli';

  @override
  String get completeGoogleSignIn =>
      'Terminez la connexion Google, puis revenez';

  @override
  String get computer => 'Ordinateur';

  @override
  String get confirm => 'Confirmer';

  @override
  String get confirmJoinCaps => 'CONFIRMER ET REJOINDRE';

  @override
  String confirmLinkSentTo(String target) {
    return 'Nous avons envoyé un lien de confirmation à $target.\nOuvrez-le sur cet appareil puis revenez — vous serez connecté automatiquement.';
  }

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get confirmationEmailSent =>
      'E-mail de confirmation envoyé — vérifiez votre boîte';

  @override
  String get confirmingVideo =>
      'Nous confirmons que la vidéo a été regardée. Patientez.';

  @override
  String get connectingChat => 'Connexion du chat…';

  @override
  String get connectionUnstable => 'Connexion instable';

  @override
  String get connectionUnstableCaps => 'CONNEXION INSTABLE';

  @override
  String get contactAbout => 'Contact et à propos';

  @override
  String get contactUsCaps => 'NOUS CONTACTER';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get continuePlaying => 'Continuer à jouer';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String copiedValue(String label, String value) {
    return '$label copié : $value';
  }

  @override
  String get couldNotAddCoins => 'Impossible d\'ajouter les pièces';

  @override
  String get couldNotApplyReferral => 'Impossible d\'appliquer le code';

  @override
  String couldNotCheck(String error) {
    return 'Vérification impossible : $error';
  }

  @override
  String get couldNotJoinRoom => 'Impossible de rejoindre le salon';

  @override
  String get couldNotLoadPrivacy => 'Impossible de charger la confidentialité';

  @override
  String get couldNotLoadProfile =>
      'Impossible de charger votre profil. Réessayez.';

  @override
  String get couldNotOpenGoogle => 'Impossible d\'ouvrir la connexion Google';

  @override
  String get couldNotSavePrivacy =>
      'Impossible d\'enregistrer la confidentialité';

  @override
  String get couldNotStopChat => 'Impossible d\'arrêter le chat';

  @override
  String get couldNotSubmitAppeal => 'Impossible d\'envoyer l\'appel';

  @override
  String get couldNotVerify => 'Vérification impossible';

  @override
  String get couldNotVerifyAccount =>
      'Impossible de vérifier l\'état du compte. Réessayez.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createPrivateRoom => 'Créer un salon privé';

  @override
  String get customize => 'Personnaliser';

  @override
  String get daily => 'Quotidien';

  @override
  String get dailyChest => 'Coffre quotidien';

  @override
  String get dailyLimit => 'LIMITE QUOTIDIENNE ATTEINTE';

  @override
  String get date => 'Date';

  @override
  String dayN(String n) {
    return 'Jour $n';
  }

  @override
  String dayStreak(String n) {
    return 'Série de $n jours';
  }

  @override
  String get days30 => '30 jours';

  @override
  String get days7 => '7 jours';

  @override
  String get debitFailed => 'Impossible de débiter les pièces';

  @override
  String get declineCaps => 'REFUSER';

  @override
  String get defeat => 'DÉFAITE';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountBody =>
      'Vos pièces, votre score et votre historique seront supprimés définitivement.';

  @override
  String get deleteAccountQuestion => 'Supprimer le compte ?';

  @override
  String get descriptionMin10 =>
      'La description doit contenir au moins 10 caractères';

  @override
  String get diagonal => 'Diagonale';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get doll => 'Poupée';

  @override
  String get done => 'Terminé';

  @override
  String get downloadAndInstall => 'Télécharger et installer';

  @override
  String get downloading => 'Téléchargement…';

  @override
  String downloadingPercent(String percent) {
    return 'Téléchargement $percent %';
  }

  @override
  String get draw => 'Égalité';

  @override
  String get drawBadge => 'ÉGALITÉ';

  @override
  String get draws => 'Nuls';

  @override
  String get duration => 'Période';

  @override
  String get earned => 'Gagné';

  @override
  String get earnedThisWeek => 'Gagné cette semaine, par source';

  @override
  String get editProfileCaps => 'MODIFIER LE PROFIL';

  @override
  String get eliminatedCaps => 'ÉLIMINÉ';

  @override
  String get email => 'E-mail';

  @override
  String get emailNotConfirmed => 'E-mail non confirmé';

  @override
  String emailNotConfirmedBody(String email) {
    return 'Votre inscription a réussi, mais votre e-mail n\'est pas encore confirmé.\n\nOuvrez le lien de confirmation dans votre boîte de réception ou vos spams, puis reconnectez-vous.\n\n$email';
  }

  @override
  String get emailSentAgain => 'E-mail renvoyé — vérifiez votre boîte';

  @override
  String get endsIn => 'Se termine dans';

  @override
  String get enterCode => 'Saisir le code';

  @override
  String get enterCodeFromEmail => 'Saisissez le code reçu par e-mail';

  @override
  String get enterCodeInstead => 'Saisir le code à la place';

  @override
  String get enterEmailPassword => 'Saisissez e-mail et mot de passe';

  @override
  String get enterFullCode => 'Saisissez le code complet';

  @override
  String get enterReferralOrSkip =>
      'Saisissez un code de parrainage ou passez pour l\'instant';

  @override
  String get enterResetCode => 'Saisissez le code de réinitialisation';

  @override
  String get enterValidMobile => 'Saisissez un numéro de mobile valide';

  @override
  String get enterValidReferral => 'Saisissez un code de parrainage valide';

  @override
  String get enterYourEmail => 'Saisissez votre e-mail';

  @override
  String get entry => 'Entrée';

  @override
  String get entryFee => 'Frais d\'entrée';

  @override
  String get equip => 'Équiper';

  @override
  String get equipped => 'Équipé';

  @override
  String get events => 'Événements';

  @override
  String get everyone => 'Tout le monde';

  @override
  String get expertMode => 'Mode expert (5×5)';

  @override
  String get expiredMoveToHistory =>
      'Les défis expirés passent dans l\'Historique.';

  @override
  String get failed => 'Échec';

  @override
  String get fillAllFields => 'Remplissez tous les champs';

  @override
  String get finalRound => 'Finale';

  @override
  String get findAMatch => 'Trouver un match';

  @override
  String get findOpponent => 'Trouver un adversaire';

  @override
  String get findPrivateJoin => 'Trouver · salon privé · code';

  @override
  String get findingOpponent => 'Recherche d\'un adversaire';

  @override
  String get findingPlayer => 'Recherche d\'un joueur';

  @override
  String get firstMatchSet =>
      'Votre premier match sera fixé à l\'ouverture de la manche.';

  @override
  String get fiveOfFiveWatched => '5 vidéos sur 5 regardées';

  @override
  String get flash => 'Flash';

  @override
  String get flashUnavailable => 'Flash indisponible';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get free => 'Gratuit';

  @override
  String get freeCoins => 'PIÈCES GRATUITES';

  @override
  String get freeMatch => 'Match gratuit';

  @override
  String get freeMatchesPerDay => '3 matchs gratuits par jour';

  @override
  String get freeVideosToday => 'Vidéos gratuites aujourd\'hui';

  @override
  String freeVideosUsed(String used) {
    return '$used vidéos gratuites sur 5 utilisées aujourd\'hui';
  }

  @override
  String get friendChallenge => 'Défi entre amis';

  @override
  String get friendRequestExists => 'Une demande d\'ami existe déjà';

  @override
  String friendRequestSent(String name) {
    return 'Demande d\'ami envoyée à $name';
  }

  @override
  String get friendRequestSentShort => 'Demande d\'ami envoyée';

  @override
  String get friendsCaps => 'AMIS';

  @override
  String get friendsLabel => 'Amis';

  @override
  String get friendsOnly => 'Amis uniquement';

  @override
  String get fromPhoto => 'Depuis une photo';

  @override
  String gameComingSoon(String game) {
    return '$game : bientôt disponible';
  }

  @override
  String get gameOver => 'Partie terminée';

  @override
  String get gamePaused => 'Jeu en pause';

  @override
  String get getStarted => 'Commencer';

  @override
  String get gettingVideo => 'Chargement de votre vidéo…';

  @override
  String get goToMatchCaps => 'ALLER AU MATCH';

  @override
  String get gotIt => 'Compris';

  @override
  String get graceWindowEnded =>
      'Le délai de 30 secondes est écoulé. Vous pouvez réclamer la victoire.';

  @override
  String greatRun(String name) {
    return 'Beau parcours dans $name';
  }

  @override
  String get guard => 'Garde';

  @override
  String get guest => 'Invité';

  @override
  String get history => 'Historique';

  @override
  String get historyNeverPublic =>
      'Votre historique et votre activité n\'apparaissent jamais sur votre profil public.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches matchs · $wins victoires · $losses défaites · $draws nuls';
  }

  @override
  String get howItWorks => 'Comment ça marche';

  @override
  String get howToPlay => 'Comment jouer';

  @override
  String get howToPlayRules =>
      'Alignez trois de vos symboles, à l\'horizontale, à la verticale ou en diagonale, avant votre adversaire. Sur les grands plateaux, il en faut quatre.';

  @override
  String howToPlayStep(String n) {
    return 'COMMENT JOUER · $n/3';
  }

  @override
  String get imReadyCaps => 'JE SUIS PRÊT';

  @override
  String get imageTooBig => 'L\'image doit faire moins de 2 Mo';

  @override
  String get install => 'Installer';

  @override
  String get installUpdate => 'Installer la mise à jour';

  @override
  String get installed => 'Installée';

  @override
  String get internetRequired =>
      'Connexion Internet requise. Vous pouvez toujours jouer contre The Doll hors ligne.';

  @override
  String get introBody1 => 'Battez l\'IA sur des plateaux 3×3, 4×4 ou 5×5.';

  @override
  String get introBody2 =>
      'Matchs aléatoires contre de vrais joueurs. Misez des pièces, gagnez des pièces.';

  @override
  String get introBody3 =>
      'Récompenses quotidiennes, missions et tournois pour progresser.';

  @override
  String get introTitle1 => 'Déjouez la Poupée';

  @override
  String get introTitle2 => 'Défiez le monde';

  @override
  String get introTitle3 => 'Grimpez au classement';

  @override
  String get invalidRoomQr => 'QR de salon invalide';

  @override
  String get inviteImage => 'Image d\'invitation';

  @override
  String get inviteImageBody =>
      'Code, QR et lien en une image. Envoyez-la sur WhatsApp ou ailleurs.';

  @override
  String isThinking(String name) {
    return '$name réfléchit';
  }

  @override
  String get joinCaps => 'REJOINDRE';

  @override
  String joinForCoins(String n) {
    return 'REJOINDRE POUR $n PIÈCES';
  }

  @override
  String get joinRoomCaps => 'REJOINDRE LE SALON';

  @override
  String get joinTheGame => 'Rejoignez la partie';

  @override
  String joinTournamentQuestion(String name) {
    return 'Rejoindre $name ?';
  }

  @override
  String get joinWithCode => 'Rejoindre avec un code';

  @override
  String get joined => 'Inscrit';

  @override
  String get joiningCaps => 'CONNEXION…';

  @override
  String get joiningQueue => 'Entrée dans la file…';

  @override
  String get joiningRoom => 'Connexion au salon…';

  @override
  String get keepWatchingCaps => 'CONTINUER';

  @override
  String get language => 'Langue';

  @override
  String get languageUpdated => 'Langue mise à jour';

  @override
  String get last20Sent =>
      'Les 20 derniers messages sont envoyés avec votre signalement.';

  @override
  String get last7Games => '7 dernières parties';

  @override
  String lastUpdated(String date) {
    return 'Dernière mise à jour : $date';
  }

  @override
  String get later => 'Plus tard';

  @override
  String get latestVersion => 'Vous utilisez la dernière version.';

  @override
  String get leaderboard => 'Classement';

  @override
  String get leaderboardUpdated => 'Classement mis à jour';

  @override
  String get leave => 'Quitter';

  @override
  String get leaveForfeitBody =>
      'Quitter maintenant compte comme un forfait. Votre adversaire gagne.';

  @override
  String get leaveGame => 'Quitter la partie';

  @override
  String get leaveMatchQuestion => 'Quitter le match ?';

  @override
  String get leaveVideoQuestion => 'Quitter la vidéo ?';

  @override
  String get letsPlay => 'C\'est parti';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get live => 'En direct';

  @override
  String get liveEventCaps => 'ÉVÉNEMENT EN DIRECT';

  @override
  String get loading => 'Chargement…';

  @override
  String get local => 'Local';

  @override
  String get locked => 'Verrouillé';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get loginMethod => 'Méthode de connexion';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'Si vous fermez maintenant, vous n\'aurez pas vos 10 pièces. Encore $seconds secondes.';
  }

  @override
  String get losses => 'Défaites';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get marks => 'Symboles';

  @override
  String get match => 'Match';

  @override
  String get matchAbandonedCaps => 'MATCH ABANDONNÉ';

  @override
  String matchDuration(String duration) {
    return 'Durée du match $duration';
  }

  @override
  String get matchHistory => 'Historique des matchs';

  @override
  String get matchHistoryCaps => 'HISTORIQUE DES MATCHS';

  @override
  String get matchInvitations => 'Invitations à jouer';

  @override
  String get matchLobby => 'Salle d\'attente';

  @override
  String get matchResult => 'Résultat du match';

  @override
  String get matchResults => 'Résultats des matchs';

  @override
  String get matchStakes => 'Mises du match';

  @override
  String get matchStartsIn => 'Le match commence dans';

  @override
  String get matches => 'Matchs';

  @override
  String get matchmakingError => 'Erreur de matchmaking';

  @override
  String get matchmakingFailed => 'Échec du matchmaking';

  @override
  String get matchmakingStopped => 'Matchmaking arrêté';

  @override
  String memberSince(String date) {
    return 'Membre depuis $date';
  }

  @override
  String get messageEmpty => 'Le message ne peut pas être vide';

  @override
  String get messagesStayForMatch => 'Les messages restent le temps du match';

  @override
  String minusCoins(String n) {
    return '-$n pièces';
  }

  @override
  String get misPlay30 => 'Jouez 30 matchs';

  @override
  String get misPlay5 => 'Jouez 5 matchs';

  @override
  String get misQuick => 'Jouez un match aléatoire';

  @override
  String get misTourney => 'Rejoignez un tournoi';

  @override
  String get misWin15 => 'Gagnez 15 parties';

  @override
  String get misWin3 => 'Gagnez 3 parties';

  @override
  String get misWin4x4 => 'Gagnez sur un plateau 4×4';

  @override
  String get missResets =>
      'Un jour manqué et tout repart à zéro. Revenez demain pour la prochaine récompense.';

  @override
  String get missingChallengeData => 'Données du défi manquantes';

  @override
  String get missingEmail => 'E-mail manquant — revenez et réessayez';

  @override
  String get missions => 'Missions';

  @override
  String missionsDone(String done, String total) {
    return '$done missions sur $total terminées';
  }

  @override
  String get mobileNotSupported =>
      'Les numéros de mobile ne sont pas encore pris en charge dans votre région';

  @override
  String get mobileOptional => 'Numéro de mobile (facultatif)';

  @override
  String mode(String n) {
    return 'Mode $n';
  }

  @override
  String get more => 'Plus';

  @override
  String get moreGames => 'Plus de jeux';

  @override
  String get music => 'Musique';

  @override
  String nOf5(String n) {
    return '$n sur 5';
  }

  @override
  String get navPlay => 'Jouer';

  @override
  String get newCodeSent => 'Nouveau code envoyé — vérifiez votre boîte';

  @override
  String get newHere => 'Nouveau ?';

  @override
  String get newMatchChallengeCaps => 'NOUVEAU DÉFI !';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get newPasswordBody =>
      'Saisissez un nouveau mot de passe. Vous resterez connecté après l\'enregistrement.';

  @override
  String get newVersion => 'Nouvelle version';

  @override
  String get newVersionReady => 'Une nouvelle version de DROTIX est prête.';

  @override
  String get newVideosUnlockIn => 'Nouvelles vidéos gratuites dans';

  @override
  String get next => 'Suivant';

  @override
  String get nextCaps => 'SUIVANT';

  @override
  String get nextRound => 'Manche suivante';

  @override
  String get no => 'Non';

  @override
  String get noChallenge => 'Aucun défi';

  @override
  String get noChallengesHere => 'Aucun défi ici.';

  @override
  String get noCloudMatches =>
      'Aucun match cloud pour l\'instant. Jouez contre The Doll connecté pour apparaître ici.';

  @override
  String get noFriendsYet => 'Pas encore d\'amis — cherchez pour en ajouter.';

  @override
  String get noHistory => 'Aucun historique';

  @override
  String get noMatchesYet => 'Aucun match pour l\'instant';

  @override
  String get noMessagesYet =>
      'Pas encore de messages.\nLes réponses rapides marchent aussi.';

  @override
  String get noNotificationsYet => 'Aucune notification pour l\'instant';

  @override
  String get noOpponentFound => 'Aucun adversaire trouvé — réessayez';

  @override
  String get noPendingRequests => 'Aucune demande en attente.';

  @override
  String get noPlayersFound => 'Aucun joueur trouvé';

  @override
  String get noQrInPhoto => 'Aucun QR trouvé sur la photo';

  @override
  String get noRankedPlayers =>
      'Aucun joueur classé pour l\'instant. Connectez-vous et jouez pour entrer au classement.';

  @override
  String get noTransactions => 'Aucune transaction pour l\'instant.';

  @override
  String get noVideoFound =>
      'Aucune vidéo trouvée. Votre vidéo gratuite n\'a pas été utilisée. Réessayez dans une minute.';

  @override
  String get noVideoNow =>
      'Aucune vidéo disponible pour le moment. Réessayez plus tard.';

  @override
  String get noVideoRightNow => 'Pas de vidéo pour le moment';

  @override
  String get nobody => 'Personne';

  @override
  String get nobodyBlinked => 'Personne n\'a cédé.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Personne n\'a cédé. $name vous a tenu tête.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name n\'accepte pas de défis pour le moment.';
  }

  @override
  String get notEnoughCoins => 'Pas assez de pièces';

  @override
  String get notEnoughCoinsAnother =>
      'Pas assez de pièces pour une nouvelle mise.';

  @override
  String get notEnoughCoinsStake => 'Pas assez de pièces pour cette mise.';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get notSignedIn => 'Non connecté';

  @override
  String get notSignedInYet =>
      'Pas encore connecté — ouvrez d\'abord le lien de l\'e-mail';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name a accepté votre défi. Le match commence !';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Défi accepté';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name est en match. Réessayez plus tard.';
  }

  @override
  String get notifChallengeBusyTitle => 'Joueur occupé';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name a annulé le défi';
  }

  @override
  String get notifChallengeCancelledTitle => 'Défi annulé';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name a refusé votre défi';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Défi refusé';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name n\'a pas répondu à temps';
  }

  @override
  String get notifChallengeExpiredTitle => 'Défi expiré';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name vous a défié en match';
  }

  @override
  String get notifChallengeRequestTitle => 'Nouveau défi';

  @override
  String get notifChannelDesc => 'Défis, matchs et pièces';

  @override
  String get notifChannelName => 'Alertes du jeu';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return '$amount pièces ajoutées. Solde : $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Pièces ajoutées';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return '$amount pièces débitées. Solde : $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Pièces débitées';

  @override
  String get notifCoinsPurchaseTitle => 'Achat effectué';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'Vous avez gagné $amount pièces. Solde : $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Récompense reçue';

  @override
  String get notifEmptyHint =>
      'Les défis, résultats de matchs et mouvements de pièces apparaîtront ici.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name a accepté votre demande d\'ami';
  }

  @override
  String get notifFriendAcceptedTitle => 'Nouvel ami';

  @override
  String notifFriendRequestBody(String name) {
    return '$name veut devenir votre ami';
  }

  @override
  String get notifFriendRequestTitle => 'Demande d\'ami';

  @override
  String get notifGeneric => 'Nouvelle notification';

  @override
  String notifMatchBody(String name) {
    return 'Votre match contre $name est terminé';
  }

  @override
  String get notifMatchDrawTitle => 'Match nul';

  @override
  String get notifMatchLostTitle => 'Vous avez perdu';

  @override
  String get notifMatchWonTitle => 'Vous avez gagné !';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name a rejoint votre salon privé';
  }

  @override
  String get notifRoomJoinedTitle => 'Un joueur a rejoint';

  @override
  String get notifications => 'Notifications';

  @override
  String nowFriends(String name) {
    return '$name et vous êtes maintenant amis';
  }

  @override
  String get nowFriendsShort => 'Vous êtes maintenant amis';

  @override
  String get officialWebsite => 'Site officiel';

  @override
  String get offlineAi => 'IA hors ligne';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'Pas d\'Internet · Adversaires IA uniquement · $size · Mise $stake';
  }

  @override
  String get offlineBanner =>
      'Hors ligne · Jouer contre The Doll fonctionne toujours';

  @override
  String get offlineBody =>
      'Les matchs en ligne et les tournois nécessitent une connexion. Vous pouvez toujours jouer contre The Doll.';

  @override
  String get offlineProfilesNote =>
      'Ce sont des profils IA hors ligne, pas de vrais joueurs.';

  @override
  String get offlineSmart => 'Hors ligne, adversaire malin';

  @override
  String get ok => 'OK';

  @override
  String get oneLastStepCaps => 'UNE DERNIÈRE ÉTAPE';

  @override
  String get online => 'En ligne';

  @override
  String get onlineMatch => 'Match en ligne';

  @override
  String get onlineMultiplayer => 'Multijoueur en ligne';

  @override
  String get onlineOfflineAi => 'Joueurs en ligne · IA hors ligne';

  @override
  String onlineStake(String stake) {
    return 'En ligne · Mise $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name n\'accepte que les défis de ses amis. Ajoutez-le d\'abord.';
  }

  @override
  String get open => 'Ouvrir';

  @override
  String get openedTheLink => 'J\'ai ouvert le lien';

  @override
  String get openingInstaller => 'Ouverture du programme d\'installation…';

  @override
  String get opponent => 'Adversaire';

  @override
  String get opponentAdvances =>
      'Si vous ne rejoignez pas à temps, votre adversaire passe.';

  @override
  String get opponentDisconnected => 'L\'adversaire s\'est déconnecté';

  @override
  String get opponentWins => 'L\'adversaire gagne';

  @override
  String opponentsMove(String name) {
    return 'Au tour de $name';
  }

  @override
  String get or => 'Ou';

  @override
  String get orEnterCodeCaps => 'OU SAISISSEZ LE CODE';

  @override
  String get otherEvents => 'Autres événements';

  @override
  String get owned => 'Possédé';

  @override
  String get passAndPlay => 'Passe et joue';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordMin6 =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour';

  @override
  String get passwordsNoMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get pasteCode => 'Coller le code';

  @override
  String get pause => 'Pause';

  @override
  String get paused => 'En pause';

  @override
  String get perMove20s => '20 s par coup';

  @override
  String get photoUpdated => 'Photo mise à jour';

  @override
  String get pickClosestReason =>
      'Que se passe-t-il ? Choisissez le motif le plus proche.';

  @override
  String get pickYourGame => 'Choisissez votre jeu';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get playAsGuest => 'Jouer en invité';

  @override
  String get playCaps => 'JOUER';

  @override
  String get playDollOffline => 'Jouer contre The Doll hors ligne';

  @override
  String get playToBuildForm => 'Jouez un match pour voir votre forme.';

  @override
  String get playVsDoll => 'Jouer contre The Doll';

  @override
  String playVsName(String name) {
    return 'Jouer contre $name';
  }

  @override
  String get played => 'Jouées';

  @override
  String get player => 'Joueur';

  @override
  String get player1 => 'Joueur 1';

  @override
  String get player1Move => 'Au tour du joueur 1';

  @override
  String get player1Wins => 'Le joueur 1 gagne !';

  @override
  String get player2 => 'Joueur 2';

  @override
  String get player2Move => 'Au tour du joueur 2';

  @override
  String get player2Wins => 'Le joueur 2 gagne !';

  @override
  String playerAdded(String name) {
    return '$name ajouté';
  }

  @override
  String get playerBlocked => 'Joueur bloqué';

  @override
  String playerIdLabel(String id) {
    return 'JOUEUR $id';
  }

  @override
  String get playerUnblocked => 'Joueur débloqué';

  @override
  String get players => 'Joueurs';

  @override
  String get playersLeft => 'Joueurs restants';

  @override
  String get pleaseWait => 'Patientez…';

  @override
  String plusCoins(String n) {
    return '+$n pièces';
  }

  @override
  String get podium => 'Podium';

  @override
  String get pointAtHostQr =>
      'Pointez vers le QR de l\'hôte. Même code que dans le salon.';

  @override
  String get pointCameraAtQr => 'Pointez la caméra vers le QR du salon';

  @override
  String pointsWins(String points, String wins) {
    return '$points pts · $wins victoires';
  }

  @override
  String get popular => 'Populaire';

  @override
  String get previousMatchExpired =>
      'Le match précédent a expiré. Réessayez dans un instant.';

  @override
  String get privacy => 'Confidentialité';

  @override
  String privacyBody(String email) {
    return 'Nous collectons uniquement les données de jeu nécessaires au fonctionnement de l\'appli (pièces, cosmétiques, historique et paramètres). Jouer en invité ne nécessite pas de compte.\n\nSi vous vous connectez, vos informations servent uniquement à sauvegarder et restaurer votre progression. Nous ne vendons pas de données personnelles. Vous pouvez supprimer vos données à tout moment via Paramètres → Supprimer le compte.\n\nContact : $email';
  }

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privateOnlyYou => 'Privé. Vous seul pouvez le voir.';

  @override
  String get privateRoomByUsername => 'Salon privé (par pseudo)';

  @override
  String get privateRoomCaps => 'SALON PRIVÉ';

  @override
  String get prizeAdded => 'Prix ajouté à votre solde';

  @override
  String get prizePool => 'Cagnotte';

  @override
  String get profile => 'Profil';

  @override
  String get profileNotFound => 'Profil introuvable';

  @override
  String get profilePrivacyNote =>
      'L\'historique et l\'activité restent privés. Le signalement concerne les abus de profil ; pour le chat en match, utilisez le bouton Signaler du chat.';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String progressOf(String done, String total) {
    return '$done sur $total';
  }

  @override
  String get publicStatsNote =>
      'Seuls le rang, le score et les victoires sont publics. L\'historique et l\'activité restent privés.';

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String get purchases => 'Achats';

  @override
  String get purchasesComingSoon =>
      'L\'achat de pièces arrive bientôt. Regardez une vidéo dans Pièces gratuites pour en gagner maintenant.';

  @override
  String get quarter => 'Quarts';

  @override
  String get quarterFinal => 'Quart de finale';

  @override
  String get quickCloseOne => 'C\'était serré !';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => 'Bien joué !';

  @override
  String quickMatchVsAi(String time) {
    return 'Match rapide contre l\'IA · $time';
  }

  @override
  String get quitMatch => 'Quitter le match';

  @override
  String get randomMatch => 'Match aléatoire';

  @override
  String get rank => 'Rang';

  @override
  String rankScore(String rank, String score) {
    return 'Rang #$rank · Score $score';
  }

  @override
  String get rankScoreUnknown => 'Rang – · Score –';

  @override
  String get ranks => 'Classement';

  @override
  String get rateApp => 'Noter l\'appli';

  @override
  String get ratingsSoon => 'Les notes arrivent bientôt';

  @override
  String get readOnly => 'lecture seule';

  @override
  String get readyCaps => 'PRÊT';

  @override
  String get reasonHarassment => 'Harcèlement ou intimidation';

  @override
  String get reasonInappropriate => 'Contenu sexuel ou inapproprié';

  @override
  String get reasonOffensive => 'Propos haineux ou insultes';

  @override
  String get reasonOther => 'Autre chose';

  @override
  String get reasonSpam => 'Spam ou arnaques';

  @override
  String get reasonThreatening => 'Menaces ou violence';

  @override
  String get received => 'Reçus';

  @override
  String get reconnecting => 'Reconnexion…';

  @override
  String reference(String id) {
    return 'Référence : $id';
  }

  @override
  String get referralCode => 'Code de parrainage';

  @override
  String get referralHint => 'Code de parrainage (facultatif)';

  @override
  String get referralOnce =>
      'Un code de parrainage n\'est utilisable qu\'une fois, juste après l\'inscription.';

  @override
  String get referralPrompt =>
      'Un ami vous a donné un code ? Saisissez-le et gagnez 50 pièces.';

  @override
  String get referralWorked =>
      'Votre code a fonctionné. Les pièces sont dans votre portefeuille.';

  @override
  String get refresh => 'Actualiser';

  @override
  String get refreshStatus => 'Actualiser l\'état';

  @override
  String get region => 'Région';

  @override
  String get regionIndiaNote =>
      'Détecté automatiquement depuis votre SIM ou appareil. En Inde : langues indiennes et prix en ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Détecté automatiquement depuis votre SIM ou appareil. Langues internationales, prix en $currency.';
  }

  @override
  String get register => 'S\'inscrire';

  @override
  String get released => 'Publiée';

  @override
  String get rematch => 'Revanche';

  @override
  String get rematchQuestion => 'Revanche ?';

  @override
  String get remindMe => 'Me prévenir avant mon match';

  @override
  String get reportButtonCaps => 'BOUTON SIGNALER';

  @override
  String get reportButtonHelp =>
      'En haut à droite du chat en direct, à côté d\'Arrêter le chat. Toujours visible quand le chat est actif.\nTouchez → choisissez un motif → ajoutez détails et captures → envoyez.';

  @override
  String get reportCaps => 'SIGNALER';

  @override
  String get reportFailed => 'Échec du signalement';

  @override
  String reportName(String name) {
    return 'Signaler $name';
  }

  @override
  String get reportOrBlock => 'Signaler ou bloquer';

  @override
  String get reportOrBlockPlayer => 'Signaler ou bloquer ce joueur';

  @override
  String get reportPlayer => 'Signaler le joueur';

  @override
  String get requestSentCaps => 'DEMANDE ENVOYÉE';

  @override
  String requestSentTo(String name) {
    return 'Demande envoyée à $name';
  }

  @override
  String get requests => 'Demandes';

  @override
  String requestsCount(String n) {
    return 'Demandes · $n';
  }

  @override
  String get requestsExpire7d =>
      'Les demandes expirent après 7 jours sans réponse.';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get resendEmail => 'Renvoyer l\'e-mail';

  @override
  String get resetCode => 'Code de réinitialisation';

  @override
  String resetCodeSentTo(String target) {
    return 'Nous avons envoyé un code à $target.\nSaisissez-le ci-dessous — inutile d\'ouvrir le lien de l\'e-mail.';
  }

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordBody =>
      'Saisissez votre e-mail et nous enverrons un code. Tapez-le dans l\'appli — inutile d\'ouvrir le lien.';

  @override
  String get restart => 'Recommencer';

  @override
  String get result => 'Résultat';

  @override
  String get resume => 'Reprendre';

  @override
  String get returnToMainMenu => 'Retour au menu principal';

  @override
  String get rewardEarnedCaps => 'RÉCOMPENSE OBTENUE';

  @override
  String get rewardFlowOverview => 'Aperçu des récompenses';

  @override
  String rewardIn(String time) {
    return 'Récompense dans $time';
  }

  @override
  String get rivalO => 'Adversaire : O';

  @override
  String get roomCancelled => 'Salon annulé';

  @override
  String roomClosesIn(String time) {
    return 'Le salon ferme dans $time si personne ne rejoint.';
  }

  @override
  String get roomClosesSoon =>
      'Le salon fermera bientôt si personne ne rejoint.';

  @override
  String get roomClosing => 'Fermeture du salon…';

  @override
  String get roomCodeCaps => 'CODE DU SALON';

  @override
  String get roomCodeCopied => 'Code du salon copié';

  @override
  String get roomExpired => 'Salon expiré';

  @override
  String get roomOpenCaps => 'SALON OUVERT';

  @override
  String get roundOf16 => 'Huitièmes';

  @override
  String get roundOf16Caps => 'HUITIÈMES';

  @override
  String roundOf16Vs(String name) {
    return 'Huitièmes · contre $name';
  }

  @override
  String get roundsWon => 'Manches gagnées';

  @override
  String get row => 'Ligne';

  @override
  String get ruleEmoji =>
      '• Les réactions emoji fonctionnent sans demande et peuvent être coupées.';

  @override
  String get ruleEnds =>
      '• Le chat se termine automatiquement à la fin du match.';

  @override
  String get ruleStop => '• Chaque joueur peut arrêter le chat à tout moment.';

  @override
  String get ruleVanish =>
      '• Les messages disparaissent en quelques secondes et ne sont jamais enregistrés.';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get savePassword => 'Enregistrer le mot de passe';

  @override
  String get saving => 'Enregistrement…';

  @override
  String get savingToCloud => 'Enregistrement dans le cloud…';

  @override
  String get scanOrShare => 'Scannez pour rejoindre ou partagez le lien';

  @override
  String get scanQr => 'Scanner le QR';

  @override
  String get score => 'Score';

  @override
  String get scorePlus10 => 'Score +10';

  @override
  String get screenshotTooBig => 'La capture doit faire moins de 2 Mo';

  @override
  String get screenshotsOptionalCaps => 'CAPTURES (FACULTATIF)';

  @override
  String get searchPlayersHint => 'Rechercher par pseudo ou ID joueur';

  @override
  String get searchResults => 'Résultats';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'En ligne · $size · mise $stake · $time';
  }

  @override
  String get seatWaiting => 'Joueur, votre place vous attend.';

  @override
  String secondsLeft(String seconds) {
    return 'Plus que $seconds s';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'Plus que $seconds s pour répondre';
  }

  @override
  String get selectDifficulty => 'Choisissez la difficulté';

  @override
  String get selectOpponent => 'Sélectionnez un adversaire';

  @override
  String get selectReportReason => 'Choisissez un motif';

  @override
  String get semi => 'Demies';

  @override
  String get send => 'Envoyer';

  @override
  String get sendChallenge => 'Envoyer le défi';

  @override
  String get sendResetCode => 'Envoyer le code';

  @override
  String get sending => 'Envoi…';

  @override
  String get sendingMove => 'Envoi du coup…';

  @override
  String get sent => 'Envoyée';

  @override
  String serverTournamentsDemo(String error) {
    return 'Tournois serveur indisponibles — démo affichée.\n$error';
  }

  @override
  String get sessionExpiredReset =>
      'Session expirée — demandez un nouveau code';

  @override
  String get settings => 'Paramètres';

  @override
  String get shareComingSoon => 'Partage bientôt disponible';

  @override
  String get shareInviteCaps => 'PARTAGER L\'INVITATION';

  @override
  String get shareOnWhatsApp => 'Partager sur WhatsApp';

  @override
  String get shareProfile => 'Partager le profil';

  @override
  String shareWin(String url) {
    return 'Je viens de gagner une partie de DROTIX ! Tu crois pouvoir me battre ? Joue maintenant : $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return 'Je viens de battre $name sur DROTIX ! Tu crois pouvoir me battre ? Joue maintenant : $url';
  }

  @override
  String get shop => 'Boutique';

  @override
  String get showHidePassword => 'Afficher ou masquer le mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInChangePhoto => 'Connectez-vous pour changer la photo';

  @override
  String get signInFindFriends => 'Connectez-vous pour trouver des amis';

  @override
  String get signInMatchmaking =>
      'Connexion requise pour le matchmaking en ligne';

  @override
  String get signInNotifications =>
      'Connectez-vous pour voir vos notifications';

  @override
  String get signInOnline => 'Connectez-vous pour jouer en ligne';

  @override
  String get signInRandomMatch =>
      'Connectez-vous pour jouer des matchs aléatoires contre de vrais joueurs';

  @override
  String get signInRequired => 'Connexion requise';

  @override
  String get signInSearchPlayers =>
      'Connectez-vous pour chercher des joueurs et synchroniser vos amis.';

  @override
  String get signInToAddFriends => 'Connectez-vous pour ajouter des amis';

  @override
  String get signInToChallenge => 'Connectez-vous pour défier ce joueur';

  @override
  String get signInWalletHistory =>
      'Connectez-vous pour voir l\'historique du portefeuille.';

  @override
  String get signInWithEmail => 'Se connecter par e-mail';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get skip => 'Passer';

  @override
  String get skipForNow => 'Passer pour l\'instant';

  @override
  String get somethingWentWrong => 'Un problème est survenu';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Un problème est survenu : $error';
  }

  @override
  String get soundDisabled => 'Son désactivé';

  @override
  String get soundEffects => 'Effets sonores';

  @override
  String get soundEnabled => 'Son activé';

  @override
  String get spent => 'Dépensé';

  @override
  String get sponsored => 'Sponsorisé';

  @override
  String stakeDot(String n) {
    return 'Mise · $n';
  }

  @override
  String get stakeReturned => 'Mise remboursée';

  @override
  String stakeRoom(String stake, String room) {
    return 'Mise $stake · $room…';
  }

  @override
  String get start => 'Commencer';

  @override
  String get startPlayingCaps => 'COMMENCER À JOUER';

  @override
  String get starterPack => 'Pack de départ';

  @override
  String get starting => 'Démarrage…';

  @override
  String get startsInCaps => 'COMMENCE DANS';

  @override
  String get stats => 'Statistiques';

  @override
  String statusLabel(String status) {
    return 'Statut : $status';
  }

  @override
  String get stayInApp =>
      'Restez dans l\'appli. Nous vous préviendrons quand votre match sera prêt.';

  @override
  String get stillOffline =>
      'Toujours hors ligne. Vérifiez votre connexion et réessayez.';

  @override
  String get stopChat => 'Arrêter le chat';

  @override
  String get submitAppeal => 'Faire appel';

  @override
  String get submitReportCaps => 'ENVOYER LE SIGNALEMENT';

  @override
  String submittedAt(String date) {
    return 'Envoyé : $date';
  }

  @override
  String get submitting => 'Envoi…';

  @override
  String get submittingCaps => 'ENVOI…';

  @override
  String get supportEmail => 'E-mail d\'assistance';

  @override
  String suspendedAt(String date) {
    return 'Suspendu : $date';
  }

  @override
  String get suspendedByModerator =>
      'Un modérateur a suspendu ce compte après examen d\'un signalement.';

  @override
  String get suspendedRules =>
      'Pendant la suspension, impossible de jouer, rejoindre un salon ou chatter. Vous pouvez soumettre un appel.';

  @override
  String get t20Seconds => '20 secondes par coup';

  @override
  String get tDrawReplays => 'Un nul fait rejouer la manche';

  @override
  String get tSingleElim =>
      'Élimination directe : une défaite et vous êtes éliminé';

  @override
  String get tSingleElimFee =>
      'Élimination directe. Une manche perdue et vous êtes éliminé, sans remboursement des frais.';

  @override
  String get tagline => 'Le petit jeu le plus redoutable';

  @override
  String get takeTurnsBody =>
      'Vous et votre adversaire placez un symbole à chaque tour. Touchez une case vide pour jouer.';

  @override
  String get takeTurnsCaps => 'À TOUR DE RÔLE';

  @override
  String get takesFewSeconds => 'Cela prend généralement quelques secondes.';

  @override
  String get tapEmptySquare => 'Touchez une case vide';

  @override
  String get tbd => 'À définir';

  @override
  String get tellUsMin10 =>
      'Dites-nous ce qui s\'est passé (au moins 10 caractères)';

  @override
  String get termsAccountBody =>
      'Protégez vos identifiants. Vous êtes responsable de l\'activité de votre compte.';

  @override
  String get termsAccountTitle => '2. Votre compte';

  @override
  String get termsChangesBody =>
      'Nous pouvons modifier ces conditions. Continuer à utiliser l\'appli vaut acceptation.';

  @override
  String get termsChangesTitle => '5. Modifications';

  @override
  String get termsCoinsBody =>
      'Les pièces sont des objets virtuels sans valeur monétaire et ne peuvent pas être échangées contre de l\'argent.';

  @override
  String get termsCoinsTitle => '3. Pièces virtuelles';

  @override
  String get termsFairBody =>
      'Pas de triche, d\'insultes ni de harcèlement. Nous pouvons suspendre les comptes qui enfreignent les règles.';

  @override
  String get termsFairTitle => '4. Fair-play et chat';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get termsUsingBody =>
      'Vous devez respecter ces conditions et jouer loyalement.';

  @override
  String get termsUsingTitle => '1. Utilisation de DROTIX';

  @override
  String get theirTurnCaps => 'À EUX';

  @override
  String get threeInRowBody =>
      'Alignez trois symboles en ligne, en colonne ou en diagonale avant votre adversaire.';

  @override
  String get threeInRowCaps => 'TROIS D\'AFFILÉE';

  @override
  String timeDaysAgo(String n) {
    return 'il y a $n j';
  }

  @override
  String timeHoursAgo(String n) {
    return 'il y a $n h';
  }

  @override
  String get timeJustNow => 'À l\'instant';

  @override
  String timeMinutesAgo(String n) {
    return 'il y a $n min';
  }

  @override
  String get timeSkipped => 'Si le temps est écoulé, le coup est passé.';

  @override
  String timesUp(String who) {
    return 'Temps écoulé · $who';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get todayCaps => 'AUJOURD\'HUI';

  @override
  String get top16 => 'Top 16';

  @override
  String get totalCoinsCaps => 'TOTAL DES PIÈCES';

  @override
  String get tournament => 'Tournoi';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get tryAgainCaps => 'RÉESSAYER';

  @override
  String get twoPlayers => 'Deux joueurs, un téléphone';

  @override
  String get txChallengeEntry => 'Entrée de défi';

  @override
  String get txCoinPurchase => 'Achat de pièces';

  @override
  String txDailyBonus(String time) {
    return 'Bonus quotidien · $time';
  }

  @override
  String get txDailyReward => 'Récompense quotidienne';

  @override
  String get txFreeVideo => 'Récompense vidéo';

  @override
  String get txMatchWin => 'Victoire';

  @override
  String txPurchasing(String time) {
    return 'Achat de pièces · $time';
  }

  @override
  String txReferral(String time) {
    return 'Code de parrainage · $time';
  }

  @override
  String txTournament(String time) {
    return 'Tournoi · $time';
  }

  @override
  String get txTournamentPrize => 'Prix du tournoi';

  @override
  String txWatchingAds(String time) {
    return 'Publicités vues · $time';
  }

  @override
  String get txWelcomeBonus => 'Bonus de bienvenue';

  @override
  String txWinning(String time) {
    return 'Matchs gagnés · $time';
  }

  @override
  String get typeMessage => 'Écrivez un message';

  @override
  String get unblockPlayer => 'Débloquer le joueur';

  @override
  String get unblockToAdd => 'Débloquez ce joueur pour l\'ajouter';

  @override
  String get unblockToChallenge => 'Débloquez ce joueur pour le défier';

  @override
  String unlockFor(String n) {
    return 'Débloquer · $n pièces';
  }

  @override
  String get unlocked => 'Débloqué';

  @override
  String unlockedCount(String n, String total) {
    return '$n sur $total débloqués';
  }

  @override
  String get unranked => 'Non classé';

  @override
  String get upTo3Images =>
      'Jusqu\'à 3 images. Seule notre équipe peut les voir.';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get updateFailed => 'Échec de la mise à jour';

  @override
  String get updateOnAppStore => 'Mettre à jour sur l\'App Store';

  @override
  String get updateRequired => 'Mise à jour requise';

  @override
  String get updatesOnlyMobile =>
      'Les mises à jour sont disponibles sur Android et iOS.';

  @override
  String get useChatReport =>
      'Utilisez Chat → Signaler pendant un match pour un signalement avec preuves.';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameHint => 'Nom d\'utilisateur (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Vérifier le code';

  @override
  String get verifyFailBody =>
      'Cela peut arriver avec une connexion faible ou si la récompense a déjà été obtenue. Vos pièces sont en sécurité.';

  @override
  String get verifying => 'Vérification…';

  @override
  String get verifyingReward => 'Vérification de votre récompense';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get versionUnsupported =>
      'Cette version n\'est plus prise en charge. Mettez à jour pour continuer.';

  @override
  String get vibration => 'Vibration';

  @override
  String get victory => 'VICTOIRE';

  @override
  String get videoLength =>
      'La vidéo dure 15 à 30 secondes. Regardez-la jusqu\'au bout pour obtenir vos pièces.';

  @override
  String get videos => 'Vidéos';

  @override
  String get viewAppealStatus => 'Voir l\'état de l\'appel';

  @override
  String get viewBracket => 'Voir le tableau';

  @override
  String get viewBracketCaps => 'VOIR LE TABLEAU';

  @override
  String get viewProfile => 'Voir le profil';

  @override
  String vsName(String name) {
    return 'contre $name';
  }

  @override
  String get waitingCaps => 'EN ATTENTE';

  @override
  String waitingForAccept(String name) {
    return 'En attente de l\'acceptation de $name…';
  }

  @override
  String get waitingForFriend => 'En attente d\'un ami...';

  @override
  String get waitingOtherMatches => 'En attente des autres matchs';

  @override
  String get waitingRoundOpen => 'En attente de l\'ouverture de la manche';

  @override
  String get wallet => 'Portefeuille';

  @override
  String get walletBalance => 'Solde du portefeuille';

  @override
  String get walletCaps => 'PORTEFEUILLE';

  @override
  String get walletUnavailable => 'Portefeuille indisponible';

  @override
  String watchAnotherLeft(String n) {
    return 'EN REGARDER UNE AUTRE ($n RESTANTES)';
  }

  @override
  String get watchBracketCaps => 'SUIVRE LE TABLEAU';

  @override
  String get watchFullVideo =>
      'Regardez la vidéo en entier pour obtenir vos pièces bonus.';

  @override
  String get watchNowCaps => 'REGARDER';

  @override
  String get watchShortVideo => 'Regardez une courte vidéo';

  @override
  String watchShortVideoToGet(String n) {
    return 'Regardez une courte vidéo pour obtenir +$n';
  }

  @override
  String get watchVideo => 'VOIR LA VIDÉO';

  @override
  String get watchVideoCoins => 'Regardez une vidéo, gagnez 10 pièces';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get weeklyChest => 'Coffre hebdomadaire';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get welcomeBonusCaps => 'BONUS DE BIENVENUE';

  @override
  String welcomeName(String name) {
    return 'Bienvenue, $name';
  }

  @override
  String get whatHappenedCaps => 'CE QUI S\'EST PASSÉ';

  @override
  String get whatHappenedHint =>
      'Dites-nous ce qui s\'est passé et pourquoi vous signalez ce joueur';

  @override
  String get whatsNewCaps => 'NOUVEAUTÉS';

  @override
  String get whoCanChallenge => 'Qui peut vous défier';

  @override
  String get whoCanMessage => 'Qui peut vous envoyer des messages';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String get winner => 'GAGNANT';

  @override
  String get wins => 'Victoires';

  @override
  String winsThisRound(String name) {
    return '$name remporte cette manche.';
  }

  @override
  String get yesDelete => 'Oui, supprimer';

  @override
  String get yesterday => 'Hier';

  @override
  String get yesterdayCaps => 'HIER';

  @override
  String get you => 'Vous';

  @override
  String youBeat(String name) {
    return 'Vous avez battu $name.';
  }

  @override
  String get youFinished => 'Votre classement';

  @override
  String get youLose => 'Vous avez perdu';

  @override
  String youMark(String mark) {
    return 'Vous · $mark';
  }

  @override
  String get youWin => 'Vous avez gagné !';

  @override
  String get youWinCaps => 'VOUS GAGNEZ';

  @override
  String get youX => 'Vous : X';

  @override
  String yourBalance(String n) {
    return 'Votre solde : $n pièces';
  }

  @override
  String get yourEmail => 'votre e-mail';

  @override
  String get yourMatchReadyCaps => 'VOTRE MATCH EST PRÊT';

  @override
  String get yourMove => 'À vous';

  @override
  String get yourNextMatch => 'Votre prochain match';

  @override
  String get yourTurnCaps => 'À VOUS';

  @override
  String get youreInCaps => 'VOUS Y ÊTES';

  @override
  String get youreInViewBracket => 'VOUS Y ÊTES — VOIR LE TABLEAU';

  @override
  String get youreOffline => 'Vous êtes hors ligne';
}
