import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/puzzle/puzzle.dart';
import 'package:puzzle/puzzle/puzzle_board.dart';
import 'package:puzzle/puzzle/puzzle_creator.dart';
import 'package:puzzle/puzzle/puzzle_page_args.dart';
import 'package:puzzle/puzzle/puzzle_page_bloc.dart';
import 'package:puzzle/puzzle/puzzle_shuffler.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PuzzlePageBloc>(context);

    return Scaffold(
      body: Container(
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
      ),
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

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
}
