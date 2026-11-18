import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/services/country_currency_service.dart';

void main() {
  test('country calling codes', () {
    expect(CountryCurrencyService.byIso2('BD')?.callingCode, '+880');
    expect(CountryCurrencyService.byIso2('IN')?.currencySymbol, '₹');
    expect(
      CountryCurrencyService.formatBalance(
          amountMinor: 100, currencyCode: 'COIN'),
      '100 coins',
    );
  });

  test('detected country → currency (IN = INR, US = USD, unknown = USD)', () {
    expect(CountryCurrencyService.forDetectedIso2('in').currencyCode, 'INR');
    expect(CountryCurrencyService.forDetectedIso2('IN').currencySymbol, '₹');
    expect(CountryCurrencyService.forDetectedIso2('US').currencyCode, 'USD');
    expect(CountryCurrencyService.forDetectedIso2('JP').currencyCode, 'JPY');
    final unknown = CountryCurrencyService.forDetectedIso2('ZZ');
    expect(unknown.iso2, 'ZZ');
    expect(unknown.currencyCode, 'USD');
    expect(unknown.callingCode, isEmpty);
  });

  test('every mapped currency has an INR rate', () {
    for (final c in CountryCurrencyService.countries) {
      expect(CountryCurrencyService.inrToCurrency.containsKey(c.currencyCode),
          isTrue,
          reason: '${c.iso2} ${c.currencyCode}');
    }
  });
}
