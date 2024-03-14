import 'dart:convert';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';


part 'Product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  String? idProduct;
  @HiveField(1)
  String? nameProduct;
  @HiveField(2)
  String? unit;
  @HiveField(3)
  int? stock;
  @HiveField(4)
  int? subTotal;
  @HiveField(5)
  int? price;
  @HiveField(6)
  int? totalQty;
  @HiveField(7)
  String? group;
  @HiveField(8)
  String? category;
  @HiveField(9)
  String? brand;
  @HiveField(10)
  String? itemGroup;
  String? priceTag;
  @HiveField(11)
  int? discount;
  @HiveField(12)
  String? nameCustomer;
  String? message;
  int? transType;

  Product(
      {this.idProduct,
      this.nameCustomer,
      this.nameProduct,
      this.unit,
      this.stock,
      this.subTotal,
      this.price,
      this.totalQty,
      this.group,
      this.category,
      this.brand,
      this.itemGroup,
      this.priceTag});

  factory Product.convertProduct(Map<String, dynamic> object) {

    return Product(
        idProduct: object['idProduct'],
        nameCustomer: object['nameCustomer'],
        nameProduct: object['nameProduct'],
        unit: object['unit'],
        stock: object['stock'],
        price: object['price'],
        subTotal: object['subTotal'],
        totalQty: object['totalQty'],
        itemGroup: object['itemGroup'],
        priceTag: object['priceTag']);
  }

  factory Product.convertAllProduct(Map<String, dynamic> object) {
    return Product(
        idProduct: object['idProduct'],
        nameCustomer: object['nameCustomer'],
        nameProduct: object['nameProduct'],
        unit: object['unit'],
        brand: object['brand'],
        group: object['group'],
        itemGroup: object['itemGroup'],
        category: object['category']);
  }

  Map<String, dynamic> toJsonDisc() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['nameCustomer'] = this.nameCustomer;
    data['nameProduct'] = this.nameProduct;
    data['unit'] = this.unit;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['totalQty'] = this.totalQty;
    data['discount'] = this.discount;
    data['subTotal'] = this.subTotal;
    return data;
  }

  static Future<List<Product>?> getProduct(
      String idSales, String idCustomer, int condition) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("codeName", idCustomer);
    print("idCustomer apiGetProduct : $idCustomer");
    var url = ApiConstant().urlApi +
        "api/product?idSales=" +
        idSales +
        "&idCustomer=" +
        idCustomer +
        "&condition=" +
        condition.toString();
    var dio = Dio();
    log("get product Url $url");
    List<Product> models = [];
    // List models = prefs.getStringList("getProduct");
    try {
      Response response = await dio.get(url);
      var jsonObject = response.data;
      if (jsonObject != null) {
        for (var product in jsonObject) {
          var objects = Product.convertProduct(product as Map<String, dynamic>);
          // String getProductSharedPrefs = jsonEncode(objects);
          // prefs.setString("getProduct", getProductSharedPrefs);
          objects.totalQty = 1;
          models.add(objects);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print('Error Get PRODUCT : ${e.error}');
    }
    return models;
  }

  // static Future<List<Product>> getProductCart(
  //     List<String> listProducts, String idSales) async {
  //   String url = ApiConstant(1).urlApi + "api/product?idSales=" + idSales;
  //   var dio = Dio();
  //   Response response = await dio.get(url);
  //   var jsonObject = response.data;
  //   List<Product> models = [];
  //   for (var product in jsonObject) {
  //     var objects = Product.convertProduct(product as Map<String, dynamic>);
  //     objects.totalQty = 1;
  //     models.add(objects);
  //   }

  //   Product obj;
  //   List<Product> listResult = [];
  //   for (int indexFirst = 0; indexFirst < listProducts.length; indexFirst++) {
  //     for (int indSecond = 0; indSecond < models.length; indSecond++) {
  //       if (models[indSecond].idProduct == listProducts[indexFirst]) {
  //         obj = new Product();
  //         obj = models[indSecond];
  //         listResult.add(obj);
  //       }
  //     }
  //   }
  //   return listResult;
  // }

  static Future<List<Product>> getAllProduct(
      String token, String username, String idSales) async {
    String url = ApiConstant().urlApi +
        "api/allproduct/" +
        username +
        "?idSales=" +
        idSales;
    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    print(token);
    print("ini url getAllProduct: $url");
    var jsonObject = await response.data;
    print("Tipe data: " + jsonObject.runtimeType.toString());
    print("Data count: ${jsonObject.length}");
    List<Product> models = [];
    for (var product in jsonObject) {
      var objects = Product.convertAllProduct(product as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<List<Product>> getListProduct(
      String token, String username, String idSales) async {
    String url = ApiConstant().urlApi +
        "api/allproduct/" +
        username +
        "?idSales=" +
        idSales;
    var dio = Dio();
    dio.options.headers['Authorization'] = token;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<Product> models = [];
    for (var product in jsonObject) {
      var objects = Product.convertAllProduct(product as Map<String, dynamic>);
      models.add(objects);
    }
    return models;
  }

  static Future<List<String>> getAllUnit() async {
    String url = ApiConstant().urlApi + "api/unit";
    var dio = Dio();
    Response response = await dio.get(url);
    var jsonObject = response.data;
    List<String> models = [];
    for (var product in jsonObject) {
      var objects = product as String;
      models.add(objects);
    }
    return models;
  }

  static Future<String> insertTransaction(List<Product> listProduct,
      String idMerger, int amount, String idDevice, String orderId, int condtion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getRole = prefs.getString("getRole");
    int? convertRole;
    print("ini getRole: $getRole");
    if(getRole == "Regular"){
      convertRole = 0;
    }else if(getRole == "Canvas"){
      convertRole = 1;
      // return "1";
    }
    String url = ApiConstant().urlApi + "api/DetailPayment/";
    print("url insertTransaction : $url");
    // var dio = Dio();
    // dio.options.headers['content-type'] = 'application/json';
    var jsonData = jsonEncode({
      "listProducts": listProduct.map((f) => f.toJsonDisc()).toList(),
      "idMerger": idMerger,
      "subTotal": amount,
      "idDevice": idDevice,
      "idOrder": orderId,
      "condition": condtion,
      "transType" : convertRole
    });

    var apiResult = await http.post(
      Uri.parse(url),
      body: jsonData,
      headers: {'content-type': 'application/json'},
    );
    print('Request : $jsonData');
    dynamic jsonObject = json.decode(apiResult.body);
    var data = jsonObject as String;

    return data;
  }
}
