import 'dart:convert';
import 'dart:developer';
import 'package:flutter_scs/mobile_sms/lib/models/transactionHistory.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class TransactionHistoryPresenter extends GetxController{

  // TransactionHistory transactionHistory = TransactionHistory();
  var transactionHistory = <TransactionHistory>[].obs;
  TransactionLines transactionLines = TransactionLines();

  List data = [];

  getTransactionHistory()async{
    var url = "http://119.18.157.236:8869/api/transaction";
    final response = await get(Uri.parse(url));
    // transactionLines = TransactionLines.fromJson(jsonDecode(response.body));
    // data = jsonDecode(response.body);
    transactionHistory.value = (jsonDecode(response.body)as List).map((data) => TransactionHistory.fromJson(data)).toList();
    // print("transactionHistory :${data[0]['transactionLines']}");
    print("transactionHistory :${jsonEncode(transactionHistory.length)}");
    log("transactionHistory :${jsonEncode(transactionHistory)}");
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      getTransactionHistory();
    });
  }

}