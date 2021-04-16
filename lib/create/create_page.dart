import 'package:flutter/material.dart';
import 'package:puzzle/puzzle/puzzle_page.dart';

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      settings: const RouteSettings(
                        name: '${PuzzlePage.Path}?src=test',
                      ),
                      builder: (_) => PuzzlePage(args: PuzzlePageArgs('test')),
                    ),
                  );
                },
                child: const Text('パズルページへ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
