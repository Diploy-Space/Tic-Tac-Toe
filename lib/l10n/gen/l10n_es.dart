// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get aboutDescription =>
      'DROTIX es un juego de tres en raya rápido y competitivo. Juega contra la máquina, enfréntate a jugadores reales, desafía a tus amigos y sube en la clasificación.';

  @override
  String get aboutUs => 'Acerca de';

  @override
  String get accept => 'Aceptar';

  @override
  String get acceptCaps => 'ACEPTAR';

  @override
  String get acceptRequestCaps => 'ACEPTAR SOLICITUD';

  @override
  String get accountCheckFailed => 'Error al verificar la cuenta';

  @override
  String get accountIsSuspended => 'Tu cuenta está suspendida.';

  @override
  String get accountRestricted =>
      'Tu cuenta seguirá restringida hasta que un moderador termine la revisión. El juego, el emparejamiento y el chat siguen bloqueados.';

  @override
  String get accountStatusUnknown =>
      'Estado de la cuenta desconocido. Inténtalo de nuevo.';

  @override
  String get accountSuspended => 'Cuenta suspendida';

  @override
  String get accountSuspendedSignIn =>
      'Tu cuenta fue suspendida. Inicia sesión para ver los detalles o apelar.';

  @override
  String get accountSuspendedTitle => 'Tu cuenta ha sido suspendida';

  @override
  String get ach100Wins => '100 victorias';

  @override
  String get ach10Matches => '10 partidas';

  @override
  String get ach50Matches => '50 partidas';

  @override
  String get achChallenger => 'Retador';

  @override
  String get achChampion => 'Campeón';

  @override
  String get achFirstWin => 'Primera victoria';

  @override
  String get achScore100 => '100 puntos';

  @override
  String get achStreak3 => 'Racha de 3';

  @override
  String get achStreak5 => 'Racha de 5';

  @override
  String get achSurvivor => 'Superviviente';

  @override
  String get achTop3 => 'Top 3';

  @override
  String get achievements => 'Logros';

  @override
  String get add => 'Añadir';

  @override
  String get addFriend => 'Añadir amigo';

  @override
  String get addFriendCaps => 'AÑADIR AMIGO';

  @override
  String get advanceQuarter => 'Pasas a cuartos de final';

  @override
  String get advancedMode => 'Modo avanzado (4×4)';

  @override
  String get advertiserApp => 'App del anunciante';

  @override
  String get advertiserVideo => 'Aquí se reproduce el anuncio';

  @override
  String get all => 'Todo';

  @override
  String get allowAndInstall => 'Permitir e instalar';

  @override
  String get allowUnknownApps =>
      'Permite \"Instalar apps desconocidas\" para DROTIX y vuelve. La actualización se instalará sola.';

  @override
  String get alreadyPlayer => '¿Ya juegas?';

  @override
  String get alsoBlock => 'Bloquear también a este jugador';

  @override
  String get alwaysTrue => 'Siempre';

  @override
  String get appUpdate => 'Actualización de la app';

  @override
  String get appealExplain =>
      'Explica por qué deberíamos reactivar tu cuenta. Un moderador revisará tu mensaje.';

  @override
  String get appealFailed => 'Error en la apelación';

  @override
  String get appealHint => 'Escribe tu apelación (mín. 20 caracteres)…';

  @override
  String get appealIsUnderReview => 'Tu apelación está en revisión.';

  @override
  String get appealMin20 => 'La apelación debe tener al menos 20 caracteres';

  @override
  String get appealSubmitted => 'Apelación enviada';

  @override
  String get appealSuspension => 'Apelar suspensión';

  @override
  String get appealUnderReview => 'Apelación en revisión';

  @override
  String get applyCodeCaps => 'APLICAR CÓDIGO';

  @override
  String get attachRecentChat => 'Adjuntar mensajes recientes';

  @override
  String get attemptingReconnect => 'Intentando reconectar…';

  @override
  String get auto => 'Auto';

  @override
  String get avatars => 'Avatares';

  @override
  String get back => 'Atrás';

  @override
  String get backToEvent => 'Volver al evento';

  @override
  String get backToEvents => 'Volver a eventos';

  @override
  String get backToEventsCaps => 'VOLVER A EVENTOS';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get backToMenu => 'Volver al menú';

  @override
  String get backToSignIn => 'Volver a iniciar sesión';

  @override
  String balance(String n) {
    return 'Saldo $n';
  }

  @override
  String get balanceAfter => 'Saldo después';

  @override
  String balanceArrow(String from) {
    return 'Saldo $from →';
  }

  @override
  String get bestStreak => 'Mejor racha';

  @override
  String get bestValue => 'Mejor valor';

  @override
  String get biggerBoardsBody =>
      'En tableros grandes necesitas cuatro en línea para ganar. Si se llena sin línea, es empate.';

  @override
  String get biggerBoardsCaps => 'TABLEROS GRANDES';

  @override
  String get biggerNeedFour => 'Los tableros grandes necesitan cuatro en línea';

  @override
  String get blockPlayer => 'Bloquear jugador';

  @override
  String get boardHiddenUntilBack => 'El tablero se oculta hasta que vuelvas.';

  @override
  String get boards => 'Tableros';

  @override
  String bonusAddedToWallet(String n) {
    return '+$n monedas añadidas a tu cartera';
  }

  @override
  String get bonusClaimed => '¡Bono reclamado!';

  @override
  String bonusCoinsAdded(String n) {
    return '+$n monedas extra añadidas';
  }

  @override
  String get bracket => 'Cuadro';

  @override
  String get bracketInfo =>
      'Octavos · 8 partidas, se muestran 4. Tú estás resaltado.';

  @override
  String get buyCoinsCaps => 'COMPRAR MONEDAS';

  @override
  String get byBoard => 'Por tablero';

  @override
  String get cameraOnlyForScan =>
      'La cámara solo se usa para escanear el código.';

  @override
  String get cameraPermissionNeeded =>
      'Se necesita permiso de cámara para escanear. También puedes escribir el código abajo.';

  @override
  String get cameraPermissionRequired =>
      'Se necesita permiso de cámara para escanear el QR de la sala. Actívalo en los ajustes del sistema e inténtalo de nuevo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancelChallenge => 'Cancelar desafío';

  @override
  String get cancelDownload => 'Cancelar descarga';

  @override
  String get cannotChallengeSelf => 'No puedes desafiarte a ti mismo';

  @override
  String get cannotFriendSelf => 'No puedes añadirte como amigo';

  @override
  String get cantChallengeNow => 'No puedes desafiar a este jugador ahora.';

  @override
  String get challenge => 'Desafío';

  @override
  String get challengeAccepted => 'Desafío aceptado';

  @override
  String get challengeCancelled => 'Desafío cancelado';

  @override
  String get challengeCaps => 'DESAFIAR';

  @override
  String get challengeClosed => 'Desafío cerrado';

  @override
  String get challengeDeclined => 'Desafío rechazado';

  @override
  String get challengeExpired => 'Desafío caducado';

  @override
  String get challengeExpiresIn60 =>
      'El desafío caduca en 60 segundos si no se acepta.';

  @override
  String get challengePrivacy => 'Privacidad de desafíos';

  @override
  String get challengeRequests => 'Solicitudes de desafío';

  @override
  String get challengeSentCoins => 'Desafío enviado · 5 monedas';

  @override
  String get challengeSentFree => 'Desafío enviado · Partida gratis';

  @override
  String get challenges => 'Desafíos';

  @override
  String get championCaps => 'CAMPEÓN';

  @override
  String get change => 'Cambiar';

  @override
  String get chat => 'Chat';

  @override
  String get chatAfterAccept => 'Chat cuando ambos aceptan la solicitud.';

  @override
  String get chatAfterAcceptRandom =>
      'Chat cuando ambos aceptan. Solo se comparte el nombre de usuario.';

  @override
  String chatBlockedFriendsOnly(String name) {
    return '$name solo acepta mensajes de amigos.';
  }

  @override
  String chatBlockedNobody(String name) {
    return '$name desactivó los mensajes.';
  }

  @override
  String get chatNotConnected => 'El chat no está conectado';

  @override
  String get chatOn => 'Chat activo';

  @override
  String get chatPrivacyNote =>
      'Se aplica al chat de partida. Los cambios valen al instante, incluso durante una partida.';

  @override
  String get chatRules => 'Reglas del chat';

  @override
  String get chatRulesIntro =>
      'El chat de texto nunca empieza solo. Un jugador lo pide y el otro debe aceptar.';

  @override
  String get checkAgainCaps => 'COMPROBAR DE NUEVO';

  @override
  String get checkEmail => 'Revisa tu correo';

  @override
  String get checkEmailConfirm =>
      'Revisa tu correo y abre el enlace de confirmación';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get checkInbox => 'Revisa tu bandeja de entrada';

  @override
  String get checking => 'Comprobando…';

  @override
  String get chooseEntryStake => 'Elige tu apuesta de entrada';

  @override
  String get chooseGameMode => 'Elige el modo de juego';

  @override
  String get chooseNewPassword => 'Elige una contraseña nueva';

  @override
  String get chooseOpponent => 'Elige un rival';

  @override
  String get claim => 'RECLAMAR';

  @override
  String claimBonusCoins(String n) {
    return 'Reclama $n monedas extra';
  }

  @override
  String get claimLabel => 'Reclamar';

  @override
  String claimPlusCoins(String n) {
    return 'Reclamar +$n monedas';
  }

  @override
  String get claimVictory => 'Reclamar victoria';

  @override
  String get claimsSync => 'Las recompensas se sincronizan con tu cuenta';

  @override
  String get classicMode => 'Modo clásico (3×3)';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get clipboardNoCode => 'El portapapeles no tiene un código de sala';

  @override
  String get close => 'Cerrar';

  @override
  String get closeAndLose => 'Cerrar y perder la recompensa';

  @override
  String get closeRoom => 'Cerrar sala';

  @override
  String get closing => 'Cerrando…';

  @override
  String get cloud => 'Nube';

  @override
  String cloudSaveFailed(String message) {
    return 'Error al guardar en la nube: $message';
  }

  @override
  String get codeSent => 'Código enviado';

  @override
  String get coinPacks => 'Packs de monedas';

  @override
  String coinPacksFrom(String price) {
    return 'PACKS DESDE $price';
  }

  @override
  String get coins5 => '5 monedas';

  @override
  String coinsAdded(String n) {
    return '+$n monedas añadidas';
  }

  @override
  String coinsBalance(String delta, String balance) {
    return 'Monedas $delta · Saldo $balance';
  }

  @override
  String get coinsEntryFee => 'Entrada de 5 monedas';

  @override
  String get coinsEntryFeeBody =>
      'Se usa cuando se acaban las partidas gratis o para subir la apuesta.';

  @override
  String coinsLabel(String n) {
    return '$n monedas';
  }

  @override
  String coinsSavedCloud(String n) {
    return '+$n monedas (guardado en la nube)';
  }

  @override
  String get column => 'Columna';

  @override
  String get comeBackTomorrow => 'Vuelve mañana';

  @override
  String get completeGoogleReturnApp =>
      'Completa el inicio con Google y vuelve a la app';

  @override
  String get completeGoogleSignIn => 'Completa el inicio con Google y vuelve';

  @override
  String get computer => 'Computadora';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmJoinCaps => 'CONFIRMAR Y UNIRSE';

  @override
  String confirmLinkSentTo(String target) {
    return 'Enviamos un enlace de confirmación a $target.\nÁbrelo en este dispositivo y vuelve aquí — se iniciará sesión automáticamente.';
  }

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get confirmationEmailSent =>
      'Correo de confirmación enviado — revisa tu bandeja';

  @override
  String get confirmingVideo =>
      'Confirmando que viste el video. Espera, por favor.';

  @override
  String get connectingChat => 'Conectando el chat…';

  @override
  String get connectionUnstable => 'Conexión inestable';

  @override
  String get connectionUnstableCaps => 'CONEXIÓN INESTABLE';

  @override
  String get contactAbout => 'Contacto e información';

  @override
  String get contactUsCaps => 'CONTACTO';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get continuePlaying => 'Seguir jugando';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String copiedValue(String label, String value) {
    return '$label copiado: $value';
  }

  @override
  String get couldNotAddCoins => 'No se pudieron añadir monedas';

  @override
  String get couldNotApplyReferral => 'No se pudo aplicar el código';

  @override
  String couldNotCheck(String error) {
    return 'No se pudo comprobar: $error';
  }

  @override
  String get couldNotJoinRoom => 'No se pudo unir a la sala';

  @override
  String get couldNotLoadPrivacy => 'No se pudo cargar la privacidad';

  @override
  String get couldNotLoadProfile =>
      'No se pudo cargar tu perfil. Inténtalo de nuevo.';

  @override
  String get couldNotOpenGoogle =>
      'No se pudo abrir el inicio de sesión de Google';

  @override
  String get couldNotSavePrivacy => 'No se pudo guardar la privacidad';

  @override
  String get couldNotStopChat => 'No se pudo detener el chat';

  @override
  String get couldNotSubmitAppeal => 'No se pudo enviar la apelación';

  @override
  String get couldNotVerify => 'No pudimos verificarlo';

  @override
  String get couldNotVerifyAccount =>
      'No se pudo verificar el estado de la cuenta. Inténtalo de nuevo.';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createPrivateRoom => 'Crear sala privada';

  @override
  String get customize => 'Personalizar';

  @override
  String get daily => 'Diario';

  @override
  String get dailyChest => 'Cofre diario';

  @override
  String get dailyLimit => 'LÍMITE DIARIO ALCANZADO';

  @override
  String get date => 'Fecha';

  @override
  String dayN(String n) {
    return 'Día $n';
  }

  @override
  String dayStreak(String n) {
    return 'Racha de $n días';
  }

  @override
  String get days30 => '30 días';

  @override
  String get days7 => '7 días';

  @override
  String get debitFailed => 'No se pudieron descontar las monedas';

  @override
  String get declineCaps => 'RECHAZAR';

  @override
  String get defeat => 'DERROTA';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountBody =>
      'Esto elimina tus monedas, puntuación e historial para siempre.';

  @override
  String get deleteAccountQuestion => '¿Eliminar cuenta?';

  @override
  String get descriptionMin10 =>
      'La descripción debe tener al menos 10 caracteres';

  @override
  String get diagonal => 'Diagonal';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get doll => 'Muñeca';

  @override
  String get done => 'Hecho';

  @override
  String get downloadAndInstall => 'Descargar e instalar';

  @override
  String get downloading => 'Descargando…';

  @override
  String downloadingPercent(String percent) {
    return 'Descargando $percent %';
  }

  @override
  String get draw => 'Empate';

  @override
  String get drawBadge => 'EMPATE';

  @override
  String get draws => 'Empates';

  @override
  String get duration => 'Periodo';

  @override
  String get earned => 'Ganado';

  @override
  String get earnedThisWeek => 'Ganado esta semana, por origen';

  @override
  String get editProfileCaps => 'EDITAR PERFIL';

  @override
  String get eliminatedCaps => 'ELIMINADO';

  @override
  String get email => 'Correo';

  @override
  String get emailNotConfirmed => 'Correo no confirmado';

  @override
  String emailNotConfirmedBody(String email) {
    return 'Tu registro funcionó, pero tu correo aún no está confirmado.\n\nAbre el enlace de confirmación en tu bandeja de entrada o spam y vuelve a iniciar sesión.\n\n$email';
  }

  @override
  String get emailSentAgain => 'Correo reenviado — revisa tu bandeja';

  @override
  String get endsIn => 'Termina en';

  @override
  String get enterCode => 'Introducir código';

  @override
  String get enterCodeFromEmail => 'Escribe el código de tu correo';

  @override
  String get enterCodeInstead => 'Escribir el código';

  @override
  String get enterEmailPassword => 'Escribe correo y contraseña';

  @override
  String get enterFullCode => 'Escribe el código completo';

  @override
  String get enterReferralOrSkip =>
      'Escribe un código de referido u omítelo por ahora';

  @override
  String get enterResetCode => 'Introduce el código';

  @override
  String get enterValidMobile => 'Escribe un número de móvil válido';

  @override
  String get enterValidReferral => 'Escribe un código de referido válido';

  @override
  String get enterYourEmail => 'Escribe tu correo';

  @override
  String get entry => 'Entrada';

  @override
  String get entryFee => 'Inscripción';

  @override
  String get equip => 'Equipar';

  @override
  String get equipped => 'Equipado';

  @override
  String get events => 'Eventos';

  @override
  String get everyone => 'Todos';

  @override
  String get expertMode => 'Modo experto (5×5)';

  @override
  String get expiredMoveToHistory =>
      'Los desafíos caducados pasan al Historial.';

  @override
  String get failed => 'Error';

  @override
  String get fillAllFields => 'Completa todos los campos';

  @override
  String get finalRound => 'Final';

  @override
  String get findAMatch => 'Buscar partida';

  @override
  String get findOpponent => 'Buscar rival';

  @override
  String get findPrivateJoin => 'Buscar · sala privada · código';

  @override
  String get findingOpponent => 'Buscando rival';

  @override
  String get findingPlayer => 'Buscando jugador';

  @override
  String get firstMatchSet =>
      'Tu primera partida se fija cuando abra la ronda.';

  @override
  String get fiveOfFiveWatched => '5 de 5 videos vistos';

  @override
  String get flash => 'Flash';

  @override
  String get flashUnavailable => 'Flash no disponible';

  @override
  String get forgotPassword => '¿Olvidaste la contraseña?';

  @override
  String get forgotPasswordTitle => 'Olvidé la contraseña';

  @override
  String get free => 'Gratis';

  @override
  String get freeCoins => 'MONEDAS GRATIS';

  @override
  String get freeMatch => 'Partida gratis';

  @override
  String get freeMatchesPerDay => '3 partidas gratis al día';

  @override
  String get freeVideosToday => 'Videos gratis hoy';

  @override
  String freeVideosUsed(String used) {
    return '$used de 5 videos gratis usados hoy';
  }

  @override
  String get friendChallenge => 'Desafío entre amigos';

  @override
  String get friendRequestExists => 'Ya existe una solicitud de amistad';

  @override
  String friendRequestSent(String name) {
    return 'Solicitud de amistad enviada a $name';
  }

  @override
  String get friendRequestSentShort => 'Solicitud de amistad enviada';

  @override
  String get friendsCaps => 'AMIGOS';

  @override
  String get friendsLabel => 'Amigos';

  @override
  String get friendsOnly => 'Solo amigos';

  @override
  String get fromPhoto => 'Desde foto';

  @override
  String gameComingSoon(String game) {
    return '$game: próximamente';
  }

  @override
  String get gameOver => 'Fin del juego';

  @override
  String get gamePaused => 'Juego en pausa';

  @override
  String get getStarted => 'Empezar';

  @override
  String get gettingVideo => 'Cargando tu video…';

  @override
  String get goToMatchCaps => 'IR A LA PARTIDA';

  @override
  String get gotIt => 'Entendido';

  @override
  String get graceWindowEnded =>
      'Se acabaron los 30 segundos de espera. Puedes reclamar la victoria.';

  @override
  String greatRun(String name) {
    return 'Gran actuación en $name';
  }

  @override
  String get guard => 'Guardia';

  @override
  String get guest => 'Invitado';

  @override
  String get history => 'Historial';

  @override
  String get historyNeverPublic =>
      'Tu historial y actividad nunca se muestran en tu perfil público.';

  @override
  String historySummary(
      String matches, String wins, String losses, String draws) {
    return '$matches partidas · $wins victorias · $losses derrotas · $draws empates';
  }

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get howToPlay => 'Cómo jugar';

  @override
  String get howToPlayRules =>
      'Coloca tres de tus marcas en línea, horizontal, vertical o diagonal, antes que tu rival. En tableros grandes necesitas cuatro.';

  @override
  String howToPlayStep(String n) {
    return 'CÓMO JUGAR · $n/3';
  }

  @override
  String get imReadyCaps => 'ESTOY LISTO';

  @override
  String get imageTooBig => 'La imagen debe pesar menos de 2 MB';

  @override
  String get install => 'Instalar';

  @override
  String get installUpdate => 'Instalar actualización';

  @override
  String get installed => 'Instalada';

  @override
  String get internetRequired =>
      'Se necesita conexión a internet. Aún puedes jugar contra The Doll sin conexión.';

  @override
  String get introBody1 => 'Vence a la IA en tableros de 3×3, 4×4 o 5×5.';

  @override
  String get introBody2 =>
      'Partidas aleatorias con jugadores reales. Apuesta monedas, gana monedas.';

  @override
  String get introBody3 =>
      'Recompensas diarias, misiones y torneos para seguir subiendo.';

  @override
  String get introTitle1 => 'Supera a The Doll';

  @override
  String get introTitle2 => 'Desafía al mundo';

  @override
  String get introTitle3 => 'Sube en la clasificación';

  @override
  String get invalidRoomQr => 'QR de sala no válido';

  @override
  String get inviteImage => 'Imagen de invitación';

  @override
  String get inviteImageBody =>
      'Código, QR y enlace en una imagen. Envíala por WhatsApp o donde quieras.';

  @override
  String isThinking(String name) {
    return '$name está pensando';
  }

  @override
  String get joinCaps => 'UNIRSE';

  @override
  String joinForCoins(String n) {
    return 'UNIRSE POR $n MONEDAS';
  }

  @override
  String get joinRoomCaps => 'UNIRSE A SALA';

  @override
  String get joinTheGame => 'Únete al juego';

  @override
  String joinTournamentQuestion(String name) {
    return '¿Unirte a $name?';
  }

  @override
  String get joinWithCode => 'Unirse con código';

  @override
  String get joined => 'Inscrito';

  @override
  String get joiningCaps => 'UNIÉNDOSE…';

  @override
  String get joiningQueue => 'Entrando en la cola…';

  @override
  String get joiningRoom => 'Uniéndose a la sala…';

  @override
  String get keepWatchingCaps => 'SEGUIR VIENDO';

  @override
  String get language => 'Idioma';

  @override
  String get languageUpdated => 'Idioma actualizado';

  @override
  String get last20Sent => 'Se envían los últimos 20 mensajes con tu denuncia.';

  @override
  String get last7Games => 'Últimas 7 partidas';

  @override
  String lastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get later => 'Más tarde';

  @override
  String get latestVersion => 'Tienes la última versión.';

  @override
  String get leaderboard => 'Clasificación';

  @override
  String get leaderboardUpdated => 'Clasificación actualizada';

  @override
  String get leave => 'Salir';

  @override
  String get leaveForfeitBody =>
      'Si sales ahora, se cuenta como abandono. Gana tu rival.';

  @override
  String get leaveGame => 'Salir del juego';

  @override
  String get leaveMatchQuestion => '¿Abandonar la partida?';

  @override
  String get leaveVideoQuestion => '¿Salir del video?';

  @override
  String get letsPlay => '¡A jugar!';

  @override
  String get linkCopied => 'Enlace copiado';

  @override
  String get live => 'En vivo';

  @override
  String get liveEventCaps => 'EVENTO EN VIVO';

  @override
  String get loading => 'Cargando…';

  @override
  String get local => 'Local';

  @override
  String get locked => 'Bloqueado';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get loginMethod => 'Método de inicio de sesión';

  @override
  String loseCoinsIfClose(String seconds) {
    return 'Si lo cierras ahora no recibirás tus 10 monedas. Quedan $seconds segundos.';
  }

  @override
  String get losses => 'Derrotas';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get marks => 'Marcas';

  @override
  String get match => 'Partida';

  @override
  String get matchAbandonedCaps => 'PARTIDA ABANDONADA';

  @override
  String matchDuration(String duration) {
    return 'Duración $duration';
  }

  @override
  String get matchHistory => 'Historial de partidas';

  @override
  String get matchHistoryCaps => 'HISTORIAL DE PARTIDAS';

  @override
  String get matchInvitations => 'Invitaciones a partidas';

  @override
  String get matchLobby => 'Sala de espera';

  @override
  String get matchResult => 'Resultado';

  @override
  String get matchResults => 'Resultados de partidas';

  @override
  String get matchStakes => 'Apuestas de la partida';

  @override
  String get matchStartsIn => 'La partida empieza en';

  @override
  String get matches => 'Partidas';

  @override
  String get matchmakingError => 'Error de emparejamiento';

  @override
  String get matchmakingFailed => 'Error al buscar partida';

  @override
  String get matchmakingStopped => 'Búsqueda detenida';

  @override
  String memberSince(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get messageEmpty => 'El mensaje no puede estar vacío';

  @override
  String get messagesStayForMatch => 'Los mensajes solo duran esta partida';

  @override
  String minusCoins(String n) {
    return '-$n monedas';
  }

  @override
  String get misPlay30 => 'Juega 30 partidas';

  @override
  String get misPlay5 => 'Juega 5 partidas';

  @override
  String get misQuick => 'Juega una partida aleatoria';

  @override
  String get misTourney => 'Únete a un torneo';

  @override
  String get misWin15 => 'Gana 15 partidas';

  @override
  String get misWin3 => 'Gana 3 partidas';

  @override
  String get misWin4x4 => 'Gana en un tablero 4×4';

  @override
  String get missResets =>
      'Si faltas un día, se reinicia. Vuelve mañana por la siguiente recompensa.';

  @override
  String get missingChallengeData => 'Faltan datos del desafío';

  @override
  String get missingEmail => 'Falta el correo — vuelve e inténtalo de nuevo';

  @override
  String get missions => 'Misiones';

  @override
  String missionsDone(String done, String total) {
    return '$done de $total misiones hechas';
  }

  @override
  String get mobileNotSupported =>
      'Los números de móvil aún no están disponibles en tu región';

  @override
  String get mobileOptional => 'Número de móvil (opcional)';

  @override
  String mode(String n) {
    return 'Modo $n';
  }

  @override
  String get more => 'Más';

  @override
  String get moreGames => 'Más juegos';

  @override
  String get music => 'Música';

  @override
  String nOf5(String n) {
    return '$n de 5';
  }

  @override
  String get navPlay => 'Jugar';

  @override
  String get newCodeSent => 'Nuevo código enviado — revisa tu bandeja';

  @override
  String get newHere => '¿Eres nuevo?';

  @override
  String get newMatchChallengeCaps => '¡NUEVO DESAFÍO!';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get newPasswordBody =>
      'Escribe una contraseña nueva. Seguirás con la sesión iniciada al guardar.';

  @override
  String get newVersion => 'Nueva versión';

  @override
  String get newVersionReady => 'Hay una nueva versión de DROTIX.';

  @override
  String get newVideosUnlockIn => 'Nuevos videos gratis en';

  @override
  String get next => 'Siguiente';

  @override
  String get nextCaps => 'SIGUIENTE';

  @override
  String get nextRound => 'Siguiente ronda';

  @override
  String get no => 'No';

  @override
  String get noChallenge => 'Sin desafío';

  @override
  String get noChallengesHere => 'No hay desafíos aquí.';

  @override
  String get noCloudMatches =>
      'Aún no hay partidas en la nube. Juega contra The Doll con sesión iniciada para aparecer aquí.';

  @override
  String get noFriendsYet =>
      'Aún no tienes amigos — busca para añadir a alguien.';

  @override
  String get noHistory => 'No hay historial';

  @override
  String get noMatchesYet => 'Aún no hay partidas';

  @override
  String get noMessagesYet =>
      'Aún no hay mensajes.\nLas respuestas rápidas también sirven.';

  @override
  String get noNotificationsYet => 'Aún no hay notificaciones';

  @override
  String get noOpponentFound => 'No se encontró rival — inténtalo de nuevo';

  @override
  String get noPendingRequests => 'No hay solicitudes pendientes.';

  @override
  String get noPlayersFound => 'No se encontraron jugadores';

  @override
  String get noQrInPhoto => 'No se encontró ningún QR en la foto';

  @override
  String get noRankedPlayers =>
      'Aún no hay jugadores clasificados. Inicia sesión y juega para entrar.';

  @override
  String get noTransactions => 'Aún no hay movimientos.';

  @override
  String get noVideoFound =>
      'No encontramos un video para ti. Tu video gratis no se gastó. Inténtalo en un minuto.';

  @override
  String get noVideoNow =>
      'No hay videos disponibles ahora. Inténtalo más tarde.';

  @override
  String get noVideoRightNow => 'No hay video ahora';

  @override
  String get nobody => 'Nadie';

  @override
  String get nobodyBlinked => 'Nadie cedió.';

  @override
  String nobodyBlinkedVs(String name) {
    return 'Nadie cedió. $name te frenó.';
  }

  @override
  String notAcceptingChallenges(String name) {
    return '$name no acepta desafíos ahora mismo.';
  }

  @override
  String get notEnoughCoins => 'No tienes suficientes monedas';

  @override
  String get notEnoughCoinsAnother =>
      'No tienes suficientes monedas para otra apuesta.';

  @override
  String get notEnoughCoinsStake =>
      'No tienes suficientes monedas para esta apuesta.';

  @override
  String get notNow => 'Ahora no';

  @override
  String get notSignedIn => 'No has iniciado sesión';

  @override
  String get notSignedInYet =>
      'Aún no has iniciado sesión — abre primero el enlace';

  @override
  String notifChallengeAcceptedBody(String name) {
    return '$name aceptó tu desafío. ¡Empieza la partida!';
  }

  @override
  String get notifChallengeAcceptedTitle => 'Desafío aceptado';

  @override
  String notifChallengeBusyBody(String name) {
    return '$name está en una partida ahora. Inténtalo más tarde.';
  }

  @override
  String get notifChallengeBusyTitle => 'El jugador está ocupado';

  @override
  String notifChallengeCancelledBody(String name) {
    return '$name canceló el desafío';
  }

  @override
  String get notifChallengeCancelledTitle => 'Desafío cancelado';

  @override
  String notifChallengeDeclinedBody(String name) {
    return '$name rechazó tu desafío';
  }

  @override
  String get notifChallengeDeclinedTitle => 'Desafío rechazado';

  @override
  String notifChallengeExpiredBody(String name) {
    return '$name no respondió a tiempo';
  }

  @override
  String get notifChallengeExpiredTitle => 'Desafío caducado';

  @override
  String notifChallengeRequestBody(String name) {
    return '$name te desafió a una partida';
  }

  @override
  String get notifChallengeRequestTitle => 'Nuevo desafío';

  @override
  String get notifChannelDesc => 'Desafíos, partidas y monedas';

  @override
  String get notifChannelName => 'Alertas del juego';

  @override
  String notifCoinsAddedBody(String amount, String balance) {
    return 'Se añadieron $amount monedas. Saldo: $balance';
  }

  @override
  String get notifCoinsCreditTitle => 'Monedas añadidas';

  @override
  String notifCoinsDebitBody(String amount, String balance) {
    return 'Se descontaron $amount monedas. Saldo: $balance';
  }

  @override
  String get notifCoinsDebitTitle => 'Monedas descontadas';

  @override
  String get notifCoinsPurchaseTitle => 'Compra completada';

  @override
  String notifCoinsRewardBody(String amount, String balance) {
    return 'Ganaste $amount monedas. Saldo: $balance';
  }

  @override
  String get notifCoinsRewardTitle => 'Recompensa recibida';

  @override
  String get notifEmptyHint =>
      'Aquí verás desafíos, resultados de partidas y movimientos de monedas.';

  @override
  String notifFriendAcceptedBody(String name) {
    return '$name aceptó tu solicitud de amistad';
  }

  @override
  String get notifFriendAcceptedTitle => 'Nuevo amigo';

  @override
  String notifFriendRequestBody(String name) {
    return '$name quiere ser tu amigo';
  }

  @override
  String get notifFriendRequestTitle => 'Solicitud de amistad';

  @override
  String get notifGeneric => 'Nueva notificación';

  @override
  String notifMatchBody(String name) {
    return 'Tu partida contra $name terminó';
  }

  @override
  String get notifMatchDrawTitle => 'Empate';

  @override
  String get notifMatchLostTitle => 'Perdiste';

  @override
  String get notifMatchWonTitle => '¡Ganaste!';

  @override
  String notifRoomJoinedBody(String name) {
    return '$name se unió a tu sala privada';
  }

  @override
  String get notifRoomJoinedTitle => 'Jugador unido';

  @override
  String get notifications => 'Notificaciones';

  @override
  String nowFriends(String name) {
    return '$name y tú ahora son amigos';
  }

  @override
  String get nowFriendsShort => 'Ahora son amigos';

  @override
  String get officialWebsite => 'Sitio web oficial';

  @override
  String get offlineAi => 'IA sin conexión';

  @override
  String offlineAiSubtitle(String size, String stake) {
    return 'Sin internet · Solo rivales IA · $size · Apuesta $stake';
  }

  @override
  String get offlineBanner =>
      'Sin conexión · Jugar contra The Doll sigue funcionando';

  @override
  String get offlineBody =>
      'Las partidas en línea y los torneos necesitan conexión. Aún puedes jugar contra The Doll.';

  @override
  String get offlineProfilesNote =>
      'Son perfiles de IA sin conexión, no jugadores reales.';

  @override
  String get offlineSmart => 'Sin conexión, rival inteligente';

  @override
  String get ok => 'Aceptar';

  @override
  String get oneLastStepCaps => 'UN ÚLTIMO PASO';

  @override
  String get online => 'En línea';

  @override
  String get onlineMatch => 'Partida en línea';

  @override
  String get onlineMultiplayer => 'Multijugador en línea';

  @override
  String get onlineOfflineAi => 'Jugadores en línea · IA sin conexión';

  @override
  String onlineStake(String stake) {
    return 'En línea · Apuesta $stake';
  }

  @override
  String onlyFriendsChallenges(String name) {
    return '$name solo acepta desafíos de amigos. Añádelo primero.';
  }

  @override
  String get open => 'Abrir';

  @override
  String get openedTheLink => 'Ya abrí el enlace';

  @override
  String get openingInstaller => 'Abriendo el instalador…';

  @override
  String get opponent => 'Rival';

  @override
  String get opponentAdvances => 'Si no entras a tiempo, tu rival avanza.';

  @override
  String get opponentDisconnected => 'El rival se desconectó';

  @override
  String get opponentWins => 'Gana el rival';

  @override
  String opponentsMove(String name) {
    return 'Turno de $name';
  }

  @override
  String get or => 'O';

  @override
  String get orEnterCodeCaps => 'O ESCRIBE EL CÓDIGO';

  @override
  String get otherEvents => 'Otros eventos';

  @override
  String get owned => 'Comprado';

  @override
  String get passAndPlay => 'Pasa y juega';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordMin6 => 'La contraseña debe tener al menos 6 caracteres';

  @override
  String get passwordUpdated => 'Contraseña actualizada';

  @override
  String get passwordsNoMatch => 'Las contraseñas no coinciden';

  @override
  String get pasteCode => 'Pegar código';

  @override
  String get pause => 'Pausa';

  @override
  String get paused => 'En pausa';

  @override
  String get perMove20s => '20 s por jugada';

  @override
  String get photoUpdated => 'Foto actualizada';

  @override
  String get pickClosestReason =>
      '¿Qué está pasando? Elige el motivo más cercano.';

  @override
  String get pickYourGame => 'Elige tu juego';

  @override
  String get playAgain => 'Jugar de nuevo';

  @override
  String get playAsGuest => 'Jugar como invitado';

  @override
  String get playCaps => 'JUGAR';

  @override
  String get playDollOffline => 'Jugar contra The Doll sin conexión';

  @override
  String get playToBuildForm => 'Juega una partida para ver tu racha.';

  @override
  String get playVsDoll => 'Juega contra The Doll';

  @override
  String playVsName(String name) {
    return 'Jugar contra $name';
  }

  @override
  String get played => 'Jugadas';

  @override
  String get player => 'Jugador';

  @override
  String get player1 => 'Jugador 1';

  @override
  String get player1Move => 'Turno del jugador 1';

  @override
  String get player1Wins => '¡Gana el jugador 1!';

  @override
  String get player2 => 'Jugador 2';

  @override
  String get player2Move => 'Turno del jugador 2';

  @override
  String get player2Wins => '¡Gana el jugador 2!';

  @override
  String playerAdded(String name) {
    return '$name añadido';
  }

  @override
  String get playerBlocked => 'Jugador bloqueado';

  @override
  String playerIdLabel(String id) {
    return 'JUGADOR $id';
  }

  @override
  String get playerUnblocked => 'Jugador desbloqueado';

  @override
  String get players => 'Jugadores';

  @override
  String get playersLeft => 'Jugadores restantes';

  @override
  String get pleaseWait => 'Espera…';

  @override
  String plusCoins(String n) {
    return '+$n monedas';
  }

  @override
  String get podium => 'Podio';

  @override
  String get pointAtHostQr =>
      'Apunta al QR del anfitrión. Es el mismo código de la sala.';

  @override
  String get pointCameraAtQr => 'Apunta la cámara al código QR de la sala';

  @override
  String pointsWins(String points, String wins) {
    return '$points pts · $wins victorias';
  }

  @override
  String get popular => 'Popular';

  @override
  String get previousMatchExpired =>
      'La partida anterior caducó. Inténtalo en un momento.';

  @override
  String get privacy => 'Privacidad';

  @override
  String privacyBody(String email) {
    return 'Solo recopilamos los datos de juego necesarios para que la app funcione (monedas, objetos, historial y ajustes). Jugar como invitado no requiere cuenta.\n\nSi inicias sesión, tus datos solo se usan para guardar y recuperar tu progreso. No vendemos datos personales. Puedes borrar tus datos cuando quieras en Ajustes → Eliminar cuenta.\n\nContacto: $email';
  }

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privateOnlyYou => 'Privado. Solo tú puedes verlo.';

  @override
  String get privateRoomByUsername => 'Sala privada (por usuario)';

  @override
  String get privateRoomCaps => 'SALA PRIVADA';

  @override
  String get prizeAdded => 'Premio añadido a tu saldo';

  @override
  String get prizePool => 'Premio total';

  @override
  String get profile => 'Perfil';

  @override
  String get profileNotFound => 'Perfil no encontrado';

  @override
  String get profilePrivacyNote =>
      'El historial y la actividad son privados. Denunciar es para abusos en el perfil; para el chat de la partida usa el botón Denunciar del chat.';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String progressOf(String done, String total) {
    return '$done de $total';
  }

  @override
  String get publicStatsNote =>
      'Solo el rango, los puntos y las victorias son públicos. El historial y la actividad son privados.';

  @override
  String get purchaseFailed => 'La compra falló';

  @override
  String get purchases => 'Compras';

  @override
  String get purchasesComingSoon =>
      'La compra de monedas llegará pronto. Mira un video en Monedas gratis para ganar monedas ya.';

  @override
  String get quarter => 'Cuartos';

  @override
  String get quarterFinal => 'Cuartos de final';

  @override
  String get quickCloseOne => '¡Por poco!';

  @override
  String get quickGg => 'GG';

  @override
  String get quickGoodMove => '¡Buena jugada!';

  @override
  String quickMatchVsAi(String time) {
    return 'Partida rápida vs IA · $time';
  }

  @override
  String get quitMatch => 'Abandonar partida';

  @override
  String get randomMatch => 'Partida aleatoria';

  @override
  String get rank => 'Rango';

  @override
  String rankScore(String rank, String score) {
    return 'Rango #$rank · Puntos $score';
  }

  @override
  String get rankScoreUnknown => 'Rango – · Puntos –';

  @override
  String get ranks => 'Rangos';

  @override
  String get rateApp => 'Valorar la app';

  @override
  String get ratingsSoon => 'Las valoraciones llegarán pronto';

  @override
  String get readOnly => 'solo lectura';

  @override
  String get readyCaps => 'LISTO';

  @override
  String get reasonHarassment => 'Acoso o intimidación';

  @override
  String get reasonInappropriate => 'Contenido sexual o inapropiado';

  @override
  String get reasonOffensive => 'Discurso de odio o insultos';

  @override
  String get reasonOther => 'Otra cosa';

  @override
  String get reasonSpam => 'Spam o estafas';

  @override
  String get reasonThreatening => 'Amenazas o violencia';

  @override
  String get received => 'Recibidos';

  @override
  String get reconnecting => 'Reconectando…';

  @override
  String reference(String id) {
    return 'Referencia: $id';
  }

  @override
  String get referralCode => 'Código de referido';

  @override
  String get referralHint => 'Código de referido (opcional)';

  @override
  String get referralOnce =>
      'Solo puedes usar un código de referido una vez, justo después de registrarte.';

  @override
  String get referralPrompt =>
      '¿Un amigo te dio un código? Escríbelo ahora y gana 50 monedas.';

  @override
  String get referralWorked =>
      'Tu código funcionó. Las monedas ya están en tu cartera.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get refreshStatus => 'Actualizar estado';

  @override
  String get region => 'Región';

  @override
  String get regionIndiaNote =>
      'Detectado automáticamente desde tu SIM o dispositivo. En India se muestran idiomas indios y precios en ₹.';

  @override
  String regionIntlNote(String currency) {
    return 'Detectado automáticamente desde tu SIM o dispositivo. Idiomas internacionales, precios en $currency.';
  }

  @override
  String get register => 'Regístrate';

  @override
  String get released => 'Publicada';

  @override
  String get rematch => 'Revancha';

  @override
  String get rematchQuestion => '¿Revancha?';

  @override
  String get remindMe => 'Recordármelo antes de mi partida';

  @override
  String get reportButtonCaps => 'BOTÓN DE DENUNCIA';

  @override
  String get reportButtonHelp =>
      'Arriba a la derecha del chat en vivo, junto a Detener chat. Siempre visible con el chat activo.\nToca → elige un motivo → añade detalles y capturas → envía.';

  @override
  String get reportCaps => 'DENUNCIAR';

  @override
  String get reportFailed => 'No se pudo enviar la denuncia';

  @override
  String reportName(String name) {
    return 'Denunciar a $name';
  }

  @override
  String get reportOrBlock => 'Denunciar o bloquear';

  @override
  String get reportOrBlockPlayer => 'Denunciar o bloquear a este jugador';

  @override
  String get reportPlayer => 'Denunciar jugador';

  @override
  String get requestSentCaps => 'SOLICITUD ENVIADA';

  @override
  String requestSentTo(String name) {
    return 'Solicitud enviada a $name';
  }

  @override
  String get requests => 'Solicitudes';

  @override
  String requestsCount(String n) {
    return 'Solicitudes · $n';
  }

  @override
  String get requestsExpire7d =>
      'Las solicitudes caducan a los 7 días sin respuesta.';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get resendEmail => 'Reenviar correo';

  @override
  String get resetCode => 'Código de restablecimiento';

  @override
  String resetCodeSentTo(String target) {
    return 'Enviamos un código a $target.\nEscríbelo abajo — no necesitas abrir el enlace del correo.';
  }

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetPasswordBody =>
      'Escribe tu correo y te enviaremos un código. Escríbelo en la app — no hace falta abrir el enlace.';

  @override
  String get restart => 'Reiniciar';

  @override
  String get result => 'Resultado';

  @override
  String get resume => 'Reanudar';

  @override
  String get returnToMainMenu => 'Volver al menú principal';

  @override
  String get rewardEarnedCaps => 'RECOMPENSA OBTENIDA';

  @override
  String get rewardFlowOverview => 'Resumen de recompensas';

  @override
  String rewardIn(String time) {
    return 'Recompensa en $time';
  }

  @override
  String get rivalO => 'Rival: O';

  @override
  String get roomCancelled => 'Sala cancelada';

  @override
  String roomClosesIn(String time) {
    return 'La sala se cierra en $time si nadie se une.';
  }

  @override
  String get roomClosesSoon => 'La sala se cerrará pronto si nadie se une.';

  @override
  String get roomClosing => 'La sala se está cerrando…';

  @override
  String get roomCodeCaps => 'CÓDIGO DE SALA';

  @override
  String get roomCodeCopied => 'Código de sala copiado';

  @override
  String get roomExpired => 'La sala caducó';

  @override
  String get roomOpenCaps => 'SALA ABIERTA';

  @override
  String get roundOf16 => 'Octavos';

  @override
  String get roundOf16Caps => 'OCTAVOS';

  @override
  String roundOf16Vs(String name) {
    return 'Octavos · vs $name';
  }

  @override
  String get roundsWon => 'Rondas ganadas';

  @override
  String get row => 'Fila';

  @override
  String get ruleEmoji =>
      '• Las reacciones con emoji no necesitan solicitud y se pueden silenciar.';

  @override
  String get ruleEnds =>
      '• El chat termina automáticamente al acabar la partida.';

  @override
  String get ruleStop =>
      '• Cualquiera de los dos puede detener el chat cuando quiera.';

  @override
  String get ruleVanish =>
      '• Los mensajes desaparecen en segundos y nunca se guardan.';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get savePassword => 'Guardar contraseña';

  @override
  String get saving => 'Guardando…';

  @override
  String get savingToCloud => 'Guardando en la nube…';

  @override
  String get scanOrShare => 'Escanea para unirte o comparte el enlace';

  @override
  String get scanQr => 'Escanear QR';

  @override
  String get score => 'Puntos';

  @override
  String get scorePlus10 => 'Puntos +10';

  @override
  String get screenshotTooBig => 'La captura debe pesar menos de 2 MB';

  @override
  String get screenshotsOptionalCaps => 'CAPTURAS (OPCIONAL)';

  @override
  String get searchPlayersHint => 'Busca por usuario o ID de jugador';

  @override
  String get searchResults => 'Resultados';

  @override
  String searchingSubtitle(String size, String stake, String time) {
    return 'En línea · $size · apuesta $stake · $time';
  }

  @override
  String get seatWaiting => 'Jugador, tu asiento te espera.';

  @override
  String secondsLeft(String seconds) {
    return 'Quedan $seconds s';
  }

  @override
  String secondsLeftToRespond(String seconds) {
    return 'Quedan $seconds s para responder';
  }

  @override
  String get selectDifficulty => 'Elige la dificultad';

  @override
  String get selectOpponent => 'Selecciona un rival';

  @override
  String get selectReportReason => 'Elige un motivo';

  @override
  String get semi => 'Semis';

  @override
  String get send => 'Enviar';

  @override
  String get sendChallenge => 'Enviar desafío';

  @override
  String get sendResetCode => 'Enviar código';

  @override
  String get sending => 'Enviando…';

  @override
  String get sendingMove => 'Enviando jugada…';

  @override
  String get sent => 'Enviada';

  @override
  String serverTournamentsDemo(String error) {
    return 'Torneos del servidor no disponibles — mostrando demo.\n$error';
  }

  @override
  String get sessionExpiredReset => 'La sesión caducó — pide un código nuevo';

  @override
  String get settings => 'Ajustes';

  @override
  String get shareComingSoon => 'Compartir llegará pronto';

  @override
  String get shareInviteCaps => 'COMPARTIR INVITACIÓN';

  @override
  String get shareOnWhatsApp => 'Compartir en WhatsApp';

  @override
  String get shareProfile => 'Compartir perfil';

  @override
  String shareWin(String url) {
    return '¡Acabo de ganar una partida de DROTIX! ¿Crees que puedes vencerme? Juega ya: $url';
  }

  @override
  String shareWinVs(String name, String url) {
    return '¡Acabo de ganarle a $name en DROTIX! ¿Crees que puedes vencerme? Juega ya: $url';
  }

  @override
  String get shop => 'Tienda';

  @override
  String get showHidePassword => 'Mostrar u ocultar contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInChangePhoto => 'Inicia sesión para cambiar la foto';

  @override
  String get signInFindFriends => 'Inicia sesión para buscar amigos';

  @override
  String get signInMatchmaking => 'Inicia sesión para buscar partidas en línea';

  @override
  String get signInNotifications => 'Inicia sesión para ver tus notificaciones';

  @override
  String get signInOnline => 'Inicia sesión para jugar en línea';

  @override
  String get signInRandomMatch =>
      'Inicia sesión para jugar partidas aleatorias contra jugadores reales';

  @override
  String get signInRequired => 'Debes iniciar sesión';

  @override
  String get signInSearchPlayers =>
      'Inicia sesión para buscar jugadores y sincronizar amigos en la nube.';

  @override
  String get signInToAddFriends => 'Inicia sesión para añadir amigos';

  @override
  String get signInToChallenge => 'Inicia sesión para desafiar a este jugador';

  @override
  String get signInWalletHistory =>
      'Inicia sesión para ver el historial de tu cartera.';

  @override
  String get signInWithEmail => 'Iniciar sesión con correo';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get skip => 'Omitir';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String somethingWentWrongDetail(String error) {
    return 'Algo salió mal: $error';
  }

  @override
  String get soundDisabled => 'Sonido desactivado';

  @override
  String get soundEffects => 'Efectos de sonido';

  @override
  String get soundEnabled => 'Sonido activado';

  @override
  String get spent => 'Gastado';

  @override
  String get sponsored => 'Patrocinado';

  @override
  String stakeDot(String n) {
    return 'Apuesta · $n';
  }

  @override
  String get stakeReturned => 'Apuesta devuelta';

  @override
  String stakeRoom(String stake, String room) {
    return 'Apuesta $stake · $room…';
  }

  @override
  String get start => 'Empezar';

  @override
  String get startPlayingCaps => 'EMPEZAR A JUGAR';

  @override
  String get starterPack => 'Pack inicial';

  @override
  String get starting => 'Iniciando…';

  @override
  String get startsInCaps => 'EMPIEZA EN';

  @override
  String get stats => 'Estadísticas';

  @override
  String statusLabel(String status) {
    return 'Estado: $status';
  }

  @override
  String get stayInApp =>
      'Quédate en la app. Te avisaremos cuando tu partida esté lista.';

  @override
  String get stillOffline =>
      'Sigues sin conexión. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get stopChat => 'Detener chat';

  @override
  String get submitAppeal => 'Enviar apelación';

  @override
  String get submitReportCaps => 'ENVIAR DENUNCIA';

  @override
  String submittedAt(String date) {
    return 'Enviada: $date';
  }

  @override
  String get submitting => 'Enviando…';

  @override
  String get submittingCaps => 'ENVIANDO…';

  @override
  String get supportEmail => 'Correo de soporte';

  @override
  String suspendedAt(String date) {
    return 'Suspendida: $date';
  }

  @override
  String get suspendedByModerator =>
      'Un moderador suspendió esta cuenta tras revisar una denuncia.';

  @override
  String get suspendedRules =>
      'Mientras estés suspendido no puedes jugar, unirte a salas ni chatear. Puedes enviar una apelación para revisión.';

  @override
  String get t20Seconds => '20 segundos por jugada';

  @override
  String get tDrawReplays => 'Un empate repite la ronda';

  @override
  String get tSingleElim =>
      'Eliminación directa: si pierdes una vez, quedas fuera';

  @override
  String get tSingleElimFee =>
      'Eliminación directa. Si pierdes una ronda quedas fuera y no se devuelve la inscripción.';

  @override
  String get tagline => 'El pequeño juego más letal';

  @override
  String get takeTurnsBody =>
      'Tú y tu rival ponéis una marca por turno. Toca una casilla vacía para jugar.';

  @override
  String get takeTurnsCaps => 'POR TURNOS';

  @override
  String get takesFewSeconds => 'Suele tardar unos segundos.';

  @override
  String get tapEmptySquare => 'Toca una casilla vacía';

  @override
  String get tbd => 'Por definir';

  @override
  String get tellUsMin10 => 'Cuéntanos qué pasó (al menos 10 caracteres)';

  @override
  String get termsAccountBody =>
      'Mantén tu acceso seguro. Eres responsable de la actividad de tu cuenta.';

  @override
  String get termsAccountTitle => '2. Tu cuenta';

  @override
  String get termsChangesBody =>
      'Podemos actualizar estos términos. Seguir usando la app implica aceptar los cambios.';

  @override
  String get termsChangesTitle => '5. Cambios';

  @override
  String get termsCoinsBody =>
      'Las monedas son objetos virtuales sin valor monetario y no se pueden cambiar por dinero.';

  @override
  String get termsCoinsTitle => '3. Monedas virtuales';

  @override
  String get termsFairBody =>
      'Nada de trampas, insultos ni acoso. Podemos suspender cuentas que incumplan las normas.';

  @override
  String get termsFairTitle => '4. Juego limpio y chat';

  @override
  String get termsOfService => 'Términos del servicio';

  @override
  String get termsUsingBody => 'Debes seguir estos términos y jugar limpio.';

  @override
  String get termsUsingTitle => '1. Uso de DROTIX';

  @override
  String get theirTurnCaps => 'SU TURNO';

  @override
  String get threeInRowBody =>
      'Alinea tres marcas en fila, columna o diagonal antes que tu rival.';

  @override
  String get threeInRowCaps => 'TRES EN RAYA';

  @override
  String timeDaysAgo(String n) {
    return 'hace $n d';
  }

  @override
  String timeHoursAgo(String n) {
    return 'hace $n h';
  }

  @override
  String get timeJustNow => 'Ahora';

  @override
  String timeMinutesAgo(String n) {
    return 'hace $n min';
  }

  @override
  String get timeSkipped => 'Si se acaba el tiempo, se salta la jugada.';

  @override
  String timesUp(String who) {
    return 'Se acabó el tiempo · $who';
  }

  @override
  String get today => 'Hoy';

  @override
  String get todayCaps => 'HOY';

  @override
  String get top16 => 'Top 16';

  @override
  String get totalCoinsCaps => 'MONEDAS TOTALES';

  @override
  String get tournament => 'Torneo';

  @override
  String get tryAgain => 'Reintentar';

  @override
  String get tryAgainCaps => 'REINTENTAR';

  @override
  String get twoPlayers => 'Dos jugadores, un teléfono';

  @override
  String get txChallengeEntry => 'Entrada de desafío';

  @override
  String get txCoinPurchase => 'Compra de monedas';

  @override
  String txDailyBonus(String time) {
    return 'Bono diario · $time';
  }

  @override
  String get txDailyReward => 'Recompensa diaria';

  @override
  String get txFreeVideo => 'Recompensa por video';

  @override
  String get txMatchWin => 'Victoria';

  @override
  String txPurchasing(String time) {
    return 'Compra de monedas · $time';
  }

  @override
  String txReferral(String time) {
    return 'Código de referido · $time';
  }

  @override
  String txTournament(String time) {
    return 'Torneo · $time';
  }

  @override
  String get txTournamentPrize => 'Premio del torneo';

  @override
  String txWatchingAds(String time) {
    return 'Viendo anuncios · $time';
  }

  @override
  String get txWelcomeBonus => 'Bono de bienvenida';

  @override
  String txWinning(String time) {
    return 'Ganando partidas · $time';
  }

  @override
  String get typeMessage => 'Escribe un mensaje';

  @override
  String get unblockPlayer => 'Desbloquear jugador';

  @override
  String get unblockToAdd => 'Desbloquea a este jugador para añadirlo';

  @override
  String get unblockToChallenge => 'Desbloquea a este jugador para desafiarlo';

  @override
  String unlockFor(String n) {
    return 'Desbloquear · $n monedas';
  }

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String unlockedCount(String n, String total) {
    return '$n de $total desbloqueados';
  }

  @override
  String get unranked => 'Sin clasificar';

  @override
  String get upTo3Images =>
      'Hasta 3 imágenes. Solo nuestro equipo puede verlas.';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get updateFailed => 'Error al actualizar';

  @override
  String get updateOnAppStore => 'Actualizar en App Store';

  @override
  String get updateRequired => 'Actualización obligatoria';

  @override
  String get updatesOnlyMobile =>
      'Las actualizaciones están disponibles en Android e iOS.';

  @override
  String get useChatReport =>
      'Usa Chat → Denunciar durante la partida para denuncias con pruebas.';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get usernameHint => 'Usuario (a-z, 0-9, _)';

  @override
  String get verifyCode => 'Verificar código';

  @override
  String get verifyFailBody =>
      'Puede pasar con una conexión débil o si ya reclamaste la recompensa. Tus monedas están a salvo.';

  @override
  String get verifying => 'Verificando…';

  @override
  String get verifyingReward => 'Verificando tu recompensa';

  @override
  String versionLabel(String version) {
    return 'Versión $version';
  }

  @override
  String get versionUnsupported =>
      'Esta versión ya no es compatible. Actualiza para seguir jugando.';

  @override
  String get vibration => 'Vibración';

  @override
  String get victory => 'VICTORIA';

  @override
  String get videoLength =>
      'El video dura de 15 a 30 segundos. Míralo hasta el final para recibir tus monedas.';

  @override
  String get videos => 'Videos';

  @override
  String get viewAppealStatus => 'Ver estado de la apelación';

  @override
  String get viewBracket => 'Ver cuadro';

  @override
  String get viewBracketCaps => 'VER CUADRO';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String get waitingCaps => 'ESPERANDO';

  @override
  String waitingForAccept(String name) {
    return 'Esperando a que $name acepte…';
  }

  @override
  String get waitingForFriend => 'Esperando a un amigo...';

  @override
  String get waitingOtherMatches => 'Esperando otras partidas';

  @override
  String get waitingRoundOpen => 'Esperando a que abra la ronda';

  @override
  String get wallet => 'Cartera';

  @override
  String get walletBalance => 'Saldo de la cartera';

  @override
  String get walletCaps => 'CARTERA';

  @override
  String get walletUnavailable => 'Cartera no disponible';

  @override
  String watchAnotherLeft(String n) {
    return 'VER OTRO (QUEDAN $n)';
  }

  @override
  String get watchBracketCaps => 'VER EL CUADRO';

  @override
  String get watchFullVideo =>
      'Mira el video completo para recibir tus monedas extra.';

  @override
  String get watchNowCaps => 'VER AHORA';

  @override
  String get watchShortVideo => 'Mira un video corto';

  @override
  String watchShortVideoToGet(String n) {
    return 'Mira un video corto y gana +$n';
  }

  @override
  String get watchVideo => 'VER VIDEO';

  @override
  String get watchVideoCoins => 'Mira un video y gana 10 monedas';

  @override
  String get weekly => 'Semanal';

  @override
  String get weeklyChest => 'Cofre semanal';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get welcomeBonusCaps => 'BONO DE BIENVENIDA';

  @override
  String welcomeName(String name) {
    return 'Bienvenido, $name';
  }

  @override
  String get whatHappenedCaps => 'QUÉ PASÓ';

  @override
  String get whatHappenedHint =>
      'Cuéntanos qué pasó y por qué denuncias a este jugador';

  @override
  String get whatsNewCaps => 'NOVEDADES';

  @override
  String get whoCanChallenge => 'Quién puede desafiarte';

  @override
  String get whoCanMessage => 'Quién puede enviarte mensajes';

  @override
  String get winRate => 'Tasa de victorias';

  @override
  String get winner => 'GANADOR';

  @override
  String get wins => 'Victorias';

  @override
  String winsThisRound(String name) {
    return '$name gana esta ronda.';
  }

  @override
  String get yesDelete => 'Sí, eliminar';

  @override
  String get yesterday => 'Ayer';

  @override
  String get yesterdayCaps => 'AYER';

  @override
  String get you => 'Tú';

  @override
  String youBeat(String name) {
    return 'Venciste a $name.';
  }

  @override
  String get youFinished => 'Terminaste';

  @override
  String get youLose => 'Perdiste';

  @override
  String youMark(String mark) {
    return 'Tú · $mark';
  }

  @override
  String get youWin => '¡Ganaste!';

  @override
  String get youWinCaps => 'GANASTE';

  @override
  String get youX => 'Tú: X';

  @override
  String yourBalance(String n) {
    return 'Tu saldo: $n monedas';
  }

  @override
  String get yourEmail => 'tu correo';

  @override
  String get yourMatchReadyCaps => 'TU PARTIDA ESTÁ LISTA';

  @override
  String get yourMove => 'Tu turno';

  @override
  String get yourNextMatch => 'Tu próxima partida';

  @override
  String get yourTurnCaps => 'TU TURNO';

  @override
  String get youreInCaps => 'ESTÁS DENTRO';

  @override
  String get youreInViewBracket => 'ESTÁS DENTRO — VER CUADRO';

  @override
  String get youreOffline => 'Estás sin conexión';
}
