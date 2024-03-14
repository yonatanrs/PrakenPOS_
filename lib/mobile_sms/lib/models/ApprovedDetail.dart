class ApprovedDetail {
  final String product;
  final int qty;
  final String unit;

  ApprovedDetail({
    required this.product,
    required this.qty,
    required this.unit,
  });

  factory ApprovedDetail.fromJson(Map<String, dynamic> json) {
    return ApprovedDetail(
      product: json['Product'] as String,
      qty: json['Qty'] as int,
      unit: json['Unit'] as String,
    );
  }
}
