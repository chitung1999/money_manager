import 'package:flutter/material.dart';
import '../common/enum.dart';
import '../database/database.dart';
import '../common/bar_chart.dart';
import '../common/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.month});

  final String month;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> _dataBarChart = [0,0,0,0];
  List<int> _dataPieChartTogether = [0,0,0,0,0,0,0];
  List<int> _dataPieChartTung = [0,0,0,0,0,0,0];
  List<int> _dataPieChartTruc = [0,0,0,0,0,0,0];

  @override
  void initState() {
    if(widget.month.isNotEmpty) {
      _dataBarChart = database.getDataOverviewChart(widget.month);
      _dataPieChartTogether = database.getDataPieChart(widget.month, UseType.TOGETHER, null);
      _dataPieChartTung = database.getDataPieChart(widget.month, UseType.SEPARATELY, Member.TUNG);
      _dataPieChartTruc = database.getDataPieChart(widget.month, UseType.SEPARATELY, Member.TRUC);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          BarChartApp(data: _dataBarChart),
          const Text('Tổng quan chi tiêu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 100),
          PieChartApp(data: _dataPieChartTogether),
          const SizedBox(height: 10),
          const Text('Chi tiêu chung', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 100),
          PieChartApp(data: _dataPieChartTung),
          const SizedBox(height: 10),
          const Text('Chi tiêu của Tùng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 100),
          PieChartApp(data: _dataPieChartTruc),
          const SizedBox(height: 10),
          const Text('Chi tiêu của Trúc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
