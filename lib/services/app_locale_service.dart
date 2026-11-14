import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';
import 'country_currency_service.dart';
import 'storage.dart';

/// One selectable UI language.
class AppLanguage {
  final String code; // BCP-47 language subtag
  final String englishName;
  final String nativeName;
  final Locale locale;

  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.locale,
  });

  String get label => nativeName;
}

/// Country detection, language catalog, locale + money formatting.
class AppLocaleService {
  AppLocaleService._();

  static const _kLangCode = 'languageCode';
  static const _kCountryIso = 'countryIso2';

  /// Shop pack base prices are authored in INR, then converted.
  static const shopPacksInr = <({int coins, String title, int inr})>[
    (coins: 100, title: 'Starter pack', inr: 29),
    (coins: 300, title: 'Popular', inr: 79),
    (coins: 700, title: 'Best value', inr: 149),
  ];

  static const indiaLanguages = <AppLanguage>[
    AppLanguage(
        code: 'hi',
        englishName: 'Hindi',
        nativeName: 'हिन्दी',
        locale: Locale('hi', 'IN')),
    AppLanguage(
        code: 'en',
        englishName: 'English',
        nativeName: 'English',
        locale: Locale('en', 'IN')),
    AppLanguage(
        code: 'bn',
        englishName: 'Bengali',
        nativeName: 'বাংলা',
        locale: Locale('bn', 'IN')),
    AppLanguage(
        code: 'or',
        englishName: 'Odia',
        nativeName: 'ଓଡ଼ିଆ',
        locale: Locale('or', 'IN')),
    AppLanguage(
        code: 'ta',
        englishName: 'Tamil',
        nativeName: 'தமிழ்',
        locale: Locale('ta', 'IN')),
    AppLanguage(
        code: 'te',
        englishName: 'Telugu',
        nativeName: 'తెలుగు',
        locale: Locale('te', 'IN')),
    AppLanguage(
        code: 'gu',
        englishName: 'Gujarati',
        nativeName: 'ગુજરાતી',
        locale: Locale('gu', 'IN')),
    AppLanguage(
        code: 'mr',
        englishName: 'Marathi',
        nativeName: 'मराठी',
        locale: Locale('mr', 'IN')),
    AppLanguage(
        code: 'kn',
        englishName: 'Kannada',
        nativeName: 'ಕನ್ನಡ',
        locale: Locale('kn', 'IN')),
    AppLanguage(
        code: 'ml',
        englishName: 'Malayalam',
        nativeName: 'മലയാളം',
        locale: Locale('ml', 'IN')),
    AppLanguage(
        code: 'pa',
        englishName: 'Punjabi',
        nativeName: 'ਪੰਜਾਬੀ',
        locale: Locale('pa', 'IN')),
    AppLanguage(
        code: 'ur',
        englishName: 'Urdu',
        nativeName: 'اردو',
        locale: Locale('ur', 'IN')),
  ];

  static const internationalLanguages = <AppLanguage>[
    AppLanguage(
        code: 'en',
        englishName: 'English',
        nativeName: 'English',
        locale: Locale('en')),
    AppLanguage(
        code: 'es',
        englishName: 'Spanish',
        nativeName: 'Español',
        locale: Locale('es')),
    AppLanguage(
        code: 'fr',
        englishName: 'French',
        nativeName: 'Français',
        locale: Locale('fr')),
    AppLanguage(
        code: 'de',
        englishName: 'German',
        nativeName: 'Deutsch',
        locale: Locale('de')),
    AppLanguage(
        code: 'ar',
        englishName: 'Arabic',
        nativeName: 'العربية',
        locale: Locale('ar')),
    AppLanguage(
        code: 'pt',
        englishName: 'Portuguese',
        nativeName: 'Português',
        locale: Locale('pt')),
    AppLanguage(
        code: 'zh',
        englishName: 'Chinese',
        nativeName: '中文',
        locale: Locale('zh')),
    AppLanguage(
        code: 'ja',
        englishName: 'Japanese',
        nativeName: '日本語',
        locale: Locale('ja')),
    AppLanguage(
        code: 'ko',
        englishName: 'Korean',
        nativeName: '한국어',
        locale: Locale('ko')),
    AppLanguage(
        code: 'ru',
        englishName: 'Russian',
        nativeName: 'Русский',
        locale: Locale('ru')),
    AppLanguage(
        code: 'it',
        englishName: 'Italian',
        nativeName: 'Italiano',
        locale: Locale('it')),
  ];

  static final ValueNotifier<Locale> locale =
      ValueNotifier<Locale>(const Locale('en'));
  static final ValueNotifier<String> languageCode =
      ValueNotifier<String>('en');
  static final ValueNotifier<CountryInfo> country =
      ValueNotifier<CountryInfo>(CountryCurrencyService.fallback);
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static bool get isIndia => country.value.iso2 == 'IN';

  static List<AppLanguage> get availableLanguages =>
      isIndia ? indiaLanguages : internationalLanguages;

  static List<Locale> get supportedLocales {
    final all = <Locale>[
      ...indiaLanguages.map((e) => e.locale),
      ...internationalLanguages.map((e) => e.locale),
    ];
    // Deduplicate by language(+country) string.
    final seen = <String>{};
    return [
      for (final l in all)
        if (seen.add('${l.languageCode}_${l.countryCode ?? ''}')) l,
    ];
  }

  static AppLanguage get currentLanguage {
    final list = availableLanguages;
    for (final l in list) {
      if (l.code == languageCode.value) return l;
    }
    return list.firstWhere((l) => l.code == 'en', orElse: () => list.first);
  }

  static String get currencyCode => country.value.currencyCode;
  static String get currencySymbol => country.value.currencySymbol;

