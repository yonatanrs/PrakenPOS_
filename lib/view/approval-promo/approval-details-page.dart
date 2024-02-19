import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_input_formatter/money_input_formatter.dart';

import 'approval-promo-presenter.dart';

class ApprovalDetailsPage extends StatefulWidget {
  int? id;

  ApprovalDetailsPage({Key? key, this.id}) : super(key: key);

  @override
  _ApprovalDetailsPageState createState() => _ApprovalDetailsPageState();
}

class _ApprovalDetailsPageState extends State<ApprovalDetailsPage> {
  final approvalPromoPresenter = Get.put(ApprovalPromoPresenter());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approvalPromoPresenter.getApprovalDetail(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    approvalPromoPresenter.getApprovalDetail(widget.id!);
    return Scaffold(
      appBar: AppBar(
        title: Text("Approval Detail Promosi"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 1,
            itemBuilder: (BuildContext context, int index){

              // List<TextEditingController> _controllerPrice = [];
              // for (int i = 1; i < approvalPromoPresenter.dataLines[index].price; i++) _controllerPrice.add(TextEditingController());
              // String convertPrice = approvalPromoPresenter.dataLines[index].price.toString();
              // _controllerPrice[index].text = convertPrice;
              //
              // List<TextEditingController> _controllerDiscount = [];
              // for (int i = 1; i < approvalPromoPresenter.dataLines[index].disc; i++) _controllerDiscount.add(TextEditingController());
              // String convertDiscount = approvalPromoPresenter.dataLines[index].disc.toString();
              // _controllerDiscount[index].text = convertDiscount;

              return Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name  :"),
                        Obx(() => Text(approvalPromoPresenter.dataApprovalDetails.value.name ?? ""))
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status  :"),
                        Obx(
                              () => Text(approvalPromoPresenter
                              .dataApprovalDetails.value.status ??
                              ""),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("CreatedBy :"),
                        Obx(
                              () => Text(approvalPromoPresenter
                              .dataApprovalDetails.value.createdBy ??
                              ""),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CustID :",
                        ),
                        Spacer(),
                        Obx(
                              () => Flexible(
                            child: Text(
                                approvalPromoPresenter.dataApprovalDetails.value.custId??""),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Lines :"),
                    SizedBox(height: 10,),
                    Obx(
                          () => ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: approvalPromoPresenter.dataLines.length,
                          itemBuilder: (BuildContext context, int index) {
                            List<TextEditingController> _controllerPrice = [];
                            for (int i = 1; i < approvalPromoPresenter.dataLines[index].price; i++) _controllerPrice.add(TextEditingController());
                            String convertPrice = approvalPromoPresenter.dataLines[index].price.toString();
                            _controllerPrice[index].text = convertPrice;

                            print("ini 1: ${_controllerPrice[index].text}");

                            List<TextEditingController> _controllerDiscount = <TextEditingController>[];
                            for (int i = 0; i < approvalPromoPresenter.dataLines[index].disc; i++) _controllerDiscount.add(TextEditingController());
                            String convertDiscount = approvalPromoPresenter.dataLines[index].disc.toString();
                            _controllerDiscount[index].text = convertDiscount;

                            print("ini 2: ${_controllerDiscount[index].text}");

                            return Container(
                              padding: EdgeInsets.all(7),
                              child: Card(
                                elevation: 3,
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "ItemId: ${approvalPromoPresenter.dataLines[index].itemId ?? " "}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Unit : ${approvalPromoPresenter.dataLines[index].unit}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Qty : ${approvalPromoPresenter.dataLines[index].qty}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          prefixText: "Rp. ",
                                          prefixStyle: TextStyle(color: Colors.blue, fontSize: 12 ),
                                          label: Text("Price : ",style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),),
                                          isDense: true,
                                        ),
                                        controller: _controllerPrice[index],
                                        inputFormatters: [
                                          MoneyInputFormatter(thousandSeparator: ",", decimalSeparator: ".")
                                        ],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      alignment: Alignment.centerLeft,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          suffixText: "%                                                                                              ",
                                          suffixStyle: TextStyle(color: Colors.blue, fontSize: 12),
                                          label: Text("Discount : ",style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),),
                                          isDense: true,
                                        ),
                                        controller: _controllerDiscount[index],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 5,
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.orange,
                                          indent: 5,
                                          endIndent: 5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    //Ini row button
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text("Approve"),
                            onPressed: () {
                              approvalPromoPresenter.approvalProcess(context, widget.id!, approvalPromoPresenter.dataLines[index].price, approvalPromoPresenter.dataLines[index].disc);
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text("Reject"),
                            onPressed: () {
                              approvalPromoPresenter.rejectProcess(context, widget.id!, approvalPromoPresenter.dataLines[index].price, approvalPromoPresenter.dataLines[index].disc);
                            }),
                      ],
                    ),
                  ],
                ),
              );
            })
      ),
    );
  }
}
