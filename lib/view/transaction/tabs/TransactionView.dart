import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/ExpansionTileAdapter.dart';
import 'package:flutter_scs/assets/uistate/widget_state_error.dart';
import 'package:flutter_scs/assets/uistate/widget_state_no_data.dart';
import 'package:flutter_scs/state_management/getx/TransactionController.dart';
import 'package:get/get.dart';

class TransactionView extends StatefulWidget {
  @override
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  var transactionController = Get.put(TransactionController());

  @override
  void initState() {
    super.initState();
    listTransaction();
  }

  void listTransaction() {
    transactionController.getTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return transactionController.obx(
        (state) => ListView.builder(
            itemCount: state?.length,
            itemBuilder: (BuildContext context, int index) =>
                ExpansionTileAdapter(models: state![index])),
        onError: (value) =>
            WidgetStateError(message: value!, onPressed: listTransaction),
        onEmpty: WidgetStateNoData(message: "No Data"));
  }
}
