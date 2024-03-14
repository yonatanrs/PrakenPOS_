class TransactionHistory2 {
  final String? SalesId;
  final String? Customer;
  final String? Date;
  final String? CustReff;
  final String? Status; // Make sure this field exists

  TransactionHistory2({this.SalesId, this.Customer, this.Date, this.CustReff, this.Status});

  factory TransactionHistory2.fromJson(Map<String, dynamic> json) {
    return TransactionHistory2(
      SalesId: json['SalesId'] as String?,
      Customer: json['Customer'] as String?,
      Date: json['Date'] as String?,
      CustReff: json['CustReff'] as String?,
      Status: json['Status'] as String?, // Make sure this line is correct
    );
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
