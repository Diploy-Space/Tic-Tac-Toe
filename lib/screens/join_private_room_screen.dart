import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/multiplayer_match.dart';
import '../services/auth_service.dart';
import '../services/private_room_service.dart';
import '../services/qr_code_service.dart';
import '../services/sfx_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Join via camera QR and/or 6-character room code (design: JOIN ROOM).
class JoinPrivateRoomScreen extends StatefulWidget {
  const JoinPrivateRoomScreen({super.key});
  @override
  State<JoinPrivateRoomScreen> createState() => _JoinPrivateRoomScreenState();
}

class _JoinPrivateRoomScreenState extends State<JoinPrivateRoomScreen>
    with SingleTickerProviderStateMixin {
  static const _len = 6;

  final _chars = List<String>.filled(_len, '');
  final _focus = List<FocusNode>.generate(_len, (_) => FocusNode());
  final _inputs =
      List<TextEditingController>.generate(_len, (_) => TextEditingController());

  late final MobileScannerController _camera;
  late final AnimationController _scanAnim;

  bool _busy = false;
  bool _torch = false;
  bool _denied = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _camera = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    for (var i = 0; i < _len; i++) {
      _focus[i].addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    _camera.dispose();
    for (final f in _focus) {
      f.dispose();
    }
    for (final c in _inputs) {
      c.dispose();
    }
    super.dispose();
  }

  String get _code => _chars.join().toUpperCase();

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _setCodeDigits(String raw) {
    final cleaned =
        raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    for (var i = 0; i < _len; i++) {
      _chars[i] = i < cleaned.length ? cleaned[i] : '';
      _inputs[i].text = _chars[i];
    }
    setState(() {});
    final next = cleaned.length.clamp(0, _len - 1);
    if (cleaned.length < _len) {
      _focus[next].requestFocus();
    } else {
      _focus[_len - 1].unfocus();
    }
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final raw = data?.text ?? '';
    final parsed = QrCodeService.parseRoomCode(raw) ??
        raw.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (parsed.isEmpty) {
      _toast('Clipboard has no room code');
      return;
    }
    _setCodeDigits(parsed);
  }

  Future<void> _toggleFlash() async {
    try {
      await _camera.toggleTorch();
      setState(() => _torch = !_torch);
    } catch (_) {
      _toast('Flash not available');
    }
  }

  Future<void> _fromPhoto() async {
    if (_busy) return;
    try {
      final file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final result = await _camera.analyzeImage(file.path);
      if (!mounted) return;
      if (result == null || result.barcodes.isEmpty) {
        _toast('No QR found in photo');
        return;
      }
      String? raw;
      for (final b in result.barcodes) {
        if (b.rawValue != null && b.rawValue!.trim().isNotEmpty) {
          raw = b.rawValue;
          break;
        }
      }
      final code = raw == null ? null : QrCodeService.parseRoomCode(raw);
      if (code == null) {
        _toast('Invalid room QR');
        return;
      }
      _setCodeDigits(code);
      await _join(code);
    } catch (e) {
      if (!mounted) return;
      _toast(AuthService.messageFromError(e));
    }
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
    _setCodeDigits(code);
    await _join(code);
  }

  Future<void> _join([String? override]) async {
    final code = (override ?? _code).trim().toUpperCase();
    if (code.length < 4) {
      _toast('Enter the full room code');
      return;
    }
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _camera.stop();
    } catch (_) {}
    try {
      final res = await PrivateRoomService.join(code);
      if (!mounted) return;
      if (!res.isMatched || res.roomId == null) {
        _toast(res.message ?? 'Could not join room');
        setState(() => _busy = false);
        try {
          await _camera.start();
        } catch (_) {}
        return;
      }
      SfxService.play(Sfx.matchFound);
      Navigator.pushReplacementNamed(
        context,
        '/online-room',
        arguments: OnlineRoomArgs.fromMatch(res),
      );
    } catch (e) {
      if (!mounted) return;
      _toast(AuthService.messageFromError(e));
      setState(() => _busy = false);
      try {
        await _camera.start();
      } catch (_) {}
    }
  }

  Widget _codeBox(int i) {
    final focused = _focus[i].hasFocus;
    return Expanded(
      child: Container(
        height: 52,
        margin: EdgeInsets.only(right: i == _len - 1 ? 0 : 8),
        decoration: BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: focused ? C.magenta : C.border2,
            width: focused ? 1.8 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: _inputs[i],
          focusNode: _focus[i],
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: C.teal,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
          keyboardType: TextInputType.visiblePassword,
          textCapitalization: TextCapitalization.characters,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            _UpperCaseFormatter(),
          ],
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (v) {
            if (v.length > 1) {
              _setCodeDigits(_code.substring(0, i) + v);
              return;
            }
            _chars[i] = v.toUpperCase();
            setState(() {});
            if (v.isNotEmpty && i < _len - 1) {
              _focus[i + 1].requestFocus();
            }
            if (v.isEmpty && i > 0) {
              _focus[i - 1].requestFocus();
            }
          },
          onTap: () => _inputs[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _inputs[i].text.length,
          ),
        ),
      ),
    );
  }

  Widget _scanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_denied)
              const ColoredBox(
                color: Color(0xFF121218),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Camera permission needed to scan. You can still enter the code below.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: C.muted, height: 1.4),
                    ),
                  ),
                ),
              )
            else
              MobileScanner(
                controller: _camera,
                onDetect: _onDetect,
                errorBuilder: (context, error) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    if (error.errorCode ==
                            MobileScannerErrorCode.permissionDenied &&
                        !_denied) {
                      setState(() => _denied = true);
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
            IgnorePointer(
              child: CustomPaint(
                painter: _ScanFramePainter(progress: _scanAnim),
                child: const SizedBox.expand(),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                'Point your camera at the room QR code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 8),
                  ],
                ),
              ),
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
    );
  }

  Widget _toolBtn({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: C.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: C.text),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopBar('JOIN ROOM'),
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _scanner(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _toolBtn(
                        icon: _torch
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        label: 'Flash',
                        onTap: _busy || _denied ? null : _toggleFlash,
                      ),
                      const SizedBox(width: 10),
                      _toolBtn(
                        icon: Icons.image_outlined,
                        label: 'From photo',
                        onTap: _busy ? null : _fromPhoto,
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      const Expanded(child: Divider(color: C.border2)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR ENTER THE CODE',
                          style: TextStyle(
                            color: C.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: C.border2)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(children: [for (var i = 0; i < _len; i++) _codeBox(i)]),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: _busy ? null : _paste,
                      child: const Text(
                        'Paste code',
                        style: TextStyle(
                          color: C.teal,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: C.teal,
                        ),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: C.danger),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const Text(
            'The camera is only used to scan the code.',
            textAlign: TextAlign.center,
            style: TextStyle(color: C.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: _busy ? null : () => _join(),
              style: FilledButton.styleFrom(
                backgroundColor: C.magenta,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                _busy ? 'JOINING…' : 'JOIN ROOM',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final Animation<double> progress;
  _ScanFramePainter({required this.progress}) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 28.0;
    const arm = 28.0;
    const stroke = 3.5;
    final r = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final paint = Paint()
      ..color = C.magenta
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void corner(Offset a, Offset b, Offset c) {
      canvas.drawLine(a, b, paint);
      canvas.drawLine(a, c, paint);
    }

    corner(r.topLeft, r.topLeft + const Offset(arm, 0),
        r.topLeft + const Offset(0, arm));
    corner(r.topRight, r.topRight + const Offset(-arm, 0),
        r.topRight + const Offset(0, arm));
    corner(r.bottomLeft, r.bottomLeft + const Offset(arm, 0),
        r.bottomLeft + const Offset(0, -arm));
    corner(r.bottomRight, r.bottomRight + const Offset(-arm, 0),
        r.bottomRight + const Offset(0, -arm));

    final y = r.top + r.height * (0.18 + 0.64 * progress.value);
    final line = Paint()
      ..shader = LinearGradient(
        colors: [
          C.teal.withValues(alpha: 0),
          C.teal,
          C.teal.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(r.left, y - 1, r.width, 2))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(r.left + 8, y), Offset(r.right - 8, y), line);
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) => false;
}
