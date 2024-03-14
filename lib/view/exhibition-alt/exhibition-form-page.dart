import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/ApiConstant.dart';

class ExhibitionFormPage extends StatefulWidget {
  const ExhibitionFormPage({Key? key}) : super(key: key);

  @override
  _ExhibitionFormPageState createState() => _ExhibitionFormPageState();
}

class _ExhibitionFormPageState extends State<ExhibitionFormPage> {
  Widget cardCustomerForm() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 20, bottom: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Customer Name",
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "No Telp",
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Alamat",
                ),
                keyboardType: TextInputType.streetAddress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // var scanBarcode = "Unknown";
  List<String> scanBarcode = [];
  String? barcodeScanRes;
  String? valueScanBarcode;

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        !.listen((barcode) => print(barcode));
  }

  scanBarcodeNormal(int index) async {
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    print("isi scan1 : $scanBarcode");
    if (!mounted) return;
    setState(() {
      scanBarcode[index] = barcodeScanRes!;
      getUnit(scanBarcode[index], index);
    });
    print("isi scan2 : $scanBarcode");
  }

  List? dataUnitProduct;
  var valUnitProductValue;
  List<String> valUnitProduct = [];
  var listData;
  void getUnit(String idProduct, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var url = "${ApiConstant().urlApi}api/Unit?item=$idProduct";
    final response = await get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '$token',
    });
    listData = jsonDecode(response.body);
    print("url getDropdownProduct :$url");
    setState(() {
      dataUnitProduct = listData;
      if (!unitContains(valUnitProductValue)) {
        setState(() {
          valUnitProduct = null!;
        });
      }
    });
    print("Data Unit : $listData");
  }

  bool unitContains(String unit) {
    for (int i = 0; i < dataUnitProduct!.length; i++) {
      if (unit == dataUnitProduct![i]) return true;
    }
    return false;
  }

  Widget cardProductForm(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          dataProduct.length++;
                          valUnitProduct.length++;
                          scanBarcode.length++;
                        });
                      },
                      icon: Icon(
                          Icons.add
                      )),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          dataProduct.removeAt(index);
                          valUnitProduct.removeAt(index);
                          scanBarcode.removeAt(index);
                        });
                      },
                      icon: Icon(
                          Icons.delete
                      ))
                ],
              ),
              Row(
                children: [
                  Text("Nama Produk :"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      scanBarcode[index]??"Scan Barcode",
                      maxLines: 5,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          scanBarcode[index] = "";
                        });
                      },
                      icon: Icon(Icons.clear)),
                  IconButton(
                      onPressed: () => scanBarcodeNormal(index),
                      icon: Icon(Icons.scanner))
                ],
              ),
              SearchChoices.single(
                  isExpanded: true,
                  value: valUnitProductValue,
                  items: dataUnitProduct?.map((item) {
                    print("ini item :$item");
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  }).toList() ??
                      [],
                  onChanged: (value) {
                    valUnitProductValue = value;
                    valUnitProduct[index] = valUnitProductValue;
                  }),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "qty",
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Discount",
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> dataProduct = [];

  postCustomer()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "${ApiConstant().urlApi}api/Transaction?idOrder={idOrder}&amount={amount}&idSales={idSales}&idDevice={idDevice}&condition={condition}&transType={transType}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: Get.size.height,
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              cardCustomerForm(),
              SizedBox(
                height: 0,
              ),
              dataProduct.length == 0
                  ? ElevatedButton(
                      child: Text("Add Product"),
                      onPressed: () {
                        setState(() {
                          dataProduct.length++;
                          valUnitProduct.length++;
                          scanBarcode.length++;
                        });
                      })
                  : ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataProduct.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            cardProductForm(index),
                            index == dataProduct.length - 1
                                ? Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Center(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: Text("Submit"),
                                          onPressed: () {
                                            Get.back();
                                          }),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
