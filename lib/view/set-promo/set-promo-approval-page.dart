
import 'package:flutter/material.dart';
import 'package:flutter_scs/view/set-promo/set-promo-approval-detail-page.dart';
import 'package:flutter_scs/view/set-promo/set-promo-presenter.dart';
import 'package:get/get.dart';

class SetPromoApprovalPage extends StatefulWidget {
  const SetPromoApprovalPage({Key? key}) : super(key: key);

  @override
  _SetPromoApprovalPageState createState() => _SetPromoApprovalPageState();
}

class _SetPromoApprovalPageState extends State<SetPromoApprovalPage> {
  final approvalPromoPresenter = Get.put(SetPromoPresenter());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approvalPromoPresenter.getDataApproval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Promo"),
      ),
      body: SafeArea(
          child: Obx(()=>ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: approvalPromoPresenter.data.length,
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
                            "Name : ${approvalPromoPresenter.data[index].name}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Status : ${approvalPromoPresenter.data[index].status ?? " "}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.blue,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Created By : ${approvalPromoPresenter.data[index].createdBy}",
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
                            "Date : ${approvalPromoPresenter.data[index].createdDateTime}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.all(6),
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Lines : ${approvalPromoPresenter.data[index].lines}",
                        //     textAlign: TextAlign.left,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.blue,
                        //     ),
                        //   ),
                        // ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Container(
                                height: 60,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: Colors.orange,
                                  endIndent: 20,
                                  indent: 5,
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 30,
                                child: InkWell(
                                    child: Text(
                                      "DETAILS",
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(SetPromoApprovalDetailPage(
                                        id: approvalPromoPresenter.data[index].id!,
                                      ));
                                    }),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 60,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: Colors.orange,
                                  endIndent: 20,
                                  indent: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),)
      ),
    );
  }
}
