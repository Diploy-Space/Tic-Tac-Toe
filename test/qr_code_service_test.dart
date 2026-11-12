import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_game/services/qr_code_service.dart';

void main() {
  test('encode and parse room code', () {
    const code = 'AB12CD';
    final payload = QrCodeService.encodeRoomCode(code);
    expect(payload, 'TICTAC_ROOM:AB12CD');
    expect(QrCodeService.parseRoomCode(payload), code);
    expect(QrCodeService.parseRoomCode(code), code);
    expect(QrCodeService.parseRoomCode('ab'), isNull);
    expect(QrCodeService.parseRoomCode('https://x.app/?code=ZZ99YY'), 'ZZ99YY');
  });
}
