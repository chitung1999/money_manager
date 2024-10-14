import 'package:flutter/material.dart';
import '../common/drop_down.dart';
import '../common/enum.dart';
import '../common/notify.dart';
import '../database/database.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.month, required this.onRemove});

  final String month;
  final Function(String) onRemove;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final List<List<String>> _data = [];
  final List<bool> _isEdit = [];
  final List<String> _titles = ['Ngày', 'Tên', 'SP','Giá', 'Loại SD', 'Loại SP'];
  final List<double> _width = [1/8, 1/7, 1/5, 1/6, 1/7, 1/5];
  final List<String> _name = ['Tên','Tùng', 'Trúc'];
  final List<String> _typeItem = ['Loại SP','Ăn chính', 'Ăn vặt', 'Giải trí', 'Đồ dùng', 'Tiền phòng', 'Di chuyển', 'Khác'];
  final List<String> _typeUse = ['Loại SD','Chung', 'Riêng'];
  late String _filterName;
  late String _filterTypeItem;
  late String _filterTypeUse;

  void _onEdit(int? index) {
    for(int i = 0; i < _isEdit.length; i++) {
      _isEdit[i] = false;
    }
    if (index != null) _isEdit[index] = true;
    setState(() {});
  }

  void _onFilter() {
    _data.clear();
    _isEdit.clear();
    List<DataModel> data = database.getDataDetail(widget.month, _name.indexOf(_filterName), _typeItem.indexOf(_filterTypeItem), _typeUse.indexOf(_filterTypeUse));
    for (var item in data) {
      _data.add([
        item.day.toString(),
        _name[item.name.index + 1],
        item.item,
        item.price.toString(),
        _typeUse[item.useType.index + 1],
        _typeItem[item.itemType.index + 1]
      ]);
      _isEdit.add(false);
    }
    setState(() {});
  }

  @override
  void initState() {
    _filterName = _name[0];
    _filterTypeItem = _typeItem[0];
    _filterTypeUse = _typeUse[0];
    if(widget.month.isNotEmpty) {
      _onFilter();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropDown(
              width: width/4,
              data: _name,
              onSelected: (String str) {
                _filterName = str;
                _onFilter();
              }
            ),
            SizedBox(width: width/24),
            DropDown(
              width: width/3,
              data: _typeItem,
              onSelected: (String str) {
                _filterTypeItem = str;
                _onFilter();
              }
            ),
            SizedBox(width: width/24),
            DropDown(
              width: width/4,
              data: _typeUse,
              onSelected: (String str) {
                _filterTypeUse = str;
                _onFilter();
              }
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 40,
          color: Colors.blueGrey.withOpacity(0.3),
          child: Row(
            children: [
              for(int i = 0; i < _titles.length; i++)
                SizedBox(
                  width: _width[i] * width,
                  child:Center(child: Text(
                    _titles[i], style: const TextStyle(fontWeight: FontWeight.bold)
                  ))
                )
            ],
          ),
        ),
        Expanded(child: ListView(
          children: List.generate(
            _data.length, (index) => GestureDetector(
            onTap: () {_onEdit(null);},
            onLongPress: () {_onEdit(index);},
            child: Container(
              height: 40,
              decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey.withOpacity(0.2))),
              child: Stack(
                children: [
                  Row(
                    children: [for(int i = 0; i < 6; i++)
                      SizedBox(
                        width: _width[i] * width,
                        child: Center(child: Text(_data[index][i]))
                      )
                    ]
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    right: _isEdit[index] ? 0 : -150,
                    child: Container(
                      width: 150,
                      color: Colors.red,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white70),
                        onPressed: () async {
                          showWaitingProcess(context);
                          StatusApp ret = await database.removeData(widget.month, index);
                          Navigator.of(context).pop();
                          if (ret == StatusApp.SUCCESS) {
                            String month = '';
                            if(database.data[widget.month]!.isNotEmpty) {
                              month = widget.month;
                            } else {
                              List<String> months = database.getDataMonth();
                              months.remove(widget.month);
                              if(months.isNotEmpty) {
                                month = months[0];
                              }
                            }
                            widget.onRemove(month);
                            showNotify(context, true, 'Xoá dữ liệu thành công');
                          } else if (ret == StatusApp.REQUEST_RESET) {
                            showNotify(context, false, 'Vui lòng khởi động lại ứng dụng trước khi xoá dữ liệu!');
                          } else {
                            showNotify(context, false, 'Không thể xoá dữ liệu!');
                          }
                        }
                      ),
                    ),
                  ),
                ]
              )
            )
          ))
        ))
      ]
    );
  }
}
