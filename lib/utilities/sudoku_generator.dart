import 'dart:math';

import 'package:sudoker/global/global_variables.dart' as glob;

class SudokuGenerator {
  List createNewSudoku(int freeSpace) {
    List<int> grid = List.filled(glob.gridLength, 0);
    List<int> completeGrid = List.filled(glob.gridLength, 0);
    List<int> numbers = [];

    for (int i = 1; i <= glob.gridSize; i++) {
      numbers.add(i);
    }

    // fill each box inside grid with random values
    for (int i = 0; i < glob.gridLength; i++) {
      if (i % glob.gridSize == 0) {
        numbers.shuffle();
      }

      int perBox = ((i ~/ glob.boxSize) % glob.boxSize) * glob.gridSize +
          ((i % glob.boxLength) ~/ glob.gridSize) * glob.boxSize +
          (i ~/ glob.boxLength) * glob.boxLength +
          (i % glob.boxSize);

      grid[perBox] = numbers[i % glob.gridSize];
    }

    // sorting
    _sortSudoku(grid);

    // check if sudoku is valid
    if (!_isSudokuValid(grid)) {
      throw Exception('The sudoku was not valid!');
    }

    completeGrid = grid;
    glob.completeGrid = _convertArrayToList2D(completeGrid);

    // create free spaces for the user to fill
    for (int i = freeSpace; i > 0; i--) {
      int index = Random().nextInt(grid.length);

      if (grid[index] != 0) {
        grid[index] = 0;
      } else if (freeSpace >= glob.gridLength) {
        break;
      } else {
        i++;
      }
    }

    glob.freeSpaceLeft = freeSpace;

    return _convertArrayToList2D(grid);
  }

  // based on: https://github.com/mfgravesjr/finished-projects/blob/master/SudokuGridGenerator/SudokuGridGenerator.java#L65
  void _sortSudoku(List grid) {
    //tracks rows and columns that have been sorted
    List<bool> sorted = List<bool>.filled(glob.gridLength, false);

    for (int i = 0; i < glob.gridSize; i++) {
      bool backtrack = false;

      //0 is row, 1 is column
      for (int a = 0; a < 2; a++) {
        //every number 1-9 that is encountered is registered
        List<bool> registered = List<bool>.filled(glob.gridSize + 1,
            false); //index 0 will intentionally be left empty since there are only number 1-9.
        int rowOrigin = i * glob.gridSize;
        int colOrigin = i;

        ROW_COL:
        for (int j = 0; j < glob.gridSize; j++) {
          //row/column stepping - making sure numbers are only registered once and marking which cells have been sorted
          int step =
              (a % 2 == 0 ? rowOrigin + j : colOrigin + j * glob.gridSize);
          int num = grid[step];

          if (!registered[num]) {
            registered[num] = true;
          } else {
            //if duplicate in row/column
            //box and adjacent-cell swap (BAS method)
            //checks for either unregistered and unsorted candidates in same box,
            //or unregistered and sorted candidates in the adjacent cells
            for (int y = j; y >= 0; y--) {
              int scan =
                  (a % 2 == 0 ? i * glob.gridSize + y : i + glob.gridSize * y);
              if (grid[scan] == num) {
                // box stepping
                for (int z = (a % 2 == 0
                        ? (i % glob.boxSize + 1) * glob.boxSize
                        : 0);
                    z < glob.gridSize;
                    z++) {
                  if (a % 2 == 1 && z % glob.boxSize <= i % glob.boxSize) {
                    continue;
                  }

                  int boxOrigin =
                      ((scan % glob.gridSize) ~/ glob.boxSize) * glob.boxSize +
                          (scan ~/ glob.boxLength) * glob.boxLength;
                  int boxStep = boxOrigin +
                      (z ~/ glob.boxSize) * glob.gridSize +
                      (z % glob.boxSize);
                  int boxNum = grid[boxStep];

                  if ((!sorted[scan] &&
                          !sorted[boxStep] &&
                          !registered[boxNum]) ||
                      (sorted[scan] &&
                          !registered[boxNum] &&
                          (a % 2 == 0
                              ? boxStep % glob.gridSize == scan % glob.gridSize
                              : boxStep / glob.gridSize ==
                                  scan / glob.gridSize))) {
                    grid[scan] = boxNum;
                    grid[boxStep] = num;
                    registered[boxNum] = true;
                    continue ROW_COL;
                  } else if (z == glob.gridSize - 1) {
                    //if z == 8, then break statement not reached: no candidates available
                    //Preferred adjacent swap (PAS)
                    //Swaps x for y (preference on unregistered numbers), finds occurrence of y
                    //and swaps with z, etc. until an unregistered number has been found
                    int searchingNo = num;

                    //noting the location for the blindSwaps to prevent infinite loops.
                    List<bool> blindSwapIndex =
                        List<bool>.filled(glob.gridLength, false);

                    //loop of size 18 to prevent infinite loops as well. Max of 18 swaps are possible.
                    //at the end of this loop, if continue or break statements are not reached, then
                    //fail-safe is executed called Advance and Backtrack Sort (ABS) which allows the
                    //algorithm to continue sorting the next row and column before coming back.
                    //Somehow, this fail-safe ensures success.
                    for (int q = 0; q < 2 * glob.gridSize; q++) {
                      SWAP:
                      for (int b = 0; b <= j; b++) {
                        int pacing = (a % 2 == 0
                            ? rowOrigin + b
                            : colOrigin + b * glob.gridSize);
                        if (grid[pacing] == searchingNo) {
                          int adjacentCell = -1;
                          int adjacentNo = -1;
                          int decrement = (a % 2 == 0 ? glob.gridSize : 1);

                          for (int c = 1;
                              c < glob.boxSize - (i % glob.boxSize);
                              c++) {
                            adjacentCell = pacing +
                                (a % 2 == 0 ? (c + 1) * glob.gridSize : c + 1);

                            //this creates the preference for swapping with unregistered numbers
                            if ((a % 2 == 0 &&
                                    adjacentCell >= glob.gridLength) ||
                                (a % 2 == 1 &&
                                    adjacentCell % glob.gridSize == 0)) {
                              adjacentCell -= decrement;
                            } else {
                              adjacentNo = grid[adjacentCell];
                              if (i % glob.boxSize != 0 ||
                                  c != 1 ||
                                  blindSwapIndex[adjacentCell] ||
                                  registered[adjacentNo]) {
                                adjacentCell -= decrement;
                              }
                            }
                            adjacentNo = grid[adjacentCell];

                            //as long as it hasn't been swapped before, swap it
                            if (!blindSwapIndex[adjacentCell]) {
                              blindSwapIndex[adjacentCell] = true;
                              grid[pacing] = adjacentNo;
                              grid[adjacentCell] = searchingNo;
                              searchingNo = adjacentNo;

                              if (!registered[adjacentNo]) {
                                registered[adjacentNo] = true;
                                continue ROW_COL;
                              }
                              break SWAP;
                            }
                          }
                        }
                      }
                    }

                    //begin Advance and Backtrack Sort (ABS)
                    backtrack = true;
                    break ROW_COL;
                  }
                }
              }
            }
          }
        }

        if (a % 2 == 0) {
          for (int j = 0; j < 9; j++) {
            //setting row as sorted
            sorted[i * 9 + j] = true;
          }
        } else if (!backtrack) {
          for (int j = 0; j < 9; j++) {
            //setting column as sorted
            sorted[i + j * 9] = true;
          }
        } else {
          //resetting sorted cells through to the last iteration
          backtrack = false;
          for (int j = 0; j < 9; j++) {
            sorted[i * 9 + j] = false;
          }
          for (int j = 0; j < 9; j++) {
            sorted[(i - 1) * 9 + j] = false;
          }
          for (int j = 0; j < 9; j++) {
            sorted[i - 1 + j * 9] = false;
          }
          i -= 2;
        }
      }
    }
  }

