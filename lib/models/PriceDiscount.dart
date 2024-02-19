import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
part 'PriceDiscount.g.dart';

@HiveType(typeId: 0)
class PriceDiscount {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? idCustomer;
  @HiveField(2)
  String? customer;
  @HiveField(3)
  String? idProduct;
  @HiveField(4)
  String? product;
  @HiveField(5)
  String? unit;
  @HiveField(6)
  String? group;
  @HiveField(7)
  String? businessUnit;
  @HiveField(8)
  String? price;
  @HiveField(9)
  int? disc1;
  @HiveField(10)
  int? disc2;
  @HiveField(11)
  String? fromDate;
  @HiveField(12)
  String? endDate;
  String? disc1Tag;
  String? disc2Tag;

  PriceDiscount(
      {this.id,
      this.idCustomer,
      this.customer,
      this.idProduct,
      this.product,
      this.unit,
      this.group,
      this.businessUnit,
      this.price,
      this.disc1,
      this.disc2});

  PriceDiscount.fromJsonPrice(Map<String, dynamic> json) {
    id = json['id'];
    idProduct = json['idProduct'];
    product = json['nameProduct'];
    unit = json['unit'];
    group = json['group'];
    businessUnit = json['businessUnit'];
    price = json['price'];
  }

  PriceDiscount.fromJsonDiscount(Map<String, dynamic> json) {
    id = json['id'];
    idProduct = json['idProduct'];
    product = json['nameProduct'];    
    idCustomer = json['idCustomer'];
    customer = json['nameCustomer'];
    price = json['price'];
    unit = json['unit'];
    disc1 = json['disc1'];
    disc2 = json['disc2'];
    disc1Tag = json['disc1Tag'];
    disc2Tag = json['disc2Tag'];
    fromDate = json['fromDate'];
    endDate = json['toDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.product;
    data['unit'] = this.unit;
    data['group'] = this.group;
    data['businessUnit'] = this.businessUnit;
    data['disc1'] = this.disc1;
    data['disc2'] = this.disc2;
    return data;
  }

  static Future<List<PriceDiscount>> getAllPrice() async {
    String url = ApiConstant().urlApi + "api/allprice";
    print("url price: $url");
    var dio = Dio();
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<PriceDiscount> models = [];
    for (var price in jsonObject) {
      var objects = PriceDiscount.fromJsonPrice(price as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<String> insertDiscount(PriceDiscount dataDiscount) async {
    String url = ApiConstant().urlApi + "api/AllDiscount/";
    // var dio = Dio();
    // dio.options.headers['content-type'] = 'application/json';
    var jsonData = jsonEncode({
      "idCustomer": dataDiscount.idCustomer,
      "customerGroup": dataDiscount.customer,
      "idProduct": dataDiscount.idProduct,
      "group": dataDiscount.product,
      "price": dataDiscount.price,
      "unit": dataDiscount.unit,
      "disc1": dataDiscount.disc1,
      "disc2": dataDiscount.disc2,
      "fromDate": dataDiscount.fromDate,
      "toDate": dataDiscount.endDate
    });

    var apiResult = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: {'content-type': 'application/json'},
    );
    // dynamic jsonObject;
    var data;
    if (apiResult.statusCode == 200) {
      data = "Success";
      // jsonObject = json.decode(apiResult.body);
      // data = jsonObject as String;
    } else {
      data = "Failed Insert Discount";
    }

    return data;
  }

  static Future<List<PriceDiscount>> getAllDiscount(String idSales) async {
    // String url = ApiConstant(1).urlApi + "api/alldiscount?idSales=" + idSales;
    String url = ApiConstant().urlApi + "api/AllDiscount";
    var dio = Dio();
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<PriceDiscount> models = [];
    for (var discount in jsonObject) {
      var objects =
          PriceDiscount.fromJsonDiscount(discount as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }
}
