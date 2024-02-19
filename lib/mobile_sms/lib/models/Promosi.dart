import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConstant.dart';
import 'Lines.dart';

class Promosi {
  dynamic id;
  String? nomorPP; // nullable if they can be null
  String? ppType;
  dynamic namePP;
  dynamic date;
  String? fromDate;
  String? toDate;
  dynamic group;
  String? idProduct;
  String? product;
  String? idCustomer;
  String? customer;
  dynamic salesman;
  dynamic qty;
  dynamic qtyTo;
  String? unitId;
  String? note;
  String? disc1;
  String? disc2;
  String? disc3;
  String? disc4;
  String? value1;
  String? value2;
  String? suppItem;
  String? suppUnit;
  String? warehouse;
  String? suppQty;
  String? salesOffice;
  dynamic businessUnit;
  String? price;
  String? totalAmount;
  bool? status; // nullable if they can be null
  dynamic codeError;
  dynamic message;
  dynamic listId;
  dynamic listLines;
  dynamic listPromosi;
  dynamic detailpromosi;
  String? axStatus;

  // Constructor
  Promosi({
    this.id,
    this.nomorPP,
    this.ppType,
    this.namePP,
    this.date,
    this.fromDate,
    this.toDate,
    this.group,
    this.idProduct,
    this.product,
    this.idCustomer,
    this.customer,
    this.salesman,
    this.qty,
    this.qtyTo,
    this.unitId,
    this.note,
    this.disc1,
    this.disc2,
    this.disc3,
    this.disc4,
    this.value1,
    this.value2,
    this.suppItem,
    this.suppUnit,
    this.warehouse,
    this.suppQty,
    this.salesOffice,
    this.businessUnit,
    this.price,
    this.totalAmount,
    this.status,
    this.codeError,
    this.message,
    this.listId,
    this.listLines,
    this.listPromosi,
    this.detailpromosi,
    this.axStatus,
  });

  Promosi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomorPP = json['nomorPP'];
    ppType = json['type'];
    namePP = json['namePP'];
    date = json['date'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    group = json['group'];
    idProduct = json['idProduct'];
    product = json['product'];
    idCustomer = json['idCustomer'];
    customer = json['customer'];
    salesman = json['salesman'];
    qty = json['qty'];
    qtyTo = json['qtyTo'];
    unitId = json['unitId'];
    note = json['note'];
    disc1 = json['disc1'];
    disc2 = json['disc2'];
    disc3 = json['disc3'];
    disc4 = json['disc4'];
    value1 = json['value1'];
    value2 = json['value2'];
    suppItem = json['suppItem'];
    suppUnit = json['suppUnit'];
    warehouse = json['warehouse'];
    suppQty = json['suppQty'];
    salesOffice = json['salesOffice'];
    businessUnit = json['businessUnit'];
    price = json['price'];
    totalAmount = json['totalAmount'];
    status = json['status'];
    codeError = json['codeError'];
    message = json['message'];
    listId = json['listId'];
    listLines = json['listLines'];
    listPromosi = json['listPromosi'];
    detailpromosi = json['detailpromosi'];
    axStatus = json['AXStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomorPP'] = this.nomorPP;
    data['type'] = this.ppType;
    data['namePP'] = this.namePP;
    data['date'] = this.date;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['group'] = this.group;
    data['idProduct'] = this.idProduct;
    data['product'] = this.product;
    data['idCustomer'] = this.idCustomer;
    data['customer'] = this.customer;
    data['salesman'] = this.salesman;
    data['qty'] = this.qty;
    data['qtyTo'] = this.qtyTo;
    data['unitId'] = this.unitId;
    data['note'] = this.note;
    data['disc1'] = this.disc1;
    data['disc2'] = this.disc2;
    data['disc3'] = this.disc3;
    data['disc4'] = this.disc4;
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    data['suppItem'] = this.suppItem;
    data['suppUnit'] = this.suppUnit;
    data['warehouse'] = this.warehouse;
    data['suppQty'] = this.suppQty;
    data['salesOffice'] = this.salesOffice;
    data['businessUnit'] = this.businessUnit;
    data['price'] = this.price;
    data['totalAmount'] = this.totalAmount;
    data['status'] = this.status;
    data['codeError'] = this.codeError;
    data['message'] = this.message;
    data['listId'] = this.listId;
    data['listLines'] = this.listLines;
    data['listPromosi'] = this.listPromosi;
    data['detailpromosi'] = this.detailpromosi;
    data['AXStatus'] = this.axStatus;
    return data;
  }



