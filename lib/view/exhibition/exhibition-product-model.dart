class ExhibitionProductModel {
  String? idProduct;
  dynamic nameCustomer;
  String? nameProduct;
  String? brand;
  dynamic unit;
  dynamic group;
  String? category;
  dynamic itemGroup;
  int? stock;
  int? subTotal;
  int? price;
  int? discount;
  dynamic priceTag;
  int? totalQty;
  dynamic listProducts;
  dynamic detailProduct;
  dynamic idMerger;
  dynamic idDevice;
  dynamic idOrder;
  dynamic condition;
  dynamic transType;

  ExhibitionProductModel(
      {required this.idProduct,
        this.nameCustomer,
        required this.nameProduct,
        required this.brand,
        this.unit,
        this.group,
        required this.category,
        this.itemGroup,
        required this.stock,
        required this.subTotal,
        required this.price,
        required this.discount,
        this.priceTag,
        required this.totalQty,
        this.listProducts,
        this.detailProduct,
        this.idMerger,
        this.idDevice,
        this.idOrder,
        this.condition,
        this.transType});

  ExhibitionProductModel.fromJson(Map<String, dynamic> json) {
    idProduct = json['idProduct'];
    nameCustomer = json['nameCustomer'];
    nameProduct = json['nameProduct'];
    brand = json['brand'];
    unit = json['unit'];
    group = json['group'];
    category = json['category'];
    itemGroup = json['itemGroup'];
    stock = json['stock'];
    subTotal = json['subTotal'];
    price = json['price'];
    discount = json['discount'];
    priceTag = json['priceTag'];
    totalQty = json['totalQty'];
    listProducts = json['listProducts'];
    detailProduct = json['detailProduct'];
    idMerger = json['idMerger'];
    idDevice = json['idDevice'];
    idOrder = json['idOrder'];
    condition = json['condition'];
    transType = json['transType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idProduct'] = this.idProduct;
    data['nameCustomer'] = this.nameCustomer;
    data['nameProduct'] = this.nameProduct;
    data['brand'] = this.brand;
    data['unit'] = this.unit;
    data['group'] = this.group;
    data['category'] = this.category;
    data['itemGroup'] = this.itemGroup;
    data['stock'] = this.stock;
    data['subTotal'] = this.subTotal;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['priceTag'] = this.priceTag;
    data['totalQty'] = this.totalQty;
    data['listProducts'] = this.listProducts;
    data['detailProduct'] = this.detailProduct;
    data['idMerger'] = this.idMerger;
    data['idDevice'] = this.idDevice;
    data['idOrder'] = this.idOrder;
    data['condition'] = this.condition;
    data['transType'] = this.transType;
    return data;
  }
}
