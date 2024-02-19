import 'dart:convert';
import 'dart:developer';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/models/activity_edit.dart';
import 'package:flutter_scs/mobile_sms/lib/models/input-page-wrapper.dart';
import 'package:flutter_scs/mobile_sms/lib/models/promotion-program-input-state.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:money_input_formatter/money_input_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ApiConstant.dart';
import '../models/IdAndValue.dart';
import '../models/Promosi.dart';
import '../models/User.dart';
import 'dashboard/dashboard_pp.dart';
import 'input-page/input-page-presenter-new.dart';

class HistoryLinesAllEdit extends StatefulWidget {
  String? numberPP;
  int? idEmp;

  HistoryLinesAllEdit({Key? key, this.numberPP, this.idEmp}) : super(key: key);

  @override
  State<HistoryLinesAllEdit> createState() => _HistoryLinesAllEditState();
}

class _HistoryLinesAllEditState extends State<HistoryLinesAllEdit> {
  late User _user;
  late int code;
  var listLines;
  late List _listHistorySO;
  dynamic _listHistorySOEncode;
  var dataHeader;
  bool startApp = false;

  Future<Null> listHistorySO() async {
    await Future.delayed(Duration(seconds: 1));
    var value = await Promosi.getListLines(
        widget.numberPP!, code, _user.token!, _user.username);
    setState(() {
      listLines = value;
      _listHistorySO = value;
      _listHistorySOEncode = jsonEncode(_listHistorySO);
      dataHeader = jsonDecode(_listHistorySOEncode);
    });
    return null;
  }

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code")!;
    });
  }

  final inputPagePresenter = Get.put(InputPagePresenterNew());

  ActivityEdit activityEditModel = ActivityEdit();

  getDataActivity() async {
    final url = '${ApiConstant(code).urlApi}api/activity/${widget.numberPP}';
    print("activityes $url");
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic>) {
        setState(() {
          activityEditModel = ActivityEdit.fromJson(decodedData);
        });
      }
    }
  }

  List idLines = [];

  @override
  void initState() {
    super.initState();
    getSharedPreference();
    getDataActivity();
    Future.delayed(Duration(seconds: 2),(){
      log("ngawur : ${jsonEncode(activityEditModel)}");
      startApp = true;
      inputPagePresenter.programNoteTextEditingControllerRx.value.text = activityEditModel.note!;
      inputPagePresenter.programNameTextEditingControllerRx.value.text = activityEditModel.number!;
      IdAndValue<String> type = IdAndValue<String>(id: activityEditModel.type!, value: activityEditModel.type == "1" ? "Discount" : activityEditModel.type == "2" ? "Bonus" : "Discount & Bonus",);
      inputPagePresenter.promotionTypeInputPageDropdownStateRx.value.selectedChoice = type;
      inputPagePresenter.customerGroupInputPageDropdownState.value.selectedChoice = "Customer";
      inputPagePresenter.changeCustomerGroupHeader(inputPagePresenter.customerGroupInputPageDropdownState.value.selectedChoice!);
      IdAndValue<String> custHeader = IdAndValue<String>(id: activityEditModel.customerId!, value: activityEditModel.customerId!);
      inputPagePresenter.custNameHeaderValueDropdownStateRx.value.selectedChoice = custHeader;
      print("se fromDate :${DateFormat('dd-MM-yyyy').format(DateTime.parse(activityEditModel.fromDate))}");
      print("se toDate :${activityEditModel.toDate}");
      inputPagePresenter.programFromDateTextEditingControllerRx.value.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(activityEditModel.fromDate));
      inputPagePresenter.programToDateTextEditingControllerRx.value.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(activityEditModel.toDate));
      if (activityEditModel.vendor != null) {
        final index = inputPagePresenter.listDataPrincipal.indexOf(activityEditModel.vendor);
        if (index >= 0) {
          inputPagePresenter.selectedDataPrincipal.add(index);
        }
      }

      // inputPagePresenter.listDataPrincipal[inputPagePresenter.selectedDataPrincipal[0]] = inputPagePresenter.listDataPrincipal[activityEditModel.vendor];
      for (int i = 0; i < activityEditModel.activityLinesEdit!.length; i++) {
        inputPagePresenter.addItem();
        Future.delayed(Duration(seconds: 2),(){
          setState(() {
          });
        });
        IdAndValue<String> percent = IdAndValue<String>(id: "1", value: "Percent");
        PromotionProgramInputState promotionProgramInputState = inputPagePresenter.promotionProgramInputStateRx.value.promotionProgramInputState![i];
        IdAndValue<String> itemProduct = IdAndValue<String>(id: activityEditModel.activityLinesEdit![i].item!, value: activityEditModel.activityLinesEdit![i].item!);
        IdAndValue<String> suppItemProduct = IdAndValue<String>(id: activityEditModel.activityLinesEdit![i].suppItemId!, value: activityEditModel.activityLinesEdit![i].suppItemId!);
        promotionProgramInputState.itemGroupInputPageDropdownState!.selectedChoice = 'Item';
        inputPagePresenter.changeItemGroup(i, promotionProgramInputState.itemGroupInputPageDropdownState!.selectedChoice!);
        promotionProgramInputState.selectProductPageDropdownState!.selectedChoice = itemProduct;
        promotionProgramInputState.supplyItem!.selectedChoice = suppItemProduct;
        inputPagePresenter.changeProduct(i, promotionProgramInputState.selectProductPageDropdownState!.selectedChoice!);
        inputPagePresenter.changeSupplyItem(i, promotionProgramInputState.supplyItem!.selectedChoice!);
        promotionProgramInputState.qtyFrom!.text = activityEditModel.activityLinesEdit![i].qtyFrom.toString().split(".")[0];
        promotionProgramInputState.qtyTo!.text = activityEditModel.activityLinesEdit![i].qtyTo.toString().split(".")[0];
        promotionProgramInputState.unitPageDropdownState!.selectedChoice = activityEditModel.activityLinesEdit![i].unitID!;
        promotionProgramInputState.unitSupplyItem?.selectedChoice = activityEditModel.activityLinesEdit![i].supplementaryUnitId!;
        promotionProgramInputState.salesPrice!.text = activityEditModel.activityLinesEdit![i].salesPrice.toString().replaceAll("Rp", "");
        promotionProgramInputState.percentValueInputPageDropdownState?.selectedChoice = percent;
        promotionProgramInputState.qtyItem!.text = activityEditModel.activityLinesEdit![i].suppItemQty.toString().split(".")[0];
        promotionProgramInputState.percent1!.text = activityEditModel.activityLinesEdit![i].percent1.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
        promotionProgramInputState.percent2!.text = activityEditModel.activityLinesEdit![i].percent2.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
        promotionProgramInputState.percent3!.text = activityEditModel.activityLinesEdit![i].percent3.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
        promotionProgramInputState.percent4!.text = activityEditModel.activityLinesEdit![i].percent4.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
        promotionProgramInputState.value1!.text = activityEditModel.activityLinesEdit![i].value1.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
        promotionProgramInputState.value2!.text = activityEditModel.activityLinesEdit![i].value2.toString().split(".")[0];
        inputPagePresenter.getPriceToCustomer(i);
      }
      idLines = activityEditModel.activityLinesEdit!.map((e) => e.id).toList();
    });
  }

  Widget customCard(int index, InputPagePresenterNew inputPagePresenter) {
    PromotionProgramInputState promotionProgramInputState = inputPagePresenter
        .promotionProgramInputStateRx.value.promotionProgramInputState![index];
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
                        setState(() {
                          idLines.add(0);
                        });
                        inputPagePresenter.addItem();
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        List idLines = activityEditModel.activityLinesEdit!.map((e) => e.id).toList();
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
                              ? "${promotionProgramInputState
                              .selectProductPageDropdownState?.selectedChoice}"
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
                    width: 100,
                    height: 68,
                    child: SearchChoices.single(
                      isExpanded: true,
                      value: promotionProgramInputState
                          .unitPageDropdownState?.selectedChoice,
                      hint: Text(
                        "${promotionProgramInputState.unitPageDropdownState?.selectedChoice??"Unit"}",
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
                              .percentValueInputPageDropdownState!.choiceList![1]
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
                          .selectedChoice!.value ==
                      "Discount"
                  ? SizedBox()
                  : SearchChoices.single(
                      isExpanded: true,
                      value:
                          promotionProgramInputState.supplyItem?.selectedChoice,
                      hint: Text(
                        "${promotionProgramInputState
                            .supplyItem?.selectedChoice??"Bonus Item"}",
                        style: TextStyle(fontSize: 12),
                      ),
                      items: promotionProgramInputState.supplyItem?.choiceList
                          !.map((item) {
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
                          .selectedChoice!.value ==
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
                                !.map((item) {
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

  Future<bool> onBackPressLines() {
    Get.off(DashboardPP(
      initialIndexs: 1,
    ));
    Get.delete<InputPagePresenterNew>();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    log("totlah ${_listHistorySOEncode}");
    return WillPopScope(
      onWillPop: onBackPressLines,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("Edit"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Get.off(DashboardPP(
                initialIndexs: 1,
              ));
              Get.delete<InputPagePresenterNew>();
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: startApp == false
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
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
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black54),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Obx(() => TextFormField(
                                          controller: inputPagePresenter
                                              .programNameTextEditingControllerRx
                                              .value,
                                          onChanged: (value) =>
                                              inputPagePresenter
                                                  .checkAddItemStatus(),
                                          decoration: InputDecoration(
                                            labelText: 'Program Name',
                                            labelStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 12,
                                                fontFamily: 'AvenirLight'),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.purple),
                                            ),
                                            enabledBorder:
                                                new UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0)),
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
                                              !.map((item) {
                                            return DropdownMenuItem<IdAndValue<String>>(
                                              child: Text(item.value),
                                              value: item,
                                            );
                                          }).toList(),
                                          onChanged: (value) =>
                                              inputPagePresenter.changePromotionType(value),
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
                                            !.map((item) {
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
                                                .changeCustomerGroupHeader(
                                                    value!);
                                            Future.delayed(Duration(seconds: 1),
                                                () {
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
                                        !.map((item) {
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
                                          ? "${inputPagePresenter.custNameHeaderValueDropdownStateRx.value.selectedChoice}"
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
                                      // value: inputPagePresenter.valPrincipal.value,
                                      value: inputPagePresenter.selectedDataPrincipal.isNotEmpty
                                          ? inputPagePresenter.listDataPrincipal[inputPagePresenter.selectedDataPrincipal[0]]
                                          : null,
                                      hint: Text(
                                        "Select Principal",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      items: inputPagePresenter.listDataPrincipal
                                          .where((item) => item != null) // Filter out null items
                                          .map((item) {
                                        return DropdownMenuItem<String>(
                                          child: Text(item),
                                          value: item,
                                        );
                                      }).toList(),
                                      onChanged: (String value) {
                                        print("value: $value");
                                        final index = inputPagePresenter.listDataPrincipal.indexOf(value);
                                        inputPagePresenter.selectedDataPrincipal.clear();
                                        if (index >= 0) {
                                          inputPagePresenter.selectedDataPrincipal.add(index);
                                        }
                                        final selectedItems = inputPagePresenter.selectedDataPrincipal.map((index) => inputPagePresenter.listDataPrincipal[index]).toList();
                                        print("Selected Principal: $selectedItems");
                                        print("Selected Principal2: ${inputPagePresenter.selectedDataPrincipal.value}");
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DateTimeField(
                                            decoration: InputDecoration(
                                              labelText: "From Date",
                                              suffixIcon:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                            controller: inputPagePresenter
                                                .programFromDateTextEditingControllerRx
                                                .value,
                                            initialValue: DateTime.now(),
                                            style: TextStyle(fontSize: 12),
                                            format: DateFormat('dd-MM-yyyy'),
                                            onShowPicker:
                                                (context, currentValue) {
                                              return showDatePicker(
                                                context: context,
                                                firstDate: DateTime.now()
                                                    .subtract(
                                                        Duration(days: 365)),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DateTimeField(
                                            decoration: InputDecoration(
                                              labelText: "To Date",
                                              suffixIcon:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                            controller: inputPagePresenter
                                                .programToDateTextEditingControllerRx
                                                .value,
                                            initialValue: DateTime.now(),
                                            style: TextStyle(fontSize: 12),
                                            format: DateFormat('dd-MM-yyyy'),
                                            onShowPicker:
                                                (context, currentValue) {
                                              DateTime fromDate = DateTime
                                                  .fromMillisecondsSinceEpoch(inputPagePresenter
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
                                                lastDate: fromDate
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
                      List<PromotionProgramInputState>?
                          promotionProgramInputStateList =
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
                                  onPressed: isAddItem! ? () {
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
                                                padding: EdgeInsets.only(
                                                    bottom: 500),
                                                child: inputPagePresenter.onTap.value==false?ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.green,
                                                    ),
                                                    child: Text("Submit"),
                                                    onPressed: () {
                                                      String? ppnum = activityEditModel.number;
                                                      setState(() {
                                                        inputPagePresenter.onTap.value = true;
                                                      });
                                                      inputPagePresenter.submitEditPromotionProgram(int.parse(widget.numberPP!), idLines, ppnum!);
                                                    }):Center(child: CircularProgressIndicator()),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ));
                    })
                  ],
                ),
              )),
      ),
    );
  }
}
