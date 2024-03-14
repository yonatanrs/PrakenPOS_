class Approved {
  final int id;
  final String salesOrder;
  final String customer;
  final String date;
  final String custReff;
  final String desc;
  final String status;

  Approved({
    required this.id,
    required this.salesOrder,
    required this.customer,
    required this.date,
    required this.custReff,
    required this.desc,
    required this.status,
  });

  factory Approved.fromJson(Map<String, dynamic> json) {
    return Approved(
      id: json['Id'] as int,
      salesOrder: json['SalesOrder'] as String,
      customer: json['Customer'] as String,
      date: json['Date'] as String,
      custReff: json['CustReff'] as String,
      desc: json['Desc'] as String,
      status: json['Status'] as String,
    );
  }

  // Helper method to format date if needed
  String getFormattedDate() {
    // Implement date formatting here
    return date;
  }
}
