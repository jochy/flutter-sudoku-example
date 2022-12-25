import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/tile.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:go_router/go_router.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.title});

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final Puzzle puzzle = Puzzle(PuzzleOptions());
  bool isInit = false;
  Point? selectedCell;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var bigCellSize = (maxSize / 3).ceil().toDouble();
    var smallCellSize = (maxSize / 9).ceil().toDouble();

    if (!isInit) {
      puzzle.generate().then((value) => setState(() {
            isInit = true;
          }));
      return const Text("Loading");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: bigCellSize * 3,
                height: bigCellSize * 3,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (x) {
                    return Container(
                      width: bigCellSize,
                      height: bigCellSize,
                      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: List.generate(9, (y) {
                          return Tile(
                            value: "${puzzle.board()?.matrix()?[x][y].getValue()}",
                            hint: "${puzzle.solvedBoard()?.matrix()?[x][y].getValue()}",
                            size: smallCellSize,
                            isSelected: selectedCell != null && selectedCell!.x == x && selectedCell!.y == y,
                            onSelected: () => setState(() {
                              selectedCell = Point(x, y);
                            }),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    5,
                    (index) => ElevatedButton(
                        onPressed: () => setSelectedCellValue(index + 1, context), child: Text("${index + 1}"))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    4,
                    (index) => ElevatedButton(
                        onPressed: () => setSelectedCellValue(index + 6, context), child: Text("${index + 6}"))),
              ),
            ),
            ElevatedButton(
              onPressed: () => autoFill(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              child: const Text("Resolve"),
            )
          ],
        ),
      ),
    );
  }

  void autoFill(BuildContext context) {
    for (var list in puzzle.board()!.matrix()!) {
      for (var cell in list) {
        cell.setValue(puzzle.solvedBoard()!.cellAt(cell.position!).getValue());
      }
    }

    context.go('/end');
  }

  bool isSolution() {
    for (var list in puzzle.board()!.matrix()!) {
      for (var cell in list) {
        if (cell.getValue() != puzzle.solvedBoard()!.cellAt(cell.position!).getValue()) {
          return false;
        }
      }
    }
    return true;
  }

  void setSelectedCellValue(value, context) {
    if (selectedCell == null || puzzle.board() == null || puzzle.solvedBoard() == null) {
      return;
    }
    var pos = Position(row: selectedCell!.x.toInt(), column: selectedCell!.y.toInt());

    if (puzzle.solvedBoard()!.cellAt(pos).getValue() != value) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Wrong value',
          message: 'Please try another one',
          contentType: ContentType.warning,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      setState(() {
        selectedCell = null;
      });
    } else {
      setState(() {
        puzzle.board()!.cellAt(pos).setValue(value);
        selectedCell = null;
      });
      if (isSolution()) {
        context.go('/end');
      }
    }
  }
}
