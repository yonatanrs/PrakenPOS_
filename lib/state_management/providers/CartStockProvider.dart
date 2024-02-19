import 'package:flutter/cupertino.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:hive/hive.dart';

class CartStockProvider with ChangeNotifier {
  CartStockProvider();
  int discount = 0;
  int subTotal = 0;
  int total = 0;
  int grandTotal = 0;

  int qty = 1;
  Product? product;
  Cart? cartModel;
  String? message;
  String? address;

  void setQty(int type, Cart cart) async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    int position =
        listCart.indexWhere((element) => element.idProduct == cart.idProduct);
    if (type == 1) {
      if (listCart[position].qty == 1) {
        cart.qty = 1;
        cart.message  = null;
      } else {
        cart.qty = listCart[position].qty! - 1;
        cart.message  = null;
      }
    } else {
      if (listCart[position].qty == cart.stock) {
        cart.qty = cart.stock;
        cart.message = 'Stock habis';
      } else {
        cart.qty = listCart[position].qty! + 1;
        cart.message  = null;
      }
    }

    subTotal = listCart[position].price! * cart.qty!;
    cart.subTotal = subTotal;
    discount = (subTotal * (listCart[position].discount / 100)).toInt();
    cart.total = subTotal - discount;
    total = cart.total!;

    _cartBox.deleteAt(position);
    _cartBox.add(cart);
    setSubTotal();
    notifyListeners();
  }

  void setSubTotal() async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    discount = 0;
    subTotal = 0;
    total = 0;
    grandTotal = 0;
    if (listCart.length != 0) {
      for (int counts = 0; counts < listCart.length; counts++) {
        total = listCart[counts].subTotal! +
            total -
            (listCart[counts].subTotal! * (listCart[counts].discount / 100))
                .toInt();
        grandTotal = subTotal;
      }
      cartModel = listCart[0];
    } else {
      cartModel = new Cart();
    }

    notifyListeners();
  }

  void setDiscount(int discountPercent, String idProduct) async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    discount = 0;
    subTotal = 0;
    int position =
        listCart.indexWhere((element) => element.idProduct == idProduct);
    discount = (listCart[position].subTotal! * (discountPercent / 100)).toInt();
    subTotal = listCart[position].subTotal! - discount;
    // for (int counts = 0; counts < listCart.length; counts++) {
    //   subTotal = listCart[counts].subTotal - discount;
    // }

    notifyListeners();
  }

  void setUpdateDiscount(int discountPercent, String idProduct) async {
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    List<Cart> listCart = list.map((e) => e as Cart).toList();
    int position =
        listCart.indexWhere((element) => element.idProduct == idProduct);
    subTotal = 0;
    discount = 0;
    Cart cartModel = new Cart();
    cartModel = listCart[position];
    discount = (cartModel.subTotal! * (discountPercent / 100)).toInt();
    cartModel.total = cartModel.subTotal! - discount;
    //discount dalam bentuk rupiah  // cartModel.discount = discount;
    cartModel.discount = discountPercent.toInt(); //discount dlm bntuk %

    _cartBox.deleteAt(position);
    _cartBox.add(cartModel);
    setSubTotal();
    // discount = discount;
    // total = cartModel.total;
    notifyListeners();
  }

  void setAddress(String addressCustomer) {
    address = addressCustomer;
    notifyListeners();
  }

  String get getAddress => address!;
  Product get getProduct => product!;
  int get getDiscount => discount;
  int get getTotal => subTotal;
  int get getGrandTotal => total;
  Cart get getCart => cartModel!;
  String get getMessageError => message!;
}
