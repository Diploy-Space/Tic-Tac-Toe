import 'package:flutter/widgets.dart';

import '../services/app_locale_service.dart';

/// Lightweight string table. Missing keys fall back to English.
class AppLocalizations {
  AppLocalizations(this.languageCode);

  final String languageCode;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(AppLocaleService.languageCode.value);
  }

  static const _en = <String, String>{
    'settings': 'Settings',
    'language': 'Language',
    'notifications': 'Notifications',
    'challenges': 'Challenges',
    'challenge_privacy': 'Challenge privacy',
    'chat_rules': 'Chat rules',
    'contact_about': 'Contact & about',
    'privacy_terms': 'Privacy & terms',
    'rate_app': 'Rate the app',
    'delete_account': 'Delete account',
    'sound_effects': 'Sound effects',
    'music': 'Music',
    'vibration': 'Vibration',
    'shop': 'Shop',
    'coin_packs': 'Coin packs',
    'free_coins': 'FREE COINS',
    'watch_video_coins': 'Watch a video, get 10 coins',
    'watch_video': 'WATCH VIDEO',
    'daily_limit': 'DAILY LIMIT REACHED',
    'free_videos_used': '{used} of 5 free videos used today',
    'starter_pack': 'Starter pack',
    'popular': 'Popular',
    'best_value': 'Best value',
    'coins_label': '{n} coins',
    'pick_your_game': 'Pick your game',
    'play_vs_doll': 'Play vs The Doll',
    'offline_smart': 'Offline, smart opponent',
    'random_match': 'Random match',
    'online_offline_ai': 'Online Players · Offline AI',
    'online_match': 'Online match',
    'find_private_join': 'Find · private room · join code',
    'pass_and_play': 'Pass & Play',
    'two_players': 'Two players, one phone',
    'mode': 'Mode {n}',
    'wallet': 'Wallet',
    'home': 'Play',
    'ranks': 'Ranks',
    'profile': 'Profile',
    'games': 'Games',
    'language_updated': 'Language updated',
    'coin_packs_from': 'COIN PACKS FROM {price}',
    'version': 'Version 1.0.1',
  };

  static const _hi = <String, String>{
    'settings': 'सेटिंग्स',
    'language': 'भाषा',
    'notifications': 'सूचनाएँ',
    'challenges': 'चुनौतियाँ',
    'challenge_privacy': 'चुनौती गोपनीयता',
    'chat_rules': 'चैट नियम',
    'contact_about': 'संपर्क और जानकारी',
    'privacy_terms': 'गोपनीयता और नियम',
    'rate_app': 'ऐप रेट करें',
    'delete_account': 'खाता हटाएँ',
    'sound_effects': 'ध्वनि प्रभाव',
    'music': 'संगीत',
    'vibration': 'कंपन',
    'shop': 'दुकान',
    'coin_packs': 'कॉइन पैक',
    'free_coins': 'मुफ़्त कॉइन',
    'watch_video_coins': 'वीडियो देखें, 10 कॉइन पाएँ',
    'watch_video': 'वीडियो देखें',
    'daily_limit': 'दैनिक सीमा पूरी',
    'free_videos_used': 'आज {used} में से 5 मुफ़्त वीडियो',
    'starter_pack': 'स्टार्टर पैक',
    'popular': 'लोकप्रिय',
    'best_value': 'सबसे बढ़िया',
    'coins_label': '{n} कॉइन',
    'pick_your_game': 'अपना गेम चुनें',
    'play_vs_doll': 'द डॉल के खिलाफ खेलें',
    'offline_smart': 'ऑफ़लाइन, स्मार्ट प्रतिद्वंद्वी',
    'random_match': 'रैंडम मैच',
    'online_offline_ai': 'ऑनलाइन खिलाड़ी · ऑफ़लाइन AI',
    'online_match': 'ऑनलाइन मैच',
    'find_private_join': 'खोजें · प्राइवेट रूम · जॉइन कोड',
    'pass_and_play': 'पास ऐंड प्ले',
    'two_players': 'दो खिलाड़ी, एक फ़ोन',
    'mode': 'मोड {n}',
    'wallet': 'वॉलेट',
    'home': 'खेलें',
    'ranks': 'रैंक',
    'profile': 'प्रोफ़ाइल',
    'games': 'गेम्स',
    'language_updated': 'भाषा अपडेट हुई',
    'coin_packs_from': 'कॉइन पैक {price} से',
    'version': 'संस्करण 1.0.1',
  };

  static const _es = <String, String>{
    'settings': 'Ajustes',
    'language': 'Idioma',
    'notifications': 'Notificaciones',
    'challenges': 'Desafíos',
    'challenge_privacy': 'Privacidad de desafíos',
    'chat_rules': 'Reglas del chat',
    'contact_about': 'Contacto y acerca de',
    'privacy_terms': 'Privacidad y términos',
    'rate_app': 'Valorar la app',
    'delete_account': 'Eliminar cuenta',
    'sound_effects': 'Efectos de sonido',
    'music': 'Música',
    'vibration': 'Vibración',
    'shop': 'Tienda',
    'coin_packs': 'Paquetes de monedas',
    'free_coins': 'MONEDAS GRATIS',
    'watch_video_coins': 'Mira un video y recibe 10 monedas',
    'watch_video': 'VER VIDEO',
    'daily_limit': 'LÍMITE DIARIO ALCANZADO',
    'free_videos_used': '{used} de 5 videos gratis hoy',
    'starter_pack': 'Paquete inicial',
    'popular': 'Popular',
    'best_value': 'Mejor valor',
    'coins_label': '{n} monedas',
    'pick_your_game': 'Elige tu juego',
    'play_vs_doll': 'Jugar contra The Doll',
    'offline_smart': 'Offline, rival inteligente',
    'random_match': 'Partida aleatoria',
    'online_offline_ai': 'Jugadores online · IA offline',
    'online_match': 'Partida online',
    'find_private_join': 'Buscar · sala privada · código',
    'pass_and_play': 'Pasa y juega',
    'two_players': 'Dos jugadores, un teléfono',
    'mode': 'Modo {n}',
    'wallet': 'Cartera',
    'home': 'Jugar',
    'ranks': 'Rangos',
    'profile': 'Perfil',
    'games': 'Juegos',
    'language_updated': 'Idioma actualizado',
    'coin_packs_from': 'PAQUETES DESDE {price}',
    'version': 'Versión 1.0.1',
  };

  static const _fr = <String, String>{
    'settings': 'Paramètres',
    'language': 'Langue',
    'shop': 'Boutique',
    'coin_packs': 'Packs de pièces',
    'pick_your_game': 'Choisissez votre jeu',
    'language_updated': 'Langue mise à jour',
    'coin_packs_from': 'PACKS À PARTIR DE {price}',
    'wallet': 'Portefeuille',
    'delete_account': 'Supprimer le compte',
  };

  static const _ar = <String, String>{
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'shop': 'المتجر',
    'coin_packs': 'باقات العملات',
    'pick_your_game': 'اختر لعبتك',
    'language_updated': 'تم تحديث اللغة',
    'coin_packs_from': 'باقات ابتداءً من {price}',
    'wallet': 'المحفظة',
    'delete_account': 'حذف الحساب',
  };

  static const _de = <String, String>{
    'settings': 'Einstellungen',
    'language': 'Sprache',
    'shop': 'Shop',
    'pick_your_game': 'Spiel wählen',
    'language_updated': 'Sprache aktualisiert',
    'coin_packs_from': 'PAKETE AB {price}',
  };

  static const _pt = <String, String>{
    'settings': 'Configurações',
    'language': 'Idioma',
    'shop': 'Loja',
    'pick_your_game': 'Escolha seu jogo',
    'language_updated': 'Idioma atualizado',
    'coin_packs_from': 'PACOTES A PARTIR DE {price}',
  };

  static const _zh = <String, String>{
    'settings': '设置',
    'language': '语言',
    'shop': '商店',
    'pick_your_game': '选择游戏',
    'language_updated': '语言已更新',
    'coin_packs_from': '币包低至 {price}',
  };

  static const _ja = <String, String>{
    'settings': '設定',
    'language': '言語',
    'shop': 'ショップ',
    'pick_your_game': 'ゲームを選ぶ',
    'language_updated': '言語を更新しました',
    'coin_packs_from': '{price}からのコインパック',
  };

  static const _ko = <String, String>{
    'settings': '설정',
    'language': '언어',
    'shop': '상점',
    'pick_your_game': '게임 선택',
    'language_updated': '언어가 업데이트되었습니다',
    'coin_packs_from': '{price}부터 코인 팩',
  };

  static const _ru = <String, String>{
    'settings': 'Настройки',
    'language': 'Язык',
    'shop': 'Магазин',
    'pick_your_game': 'Выберите игру',
    'language_updated': 'Язык обновлён',
    'coin_packs_from': 'НАБОРЫ ОТ {price}',
  };

  static const _it = <String, String>{
    'settings': 'Impostazioni',
    'language': 'Lingua',
    'shop': 'Negozio',
    'pick_your_game': 'Scegli il gioco',
    'language_updated': 'Lingua aggiornata',
    'coin_packs_from': 'PACCHETTI DA {price}',
  };

  static const _bn = <String, String>{
    'settings': 'সেটিংস',
    'language': 'ভাষা',
    'shop': 'শপ',
    'pick_your_game': 'আপনার গেম বেছে নিন',
    'language_updated': 'ভাষা আপডেট হয়েছে',
    'coin_packs_from': '{price} থেকে কয়েন প্যাক',
  };

  static const Map<String, Map<String, String>> _tables = {
    'en': _en,
    'hi': _hi,
    'es': _es,
    'fr': _fr,
    'ar': _ar,
    'de': _de,
    'pt': _pt,
    'zh': _zh,
    'ja': _ja,
    'ko': _ko,
    'ru': _ru,
    'it': _it,
    'bn': _bn,
    // Indian languages fall back to Hindi where not fully translated.
    'or': _hi,
    'ta': _hi,
    'te': _hi,
    'gu': _hi,
    'mr': _hi,
    'kn': _hi,
    'ml': _hi,
    'pa': _hi,
    'ur': _ar,
  };

  String t(String key, [Map<String, String>? params]) {
    final table = _tables[languageCode] ?? _en;
    var value = table[key] ?? _en[key] ?? key;
    if (params != null) {
      params.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }
    return value;
  }
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      // Prefer the user's selected language even when Material falls back to en.
      AppLocalizations(AppLocaleService.languageCode.value);

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => true;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  String tr(String key, [Map<String, String>? params]) =>
      l10n.t(key, params);
}
