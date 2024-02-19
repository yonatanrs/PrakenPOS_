import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Lines.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinesProvider with ChangeNotifier {
  LinesProvider();
//  List<String> listResult = new List<String>();
  String? result;
  List<Map>? listResult;
  SharedPreferences? preferences;

  Future<void> setBundleLines(
      int id, double disc, DateTime fromDate, DateTime toDate) async {
    Lines model = new Lines();
    List<Lines> listDisc = <Lines>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
//    result = preferences.getString("result");
//    result = '"""'+ result + '"""';
//    var listStringResult = json.decode(result);
//    for (var objectResult in listStringResult) {
//      var objects = Lines.fromJson(objectResult as Map<String, dynamic>);
//      listDisc.add(objects);
//    }
    model.id = id;
    model.disc = disc;
    model.fromDate = fromDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(fromDate).toString();
    model.toDate = toDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(toDate).toString();
    Lines(model: model);
//    listDisc.add(model);
    listResult = listDisc.map((f) => f.toJson()).toList();
    result = jsonEncode(listResult);
//    listResult.add(result);
//    result = listResult.toString();
    preferences.setString("result", result!);
    notifyListeners();
  }

  String get getBundleLines => result!;
//  List<Lines> get getBundleLines => listDisc;
}
