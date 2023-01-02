import 'package:flutter/material.dart';
import 'package:sudoker/constants/app_constants.dart';
import 'package:sudoker/utilities/sudoku_checker.dart';
import 'package:sudoker/global/global_variables.dart' as glob;
import 'package:sudoker/global/global_sudoku_actions.dart' as sudoku_actions;
import 'package:sudoker/widgets/end_screen_confetti.dart';

class SudokuFieldDetails{
  String number;
  bool untouchable;
  SudokuField? widget;

  SudokuFieldDetails(this.number, this.untouchable, this.widget);
}

class SudokuField extends StatefulWidget {
  final int x, y;
  final String value;
  final Stream stream;

  late Function reset;
  late Function resetColor;
  late Function highlight;
  late Function fillCorrectNumber;

  SudokuField({Key? key, required this.x, required this.y, required this.value, required this.stream}) : super(key: key);

  @override
  _SudokuFieldState createState() => _SudokuFieldState();
}

class _SudokuFieldState extends State<SudokuField> {
  late SudokuFieldDetails _details;
  late String _value;
  late Color _bgColor;
  late SudokuChecker _checker;

  assignNumberToField(String num){
    setState(() {
      sudoku_actions.clearAllHints();

      if(!_details.untouchable){
        _value = num;

        // if you're not changing a number for a different number or trying
        // to delete an already empty field then
        // check if you are either removing or assigning a number
        if((_details.number != '' && num == '') || (_details.number == '' && num != '')){
          glob.freeSpaceLeft += num == '' ? 1 : -1;
        }

        // update the global widget grid and this field details info
        glob.widgetGrid[widget.y][widget.x] = SudokuFieldDetails(
            _value, false, widget
        );
        _details = glob.widgetGrid[widget.y][widget.x];
      }
    });
  }

  refresh(){
    setState(() {
      widget.reset = reset;
      widget.resetColor = resetBackgroundColor;
      widget.highlight = highlight;
      widget.fillCorrectNumber = fillCorrectNumber;

      _details = glob.widgetGrid[widget.y][widget.x];
      _value = widget.value;
      _bgColor = _value == '' ? fieldTouchableColor : fieldUntouchableColor;
    });
  }

  reset(){
    assignNumberToField('');
  }

  resetBackgroundColor(){
    setState(() {
      _bgColor = _details.untouchable ? fieldUntouchableColor : fieldTouchableColor;
    });
  }

  highlight(Color color){
    setState(() {
      _bgColor = color;
    });
  }

  /// Only for hints!
  fillCorrectNumber(){
    setState(() {
      _value = glob.completeGrid[widget.y][widget.x];
      glob.widgetGrid[widget.y][widget.x].number = _value;
      glob.freeSpaceLeft--;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((_){
      refresh();
    });

    refresh();
    _checker = SudokuChecker.global();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        if(_checker.isPlayerInputValid(widget.x, widget.y)){
          setState(() {
            assignNumberToField(glob.chosenNumber);

            if(_checker.isSudokuCompleted()){
              EndScreenConfetti.playConfetti();
              ScaffoldMessenger.of(context).showSnackBar(sudokuCompletedSnackbar);
            }
            else{
              EndScreenConfetti.stopConfetti();
            }
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: _bgColor,
        onPrimary: Colors.white,
        elevation: 0,
        shape: const ContinuousRectangleBorder()
      ),
      child: Center(child: Text(_value, style: bodyTextStyle)),
    );
  }
}

