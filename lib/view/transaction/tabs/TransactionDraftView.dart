import 'package:flutter/material.dart';
import 'package:flutter_scs/adapters/ExpansionDraftAdapter.dart';
import 'package:flutter_scs/assets/uistate/widget_state_error.dart';
import 'package:flutter_scs/assets/uistate/widget_state_no_data.dart';
import 'package:flutter_scs/state_management/getx/TransactionDraftController.dart';
import 'package:get/get.dart';

class TransactionDraftView extends StatefulWidget {
  @override
  _TransactionDraftViewState createState() => _TransactionDraftViewState();
}

class _TransactionDraftViewState extends State<TransactionDraftView> {
  var transactionDraftController = Get.put(TransactionDraftController());

  @override
  void initState() {
    super.initState();
    listTransaction();
  }

  void listTransaction() {
    transactionDraftController.getTransactionDraft();
  }

  @override
  Widget build(BuildContext context) {
    return transactionDraftController.obx(
        (state) => ListView.builder(
            itemCount: state?.length,
            itemBuilder: (BuildContext context, int index) =>
                ExpansionTileAdapter(headModels: state![index])),
        onError: (value) =>
            WidgetStateError(message: value!, onPressed: listTransaction),
        onEmpty: WidgetStateNoData(message: "No Data"));
  }
}
