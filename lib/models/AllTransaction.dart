import 'package:flutter_scs/models/Transaction.dart';

import 'Cart.dart';

class AllTransaction {
  String? date;
  String? idCustomer;
  String? nameCustomer;
  String? idOrder;
  List<Transaction>? listTransaction;
  List<Cart>? listDetailTransaction;

  AllTransaction({this.date, this.listTransaction});

  AllTransaction.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    idCustomer = json['idCustomer'];
    nameCustomer = json['nameCustomer'];
    idOrder = json['idOrder'];
    if (json['listTransaction'] != null) {
      listTransaction = <Transaction>[];
      json['listTransaction'].forEach((v) {
        listTransaction?.add(new Transaction.fromJson(v));
      });
    }
    if (json['listDetailTransaction'] != null) {
      listDetailTransaction = <Cart>[];
      json['listDetailTransaction'].forEach((v) {
        listDetailTransaction?.add(new Cart.fromJson(v));
      });
    }
  }

}