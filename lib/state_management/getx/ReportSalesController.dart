import 'package:dio/dio.dart';
import 'package:flutter_scs/models/Report.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ReportSalesController extends GetxController with StateMixin<Report> {
  void getReportSales(String idSales) async {
    change(null, status: RxStatus.loading());
    try {
      var reportSales = await Report.getReportSalesperMonth(idSales);
      if (reportSales == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(reportSales, status: RxStatus.success());
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        change(null, status: RxStatus.error("No Connection"));
      } else if (e.type == DioErrorType.cancel) {
        change(null, status: RxStatus.error("No Connection"));
      } else {
        change(null, status: RxStatus.error("Error"));
      }
    }
  }
}
