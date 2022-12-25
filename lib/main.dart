import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku/end.dart';
import 'package:sudoku/game.dart';
import 'package:sudoku/home.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const Home();
      },
    ),
    GoRoute(
      path: '/game',
      builder: (BuildContext context, GoRouterState state) {
        return const Game(title: "Sudoku");
      },
    ),
    GoRoute(
      path: '/end',
      builder: ((context, state) => const End()),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
