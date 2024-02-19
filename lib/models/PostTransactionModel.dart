class PostTransactionModel {
  String? nameCust;
  String? address;
  String? contact;
  String? email;
  String? dateOrder;
  dynamic totalHarga;
  List<Lines>? lines;



  PostTransactionModel(
      {this.nameCust, this.address, this.contact, this.email, this.lines,this.dateOrder,this.totalHarga});

  PostTransactionModel.fromJson(Map<String, dynamic> json) {
    nameCust = json['nameCust'];
    address = json['address'];
    contact = json['contact'];
    email = json['email'];
    totalHarga = json['total'];
    dateOrder = json['date'];
    if (json['Lines'] != null) {
      lines = <Lines>[];
      json['Lines'].forEach((v) {
        lines!.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameCust'] = this.nameCust;
    data['address'] = this.address;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['total'] = this.totalHarga;
    data['date'] = this.dateOrder;
    if (this.lines != null) {
      data['Lines'] = this.lines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  String? idOrder;
  String? idProduct;
  String? nameProduct;
  int? qty;
  String? unit;
  double? price;
  int? discount;
  int? subTotal;
  double? totalAmount;
  int? stock;

  Lines(
      {this.idOrder,
        this.idProduct,
        this.nameProduct,
        this.qty,
        this.unit,
        this.price,
        this.discount,
        this.subTotal,
        this.totalAmount,
        this.stock});

  Lines.fromJson(Map<String, dynamic> json) {
    idOrder = json['idOrder'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    qty = json['qty'];
    unit = json['unit'];
    price = json['price'];
    discount = json['discount'];
    subTotal = json['subTotal'];
    totalAmount = json['totalAmount'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idOrder'] = this.idOrder;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['subTotal'] = this.subTotal;
    data['totalAmount'] = this.totalAmount;
    data['stock'] = this.stock;
    return data;
  }
}
