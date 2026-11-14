/// Central country → calling code / currency map + INR-based conversion.
class CountryInfo {
  final String iso2;
  final String name;
  final String callingCode;
  final String currencyCode;
  final String currencySymbol;

  const CountryInfo({
    required this.iso2,
    required this.name,
    required this.callingCode,
    required this.currencyCode,
    required this.currencySymbol,
  });
}

class CountryCurrencyService {
  CountryCurrencyService._();

  /// Approx units of [currencyCode] per 1 INR (shop packs authored in INR).
  /// Update periodically; used only for client display conversion.
  static const Map<String, double> inrToCurrency = {
    'INR': 1.0,
    'USD': 0.012,
    'EUR': 0.011,
    'GBP': 0.0095,
    'BDT': 1.40,
    'PKR': 3.35,
    'AUD': 0.018,
    'CAD': 0.016,
    'AED': 0.044,
    'SAR': 0.045,
    'SGD': 0.016,
    'MYR': 0.056,
    'JPY': 1.80,
    'CNY': 0.086,
    'KRW': 16.0,
    'BRL': 0.066,
    'MXN': 0.22,
    'RUB': 1.10,
    'TRY': 0.39,
    'ZAR': 0.22,
    'NGN': 18.0,
    'PHP': 0.68,
    'THB': 0.43,
    'IDR': 190.0,
    'VND': 300.0,
    'NPR': 1.60,
    'LKR': 3.60,
    'CHF': 0.010,
    'NZD': 0.020,
    'SEK': 0.13,
    'NOK': 0.13,
    'DKK': 0.082,
    'PLN': 0.048,
    'CZK': 0.28,
    'HUF': 4.4,
    'ILS': 0.044,
    'EGP': 0.58,
    'KES': 1.55,
    'GHS': 0.18,
  };

  static const countries = <CountryInfo>[
    CountryInfo(
        iso2: 'IN',
        name: 'India',
        callingCode: '+91',
        currencyCode: 'INR',
        currencySymbol: '₹'),
    CountryInfo(
        iso2: 'US',
        name: 'United States',
        callingCode: '+1',
        currencyCode: 'USD',
        currencySymbol: '\$'),
    CountryInfo(
        iso2: 'BD',
        name: 'Bangladesh',
        callingCode: '+880',
        currencyCode: 'BDT',
        currencySymbol: '৳'),
    CountryInfo(
        iso2: 'GB',
        name: 'United Kingdom',
        callingCode: '+44',
        currencyCode: 'GBP',
        currencySymbol: '£'),
    CountryInfo(
        iso2: 'PK',
        name: 'Pakistan',
        callingCode: '+92',
        currencyCode: 'PKR',
        currencySymbol: 'Rs'),
    CountryInfo(
        iso2: 'AU',
        name: 'Australia',
        callingCode: '+61',
        currencyCode: 'AUD',
        currencySymbol: 'A\$'),
    CountryInfo(
        iso2: 'CA',
        name: 'Canada',
        callingCode: '+1',
        currencyCode: 'CAD',
        currencySymbol: 'C\$'),
    CountryInfo(
        iso2: 'AE',
        name: 'United Arab Emirates',
        callingCode: '+971',
        currencyCode: 'AED',
        currencySymbol: 'د.إ'),
    CountryInfo(
        iso2: 'SA',
        name: 'Saudi Arabia',
        callingCode: '+966',
        currencyCode: 'SAR',
        currencySymbol: '﷼'),
    CountryInfo(
        iso2: 'SG',
        name: 'Singapore',
        callingCode: '+65',
        currencyCode: 'SGD',
        currencySymbol: 'S\$'),
    CountryInfo(
        iso2: 'MY',
        name: 'Malaysia',
        callingCode: '+60',
        currencyCode: 'MYR',
        currencySymbol: 'RM'),
    CountryInfo(
        iso2: 'JP',
        name: 'Japan',
        callingCode: '+81',
        currencyCode: 'JPY',
        currencySymbol: '¥'),
    CountryInfo(
        iso2: 'CN',
        name: 'China',
        callingCode: '+86',
        currencyCode: 'CNY',
        currencySymbol: '¥'),
    CountryInfo(
        iso2: 'KR',
        name: 'South Korea',
        callingCode: '+82',
        currencyCode: 'KRW',
        currencySymbol: '₩'),
    CountryInfo(
        iso2: 'BR',
        name: 'Brazil',
        callingCode: '+55',
        currencyCode: 'BRL',
        currencySymbol: 'R\$'),
    CountryInfo(
        iso2: 'MX',
        name: 'Mexico',
        callingCode: '+52',
        currencyCode: 'MXN',
        currencySymbol: 'MX\$'),
    CountryInfo(
        iso2: 'RU',
        name: 'Russia',
        callingCode: '+7',
        currencyCode: 'RUB',
        currencySymbol: '₽'),
    CountryInfo(
        iso2: 'TR',
        name: 'Türkiye',
        callingCode: '+90',
        currencyCode: 'TRY',
        currencySymbol: '₺'),
    CountryInfo(
        iso2: 'DE',
        name: 'Germany',
        callingCode: '+49',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'FR',
        name: 'France',
        callingCode: '+33',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'ES',
        name: 'Spain',
        callingCode: '+34',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'IT',
        name: 'Italy',
        callingCode: '+39',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'PT',
        name: 'Portugal',
        callingCode: '+351',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'NL',
        name: 'Netherlands',
        callingCode: '+31',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'IE',
        name: 'Ireland',
        callingCode: '+353',
        currencyCode: 'EUR',
        currencySymbol: '€'),
    CountryInfo(
        iso2: 'NP',
        name: 'Nepal',
        callingCode: '+977',
        currencyCode: 'NPR',
        currencySymbol: 'रू'),
    CountryInfo(
        iso2: 'LK',
        name: 'Sri Lanka',
        callingCode: '+94',
        currencyCode: 'LKR',
        currencySymbol: 'Rs'),
    CountryInfo(
        iso2: 'NG',
        name: 'Nigeria',
        callingCode: '+234',
        currencyCode: 'NGN',
        currencySymbol: '₦'),
    CountryInfo(
        iso2: 'ZA',
        name: 'South Africa',
        callingCode: '+27',
        currencyCode: 'ZAR',
        currencySymbol: 'R'),
    CountryInfo(
        iso2: 'PH',
        name: 'Philippines',
        callingCode: '+63',
        currencyCode: 'PHP',
        currencySymbol: '₱'),
    CountryInfo(
        iso2: 'TH',
        name: 'Thailand',
        callingCode: '+66',
        currencyCode: 'THB',
        currencySymbol: '฿'),
    CountryInfo(
        iso2: 'ID',
        name: 'Indonesia',
        callingCode: '+62',
        currencyCode: 'IDR',
        currencySymbol: 'Rp'),
    CountryInfo(
        iso2: 'VN',
        name: 'Vietnam',
        callingCode: '+84',
        currencyCode: 'VND',
        currencySymbol: '₫'),
    CountryInfo(
        iso2: 'EG',
        name: 'Egypt',
        callingCode: '+20',
        currencyCode: 'EGP',
        currencySymbol: 'E£'),
    CountryInfo(
        iso2: 'NZ',
        name: 'New Zealand',
        callingCode: '+64',
        currencyCode: 'NZD',
        currencySymbol: 'NZ\$'),
    CountryInfo(
        iso2: 'CH',
        name: 'Switzerland',
        callingCode: '+41',
        currencyCode: 'CHF',
        currencySymbol: 'CHF'),
    CountryInfo(
        iso2: 'SE',
        name: 'Sweden',
        callingCode: '+46',
        currencyCode: 'SEK',
        currencySymbol: 'kr'),
    CountryInfo(
        iso2: 'NO',
        name: 'Norway',
        callingCode: '+47',
        currencyCode: 'NOK',
        currencySymbol: 'kr'),
    CountryInfo(
        iso2: 'DK',
        name: 'Denmark',
        callingCode: '+45',
        currencyCode: 'DKK',
        currencySymbol: 'kr'),
    CountryInfo(
        iso2: 'PL',
        name: 'Poland',
        callingCode: '+48',
        currencyCode: 'PLN',
        currencySymbol: 'zł'),
    CountryInfo(
        iso2: 'IL',
        name: 'Israel',
        callingCode: '+972',
        currencyCode: 'ILS',
        currencySymbol: '₪'),
    CountryInfo(
        iso2: 'KE',
        name: 'Kenya',
        callingCode: '+254',
        currencyCode: 'KES',
        currencySymbol: 'KSh'),
    CountryInfo(
        iso2: 'GH',
        name: 'Ghana',
        callingCode: '+233',
        currencyCode: 'GHS',
        currencySymbol: 'GH₵'),
  ];

