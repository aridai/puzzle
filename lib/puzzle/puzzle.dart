import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'puzzle.freezed.dart';

/// パズル
class Puzzle {
  Puzzle(this.img, this.settings) {
    final pieceW = img.width / settings.hDiv;
    final pieceH = img.height / settings.vDiv;

    //  先に移動可能なピースを求めておく。
    final blankIndex = settings.blankIndex;
    final movablePieceIndices = _seekMovablePieces(blankIndex);

    //  ピースの初回生成を行う。
    final pieceCount = settings.hDiv * settings.vDiv;
    _pieces = List.generate(pieceCount, (index) {
      final hIndex = index % settings.hDiv;
      final vIndex = index ~/ settings.hDiv;
      final position = Position(index, hIndex, vIndex);

      final region =
          Rect.fromLTWH(pieceW * hIndex, pieceH * vIndex, pieceW, pieceH);
      final isMovable = movablePieceIndices.contains(index);
      final isBlankPiece = index == blankIndex;

      return Piece(img, position, position, region, isMovable, isBlankPiece);
    }, growable: false);
  }

  //  ピースのリスト
  //  (オリジナルのインデックス順に配置されている。)
  late final List<Piece> _pieces;

  /// 元の画像データ
  final Image img;

  /// パズルの設定
  final PuzzleSettings settings;

  /// パズルのピースのリスト
  List<Piece> get pieces => _pieces;

  /// パズルが完成しているかどうか
  bool get isCompleted => _pieces.none((p) => p.originalPos != p.currentPos);

  /// ピースを移動する。
  void move(Piece piece) {
    final targetIndex = piece.originalPos.index;
    final blankIndex = settings.blankIndex;
    final blankPiece = _pieces[blankIndex];

    //  移動対象のピースと空白ピースの現在の位置を入れ替える。
    _pieces[targetIndex] = piece.copyWith(currentPos: blankPiece.currentPos);
    _pieces[blankIndex] = blankPiece.copyWith(currentPos: piece.currentPos);

    //  更新後の空白ピースに基づいて、動かせるピースを求める。
    final updatedBlankPieceIndex = piece.currentPos.index;
    final movablePieceIndices = _seekMovablePieces(updatedBlankPieceIndex);

    //  移動可能フラグを更新していく。
    for (var i = 0; i < _pieces.length; i++) {
      final piece = _pieces[i];
      final isMovable = movablePieceIndices.contains(piece.currentPos.index);

      _pieces[i] = piece.copyWith(isMovable: isMovable);
    }
  }

  //  移動可能ピースを求める。
  //  空白ピースの現在のインデックスを元に、パズルの領域からのはみ出しを考慮しつつ、
  //  隣接する移動可能なピースのインデックスを求める。
  List<int> _seekMovablePieces(int blankIndex) {
    final hIndex = blankIndex % settings.hDiv;
    final vIndex = blankIndex ~/ settings.hDiv;

    final rightEdgeIndex = settings.hDiv - 1;
    final bottomEdgeIndex = settings.vDiv - 1;

    final top = vIndex > 0 ? blankIndex - settings.hDiv : null;
    final bottom = vIndex < bottomEdgeIndex ? blankIndex + settings.hDiv : null;
    final left = hIndex > 0 ? blankIndex - 1 : null;
    final right = hIndex < rightEdgeIndex ? blankIndex + 1 : null;

    return [top, bottom, left, right].whereNotNull().toList();
  }
}

/// パズルの設定
class PuzzleSettings {
  /// パズルの設定を生成する。
  /// 横と縦の分割数と空白ピースの位置を指定する。
  /// 空白ピースの位置は任意指定で、指定しなかった場合は一番右下が指定される。
  PuzzleSettings({
    required this.hDiv,
    required this.vDiv,
    int? blankIndex = null,
  }) : blankIndex = blankIndex ?? calculateDefaultBlankIndex(hDiv, vDiv) {
    assert(validate(hDiv, vDiv, this.blankIndex));
  }

  /// 横方向の最小分割数
  static const MinHorizontalDiv = 3;

  /// 横方向の最大分割数
  static const MaxHorizontalDiv = 9;

  /// 横方向の分割数のデフォルト設定
  static const DefaultHorizontalDiv = 3;

  /// 縦方向の最小分割数
  static const MinVerticalDiv = 3;

  /// 縦方向の最大分割数
  static const MaxVerticalDiv = 9;

  /// 縦方向の分割数のデフォルト設定
  static const DefaultVerticalDiv = 3;

  /// デフォルト設定
  static final PuzzleSettings defaultSettings = PuzzleSettings(
    hDiv: DefaultHorizontalDiv,
    vDiv: DefaultVerticalDiv,
  );

  /// 設定項目を検証する。
  static bool validate(int hDiv, int vDiv, [int? blankIndex = null]) {
    //  分割数が範囲外ならばNG
    if (!(MinHorizontalDiv <= hDiv && hDiv <= MaxHorizontalDiv)) return false;
    if (!(MinVerticalDiv <= vDiv && vDiv <= MaxVerticalDiv)) return false;

    //  空白ピースのインデックスが指定されている場合、
    //  有効なピースのインデックスの範囲外であればNG
    if (blankIndex != null) {
      if (blankIndex.isNegative) return false;

      final lastIndex = calculateLastIndex(hDiv, vDiv);
      if (blankIndex > lastIndex) return false;
    }

    return true;
  }

  /// 指定した分割数の場合のピースの最後のインデックスを計算する。
  static int calculateLastIndex(int hDiv, int vDiv) => hDiv * vDiv - 1;

  /// デフォルトの空白ピースのインデックスを分割数に基づいて計算する。
  static int calculateDefaultBlankIndex(int hDiv, int vDiv) =>
      calculateLastIndex(hDiv, vDiv);

  /// 横方向の分割数
  final int hDiv;

  /// 縦方向の分割数
  final int vDiv;

  /// 空白ピースのインデックス
  final int blankIndex;
}

/// パズルのピース
@freezed
abstract class Piece with _$Piece {
  const factory Piece(
    /// 元の画像データ
    Image img,

    /// このピースの本来の位置
    Position originalPos,

    /// このピースの現在の位置
    Position currentPos,

    /// 元の画像データにおけるこのピースの領域
    Rect region,

    /// このピースが移動可能かどうか
    bool isMovable,

    /// このピースが空白ピースかどうか
    bool isBlankPiece,
  ) = _Piece;
}

/// ピースの位置
@freezed
abstract class Position with _$Position {
  const factory Position(
    /// 1次元インデックス
    int index,

    /// 横方向のインデックス
    int hIndex,

    /// 縦方向のインデックス
    int vIndex,
  ) = _Position;
}