  /// Convert one-dimensional array to two-dimensional list
  List<List<String>> _convertArrayToList2D(List array) {
    List<List<String>> result = List.generate(
        glob.gridSize, (index) => List<String>.filled(glob.gridSize, ''),
        growable: false);

    int currIndex = 0;

    for (int y = 0; y < glob.gridSize; y++) {
      for (int x = 0; x < glob.gridSize; x++) {
        result[y][x] = array[currIndex++].toString();
      }
    }

    return result;
  }

  // code source: https://github.com/mfgravesjr/finished-projects/blob/master/SudokuGridGenerator/SudokuGridGenerator.java#L237
  bool _isSudokuValid(List grid) {
    //tests to see if the grid is valid

    //for every box
    for (int i = 0; i < glob.gridSize; i++) {
      List<bool> registered = List.filled(glob.gridSize + 1, false);
      registered[0] = true;
      int boxOrigin = (i * glob.boxSize) % glob.gridSize +
          ((i * glob.boxSize) ~/ glob.gridSize) * glob.boxLength;
      for (int j = 0; j < glob.gridSize; j++) {
        int boxStep = boxOrigin +
            (j ~/ glob.boxSize) * glob.gridSize +
            (j % glob.boxSize);
        int boxNum = grid[boxStep];
        registered[boxNum] = true;
      }
      for (bool b in registered) {
        if (!b) {
          return false;
        }
      }
    }

    //for every row
    for (int i = 0; i < glob.gridSize; i++) {
      List<bool> registered = List.filled(glob.gridSize + 1, false);
      registered[0] = true;
      int rowOrigin = i * glob.gridSize;
      for (int j = 0; j < glob.gridSize; j++) {
        int rowStep = rowOrigin + j;
        int rowNum = grid[rowStep];
        registered[rowNum] = true;
      }
      for (bool b in registered) {
        if (!b) {
          return false;
        }
      }
    }

    //for every column
    for (int i = 0; i < glob.gridSize; i++) {
      List<bool> registered = List.filled(glob.gridSize + 1, false);
      registered[0] = true;
      int colOrigin = i;
      for (int j = 0; j < glob.gridSize; j++) {
        int colStep = colOrigin + j * glob.gridSize;
        int colNum = grid[colStep];
        registered[colNum] = true;
      }
      for (bool b in registered) {
        if (!b) {
          return false;
        }
      }
    }

    return true;
  }
}
