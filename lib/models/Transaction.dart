import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_scs/models/AllTransaction.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/models/DraftTransaction.dart';
import 'package:http/http.dart' as http;

class Transaction {
  int? id;
  String? nameCustomer;
  String? orderId;
  String? amount;
  String? typePayment;
  String? status;
  String? paidDate;
  String? createDate;

  Transaction(
      {this.id,
      this.nameCustomer,
      this.orderId,
      this.amount,
      this.typePayment,
      this.status,
      this.paidDate,
      this.createDate});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameCustomer = json['nameCustomer'];
    orderId = json['orderId'];
    amount = json['amount'];
    typePayment = json['typePayment'];
    status = json['status'];
    paidDate = json['paidDate'];
    createDate = json['createDate'];
  }

  static Future<List<AllTransaction>> getListTransaction(
      String idSales, String token) async {
    String url = ApiConstant().urlApi + 'api/Transaction?idSales=' + idSales;
    print("url transaction all:$url");
    print("token : $token");

    List<AllTransaction> models = [];
    var jsonObject;
    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = token;
      Response response = await dio.get(url);
      jsonObject = response.data;
      for (var allTransaction in jsonObject) {
        var objects =
            AllTransaction.fromJson(allTransaction as Map<String, dynamic>);
        models.add(objects);
      }
    } catch (ex) {
      jsonObject = ex.toString();
      print(jsonObject);
    }
    return models;
  }

static Future<List<TransactionDraft>> getListDraftTransaction(
      String idSales, String token) async {
    String url = ApiConstant().urlApi + 'api/DraftTransaction?idSales=' + idSales;

    print("url transaction draft:$url");
    print("token : $token");

    List<TransactionDraft> models = [];
    var jsonObject;
    try {
      var dio = Dio();
      dio.options.headers['Authorization'] = token;
      Response response = await dio.get(url);
      jsonObject = response.data;
      for (var allTransaction in jsonObject) {
        var objects =
            TransactionDraft.fromJson(allTransaction as Map<String, dynamic>);
        models.add(objects);
      }
    } catch (ex) {
      jsonObject = ex.toString();
      print(jsonObject);
    }
    return models;
  }

  static Future<List<AllTransaction>> checkPaymentStatus(String idOrder) async {
    String url = ApiConstant().urlApi + 'api/CheckStatus/' + idOrder;

    var apiResult = await http.get(Uri.parse(url),);
    List<dynamic> jsonObject = json.decode(apiResult.body);
    List<AllTransaction> models = [];
    for (var allTransaction in jsonObject) {
      var objects =
          AllTransaction.fromJson(allTransaction as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }
}
