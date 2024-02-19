import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_scs/view/set-promo/set-promo-approval-page.dart';
import 'package:flutter_scs/view/set-promo/set-promo-presenter.dart';
import 'package:get/get.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';

import '../../models/PromoInputState.dart';
import '../../models/promosi.dart';
import '../MainMenuView.dart';

class SetPromoPage extends StatefulWidget {
  SetPromoPage({Key? key}) : super(key: key);

  @override
  State<SetPromoPage> createState() => _SetPromoPageState();
}

class _SetPromoPageState extends State<SetPromoPage> {
  Widget customCard(int index, PromoInputState promoInputState, BuildContext context) {
    return Card(
      borderOnForeground: true,
      semanticContainer: true,
      shadowColor: Colors.black87,
      elevation: 15,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Lines",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    setPromoPresenter.removeItem(index);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
            Divider(
              thickness: 3,
            ),
            SizedBox(height: 20),
            // Builder(builder: (content) {
            //   if (customerState > 1) {
            //     return Obx(()=>SearchChoices.single(
            //         isExpanded: true,
            //         label: "Select Customer",
            //         style: TextStyle(
            //           color: Colors.black87,
            //         ),
            //         hint: "Select One",
            //         value: promoInput.customerId,
            //         items: setPromoPresenter.promoInputStateRx.value.dataCustomer.map((item) {
            //           return DropdownMenuItem(
            //               child: Text(
            //                 item["nameCust"],
            //                 overflow: TextOverflow.fade,
            //               ),
            //             value: (item["codeCust"] + ' ' + item["nameCust"])
            //           );
            //         }).toList(),
            //         onChanged: (value) {
            //           print("ini value ${value.toString().split(' ')[0]}");
            //
            //           print("cek :${promoInput.customerId}");
            //           print(value);
            //           setPromoPresenter.getItemProduct(index, value);
            //         }));
            //   } else {
            //     return Column(children: [
            //       Container(width: 120.0, height: 25.0, color: Colors.grey),
            //       SizedBox(height: 10.0)
            //     ]);
            //   }
            // }),
            Builder(builder: (content) {
              if (promoInputState.dataItemState! > 1) {
                return SearchChoices.single(
                  isExpanded: true,
                  label: "Select Item Product",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  hint: "Select One",
                  value: promoInputState.promoInput![index].itemId,
                  items: promoInputState.dataItem!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item["nameProduct"],
                        overflow: TextOverflow.fade,
                      ),
                      value: item["idProduct"].toString() + " " + item['nameProduct'].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setPromoPresenter.getUnit(index, value);
                  },
                );
              } else {
                return Column(children: [
                  Container(width: 120.0, height: 25.0, color: Colors.grey),
                  SizedBox(height: 10.0)
                ]);
              }
            }),
            Builder(builder: (content) {
              if (promoInputState.promoInput![index].dataUnitState! > 1) {
                return SearchChoices.single(
                  label: "Select Unit",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  hint: "Select One",
                  value: promoInputState.promoInput![index].unit,
                  items: promoInputState.promoInput![index].dataUnit!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item,
                        overflow: TextOverflow.fade,
                      ),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setPromoPresenter.setUnit(index, value);
                  },
                );
              } else {
                return Column(children: [
                  Container(width: 120.0, height: 25.0, color: Colors.grey),
                  SizedBox(height: 10.0)
                ]);
              }
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFormField(
                      controller: promoInputState.promoInput![index].qtyTextInputController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Qty',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontFamily: 'AvenirLight'),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFormField(
                      autofocus: false,
                      controller: promoInputState.promoInput![index].priceTextInputController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MoneyInputFormatter(thousandSeparator: ",", decimalSeparator: ".")
                        // CurrencyTextInputFormatter(
                        //   decimalDigits: 0,
                        //   turnOffGrouping: true,
                        //   locale: 'id',
                        // ),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontFamily: 'AvenirLight'),
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFormField(
                      controller: promoInputState.promoInput![index].discountTextInputController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: "%       ",
                        labelText: 'Discount',
                        labelStyle: TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontFamily: 'AvenirLight'),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontFamily: 'AvenirLight'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  final setPromoPresenter = Get.put(SetPromoPresenter());

  Promosi promosi = Promosi();

  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter(decimalDigits: 0, locale: 'id',);

  final lowPrice = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create Promo"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: setPromoPresenter.promoInputStateRx.value.nameTextEditingController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontFamily: 'AvenirLight'),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      fontFamily: 'AvenirLight'),
                ),
                SizedBox(
                  height: 20,
                ),
                SearchChoices.single(
                  label: "Select Customer",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                  hint: "Select One",
                  value: setPromoPresenter.promoInputStateRx.value.customerId,
                  items: setPromoPresenter.promoInputStateRx.value.dataCustomer!.map((item) {
                    return DropdownMenuItem(
                      child: Text(
                        item["nameCust"],
                        overflow: TextOverflow.fade,
                      ),

                      value: item["codeCust"].toString() + " " + item["nameCust"].toString(),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setPromoPresenter.getItemProduct(value);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Builder(
                    builder: (context) {
                      return setPromoPresenter.promoInputStateRx.value.promoInput!.length == 0 ? Column(
                        children: [
                          Text(
                            "Please Create New Form!!",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //CircularProgressIndicator(),
                        ],
                      ) : Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: setPromoPresenter
                              .promoInputStateRx.value.promoInput!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return customCard(index, setPromoPresenter.promoInputStateRx.value, context);
                          },
                        ),
                      );
                    }
                  )
                )
              ],
            ),
          )),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.format_align_justify_outlined),
              onPressed: () {
                Get.to(SetPromoApprovalPage());
              },
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                setPromoPresenter.addPromoItem();
              },
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            /*FloatingActionButton(
              child: Icon(
                Icons.delete
              ),
              onPressed: () {
                removeItem(setPromoPresenter.promoInputRx[])
              },
              heroTag: null,
            ),*/
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              child: Icon(Icons.send),
              onPressed: () {
                if(setPromoPresenter.promoInputStateRx.value.nameTextEditingController!.value.text.isEmpty&&setPromoPresenter.promoInputStateRx.value.customerId!.isEmpty){
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Row(
                          children: [
                            Text('Submit Failed'),
                            SizedBox(width: 10,),
                            Icon(Icons.error, color: Colors.red,),
                          ],
                        ),
                        content: Text('Please fill the form !!', style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      )
                  );
                }else{
                  setPromoPresenter.createPromosi();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
