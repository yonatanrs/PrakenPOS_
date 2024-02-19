import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_presenter2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

class TransactionHistoryPage2 extends StatelessWidget {
  TransactionHistoryPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionHistoryPresenter = Get.put(TransactionHistoryPresenter2());
    return Obx(() => Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: transactionHistoryPresenter.transactionHistory2.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        int indexes = index;
                        Get.bottomSheet(
                            ListView.builder(
                                shrinkWrap: true,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: transactionHistoryPresenter.transactionHistory2[index].transactionLines?.length,
                                itemBuilder: (context, index) {
                                  print("total ${transactionHistoryPresenter.transactionHistory2[index].transactionLines?[index].totalPrice}");
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text("Product Id"),
                                            Spacer(),
                                            Text("${transactionHistoryPresenter.transactionHistory2[indexes].transactionLines?[index].productId}"),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Product Name"),
                                            Spacer(),
                                            Expanded(child: Text("${transactionHistoryPresenter.transactionHistory2[indexes].transactionLines?[index].productName}")),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Unit"),
                                            Spacer(),
                                            Text("${transactionHistoryPresenter.transactionHistory2[indexes].transactionLines?[index].unit}"),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Qty"),
                                            Spacer(),
                                            Text("${transactionHistoryPresenter.transactionHistory2[indexes].transactionLines?[index].qty}"),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Disc"),
                                            Spacer(),
                                            Text("${transactionHistoryPresenter.transactionHistory2[indexes].transactionLines?[index].disc??0} %"),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Price"),
                                            Spacer(),
                                            Text("Rp ${MoneyFormatter(amount: double.parse(transactionHistoryPresenter.transactionHistory2[indexes].transactionLines![index].price.toString())).output.withoutFractionDigits}"),
                                          ]),
                                          SizedBox(height: 12,),
                                          Row(children: [
                                            Text("Total Price"),
                                            Spacer(),
                                            Text("Rp ${MoneyFormatter(amount: double.parse(transactionHistoryPresenter.transactionHistory2[indexes].transactionLines![index].totalPrice.toString().replaceAll(RegExp(r"[.,]"), ""))).output.withoutFractionDigits}"),
                                            // Text("Rp ${MoneyFormatter(amount: double.parse(transactionHistoryPresenter.transactionHistory[indexes].transactionLines[index].totalPrice.toString().replaceAll(RegExp(r"[.,]"), ""))).output.withoutFractionDigits}"),
                                          ]),
                                          // SizedBox(height: 12,),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Row(children: [
                                Text("Customer Name"),
                                Spacer(),
                                Expanded(child: Text("${transactionHistoryPresenter.transactionHistory2[index].Customer/*.split("-")[0]*/}")),
                              ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                Text("Date"),
                                Spacer(),
                                Text("${DateFormat("dd-MM-yyyy hh:mm").format(DateTime.parse(transactionHistoryPresenter.transactionHistory2[index].Date!))}"),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    );
                  })

            ],
          ),
        ),
      ),
    ));
  }
}
