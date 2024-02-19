import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/ext/rx_ext.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_ordertaking.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/IdAndValue.dart';
import '../../models/Wrapper.dart';
import '../../models/input-page-wrapper.dart';
import '../../models/promotion-program-input-state.dart';
import '../HistoryNomorPP.dart';
import '../dashboard/DashboardPage.dart';
import '../input-page/input-page-dropdown-state.dart';
// import 'input-page-dropdown-state.dart';

class TransactionPresenter extends GetxController {
  Rx<InputPageWrapper> promotionProgramInputStateRx = InputPageWrapper(
      promotionProgramInputState: [],
      isAddItem: false
  ).obs;
  Rx<TextEditingController> transactionNumberTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> programTestTextEditingControllerRx = TextEditingController().obs;
  Rx<TextEditingController> transactionDateTextEditingControllerRx = TextEditingController().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> promotionTypeInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> locationInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<IdAndValue<String>>> customerNameInputPageDropdownStateRx = InputPageDropdownState<IdAndValue<String>>().obs;
  Rx<InputPageDropdownState<String>> statusTestingInputPageDropdownStateRx = InputPageDropdownState<String>().obs;
  InputPageDropdownState<String> _customerGroupInputPageDropdownState = InputPageDropdownState<String>(
      choiceList: <String>[
        "Customer",
        "Disc Group"
      ],
      loadingState: 2
  );
  InputPageDropdownState<String> _itemGroupInputPageDropdownState = InputPageDropdownState<String>(
      choiceList: <String>[
        "Item",
        "Disc Group"
      ],
      loadingState: 0
  );
  WrappedInputPageDropdownState<IdAndValue<String>> _productInputPageDropdownState = WrappedInputPageDropdownState<IdAndValue<String>>(
      choiceListWrapper: Wrapper(value: <IdAndValue<String>>[]),
      loadingStateWrapper: Wrapper(value: 0),
      selectedChoiceWrapper: Wrapper(value: null)
  );
  InputPageDropdownState<IdAndValue<String>> _unitInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
      choiceList: <IdAndValue<String>>[],
      loadingState: 0
  );
  InputPageDropdownState<IdAndValue<String>> _multiplyInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
      choiceList: <IdAndValue<String>>[
        IdAndValue<String>(id: "0", value: "No"),
        IdAndValue<String>(id: "1", value: "Yes")
      ],
      loadingState: 0
  );
  InputPageDropdownState<String> _currencyInputPageDropdownState = InputPageDropdownState<String>(
      choiceList: <String>[
        "IDR",
        "Dollar"
      ],
      loadingState: 0
  );
  InputPageDropdownState<IdAndValue<String>> _percentValueInputPageDropdownState = InputPageDropdownState<IdAndValue<String>>(
      choiceList: <IdAndValue<String>>[
        IdAndValue<String>(id: "1", value: "Percent"),
        IdAndValue<String>(id: "2", value: "Value"),
        // "Percent",
        // "Value"
      ],
      loadingState: 0
  );

  @override
  void onInit() {
    super.onInit();
    promotionTypeInputPageDropdownStateRx.valueFromLast((value) => value.copy(
        choiceList: <IdAndValue<String>>[
          IdAndValue<String>(id: "1", value: "Diskon"),
          IdAndValue<String>(id: "2", value: "Bonus"),
          IdAndValue<String>(id: "3", value: "Diskon & Bonus"),
          IdAndValue<String>(id: "4", value: "Sample"),
          IdAndValue<String>(id: "5", value: "Listing"),
          IdAndValue<String>(id: "6", value: "Rebate"),
          IdAndValue<String>(id: "7", value: "Rafraksi"),
          IdAndValue<String>(id: "8", value: "Gimmick"),
          IdAndValue<String>(id: "9", value: "Trading Term"),
        ],
        loadingState: 2
    ));
    statusTestingInputPageDropdownStateRx.valueFromLast((value) => value.copy(
        choiceList: <String>[
          "Live",
          "Testing",
        ],
        loadingState: 2
    ));
    _loadLocation();
    _loadCustomerNameByUsername();
    // _loadWarehouse();
    _loadProduct();
    // _loadProductByOrderSample();
  }

  void _loadLocation() async {
    locationInputPageDropdownStateRx.value.loadingState = 1;
    _updateState();
    try {
      var urlGetLocation = "http://119.18.157.236:8869/api/SalesOffices";
      final response = await get(Uri.parse(urlGetLocation));
      var listData = jsonDecode(response.body);
      print("ini url getLocation : $urlGetLocation");
      locationInputPageDropdownStateRx.value.loadingState = 2;
      locationInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["CodeSO"], value: element["NameSO"])).toList();
    } catch (e) {
      locationInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void _loadCustomerNameByUsername() async {
    customerNameInputPageDropdownStateRx.value.loadingState = 1;
    _updateState();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? username = preferences.getString("username");
    try {
      var urlGetCustomer = "http://api-scs.prb.co.id/api/AllCustomer?username=$username";
      print("url get customer :${urlGetCustomer}");
      final response = await get(Uri.parse(urlGetCustomer));
      var listData = jsonDecode(response.body);
      print("ini url getCustomer : $urlGetCustomer");
      print("status getCustomer : ${response.statusCode}");
      customerNameInputPageDropdownStateRx.value.loadingState = 2;
      customerNameInputPageDropdownStateRx.value.choiceList = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["codeCust"], value: element["nameCust"])).toList();
      _updateState();
    } catch (e) {
      customerNameInputPageDropdownStateRx.value.loadingState = -1;
      _updateState();
    }
  }

  void checkAddItemStatus() {
    promotionProgramInputStateRx.value.isAddItem = customerNameInputPageDropdownStateRx.value.selectedChoice != null;
    // promotionProgramInputStateRx.value.isAddItem = transactionNumberTextEditingControllerRx.value.text.isBlank == false;
        // && transactionDateTextEditingControllerRx.value.text.isBlank == false
        // && promotionTypeInputPageDropdownStateRx.value.selectedChoice != null
        // && customerNameInputPageDropdownStateRx.value.selectedChoice != null;
        // && locationInputPageDropdownStateRx.value.selectedChoice != null
        // && statusTestingInputPageDropdownStateRx.value.selectedChoice != null;
    _updateState();
  }

  void _loadProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? ID = preferences.getString("username");
    _productInputPageDropdownState.loadingStateWrapper?.value = 1;
    _updateState();
    var urlGetProduct = "http://api-scs.prb.co.id/api/AllProduct?ID=$ID&idSales=Sample";
    final response = await get(Uri.parse(urlGetProduct));
    var listData = jsonDecode(response.body);
    _productInputPageDropdownState.loadingStateWrapper?.value = 2;
    _productInputPageDropdownState.choiceListWrapper?.value = listData.map<IdAndValue<String>>(
            (element) => IdAndValue<String>(id: element["itemId"].toString(), value: element["itemName"])
    ).toList();
    _updateState();
  }

  // void _loadProductByOrderSample() async {
  //   _productInputPageDropdownState.loadingStateWrapper?.value = 1;
  //   _updateState();
  //   var urlGetProduct = "http://api-scs.prb.co.id/api/AllProduct?ID=rp004&idSales=Sample";
  //   final response = await get(Uri.parse(urlGetProduct));
  //   var listData = jsonDecode(response.body);
  //   _productInputPageDropdownState.loadingStateWrapper?.value = 2;
  //   _productInputPageDropdownState.choiceListWrapper?.value = listData.map<IdAndValue<String>>(
  //           (element) => IdAndValue<String>(id: element["itemId"].toString(), value: element["itemName"])
  //   ).toList();
  //   _updateState();
  // }

  void _loadUnit(int index) async {
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState![index];
    // InputPageDropdownState<IdAndValue<String>> selectProductPageDropdownState = promotionProgramInputState.selectProductPageDropdownState;
    final selectProductPageDropdownState = promotionProgramInputState.productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.id;
    InputPageDropdownState<String>? unitPageDropdownState = promotionProgramInputState.unitPageDropdownState;
    unitPageDropdownState?.loadingState = 1;
    _updateState();
    // var urlGetUnit = "http://119.18.157.236:8878/api/Unit?item=$selectProductPageDropdownState http://api-scs.prb.co.id/api/Unit?item=$selectProductPageDropdownState&type=sample";
    var urlGetUnit = "http://api-scs.prb.co.id/api/Unit?item=$selectProductPageDropdownState&type=sample";
    final response = await get(Uri.parse(urlGetUnit));
    print("param product : ${selectProductPageDropdownState}");
    print("url getUnit : ${urlGetUnit}");
    print("response getUnit : ${response.body}");
    var listData = jsonDecode(response.body);
    unitPageDropdownState?.loadingState = 2;
    unitPageDropdownState?.choiceList = listData.map<String>((element) {
      return element.toString();
    }).toList();
    promotionProgramInputState.unitPageDropdownState?.selectedChoice = listData[0];
    getQtyUnitPrice(index,promotionProgramInputStateRx.value.promotionProgramInputState![index]!.productTransactionPageDropdownState!.selectedChoiceWrapper!.value!.id!, 1, promotionProgramInputState.unitPageDropdownState!.selectedChoice!);
    _updateState();
  }

  void changePromotionType(IdAndValue<String> selectedChoice) {
    promotionTypeInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void changeVendor(IdAndValue<String> selectedChoice) {
    customerNameInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void changeSelectCustomer(IdAndValue<String> selectedChoice) {
    customerNameInputPageDropdownStateRx.value.selectedChoice = selectedChoice;

    checkAddItemStatus();
  }

  void changeLocation(IdAndValue<String> selectedChoice) {
    locationInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void changeStatusTesting(String selectedChoice) {
    statusTestingInputPageDropdownStateRx.value.selectedChoice = selectedChoice;
    checkAddItemStatus();
  }

  void addItem() {
    List<PromotionProgramInputState>? promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState;
    promotionProgramInputState?.add(
        PromotionProgramInputState(
          productTransactionPageDropdownState: _productInputPageDropdownState.copy(
              choiceListWrapper: _productInputPageDropdownState.choiceListWrapper,
              loadingStateWrapper: _productInputPageDropdownState.loadingStateWrapper,
              selectedChoiceWrapper: Wrapper<IdAndValue<String>>(value: null),
          ),
          priceTransaction: TextEditingController(),
          discTransaction: TextEditingController(),
          qtyTransaction: TextEditingController(),
          totalTransaction: TextEditingController(),
          unitPageDropdownState: InputPageDropdownState<String>(
              choiceList: [],
              loadingState: 0
          ),
        ),

    );
    _updateState();
  }

  void removeItem(int index) {
    promotionProgramInputStateRx.value.promotionProgramInputState?.removeAt(index);
    originalPrice.removeAt(index);
    _updateState();
  }

  void changeProduct(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState?[index]
        .productTransactionPageDropdownState?.selectedChoiceWrapper?.value = selectedChoice;
    print(promotionProgramInputStateRx.value.promotionProgramInputState?[index]
        .productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.id);
    _updateState();
    _loadUnit(index);
  }

  List<String> originalPrice = [];
  getQtyUnitPrice(int index,String idProduct,int qty, String unit)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PromotionProgramInputState promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState![index];
    var url = "http://119.18.157.236:8877/api/Product/cekStok?item=$idProduct&qty=$qty&unit=$unit&wh=DC01-X";
    var urlPrice = "http://119.18.157.236:8878/api/AllPrice?cust=${customerNameInputPageDropdownStateRx.value.choiceList![index].id}&item=$idProduct&unit=$unit&qty=$qty";
    var urlDiscount = "http://119.18.157.236:8878/api/AllDiscount?cust=${customerNameInputPageDropdownStateRx.value.choiceList![index].id}&item=$idProduct&unit=$unit&qty=$qty";
    print("url :$url");
    print("url price :$urlPrice");
    print("url discount :$urlDiscount");
    final response = await get(Uri.parse(url));
    final responsePrice = await get(Uri.parse(urlPrice));
    final responseDiscount = await get(Uri.parse(urlDiscount));
    final listData = jsonDecode(response.body);
    double listDataPrice = 0.0;
    int listDataDiscount = 0;
    if(responsePrice.statusCode==200){
       listDataPrice = jsonDecode(responsePrice.body);
    }else{
      listDataPrice = 0.0;
    }
    if(responseDiscount.statusCode==200){
      double discount = jsonDecode(responseDiscount.body);
      listDataDiscount = discount.toInt();
    }else{
      listDataDiscount = 0;
    }
    print("listData getQtyUnitPrice :$listData");
    print("listData getQtyUnitPrice price :$listDataPrice");
    print("listData getQtyUnitPrice disc :$listDataDiscount");
    promotionProgramInputState.qtyTransaction?.text = 1.toString()/*listData['qty'].toString().split(".").first*/;
    promotionProgramInputState.priceTransaction?.text = "${MoneyFormatter(amount: listDataPrice??0).output.withoutFractionDigits}";
    String originalPrices = MoneyFormatter(amount: listDataPrice??0.0).output.withoutFractionDigits;
    promotionProgramInputState.totalTransaction?.text = listDataPrice.toString().split(".").first;
    print("object :${promotionProgramInputState.totalTransaction?.text}");
    originalPrice.add(originalPrices);
    promotionProgramInputState.discTransaction?.text = listDataDiscount.toString();
    // if(listData['message']!='Available'){
    //   Get.snackbar("Out of Stock", "Please choose another product",backgroundColor: Colors.red,icon: Icon(Icons.error));
    // };
  }


  void changeWarehouse(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState?[index]
        .wareHousePageDropdownState?.selectedChoiceWrapper?.value = selectedChoice;
    _updateState();
  }

  void changeUnit(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState?[index]
        .unitPageDropdownState?.selectedChoice = selectedChoice;

    _updateState();
  }


  void changeQty(int index, String qty) {
    double price = promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text.isEmpty?0:double.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text.replaceAll(RegExp(r"[.,]"), ""));
    double disc = double.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].discTransaction!.text);
    if(qty.isEmpty){
      promotionProgramInputStateRx.value.promotionProgramInputState?[index].totalTransaction?.text = "0";
    }else{
      double discPrice = (int.parse(qty) * price) * (disc/100);
      double calculateTotalPrice = (int.parse(qty) * price)-discPrice;
      promotionProgramInputStateRx.value.promotionProgramInputState?[index].totalTransaction?.text = calculateTotalPrice.toString().split(".").first;
    }
    print("object :${promotionProgramInputStateRx.value.promotionProgramInputState![index]
        .totalTransaction?.text}");
    _updateState();
  }

  void changePrice(int index, String price) {
    int qty =  promotionProgramInputStateRx.value.promotionProgramInputState![index].qtyTransaction!.text.isEmpty?0:int.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].qtyTransaction!.text);
    double disc = double.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].discTransaction!.text);
    print(price.replaceAll(".", ""));
    print(qty);
    print("Price :$price");
    print("Price obj :${promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text}");
    print("Price priceToDouble :${double.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text.replaceAll(RegExp(r"[.,]"), ""))}");
    double discPrice = (qty * double.parse(price.replaceAll(RegExp(r"[.,]"), ""))) * (disc/100);
    print("discPrice : ${discPrice}");
    double calculateTotalPrice = (qty * double.parse(price.replaceAll(RegExp(r"[.,]"), "")))-discPrice;
    print("calculateTotalPrice :$calculateTotalPrice");
    if(price.isEmpty){
      promotionProgramInputStateRx.value.promotionProgramInputState![index]
          .totalTransaction!.text = 0.toString();
    }else{
      promotionProgramInputStateRx.value.promotionProgramInputState![index]
          .totalTransaction!.text = MoneyFormatter(amount: calculateTotalPrice).output.withoutFractionDigits;
    }
    // print("object :${promotionProgramInputStateRx.value.promotionProgramInputState[index]
    //     .totalTransaction.text}");
    _updateState();
  }

  void changeDisc(int index, String disc) {
    int qty =  promotionProgramInputStateRx.value.promotionProgramInputState![index].qtyTransaction!.text.isEmpty?0:int.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].qtyTransaction!.text);
    double price = promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text.isEmpty?0:double.parse(promotionProgramInputStateRx.value.promotionProgramInputState![index].priceTransaction!.text.replaceAll(RegExp(r"[.,]"), ""));
    dynamic calculateTotalPrice;
    if(disc.isEmpty){
      calculateTotalPrice = (qty * price);
      promotionProgramInputStateRx.value.promotionProgramInputState![index]
          .totalTransaction!.text = calculateTotalPrice.toString();
    }else{
      double discPrice = (qty * price) * (double.parse(disc)/100);
      calculateTotalPrice = (qty * price) - discPrice;
      promotionProgramInputStateRx.value.promotionProgramInputState![index]
          .totalTransaction!.text = calculateTotalPrice.toString().split(".").first;
      print("hasil Discount : ${promotionProgramInputStateRx.value.promotionProgramInputState![index]
          .totalTransaction!.text}");
    }
    _updateState();
  }

  void changeMultiply(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState![index]
        .multiplyInputPageDropdownState!.selectedChoice = selectedChoice;
    _updateState();
  }

  void changeCurrency(int index, String selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState![index]
        .currencyInputPageDropdownState!.selectedChoice = selectedChoice;
    _updateState();
  }

  void changePercentValue(int index, IdAndValue<String> selectedChoice) {
    promotionProgramInputStateRx.value.promotionProgramInputState![index]
        .percentValueInputPageDropdownState!.selectedChoice = selectedChoice;
    _updateState();
  }

  bool promotionProgramInputValidation() {
    return true;
  }



  void submitPromotionProgram() async {
    print("waw");
    if (!promotionProgramInputValidation()) {
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    String? username = preferences.getString("username");
    int? userId = preferences.getInt("userid");
    int? idEmp = preferences.getInt("idEmp");
    print(promotionProgramInputStateRx.value.promotionProgramInputState?.map<Map<String, dynamic>>((element) => <String, dynamic>{
      "price": element.priceTransaction?.text.replaceAll(",", ""),
    }));
    // final isiBody = jsonEncode(<String, dynamic>{
    //   "customerId": customerNameInputPageDropdownStateRx.value.selectedChoice?.id,
    //   "customerName": customerNameInputPageDropdownStateRx.value.selectedChoice?.value,
    //   "transactionLines": promotionProgramInputStateRx.value.promotionProgramInputState?.map<Map<String, dynamic>>((element) => <String, dynamic>{
    //     "productId": element.productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.id,
    //     "productName": element.productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.value,
    //     "unit": element.unitPageDropdownState?.selectedChoice,
    //     "qty": element.qtyTransaction!.text.isEmpty ? 0 : element.qtyTransaction?.text,
    //     "price": element.priceTransaction!.text.isEmpty ? 0 : int.parse(element.priceTransaction!.text.replaceAll(RegExp(r"[.,]"), "")),
    //     "disc": element.discTransaction?.text,
    //     "totalPrice": MoneyFormatter(amount: double.parse(element.totalTransaction!.text.replaceAll(RegExp(r"[.,]"), ""))).output.withoutFractionDigits.replaceAll(",", ""),
    //   }).toList()
    // });
    final isiBody = jsonEncode(<String, dynamic>{
        "custid": customerNameInputPageDropdownStateRx.value.selectedChoice?.id,
        "custReff": "test",
        "description": "Cuma test",
        "idEmp": idEmp,
        "lines": promotionProgramInputStateRx.value.promotionProgramInputState?.map<Map<String, dynamic>>((element) => <String, dynamic>{
          "itemId": element.productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.id,
          "qty": element.qtyTransaction!.text.isEmpty ? 0 : element.qtyTransaction?.text,
          "unit": element.unitPageDropdownState?.selectedChoice,
          "price": element.priceTransaction!.text.isEmpty ? 0 : int.parse(element.priceTransaction!.text.replaceAll(RegExp(r"[.,]"), "")),
        }).toList()
    });
    print(isiBody);
    List<PromotionProgramInputState>? promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState?.toList();
    List<String?>? dataTotal = promotionProgramInputState?.map((e) => e.totalTransaction?.text).toList();
    print(token);
    final response = await post(
        // Uri.parse('http://119.18.157.236:8869/api/transaction?idUser=$userId'),
        Uri.parse('http://api-scs.prb.co.id/api/SampleTransaction'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': '$token',
        },
        body: isiBody
    );
    print("status submit prod : ${response.statusCode}");
    Future.delayed(Duration(seconds: 2),(){
      if (response.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        final tabController = Get.put(DashboadOrderTakingTabController());
        Future.delayed(Duration(seconds: 2),(){
          tabController.initialIndex = 1;
          Get.offAll(
            MainMenuView(),
          );
          Get.to(DashboardOrderTaking(initialIndexs: 1,));
          // Get.offAll(HistoryNomorPP());
        });
        Get.dialog(
            SimpleDialog(
              title: Text("Success"),
              children: [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),barrierDismissible: false);
      } else {
        print("token : $token");
        Get.dialog(SimpleDialog(
          title: Text("Error"),
          children: [
            Center(
              child: Text("${response.statusCode}\n${response.body.replaceAll(r"\'", "'")}",style: TextStyle(color: Colors.red),textAlign: TextAlign.center),
            ),
            Center(
              child: Icon(Icons.error),
            )
          ],
        ));
        print(response.body);
      }
    }
    );
  }

  void submitPromotionProgramAll() async {
    if (!promotionProgramInputValidation()) {
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    String? username = preferences.getString("username");
    final isiBody = jsonEncode(<String, dynamic>{
      "PPtype": 1,
      "PPname": "${customerNameInputPageDropdownStateRx.value.selectedChoice?.id}-$username-${DateFormat("dd-mm-yyyy hh:mm:ss").format(DateTime.now())}",
      "PPnum": "${customerNameInputPageDropdownStateRx.value.selectedChoice?.id}-$username-${DateFormat("dd-mm-yyyy hh:mm:ss").format(DateTime.now())}",
      "Location": preferences.getString("so"),
      "Vendor": "",
      "CustomerId": customerNameInputPageDropdownStateRx.value.selectedChoice?.id,
      "Lines": promotionProgramInputStateRx.value.promotionProgramInputState?.map<Map<String, dynamic>>((element) => <String, dynamic>{
        "Customer": customerNameInputPageDropdownStateRx.value.selectedChoice?.id,
        "ItemId": element.productTransactionPageDropdownState?.selectedChoiceWrapper?.value?.id,
        "QtyFrom": element.qtyTransaction?.text,
        "QtyTo": element.qtyTransaction?.text,
        "Unit": element.unitPageDropdownState?.selectedChoice,
        "Multiply": 1,
        "FromDate": "${DateTime.now()}",//"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".replaceAll("${DateFormat("dd-mm-yyyy").format(DateTime.now())}", "${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[2]}-${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[1]}-${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[0]}"),
        "ToDate": "${DateTime.now()}",//"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".replaceAll("${DateFormat("dd-mm-yyyy").format(DateTime.now())}", "${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[2]}-${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[1]}-${"${DateFormat("dd-mm-yyyy").format(DateTime.now())}".split('-')[0]}"),
        "Currency": "IDR",
        "type": 1,
        "Pct1": element.discTransaction?.text,
        "Pct2": 0,
        "Pct3": 0,
        "Pct4": 0,
        "Value1": 0.0,
        "Value2": 0.0,
        "SupplyItemOnlyOnce": 0,
        "SupplyItem": "",
        "QtySupply": 0,
        "UnitSupply": "",
        "SalesPrice": element.priceTransaction!.text.isEmpty ? 0 : int.parse(element.priceTransaction!.text.replaceAll(RegExp(r"[.,]"), "")),
        "PriceTo": ""
      }).toList()
    });
    print("isiBody :$isiBody");
    List<PromotionProgramInputState> promotionProgramInputState = promotionProgramInputStateRx.value.promotionProgramInputState!.toList();
    print("mazda :${promotionProgramInputState.map((e) => e.totalTransaction?.text).toList()}");
    List dataTotal = promotionProgramInputState.map((e) => e.totalTransaction?.text).toList();
      final response = await post(
          Uri.parse('http://119.18.157.236:8869/api/activity?username=$username'),
          headers: {
            "Content-Type": "application/json",
            'Authorization': '$token',
          },
          body: isiBody
      );
      print("status submit alt : ${response.statusCode}");
      Future.delayed(Duration(seconds: 2),(){
        if (response.statusCode == 201) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
          final tabController = Get.put(DashboadOrderTakingTabController());
          Future.delayed(Duration(seconds: 2),(){
            tabController.initialIndex = 1;
            // Get.offAll(
            //   MainMenuView(),
            // );
            // Get.to(DashboardOrderTaking(initialIndexs: 1,));
          });
          // Get.dialog(
          //     SimpleDialog(
          //       title: Text("Success"),
          //       children: [
          //         Center(
          //           child: CircularProgressIndicator(),
          //         )
          //       ],
          //     ),barrierDismissible: false);
        } else {
          print("token : $token");
          Get.dialog(SimpleDialog(
            title: Text("Error"),
            children: [
              Center(
                child: Text("${response.statusCode}\n${response.body.replaceAll(r"\'", "'")}",style: TextStyle(color: Colors.red),textAlign: TextAlign.center),
              ),
              Center(
                child: Icon(Icons.error),
              )
            ],
          ));
          print(response.body);
        }
      }
      );
  }

  void _updateState() {
    promotionTypeInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    locationInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    customerNameInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    statusTestingInputPageDropdownStateRx.valueFromLast((value) => value.copy());
    promotionProgramInputStateRx.valueFromLast((value) => value.copy());
    update();
  }
}