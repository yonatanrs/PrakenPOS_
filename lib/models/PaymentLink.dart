import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';

class PaymentLink {
  String? linkPayment;
  bool? status;

  PaymentLink({this.linkPayment, this.status});

  PaymentLink.fromJson(Map<String, dynamic> json) {
    linkPayment = json['linkPayment'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkPayment'] = this.linkPayment;
    data['status'] = this.status;
    return data;
  }

  static Future<PaymentLink> getPaymentLink(String orderId) async {
    Dio dio = new Dio();
    String url = ApiConstant().urlApi + 'api/paymentlink/' + orderId;
    Response response = await dio.get(url);
    var jsonObject = response.data;
    var objResult = PaymentLink.fromJson(jsonObject as Map<String, dynamic>);    
    return objResult;
  }
}