import 'package:sudoker/global/global_variables.dart' as glob;
import 'package:sudoker/global/global_sudoku_actions.dart' as sudoku_actions;

class SudokuChecker{
  final List table;

  SudokuChecker(this.table);
  SudokuChecker.global() : table = [];

  bool isValidField(int xPos, int yPos, String chosenNumber) {
    bool checkBox(int xInput, int yInput){
      for(int y = yInput; y < yInput + glob.boxSize; y++){
        for(int x = xInput; x < xInput + glob.boxSize; x++) {
          if(table[y][x] == chosenNumber){
            return false;
          }
        }
      }

      return true;
    }

    if(chosenNumber == ''){
      return true;
    }

    // Check horizontal line
    for(int x = 0; x < glob.gridSize; x++){
      if(table[yPos][x] == chosenNumber){
        return false;
      }
    }

    // Check vertical line
    for(int y = 0; y < glob.gridSize; y++){
      if(table[y][xPos] == chosenNumber){
        return false;
      }
    }

    return checkBox(
        (xPos / glob.boxSize).floor() * glob.boxSize,
        (yPos / glob.boxSize).floor() * glob.boxSize
    );
  }

  /// Works only for widgetGrid
  bool isPlayerInputValid(int x, int y){
    return !glob.widgetGrid[y][x].untouchable && _isValidFieldForGlobal(x, y);
  }

  /// Works only for widgetGrid
  bool _isValidFieldForGlobal(int xPos, int yPos){
    bool checkBox(int xInput, int yInput){
      for(int y = yInput; y < yInput + glob.boxSize; y++){
        for(int x = xInput; x < xInput + glob.boxSize; x++) {
          if(glob.widgetGrid[y][x].number == glob.chosenNumber){
            return false;
          }
        }
      }

      return true;
    }

    if(glob.chosenNumber == ''){
      return true;
    }

    // Check horizontal line
    for(int x = 0; x < glob.gridSize; x++){
      if(glob.widgetGrid[yPos][x].number == glob.chosenNumber){
        return false;
      }
    }

    // Check vertical line
    for(int y = 0; y < glob.gridSize; y++){
      if(glob.widgetGrid[y][xPos].number == glob.chosenNumber){
        return false;
      }
    }

    return checkBox(
        (xPos / glob.boxSize).floor() * glob.boxSize,
        (yPos / glob.boxSize).floor() * glob.boxSize
    );
  }

  /// Works only for widgetGrid
  bool isSudokuCompleted(){
    // Check for duplicate numbers
    bool hasErrors = false;

    if(glob.freeSpaceLeft <= 0){
      for(int y = 0; y < glob.gridSize; y++){
        for(int x = 0; x < glob.gridSize; x++){
          if(sudoku_actions.hasDuplicates(x, y)){
            hasErrors = true;
          }
        }
      }
    }

    glob.errorOccurred = hasErrors;

    return glob.freeSpaceLeft <= 0 && !hasErrors;
  }
}
