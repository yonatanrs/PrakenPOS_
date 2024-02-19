import 'package:flutter/material.dart';
import 'package:flutter_scs/models/Customer.dart';

class CustomerProvider with ChangeNotifier {
  CustomerProvider();
  Customer? models;
  String? group;

  void setDetailCustomer(Customer customer) {
    models = customer;
    notifyListeners();
  }

  Customer get getDetailCustomer => models!;
}
