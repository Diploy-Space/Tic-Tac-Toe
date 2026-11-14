import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

enum ShapeKind { circle, triangle, square, bullseye }

Paint _fill(Color c) => Paint()..color = c;
Paint _line(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

class ShapeIcon extends StatelessWidget {
  final ShapeKind kind;
  final double size;
  final Color color;
  final double stroke;
  const ShapeIcon(this.kind,
      {super.key, this.size = 26, this.color = C.magenta, this.stroke = 2});
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
      child: CustomPaint(
          size: Size.square(size), painter: _ShapePainter(kind, color, stroke)));
}

class _ShapePainter extends CustomPainter {
  final ShapeKind kind;
  final Color color;
  final double stroke;
  _ShapePainter(this.kind, this.color, this.stroke);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final p = _line(color, stroke);
    switch (kind) {
      case ShapeKind.circle:
        canvas.drawCircle(const Offset(12, 12), 8, p);
        break;
      case ShapeKind.triangle:
        canvas.drawPath(
            Path()
              ..moveTo(12, 4)
              ..lineTo(21, 20)
              ..lineTo(3, 20)
              ..close(),
            p);
        break;
      case ShapeKind.square:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(4, 4, 16, 16),
            const Radius.circular(3),
          ),
          p,
        );
        break;
      case ShapeKind.bullseye:
        canvas.drawCircle(const Offset(12, 12), 8, p);
        canvas.drawCircle(const Offset(12, 12), 2.8, _fill(color));
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _ShapePainter o) =>
      o.kind != kind || o.color != color || o.stroke != stroke;
}

/// X (magenta) or O (teal) game mark.
///
/// When [skin] is null, follows [equippedMark] (in-game / live equip).
/// Pass an explicit [skin] for catalog previews so each tile shows its own design.
class MarkIcon extends StatelessWidget {
  final bool isX;
  final double size;
  final String? skin;
  const MarkIcon({super.key, required this.isX, this.size = 44, this.skin});

  @override
  Widget build(BuildContext context) {
    if (skin != null) {
      return ExcludeSemantics(
          child: CustomPaint(
              size: Size.square(size),
              painter: _MarkPainter(isX, skin!)));
    }
    return ValueListenableBuilder<String>(
        valueListenable: equippedMark,
        builder: (_, equipped, __) => ExcludeSemantics(
            child: CustomPaint(
                size: Size.square(size),
                painter: _MarkPainter(isX, equipped))));
  }
}

class _MarkPainter extends CustomPainter {
  final bool isX;
  final String skin;
  _MarkPainter(this.isX, this.skin);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final accent = switch (skin) {
      'Neon' => isX ? const Color(0xFFFF2D95) : const Color(0xFF00F0E0),
      'Ghost' => isX ? const Color(0xFFB8B8C8) : const Color(0xFF8AD4D0),
      'Gold' => isX ? const Color(0xFFFFC24D) : const Color(0xFFE8A838),
      'Pixel' => isX ? const Color(0xFFED1B76) : const Color(0xFF2FB8B4),
      'Shapes' => isX ? C.magenta : C.teal,
      _ => isX ? C.magenta : C.teal,
    };
    if (skin == 'Shapes') {
      if (isX) {
        canvas.drawPath(
            Path()
              ..moveTo(12, 4)
              ..lineTo(20, 20)
              ..lineTo(4, 20)
              ..close(),
            _line(accent, 2.6));
      } else {
        canvas.drawRect(const Rect.fromLTWH(5, 5, 14, 14), _line(accent, 2.6));
      }
      return;
    }
    if (skin == 'Pixel') {
      final p = _fill(accent);
      if (isX) {
        for (final r in const [
          Rect.fromLTWH(5, 5, 4, 4),
          Rect.fromLTWH(9, 9, 4, 4),
          Rect.fromLTWH(13, 13, 4, 4),
          Rect.fromLTWH(15, 5, 4, 4),
          Rect.fromLTWH(5, 15, 4, 4),
        ]) {
          canvas.drawRect(r, p);
        }
      } else {
        canvas.drawRect(const Rect.fromLTWH(6, 6, 12, 12), _line(accent, 3));
      }
      return;
    }
    if (isX) {
      final p = _line(accent, skin == 'Neon' ? 4 : 3.4);
      canvas.drawLine(const Offset(5, 5), const Offset(19, 19), p);
      canvas.drawLine(const Offset(19, 5), const Offset(5, 19), p);
    } else {
      canvas.drawCircle(
          const Offset(12, 12), 7, _line(accent, skin == 'Neon' ? 4 : 3.4));
    }
  }

  @override
  bool shouldRepaint(covariant _MarkPainter o) =>
      o.isX != isX || o.skin != skin;
}

class _Face extends StatelessWidget {
  final CustomPainter painter;
  final double size;
  final String label;
  const _Face(this.painter, this.size, this.label);
  @override
  Widget build(BuildContext context) => Semantics(
      label: label,
      image: true,
      child: CustomPaint(size: Size.square(size), painter: painter));
}

class DollFace extends StatelessWidget {
  final double size;
  const DollFace({super.key, this.size = 80});
  @override
  Widget build(BuildContext context) =>
      _Face(_DollPainter(), size, 'The Doll character');
}

