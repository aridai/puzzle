import 'package:puzzle/puzzle/puzzle.dart';

/// パズルページの引数
class PuzzlePageArgs {
  PuzzlePageArgs(this.settings, this.src, this.seed);

  /// 横方向の分割数のクエリパラメタ名
  static const HDivParam = 'hdiv';

  /// 縦方向の分割数のクエリパラメタ名
  static const VDivParam = 'vdiv';

  /// 空白ピースのインデックスのクエリパラメタ名
  static const BlankParam = 'blank';

  /// シード値のクエリパラメタ名
  static const SeedParam = 'seed';

  /// 画像の取得元URLのクエリパラメタ名
  static const SrcParam = 'src';

  /// パズルの設定
  final PuzzleSettings settings;

  /// シャッフル時の乱数のシード値 (任意指定)
  final int? seed;

  /// 画像の取得元URL
  final String src;

  /// URLのクエリパラメタ文字列を取得する。
  String get queryParams => '$HDivParam=${settings.hDiv}&'
      '$VDivParam=${settings.vDiv}&'
      '$BlankParam=${settings.blankIndex}&'
      '$SeedParam=$seed&'
      '$SrcParam=${Uri.encodeComponent(src)}';

  /// クエリパラメタのパースを試行する。
  static PuzzlePageArgs? tryParseParams(Map<String, List<String>>? params) {
    if (params == null) return null;

    //  必須パラメタの画像の取得元を取得する。
    final srcParam = _singleOrNull(params[SrcParam]);
    if (srcParam == null || srcParam.trim().isEmpty) return null;
    final src = Uri.decodeComponent(srcParam);

    //  シード値のパラメタをパースする。
    final seed = int.tryParse(_singleOrNull(params[SeedParam]) ?? '');

    //  分割数のパラメタをパースする。
    final hDiv = int.tryParse(_singleOrNull(params[HDivParam]) ?? '');
    final vDiv = int.tryParse(_singleOrNull(params[VDivParam]) ?? '');

    //  有効でない分割数が指定された場合はデフォルト設定を使わせる。
    if (hDiv == null || vDiv == null || !PuzzleSettings.validate(hDiv, vDiv))
      return PuzzlePageArgs(PuzzleSettings.defaultSettings, src, seed);

    //  空白ピースのインデックスをパースする。
    final blank = int.tryParse(_singleOrNull(params[BlankParam]) ?? '');

    //  有効でない空白ピースが指定された場合はデフォルトの空白ピースの設定を使わせる。
    if (blank == null || !PuzzleSettings.validate(hDiv, vDiv, blank))
      return PuzzlePageArgs(PuzzleSettings(hDiv: hDiv, vDiv: vDiv), src, seed);

    final settings = PuzzleSettings(hDiv: hDiv, vDiv: vDiv, blankIndex: blank);
    return PuzzlePageArgs(settings, src, seed);
  }

  static String? _singleOrNull(List<String>? list) =>
      list != null && list.length == 1 ? list.first : null;
}
