import 'package:hive/hive.dart';
part 'Cart.g.dart';

@HiveType(typeId: 0)
class Cart {
  @HiveField(0)
  String? idProduct;
  @HiveField(1)
  String? nameProduct;
  @HiveField(2)
  String? unit;
  @HiveField(3)
  int? stock;
  @HiveField(4)
  int? qty;
  @HiveField(5)
  int? subTotal;
  @HiveField(6)
  dynamic discount;
  @HiveField(7)
  int? total;
  @HiveField(8)
  int? price;
  String? message;

  Cart(
      {this.idProduct,
      this.nameProduct,
      this.unit,
      this.stock,
      this.qty,
      this.subTotal,
      this.discount,
      this.total,
      this.price});

   Cart.fromJson(Map<String, dynamic> json) {
    idProduct = json['id'];
    nameProduct = json['nameProduct'];
    unit = json['unit'];
    stock = json['stock'];
    price = json['price'];
    qty = json['qty'];
    subTotal = json['subTotal'];
    discount = json['discount'];
  }
}
