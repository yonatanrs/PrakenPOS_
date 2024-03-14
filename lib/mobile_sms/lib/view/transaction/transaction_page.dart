import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/global.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_presenter.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  Widget customCard(int index, TransactionPresenter inputPagePresenter){
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState![index];

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
                  Text("Add Lines"),
                  Spacer(),
                  IconButton(
                      onPressed: (){
                        inputPagePresenter.addItem();
                      },
                      icon: Icon(Icons.add)
                  ),
                  IconButton(
                      onPressed: (){
                        // Future.delayed(Duration(milliseconds: ),(){
                        inputPagePresenter.removeItem(index);
                        // });
                        // Future.delayed(Duration(milliseconds: 500),(){
                        //   setState(() {
                        //   });
                        // });
                      },
                      icon: Icon(Icons.delete,)
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10,),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState.productTransactionPageDropdownState!.selectedChoiceWrapper?.value,
                  items: promotionProgramInputState.productTransactionPageDropdownState?.choiceListWrapper?.value?.map((item) {
                    return DropdownMenuItem(
                        child: Text(item.value),
                        value: item
                    );
                  }).toList(),
                  hint: Text(
                    "Select Product",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value){
                    inputPagePresenter.changeProduct(index, value);
                    Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                      setState(() {
                      });
                    });
                  }
                // isExpanded: true,
              ),
              SearchChoices.single(
                  isExpanded: true,
                  value: promotionProgramInputState.unitPageDropdownState?.selectedChoice,
                  items: promotionProgramInputState.unitPageDropdownState?.choiceList?.map((item) {
                    return DropdownMenuItem(
                        child: Text(item),
                        value: item
                    );
                  }).toList(),
                  hint: Text(
                    "Select Unit",
                    style: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value){
                    inputPagePresenter.changeUnit(index, value);
                    Future.delayed(Duration(seconds: 1),(){
                      setState(() {

                      });
                    });
                  }
                // isExpanded: true,
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.qtyTransaction,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontFamily: 'AvenirLight'
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.0)),
                  ),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontFamily: 'AvenirLight'),
                  onTap: (){
                    Get.defaultDialog(
                      title: "",
                      barrierDismissible: false,
                      onWillPop: () {
                        return Future.value(false);
                      },
                      content: TextFormField(
                        controller: promotionProgramInputState.qtyTransaction,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                            labelText: "Set Qty : ",
                            suffixText: ""
                        ),
                      ),
                      confirm: TextButton(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: colorSecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          child: Text(
                            "Ok",
                            style:
                            TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            inputPagePresenter.changeQty(index, promotionProgramInputState.qtyTransaction!.text);
                            Get.back();
                          }),
                    );
                  },
                ),
              ),
              Container(
                width: Get.width,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: promotionProgramInputState.priceTransaction,
                  inputFormatters: [
                    MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                  ],
                  decoration: InputDecoration(
                    prefixText: "Rp ",
                    labelText: 'Price',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontFamily: 'AvenirLight'
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey, width: 1.0)),
                  ),
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontFamily: 'AvenirLight'),
                  // onChanged: (value){
                  //   inputPagePresenter.changePrice(index, promotionProgramInputState.priceTransaction.text);
                  // },
                  onTap: (){
                    Get.defaultDialog(
                      title: "",
                      barrierDismissible: false,
                      onWillPop: () {
                        return Future.value(false);
                      },
                      content: TextFormField(
                        controller: promotionProgramInputState.priceTransaction,
                        keyboardType: TextInputType.number,
                        // onChanged: (value){
                        //   textFormField.inputFormatters.removeWhere((formatter) => formatter is MoneyInputFormatter);
                        // },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          MoneyInputFormatter(thousandSeparator: ".", decimalSeparator: ",")
                        ],
                        decoration: InputDecoration(
                            labelText: "Set Price : ",
                            suffixText: ""
                        ),
                      ),
                      confirm: TextButton(
                          style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: colorSecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          child: Text(
                            "Ok",
                            style:
                            TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            // Future.delayed(Duration(milliseconds: 500),(){
                            inputPagePresenter.changePrice(index, promotionProgramInputState.priceTransaction!.text);
                            // });
                            // Future.delayed(Duration(milliseconds: 600),(){
                            //   setState(() {
                            //
                            //   });
                            // });
                            Get.back();
                          }),
                    );
                  },
                  //  controller: _passwordController,
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
              SizedBox(height: 8,),
              Text("Total",style: TextStyle(fontSize: 11),),
              SizedBox(height: 3,),
              Text(promotionProgramInputState.totalTransaction!.value.text.isEmpty?"0":"Rp "+MoneyFormatter(amount: double.parse(promotionProgramInputState.totalTransaction!.value.text.replaceAll(",", ""))).output.withoutFractionDigits),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    borderOnForeground: true,
                    semanticContainer: true,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create"),
                          SizedBox(height: 5),
                          Text(
                            "New Order Taking",
                            style: TextStyle(fontSize: 10, color: Colors.black54),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Get.width,
                            child: Obx(() => SearchChoices.single(
                              isExpanded: true,
                              value: inputPagePresenter.customerNameInputPageDropdownStateRx.value.selectedChoice,
                              hint: Text(
                                "Customer Name",
                                style: TextStyle(fontSize: 12),
                              ),
                              items: inputPagePresenter.customerNameInputPageDropdownStateRx.value.choiceList?.map((item) {
                                return DropdownMenuItem(
                                  child: Text(
                                      item.value,
                                      style: TextStyle(fontSize: 12)
                                  ),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) => inputPagePresenter.changeSelectCustomer(value),
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
                  InputPageWrapper inputPageWrapper = inputPagePresenter.promotionProgramInputStateRx.value;
                  List<PromotionProgramInputState>? promotionProgramInputStateList = inputPageWrapper.promotionProgramInputState;
                  bool? isAddItem = inputPageWrapper.isAddItem;
                  return promotionProgramInputStateList?.length == 0 ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBlueDark,
                      ),
                      child: Text("Add Data Transaction",style: TextStyle(color: Colors.white)),
                      onPressed: isAddItem! ? () => inputPagePresenter.addItem() : null
                  ) : ListView.builder(
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

                          index == promotionProgramInputStateList!.length - promotionProgramInputStateList.length ? Column(
                            children: [

                            ],
                          ) : SizedBox(),
                          index == promotionProgramInputStateList.length - promotionProgramInputStateList.length ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorBlueDark,
                              ),
                              child: Text("Submit"),
                              onPressed: (){
                                List<PromotionProgramInputState>? promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState?.toList();
                                List disc = promotionProgramInputState!.map((e) => e.discTransaction?.text).toList();
                                List<String?> price = promotionProgramInputState.map((e) => e.priceTransaction?.text).toList();
                                print(disc);
                                print("originalPrice ${inputPagePresenter.originalPrice.toString()}");
                                print("Editing price :$price");
                                bool isEqual = listEquals(inputPagePresenter.originalPrice, price);
                                if(isEqual){
                                  print("x");
                                  inputPagePresenter.submitPromotionProgram();
                                }else{
                                  print("y");

                                  Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                                    inputPagePresenter.submitPromotionProgram();
                                  });
                                  Future.delayed(Duration(seconds: 1, milliseconds: 500),(){
                                    inputPagePresenter.submitPromotionProgramAll();
                                  });
                                }
                                // inputPagePresenter.submitPromotionProgram();
                              }
                          ) : SizedBox()
                        ],
                      )
                  );
                }),
              ],
            ),
          )
      ),
    );
  }
}