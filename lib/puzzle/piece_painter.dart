import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/puzzle.dart';

/// ピースの描画を行うCustomPainter
class PiecePainter extends CustomPainter {
  PiecePainter(this._piece);

  final Piece _piece;
  static final _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final destRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(_piece.img, _piece.region, destRect, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
