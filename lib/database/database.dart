import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:path_provider/path_provider.dart';
import '../common/enum.dart';

Database database = Database();
Client client = Client();
Databases databases = Databases(client);
String xxxxx = '';

class DataModel {
  late int day;
  late Member name;
  late String item;
  late ItemType itemType;
  late UseType useType;
  late int price;

  DataModel(int d, Member n, String i, ItemType iT, UseType uT, int p) {
    day = d;
    name = n;
    item = i;
    itemType = iT;
    useType = uT;
    price = p;
  }
}

class Database {
  Database._internal();
  static final Database _instance = Database._internal();
  factory Database() {
    return _instance;
  }

  Map<String, List<DataModel>> data = {};

  Future<StatusApp> initialize() async {
    try {
      client.setEndpoint('https://cloud.appwrite.io/v1').setProject('66fd5db5001845b85a99').setSelfSigned(status: true);

      var response = await databases.listDocuments(
        databaseId: '66fd5e4c001b5722c3a4',
        collectionId: '66fd5e670026f81adec9',
      );
      Map<String, String> strData = {};
      for (var document in response.documents) {
        strData[document.data['month']] = document.data['data'];
      }

      StatusApp ret = loadData(strData);
      if(ret == StatusApp.SUCCESS) {
        await writeFileLocal(strData);
        return ret;
      }
    } catch(e) {
      print('Connection to Appwrite failed: $e');
    }

    try {
      Map<String, dynamic> dynamicData = await readFileLocal();
      Map<String, String> strData = dynamicData.map((key, value) {
        return MapEntry(key, value.toString());
      });
      StatusApp ret = loadData(strData);
      return ret;
    } catch(e) {
      print('Real file local failed: $e');
      return StatusApp.ERROR;
    }
  }

  Future<Map<String, dynamic>> readFileLocal() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/money_database.json');
      final data = await file.readAsString();
      return jsonDecode(data);
    } catch (e) {
      print('Fail to read file local: $e');
      return {};
    }
  }

  Future<StatusApp> writeFileLocal(Map<String,dynamic> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/money_database.json');
      final str = jsonEncode(data);
      await file.writeAsString(str);
      return StatusApp.SUCCESS;
    } catch(e) {
      print('Fail to write file local: $e');
      return StatusApp.ERROR;
    }
  }

  StatusApp loadData(Map<String, String> strData) {
    try{
      for(var key in strData.keys.toList()) {
        String strMonth = strData[key]!;
        List<String> strItem = strMonth.split('\n');
        List<DataModel> dataMonth = [];
        for(String value in strItem) {
          if(value.isEmpty) {
            continue;
          }
          List<String> l = value.split(',');
          dataMonth.add(DataModel(int.parse(l[0]), Member.values[int.parse(l[1])],
              l[2], ItemType.values[int.parse(l[3])], UseType.values[int.parse(l[4])], int.parse(l[5])));
        }
        data[key] = dataMonth;
      }
      return StatusApp.SUCCESS;
    } catch(e) {
      print('Fail to load data: $e');
      return StatusApp.ERROR ;
    }
  }

  List<int> getDataOverviewChart(String month) {
    int togTung = 0;
    int sepTung = 0;
    int togTruc = 0;
    int sepTruc = 0;
    List<DataModel> dataMonth = data[month]!;
    for(var item in dataMonth) {
      if(item.name == Member.TUNG) {
        item.useType == UseType.TOGETHER ? (togTung += item.price) : (sepTung += item.price);
      } else {
        item.useType == UseType.TOGETHER ? (togTruc += item.price) : (sepTruc += item.price);
      }
    }
    return [sepTung, togTung, sepTruc, togTruc];
  }

  List<int> getDataPieChart(String month, UseType useType, Member? member) {
    int food = 0;
    int snack = 0;
    int entertainment = 0;
    int thing = 0;
    int home = 0;
    int travel = 0;
    int other = 0;
    List<DataModel> dataMonth = data[month]!;
    for(var item in dataMonth) {
      if((useType == UseType.TOGETHER && item.useType == UseType.TOGETHER) ||
          (useType == UseType.SEPARATELY && item.useType == UseType.SEPARATELY && item.name == member)
      ) {
        switch(item.itemType) {
          case ItemType.FOOD:
            food += item.price;
            break;
          case ItemType.SNACK:
            snack += item.price;
            break;
          case ItemType.ENTERTAINMENT:
            entertainment += item.price;
            break;
          case ItemType.THING:
            thing += item.price;
            break;
          case ItemType.HOME:
            home += item.price;
            break;
          case ItemType.TRAVEL:
            travel += item.price;
            break;
          case ItemType.OTHER:
            other += item.price;
            break;
        }
      }
    }
    return [food, snack, entertainment, thing, home, travel, other];
  }

  List<DataModel> getDataDetail(String month, int indexName, int indexTypeItem, int indexTypeUse) {
    List<DataModel> resultData = [];
    for(var item in data[month]!) {
      if(indexName > 0 && item.name != Member.values[indexName - 1]) {
        continue;
      }
      if(indexTypeItem > 0 && item.itemType != ItemType.values[indexTypeItem - 1]) {
        continue;
      }
      if(indexTypeUse > 0 && item.useType != UseType.values[indexTypeUse - 1]) {
        continue;
      }
      resultData.add(item);
    }
    return resultData;
  }

  Future<StatusApp> addData(String month, DataModel item) async {
    try {
      if (data.keys.contains(month)) {
        List<DataModel> dataMonth = [];
        for(var value in data[month]!) {
          dataMonth.add(value);
        }
        dataMonth.add(item);
        dataMonth.sort((a, b) => b.day.compareTo(a.day));

        var response = await databases.listDocuments(
          databaseId: '66fd5e4c001b5722c3a4',
          collectionId: '66fd5e670026f81adec9',
          queries: [Query.equal('month', month)],
        );

        if (response.documents.isNotEmpty) {
          String documentId = response.documents.first.$id;

          String strData = '';
          for (var value in dataMonth) {
            strData += '${value.day},${value.name.index},${value.item},${value.itemType.index},${value.useType.index},${value.price}\n';
          }

          await databases.updateDocument(
            databaseId: '66fd5e4c001b5722c3a4',
            collectionId: '66fd5e670026f81adec9',
            documentId: documentId,
            data: {'data': strData},
          );

          return initialize();
        } else {
          return StatusApp.ERROR;
        }
      }
      else {
        String dataItem = '${item.day},${item.name.index},${item.item},${item.itemType.index},${item.useType.index},${item.price}\n';
        await databases.createDocument(
          databaseId: '66fd5e4c001b5722c3a4',
          collectionId: '66fd5e670026f81adec9',
          documentId: ID.unique(),
          data: {
            'month': month,
            'data': dataItem,
          },
        );
        return initialize();
      }
    } catch(e) {
      print('Fail to add data: $e');
      xxxxx = 'Fail to add data: $e';
      return StatusApp.ERROR;
    }
  }
}