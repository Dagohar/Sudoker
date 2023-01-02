import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sudoker/constants/app_constants.dart';
import 'package:sudoker/utilities//sudoku_generator.dart';
import 'package:sudoker/widgets/sudoku_field.dart';
import 'package:sudoker/global/global_variables.dart' as glob;

// create a listener for refreshing all sudoku fields
StreamController streamController = StreamController.broadcast();

class SudokuTable extends StatefulWidget {
  const SudokuTable({Key? key}) : super(key: key);

  @override
  State<SudokuTable> createState() => _SudokuTableState();
}

class _SudokuTableState extends State<SudokuTable> {
  final SudokuGenerator _creator = SudokuGenerator();

  List<Widget> _listOfFields() {
    List<Widget> finalTable = [];
    List fields = _creator.createNewSudoku(glob.freeSpaceAmount);

    int currIndex = 0;
    String currValue;

    glob.widgetGrid = List.generate(glob.gridSize, (_) => List<SudokuFieldDetails>.filled(glob.gridSize, SudokuFieldDetails('', false, null)), growable: false);

    for (int y = 0; y < glob.gridSize; y++) {
      for (int x = 0; x < glob.gridSize; x++) {
        currValue = fields[y][x] == '0' ? '' : fields[y][x];

        // create sudoku fields on screen with proper border decoration
        if (x % glob.boxSize == 0 && y % glob.boxSize == 0 && x > 0 && y > 0) {
          finalTable.add(Container(
            decoration: heavyBoxBorderTopLeft,
            child: SudokuField(x: x, y: y, value: currValue, stream: streamController.stream),
          ));
        } else if (x % glob.boxSize == 0 && x > 0) {
          finalTable.add(Container(
            decoration: heavyBoxBorderLeft,
            child: SudokuField(x: x, y: y, value: currValue, stream: streamController.stream),
          ));
        } else if (y % glob.boxSize == 0 && y > 0) {
          finalTable.add(Container(
            decoration: heavyBoxBorderTop,
            child: SudokuField(x: x, y: y, value: currValue, stream: streamController.stream),
          ));
        } else {
          finalTable.add(Container(
            decoration: lightBoxBorder,
            child: SudokuField(x: x, y: y, value: currValue, stream: streamController.stream),
          ));
        }

        glob.widgetGrid[y][x] = SudokuFieldDetails(currValue, currValue != '', (finalTable[currIndex++] as Container).child as SudokuField);
      }
    }

    // update all listening sudoku fields
    streamController.add(null);

    return finalTable;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: glob.gridSize,
      padding: const EdgeInsets.all(20.0),
      children: _listOfFields(),
    );
  }
}