  /// Primary market for this app (shop packs authored in INR).
  static const fallback = CountryInfo(
    iso2: 'IN',
    name: 'India',
    callingCode: '+91',
    currencyCode: 'INR',
    currencySymbol: '₹',
  );

  static CountryInfo? byIso2(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    final u = iso.toUpperCase();
    for (final c in countries) {
      if (c.iso2 == u) return c;
    }
    return null;
  }

  static CountryInfo byCurrencyCode(String code) {
    final u = code.toUpperCase();
    for (final c in countries) {
      if (c.currencyCode == u) return c;
    }
    return fallback;
  }

  static double convertFromInr(double inrAmount, String currencyCode) {
    final rate = inrToCurrency[currencyCode.toUpperCase()] ??
        inrToCurrency['USD']!;
    return inrAmount * rate;
  }

  /// Smart rounding for shop display (whole for JPY/KRW/VND/IDR, else 2dp).
  static String formatMoney(
    double amount, {
    required String currencyCode,
    required String symbol,
    int? decimals,
  }) {
    final code = currencyCode.toUpperCase();
    final zeroDecimal = const {
      'JPY',
      'KRW',
      'VND',
      'IDR',
      'CLP',
      'ISK',
    }.contains(code);
    final d = decimals ?? (zeroDecimal ? 0 : 2);
    final rounded = double.parse(amount.toStringAsFixed(d));
    // Prefer whole numbers when clean (e.g. 0.99 stays, 2.00 → 2).
    final text = d == 0
        ? rounded.round().toString()
        : (rounded == rounded.roundToDouble()
            ? rounded.round().toString()
            : rounded.toStringAsFixed(d));
    return '$symbol$text';
  }

  /// Wallet rows with currency_code COIN display as coins.
  static String formatBalance({
    required int amountMinor,
    required String currencyCode,
  }) {
    if (currencyCode == 'COIN') return '$amountMinor coins';
    final info = byCurrencyCode(currencyCode);
    return formatMoney(
      amountMinor.toDouble(),
      currencyCode: info.currencyCode,
      symbol: info.currencySymbol,
      decimals: 0,
    );
  }
}
