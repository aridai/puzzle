import 'package:flutter/material.dart';
import 'package:puzzle/create/create_page.dart';

/// ホーム
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('ホーム'),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CreatePage.Path);
                },
                child: const Text('作成ページへ'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
