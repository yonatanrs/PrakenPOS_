class ApprovalDetail {
  final String product;
  final int qty;
  final String unit;

  ApprovalDetail({
    required this.product,
    required this.qty,
    required this.unit,
  });

  factory ApprovalDetail.fromJson(Map<String, dynamic> json) {
    return ApprovalDetail(
      product: json['Product'] as String,
      qty: json['Qty'] as int,
      unit: json['Unit'] as String,
    );
  }
}
