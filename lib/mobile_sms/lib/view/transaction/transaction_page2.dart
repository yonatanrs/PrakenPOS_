import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_presenter2.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';

class TransactionPage2 extends StatefulWidget {
  TransactionPage2({Key? key}) : super(key: key);

  @override
  State<TransactionPage2> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage2> {
  Widget customCard(int index, TransactionPresenter inputPagePresenter) {
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter
        .promotionProgramInputStateRx.value.promotionProgramInputState![index];
    final promotionProgramInputState2 = TextEditingController(text: "0");
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        borderOnForeground: true,
        semanticContainer: true,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Add Lines",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        inputPagePresenter.addItem();
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                    onPressed: () {
                      inputPagePresenter.removeItem(index);
                      // Gunakan update() jika menggunakan GetX atau setState() jika tidak
                      setState(() {});
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 10,
              ),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState
                      .productTransactionPageDropdownState!
                      .selectedChoiceWrapper
                      ?.value,
                  items: promotionProgramInputState
                      .productTransactionPageDropdownState
                      ?.choiceListWrapper
                      ?.value
                      ?.map((item) {
                    return DropdownMenuItem(
                        child: Text(item.value), value: item);
                  }).toList(),
                  hint: Text(
                    "Select Product",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value) {
                    inputPagePresenter.changeProduct(index, value);
                    Future.delayed(Duration(seconds: 1, milliseconds: 500), () {
                      setState(() {});
                    });
                  }
                  // isExpanded: true,
                  ),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState
                      .unitPageDropdownState?.selectedChoice,
                  items: promotionProgramInputState
                      .unitPageDropdownState?.choiceList
                      ?.map((item) {
                    return DropdownMenuItem(child: Text(item), value: item);
                  }).toList(),
                  hint: Text(
                    "Select Unit",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value) {
                    inputPagePresenter.changeUnit(index, value);
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  }
                  // isExpanded: true,
                  ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.qtyTransaction,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontFamily: 'AvenirLight'),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 20), // Increased input column height
                  ),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16, // Increased text size
                      fontFamily: 'AvenirLight'),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    // Call an existing method without changing it
                    inputPagePresenter.changeQty(index, value);
                  },
                ),
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState2,
                  inputFormatters: [
                    MoneyInputFormatter(
                        thousandSeparator: ".", decimalSeparator: ",")
                  ],
                  decoration: InputDecoration(
                    prefixText: "",
                    labelText: 'Price',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 22, // Adjusted for consistency
                        fontFamily: 'AvenirLight' // Consistent fontFamily
                        ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    // Decrease size by adjusting padding to bring text closer to underline
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10), // Decreased vertical padding
                  ),
                  readOnly: true,
                  // Make it read-only
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    // Make fontSize consistent with the first TextFormField
                    fontFamily: 'AvenirLight', // Make fontFamily consistent
                  ),
                ),
              ),
              // Container(
              //   width: Get.width,
              //   child: TextFormField(
              //     keyboardType: TextInputType.number,
              //     controller: promotionProgramInputState.discTransaction,
              //     readOnly: true,
              //     decoration: InputDecoration(
              //       labelText: 'Disc',
              //       suffixText: "(%)",
              //       labelStyle: TextStyle(
              //           color: Colors.black87,
              //           fontSize: 12,
              //           fontFamily: 'AvenirLight'
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide:
              //         BorderSide(color: Colors.purple),
              //       ),
              //       enabledBorder: new UnderlineInputBorder(
              //           borderSide: BorderSide(
              //               color: Colors.grey, width: 1.0)),
              //     ),
              //     style: TextStyle(
              //         color: Colors.black87,
              //         fontSize: 17,
              //         fontFamily: 'AvenirLight'),
              //     // onChanged: (value){
              //     //   inputPagePresenter.changeDisc(index, promotionProgramInputState.discTransaction.text);
              //     // },
              //     onTap: (){
              //       Get.defaultDialog(
              //           title: "",
              //           barrierDismissible: false,
              //           onWillPop: () {
              //             return Future.value(false);
              //           },
              //           content: TextFormField(
              //             controller: promotionProgramInputState.discTransaction,
              //             keyboardType: TextInputType.number,
              //             inputFormatters: <TextInputFormatter>[
              //               FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              //             ],
              //             decoration: InputDecoration(
              //                 labelText: "Set Discount : ",
              //                 suffixText: "%"
              //             ),
              //           ),
              //           confirm: TextButton(
              //               style: TextButton.styleFrom(
              //                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //                 backgroundColor: colorSecondary,
              //                 shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(100)),
              //               ),
              //               child: Text(
              //                 "Ok",
              //                 style:
              //                 TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              //               ),
              //               onPressed: () {
              //                 inputPagePresenter.changeDisc(index, promotionProgramInputState.discTransaction!.text);
              //                 Get.back();
              //               }),
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Total",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontFamily: 'AvenirLight'),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                promotionProgramInputState.totalTransaction!.value.text.isEmpty
                    ? "0"
                    : "Rp " +
                        MoneyFormatter(
                                amount: double.parse(promotionProgramInputState
                                    .totalTransaction!.value.text
                                    .replaceAll(",", "")))
                            .output
                            .withoutFractionDigits,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'AvenirLight', // Ukuran teks ditingkatkan
                ),
              ),

              Divider(
                thickness: 1,
                color: Colors.black54,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputPagePresenter = Get.put(TransactionPresenter());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, right: 20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                borderOnForeground: true,
                semanticContainer: true,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "New Sample Order",
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Get.width,
                        child: Obx(() => SearchChoices.single(
                              isExpanded: true,
                              value: inputPagePresenter
                                  .customerNameInputPageDropdownStateRx
                                  .value
                                  .selectedChoice,
                              hint: Text(
                                "Customer Name",
                                style: TextStyle(fontSize: 15),
                              ),
                              items: inputPagePresenter
                                  .customerNameInputPageDropdownStateRx
                                  .value
                                  .choiceList
                                  ?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item.value,
                                      style: TextStyle(fontSize: 15)),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) => inputPagePresenter
                                  .changeSelectCustomer(value),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              InputPageWrapper inputPageWrapper =
                  inputPagePresenter.promotionProgramInputStateRx.value;
              List<PromotionProgramInputState>? promotionProgramInputStateList =
                  inputPageWrapper.promotionProgramInputState;
              bool? isAddItem = inputPageWrapper.isAddItem;
              return promotionProgramInputStateList?.length == 0
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBlueDark,
                      ),
                      child: Text("Add Data Transaction",
                          style: TextStyle(color: Colors.white)),
                      onPressed: isAddItem!
                          ? () => inputPagePresenter.addItem()
                          : null)
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: promotionProgramInputStateList?.length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              customCard(index, inputPagePresenter),
                              SizedBox(
                                height: 10,
                              ),
                              index ==
                                      promotionProgramInputStateList!.length -
                                          promotionProgramInputStateList.length
                                  ? Column(
                                      children: [],
                                    )
                                  : SizedBox(),
                              index ==
                                      promotionProgramInputStateList.length -
                                          promotionProgramInputStateList.length
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorBlueDark,
                                      ),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        List<PromotionProgramInputState>?
                                            promotionProgramInputState =
                                            inputPagePresenter
                                                .promotionProgramInputStateRx
                                                .value
                                                .promotionProgramInputState
                                                ?.toList();
                                        // Memanggil fungsi submit secara langsung tanpa delay
                                        await inputPagePresenter
                                            .submitPromotionProgram();
                                      }
                                      // inputPagePresenter.submitPromotionProgram();
                                      )
                                  : SizedBox()
                            ],
                          ));
            }),
          ],
        ),
      )),
    );
  }
}
