import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../common/text_box_btn.dart';
import '../common/enum.dart';
import '../database/database.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.onAdd});

  final Function(String) onAdd;

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  DateTime _time = DateTime.now();
  final TextEditingController _item = TextEditingController();
  final TextEditingController _price = TextEditingController();
  int? indexName;
  int? indexUseType;
  int? indexItemType;
  OverlayEntry? _overlayEntry;
  Timer? _timer;

  void showNotify(BuildContext context, bool status, String msg) {
    _overlayEntry?.remove();
    _timer?.cancel();

    _overlayEntry = OverlayEntry(builder: (context) => Positioned(
      bottom: 60.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: status ? Colors.green[400] : Colors.red[400],
        child: Row(
          children: [
            Icon(status ? Icons.done : Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status ? 'SUCCESS' : 'ERROR',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, decoration: TextDecoration.none)
                  ),
                  const SizedBox(height: 5),
                  Text(
                    msg,
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal, decoration: TextDecoration.none),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));

    Overlay.of(context).insert(_overlayEntry!);

    _timer = Timer(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Center(
            child: Row(
              children: [
                const SizedBox(width: 100, child: Text('Thời gian', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(width: 30),
                Expanded(child: DatePickerWidget(
                  key: ValueKey(_time),
                  looping: true,
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime(2100, 1, 1),
                  initialDate: _time,
                  dateFormat: "dd/MM/yyyy",
                  onChange: (DateTime newDate, _) {
                    setState(() {_time = newDate;});
                  },
                  pickerTheme: const DateTimePickerTheme(
                    itemTextStyle: TextStyle(color: Colors.deepPurple, fontSize: 20, fontWeight: FontWeight.bold),
                    backgroundColor: Colors.transparent,
                    dividerColor: Colors.blueGrey,
                    dividerThickness: 3,
                    diameterRatio: 3,
                    dividerSpacing: 2,
                    squeeze: 0.8,
                  ),
                )),
                const SizedBox(width: 30)
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 100, child: Text('Tên', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Expanded(child: TextBoxBtn(
                title: 'Tùng',
                height: 40,
                radius: 5,
                bgColor: indexName == 0 ? Colors.deepPurple[100] : Colors.white,
                textColor: Colors.blueGrey,
                onPressed: () {setState(() {indexName = 0;});},
              )),
              const SizedBox(width: 30),
              Expanded(child: TextBoxBtn(
                title: 'Trúc',
                height: 40,
                radius: 5,
                bgColor: indexName == 1 ? Colors.deepPurple[100] : Colors.white,
                textColor: Colors.blueGrey,
                onPressed: () {setState(() {indexName = 1;});},
              )),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 100, child: Text('Sản phẩm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Expanded(
                child: TextField(
                  controller: _item,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey))
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 100, child: Text('Giá', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Expanded(
                child: TextField(
                  controller: _price,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey))
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 100, child: Text('Loại sử dụng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Expanded(child: TextBoxBtn(
                title: 'Chung',
                height: 40,
                radius: 5,
                bgColor: indexUseType == 0 ? Colors.deepPurple[100] : Colors.white,
                textColor: Colors.blueGrey,
                onPressed: () {setState(() {indexUseType = 0;});},
              )),
              const SizedBox(width: 30),
              Expanded(child: TextBoxBtn(
                title: 'Riêng',
                height: 40,
                radius: 5,
                bgColor: indexUseType == 1 ? Colors.deepPurple[100] : Colors.white,
                textColor: Colors.blueGrey,
                onPressed: () {setState(() {indexUseType = 1;});},
              )),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 100, child: Text('Loại sản phẩm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextBoxBtn(
                          title: 'Ăn chính',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 0 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 0;});},
                        )),
                        const SizedBox(width: 15),
                        Expanded(child: TextBoxBtn(
                          title: 'Ăn vặt',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 1 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 1;});},
                        )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextBoxBtn(
                          title: 'Giải trí',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 2 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 2;});},
                        )),
                        const SizedBox(width: 15),
                        Expanded(child: TextBoxBtn(
                          title: 'Đồ dùng',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 3 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 3;});},
                        )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextBoxBtn(
                          title: 'Tiền phòng',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 4 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 4;});},
                        )),
                        const SizedBox(width: 15),
                        Expanded(child: TextBoxBtn(
                          title: 'Di chuyển',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 5 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 5;});},
                        )),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: TextBoxBtn(
                          title: 'Khác',
                          height: 40,
                          radius: 5,
                          bgColor: indexItemType == 6 ? Colors.deepPurple[100] : Colors.white,
                          textColor: Colors.blueGrey,
                          textSize: 13,
                          onPressed: () {setState(() {indexItemType = 6;});},
                        )),
                        const SizedBox(width: 30),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(child: TextBoxBtn(
                title: 'Huỷ',
                height: 40,
                radius: 5,
                bgColor: Colors.white,
                textColor: Colors.blueGrey,
                onPressed: () {
                  setState(() {
                    _time = DateTime.now();
                    _item.text = '';
                    _price.text = '';
                    indexName = null;
                    indexUseType = null;
                    indexItemType = null;
                  });
                },
              )),
              const SizedBox(width: 30),
              Expanded(child: TextBoxBtn(
                title: 'Thêm',
                height: 40,
                radius: 5,
                onPressed: () async {
                  if(_item.text.isEmpty || _price.text.isEmpty || indexName == null ||
                      indexUseType == null || indexItemType == null) {
                    showNotify(context, false, 'Một số trường trống!');
                  } else {
                    try {
                      int price = int.parse(_price.text);
                      String month = '${_time.month.toString().padLeft(2, '0')}/${_time.year}';
                      DataModel item = DataModel(_time.day, Member.values[indexName!], _item.text, ItemType.values[indexItemType!], UseType.values[indexUseType!], price);
                      StatusApp ret = await database.addData(month, item);
                      if(ret == StatusApp.SUCCESS) {
                        widget.onAdd(month);
                        showNotify(context, true, 'Thêm dữ liệu thành công');
                      } else {showNotify(context, false, xxxxx);

                        // showNotify(context, false, 'Không thể thêm dữ liệu!');
                      }
                    } catch (e) {
                      showNotify(context, false, xxxxx);
                      // showNotify(context, false, 'Giá không hợp lệ!');
                    }
                  }
                },
              )),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
