/// Central country → calling code / currency map.
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

  static const countries = <CountryInfo>[
    CountryInfo(
      iso2: 'BD',
      name: 'Bangladesh',
      callingCode: '+880',
      currencyCode: 'BDT',
      currencySymbol: '৳',
    ),
    CountryInfo(
      iso2: 'IN',
      name: 'India',
      callingCode: '+91',
      currencyCode: 'INR',
      currencySymbol: '₹',
    ),
    CountryInfo(
      iso2: 'US',
      name: 'United States',
      callingCode: '+1',
      currencyCode: 'USD',
      currencySymbol: '\$',
    ),
    CountryInfo(
      iso2: 'GB',
      name: 'United Kingdom',
      callingCode: '+44',
      currencyCode: 'GBP',
      currencySymbol: '£',
    ),
    CountryInfo(
      iso2: 'PK',
      name: 'Pakistan',
      callingCode: '+92',
      currencyCode: 'PKR',
      currencySymbol: 'Rs',
    ),
    CountryInfo(
      iso2: 'AU',
      name: 'Australia',
      callingCode: '+61',
      currencyCode: 'AUD',
      currencySymbol: 'A\$',
    ),
  ];

  static CountryInfo? byIso2(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    final u = iso.toUpperCase();
    for (final c in countries) {
      if (c.iso2 == u) return c;
    }
    return null;
  }

  /// Wallet rows with currency_code COIN display as coins.
  static String formatBalance({
    required int amountMinor,
    required String currencyCode,
  }) {
    if (currencyCode == 'COIN') return '$amountMinor coins';
    for (final c in countries) {
      if (c.currencyCode == currencyCode) {
        return '${c.currencySymbol}$amountMinor';
      }
    }
    return '$amountMinor $currencyCode';
  }
}
