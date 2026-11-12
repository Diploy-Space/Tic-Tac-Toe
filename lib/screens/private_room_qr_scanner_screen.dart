import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/private_room_service.dart';
import '../services/qr_code_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Scan a private-room QR and join via existing [PrivateRoomService.join].
class PrivateRoomQrScannerScreen extends StatefulWidget {
  const PrivateRoomQrScannerScreen({super.key});

  @override
  State<PrivateRoomQrScannerScreen> createState() =>
      _PrivateRoomQrScannerScreenState();
}

class _PrivateRoomQrScannerScreenState
    extends State<PrivateRoomQrScannerScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _busy = false;
  bool _denied = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy) return;
    String? raw;
    for (final b in capture.barcodes) {
      if (b.rawValue != null && b.rawValue!.trim().isNotEmpty) {
        raw = b.rawValue;
        break;
      }
    }
    if (raw == null) return;
    final code = QrCodeService.parseRoomCode(raw);
    if (code == null) {
      setState(() => _error = 'Invalid room QR');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    await _controller.stop();
    try {
      final res = await PrivateRoomService.join(code);
      if (!mounted) return;
      if (!res.isMatched || res.roomId == null) {
        setState(() {
          _busy = false;
          _error = res.message ?? 'Could not join room';
        });
        await _controller.start();
        return;
      }
      Navigator.pushReplacementNamed(
        context,
        '/online-room',
        arguments: OnlineRoomArgs.fromMatch(res),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = AuthService.messageFromError(e);
      });
      await _controller.start();
    }
  }

  Widget _deniedUi() => AppScaffold(
        child: staggered([
          const TopBar('Scan QR'),
          const AppCard(
            child: Text(
              'Camera permission is required to scan a room QR code. Enable Camera for this app in system settings, then try again.',
              style: TextStyle(color: C.muted, height: 1.4),
            ),
          ),
          GhostButton(
            'Enter code instead',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/join-private-room'),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    if (_denied) return _deniedUi();

    return AppScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TopBar('Scan QR'),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;
                      if (error.errorCode ==
                              MobileScannerErrorCode.permissionDenied &&
                          !_denied) {
                        setState(() => _denied = true);
                      } else if (!_denied) {
                        setState(() => _error = error.errorDetails?.message ??
                            error.errorCode.name);
                      }
                    });
                    return const ColoredBox(
                      color: Colors.black,
                      child: Center(
                        child: Icon(Icons.videocam_off,
                            color: C.muted, size: 48),
                      ),
                    );
                  },
                ),
                if (_busy)
                  Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: C.magenta),
                        SizedBox(height: 12),
                        Text('Joining room…',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_error!,
                        style: const TextStyle(color: C.danger),
                        textAlign: TextAlign.center),
                  ),
                const Text(
                  'Point at the host’s QR. Same code as the lobby.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: C.muted),
                ),
                const SizedBox(height: 10),
                GhostButton(
                  'Enter code instead',
                  onTap: _busy
                      ? null
                      : () => Navigator.pushReplacementNamed(
                          context, '/join-private-room'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
