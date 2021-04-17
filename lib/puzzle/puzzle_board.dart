import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/piece_painter.dart';
import 'package:puzzle/puzzle/puzzle.dart';

typedef PieceCallback = void Function(Piece);

/// パズルボードのUI
class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    Key? key,
    required this.puzzle,
    required this.onPieceSelected,
    this.animDuration = const Duration(milliseconds: 100),
    this.focusColor = const Color(0x332196F3),
  }) : super(key: key);

  final Puzzle puzzle;
  final PieceCallback onPieceSelected;
  final Duration animDuration;
  final Color focusColor;

  @override
  Widget build(BuildContext context) {
    final ratio = puzzle.img.width / puzzle.img.height;

    return AspectRatio(
      aspectRatio: ratio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final pieceWidth = constraints.maxWidth / puzzle.settings.hDiv;
          final pieceHeight = constraints.maxHeight / puzzle.settings.vDiv;

          return _buildPieces(pieceWidth, pieceHeight);
        },
      ),
    );
  }

  //  パズルの複数のピースを生成する。
  Widget _buildPieces(double pieceWidth, double pieceHeight) {
    return Stack(
      children: puzzle.pieces.map(
        (piece) {
          final offsetX = pieceWidth * piece.currentPos.hIndex;
          final offsetY = pieceHeight * piece.currentPos.vIndex;

          return AnimatedPadding(
            padding: EdgeInsets.only(left: offsetX, top: offsetY),
            duration: animDuration,
            child: SizedBox(
              width: pieceWidth,
              height: pieceHeight,
              child: _buildPiece(piece),
            ),
          );
        },
      ).toList(),
    );
  }

  //  ピースを生成する。
  Widget _buildPiece(Piece piece) {
    //  空白ピースの場合は何も描画させない。
    if (piece.isBlankPiece) return const SizedBox();

    //  移動可能かどうかによって色を分ける。
    final inkColor = piece.isMovable ? focusColor : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: PiecePainter(piece)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onPieceSelected(piece),
              hoverColor: inkColor,
              splashColor: inkColor,
              highlightColor: inkColor,
            ),
          ),
        ],
      ),
    );
  }
}
