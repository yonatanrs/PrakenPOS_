class TransactionHistory {
  List<TransactionLines>? transactionLines;
  int? id;
  String? customerName;
  String? date;
  String? transactionId;
  String? customerId;

  TransactionHistory(
      {this.transactionLines,
        this.id,
        this.customerName,
        this.date,
        this.transactionId,
        this.customerId});

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    if (json['transactionLines'] != null) {
      transactionLines = <TransactionLines>[];
      json['transactionLines'].forEach((v) {
        transactionLines?.add(new TransactionLines.fromJson(v));
      });
    }
    id = json['id'];
    customerName = json['customerName'];
    date = json['date'];
    transactionId = json['transactionId'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final transactionLines = this.transactionLines;
    if (transactionLines != null) {
      data['transactionLines'] =
          transactionLines.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['customerName'] = this.customerName;
    data['date'] = this.date;
    data['transactionId'] = this.transactionId;
    data['customerId'] = this.customerId;
    return data;
  }
}

class TransactionLines {
  int? id;
  String? productId;
  String? unit;
  int? qty;
  int? disc;
  int? price;
  int? transactionId;
  int? totalPrice;
  String? productName;

  TransactionLines(
      {this.id,
        this.productId,
        this.unit,
        this.qty,
        this.disc,
        this.price,
        this.transactionId,
        this.totalPrice,
        this.productName});

  TransactionLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    unit = json['unit'];
    qty = json['qty'];
    disc = json['disc'];
    price = json['price'];
    transactionId = json['transactionId'];
    totalPrice = json['totalPrice'];
    productName = json['productName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['unit'] = this.unit;
    data['qty'] = this.qty;
    data['disc'] = this.disc;
    data['price'] = this.price;
    data['transactionId'] = this.transactionId;
    data['totalPrice'] = this.totalPrice;
    data['productName'] = this.productName;
    return data;
  }
}
