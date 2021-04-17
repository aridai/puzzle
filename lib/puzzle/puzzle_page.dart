import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/puzzle_page_args.dart';

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
              child: SelectableText(Uri.base.toString()),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Image.network(args.src, width: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
