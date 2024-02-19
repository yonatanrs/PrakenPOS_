import 'dart:async';
import 'package:dio/dio.dart';

class Merchant {
  String? errorCode;
  String? errorMessage;
  List<Data>? data;

  Merchant({this.errorCode, this.errorMessage, this.data});

  Merchant.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.errorCode;
    data['error_message'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<List<Data>> getListPayment() async {
    var listPayment = <Data>[];
    Dio dio = new Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response response = await dio.post(
        "https://sandbox-api.espay.id/rest/merchant/merchantinfo",
        data: {"key": "f4fb07ff62165046c668d3487f70a2ce"},
        options: Options(contentType: Headers.formUrlEncodedContentType));
    var jsonObject = response.data;
    var objResult = Merchant.fromJson(jsonObject as Map<String, dynamic>);
    List<Data>? listData = objResult.data;
    listData!.forEach((element) {
      listPayment.add(Data(
          bankCode: element.bankCode,
          productCode: element.productCode,
          productName:
              element.bankCode == '008' ? 'QR Code Pay' : element.productName));
    });
    return listPayment;
  }
}

class Data {
  String? bankCode;
  String? productCode;
  String? productName;

  Data({this.bankCode, this.productCode, this.productName});

  Data.fromJson(Map<String, dynamic> json) {
    bankCode = json['bankCode'];
    productCode = json['productCode'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankCode'] = this.bankCode;
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    return data;
  }
}
