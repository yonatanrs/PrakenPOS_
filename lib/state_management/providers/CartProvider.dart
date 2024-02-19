import 'package:flutter/cupertino.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  CartProvider();

  late Product product;
  List<String> listProducts = <String>[];
  List<Cart> carts = <Cart>[];
  String? message;
  int qty = 0;

  void setCartProduct(Product model) async {
    Cart cartModel = new Cart();
    cartModel.idProduct = model.idProduct;
    cartModel.nameProduct = model.nameProduct;
    cartModel.stock = model.stock;
    cartModel.unit = model.unit;
    cartModel.qty = 1;
    cartModel.price = model.price;
    cartModel.subTotal = cartModel.qty! * cartModel.price!;
    cartModel.discount = 0;
    cartModel.total = cartModel.subTotal! + int.parse(cartModel.discount);

    List<Cart> listCart = <Cart>[];
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    listCart = list.map((e) => e as Cart).toList();
    if (listCart.length == 0) {
      _cartBox.add(cartModel);
    } else {
      if (listCart
              .where((element) => element.idProduct == cartModel.idProduct)
              .toList()
              .length !=
          0) {
        int position = listCart
            .indexWhere((element) => element.idProduct == cartModel.idProduct);
        cartModel.qty = listCart[position].qty! + 1;
        cartModel.subTotal = cartModel.qty! * cartModel.price!;
        cartModel.total = cartModel.subTotal;
        _cartBox.deleteAt(position);
        _cartBox.add(cartModel);
      } else {
        _cartBox.add(cartModel);
      }
    }
    qty = 0;
    raw = _cartBox.toMap();
    list = raw.values.toList();
    listCart = list.map((e) => e as Cart).toList();
    for (int value = 0; value < listCart.length; value++) {
      qty = listCart[value].qty! + qty;
    }
    carts = listCart;
    // message = qty.toString();
    notifyListeners();
  }

  void setRefreshCart() async {
    List<Cart> listCart = <Cart>[];
    Box _cartBox = await Hive.openBox("carts");
    Map<dynamic, dynamic> raw = _cartBox.toMap();
    List list = raw.values.toList();
    qty = 0;
    listCart = list.map((e) => e as Cart).toList();
    for (int value = 0; value < listCart.length; value++) {
      qty = listCart[value].qty! + qty;
    }
    notifyListeners();
  }

  int get getCountProduct => qty;

  List<Cart> get getCarts => carts;
  String get getMessage => message!;
}
