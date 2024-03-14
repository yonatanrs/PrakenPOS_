class ExhibitionModel {
  String? customerName;
  String? noTelp;
  String? email;
  String? alamat;
  List<DataProduct>? dataProduct;

  ExhibitionModel(
      {this.customerName,
        this.noTelp,
        this.email,
        this.alamat,
        this.dataProduct});

  ExhibitionModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    noTelp = json['noTelp'];
    email = json['email'];
    alamat = json['alamat'];
    if (json['dataProduct'] != null) {
      dataProduct = <DataProduct>[];
      json['dataProduct'].forEach((v) {
        dataProduct?.add(new DataProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['noTelp'] = this.noTelp;
    data['email'] = this.email;
    data['alamat'] = this.alamat;
    final dataProduct = this.dataProduct;
    if (dataProduct != null) {
      data['dataProduct'] = dataProduct.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataProduct {
  String? namaProduct;
  dynamic qty;
  String? uom;
  dynamic discount;
  dynamic price;

  DataProduct(
      {this.namaProduct, this.qty, this.uom, this.discount, this.price});

  DataProduct.fromJson(Map<String, dynamic> json) {
    namaProduct = json['namaProduct'];
    qty = json['qty'];
    uom = json['uom'];
    discount = json['discount'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['namaProduct'] = this.namaProduct;
    data['qty'] = this.qty;
    data['uom'] = this.uom;
    data['discount'] = this.discount;
    data['price'] = this.price;
    return data;
  }
}
