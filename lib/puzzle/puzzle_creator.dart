import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:puzzle/puzzle/puzzle.dart';

part 'puzzle_creator.freezed.dart';

/// [Puzzle]の生成ロジック
class PuzzleCreator {
  /// [Puzzle]を生成する。
  Future<PuzzleCreatorResult> createPuzzle(
    String src,
    PuzzleSettings settings,
  ) async {
    try {
      final img = await _fetchImageFromUrl(src);
      final puzzle = Puzzle(img, settings);

      return PuzzleCreatorResult.success(puzzle);
    } catch (e) {
      //  このアプリでは細かなエラー分岐や自動リトライなどはしないことにする。
      print('画像取得エラー: $e');

      return const PuzzleCreatorResult.failure();
    }
  }

  //  ui.ImageをURLから取得する。
  Future<ui.Image> _fetchImageFromUrl(String url) async {
    final imageStream = NetworkImage(url).resolve(ImageConfiguration.empty);

    final completer = Completer<ImageInfo>();
    imageStream.addListener(
      ImageStreamListener(
        (info, _) => completer.complete(info),
        onError: (error, stack) => completer.completeError(error, stack),
      ),
    );

    return (await completer.future).image;
  }
}

/// [PuzzleCreator]の結果
@freezed
abstract class PuzzleCreatorResult with _$PuzzleCreatorResult {
  /// 成功
  const factory PuzzleCreatorResult.success(Puzzle puzzle) = _Success;

  /// 失敗
  const factory PuzzleCreatorResult.failure() = _Failure;
}
