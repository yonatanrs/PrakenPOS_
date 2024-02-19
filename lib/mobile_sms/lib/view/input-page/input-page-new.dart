import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:search_choices/search_choices.dart';
import '../../models/IdAndValue.dart';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';
import '../dashboard/dashboard_pp.dart';
import 'input-page-presenter-new.dart';

class InputPageNew extends StatefulWidget {
  InputPageNew({Key? key}) : super(key: key);

  @override
  State<InputPageNew> createState() => _InputPageNewState();
}

class _InputPageNewState extends State<InputPageNew> {
  Widget customCard(int index, InputPagePresenterNew inputPagePresenter) {
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter
        .promotionProgramInputStateRx.value.promotionProgramInputState![index];
    // promotionProgramInputState.qtyFrom.text = 1.toString();
    // promotionProgramInputState.qtyTo.text = 1.toString();
    // promotionProgramInputState.fromDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // promotionProgramInputState.toDate.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
                      onPressed: () {
                        inputPagePresenter.addItem();
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        inputPagePresenter.removeItem(index);
                        inputPagePresenter.onTap.value = false;
                      },
                      icon: Icon(
                        Icons.delete,
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // DropdownButtonFormField<String>(
              //   isExpanded: true,
              //   isDense: true,
              //   value: promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice,
              //   hint: Text(
              //     "Customer/Cust Group",
              //     style: TextStyle(fontSize: 12),
              //   ),
              //   items: promotionProgramInputState.customerGroupInputPageDropdownState.choiceList.map((item) {
              //     return DropdownMenuItem(
              //       child: Text(
              //         item,
              //         style: TextStyle(fontSize: 12),
              //         overflow: TextOverflow.fade,
              //       ),
              //       value: item,
              //     );
              //   }).toList(),
              //   onChanged: (value) => inputPagePresenter.changeCustomerGroup(index, value)
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // SearchChoices.single(
              //   items: promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState.choiceList.map((item) {
              //     return DropdownMenuItem(
              //       child: Text(
              //         item.value,
              //         style: TextStyle(fontSize: 12),
              //         overflow: TextOverflow.fade,
              //       ),
              //       value: item,
              //     );
              //   }).toList(),
              //   value: promotionProgramInputState.customerNameOrDiscountGroupInputPageDropdownState.selectedChoice,
              //   hint: Builder(
              //     builder: (context) {
              //       String text = (promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice ?? "").toLowerCase() == "Customer"
              //           ? "Customer Name" : "Discount Group Name";
              //       return Text(
              //         promotionProgramInputState.customerGroupInputPageDropdownState.selectedChoice=="Customer"?"Select Customer": "Select Discount Group",
              //         style: TextStyle(fontSize: 12),
              //       );
              //     }
              //   ),
              //   onChanged: (value) => inputPagePresenter.changeCustomerNameOrDiscountGroup(index, value),
              //   isExpanded: true,
              // ),
              // SizedBox(height: 10,),
              //ite, group
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Item/Item Group",
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                  SearchChoices.single(
                    isExpanded: true,
                    value: promotionProgramInputState
                        .itemGroupInputPageDropdownState?.selectedChoice,
                    hint: Text(
                      "Item/Item Group",
                      style: TextStyle(fontSize: 12),
                    ),
                    items: promotionProgramInputState
                        .itemGroupInputPageDropdownState?.choiceList
                        ?.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.fade,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        inputPagePresenter.changeItemGroup(index, value),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Item Product",
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: promotionProgramInputState
                                  .selectProductPageDropdownState
                                  ?.selectedChoice !=
                              null
                          ? 10
                          : 0,
                    ),
                    child: SearchChoices.single(
                        isExpanded: true,
                        value: promotionProgramInputState
                            .selectProductPageDropdownState?.selectedChoice,
                        items: promotionProgramInputState
                            .selectProductPageDropdownState?.choiceList
                            ?.map((item) {
                          return DropdownMenuItem(
                              child: Text(item.value), value: item);
                        }).toList(),
                        hint: Text(
                          promotionProgramInputState
                                      .itemGroupInputPageDropdownState
                                      ?.selectedChoice ==
                                  "Item"
                              ? "Select Product"
                              : "Select Product",
                          style: TextStyle(fontSize: 12),
                        ),
                        onChanged: (value) =>
                            inputPagePresenter.changeProduct(index, value)
                        // isExpanded: true,
                        ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              //warehouse qyt
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Warehouse",
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                  ),
                  Container(
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState
                              .wareHousePageDropdownState
                              ?.selectedChoiceWrapper
                              ?.value ??
                          "WHS - Tunas - Buffer",
                      hint: Text(
                        "WHS - Tunas - Buffer",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      items: promotionProgramInputState
                          .wareHousePageDropdownState?.choiceListWrapper?.value
                          ?.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item.value,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) =>
                          inputPagePresenter.changeWarehouse(index, value),
                    ),
                  ),
                ],
              ),

              //unit multiply
              // Stack(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 10),
              //       child: Text("Unit",style: TextStyle(fontSize: 10,color: Colors.black54)),
              //     ),
              //     Row(
              //       children: [
              //         //unit
              //         Expanded(
              //           child: SearchChoices.single(
              //             isExpanded: true,
              //             value: promotionProgramInputState.unitPageDropdownState.selectedChoice,
              //             hint: Text(
              //               "Unit",
              //               style: TextStyle(fontSize: 12),
              //             ),
              //             items: promotionProgramInputState.unitPageDropdownState.choiceList.map((item) {
              //               return DropdownMenuItem(
              //                 child: Text(item),
              //                 value: item,
              //               );
              //             }).toList(),
              //             onChanged: (value) => inputPagePresenter.changeUnit(index, value),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.qtyFrom,
                      decoration: InputDecoration(
                        labelText: 'Qty From',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontFamily: 'AvenirLight',
                        ),
                        contentPadding: EdgeInsets.only(bottom: 20),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        enabledBorder: new UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                      ),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: promotionProgramInputState.qtyTo,
                      decoration: InputDecoration(
                          labelText: 'Qty To',
                          labelStyle: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontFamily: 'AvenirLight'),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          enabledBorder: new UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0)),
                          contentPadding: EdgeInsets.only(bottom: 20)),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                          fontFamily: 'AvenirLight'),
                      //  controller: _passwordController,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 140,
                    height: 68,
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState
                          .unitPageDropdownState?.selectedChoice,
                      hint: Text(
                        "Unit",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState
                          .unitPageDropdownState?.choiceList
                          ?.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) =>
                          inputPagePresenter.changeUnit(index, value),
                    ),
                  ),
                ],
              ),

              //curency percent
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value
                          .selectedChoice?.value ==
                      "Bonus"
                  ? SizedBox()
                  : Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<IdAndValue<String>>(
                            value: promotionProgramInputState
                                .percentValueInputPageDropdownState
                                ?.selectedChoice,
                            hint: Text(
                              "Disc Type (percent/value)",
                              style: TextStyle(fontSize: 12),
                            ),
                            items: promotionProgramInputState
                                .percentValueInputPageDropdownState?.choiceList
                                ?.map((item) {
                              return DropdownMenuItem<IdAndValue<String>>(
                                child: Text(
                                  item.value,
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (value) {
                              inputPagePresenter.changePercentValue(
                                  index, value!);
                            },
                          ),
                        ),
                      ],
                    ),

              //percent
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value
                          .selectedChoice?.value ==
                      "Bonus"
                  ? SizedBox()
                  : promotionProgramInputState
                              .percentValueInputPageDropdownState
                              ?.selectedChoice ==
                          promotionProgramInputState
                              .percentValueInputPageDropdownState?.choiceList![1]
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //sales price
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.salesPrice,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Sales Price',
                                      prefixText: "Rp",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //price to customer
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    controller: promotionProgramInputState
                                        .priceToCustomer,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Price to Customer',
                                      prefixText: "Rp",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                //value 1
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    controller:
                                        promotionProgramInputState.value1,
                                    onChanged: (value) {
                                      inputPagePresenter
                                          .getPriceToCustomer(index);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Value(PRB)',
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //value 2
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.value2,
                                    onChanged: (value) {
                                      inputPagePresenter
                                          .getPriceToCustomer(index);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Value(Principal)',
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //sales price
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                    promotionProgramInputState.salesPrice,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    decoration: InputDecoration(
                                      labelText: 'Sales Price',
                                      prefixText: "Rp",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //price to customer
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MoneyInputFormatter(
                                          thousandSeparator: ".",
                                          decimalSeparator: ",")
                                    ],
                                    controller: promotionProgramInputState
                                        .priceToCustomer,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Price to Customer',
                                      prefixText: "Rp",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //percent1
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.percent1,
                                    onChanged: (value) {
                                      setState(() {
                                        inputPagePresenter
                                            .getPriceToCustomer(index);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      suffixText: "%",
                                      labelText: 'Disc-1 (%) Prb',
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //percent2
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.percent2,
                                    onChanged: (value) {
                                      setState(() {
                                        inputPagePresenter
                                            .getPriceToCustomer(index);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Disc-2 (%) COD',
                                      suffixText: "%",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //percent3
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.percent3,
                                    onChanged: (value) {
                                      setState(() {
                                        inputPagePresenter
                                            .getPriceToCustomer(index);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Disc-3 (%) Principal',
                                      suffixText: "%",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                //percent4
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        promotionProgramInputState.percent4,
                                    onChanged: (value) {
                                      setState(() {
                                        inputPagePresenter
                                            .getPriceToCustomer(index);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Disc-4 (%) Principal',
                                      suffixText: "%",
                                      labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontFamily: 'AvenirLight'),
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
                                    //  controller: _passwordController,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value
                          .selectedChoice?.value ==
                      "Discount"
                  ? SizedBox()
                  : SearchChoices.single(
                      isExpanded: true,
                      value:
                          promotionProgramInputState.supplyItem?.selectedChoice,
                      hint: Text(
                        "Bonus Item",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.supplyItem?.choiceList
                          ?.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item.value,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) =>
                          inputPagePresenter.changeSupplyItem(index, value)),

              //unit multiply
              inputPagePresenter.promotionTypeInputPageDropdownStateRx.value
                          .selectedChoice?.value ==
                      "Discount"
                  ? SizedBox()
                  : Row(
                      children: [
                        //unit
                        Container(
                          width: 50,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: promotionProgramInputState.qtyItem,
                            decoration: InputDecoration(
                              labelText: 'Qty Item',
                              labelStyle: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontFamily: 'AvenirLight'),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple),
                              ),
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.0)),
                            ),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 17,
                                fontFamily: 'AvenirLight'),
                            //  controller: _passwordController,
                          ),
                        ),
                        Spacer(),
                        //unit supply item
                        Container(
                          width: 120,
                          child: SearchChoices.single(
                            isExpanded: true,
                            value: promotionProgramInputState
                                .unitSupplyItem?.selectedChoice,
                            hint: Text(
                              "Unit Bonus Item",
                              style: TextStyle(fontSize: 12),
                            ),
                            items: promotionProgramInputState
                                .unitSupplyItem?.choiceList
                                ?.map((item) {
                              return DropdownMenuItem(
                                child: Text(item),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (value) => inputPagePresenter
                                .changeUnitSupplyItem(index, value),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  final noteFocusNode = FocusNode();

  final _scrollController = ScrollController();

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent - 500,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  bool isNoteTapped = false;
  double noteFieldHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    final inputPagePresenter = Get.put(InputPagePresenterNew());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
                        "Setup a trade agreement",
                        style: TextStyle(fontSize: 10, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => TextFormField(
                                  controller: inputPagePresenter
                                      .programNameTextEditingControllerRx.value,
                                  onChanged: (value) =>
                                      inputPagePresenter.checkAddItemStatus(),
                                  decoration: InputDecoration(
                                    labelText: 'Program Name',
                                    labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                        fontFamily: 'AvenirLight'),
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
                                  //  controller: _passwordController,
                                  // obscureText: true,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            // width: 150,
                            child: Obx(() => DropdownButtonFormField<IdAndValue<String>>(
                                  value: inputPagePresenter
                                      .promotionTypeInputPageDropdownStateRx
                                      .value
                                      .selectedChoice,
                                  hint: Text(
                                    "Type",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  items: inputPagePresenter
                                      .promotionTypeInputPageDropdownStateRx
                                      .value
                                      .choiceList
                                      ?.map((item) {
                                    return DropdownMenuItem<IdAndValue<String>>(
                                      child: Text(item.value),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (value) => inputPagePresenter
                                      .changePromotionType(value!),
                                )),
                          ),
                        ],
                      ),
                      Container(
                          width: Get.width,
                          child: Obx(
                            () => DropdownButtonFormField<String>(
                                isExpanded: true,
                                isDense: true,
                                value: inputPagePresenter
                                    .customerGroupInputPageDropdownState
                                    .value
                                    .selectedChoice,
                                hint: Text(
                                  "Customer/Cust Group",
                                  style: TextStyle(fontSize: 12),
                                ),
                                items: inputPagePresenter
                                    .customerGroupInputPageDropdownState
                                    .value
                                    .choiceList
                                    ?.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item,
                                      style: TextStyle(fontSize: 12),
                                      overflow: TextOverflow.fade,
                                    ),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    inputPagePresenter
                                        .changeCustomerGroupHeader(value!);
                                    Future.delayed(Duration(seconds: 1), () {
                                      setState(() {});
                                    });
                                  });
                                }),
                          )),
                      Container(
                        width: Get.width,
                        child: Obx(
                          () => SearchChoices.single(
                            items: inputPagePresenter
                                .custNameHeaderValueDropdownStateRx
                                .value
                                .choiceList
                                ?.map((item) {
                              return DropdownMenuItem(
                                child: Text(item.value,
                                    style: TextStyle(fontSize: 12)),
                                value: item,
                              );
                            }).toList(),
                            value: inputPagePresenter
                                .custNameHeaderValueDropdownStateRx
                                .value
                                .selectedChoice,
                            hint: Text(
                              inputPagePresenter
                                          .customerGroupInputPageDropdownState
                                          .value
                                          .selectedChoice ==
                                      "Customer"
                                  ? "Select Customer"
                                  : "Select Customer",
                              style: TextStyle(fontSize: 12),
                            ),
                            onChanged: (value) {
                              setState(() {
                                inputPagePresenter
                                    .changeCustomerNameOrDiscountGroupHeader(
                                        value);
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => SearchChoices.single(
                              // Assuming listDataPrincipal is a List of non-null items
                              value: inputPagePresenter.selectedDataPrincipal.isNotEmpty
                                  ? inputPagePresenter.listDataPrincipal[inputPagePresenter.selectedDataPrincipal[0]]
                                  : null,
                              hint: Text(
                                "Select Principal",
                                style: TextStyle(fontSize: 12),
                              ),
                              items: inputPagePresenter.listDataPrincipal.map((item) {
                                return DropdownMenuItem<String>(
                                  child: Text(item.toString()), // Assuming item.toString() is what you want to display
                                  value: item.toString(),
                                );
                              }).toList(),
                              onChanged: (String? value) { // onChanged should expect a nullable String
                                if (value != null) {
                                  print("value: $value");
                                  final index = inputPagePresenter.listDataPrincipal.indexOf(value);
                                  inputPagePresenter.selectedDataPrincipal.clear();
                                  if (index >= 0) {
                                    inputPagePresenter.selectedDataPrincipal.add(index);
                                  }
                                  final selectedItems = inputPagePresenter.selectedDataPrincipal.map((index) => inputPagePresenter.listDataPrincipal[index]).toList();
                                  print("Selected Principal: $selectedItems");
                                }
                              },
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // From Date
                          Container(
                            width: 150,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateTimeField(
                                    decoration: InputDecoration(
                                      labelText: "From Date",
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                    controller: inputPagePresenter
                                        .programFromDateTextEditingControllerRx
                                        .value,
                                    initialValue: DateTime.now(),
                                    style: TextStyle(fontSize: 12),
                                    format: DateFormat('dd-MM-yyyy'),
                                    onShowPicker: (context, currentValue) {
                                      return showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now()
                                            .subtract(Duration(days: 365)),
                                        initialDate: DateTime.now(),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 180)),
                                        builder: (BuildContext context, child) {
                                          return Theme(
                                            data: ThemeData.light(),
                                            child: child!,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),

                          // To Date
                          Container(
                            width: 150,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DateTimeField(
                                    decoration: InputDecoration(
                                      labelText: "To Date",
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                    controller: inputPagePresenter
                                        .programToDateTextEditingControllerRx
                                        .value,
                                    initialValue: DateTime.now(),
                                    style: TextStyle(fontSize: 12),
                                    format: DateFormat('dd-MM-yyyy'),
                                    onShowPicker: (context, currentValue) {
                                      DateTime fromDate =
                                          DateTime.fromMillisecondsSinceEpoch(
                                              inputPagePresenter
                                                      .programFromDateTextEditingControllerRx
                                                      .value
                                                      .text
                                                      .isNotEmpty
                                                  ? DateFormat('dd-MM-yyyy')
                                                      .parse(inputPagePresenter
                                                          .programFromDateTextEditingControllerRx
                                                          .value
                                                          .text)
                                                      .millisecondsSinceEpoch
                                                  : DateTime.now()
                                                      .millisecondsSinceEpoch);
                                      return showDatePicker(
                                        context: context,
                                        firstDate: fromDate,
                                        initialDate: DateTime.now(),
                                        lastDate:
                                            fromDate.add(Duration(days: 180)),
                                        builder: (BuildContext context, child) {
                                          return Theme(
                                            data: ThemeData.light(),
                                            child: child!,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() => TextFormField(
                                  maxLines: 1,
                                  controller: inputPagePresenter
                                      .programNoteTextEditingControllerRx.value,
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      // isNoteTapped = false;
                                      // noteFieldHeight = 10.0;
                                    });
                                  },
                              onChanged: (value) {
                                setState(() {
                                  isNoteTapped = true;
                                  noteFieldHeight = 200.0;
                                });
                              },
                              decoration: InputDecoration(
                                    labelText: 'Note',
                                    labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                        fontFamily: 'AvenirLight'),
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
                                )),
                          ),
                        ],
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
                  ? Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text("Add Lines"),
                        onPressed: isAddItem!
                            ? () {
                                inputPagePresenter.addItem();
                              }
                            : null),
                  )
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: promotionProgramInputStateList?.length,
                      itemBuilder: (context, index) => GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Column(
                              children: [
                                customCard(index, inputPagePresenter),
                                SizedBox(
                                  height: 10,
                                ),
                                index == promotionProgramInputStateList!.length - 1
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 500),
                                        child: Column(
                                          children: [
                                            Visibility(
                                              visible: !inputPagePresenter
                                                  .onTap.value,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                  child: Text("Submit"),
                                                  onPressed: () {
                                                    setState(() {
                                                      bool isInvalid = false;
                                                      for (int i = 0;
                                                          i <
                                                              promotionProgramInputStateList
                                                                  !.length;
                                                          i++) {
                                                        PromotionProgramInputState
                                                            element =
                                                            promotionProgramInputStateList[
                                                                i];
                                                        if (element.selectProductPageDropdownState
                                                                        ?.selectedChoice ==
                                                                    null ||
                                                                element
                                                                    .qtyFrom
                                                                    !.text
                                                                    .isEmpty ||
                                                                /*element.qtyTo.text.isEmpty ||*/
                                                                element.unitPageDropdownState
                                                                        ?.selectedChoice ==
                                                                    null
                                                            ) {
                                                          isInvalid = true;
                                                          break;
                                                        }
                                                      }

                                                      if (isInvalid) {
                                                        // Handle empty fields in promotionProgramInputList
                                                        inputPagePresenter.onTap
                                                            .value = false;
                                                        Get.snackbar("Error",
                                                            "Found empty fields in Lines",
                                                            backgroundColor:
                                                                Colors.red,
                                                            icon: Icon(
                                                                Icons.error));
                                                      } else {
                                                        inputPagePresenter
                                                            .onTap.value = true;
                                                        inputPagePresenter
                                                            .submitPromotionProgram();
                                                      }
                                                      // inputPagePresenter.submitPromotionProgram();
                                                    });
                                                  }),
                                            ),
                                            Visibility(
                                              visible: inputPagePresenter
                                                      .onTap.value ==
                                                  true,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ));
            }),
            SizedBox(height: noteFieldHeight,),
          ],
        ),
      )),
    );
  }
}
