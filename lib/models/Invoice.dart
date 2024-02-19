import 'dart:convert';

import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:http/http.dart' as http;

class Invoice {
  int? id;
  String? nameCustomer;
  String? orderId;
  String? amount;
  Null typePayment;
  Null status;
  String? url;
  String? paidDate;
  Null createDate;
  List<ListDetailTransaction>? listDetailTransaction;

  Invoice(
      {this.id,
      this.nameCustomer,
      this.orderId,
      this.amount,
      this.typePayment,
      this.status,
      this.url,
      this.paidDate,
      this.createDate,
      this.listDetailTransaction});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameCustomer = json['nameCustomer'];
    orderId = json['orderId'];
    amount = json['amount'];
    typePayment = json['typePayment'];
    status = json['status'];
    url = json['url'];
    paidDate = json['paidDate'];
    createDate = json['createDate'];
    if (json['listDetailTransaction'] != null) {
      listDetailTransaction = <ListDetailTransaction>[];
      json['listDetailTransaction'].forEach((v) {
        listDetailTransaction?.add(new ListDetailTransaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameCustomer'] = this.nameCustomer;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['typePayment'] = this.typePayment;
    data['status'] = this.status;
    data['url'] = this.url;
    data['paidDate'] = this.paidDate;
    data['createDate'] = this.createDate;
    final listDetailTransaction = this.listDetailTransaction;
    if (listDetailTransaction != null) {
      data['listDetailTransaction'] =
          listDetailTransaction.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static Future<Invoice> getTransactionInvoice(String id) async {
    String url = ApiConstant().urlApi + 'api/Invoice/' + id;
    var apiResult = await http.get(Uri.parse(url),);
    dynamic jsonObject = json.decode(apiResult.body);
    Invoice models = new Invoice();
    models = Invoice.fromJson(jsonObject as Map<String, dynamic>);
    return models;
  }
}

class ListDetailTransaction {
  String? nameProduct;
  String? qty;
  String? discount;
  String? totalAmount;

  ListDetailTransaction(
      {this.nameProduct, this.qty, this.discount, this.totalAmount});

  ListDetailTransaction.fromJson(Map<String, dynamic> json) {
    nameProduct = json['nameProduct'];
    qty = json['qty'];
    discount = json['discount'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameProduct'] = this.nameProduct;
    data['qty'] = this.qty;
    data['discount'] = this.discount;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}
