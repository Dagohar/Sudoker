library global_vars;

import 'package:sudoker/widgets/sudoku_field.dart';

class Difficulty{
  static int get Easy => 20;
  static int get Medium => 40;
  static int get Hard => 60;
}

const int gridLength = gridSize * gridSize;
const int gridSize = 9;
const int boxLength = boxSize * boxSize * boxSize;
const int boxSize = 3;

int freeSpaceAmount = Difficulty.Medium;

String chosenNumber = '';
int freeSpaceLeft = gridLength;
bool hintShown = false;
bool errorOccurred = false;

// contains a grid of details about every Sudoku Field on the table
var widgetGrid = List.generate(
    9, (_) => List<SudokuFieldDetails>.filled(gridSize, SudokuFieldDetails('', false, null)),
    growable: false
);

// contains a grid of numbers of a already solved sudoku
List<List<String>> completeGrid = List.generate(
    9, (_) => List<String>.filled(gridSize, ''),
    growable: false
);
