import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';

class RecapStock {
  int? id;
  String? idProduct;
  String? nameProduct;
  String? unitProduct;
  int? price;
  int? qtySystem;
  int? qtyFisik;
  int? different;

  RecapStock(
      {required this.id,
      required this.idProduct,
      required this.nameProduct,
      required this.unitProduct,
      required this.price,
      required this.qtySystem,
      required this.qtyFisik,
      required this.different});

  RecapStock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    unitProduct = json['unitProduct'];
    price = json['price'];
    qtySystem = json['qtySystem'];
    qtyFisik = json['qtyFisik'];
    different = json['different'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['unitProduct'] = this.unitProduct;
    data['price'] = this.price;
    data['qtySystem'] = this.qtySystem;
    data['qtyFisik'] = this.qtyFisik;
    data['different'] = this.different;
    return data;
  }

  static Future<List<RecapStock>?> getListRecapStock(
      String idSales) async {
    String url = ApiConstant().urlApi +
        "api/recapstock?idSales=" +
        idSales;
    var dio = Dio();

    List<RecapStock> models = [];
    try {
      Response response = await dio.get(url);
      var jsonObject = response.data;
      if (jsonObject != null) {
        for (var product in jsonObject) {
          var objects = RecapStock.fromJson(product as Map<String, dynamic>);
          models.add(objects);
        }
      }else{
        return null;
      }
    } on DioError catch (e) {
      print('Error Get Recap Stock : ${e.error}');
    }
    return models;
  }
}