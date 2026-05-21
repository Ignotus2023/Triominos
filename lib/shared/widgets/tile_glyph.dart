import 'package:flutter/material.dart';

class TileGlyph extends StatelessWidget {
  const TileGlyph({
    required this.corner1,
    required this.corner2,
    required this.corner3,
    this.size = 56,
    this.color,
    this.textColor,
    super.key,
  });

  final int corner1;
  final int corner2;
  final int corner3;
  final double size;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      size: Size.square(size),
      painter: _TilePainter(
        corner1: corner1,
        corner2: corner2,
        corner3: corner3,
        fill: color ?? scheme.primaryContainer,
        stroke: scheme.outline,
        textColor: textColor ?? scheme.onPrimaryContainer,
      ),
    );
  }
}

class _TilePainter extends CustomPainter {
  _TilePainter({
    required this.corner1,
    required this.corner2,
    required this.corner3,
    required this.fill,
    required this.stroke,
    required this.textColor,
  });

  final int corner1;
  final int corner2;
  final int corner3;
  final Color fill;
  final Color stroke;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final padding = w * 0.04;

    final top = Offset(w / 2, padding);
    final bottomLeft = Offset(padding, h - padding);
    final bottomRight = Offset(w - padding, h - padding);

    final path = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = fill
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    final centroid = Offset((top.dx + bottomLeft.dx + bottomRight.dx) / 3,
        (top.dy + bottomLeft.dy + bottomRight.dy) / 3);

    final offsetRatio = 0.62;
    final labelPositions = [
      Offset.lerp(centroid, top, offsetRatio)!,
      Offset.lerp(centroid, bottomRight, offsetRatio)!,
      Offset.lerp(centroid, bottomLeft, offsetRatio)!,
    ];

    final values = [corner1, corner2, corner3];
    final fontSize = w * 0.18;
    for (var i = 0; i < 3; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: values[i].toString(),
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, labelPositions[i] - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _TilePainter old) =>
      old.corner1 != corner1 ||
      old.corner2 != corner2 ||
      old.corner3 != corner3 ||
      old.fill != fill ||
      old.stroke != stroke ||
      old.textColor != textColor;
}
