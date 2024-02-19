import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'set-promo-presenter.dart';

class SetPromoApprovalDetailPage extends StatefulWidget {
  int id;

  SetPromoApprovalDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  _SetPromoApprovalDetailPageState createState() => _SetPromoApprovalDetailPageState();
}

class _SetPromoApprovalDetailPageState extends State<SetPromoApprovalDetailPage> {
  final setPromoPresenter = Get.put(SetPromoPresenter());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPromoPresenter.getApprovalDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    setPromoPresenter.getApprovalDetail(widget.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Approval Detail Promosi"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name  :"),
                    Obx(
                          () => Text(setPromoPresenter
                          .dataApprovalDetails.value.name ??
                          ""),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status  :"),
                    Obx(
                          () => Text(setPromoPresenter
                          .dataApprovalDetails.value.status ??
                          ""),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("CreatedBy :"),
                    Obx(
                          () => Text(setPromoPresenter
                          .dataApprovalDetails.value.createdBy ??
                          ""),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Cust ID :")),
                    SizedBox(width: 50,),
                    Expanded(
                      child: Obx(
                            () => Text(
                              "${setPromoPresenter.dataApprovalDetails.value.custId}",
                              maxLines: 10,
                              // overflow: TextOverflow.visible,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Lines :"),
                Obx(
                      () => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: setPromoPresenter.dataLines.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                    "ItemId: ${setPromoPresenter.dataLines[index].itemId ?? " "}",
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
                                    "Unit : ${setPromoPresenter.dataLines[index].unit}",
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
                                    "Qty : ${setPromoPresenter.dataLines[index].qty}",
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
                                    "Price : ${setPromoPresenter.dataLines[index].price}",
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
                                    "Discount : ${setPromoPresenter.dataLines[index].disc}",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
