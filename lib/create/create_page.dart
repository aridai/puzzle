import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/puzzle.dart';
import 'package:puzzle/puzzle/puzzle_page.dart';
import 'package:puzzle/puzzle/puzzle_page_args.dart';

/// 作成ページ
class CreatePage extends StatelessWidget {
  static const Path = '/create';

  final _controller = TextEditingController(text: _defaultImgSrc);

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
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: TextField(controller: _controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: ElevatedButton(
                onPressed: () {
                  final imgSrc = _controller.value.text;
                  _toPuzzlePage(context, imgSrc);
                },
                child: const Text('パズルページへ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toPuzzlePage(BuildContext context, String src) {
    final args = PuzzlePageArgs(PuzzleSettings.defaultSettings, src);
    final route = MaterialPageRoute<void>(
      settings: RouteSettings(name: '${PuzzlePage.Path}?${args.queryParams}'),
      builder: (_) => PuzzlePage(args: args),
    );

    Navigator.push(context, route);
  }
}

const _defaultImgSrc = 'https://github.com/aridai/puzzle'
    '/blob/master/web/icons/Icon-512.png?raw=true';
