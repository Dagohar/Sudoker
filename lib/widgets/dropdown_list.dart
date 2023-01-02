import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  final List<DropdownMenuItem> items;
  final dynamic defaultValue;
  final Function getValue;

  DropdownList({Key? key, required this.items, required this.defaultValue, required this.getValue}) : super(key: key);

  @override
  _DropdownListState createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  dynamic _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: _dropdownValue,
      onChanged: (newValue){
        setState(() {
          _dropdownValue = newValue;
          widget.getValue(_dropdownValue);
        });
      },
      items: widget.items
    );
  }
}
