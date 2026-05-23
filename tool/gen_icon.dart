import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Generuje grafikę aplikacji (ikona + splash) — biały triomino na indygo.
/// Uruchom: `dart run tool/gen_icon.dart`
void main() {
  final indigo = img.ColorRgba8(0x43, 0x38, 0xCA, 0xFF);
  final white = img.ColorRgba8(0xFF, 0xFF, 0xFF, 0xFF);

  // Ikona z tłem (legacy + iOS).
  final icon = img.Image(width: 1024, height: 1024, numChannels: 4);
  img.fill(icon, color: indigo);
  _drawTriomino(icon, cx: 512, cy: 548, radius: 320, color: white,
      thickness: 52, pipRadius: 38);
  _write('assets/icon/icon.png', icon);

  // Foreground dla adaptacyjnej ikony Androida (transparentne tło, bezpieczna strefa).
  final fg = img.Image(width: 1024, height: 1024, numChannels: 4);
  _drawTriomino(fg, cx: 512, cy: 548, radius: 250, color: white,
      thickness: 46, pipRadius: 32);
  _write('assets/icon/icon_foreground.png', fg);

  // Logo splash (transparentne tło).
  final splash = img.Image(width: 768, height: 768, numChannels: 4);
  _drawTriomino(splash, cx: 384, cy: 410, radius: 250, color: white,
      thickness: 44, pipRadius: 32);
  _write('assets/splash/splash_logo.png', splash);
}

void _drawTriomino(
  img.Image image, {
  required int cx,
  required int cy,
  required int radius,
  required img.Color color,
  required num thickness,
  required int pipRadius,
}) {
  // Wierzchołki trójkąta równobocznego skierowanego w górę.
  final top = _Point(cx, cy - radius);
  final left = _Point(
    (cx - radius * math.sin(math.pi / 3)).round(),
    (cy + radius * math.cos(math.pi / 3)).round(),
  );
  final right = _Point(
    (cx + radius * math.sin(math.pi / 3)).round(),
    (cy + radius * math.cos(math.pi / 3)).round(),
  );

  for (final (a, b) in [(top, left), (left, right), (right, top)]) {
    img.drawLine(image,
        x1: a.x, y1: a.y, x2: b.x, y2: b.y,
        color: color, thickness: thickness);
  }

  // Pipsy w narożnikach, lekko przesunięte do środka.
  for (final v in [top, left, right]) {
    final px = v.x + ((cx - v.x) * 0.16).round();
    final py = v.y + ((cy - v.y) * 0.16).round();
    img.fillCircle(image, x: px, y: py, radius: pipRadius, color: color,
        antialias: true);
  }
}

void _write(String path, img.Image image) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(image));
  stdout.writeln('wrote $path (${file.lengthSync()} bytes)');
}

class _Point {
  const _Point(this.x, this.y);
  final int x;
  final int y;
}
