import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartApp extends StatefulWidget {
  const BarChartApp({super.key, required this.data});

  final List<int> data;
  @override
  _BarChartAppState createState() => _BarChartAppState();
}

class _BarChartAppState extends State<BarChartApp> {
  late List<BarChartGroupData> barGroups;

  double max() {
    int max = 0;
    for(var val in widget.data) {
      if (val > max) {
        max = val;
      }
    }
    return max.toDouble();
  }

  @override
  void initState() {
    barGroups = [
      makeGroupData(0, widget.data[0].toDouble(), widget.data[1].toDouble()),
      makeGroupData(1, widget.data[2].toDouble(), widget.data[3].toDouble()),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 7/6,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Tiêu riêng  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                width: 20, height: 10,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xfff4791f), Color(0xff659999)],
                    stops: [0, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              SizedBox(width: 40),
              const Text('Tổng tiêu chung  ', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                width: 20, height: 10,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff4e4376), Color(0xff2b5876)],
                    stops: [0, 1],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Text('  : ${widget.data[1] + widget.data[3]}K'),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: max() * 1.2,
                backgroundColor: const Color(0xFF311B92).withOpacity(0.1),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                        ) {
                      return BarTooltipItem(
                          '${rod.toY.toInt().toString()}K',
                          const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.deepPurple)
                ),
                barGroups: barGroups,
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 5,
        child: Text(value.toInt() == 0 ? 'Tùng' : 'Trúc', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepPurple))
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 20,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          width: 40,
          borderRadius: BorderRadius.circular(0),
          gradient: const LinearGradient(
            colors: [Color(0xfff4791f), Color(0xff659999)],
            stops: [0, 1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        BarChartRodData(
            toY: y2,
            width: 40,
            borderRadius: BorderRadius.circular(0),
            gradient: const LinearGradient(
              colors: [Color(0xff4e4376), Color(0xff2b5876)],
              stops: [0, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )
        )
      ],
      showingTooltipIndicators: [0,1],
    );
  }
}