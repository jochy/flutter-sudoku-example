import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class End extends StatelessWidget {
  const End({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Victory"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("You solved it!"),
            ElevatedButton(onPressed: () => context.go('/'), child: const Text("Go to main menu"))
          ],
        ),
      ),
    );
  }
}
