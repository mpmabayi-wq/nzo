import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_themes.dart';

enum NzoLogoStyle { color, light }

/// Logo Nzo dessiné en code (aucun fichier image nécessaire).
class NzoLogo extends StatelessWidget {
  const NzoLogo({
    super.key,
    this.height = 56,
    this.withWord = false,
    this.style = NzoLogoStyle.color,
    this.wordColor,
  });

  final double height;
  final bool withWord;
  final NzoLogoStyle style;
  final Color? wordColor;

  @override
  Widget build(BuildContext context) {
    final width = withWord ? height * (452 / 160) : height;
    final color = wordColor ??
        (style == NzoLogoStyle.light
            ? Colors.white
            : Theme.of(context).colorScheme.onSurface);
    return Semantics(
      label: 'Nzo',
      image: true,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(painter: _NzoPainter(withWord, style, color)),
      ),
    );
  }
}

class _NzoPainter extends CustomPainter {
  _NzoPainter(this.withWord, this.style, this.wordColor);

  final bool withWord;
  final NzoLogoStyle style;
  final Color wordColor;

  @override
  void paint(Canvas canvas, Size size) {
    final vbW = withWord ? 452.0 : 160.0;
    const vbH = 160.0;
    final sc = math.min(size.width / vbW, size.height / vbH);

    canvas.save();
    canvas.translate((size.width - vbW * sc) / 2, (size.height - vbH * sc) / 2);
    canvas.scale(sc);
    canvas.translate(-10, -10);

    const rect = Rect.fromLTWH(10, 10, 160, 160);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(42));
    final bg = Paint();
    if (style == NzoLogoStyle.color) {
      bg.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.brandLight, AppColors.brandDeep],
      ).createShader(rect);
    } else {
      bg.color = Colors.white;
    }
    canvas.drawRRect(rrect, bg);

    final house = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = style == NzoLogoStyle.color ? Colors.white : AppColors.brand;

    final roof = Path()
      ..moveTo(42, 92)
      ..lineTo(90, 52)
      ..lineTo(138, 92);
    final body = Path()
      ..moveTo(56, 84)
      ..lineTo(56, 134)
      ..lineTo(124, 134)
      ..lineTo(124, 84);
    canvas.drawPath(roof, house);
    canvas.drawPath(body, house);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(80, 102, 20, 32),
        const Radius.circular(10),
      ),
      Paint()..color = AppColors.gold,
    );

    if (withWord) {
      final word = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = wordColor;

      final n = Path()
        ..moveTo(216, 55)
        ..lineTo(216, 125)
        ..moveTo(216, 83)
        ..cubicTo(216, 65, 230, 55, 246, 55)
        ..cubicTo(264, 55, 274, 67, 274, 85)
        ..lineTo(274, 125);
      final z = Path()
        ..moveTo(300, 55)
        ..lineTo(360, 55)
        ..lineTo(300, 125)
        ..lineTo(362, 125);
      final o = Path()..addOval(Rect.fromCircle(center: const Offset(414, 90), radius: 35));
      canvas.drawPath(n, word);
      canvas.drawPath(z, word);
      canvas.drawPath(o, word);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NzoPainter old) =>
      old.withWord != withWord || old.style != style || old.wordColor != wordColor;
}
