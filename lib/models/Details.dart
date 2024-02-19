import 'dart:convert';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;

class Details {
  String idProduct;
  String nameProduct;
  String qty;
  String price;
  String amount;

  Details(
      {required this.idProduct, required this.nameProduct, required this.qty, required this.price, required this.amount});

  Details.fromJson(Map<String, dynamic> json)
      : idProduct = json['idProduct'] ?? (throw ArgumentError("idProduct is required")),
        nameProduct = json['nameProduct'] ?? (throw ArgumentError("nameProduct is required")),
        qty = json['qty'] ?? (throw ArgumentError("qty is required")),
        price = json['price'] ?? (throw ArgumentError("price is required")),
        amount = json['amount'] ?? (throw ArgumentError("amount is required"));

  static Future<List<Details>> getListDetails(String idOrder) async {
    String url =
        ApiConstant().urlApi + 'api/DetailsTransaction?idOrder=' + idOrder;

    var apiResult = await http.get(Uri.parse(url),);
    List<dynamic> jsonObject = json.decode(apiResult.body);
    List<Details> models = [];
    for (var transaction in jsonObject) {
      var objects = Details.fromJson(transaction as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }
}