class GuardFace extends StatelessWidget {
  final double size;
  const GuardFace({super.key, this.size = 80});
  @override
  Widget build(BuildContext context) =>
      _Face(_GuardPainter(), size, 'Masked guard character');
}

class PlayerFace extends StatelessWidget {
  final double size;
  const PlayerFace({super.key, this.size = 80});
  @override
  Widget build(BuildContext context) =>
      _Face(_PlayerPainter(), size, 'Player character');
}

class AppLogoMark extends StatelessWidget {
  final double size;
  const AppLogoMark({super.key, this.size = 120});
  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Tic Tac Toe app logo',
        image: true,
        child: Image.asset(
          'assets/icon/app_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      );
}

class _DollPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100);
    final hair = Path()
      ..moveTo(18, 52)
      ..cubicTo(14, 20, 32, 6, 50, 6)
      ..cubicTo(68, 6, 86, 20, 82, 52)
      ..cubicTo(82, 66, 86, 78, 88, 88)
      ..lineTo(12, 88)
      ..cubicTo(14, 78, 18, 66, 18, 52)
      ..close();
    canvas.drawPath(hair, _fill(C.bg));
    canvas.drawPath(hair, _line(C.magenta, 2));
    canvas.drawCircle(const Offset(50, 52), 27, _fill(const Color(0xFFF3D2B8)));
    canvas.drawPath(
        Path()
          ..moveTo(23, 44)
          ..cubicTo(26, 22, 74, 22, 77, 44)
          ..cubicTo(66, 34, 34, 34, 23, 44)
          ..close(),
        _fill(C.bg));
    canvas.drawCircle(const Offset(40, 54), 5, _fill(C.bg));
    canvas.drawCircle(const Offset(60, 54), 5, _fill(C.bg));
    canvas.drawCircle(const Offset(41.5, 52.5), 1.6, _fill(Colors.white));
    canvas.drawCircle(const Offset(61.5, 52.5), 1.6, _fill(Colors.white));
    canvas.drawCircle(const Offset(33, 64), 4, _fill(C.magenta.withAlpha(128)));
    canvas.drawCircle(const Offset(67, 64), 4, _fill(C.magenta.withAlpha(128)));
    canvas.drawPath(
        Path()
          ..moveTo(45, 68)
          ..quadraticBezierTo(50, 72, 55, 68),
        _line(const Color(0xFFB3123E), 2.4));
    canvas.drawPath(
        Path()
          ..moveTo(70, 22)
          ..lineTo(84, 14)
          ..lineTo(84, 30)
          ..close()
          ..moveTo(70, 22)
          ..lineTo(56, 12)
          ..lineTo(56, 28)
          ..close(),
        _fill(C.teal));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _GuardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100);
    canvas.drawPath(
        Path()
          ..moveTo(50, 4)
          ..cubicTo(26, 4, 14, 22, 14, 44)
          ..lineTo(14, 64)
          ..lineTo(6, 94)
          ..lineTo(94, 94)
          ..lineTo(86, 64)
          ..lineTo(86, 44)
          ..cubicTo(86, 22, 74, 4, 50, 4)
          ..close(),
        _fill(C.btn));
    final mask = Path()
      ..moveTo(50, 18)
      ..lineTo(72, 46)
      ..lineTo(50, 74)
      ..lineTo(28, 46)
      ..close();
    canvas.drawPath(mask, _fill(C.bg));
    canvas.drawPath(mask, _line(C.text, 2));
    final eye = _line(C.text, 3);
    canvas.drawLine(const Offset(38, 44), const Offset(46, 44), eye);
    canvas.drawLine(const Offset(54, 44), const Offset(62, 44), eye);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100);
    canvas.drawPath(
        Path()
          ..moveTo(10, 100)
          ..cubicTo(10, 74, 26, 64, 50, 64)
          ..cubicTo(74, 64, 90, 74, 90, 100)
          ..close(),
        _fill(C.teal));
    canvas.drawCircle(const Offset(50, 36), 20, _fill(const Color(0xFFF3D2B8)));
    canvas.drawPath(
        Path()
          ..moveTo(30, 34)
          ..cubicTo(30, 18, 70, 18, 70, 34)
          ..cubicTo(62, 28, 38, 28, 30, 34)
          ..close(),
        _fill(C.bg));
    canvas.drawCircle(const Offset(43, 38), 2.2, _fill(C.bg));
    canvas.drawCircle(const Offset(57, 38), 2.2, _fill(C.bg));
    canvas.drawPath(
        Path()
          ..moveTo(44, 46)
          ..quadraticBezierTo(50, 50, 56, 46),
        _line(C.bg, 2));
    canvas.drawPath(
        Path()
          ..moveTo(38, 64)
          ..lineTo(50, 78)
          ..lineTo(62, 64),
        _line(C.text, 4));
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(60, 80, 22, 13), const Radius.circular(2)),
        _fill(C.text));
    final tp = TextPainter(
      text: const TextSpan(
          text: '042',
          style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w800, color: C.bg)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(71 - tp.width / 2, 86.5 - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