  /// Locales Material/Cupertino widgets reliably support.
  static const _materialSafe = {
    'en',
    'es',
    'fr',
    'de',
    'ar',
    'pt',
    'zh',
    'ja',
    'ko',
    'ru',
    'it',
    'hi',
    'bn',
  };

  /// Use for MaterialApp.locale (falls back to en when unsupported).
  static Locale get materialSafeLocale {
    final l = locale.value;
    if (_materialSafe.contains(l.languageCode)) return l;
    return Locale('en', country.value.iso2);
  }

  static Future<void> init() async {
    final detected = _detectDeviceCountry();
    final savedIso = AppStorage.getString(_kCountryIso);
    final fromSaved = CountryCurrencyService.byIso2(savedIso);

    // Earlier builds defaulted unknowns to US. If saved US but device is not
    // actually US, prefer the fresh detection (usually India primary market).
    CountryInfo chosen;
    if (fromSaved != null) {
      if (fromSaved.iso2 == 'US' && detected.iso2 != 'US') {
        chosen = detected;
      } else {
        chosen = fromSaved;
      }
    } else {
      chosen = detected;
    }
    country.value = chosen;
    await AppStorage.setString(_kCountryIso, chosen.iso2);

    final savedCode = AppStorage.getString(_kLangCode);
    final migrated = _migrateLegacyLanguageName(language.value);
    final code = savedCode ?? migrated ?? 'en';
    await setLanguageCode(code, persist: true, bump: false);
    _syncLegacyLanguageNotifier();
    _bump();
  }

  /// Prefer profile country when the user has one (phone / signup).
  static Future<void> applyCountryIso2(String? iso2, {bool persist = true}) async {
    final info = CountryCurrencyService.byIso2(iso2);
    if (info == null) return;
    if (country.value.iso2 == info.iso2) return;
    country.value = info;
    if (persist) await AppStorage.setString(_kCountryIso, info.iso2);

    // If current language is not offered in the new region, fall back to English.
    final stillOk =
        availableLanguages.any((l) => l.code == languageCode.value);
    if (!stillOk) {
      await setLanguageCode('en', persist: true, bump: false);
    }
    _syncLegacyLanguageNotifier();
    _bump();
  }

  static Future<void> setLanguageCode(
    String code, {
    bool persist = true,
    bool bump = true,
  }) async {
    AppLanguage? match;
    for (final l in availableLanguages) {
      if (l.code == code) {
        match = l;
        break;
      }
    }
    match ??= availableLanguages.firstWhere(
      (l) => l.code == 'en',
      orElse: () => availableLanguages.first,
    );

    languageCode.value = match.code;
    locale.value = match.locale;
    if (persist) await AppStorage.setString(_kLangCode, match.code);
    _syncLegacyLanguageNotifier();
    if (bump) _bump();
  }

  static void _syncLegacyLanguageNotifier() {
    language.value = currentLanguage.nativeName;
  }

  static void _bump() => revision.value = revision.value + 1;

  static CountryInfo _detectDeviceCountry() {
    final loc = PlatformDispatcher.instance.locale;
    final code = loc.countryCode?.trim().toUpperCase();
    if (code != null && code.isNotEmpty) {
      final hit = CountryCurrencyService.byIso2(code);
      if (hit != null) return hit;
    }

    // Indic UI language without a country → India language catalog + INR.
    const indic = {
      'hi',
      'bn',
      'or',
      'ta',
      'te',
      'gu',
      'mr',
      'kn',
      'ml',
      'pa',
      'as',
      'ur',
    };
    if (indic.contains(loc.languageCode)) {
      return CountryCurrencyService.byIso2('IN')!;
    }

    final tz = DateTime.now().timeZoneName.toUpperCase();
    final offset = DateTime.now().timeZoneOffset;
    if (tz == 'IST' ||
        tz.contains('KOLKATA') ||
        tz.contains('CALCUTTA') ||
        offset == const Duration(hours: 5, minutes: 30)) {
      return CountryCurrencyService.byIso2('IN')!;
    }
    if (tz.contains('DHAKA') || offset == const Duration(hours: 6)) {
      return CountryCurrencyService.byIso2('BD') ??
          CountryCurrencyService.fallback;
    }

    // App primary market when device country is unknown.
    return CountryCurrencyService.fallback;
  }

  static String? _migrateLegacyLanguageName(String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return null;
    for (final l in [...indiaLanguages, ...internationalLanguages]) {
      if (l.nativeName.toLowerCase() == n ||
          l.englishName.toLowerCase() == n ||
          l.code == n) {
        return l.code;
      }
    }
    // Old hardcoded list leftovers.
    const legacy = {
      'english': 'en',
      'हिन्दी': 'hi',
      'türkçe': 'en', // dropped; map to English
      'العربية': 'ar',
      'español': 'es',
      'português': 'pt',
      'français': 'fr',
      'bahasa indonesia': 'en',
    };
    return legacy[n];
  }

  /// Convert an INR-authored amount into the user's currency and format it.
  static String formatMoneyFromInr(num inrAmount, {int? decimals}) {
    final c = country.value;
    final converted = CountryCurrencyService.convertFromInr(
      inrAmount.toDouble(),
      c.currencyCode,
    );
    return CountryCurrencyService.formatMoney(
      converted,
      currencyCode: c.currencyCode,
      symbol: c.currencySymbol,
      decimals: decimals,
    );
  }

  static String formatShopPackPriceInr(int inr) => formatMoneyFromInr(inr);

  static String lowestShopPackLabel() {
    final lowest = shopPacksInr
        .map((e) => e.inr)
        .reduce((a, b) => a < b ? a : b);
    return formatShopPackPriceInr(lowest);
  }
}
