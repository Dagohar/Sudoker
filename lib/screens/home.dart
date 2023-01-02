import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoker/constants/app_constants.dart';
import 'package:sudoker/widgets/appbar.dart';
import 'package:sudoker/widgets/end_screen_confetti.dart';
import 'package:sudoker/widgets/sudoku_table.dart';
import 'package:sudoker/global/global_variables.dart' as glob;
import 'package:sudoker/global/global_sudoku_actions.dart' as sudoku_actions;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SudokuTable table = SudokuTable();

  _createNewTable(){
    EndScreenConfetti.stopConfetti();

    setState(() {
      table = SudokuTable();
    });
  }

  // clear player input
  _resetTable(){
    EndScreenConfetti.stopConfetti();

    for(int y = 0; y < glob.widgetGrid.length; y++){
      for(int x = 0; x < glob.widgetGrid[y].length; x++){
        if(!glob.widgetGrid[y][x].untouchable){
          glob.widgetGrid[y][x].widget!.reset();
        }
      }
    }

    // restore correct amount of free spaces
    glob.freeSpaceLeft = glob.freeSpaceAmount;
  }

  _showHint(){
    sudoku_actions.clearAllHints(ignoreHintShown: true);
    glob.hintShown = false;

    if(glob.freeSpaceLeft > 1){
      SEARCH : for(int y = Random().nextInt(glob.gridSize); y < glob.gridSize; y++){
        for(int x = Random().nextInt(glob.gridSize); x < glob.gridSize; x++){
          if(glob.widgetGrid[y][x].number == '' && !glob.hintShown){
            glob.hintShown = true;

            // highlight row and column
            for(int i = 0; i < glob.gridSize; i++){
              glob.widgetGrid[y][i].widget!.highlight(fieldHintedColor);
              glob.widgetGrid[i][x].widget!.highlight(fieldHintedColor);
            }

            // highlight box
            int yBoxOrigin = y - y % glob.boxSize;
            int xBoxOrigin = x - x % glob.boxSize;
            for(int yb = yBoxOrigin; yb < yBoxOrigin + glob.boxSize; yb++){
              for(int xb = xBoxOrigin; xb < xBoxOrigin + glob.boxSize; xb++){
                glob.widgetGrid[yb][xb].widget!.highlight(fieldHintedColor);
              }
            }

            // highlight center
            glob.widgetGrid[y][x].widget!.highlight(fieldCenterHintColor);
            glob.widgetGrid[y][x].widget!.fillCorrectNumber();

            sudoku_actions.hasDuplicates(x, y);
            break SEARCH;
          }
        }
      }

      if(!glob.hintShown){
        _showHint();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(onNew: _createNewTable, onReset: _resetTable, onHint: _showHint, context: context),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: table
          ),
          const EndScreenConfetti(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: GridView.count(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 5,
                children: const <Widget> [
                  SudokuButton(number: '1', containerChild: Text('1', style: buttonTextStyle)),
                  SudokuButton(number: '2', containerChild: Text('2', style: buttonTextStyle)),
                  SudokuButton(number: '3', containerChild: Text('3', style: buttonTextStyle)),
                  SudokuButton(number: '4', containerChild: Text('4', style: buttonTextStyle)),
                  SudokuButton(number: '5', containerChild: Text('5', style: buttonTextStyle)),
                  SudokuButton(number: '6', containerChild: Text('6', style: buttonTextStyle)),
                  SudokuButton(number: '7', containerChild: Text('7', style: buttonTextStyle)),
                  SudokuButton(number: '8', containerChild: Text('8', style: buttonTextStyle)),
                  SudokuButton(number: '9', containerChild: Text('9', style: buttonTextStyle)),
                  SudokuButton(number: '', containerChild: Icon(CupertinoIcons.multiply, color: appbarTextColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SudokuButton extends StatelessWidget {
  final String number;
  final Widget containerChild;

  const SudokuButton({Key? key, required this.number, required this.containerChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        glob.chosenNumber = number;
      },
      style: ElevatedButton.styleFrom(
        primary: secondaryColor,
        onPrimary: Colors.white,
        textStyle: bodyTextStyle,
      ),
      child: Center(child: containerChild),
    );
  }
}
