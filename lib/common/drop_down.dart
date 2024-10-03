import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DropDown extends StatefulWidget {
  const DropDown({super.key, required this.onSelected, required this.data, this.width = 150, this.currentValue});

  final List<String> data;
  final String? currentValue;
  final double width;
  final Function(String) onSelected;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _value = '';

  @override
  void initState() {
    if(widget.currentValue != null) {
      _value = widget.currentValue!;
    } else {
      if(widget.data.isNotEmpty) {
        _value = widget.data[0];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      value: _value,
      isDense: true,
      buttonStyleData: ButtonStyleData(
        height: 35,
        width: widget.width,
        padding: const EdgeInsets.only(left: 15, right: 5),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: WidgetStateProperty.all<double>(6),
          thumbVisibility: WidgetStateProperty.all<bool>(true),
        ),
      ),
      items: widget.data.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));}
      ).toList(),
      onChanged: (String? value) {
        setState(() {
          _value = value!;
          widget.onSelected(_value);
        });
      },
    );
  }
}
