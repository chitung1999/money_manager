import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartApp extends StatefulWidget {
  const PieChartApp({super.key, required this.data});

  final List<int> data;

  @override
  _PieChartAppState createState() => _PieChartAppState();
}

class _PieChartAppState extends State<PieChartApp> {
  final List<Color?> _color = [Colors.red[900], Colors.blue[900],Colors.yellow[900], Colors.green[900], Colors.deepPurple[900], Colors.grey[900], Colors.pink[900]];
  final List<String> _title = ['Ăn chính', 'Ăn vặt', 'Giải trí', 'Đồ dùng', 'Tiền phòng', 'Di chuyển', 'Khác'];
  int _sum = 0;

  String getTitle(int value) {
    if(_sum == 0) return '';

    int temp = 100 * value~/_sum;
    return temp >= 4 ? ('$temp%') : '';
  }

  @override
  void initState() {
    for(int val in widget.data) {_sum += val;}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 30,
                sections: _sum > 0 ? showingSections() :
                [
                  PieChartSectionData(
                    color: Colors.grey,
                    value: 1,
                    title: '0%',
                    radius: 60,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(child: Column(
          children: List.generate(7, (index) => Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    width: 15, height: 15, color: _color[index],
                  ),
                  Expanded(
                    child: SizedBox(child: Text('  ${_title[index]}: ${widget.data[index]}K')),
                  )
                ],
              ),
              const SizedBox(height: 3)
            ],
          )),
        )),
      ]
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(7, (index) => PieChartSectionData(
      color: _color[index],
      value: widget.data[index].toDouble(),
      title: getTitle(widget.data[index]),
      radius: 60,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
    ));
  }
}