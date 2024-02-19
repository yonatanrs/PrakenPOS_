import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scs/models/promosi.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ApiConstant.dart';
import '../../models/ApprovalPromo.dart';
import '../../models/PromoInput.dart';
import '../../models/PromoInputState.dart';

class SetPromoPresenter extends GetxController {
  var promoInputStateRx = PromoInputState(
    promoInput: [],
    dataCustomer: [],
    dataCustomerState: 0,
    customerId: "",
    dataItem: [],
    dataItemState: 0,
    nameTextEditingController: TextEditingController()
  ).obs;

  @override
  void onInit() {
    super.onInit();
    getCustomer();
  }

  void addPromoItem() {
    List<PromoInput> promoInputList = promoInputStateRx.value.promoInput!;
    promoInputList.add(
      PromoInput(
        qtyTextInputController: TextEditingController(),
        discountTextInputController: TextEditingController(),
        priceTextInputController: TextEditingController(),
        unit: "",
        dataUnitState: 0,
        dataUnit: []
      )
    );
    promoInputStateRx.value = promoInputStateRx.value.copy(promoInput: promoInputList);
    update();
  }

  void removeItem(int index){
    List<PromoInput> promoInputList = promoInputStateRx.value.promoInput!;
    promoInputList.removeAt(index);
    promoInputStateRx.value = promoInputStateRx.value.copy(promoInput: promoInputList);
    update();
  }

  void getItemProduct(String customerId) async {
    List<PromoInput> promoInput = promoInputStateRx.value.promoInput!;
    for (int i = 0; i < promoInput.length; i++) {
      promoInput[i].itemId = "";
      promoInput[i].unit = "";
      promoInput[i].dataUnitState = 0;
      promoInput[i].dataUnit = [];
    }
    promoInputStateRx.value = promoInputStateRx.value.copy(dataItemState: 1, customerId: customerId, promoInput: promoInput);
    update();
    print("cek custId: ${customerId.split(' ')[0]}");
    var urlGetItemProduct = "${ApiConstant().urlApi}api/product?idSales=rp004&idCustomer=${customerId.split(' ')[0]}&condition=1";
    print("ini urlGetItemProduct : $urlGetItemProduct");
    final response = await get(Uri.parse(urlGetItemProduct));
    var listData = jsonDecode(response.body);
    promoInputStateRx.value = promoInputStateRx.value.copy(dataItem: listData, dataItemState: 2);
    update();
  }

  void getUnit(int index, String itemId) async {
    List<PromoInput> promoInputList = promoInputStateRx.value.promoInput!;
    promoInputList[index].itemId = itemId;
    promoInputList[index].dataUnitState = 1;
    promoInputStateRx.value = promoInputStateRx.value.copy(promoInput: promoInputList);
    update();

    var urlGetUnit = "${ApiConstant().urlApi}api/Unit?item=${itemId.split(' ')[0]}";
    print("urlGetUnit : $urlGetUnit");
    final response = await get(Uri.parse(urlGetUnit));
    var listData = jsonDecode(response.body);

    promoInputList[index].dataUnit = listData;
    promoInputList[index].dataUnitState = 2;
    promoInputStateRx.value = promoInputStateRx.value.copy(promoInput: promoInputList);
    update();
  }

  void setUnit(int index, String unit) {
    List<PromoInput> promoInputList = promoInputStateRx.value.promoInput!;
    promoInputList[index].unit = unit;
    promoInputStateRx.value = promoInputStateRx.value.copy(promoInput: promoInputList);
    update();
  }

  void getCustomer() async {
    // Loading state
    promoInputStateRx.value = promoInputStateRx.value.copy(dataCustomerState: 1);
    update();

    // Loading get customer
    var urlGetCustomer = "${ApiConstant().urlApi}api/customer?idSales=rp004&condition=3";
    final response = await get(Uri.parse(urlGetCustomer));
    var listData = jsonDecode(response.body);
    promoInputStateRx.value = promoInputStateRx.value.copy(dataCustomer: listData, dataCustomerState: 2);
    update();
  }

  /*bool customerContains(Rx<String> choice) {
    for (int i = 0; i < dataCustomer.length; i++) {
      if (choice == dataCustomer[i]["nameCust"]) return true;
    }
    update();
    return false;
  }*/

  /*bool itemProductContains(Rx<String> itemProduct) {
      for (int i = 0; i < dataItemProduct.length; i++) {
        if (itemProduct == dataItemProduct[i]["nameProduct"]) return true;
      }
      update();
      return false;
    }*/

  /*bool unitContains(Rx<String> unit) {
    for (int i = 0; i < dataUnit.length; i++) {
      if (unit == dataUnit[i]) return true;
    }
    update();
    return false;
  }*/

  Future<Promosi> createPromosi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? createdBy = prefs.getString("getIdEmp");
    List<PromoInput> promoInput = promoInputStateRx.value.promoInput!;
    List<Map<String, String>> promoInputMapList = [];
    for (int i = 0; i < promoInput.length; i++) {
      print("ini price ${promoInput[i].priceTextInputController!.text}");
      promoInputMapList.add({
        "ItemId": "${promoInput[i].itemId!.split(' ')[0]}",
        "Qty": "${promoInput[i].qtyTextInputController!.text}",
        "Unit": "${promoInput[i].unit}",
        "Price": "${promoInput[i].priceTextInputController!.text}",
        "Disc": "${promoInput[i].discountTextInputController!.text}"
      });
    }
    final response = await post(
      Uri.parse('${ApiConstant().urlApi}Api/Promo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "Name": promoInputStateRx.value.nameTextEditingController!.value.text,
        "CreatedBy": "$createdBy",
        "CustId": "${promoInputStateRx.value.customerId!.split(' ')[0]}",
        "Lines": promoInputMapList
      }),
    );
    print(response.body.toString());
    print(response.statusCode);
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Get.offAll(MainMenuView());
      return Promosi.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create promosi.');
    }
  }

  final data = <ApprovalPromosi>[].obs;

  late String IdEmp;

  Future<dynamic> getDataApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IdEmp = prefs.getString("getIdEmp").toString();
    var urlApproval = '${ApiConstant().urlApi}Api/Promo?createdBy=$IdEmp';
    print("ini urlApproval : $urlApproval");
    var response = await get(Uri.parse(urlApproval));
    data.value = (jsonDecode(response.body) as List)
        .map<ApprovalPromosi>((_data) => ApprovalPromosi.fromJson(_data))
        .toList();
    print(data);
    update();
  }

  Rx<Promosi> dataApprovalDetails = new Promosi().obs;
  final dataLines = <Lines>[].obs;

  getApprovalDetail(int idProduct) async {
    var urlApprovalDetails = "${ApiConstant().urlApi}api/Promo/$idProduct";
    print("ini id product $urlApprovalDetails");
    var response = await get(Uri.parse(urlApprovalDetails));
    final listData = jsonDecode(response.body);
    print("ini listData $listData");
    dataApprovalDetails.value = Promosi.fromJson(listData);
    update();
    dataLines.value = Promosi.fromJson(listData).lines!;
    print(dataApprovalDetails.obs);
    print(dataLines);
    update();
  }
}
