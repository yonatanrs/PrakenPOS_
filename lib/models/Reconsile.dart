import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/models/RecapStock.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Reconsile {
  int? id;
  String? note;
  String? status;
  String? userBy;
  String? codeError;
  String? reconsileDate;
  List<RecapStock>? listRecapStock;

  Reconsile(
      {this.id,
      this.note,
      this.status,
      this.userBy,
      this.codeError,
      this.reconsileDate,
      this.listRecapStock});

  Reconsile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    status = json['status'];
    userBy = json['userBy'];
    codeError = json['codeError'];
    reconsileDate = json['reconsileDate'];
    if (json['listRecapStock'] != null) {
      listRecapStock = <RecapStock>[];
      json['listRecapStock'].forEach((v) {
        listRecapStock?.add(new RecapStock.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note'] = this.note;
    data['status'] = this.status;
    data['userBy'] = this.userBy;
    data['codeError'] = this.codeError;
    data['reconsileDate'] = this.reconsileDate;
    final listRecapStock = this.listRecapStock;
    if (listRecapStock != null) {
      data['listRecapStock'] =
          listRecapStock.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Reconsile.fromJsonToMessage(Map<String, dynamic> json) {
    note = json['message'];
    codeError = json['codeError'];
  }

  static Future<List<Reconsile>> getAllReconsile(String idSales) async {
    String url = ApiConstant().urlApi + "api/reconsile/" + idSales;
    try {
      var dio = Dio();
      print("url reconsile : $url");
      Response response = await dio.get(url);
      var jsonObject = response.data;
      print("isi reconsile : $jsonObject");
      List<Reconsile> models = [];
      for (var reconsile in jsonObject) {
        var objects = Reconsile.fromJson(reconsile as Map<String, dynamic>);
        models.add(objects);
      }
      return models;
    } catch (e) {
      print("Error in getAllReconsile: $e");
      // Handle the error or return an empty list
      return [];
    }
  }

  static Future<List<Reconsile>> getAllReconsileExhibition() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wh = prefs.getString('getWh');
    String url = ApiConstant().urlApi + "api/Reconsile?Warehouse=$wh";

    print("url rec exhib : $url");

    try {
      var dio = Dio();
      Response response = await dio.get(url);
      List<Reconsile> models = (response.data as List).map((reconsile) {
        return Reconsile.fromJson(reconsile as Map<String, dynamic>);
      }).toList();
      return models;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        if (e.response?.statusCode == 405) {
          // Handle the 405 error specifically
          print("HTTP method not allowed. Check the request method and endpoint.");
        } else {
          // Handle other types of HTTP errors
          print("HTTP error: ${e.response?.statusCode}");
        }
      } else {
        // Handle non-HTTP errors (e.g., network error, timeout)
        print("Non-HTTP error: ${e.message}");
      }
      return []; // Return an empty list or handle the error appropriately
    } catch (e) {
      // Handle any other type of error (e.g., parsing error)
      print("Error: $e");
      return [];
    }
  }

  static Future<Reconsile> insertReconsile(Reconsile model) async {
    String url = ApiConstant().urlApi + "api/reconsile";
    print("url insertReconsiler : $url");
    var apiResult;
    try {
      var jsonData = jsonEncode({
        "listRecapStock": model.listRecapStock?.map((f) => f.toJson()).toList(),
        "note": model.note,
        "userBy": model.userBy
      });
      print("insertReconsile $jsonData");
      apiResult = await http.post(Uri.parse(url),
          headers: {'content-type': 'application/json'}, body: jsonData);
      dynamic jsonObject = json.decode(apiResult.body);
      model = Reconsile.fromJsonToMessage(jsonObject);
    } catch (ex) {
      model.codeError = "400";
      model.note = "No Connection. Please connect to Internet";
    }
    return model;
  }
}
