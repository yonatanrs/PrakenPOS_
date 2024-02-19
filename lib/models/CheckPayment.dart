import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckPayment {
  String? rqUuid;
  String? rsDatetime;
  String? errorCode;
  String? errorMessage;
  String? commCode;
  String? txId;
  String? orderId;
  String? ccyId;
  String? amount;
  String? txStatus;
  String? txReason;
  String? txDate;
  String? created;
  String? expired;
  String? bankName;
  String? productName;
  String? productValue;
  String? paymentRef;
  String? merchantCode;
  String? signature;

  CheckPayment(
      {this.rqUuid,
      this.rsDatetime,
      this.errorCode,
      this.errorMessage,
      this.commCode,
      this.txId,
      this.orderId,
      this.ccyId,
      this.amount,
      this.txStatus,
      this.txReason,
      this.txDate,
      this.created,
      this.expired,
      this.bankName,
      this.productName,
      this.productValue,
      this.paymentRef,
      this.merchantCode,
      this.signature});

  CheckPayment.fromJson(Map<String, dynamic> json) {
    rqUuid = json['rq_uuid'];
    rsDatetime = json['rs_datetime'];
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
    commCode = json['comm_code'];
    txId = json['tx_id'];
    orderId = json['order_id'];
    ccyId = json['ccy_id'];
    amount = json['amount'];
    txStatus = json['tx_status'];
    txReason = json['tx_reason'];
    txDate = json['tx_date'];
    created = json['created'];
    expired = json['expired'];
    bankName = json['bank_name'];
    productName = json['product_name'];
    productValue = json['product_value'];
    paymentRef = json['payment_ref'];
    merchantCode = json['merchant_code'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rq_uuid'] = this.rqUuid;
    data['rs_datetime'] = this.rsDatetime;
    data['error_code'] = this.errorCode;
    data['error_message'] = this.errorMessage;
    data['comm_code'] = this.commCode;
    data['tx_id'] = this.txId;
    data['order_id'] = this.orderId;
    data['ccy_id'] = this.ccyId;
    data['amount'] = this.amount;
    data['tx_status'] = this.txStatus;
    data['tx_reason'] = this.txReason;
    data['tx_date'] = this.txDate;
    data['created'] = this.created;
    data['expired'] = this.expired;
    data['bank_name'] = this.bankName;
    data['product_name'] = this.productName;
    data['product_value'] = this.productValue;
    data['payment_ref'] = this.paymentRef;
    data['merchant_code'] = this.merchantCode;
    data['signature'] = this.signature;
    return data;
  }

  static Future<CheckPayment> checkPaymentStatus(String idOrder) async {
    String url = ApiConstant().urlApi + 'api/CheckStatus/' + idOrder;

    var apiResult = await http.get(Uri.parse(url));
    var jsonObject = json.decode(apiResult.body);
    var objects = CheckPayment.fromJson(jsonObject as Map<String, dynamic>);
    return objects;
  }
}
