import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_scs/ext/rx_ext.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_scs/view/exhibition/IdAndValue.dart';
import 'package:flutter_scs/view/exhibition/exhibition-page.dart';
import 'package:flutter_scs/view/exhibition/exhibition-product-model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/ApiConstant.dart';
import '../../models/PostTransactionModel.dart';
import '../../models/PostTransactionModelDummy.dart';
import 'Wrapper.dart';
import 'customer-wrapper.dart';
import 'exhibition-and-customer-wrapper.dart';
import 'exhibition-product-input-state.dart';
import 'exhibition-wrapper.dart';
import 'input-page-dropdown-state.dart';
import 'package:collection/collection.dart';

class ExhibitionPresenter extends GetxController {

  RxBool isTap = false.obs;

  final ExhibitionWrapper _exhibitionWrapper = ExhibitionWrapper(
    exhibitionProgramInputState: [],
  );
  final CustomerWrapper _customerWrapper = CustomerWrapper(
    customerNameTextEditingController: TextEditingController(),
    noTelpTextEditingController: TextEditingController(),
    emailTextEditingController: TextEditingController(),
    addressTextEditingController: TextEditingController()
  );
  late Rx<ExhibitionWrapper> exhibitionProgramInputStateRx;
  late Rx<CustomerWrapper> customerWrapperRx;
  late Rx<ExhibitionAndCustomerWrapper> exhibitionAndCustomerWrapperRx;
  late Rx<PostTransactionModelDummy> postTransactionModelDummyRx = PostTransactionModelDummy(
    postTransactionModelList: []
  ).obs;
  late WrappedInputPageDropdownState _productWrappedInputPageDropdownState;

  ExhibitionPresenter() : super() {
    exhibitionProgramInputStateRx = _exhibitionWrapper.obs;
    customerWrapperRx = _customerWrapper.obs;
    exhibitionAndCustomerWrapperRx = ExhibitionAndCustomerWrapper(
      exhibitionWrapper: _exhibitionWrapper,
      customerWrapper: _customerWrapper
    ).obs;
    _productWrappedInputPageDropdownState = WrappedInputPageDropdownState<IdAndValue<String>>(
      selectedChoiceWrapper: Wrapper<IdAndValue<String>>(value: null),
      choiceListWrapper: Wrapper<List<IdAndValue<String>>>(value: []),
      loadingStateWrapper: Wrapper<int>(value: 0)
    );
  }

  addItem() {
    // Convert the dynamic list to a list of IdAndValue<String>
    var convertedChoiceListWrapper = _productWrappedInputPageDropdownState.choiceListWrapper?.value
        ?.map((item) => item as IdAndValue<String>)
        .toList();

    exhibitionProgramInputStateRx.value.exhibitionProgramInputState?.add(
        ExhibitionProgramInputState(
            qty: TextEditingController(),
            disc: TextEditingController(),
            stock: TextEditingController(),
            harga: 0.0,
            hargaOriginal: TextEditingController(),
            unitInputPageDropdownState: InputPageDropdownState<String>(
              choiceList: [],
              loadingState: 0,
            ),
            productInputPageDropdownState: WrappedInputPageDropdownState<IdAndValue<String>>(
                choiceListWrapper: Wrapper<List<IdAndValue<String>>>(value: convertedChoiceListWrapper),
                loadingStateWrapper: _productWrappedInputPageDropdownState.loadingStateWrapper,
                selectedChoiceWrapper: Wrapper<IdAndValue<String>>(value: null)
            ),
            exhibitionProductModel: null
        )
    );
    _updateState();
  }

  void removeItem(int index) {
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState?.removeAt(index);
    _updateState();
  }

