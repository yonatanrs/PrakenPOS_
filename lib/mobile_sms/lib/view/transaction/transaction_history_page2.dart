import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_presenter2.dart';

class TransactionHistoryPage2 extends StatelessWidget {
  TransactionHistoryPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transactionHistoryPresenter = Get.put(TransactionHistoryPresenter2());
    return Obx(() => Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Adjusted horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transactionHistoryPresenter.transactionHistory2.length,
                itemBuilder: (context, index) {
                  final transaction = transactionHistoryPresenter.transactionHistory2[index];
                  return InkWell(
                    onTap: () async {
                      String? idTransaction = transaction.SalesId;
                      await transactionHistoryPresenter.getTransactionHistoryDetail(idTransaction!);
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.white, // Warna merah untuk lapisan atas
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red, // Warna merah
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10), // Membulatkan sudut
                                          ),
                                        ),
                                        child: Icon(Icons.close, color: Colors.white), // Icon X dengan warna putih
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: ListTile(
                                    title: Text('Product: ${transactionHistoryPresenter.listDetail[0]["Product"]}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Unit: ${transactionHistoryPresenter.listDetail[0]["Unit"]}'),
                                        Text('Qty: ${transactionHistoryPresenter.listDetail[0]["Qty"]}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8), // Adjusted margin for spacing between cards
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
                      child: ListTile(
                        leading: Icon(Icons.description, color: Colors.blue),
                        title: Text(
                          transaction.SalesId ?? "N/A",
                          style: TextStyle(fontSize: 16,), // Title style
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${transaction.Customer}'),
                            Text('Cust.Reff: ${transaction.CustReff}'),
                            Text(
                              'Date: ${DateFormat("dd-MM-yyyy hh:mm").format(DateTime.parse(transaction.Date!))}',
                            ),
                            Text('Status ${transaction.Status}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}