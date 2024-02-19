class TransactionDraft {
  String? date;
  String? nameCustomer;
  String? idCustomer;
  String? idOrder;
  String? totalAmount;
  Null listTransaction;
  List<ListDetailTransaction>? listDetailTransaction;

  TransactionDraft(
      {required this.date,
      required this.nameCustomer,
      required this.idCustomer,
      required this.idOrder,
      required this.totalAmount,
      this.listTransaction,
      required this.listDetailTransaction});

  TransactionDraft.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    nameCustomer = json['nameCustomer'];
    idCustomer = json['idCustomer'];
    idOrder = json['idOrder'];
    totalAmount = json['totalAmount'];
    listTransaction = json['listTransaction'];
    if (json['listDetailTransaction'] != null) {
      listDetailTransaction =<ListDetailTransaction>[];
      json['listDetailTransaction'].forEach((v) {
        listDetailTransaction?.add(new ListDetailTransaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['nameCustomer'] = this.nameCustomer;
    data['idCustomer'] = this.idCustomer;
    data['idOrder'] = this.idOrder;
    data['totalAmount'] = this.totalAmount;
    data['listTransaction'] = this.listTransaction;
    final listDetailTransaction = this.listDetailTransaction;
    if (listDetailTransaction != null) {
      data['listDetailTransaction'] =
          listDetailTransaction.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDetailTransaction {
  String? idProduct;
  String? nameProduct;
  String? unit;
  String? stock;
  String? price;
  String? qty;
  String? subTotal;
  String? discount;
  String? totalAmount;

  ListDetailTransaction(
      {required this.idProduct,
      required this.nameProduct,
      required this.unit,
      required this.stock,
      required this.price,
      required this.qty,
      required this.subTotal,
      required this.discount,
      required this.totalAmount});

  ListDetailTransaction.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    unit = json['unit'];
    stock = json['stock'];
    price = json['price'];
    qty = json['qty'];
    subTotal = json['subTotal'];
    discount = json['discount'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['unit'] = this.unit;
    data['stock'] = this.stock;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['subTotal'] = this.subTotal;
    data['discount'] = this.discount;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}