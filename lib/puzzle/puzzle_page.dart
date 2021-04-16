import 'package:flutter/material.dart';

/// パズルページの引数
class PuzzlePageArgs {
  PuzzlePageArgs(this.src);

  /// 画像の取得元URL
  final String src;

  /// クエリパラメタのパースを試行する。
  static PuzzlePageArgs? tryParseParams(Map<String, List<String>>? params) {
    if (params == null) return null;

    final srcParam = params['src'];
    if (srcParam == null || srcParam.length != 1) return null;
    final src = srcParam.first;
    if (src.trim().isEmpty) return null;

    return PuzzlePageArgs(src);
  }
}

/// パズルページ
class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key, required this.args}) : super(key: key);

  static const Path = '/play';

  final PuzzlePageArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('パズルページ'),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text('src: ${args.src}'),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: SelectableText(Uri.base.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
