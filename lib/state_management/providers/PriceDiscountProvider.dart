import 'package:flutter/cupertino.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/Product.dart';

class PriceDiscountProvider with ChangeNotifier {
  PriceDiscountProvider();
  Customer? customer;
  Product? product;
  String? groupCustomer, groupProduct;

  void setGroupCustomer(List<Customer> listCustomer, String idCustomer) {
    groupCustomer = listCustomer
        .where((element) => element.codeCust == idCustomer)
        .map((e) => e.group)
        .toString();
    groupCustomer = groupCustomer?.replaceAll('(', '');
    groupCustomer = groupCustomer?.replaceAll(')', '');
    notifyListeners();
  }

  String? get getGroupCustomer => groupCustomer;

  void setGroupProduct(List<Product> listProduct, String idProduct) {
    groupProduct = listProduct
        .where((element) => element.idProduct == idProduct)
        .map((e) => e.group)
        .toString();
    groupProduct = groupProduct?.replaceAll('(', '');
    groupProduct = groupProduct?.replaceAll(')', '');
    notifyListeners();
  }

  String? get getGroupProduct => groupProduct;
}
