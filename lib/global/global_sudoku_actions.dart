library global_sudoku_actions;

import 'package:sudoker/constants/app_constants.dart';
import 'package:sudoker/global/global_variables.dart' as glob;

bool hasDuplicates(int xPos, int yPos){
  List<String> registered;
  bool hasError = false;

  // horizontal
  registered = [];
  registered.add(glob.widgetGrid[yPos][0].number);
  for(int x = 1; x < glob.gridSize; x++){
    for(int i = 0; i < registered.length; i++){
      if(registered[i] != '' && registered[i] == glob.widgetGrid[yPos][x].number){
        for(int x = 0; x < glob.gridSize; x++){
          if(glob.widgetGrid[yPos][x].number == registered[i] && !glob.widgetGrid[yPos][x].untouchable){
            glob.widgetGrid[yPos][x].widget!.highlight(fieldErrorColor);
          }
        }

        hasError = true;
      }
    }

    registered.add(glob.widgetGrid[yPos][x].number);
  }

  // vertical
  registered = [];
  registered.add(glob.widgetGrid[0][xPos].number);
  for(int y = 1; y < glob.gridSize; y++){
    for(int i = 0; i < registered.length; i++){
      if(registered[i] != '' && registered[i] == glob.widgetGrid[y][xPos].number){
        for(int y = 0; y < glob.gridSize; y++){
          if(glob.widgetGrid[y][xPos].number == registered[i] && !glob.widgetGrid[y][xPos].untouchable){
            glob.widgetGrid[y][xPos].widget!.highlight(fieldErrorColor);
          }
        }

        hasError = true;
      }
    }

    registered.add(glob.widgetGrid[y][xPos].number);
  }

  // box
  int yBoxOrigin = yPos - yPos % glob.boxSize;
  int xBoxOrigin = xPos - xPos % glob.boxSize;
  registered = [];
  registered.add(glob.widgetGrid[yBoxOrigin][xBoxOrigin].number);
  for(int yb = yBoxOrigin; yb < yBoxOrigin + glob.boxSize; yb++){
    for(int xb = yb == yBoxOrigin ? xBoxOrigin + 1 : xBoxOrigin; xb < xBoxOrigin + glob.boxSize; xb++){
      for(int i = 0; i < registered.length; i++){
        if(registered[i] != '' && registered[i] == glob.widgetGrid[yb][xb].number){
          int yBoxOrigin = yPos - yPos % glob.boxSize;
          int xBoxOrigin = xPos - xPos % glob.boxSize;
          for(int yb = yBoxOrigin; yb < yBoxOrigin + glob.boxSize; yb++){
            for(int xb = xBoxOrigin; xb < xBoxOrigin + glob.boxSize; xb++){
              if(glob.widgetGrid[yb][xb].number == registered[i] && !glob.widgetGrid[yb][xb].untouchable){
                glob.widgetGrid[yb][xb].widget!.highlight(fieldErrorColor);
              }
            }
          }

          hasError = true;
        }
      }

      registered.add(glob.widgetGrid[yb][xb].number);
    }
  }

  return hasError;
}

void clearAllHints({bool ignoreHintShown = false}){
  if((!ignoreHintShown && (glob.hintShown || glob.errorOccurred)) || ignoreHintShown){
    for(int y = 0; y < glob.gridSize; y++){
      for(int x = 0; x < glob.gridSize; x++){
        glob.widgetGrid[y][x].widget!.resetColor();
      }
    }
  }
}