  void resetProductToEmpty(int index) {
    print("before reset :${exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].exhibitionProductModel}");
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].exhibitionProductModel = null;
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].qty!.clear();
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].unitInputPageDropdownState!.selectedChoice = '';
    // exhibitionProgramInputStateRx.value.exhibitionProgramInputState[index].unitInputPageDropdownState.choiceList.clear();
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].hargaOriginal!.clear();
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].disc!.clear();
    exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index].harga = 0;
    // print("reset :${exhibitionProgramInputStateRx.value.exhibitionProgramInputState[index].exhibitionProductModel}");
    _updateState();
  }

  var store = intMapStoreFactory.store('listExhibition');
  List dataDraftExhibition = [].obs;
  late List dataKeys;

  getDraftExhibition()async{
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'SCS.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    dataKeys = await store.findKeys(db);
    //xx
    // PostTransactionModelDummy postTransactionModelDummy = exhibitiionPresenter.postTransactionModelDummyRx.value;
    dataDraftExhibition = await store.find(db);
    // List<PostTransactionModel> postTransactionModelList = dataDraftExhibition;
    log("cek :$dataDraftExhibition");
    // print("cek :$postTransactionModelList");
    log(dataDraftExhibition.toString());
    _updateState();
  }

  List dataListExhibition = [].obs;

  getListExhibition()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? idSales = prefs.getString("idSales");
      var url = "${ApiConstant().urlApi}api/Transaction/?idSales=$idSales&type=4";
      final response = await get(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': '$token',
          }
      );
      var listData = jsonDecode(response.body);
      print("listDataExhibitionCoett : ${listData}");
      print("urlListExhibition : $url");
      print("token : $token");
      print('statusListExhibition : ${response.statusCode}');
      dataListExhibition = listData;
      _updateState();
  }

  List dataListDetailExhibition = [].obs;

  getListDetailExhibition(dynamic idTransaction)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? idSales = prefs.getString("idSales");
    var url = "${ApiConstant().urlApi}api/Transaction/ExhibitionDetail?sales=$idSales&id=$idTransaction";

    print("url get detailExhibition : ${url}");
    final response = await get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      }
    );
    var listData = jsonDecode(response.body);
    print("urlListDetailExhibition : $url");
    print("token : $token");
    print('statusListDetailExhibition : ${response.statusCode}');
    log("getListDetailExhibition : $listData");
    Map<String, dynamic> map = listData;
    dataListDetailExhibition = map['Lines'] ;
    print("nonok :$dataListDetailExhibition");
    _updateState();
  }

  String Salesman = "";
  getFromSharedPrefs()async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Salesman = (await prefs.getString("getName"))!;
    // final box = GetStorage();
    // Salesman = box.read('getName');
    print(Salesman);
    _updateState();
  }

  final ScrollController listController  = ScrollController();


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFromSharedPrefs();
    getDraftExhibition();
    getListExhibition();
    getAllProduct();
  }

  var pilihDialog = "".obs;

  getAllProduct() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String idEmp = prefs.getString("getIdEmp").toString();
    var url = "${ApiConstant().urlApi}api/Product?id=$idEmp";
    print("urlProduct :$url");
    final response = await get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      }
    );
    var listData = jsonDecode(response.body);
    print("url getDropdownProduct :$url");
    print("RESPONSE product : ${listData}");
    _productWrappedInputPageDropdownState.loadingStateWrapper?.value = 1;
    _productWrappedInputPageDropdownState.choiceListWrapper?.value = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["itemId"], value: element["name"])).toList();
    // _productWrappedInputPageDropdownState.choiceListWrapper.value = listData.map<IdAndValue<String>>((element) => IdAndValue<String>(id: element["idProduct"], value: element["nameProduct"])).toList();
    // exhibitionProgramInputState.qty.text = 1.toString();
    _updateState();
  }

  var barcodeScanner;
  Future<void> startBarcodeScanStream(ExhibitionProgramInputState exhibitionProgramInputState) async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE
    )!.listen((barcode){
      try {
        if (barcode != "-1") {
            barcode = barcode;
            getBarcodeDetail(barcode, exhibitionProgramInputState);
        } else {
          barcode = "Scan canceled";
        }
        print("cek this :$barcode");
        _updateState();
      } catch (e) {
        e.toString();
        // Nothing
      }
    });
  }

  Future<void> scanBarcodeNormal(ExhibitionProgramInputState exhibitionProgramInputState) async {
    String _scanBarcode;
    try {
      final String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE
      );
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
      } else {
        _scanBarcode = "Scan canceled";
      }
      print("cek this :$_scanBarcode");
      await getBarcodeDetail(_scanBarcode, exhibitionProgramInputState);
      _updateState();
    } catch (e) {
      e.toString();
    }
  }

  getBarcodeDetail(String codeProduct, ExhibitionProgramInputState exhibitionProgramInputState) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    print("token : $token");
    var url = "${ApiConstant().urlApi}api/Product/?ItemId=$codeProduct";
    print("url barcodeDetail :$url");
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("isi barcodeDetail :${response.body}");
      final listData = jsonDecode(response.body);
      exhibitionProgramInputState.exhibitionProductModel = ExhibitionProductModel.fromJson(listData);
      print("stok ${exhibitionProgramInputState.exhibitionProductModel!.stock}");
      if (pilihDialog.value == "OTS") {
        getUnitProduct(exhibitionProgramInputState); // Removed await
        getPrice(exhibitionProgramInputState); // Removed await
      } else {
        getUnitProduct(exhibitionProgramInputState); // Removed await
        getPrice(exhibitionProgramInputState); // Removed await
      }
      _updateState();
    }
  }

  getUnitProduct(ExhibitionProgramInputState exhibitionProgramInputState)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = "${ApiConstant().urlApi}api/Unit?item=${exhibitionProgramInputState.exhibitionProductModel!.idProduct}";
    final response = await get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      }
    );
    var listData = jsonDecode(response.body);
    print("RESPONSE : ${response.body}");
    print("url getDropdownUnit :$url");
    InputPageDropdownState<String> unitInputPageDropdownState = exhibitionProgramInputState.unitInputPageDropdownState!;
    unitInputPageDropdownState.loadingState = 1;
    unitInputPageDropdownState.choiceList = listData.map<String>((value) => value.toString()).toList();
    unitInputPageDropdownState.selectedChoice = unitInputPageDropdownState.choiceList![0];
    exhibitionProgramInputState.qty!.text = 1.toString();
    _updateState();
  }

  void getPrice(ExhibitionProgramInputState exhibitionProgramInputState)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? wh = prefs.getString('getWh');
    var url = "${ApiConstant().urlApi}api/Product/cekStok?item=${exhibitionProgramInputState.exhibitionProductModel!.idProduct}&qty=${exhibitionProgramInputState.qty!.text}&unit=${exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice}&wh=$wh";
    print("url getPrice :$url");
    print("token :$token");
    final response = await get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': '$token',
      }
    );
    var listData = jsonDecode(response.body);
    var statusCode = response.statusCode;
    print("RESPONSE getPrice : ${response.body}");
    print("url getDropdownProduct :$url");
    print("disc :${listData['disc'].toString().split('.')[0]}");
    print('price :${listData['price']}');
    if(statusCode == 200){
      // exhibitionProgramInputState.qty.text = 1.toString();
      exhibitionProgramInputState.harga = listData['price'];
      exhibitionProgramInputState.hargaOriginal!.text = listData['price'].toString();
      exhibitionProgramInputState.stock!.text = "${listData['qty'].toString().split('.')[0]} ${listData['unit'].toString()}";
      // exhibitionProgramInputState.disc.text = listData['disc'].toString().toString().split('.')[0];
    }else{
      exhibitionProgramInputState.qty!.text = 0.toString();
      exhibitionProgramInputState.stock!.text = listData['message'].toString();
      exhibitionProgramInputState.hargaOriginal!.text = listData['price'].toString();
      exhibitionProgramInputState.harga = 0.0;
      // exhibitionProgramInputState.harga.text = listData['message'];
    }
    _updateState();
  }

  void changeProduct(int index, IdAndValue<String> selectedChoice) {
    print("selected product: $selectedChoice");
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];
    exhibitionProgramInputState.productInputPageDropdownState!.selectedChoice = selectedChoice;
    getBarcodeDetail(selectedChoice.id!, exhibitionProgramInputState);
    _updateState();
  }

  void changeUnit(int index, String selectedChoice) {
    print("selected unit :$selectedChoice");
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];
    if(pilihDialog=="OTS"){
      exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice = selectedChoice;
      exhibitionProgramInputState.qty!.text = 1.toString();
      // exhibitionProgramInputState.disc.text = 0.toString();
      getPrice(exhibitionProgramInputState);
    }else{
      exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice = selectedChoice;
      exhibitionProgramInputState.qty!.text = 1.toString();
      // exhibitionProgramInputState.disc.text = 0.toString();
      getPrice(exhibitionProgramInputState);
    }
    _updateState();
  }

  void changeQty(int index, String qty) async{
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];
    String qtyText = exhibitionProgramInputState.qty!.text;
    String discText = exhibitionProgramInputState.disc!.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? wh = prefs.getString('getWh');
    var urlChangeQty = "${ApiConstant().urlApi}api/Product/cekStok?item=${exhibitionProgramInputState.exhibitionProductModel!.idProduct}&qty=${exhibitionProgramInputState.qty!.text}&unit=${exhibitionProgramInputState.unitInputPageDropdownState!.selectedChoice}&wh=$wh";
    print("url getChangeQty :$urlChangeQty");
    print("token :$token");
    if(pilihDialog=="OTS"){
      exhibitionProgramInputState.harga = (qtyText.trim().isEmpty ? 1 : double.parse(qtyText)) * double.parse(exhibitionProgramInputState.hargaOriginal!.text) - ((double.parse(exhibitionProgramInputState.hargaOriginal!.text) * (qtyText.trim().isEmpty ? 1 : double.parse(qtyText))) * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
      final response = await get(
          Uri.parse(urlChangeQty),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': '$token',
          }
      );
      var listData = jsonDecode(response.body);
      print("listDataChangeQty : $listData");
      // exhibitionProgramInputState.stock.text = listData['message'];
    }else{
      exhibitionProgramInputState.harga = (double.parse(exhibitionProgramInputState.hargaOriginal!.text) * double.parse(exhibitionProgramInputState.qty!.text)) - ((double.parse(exhibitionProgramInputState.hargaOriginal!.text) * double.parse(exhibitionProgramInputState.qty!.text)) * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
    }
    _updateState();
  }

  void changeDisc(int index , String disc)async{
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];
    String discText = exhibitionProgramInputState.disc!.text;
    if(exhibitionProgramInputState.disc!.text.isEmpty){
      exhibitionProgramInputState.harga = (double.parse(exhibitionProgramInputState.qty!.text) * double.parse(exhibitionProgramInputState.hargaOriginal!.text));
    }else{
      // exhibitionProgramInputState.harga = (discText.trim().isEmpty ? 1 : double.parse(discText)) * double.parse(exhibitionProgramInputState.hargaOriginal.text);
      exhibitionProgramInputState.harga = exhibitionProgramInputState.harga! - (exhibitionProgramInputState.harga! * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
    }
    _updateState();
  }

  void changeHarga(int index, double value) {
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];

    // Update the original price
    exhibitionProgramInputState.hargaOriginal!.text = value.toString();

    // Fetch the other necessary values
    String qtyText = exhibitionProgramInputState.qty!.text;
    String discText = exhibitionProgramInputState.disc!.text;

    // Recalculate harga (subtotal) based on the new value, quantity and discount
    if(pilihDialog == "OTS") {
      exhibitionProgramInputState.harga = (qtyText.trim().isEmpty ? 1 : double.parse(qtyText)) * value - ((value * (qtyText.trim().isEmpty ? 1 : double.parse(qtyText))) * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
    } else {
      exhibitionProgramInputState.harga = (value * double.parse(qtyText)) - ((value * double.parse(qtyText)) * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
    }

    // Trigger an update
    _updateState();
  }


  void changeDiscAlt(int index , String disc)async{
    ExhibitionProgramInputState exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState![index];
    String discText = exhibitionProgramInputState.disc!.text;
    if(exhibitionProgramInputState.disc!.text.isEmpty){
      exhibitionProgramInputState.harga = (double.parse(exhibitionProgramInputState.qty!.text) * double.parse(exhibitionProgramInputState.hargaOriginal!.text));
    }else{
      exhibitionProgramInputState.harga = (double.parse(exhibitionProgramInputState.hargaOriginal!.text) * double.parse(exhibitionProgramInputState.qty!.text)) - ((double.parse(exhibitionProgramInputState.hargaOriginal!.text) * double.parse(exhibitionProgramInputState.qty!.text)) * (discText.trim().isEmpty ? 0 : double.parse(discText)) / 100);
    }
    _updateState();
  }

  //Get the total amount.
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
      print("total0 :$total");
    }
    return total;
  }

  void _updateState() {
    exhibitionProgramInputStateRx.valueFromLast((value) => value.copy());
    customerWrapperRx.valueFromLast((value) => value.copy());
    exhibitionAndCustomerWrapperRx.valueFromLast((value) => value.copy());
    postTransactionModelDummyRx.valueFromLast((value) => value.copy());
    update();
  }

  double sumList(List<double?> list) {
    return list.fold(0.0, (previousValue, element) => previousValue + (element ?? 0.0));
  }


  bool transactionProgramInputValidation() {
    return true;
  }
  void processTransaction()async{
    if (!transactionProgramInputValidation()) {
      return;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    String? username = preferences.getString("username");
    var idSales = preferences.getString("idSales");
    String? idDevice = preferences.getString("idDevice");
    String idOrder = "PRB${username}${DateFormat("ddMMyyyyhhmmss").format(DateTime.now())}";
    List<ExhibitionProgramInputState>? exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState;
    final totalHarga = exhibitionProgramInputState!.map((e) => e.harga).toList();
    final isiBody = jsonEncode(<String, dynamic>{
      "nameCust": customerWrapperRx.value.customerNameTextEditingController!.text,
      "contact": customerWrapperRx.value.noTelpTextEditingController!.text,
      "email": customerWrapperRx.value.emailTextEditingController!.text,
      "lines": exhibitionProgramInputStateRx.value.exhibitionProgramInputState!.map<Lines>(
              (value) => Lines(
              idOrder: idOrder,
              idProduct: value.exhibitionProductModel!.idProduct,
              nameProduct: value.exhibitionProductModel!.nameProduct,
              qty: int.tryParse(value.qty!.text),
              discount: value.disc!.text.isEmpty?0:int.tryParse(value.disc!.text),
              price: value.hargaOriginal!.text==""?0.0:double.parse(value.hargaOriginal!.text),
              // stock: 0,
              // subTotal: 0,
              totalAmount: value.harga,
              unit: value.unitInputPageDropdownState!.selectedChoice
          )
      ).toList()
    });

    print("isi body real :$isiBody");
    int transType = 0;
    if(pilihDialog.value=="OTS"){
      transType = 6;
    }else{
      transType = 7;
    }
    print("transType : $transType");
    var url = "${ApiConstant().urlApi}api/Transaction?idOrder=$idOrder&amount=${sumList(totalHarga)}&idSales=$idSales&idDevice=$idDevice&condition=0&transType=$transType";
    print("url transaction :$url");
    print("token :$token");
    final response = await post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': '$token',
        },
        body: isiBody
    );
    print("status submit real : ${response.statusCode}");
    // print("status submit real : ${response.body}");
    BuildContext context;
    if(response.statusCode==200){
      final tabController = Get.put(MyTabController());
      getListExhibition();
      Get.defaultDialog(
        title: "Success",
        content: Center(
          child: Icon(Icons.check,color: Colors.green,size: 100,),
        ),
        onWillPop: (){
          return Future.value(false);
        }
      );
      Future.delayed(Duration(seconds: 2),(){
        Get.back();
        isTap.value = false;
        customerWrapperRx.value.customerNameTextEditingController!.clear();
        customerWrapperRx.value.noTelpTextEditingController!.clear();
        customerWrapperRx.value.emailTextEditingController!.clear();
        exhibitionProgramInputState.clear();
        tabController.initialIndex = 1;
        tabController.controller.animateTo(tabController.initialIndex);
        update();
      });
    }else{
      Get.defaultDialog(
        title: "Error ${response.statusCode}",
        content: Center(
          child: Text(response.body,style:TextStyle(color: Colors.red, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
        )
      );
      isTap.value = false;
    }
    _updateState();
    // Get.back();
  }

  void processTransactionDummy() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    String? username = preferences.getString("username");
    var idSales = preferences.getString("idSales");
    String? idDevice = preferences.getString("idDevice");
    String idOrder = "PRB${username}${DateFormat("ddMMyyyyhhmmss").format(DateTime.now())}";
    List<ExhibitionProgramInputState>? exhibitionProgramInputState = exhibitionProgramInputStateRx.value.exhibitionProgramInputState;
    final totalHarga = exhibitionProgramInputState!.map((e) => e.harga).toList();
    print("total harga : ${sumList(totalHarga)}");
    final isiBody = PostTransactionModel(
        email: customerWrapperRx.value.emailTextEditingController!.text,
        contact: customerWrapperRx.value.noTelpTextEditingController!.text,
        nameCust: customerWrapperRx.value.customerNameTextEditingController!.text,
        dateOrder: DateFormat("ddMMyyyyhhmmss").format(DateTime.now()),
        totalHarga: sumList(totalHarga),
        lines: exhibitionProgramInputStateRx.value.exhibitionProgramInputState!.map<Lines>(
                (value) => Lines(
                idOrder: idOrder,
                idProduct: value.exhibitionProductModel!.idProduct,
                nameProduct: value.exhibitionProductModel!.nameProduct,
                qty: int.tryParse(value.qty!.text),
                discount: int.tryParse(value.disc!.text),
                price: value.hargaOriginal!.text==''?0.0:double.parse(value.hargaOriginal!.text),
                totalAmount: value.harga,
                unit: value.unitInputPageDropdownState!.selectedChoice
            )
        ).toList()
    );
    postTransactionModelDummyRx.value.postTransactionModelList!.add(
      isiBody,
    );
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'SCS.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('listExhibition');
    Map<String, dynamic> map = isiBody.toJson();
    await store.addAll(db, [map]);//put(db, isiPost);
    log("db log :${await store.find(db)}");
    getDraftExhibition();
    _updateState();
    // Get.back();
  }

  Future<void> generateInvoice(dynamic dataProduct, dynamic idTransaksi, dynamic dataCustomer) async {
    print("index ${dataCustomer}");
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid(dataProduct);
    //Draw the header section by creating text element
    final PdfLayoutResult? result = drawHeader(page, pageSize, grid, dataProduct, idTransaksi, dataCustomer);
    //Draw grid
    drawGrid(page, grid, result!, dataCustomer);
    //Add invoice footer
    drawFooter(page, pageSize, grid, dataCustomer);
    //Save the PDF document
    final List<int> bytes = document.save();
    document.dispose();
    // String pdfName = "Invoice";
    String pdfName = "Invoice ${idTransaksi}.pdf";
    Directory directory = (await getApplicationDocumentsDirectory());
    File file = await File('${directory.path}/$pdfName');
    await file.writeAsBytes(bytes,mode: FileMode.write, flush: true);
    _updateState();
    Get.bottomSheet(
      Column(
        children: [
          Expanded(
            child: SfPdfViewer.memory(
              file.readAsBytesSync(),
            ),
          ),
          IconButton(
              color: Colors.blue,
              // iconSize: 30,
              onPressed: (){
                print("${directory.path}/$pdfName");
                Share.shareFiles(["${directory.path}/$pdfName"], subject: 'PDF Invoice' );
              }, icon: Icon(Icons.share))
        ],
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
    );
    //Dispose the document.
    //Save and launch the file.
  }

  //Draws the invoice header
  PdfLayoutResult? drawHeader(PdfPage page, Size pageSize, PdfGrid grid, dynamic dataProduct , dynamic idTransaksi, dynamic dataCustomer) {

    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'Order', PdfStandardFont(PdfFontFamily.helvetica, 50),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final prambananKencana = "PT PRAMBANAN KENCANA";
    final String invoiceNumber1 =
        '\r\n\r\nOrder Number: ${idTransaksi}\r\n\r\nDate: ${format.format(DateTime.now())}\r\n\r\nSalesman: $Salesman';
    final String invoiceNumber2 =
        '\r\n\r\nCust Name: ${dataCustomer['name']}\r\n\r\nCompany: ${dataCustomer['company']}\r\n\r\nPhone No: ${dataCustomer['tlp']}';
    final Size contentSize = contentFont.measureString(invoiceNumber1);

    PdfTextElement(text: invoiceNumber2, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    PdfTextElement(text: prambananKencana, font: PdfStandardFont(PdfFontFamily.helvetica, 15,style: PdfFontStyle.bold),).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 110,
            pageSize.width - (contentSize.width + 30), pageSize.height));

    return PdfTextElement(text: invoiceNumber1, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize.width + 30), pageSize.height - 120));
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result, dynamic) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    //Draw grand total.
    page.graphics.drawString('',
    // page.graphics.drawString('Order Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left-10,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));

    page.graphics.drawString("",
    // page.graphics.drawString("Rp ${MoneyFormatter(amount: getTotalAmount(grid).toDouble()).output.withoutFractionDigits}",
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left-10,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width + double.infinity,
            totalPriceCellBounds!.height),);
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize, PdfGrid grid, dynamic dataCustomer) async{
    print("dataCustomer : ${dataCustomer['total']}");
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];

    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));


    String footerContent = "Order Total : Rp ${MoneyFormatter(amount: dataCustomer['total']).output.withoutFractionDigits}";

    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid(dynamic data) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 7);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Product Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Product Name';
    headerRow.cells[2].value = 'Unit';
    headerRow.cells[3].value = 'Quantity';
    headerRow.cells[4].value = 'Price';
    headerRow.cells[5].value = 'Discount';
    headerRow.cells[6].value = 'Total';


    //Add rows
    for (int i = 0; i < data.length ; i++){
      addProducts('${data[i]['idProduct']}', '${data[i]['nameProduct']}',data[i]['unit'], data[i]['qty'], double.parse(data[i]['price'].toString()), data[i]['discount']??0 , double.parse(data[i]['totalAmount'].toString()), grid);
    };
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(
      String productId, String productName,
      dynamic unit,int quantity,double price,
      dynamic disc, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = unit.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = MoneyFormatter(amount: price).output.withoutFractionDigits.toString();
    row.cells[5].value = "${disc.toString()} %";
    row.cells[6].value = MoneyFormatter(amount: total).output.withoutFractionDigits.toString();
    // row.cells[6].value = total.toString(); //MoneyFormatter(amount: total).output.withoutFractionDigits.toString();

  }

}


class MyTabController extends GetxController with GetSingleTickerProviderStateMixin {
  // dynamic myTab;
  int initialIndex = 0;
  MyTabController({this.initialIndex=0});

  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    // Future.delayed(Duration(seconds: 1),(){
    //   controller = TabController(vsync: this, length: 3, initialIndex: initialIndex);
    // });
    controller = TabController(vsync: this, length: 3, initialIndex: initialIndex);
    // controller = TabController(vsync: this, length: 2, initialIndex: initialIndex);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}