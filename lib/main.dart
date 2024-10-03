import 'package:flutter/material.dart';
import 'module/detail.dart';
import 'common/drop_down.dart';
import 'database/database.dart';
import 'module/add_item.dart';
import 'module/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.initialize();
  runApp(const TheApp());
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

  Future<void> reloadApp() async {}

  void loadMonth() {
    _listMonth = [];
    _listMonth = database.data.keys.toList();
    _listMonth.sort((a, b) => b.substring(0,2).compareTo(a.substring(0,2)));
    _listMonth.sort((a, b) => b.substring(3).compareTo(a.substring(3)));
  }

  @override
  void initState() {
    _currentIndex = 0;
    loadMonth();
    _currentMonth = _listMonth.isEmpty ? '' : _listMonth[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, fontFamily: 'Roboto'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Money Manager', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
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
        body: FutureBuilder<void>(
          future: reloadApp(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return IndexedStack(
                index: _currentIndex,
                children: [
                  Home(key: ValueKey(_currentMonth), month: _currentMonth),
                  Detail(key: ValueKey(_currentMonth), month: _currentMonth),
                  AddItem(onAdd: (String month) {
                    setState(() {
                      if(_currentMonth != month) {
                        loadMonth();
                        _currentMonth = month;
                      }
                      _currentIndex = 1;
                    });
                    reloadApp();
                  }),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
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
      )
    );
  }
}