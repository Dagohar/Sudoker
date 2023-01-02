import 'package:flutter/material.dart';

const Color mainColor = Colors.white;
const Color secondaryColor = Colors.blueAccent;

const Color fieldUntouchableColor = Colors.black12;
const Color fieldTouchableColor = Colors.transparent;
const Color fieldHintedColor = Colors.black38;
const Color fieldCenterHintColor = Colors.black54;
const Color fieldErrorColor = Colors.redAccent;

const Color appbarTextColor = Colors.white;
const Color bodyTextColor = Colors.black;

const TextStyle appbarTextStyle = TextStyle(
  fontSize: 24,
  color: appbarTextColor,
);
const TextStyle bodyTextStyle = TextStyle(
  fontSize: 20,
  color: bodyTextColor,
);
const TextStyle buttonTextStyle = TextStyle(
  fontSize: 20,
  color: appbarTextColor,
);

final BoxDecoration lightBoxBorder = BoxDecoration(
  border: Border.all(color: Colors.black, width: 0.25),
);
final BoxDecoration mediumBoxBorder = BoxDecoration(
  border: Border.all(color: Colors.black, width: 1),
);
const BoxDecoration heavyBoxBorderTop = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black, width: 2),
    left: BorderSide(color: Colors.black, width: 0.25),
    right: BorderSide(color: Colors.black, width: 0.25),
    bottom: BorderSide(color: Colors.black, width: 0.25),
  ),
);
const BoxDecoration heavyBoxBorderLeft = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black, width: 0.25),
    left: BorderSide(color: Colors.black, width: 2),
    right: BorderSide(color: Colors.black, width: 0.25),
    bottom: BorderSide(color: Colors.black, width: 0.25),
  ),
);
const BoxDecoration heavyBoxBorderTopLeft = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.black, width: 2),
    left: BorderSide(color: Colors.black, width: 2),
    right: BorderSide(color: Colors.black, width: 0.25),
    bottom: BorderSide(color: Colors.black, width: 0.25),
  ),
);

const SnackBar sudokuCompletedSnackbar = SnackBar(
  behavior: SnackBarBehavior.fixed,
    dismissDirection: DismissDirection.up,
    content: Text(
      'Pomyślnie rozwiązałeś/aś sudoku. Brawo!',
      style: buttonTextStyle,
    )
);
