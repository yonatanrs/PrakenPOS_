class ActivityEdit {
  List<ActivityLinesEdit>? activityLinesEdit;
  int? id;
  String? number;
  String? customerId;
  dynamic? vendor;
  String? name;
  String? type;
  String? relation;
  String? date;
  String? location;
  String? statusKlaim;
  int? status;
  dynamic totalListing;
  dynamic totalPOListing;
  String? createdDate;
  String? createdBy;
  dynamic attachment;
  dynamic approve1;
  dynamic approve2;
  dynamic approve3;
  dynamic requirement;
  dynamic description;
  dynamic title;
  dynamic productId;
  dynamic approve1By;
  dynamic approve2By;
  dynamic approve3By;
  int? imported;
  String? bU;
  int? ack;
  dynamic vendId;
  int? testing;
  dynamic fromDate;
  dynamic toDate;
  int? notif;
  String? note;

  ActivityEdit(
      {this.activityLinesEdit,
        this.id,
        this.number,
        this.customerId,
        this.vendor,
        this.name,
        this.type,
        this.relation,
        this.date,
        this.location,
        this.statusKlaim,
        this.status,
        this.totalListing,
        this.totalPOListing,
        this.createdDate,
        this.createdBy,
        this.attachment,
        this.approve1,
        this.approve2,
        this.approve3,
        this.requirement,
        this.description,
        this.title,
        this.productId,
        this.approve1By,
        this.approve2By,
        this.approve3By,
        this.imported,
        this.bU,
        this.ack,
        this.vendId,
        this.testing,
        this.fromDate,
        this.toDate,
        this.notif,
        this.note});

  ActivityEdit.fromJson(Map<String, dynamic> json) {
    if (json['activityLines'] != null) {
      activityLinesEdit = <ActivityLinesEdit>[];
      json['activityLines'].forEach((v) {
        activityLinesEdit?.add(new ActivityLinesEdit.fromJson(v));
      });
    }
    id = json['Id'];
    number = json['Number'];
    customerId = json['CustomerId'];
    vendor = json['Vendor'];
    name = json['Name'];
    type = json['Type'];
    relation = json['Relation'];
    date = json['Date'];
    location = json['Location'];
    statusKlaim = json['StatusKlaim'];
    status = json['Status'];
    totalListing = json['TotalListing'];
    totalPOListing = json['TotalPOListing'];
    createdDate = json['CreatedDate'];
    createdBy = json['CreatedBy'];
    attachment = json['Attachment'];
    approve1 = json['Approve1'];
    approve2 = json['Approve2'];
    approve3 = json['Approve3'];
    requirement = json['Requirement'];
    description = json['Description'];
    title = json['Title'];
    productId = json['ProductId'];
    approve1By = json['Approve1By'];
    approve2By = json['Approve2By'];
    approve3By = json['Approve3By'];
    imported = json['Imported'];
    bU = json['BU'];
    ack = json['Ack'];
    vendId = json['VendId'];
    testing = json['Testing'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    notif = json['Notif'];
    note = json['Note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final activityLinesEdit = this.activityLinesEdit;
    if (activityLinesEdit != null) {
      data['activityLines'] =
          activityLinesEdit.map((v) => v.toJson()).toList();
    }
    data['Id'] = this.id;
    data['Number'] = this.number;
    data['CustomerId'] = this.customerId;
    data['Vendor'] = this.vendor;
    data['Name'] = this.name;
    data['Type'] = this.type;
    data['Relation'] = this.relation;
    data['Date'] = this.date;
    data['Location'] = this.location;
    data['StatusKlaim'] = this.statusKlaim;
    data['Status'] = this.status;
    data['TotalListing'] = this.totalListing;
    data['TotalPOListing'] = this.totalPOListing;
    data['CreatedDate'] = this.createdDate;
    data['CreatedBy'] = this.createdBy;
    data['Attachment'] = this.attachment;
    data['Approve1'] = this.approve1;
    data['Approve2'] = this.approve2;
    data['Approve3'] = this.approve3;
    data['Requirement'] = this.requirement;
    data['Description'] = this.description;
    data['Title'] = this.title;
    data['ProductId'] = this.productId;
    data['Approve1By'] = this.approve1By;
    data['Approve2By'] = this.approve2By;
    data['Approve3By'] = this.approve3By;
    data['Imported'] = this.imported;
    data['BU'] = this.bU;
    data['Ack'] = this.ack;
    data['VendId'] = this.vendId;
    data['Testing'] = this.testing;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Notif'] = this.notif;
    data['Note'] = this.note;
    return data;
  }
}

class ActivityLinesEdit {
  int? id;
  String? headerNumber;
  dynamic relation;
  dynamic activityNumber;
  dynamic activityName;
  dynamic customerRelation;
  String? itemRelation;
  String? item;
  String? customer;
  dynamic custSegment;
  dynamic  custSubSegment;
  double? minQty;
  double? qtyFrom;
  double? qtyTo;
  dynamic priceListing;
  dynamic total;
  String? unitID;
  String? fromDate;
  String? toDate;
  String? currency;
  dynamic percent1;
  dynamic percent2;
  dynamic percent3;
  dynamic percent4;
  dynamic value1;
  dynamic value2;
  String? suppItemOnlyOnce;
  String? suppItemId;
  dynamic suppItemQty;
  String? supplementaryUnitId;
  dynamic location;
  dynamic purchaseOrder;
  dynamic status;
  dynamic approval1;
  dynamic approval2;
  dynamic approval3;
  dynamic costRatio;
  dynamic parentId;
  dynamic brandId;
  dynamic imported;
  dynamic countCustomerID;
  dynamic estimatedPOAmount;
  int? typeClaim;
  dynamic description;
  dynamic listCustomer;
  dynamic keterangan;
  dynamic cost;
  dynamic quota;
  dynamic itemGroup;
  int? multiply;
  dynamic itemMultiDisc;
  String? warehouse;
  int? headerId;
  String? salesPrice;
  String? priceTo;

  ActivityLinesEdit(
      {this.id,
        this.headerNumber,
        this.relation,
        this.activityNumber,
        this.activityName,
        this.customerRelation,
        this.itemRelation,
        this.item,
        this.customer,
        this.custSegment,
        this.custSubSegment,
        this.minQty,
        this.qtyFrom,
        this.qtyTo,
        this.priceListing,
        this.total,
        this.unitID,
        this.fromDate,
        this.toDate,
        this.currency,
        this.percent1,
        this.percent2,
        this.percent3,
        this.percent4,
        this.value1,
        this.value2,
        this.suppItemOnlyOnce,
        this.suppItemId,
        this.suppItemQty,
        this.supplementaryUnitId,
        this.location,
        this.purchaseOrder,
        this.status,
        this.approval1,
        this.approval2,
        this.approval3,
        this.costRatio,
        this.parentId,
        this.brandId,
        this.imported,
        this.countCustomerID,
        this.estimatedPOAmount,
        this.typeClaim,
        this.description,
        this.listCustomer,
        this.keterangan,
        this.cost,
        this.quota,
        this.itemGroup,
        this.multiply,
        this.itemMultiDisc,
        this.warehouse,
        this.headerId,
        this.salesPrice,
        this.priceTo});

  ActivityLinesEdit.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    headerNumber = json['HeaderNumber'];
    relation = json['Relation'];
    activityNumber = json['ActivityNumber'];
    activityName = json['ActivityName'];
    customerRelation = json['CustomerRelation'];
    itemRelation = json['ItemRelation'];
    item = json['Item'];
    customer = json['Customer'];
    custSegment = json['CustSegment'];
    custSubSegment = json['CustSubSegment'];
    minQty = json['MinQty'];
    qtyFrom = json['QtyFrom'];
    qtyTo = json['QtyTo'];
    priceListing = json['PriceListing'];
    total = json['total'];
    unitID = json['UnitID'];
    fromDate = json['FromDate'];
    toDate = json['ToDate'];
    currency = json['Currency'];
    percent1 = json['Percent1'];
    percent2 = json['Percent2'];
    percent3 = json['Percent3'];
    percent4 = json['Percent4'];
    value1 = json['value1'];
    value2 = json['value2'];
    suppItemOnlyOnce = json['SuppItemOnlyOnce'];
    suppItemId = json['SuppItemId'];
    suppItemQty = json['SuppItemQty'];
    supplementaryUnitId = json['SupplementaryUnitId'];
    location = json['Location'];
    purchaseOrder = json['PurchaseOrder'];
    status = json['Status'];
    approval1 = json['Approval1'];
    approval2 = json['Approval2'];
    approval3 = json['Approval3'];
    costRatio = json['costRatio'];
    parentId = json['ParentId'];
    brandId = json['BrandId'];
    imported = json['Imported'];
    countCustomerID = json['CountCustomerID'];
    estimatedPOAmount = json['EstimatedPOAmount'];
    typeClaim = json['typeClaim'];
    description = json['description'];
    listCustomer = json['listCustomer'];
    keterangan = json['keterangan'];
    cost = json['cost'];
    quota = json['quota'];
    itemGroup = json['ItemGroup'];
    multiply = json['multiply'];
    itemMultiDisc = json['ItemMultiDisc'];
    warehouse = json['warehouse'];
    headerId = json['headerId'];
    salesPrice = json['salesPrice'];
    priceTo = json['priceTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['HeaderNumber'] = this.headerNumber;
    data['Relation'] = this.relation;
    data['ActivityNumber'] = this.activityNumber;
    data['ActivityName'] = this.activityName;
    data['CustomerRelation'] = this.customerRelation;
    data['ItemRelation'] = this.itemRelation;
    data['Item'] = this.item;
    data['Customer'] = this.customer;
    data['CustSegment'] = this.custSegment;
    data['CustSubSegment'] = this.custSubSegment;
    data['MinQty'] = this.minQty;
    data['QtyFrom'] = this.qtyFrom;
    data['QtyTo'] = this.qtyTo;
    data['PriceListing'] = this.priceListing;
    data['total'] = this.total;
    data['UnitID'] = this.unitID;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['Currency'] = this.currency;
    data['Percent1'] = this.percent1;
    data['Percent2'] = this.percent2;
    data['Percent3'] = this.percent3;
    data['Percent4'] = this.percent4;
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    data['SuppItemOnlyOnce'] = this.suppItemOnlyOnce;
    data['SuppItemId'] = this.suppItemId;
    data['SuppItemQty'] = this.suppItemQty;
    data['SupplementaryUnitId'] = this.supplementaryUnitId;
    data['Location'] = this.location;
    data['PurchaseOrder'] = this.purchaseOrder;
    data['Status'] = this.status;
    data['Approval1'] = this.approval1;
    data['Approval2'] = this.approval2;
    data['Approval3'] = this.approval3;
    data['costRatio'] = this.costRatio;
    data['ParentId'] = this.parentId;
    data['BrandId'] = this.brandId;
    data['Imported'] = this.imported;
    data['CountCustomerID'] = this.countCustomerID;
    data['EstimatedPOAmount'] = this.estimatedPOAmount;
    data['typeClaim'] = this.typeClaim;
    data['description'] = this.description;
    data['listCustomer'] = this.listCustomer;
    data['keterangan'] = this.keterangan;
    data['cost'] = this.cost;
    data['quota'] = this.quota;
    data['ItemGroup'] = this.itemGroup;
    data['multiply'] = this.multiply;
    data['ItemMultiDisc'] = this.itemMultiDisc;
    data['warehouse'] = this.warehouse;
    data['headerId'] = this.headerId;
    data['salesPrice'] = this.salesPrice;
    data['priceTo'] = this.priceTo;
    return data;
  }
}
