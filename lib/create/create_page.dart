import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/puzzle.dart';
import 'package:puzzle/puzzle/puzzle_page.dart';
import 'package:puzzle/puzzle/puzzle_page_args.dart';

/// 作成ページ
class CreatePage extends StatelessWidget {
  static const Path = '/create';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('作成ページ'),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: ElevatedButton(
                onPressed: () => _toPuzzlePage(context),
                child: const Text('パズルページへ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toPuzzlePage(BuildContext context) {
    final args = PuzzlePageArgs(PuzzleSettings.defaultSettings, src);
    final route = MaterialPageRoute<void>(
      settings: RouteSettings(name: '${PuzzlePage.Path}?${args.queryParams}'),
      builder: (_) => PuzzlePage(args: args),
    );

    Navigator.push(context, route);
  }
}

const src = 'https://github.com/aridai/puzzle'
    '/blob/master/web/icons/Icon-512.png?raw=true';
