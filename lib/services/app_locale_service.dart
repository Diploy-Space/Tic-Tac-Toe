import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
  static final ValueNotifier<String> languageCode = ValueNotifier<String>('en');
  static final ValueNotifier<CountryInfo> country =
      ValueNotifier<CountryInfo>(CountryCurrencyService.fallback);
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static bool get isIndia => country.value.iso2 == 'IN';

  static List<AppLanguage> get availableLanguages =>
      isIndia ? indiaLanguages : internationalLanguages;

  static AppLanguage get currentLanguage {
    final list = availableLanguages;
    for (final l in list) {
      if (l.code == languageCode.value) return l;
    }
    return list.firstWhere((l) => l.code == 'en', orElse: () => list.first);
  }

  static String get currencyCode => country.value.currencyCode;
  static String get currencySymbol => country.value.currencySymbol;

  /// Formats a virtual coin count with the region's currency symbol.
  static String formatCoinAmount(int amount) => amount < 0
      ? '-$currencySymbol${amount.abs()}'
      : '$currencySymbol$amount';

  static const _region = MethodChannel('drotix/region');

  /// Detects the country on every app start (never chosen by the user),
  /// then restores the saved language or picks one from the device.
  static Future<void> init() async {
    final savedIso = AppStorage.getString(_kCountryIso);
    final detected = await detectCountry(savedIso: savedIso);
    country.value = detected;
    await AppStorage.setString(_kCountryIso, detected.iso2);

    final savedCode = AppStorage.getString(_kLangCode) ??
        _migrateLegacyLanguageName(language.value);
    final code =
        savedCode != null && availableLanguages.any((l) => l.code == savedCode)
            ? savedCode
            : _deviceLanguageCode();
    await setLanguageCode(code, persist: true, bump: false);
    _syncLegacyLanguageNotifier();
    _bump();
    // SIM swap / travel: check again whenever the app comes back.
    _lifecycle ??= AppLifecycleListener(onResume: () => redetect());
  }

  static AppLifecycleListener? _lifecycle;

  /// First device language that this region offers, else English.
  static String _deviceLanguageCode() {
    for (final l in PlatformDispatcher.instance.locales) {
      if (availableLanguages.any((a) => a.code == l.languageCode)) {
        return l.languageCode;
      }
    }
    return 'en';
  }

  /// SIM → mobile network → device region(s) → Indic language → time zone
  /// → last detected → India.
  static Future<CountryInfo> detectCountry({String? savedIso}) async {
    for (final iso in await _nativeCountries()) {
      return CountryCurrencyService.forDetectedIso2(iso);
    }
    for (final l in PlatformDispatcher.instance.locales) {
      final c = l.countryCode?.trim().toUpperCase();
      if (c != null && c.length == 2) {
        return CountryCurrencyService.forDetectedIso2(c);
      }
    }
    final guess = _guessFromLanguageAndZone();
    if (guess != null) return guess;
    if (savedIso != null && savedIso.length == 2) {
      return CountryCurrencyService.forDetectedIso2(savedIso);
    }
    return CountryCurrencyService.fallback;
  }

  /// Android: SIM, network and device country (non-null, in that order).
  static Future<List<String>> _nativeCountries() async {
    if (kIsWeb || !Platform.isAndroid) return const [];
    try {
      final m = await _region.invokeMapMethod<String, String?>('countries');
      return [
        for (final k in const ['sim', 'network', 'device'])
          if ((m?[k] ?? '').length == 2) m![k]!,
      ];
    } catch (e) {
      debugPrint('Region detect: $e');
      return const [];
    }
  }

  /// Internal: switch region (detection only, never from the UI).
  static Future<void> _applyCountry(CountryInfo info) async {
    if (country.value.iso2 == info.iso2) return;
    country.value = info;
    await AppStorage.setString(_kCountryIso, info.iso2);

    // If current language is not offered in the new region, fall back.
    if (!availableLanguages.any((l) => l.code == languageCode.value)) {
      await setLanguageCode(_deviceLanguageCode(), persist: true, bump: false);
    }
    _syncLegacyLanguageNotifier();
    _bump();
  }

  /// Re-runs detection (e.g. app resumed after travelling / SIM change).
  static Future<void> redetect() async {
    final info = await detectCountry(savedIso: country.value.iso2);
    await _applyCountry(info);
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

  static CountryInfo? _guessFromLanguageAndZone() {
    final loc = PlatformDispatcher.instance.locale;
    // Indic UI language without a country → India.
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
      return CountryCurrencyService.byIso2('IN');
    }
    final tz = DateTime.now().timeZoneName.toUpperCase();
    final offset = DateTime.now().timeZoneOffset;
    if (tz == 'IST' ||
        tz.contains('KOLKATA') ||
        tz.contains('CALCUTTA') ||
        offset == const Duration(hours: 5, minutes: 30)) {
      return CountryCurrencyService.byIso2('IN');
    }
    if (tz.contains('DHAKA')) return CountryCurrencyService.byIso2('BD');
    return null;
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
    final local = country.value;
    // No exchange rate for this currency → show US dollars instead.
    final c =
        CountryCurrencyService.inrToCurrency.containsKey(local.currencyCode)
            ? local
            : CountryCurrencyService.byIso2('US')!;
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
    final lowest =
        shopPacksInr.map((e) => e.inr).reduce((a, b) => a < b ? a : b);
    return formatShopPackPriceInr(lowest);
  }
}
