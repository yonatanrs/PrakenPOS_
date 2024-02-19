class CreatePromosi {
  int? pPtype;
  String? pPname;
  String? location;
  String? vendor;
  List<LinesCreatePromosi>? lines;

  CreatePromosi(
      {this.pPtype, this.pPname, this.location, this.vendor, this.lines});

  CreatePromosi.fromJson(Map<String, dynamic> json) {
    pPtype = json['PPtype'];
    pPname = json['PPname'];
    location = json['Location'];
    vendor = json['Vendor'];
    if (json['Lines'] != null) {
      lines = <LinesCreatePromosi>[];
      json['Lines'].forEach((v) {
        lines?.add(new LinesCreatePromosi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PPtype'] = this.pPtype;
    data['PPname'] = this.pPname;
    data['Location'] = this.location;
    data['Vendor'] = this.vendor;
    final lines = this.lines;
    if (lines != null) {
      data['Lines'] = lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LinesCreatePromosi {
  String? customer;
  String? itemId;
  int? qtyFrom;
  int? qtyTo;
  String? unit;
  int? multiply;
  String? fromDate;
  String? toDate;
  String? currency;
  int? type;
  double? pct1;
  int? pct2;
  double? pct3;
  int? pct4;
  double? value1;
  double? value2;
  int? supplyItemOnlyOnce;
  String? supplyItem;
  int? qtySupply;
  String? unitSupply;

  LinesCreatePromosi(
      {this.customer,
        this.itemId,
        this.qtyFrom,
        this.qtyTo,
        this.unit,
        this.multiply,
        this.fromDate,
        this.toDate,
        this.currency,
        this.type,
        this.pct1,
        this.pct2,
        this.pct3,
        this.pct4,
        this.value1,
        this.value2,
        this.supplyItemOnlyOnce,
        this.supplyItem,
        this.qtySupply,
        this.unitSupply});

  LinesCreatePromosi.fromJson(Map<String, dynamic> json) {
    customer = json['Customer'];
    itemId = json['ItemId'];
    qtyFrom = json['QtyFrom'];
    qtyTo = json['QtyTo'];
    unit = json['Unit'];
    multiply = json['Multiply'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    currency = json['Currency'];
    type = json['type'];
    pct1 = json['Pct1'];
    pct2 = json['Pct2'];
    pct3 = json['Pct3'];
    pct4 = json['Pct4'];
    value1 = json['Value1'];
    value2 = json['Value2'];
    supplyItemOnlyOnce = json['SupplyItemOnlyOnce'];
    supplyItem = json['SupplyItem'];
    qtySupply = json['QtySupply'];
    unitSupply = json['UnitSupply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Customer'] = this.customer;
    data['ItemId'] = this.itemId;
    data['QtyFrom'] = this.qtyFrom;
    data['QtyTo'] = this.qtyTo;
    data['Unit'] = this.unit;
    data['Multiply'] = this.multiply;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Currency'] = this.currency;
    data['type'] = this.type;
    data['Pct1'] = this.pct1;
    data['Pct2'] = this.pct2;
    data['Pct3'] = this.pct3;
    data['Pct4'] = this.pct4;
    data['Value1'] = this.value1;
    data['Value2'] = this.value2;
    data['SupplyItemOnlyOnce'] = this.supplyItemOnlyOnce;
    data['SupplyItem'] = this.supplyItem;
    data['QtySupply'] = this.qtySupply;
    data['UnitSupply'] = this.unitSupply;
    return data;
  }
}
