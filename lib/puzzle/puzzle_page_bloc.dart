import 'package:puzzle/puzzle/puzzle.dart';
import 'package:puzzle/puzzle/puzzle_creator.dart';
import 'package:puzzle/puzzle/puzzle_shuffler.dart';
import 'package:rxdart/rxdart.dart';

/// パズルページのBLoC
class PuzzlePageBloc {
  PuzzlePageBloc(
      this._src, this._settings, this._seed, this._creator, this._shuffler) {
    _loadPuzzle();
  }

  final String _src;
  final PuzzleSettings _settings;
  final int? _seed;
  final PuzzleCreator _creator;
  final PuzzleShuffler _shuffler;

  final _isLoading = BehaviorSubject.seeded(true);
  final _puzzle = BehaviorSubject<Puzzle?>.seeded(null);
  final _completeDialogEvent = PublishSubject<void>();

  /// ProgressIndicatorの可視性
  Stream<bool> get isProgressIndicatorVisible => _isLoading.stream;

  /// パズル
  Stream<Puzzle?> get puzzle => _puzzle.stream;

  /// リロードボタンの可視性
  Stream<bool> get isReloadButtonVisible =>
      Rx.combineLatest2<bool, Puzzle?, bool>(
        _isLoading,
        _puzzle,
        (loading, puzzle) => !loading && puzzle == null,
      );

  /// リセットボタンの可視性
  Stream<bool> get isResetButtonVisible =>
      _puzzle.map((puzzle) => puzzle != null);

  /// シャッフルボタンの可視性
  Stream<bool> get isShuffleButtonVisible =>
      _puzzle.map((puzzle) => puzzle != null);

  /// 完成ダイアログの表示を通知するイベント
  Stream<void> get completeDialogEvent => _completeDialogEvent.stream;

  /// ピースが選択されたとき。
  void onPieceSelected(Piece piece) {
    if (piece.isMovable) {
      //  移動可能なピースが選択された場合、移動処理を行い、更新を通知する。
      final puzzle = _puzzle.requireValue!;
      puzzle.move(piece);
      _puzzle.add(puzzle);

      //  パズルが完成したのならば、完成ダイアログの表示を通知する。
      if (puzzle.isCompleted) {
        _completeDialogEvent.add(null);
      }
    }
  }

  /// 終了処理を行う。
  void dispose() {
    _isLoading.close();
    _puzzle.close();
    _completeDialogEvent.close();
  }

  //  パズルを読み込む。
  Future<void> _loadPuzzle() async {
    _isLoading.add(true);

    final result = await _creator.createPuzzle(_src, _settings);
    result.when(
      //  成功時
      success: (puzzle) {
        _shuffler.shuffle(puzzle, _seed);
        _puzzle.add(puzzle);
        _isLoading.add(false);
      },

      //  失敗時
      failure: () {
        _puzzle.add(null);
        _isLoading.add(false);
      },
    );
  }
}
