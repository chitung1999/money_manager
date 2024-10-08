import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key, required this.onDateChanged});

  final Function(DateTime) onDateChanged;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final EasyInfiniteDateTimelineController _controller = EasyInfiniteDateTimelineController();
  DateTime? _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return EasyInfiniteDateTimeLine(
      selectionMode: const SelectionMode.autoCenter(),
      controller: _controller,
      firstDate: DateTime(2024),
      focusDate: _date,
      lastDate: DateTime(2030, 12, 31),
      onDateChange: (date) {
        setState(() {_date = date;});
        widget.onDateChanged(date);
        },
      dayProps: EasyDayProps(width: width/9.5, height: width/9.5),
      headerBuilder: (BuildContext context, DateTime date) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thời gian', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                Text(
                  '${_date!.day}/${_date!.month}/${_date!.year}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepPurple)
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        );
      },
      itemBuilder: (BuildContext context, DateTime date, bool isSelected, VoidCallback onTap) {
        return InkResponse(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor:
            isSelected ? Colors.deepPurple : Colors.deepPurple[100],
            radius: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black45),
                  ),
                ),
                Flexible(
                  child: Text(
                    EasyDateFormatter.shortDayName(date, "en_US"),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}