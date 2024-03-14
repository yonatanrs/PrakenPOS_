import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_scs/mobile_sms/lib/models/transactionHistory2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class TransactionHistoryPresenter2 extends GetxController {
  var transactionHistory2 = <TransactionHistory2>[].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1), () {
      getTransactionHistory2();
    });
  }

  Future<void> getTransactionHistory2() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int idEmp = int.tryParse(prefs.getString("getIdEmp") ?? '0') ?? 0;
    var urls = "http://api-scs.prb.co.id/api/SampleTransaction/$idEmp";

    try {
      final response = await get(Uri.parse(urls));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        transactionHistory2.value = jsonResponse
            .map((data) => TransactionHistory2.fromJson(data))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch transaction history: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
    }
  }


  RxList listDetail = [].obs;
  getTransactionHistoryDetail(String idTransaction)async{
    String url = "http://api-scs.prb.co.id/api/SampleTransaction/detail?trx=$idTransaction";
    final response = await get(Uri.parse(url));
    final listData = jsonDecode(response.body);
    listDetail.value = listData['Product'];
    print("cek listDetail = ${listDetail.value}");
    update();
  }




}
