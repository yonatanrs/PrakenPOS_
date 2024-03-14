import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_approval_presenter.dart'; // Sesuaikan dengan path yang benar

class TransactionApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionApprovalPresenter presenter = Get.put(TransactionApprovalPresenter());

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Transaction Approvals'),
      // ),
      body:  Obx(() {
        if (presenter.approvalList.isEmpty) {
          return Center(child: Text('Data Tidak Ditemukan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }
        return ListView.builder(
          itemCount: presenter.approvalList.length,
          itemBuilder: (context, index) {
            final approval = presenter.approvalList[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(Icons.description, color: Colors.blue),
                title: Text(approval.salesOrder),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Customer: ${approval.customer}'),
                    Text('Date: ${approval.date}'),
                    Text('Status: ${approval.status}'),
                  ],
                ),
                isThreeLine: true,
                onTap: () => presenter.showApprovalDetail(context, approval.id),
              ),
            );
          },
        );
      }),
    );
  }
}
