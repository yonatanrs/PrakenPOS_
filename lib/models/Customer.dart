import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
part 'Customer.g.dart';

@HiveType(typeId: 0)
class Customer {
  @HiveField(0)
  String? idCustomer;
  @HiveField(1)
  String? codeCust;
  @HiveField(2)
  String? nameCust;
  @HiveField(3)
  String? address;
  @HiveField(4)
  String? contact;
  @HiveField(5)
  String? segment;
  @HiveField(6)
  String? city;
  @HiveField(7)
  String? contactPerson;
  @HiveField(8)
  String? group;

  Customer(
      {this.idCustomer,
      this.codeCust,
      this.nameCust,
      this.address,
      this.contact,
      this.segment,
      this.city,
      this.contactPerson,
      this.group});

  String toString() {
    return '$nameCust'.toLowerCase() + ' $nameCust'.toUpperCase();
  }

  factory Customer.convertCust(Map<String, dynamic> object) {
    return Customer(
        idCustomer: object['idCustomer'],
        codeCust: object['codeCust'],
        nameCust: object['nameCust'],
        address: object['address'],
        contact: object['contact'],
        segment: object['segment'],
        group: object['group']);
  }

  factory Customer.convertAllCust(Map<String, dynamic> object) {
    return Customer(
        codeCust: object['codeCust'],
        nameCust: object['nameCust'],
        address: object['address'],
        contact: object['contact'],
        segment: object['segment'],
        city: object['city'],
        group: object['group'],
        contactPerson: object['contactPerson']);
  }

  static Future<List<Customer>> getCustomer(
      String idSales, int condition) async {
    String url = ApiConstant().urlApi +
        "api/customer?idSales=" +
        idSales +
        "&condition=" +
        condition.toString();
    var dio = Dio();
    Response response = await dio.get(url);
    print("ini getCustomer : $url");
    var jsonObject = response.data;
    List<Customer> models = [];
    for (var product in jsonObject) {
      var objects = Customer.convertCust(product as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<String> insertNewCustomer(Customer models) async {
    String url = ApiConstant().urlApi + "api/customer";

    var apiResult = await http.post(
        Uri.parse(url),
      body: jsonEncode({
        "codeCust": models.codeCust,
        "nameCust": models.nameCust,
        "segment": models.segment,
        "address": models.address,
        "contact": models.contact
      }),
      headers: {'content-type': 'application/json'},
    );
    dynamic jsonObject = json.decode(apiResult.body);
    var data = jsonObject as String;

    return data;
  }

  static Future<List<Customer>> getAllCustomer(
      String token, String username) async {
    String url = ApiConstant().urlApi + "api/allcustomer/" + username;
    print("ini getAllCustomer: $url");
    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Customer> models = [];
    for (var product in jsonObject) {
      var objects = Customer.convertAllCust(product as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }
}
