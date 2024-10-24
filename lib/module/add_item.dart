import 'package:flutter/material.dart';
import '../common/notify.dart';
import '../common/text_box_btn.dart';
import '../common/enum.dart';
import '../common/date_picker.dart';
import '../database/database.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key, required this.onAdd});

  final Function(String) onAdd;

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  DateTime _date = DateTime.now();
  final TextEditingController _item = TextEditingController();
  final TextEditingController _price = TextEditingController();
  int? indexName;
  int? indexUseType;
  int? indexItemType;

  _resetData() {
    setState(() {
      _date = DateTime.now();
      _item.text = '';
      _price.text = '';
      indexName = null;
      indexUseType = null;
      indexItemType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          DatePicker(onDateChanged: (date){setState(() {_date = date;});}),
          const SizedBox(height: 50),
          TextField(
            controller: _item,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Nhập tên sản phẩm',
              hintStyle: TextStyle(fontSize: 17, color: Colors.black38),
              labelText: 'Sản phẩm',
              labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
          const SizedBox(height: 50),
          TextField(
            controller: _price,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: 'Nhập giá sản phẩm',
              hintStyle: TextStyle(fontSize: 17, color: Colors.black38),
              labelText: 'Giá',
              labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
          const SizedBox(height: 50),
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Người mua',
              labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
            child: Row(
              children: [
                Expanded(child: TextBoxBtn(
                  title: 'Tùng',
                  height: 40,
                  radius: 5,
                  bgColor: indexName == 0 ? Colors.deepPurple[100] : Colors.white,
                  textColor: Colors.blueGrey,
                  outlineColor: Colors.blueGrey,
                  onPressed: () {setState(() {indexName = 0;});},
                )),
                const SizedBox(width: 30),
                Expanded(child: TextBoxBtn(
                  title: 'Trúc',
                  height: 40,
                  radius: 5,
                  bgColor: indexName == 1 ? Colors.deepPurple[100] : Colors.white,
                  textColor: Colors.blueGrey,
                  outlineColor: Colors.blueGrey,
                  onPressed: () {setState(() {indexName = 1;});},
                )),
              ],
            ),
          ),
          const SizedBox(height: 50),
          InputDecorator(
            decoration: InputDecoration(
                labelText: 'Loại sử dụng',
                labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
            child: Row(
              children: [
                Expanded(child: TextBoxBtn(
                  title: 'Chung',
                  height: 40,
                  radius: 5,
                  bgColor: indexUseType == 0 ? Colors.deepPurple[100] : Colors.white,
                  textColor: Colors.blueGrey,
                  outlineColor: Colors.blueGrey,
                  onPressed: () {setState(() {indexUseType = 0;});},
                )),
                const SizedBox(width: 30),
                Expanded(child: TextBoxBtn(
                  title: 'Riêng',
                  height: 40,
                  radius: 5,
                  bgColor: indexUseType == 1 ? Colors.deepPurple[100] : Colors.white,
                  textColor: Colors.blueGrey,
                  outlineColor: Colors.blueGrey,
                  onPressed: () {setState(() {indexUseType = 1;});},
                )),
              ],
            ),
          ),
          const SizedBox(height: 50),
          InputDecorator(
            decoration: InputDecoration(
                labelText: 'Loại sản phẩm',
                labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
            child: Row(
              children: [
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
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
                            onPressed: () {setState(() {indexItemType = 0;});},
                          )),
                          const SizedBox(width: 15),
                          Expanded(child: TextBoxBtn(
                            title: 'Ăn vặt',
                            height: 40,
                            radius: 5,
                            bgColor: indexItemType == 1 ? Colors.deepPurple[100] : Colors.white,
                            textColor: Colors.blueGrey,
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
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
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
                            onPressed: () {setState(() {indexItemType = 2;});},
                          )),
                          const SizedBox(width: 15),
                          Expanded(child: TextBoxBtn(
                            title: 'Đồ dùng',
                            height: 40,
                            radius: 5,
                            bgColor: indexItemType == 3 ? Colors.deepPurple[100] : Colors.white,
                            textColor: Colors.blueGrey,
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
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
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
                            onPressed: () {setState(() {indexItemType = 4;});},
                          )),
                          const SizedBox(width: 15),
                          Expanded(child: TextBoxBtn(
                            title: 'Di chuyển',
                            height: 40,
                            radius: 5,
                            bgColor: indexItemType == 5 ? Colors.deepPurple[100] : Colors.white,
                            textColor: Colors.blueGrey,
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
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
                            outlineColor: Colors.blueGrey,
                            textSize: 15,
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
                onPressed: () {_resetData();},
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
                  } else if (_item.text.contains('|')) {
                    showNotify(context, false, 'Sản phẩm không thể chứa kí tự "|"');
                  } else {
                    try {
                      int price = int.parse(_price.text);
                      String month = '${_date.month.toString().padLeft(2, '0')}/${_date.year}';
                      DataModel item = DataModel(_date.day, Member.values[indexName!], _item.text, ItemType.values[indexItemType!], UseType.values[indexUseType!], price);
                      showWaitingProcess(context);
                      StatusApp ret = await database.addData(month, item);
                      Navigator.of(context).pop();
                      if(ret == StatusApp.SUCCESS) {
                        widget.onAdd(month);
                        _resetData();
                        showNotify(context, true, 'Thêm dữ liệu thành công');
                      } else if (ret == StatusApp.REQUEST_RESET) {
                        showNotify(context, false, 'Vui lòng khởi động lại ứng dụng trước khi thêm dữ liệu!');
                      } else {
                        showNotify(context, false, 'Không thể thêm dữ liệu!');
                      }
                    } catch (e) {
                      showNotify(context, false, 'Giá không hợp lệ!');
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
