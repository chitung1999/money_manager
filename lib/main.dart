import 'package:flutter/material.dart';
import 'common/enum.dart';
import 'common/notify.dart';
import 'module/detail.dart';
import 'common/drop_down.dart';
import 'database/database.dart';
import 'module/add_item.dart';
import 'module/home.dart';

void main() async {
  runApp(const MoneyManager());
}

class MoneyManager extends StatelessWidget {
  const MoneyManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Roboto'),
      home: TheApp(),
    );
  }
}

class TheApp extends StatefulWidget {
  const TheApp({super.key});

  @override
  _TheAppState createState() => _TheAppState();
}

class _TheAppState extends State<TheApp> {
  late int _currentIndex;
  late String _currentMonth;
  late List<String> _listMonth;
  late Future<StatusApp> _initBuilder;

  void _onModify(String month) {
    setState(() {
      _initBuilder = _initData();
      if(_currentMonth != month) {
        _currentMonth = month;
      }
      _currentIndex = 1;
    });
  }

  Future<StatusApp> _initData() async {
    StatusApp ret = await database.initialize();
    _listMonth = database.getDataMonth();
    return ret;
  }

  void _showResultInit() async {
    StatusApp status = await _initBuilder;
    _currentMonth = _listMonth.isEmpty ? '' : _listMonth[0];
    if (status != StatusApp.SUCCESS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorInitData(context, status);
      });
    }
  }

  @override
  void initState() {
    _currentIndex = 0;
    _initBuilder = _initData();
    _showResultInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initBuilder,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Money', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text('manager', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff355C7D), Color(0xff6C5B7B), Color(0xffC06C84)],
                      stops: [0, 0.5, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                actions: [
                  DropDown(
                      key: ValueKey(_currentMonth),
                      data: _listMonth,
                      currentValue: _currentMonth,
                      onSelected: (String month) {
                        setState(() {_currentMonth = month;});
                      }
                  ),
                  const SizedBox(width: 20)
                ],
              ),
              body: IndexedStack(
                index: _currentIndex,
                children: [
                  Home(key: ValueKey(_currentMonth), month: _currentMonth),
                  Detail(key: ValueKey(_currentMonth), month: _currentMonth, onRemove: _onModify),
                  AddItem(onAdd: _onModify),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: (index) {setState(() {_currentIndex = index;});},
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tổng quan'),
                    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Chi tiết'),
                    BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Thêm'),
                  ]
              )
            );
          } else {
            return Center(child: const CircularProgressIndicator());
          }
      }
    );
  }
}