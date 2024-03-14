import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_approved_presenter.dart'; // Sesuaikan dengan path yang benar

class TransactionApprovedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionApprovedPresenter presenter = Get.put(TransactionApprovedPresenter());

    return Scaffold(

      body: Obx(() {
        if (presenter.approvedList.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: presenter.approvedList.length,
          itemBuilder: (context, index) {
            final approved = presenter.approvedList[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(Icons.description, color: Colors.blue),
                title: Text(approved.salesOrder),
                subtitle: Text('Customer: ${approved.customer}\nDate: ${approved.date}'),
                onTap: () => presenter.showApprovedDetail(context, approved.id), // Pastikan objek `Approved` memiliki `id`
              ),
            );
          },
        );
      }),
    );
  }
}
