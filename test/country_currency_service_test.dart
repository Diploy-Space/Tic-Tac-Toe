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
}
