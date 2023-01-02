import 'package:flutter/material.dart';
import 'package:sudoker/constants/app_constants.dart';
import 'package:sudoker/widgets/dropdown_list.dart';
import 'package:sudoker/global/global_variables.dart' as glob;

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final Function onNew;
  final Function onReset;
  final Function onHint;

  const MyAppbar({Key? key, required this.onNew, required this.onReset, required this.onHint, required this.context}) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  // opens a dialog box in the center of the screen
  Future openDialog(String title, List<TextButton> options) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: Text(title, style: bodyTextStyle)),
      actions: options,
    ),
  );
  Future openDialogWithContent(String title, Widget content, List<TextButton> options) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Center(child: Text(title, style: bodyTextStyle)),
      content: content,
      actions: options,
    ),
  );

  submit(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Sudoker', style: appbarTextStyle),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget> [
              FloatingActionButton(
                onPressed: () => onHint(),
                child: const Icon(Icons.lightbulb),
              ),
              FloatingActionButton(
                onPressed: () => openDialog(
                  'Wyczyścić tablicę?',
                  <TextButton> [
                    TextButton(
                      onPressed: submit,
                      child: const Text('Anuluj', style: bodyTextStyle),
                    ),
                    TextButton(
                      onPressed: (){
                        onReset();
                        submit();
                      },
                      child: const Text('Wyczyść', style: bodyTextStyle),
                    ),
                  ]
                ),
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () => openDialogWithContent(
                    'Stworzyć nową tablicę?',
                    Container(
                      decoration: mediumBoxBorder,
                      child: Center(
                        widthFactor: 0.75,
                        heightFactor: 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('Trudność: ', style: bodyTextStyle),
                            DropdownList(
                              defaultValue: 'Średni',
                              getValue: (value){
                                switch(value){
                                  case 'Łatwy': glob.freeSpaceAmount = glob.Difficulty.Easy; break;
                                  case 'Średni': glob.freeSpaceAmount = glob.Difficulty.Medium; break;
                                  case 'Trudny': glob.freeSpaceAmount = glob.Difficulty.Hard; break;
                                }
                              },
                              items: <String>['Łatwy', 'Średni', 'Trudny']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: bodyTextStyle),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    <TextButton> [
                      TextButton(
                        onPressed: submit,
                        child: const Text('Anuluj', style: bodyTextStyle),
                      ),
                      TextButton(
                        onPressed: (){
                          onNew();
                          submit();
                        },
                        child: const Text('Stwórz', style: bodyTextStyle),
                      ),
                    ]
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
      backgroundColor: secondaryColor,
    );
  }
}
