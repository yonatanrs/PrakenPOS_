import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';

class Report {
  String? description;
  String? date;
  String? amount;
  Report({this.description, this.date, this.amount});
  Report.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    date = json['date'];
    amount = json['amount'];
  }

  static Future<Report> getReportSalesperMonth(String idSales) async {
    String url = ApiConstant().urlApi +
        'api/AmountThisMonth?idSales=' + idSales;
    var dio = Dio();
    final response = await dio.get(
      url,
      options: Options(
        receiveTimeout: 10000,
        sendTimeout: 10000,
      ),
    );
    var objects = Report.fromJson(response.data);
    return objects;
  }
}
