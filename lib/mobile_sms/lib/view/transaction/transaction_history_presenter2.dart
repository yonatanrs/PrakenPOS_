import 'dart:convert';
import 'package:http/http.dart' as http;
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
    final Uri url = Uri.parse('http://api-scs.prb.co.id/api/SampleTransaction/$idEmp');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        transactionHistory2.value = jsonResponse
            .map((data) => TransactionHistory2.fromJson(data as Map<String, dynamic>))
            .toList();
        print('URL: $url');
        print('StatusCode: ${response.statusCode}');
      } else {
        Get.snackbar('Error', 'Failed to fetch transaction history: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Exception occurred: $e');
      print('Exception occurred: $e');
    }
  }
}
