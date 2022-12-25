import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sudoku"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/game'),
          child: const Text("Start a new game"),
        ),
      ),
    );
  }
}
