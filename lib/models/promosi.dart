class Promosi {
  String? name;
  String? status;
  String? custId;
  dynamic createdBy;
  List<Lines>? lines;

  Promosi({this.name, this.custId, this.createdBy, this.lines, this.status});

  Promosi.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    status = json["Status"];
    custId = json["CustId"];
    createdBy = json['CreatedBy'];
    if (json['Lines'] != null) {
      lines = <Lines>[];
      json['Lines'].forEach((v) {
        lines?.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Status'] = this.status;
    data ["CustId"] = this.custId;
    data['CreatedBy'] = this.createdBy;
    final lines = this.lines;
    if (lines != null) {
      data['Lines'] = lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lines {
  // String custId;
  String? itemId;
  dynamic qty;
  String? unit;
  dynamic price;
  dynamic disc;

  Lines({
    // this.custId,
    this.itemId, this.qty, this.unit, this.price, this.disc});

  Lines.fromJson(Map<String, dynamic> json) {
    // custId = json['CustId'];
    itemId = json['ItemId'];
    qty = json['Qty'];
    unit = json['Unit'];
    price = json['Price'];
    disc = json['Disc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['CustId'] = this.custId;
    data['ItemId'] = this.itemId;
    data['Qty'] = this.qty;
    data['Unit'] = this.unit;
    data['Price'] = this.price;
    data['Disc'] = this.disc;
    return data;
  }
}
