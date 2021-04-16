import 'package:flutter/material.dart';
import 'package:puzzle/create/create_page.dart';
import 'package:puzzle/home/home_page.dart';
import 'package:puzzle/puzzle/puzzle_page.dart';

/// パズルアプリ
class PuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'puzzle',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        final uri = Uri.tryParse(settings.name ?? '');

        switch (uri?.path) {
          case CreatePage.Path:
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => CreatePage(),
            );

          case PuzzlePage.Path:
            final args = PuzzlePageArgs.tryParseParams(uri?.queryParametersAll);
            if (args != null) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (context) => PuzzlePage(args: args),
              );
            }
            break;
        }
      },
      home: HomePage(),
    );
  }
}
