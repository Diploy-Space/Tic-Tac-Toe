import 'package:share_plus/share_plus.dart';

/// Room QR payload helpers. Encodes the same server room code.
class QrCodeService {
  QrCodeService._();

  static const prefix = 'TICTAC_ROOM:';

  /// Payload written into QR (and accepted by scanner).
  static String encodeRoomCode(String code) {
    final c = code.trim().toUpperCase();
    return '$prefix$c';
  }

  /// Extract room code from scanned text (raw code or prefixed payload).
  static String? parseRoomCode(String raw) {
    var t = raw.trim();
    if (t.isEmpty) return null;
    final uri = Uri.tryParse(t);
    if (uri != null && uri.hasQuery) {
      final q = uri.queryParameters['code'] ?? uri.queryParameters['room'];
      if (q != null && q.trim().isNotEmpty) {
        return q.trim().toUpperCase();
      }
    }
    if (t.toUpperCase().startsWith(prefix)) {
      t = t.substring(prefix.length);
    }
    t = t.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (t.length < 4 || t.length > 12) return null;
    return t;
  }

  static Future<void> shareRoomCode(String code) {
    final c = code.trim().toUpperCase();
    return SharePlus.instance.share(
      ShareParams(
        text: 'Join my Tic Tac Toe private room.\nCode: $c\n${encodeRoomCode(c)}',
        subject: 'Tic Tac Toe room $c',
      ),
    );
  }
}
