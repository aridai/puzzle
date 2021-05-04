import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/puzzle/puzzle.dart';
import 'package:puzzle/puzzle/puzzle_board.dart';
import 'package:puzzle/puzzle/puzzle_creator.dart';
import 'package:puzzle/puzzle/puzzle_page_args.dart';
import 'package:puzzle/puzzle/puzzle_page_bloc.dart';
import 'package:puzzle/puzzle/puzzle_shuffler.dart';
import 'package:puzzle/share.dart';
import 'package:rxdart/rxdart.dart';

/// パズルページ
class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key, required this.args}) : super(key: key);

  static const Path = '/play';

  final PuzzlePageArgs args;

  @override
  Widget build(BuildContext context) {
    return Provider<PuzzlePageBloc>(
      create: (context) => PuzzlePageBloc(
        args.src,
        args.settings,
        args.seed,
        PuzzleCreator(),
        PuzzleShuffler(),
      ),
      dispose: (context, bloc) => bloc.dispose(),
      child: _PuzzlePage(),
    );
  }
}

class _PuzzlePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<_PuzzlePage> {
  final _compositeSubscription = CompositeSubscription();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<PuzzlePageBloc>(context);
    bloc.completeDialogEvent
        .listen((_) => _showCompleteDialog())
        .addTo(_compositeSubscription);
    bloc.sourceImageDialogEvent
        .listen(_showSourceImageDialog)
        .addTo(_compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PuzzlePageBloc>(context);

    return Scaffold(
      endDrawer: _buildDrawer(bloc),
      body: _buildBody(bloc),
      floatingActionButton: _buildFloatingActionButton(bloc),
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  //  Drawerを生成する。
  Widget _buildDrawer(PuzzlePageBloc bloc) => Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('元の画像を表示'),
                onTap: () {
                  //  Drawerを閉じて、元画像ダイアログの表示要求を投げる。
                  Navigator.pop(context);
                  bloc.onSourceImageRequested();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('共有'),
                onTap: () => shareCurrentPage('パズル'),
              ),
            ],
          ),
        ),
      );

  //  FloatingActionButtonを生成する。
  Widget _buildFloatingActionButton(PuzzlePageBloc bloc) => Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          child: const Icon(Icons.menu),
        ),
      );

  //  ボディ部を生成する。
  Widget _buildBody(PuzzlePageBloc bloc) => Container(
        color: Colors.grey,
        child: Center(
          child: StreamBuilder<bool>(
            stream: bloc.isProgressIndicatorVisible,
            initialData: true,
            builder: (context, snapshot) {
              final isVisible = snapshot.requireData;

              if (isVisible) {
                return const CircularProgressIndicator();
              } else {
                return _buildContent(bloc);
              }
            },
          ),
        ),
      );

  //  コンテンツを生成する。
  Widget _buildContent(PuzzlePageBloc bloc) {
    return StreamBuilder<Puzzle?>(
      stream: bloc.puzzle,
      initialData: null,
      builder: (context, snapshot) {
        final puzzle = snapshot.data;

        return puzzle != null ? _buildPuzzle(bloc, puzzle) : Container();
      },
    );
  }

  //  パズルを生成する。
  Widget _buildPuzzle(PuzzlePageBloc bloc, Puzzle puzzle) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: PuzzleBoard(
            puzzle: puzzle,
            onPieceSelected: bloc.onPieceSelected,
          ),
        ),
      ),
    );
  }

  //  完成ダイアログを表示する。
  void _showCompleteDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('おめでとうございます!'),
        content: Text('パズルが完成しました!'),
      ),
    );
  }

  //  元画像ダイアログを表示する。
  void _showSourceImageDialog(String imgSrc) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: Image.network(imgSrc),
      ),
    );
  }
}
