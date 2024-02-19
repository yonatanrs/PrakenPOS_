import 'package:dio/dio.dart';
import 'package:flutter_scs/models/AllTransaction.dart';
import 'package:flutter_scs/models/Transaction.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionController extends GetxController
    with StateMixin<List<AllTransaction>> {

  void getTransaction() async {
    change(null, status: RxStatus.loading());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idSales = preferences.getString("idSales");
    var token = preferences.getString("token");
    try {
      var result = await Transaction.getListTransaction(idSales!, token!);
      if (result.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
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