  //http://119.18.157.236:8869/api/PromosiHeader?username=rp004&userId=9
  static Future<List<Promosi>> getListPromosi(
      int id, int code, String token, String username) async {
    print(token);
    dynamic userId;
    // String url = ApiConstant(code).urlApi + "api/PromosiHeader/" + id.toString() + "?username=" + username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/PromosiHeader?username=${prefs.getString("username")}&userId=${prefs.getInt('userid')}";
    print("ini url getListPromosi: $url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var promosi in jsonObject) {
      var objects = Promosi.fromJson(promosi as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<List<Promosi>> getListPromosiApproved(
      int id, int code, String token, String username) async {
    print(token);
    dynamic userId;
    // String url = ApiConstant(code).urlApi + "api/PromosiHeader/" + id.toString() + "?username=" + username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/PromosiHeader?usernames=${prefs.getString("username")}&userIds=${prefs.getInt('userid')}";
    print("ini url getListPromosi: $url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var promosi in jsonObject) {
      var objects = Promosi.fromJson(promosi as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<List<Promosi>> getAllListPromosi(
      int id, int code, String token, String username) async {
    print(token);
    dynamic userId;
    // String url = ApiConstant(code).urlApi + "api/PromosiHeader/" + id.toString() + "?username=" + username;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/Promosi?username=$username&userId=${prefs.getInt('userid')}";
    print("ini url getAllListPromosi: $url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var promosi in jsonObject) {
      var objects = Promosi.fromJson(promosi as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  var promosiLength;

  static Future<List<Promosi>> getListLines(String nomorPP, int code, String token, String username) async {
    final url = '${ApiConstant(code).urlApi}api/PromosiLines/$nomorPP?username=$username';
    print('Token: $token');
    print('URL listLines: $url');

    final dio = Dio()
      ..options.headers['Authorization'] = token;
    final response = await dio.get(url);

    // Check for errors in the response
    if (response.statusCode != 200) {
      throw Exception('Failed to get list of lines');
    }

    // Extract the JSON data from the response
    final jsonObject = response.data;
    final promosiList = List<Promosi>.from(jsonObject.map((model) => Promosi.fromJson(model)));

    return promosiList;
  }

  static Future<List<Promosi>> getListLinesPending(String nomorPP, int code, String token, String username) async {
    final url = '${ApiConstant(code).urlApi}api/PromosiLines/$nomorPP?username=$username&type=1';
    print('Token: $token');
    print('URL listLines: $url');

    final dio = Dio()
      ..options.headers['Authorization'] = token;
    final response = await dio.get(url);

    // Check for errors in the response
    if (response.statusCode != 200) {
      throw Exception('Failed to get list of lines');
    }

    // Extract the JSON data from the response
    final jsonObject = response.data;
    final promosiList = List<Promosi>.from(jsonObject.map((model) => Promosi.fromJson(model)));

    return promosiList;
  }

  static Future<List<Promosi>> getListActivity(String nomorPP, int code, String token, String username) async {
    final url = '${ApiConstant(code).urlApi}api/PromosiLines/$nomorPP?username=$username';
    print('Token: $token');
    print('URL listLines: $url');

    final dio = Dio()
      ..options.headers['Authorization'] = token;
    final response = await dio.get(url);

    // Check for errors in the response
    if (response.statusCode != 200) {
      throw Exception('Failed to get list of lines');
    }

    // Extract the JSON data from the response
    final jsonObject = response.data;
    final promosiList = List<Promosi>.from(jsonObject.map((model) => Promosi.fromJson(model)));

    return promosiList;
  }


  // api/SalesOrder?idProduct={idProduct}&idCustomer={idCustomer}
  static Future<List<Promosi>> getListSalesOrder(String idProduct,
      String idCustomer, int code, String token, String username) async {
    print("token :$token");
    String url = ApiConstant(code).urlApi +
        "api/SalesOrder?idProduct=" +
        idProduct +
        "&idCustomer=" +
        idCustomer +
        "&username=" +
        username;
    print("ini url listSalesOrder :$url");

    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    print("status salesHistory : ${response.statusMessage}");
    var jsonObject = response.data;
    List<Promosi> models = [];
    for (var salesOrder in jsonObject) {
      var objects = Promosi.fromJson(salesOrder as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  // static Future<Promosi> approveSalesOrder(String nomorPP, int code) async {
  static Future<Promosi> approveSalesOrder(
      List<Lines> listLines, int code) async {
    String url = ApiConstant(code).urlApi + "api/PromosiHeader/";
    var dio = Dio();
    dio.options.headers['content-type'] = 'application/json';
    var jsonData = jsonEncode(
        {"listLines": listLines.map((f) => f.toJsonDisc()).toList()});

    var apiResult = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    dynamic jsonObject = json.decode(apiResult.body);
    var data = jsonObject as Map<String, dynamic>;
    Promosi _promosi = Promosi.fromJson(data);
    return _promosi;
  }
}
