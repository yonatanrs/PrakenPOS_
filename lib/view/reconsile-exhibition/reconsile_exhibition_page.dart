import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/view/reconsile-exhibition/reconsile_exhibition_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../assets/style.dart';
import '../MainMenuView.dart';

class ReconsileExhibitionPage extends StatefulWidget {
  const ReconsileExhibitionPage({Key? key}) : super(key: key);

  @override
  State<ReconsileExhibitionPage> createState() =>
      _ReconsileExhibitionPageState();
}

class _ReconsileExhibitionPageState extends State<ReconsileExhibitionPage> {
  String dropdownValue = 'One';
  bool isChecked = false;

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }

  List data = [];

  getStockOnHand() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wh = prefs.getString('getWh');
    var url = "${ApiConstant().urlApi}api/StockOnHands?warehouse=$wh";
    print("url stockonhand :$url");
    final response = await get(Uri.parse(url));
    // id: 234, idItem: P002958, idWarehouse: DC07-X, idUnit: ctn, qty: 170.0, inventQty: 510.0, inventUnit: pack, ordered: 0.0, reserved: 0.0, sold: 0.0, parentId: null, createdDateTime: 2022-09-20T08:51:00.51
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        print("data : $data");
      });
    } else {
      jsonDecode(response.body);
    }
  }

  processSubmit()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? wh = prefs.getString('getWh');
    String? username = prefs.getString("username");
    var url = "${ApiConstant().urlApi}api/StockOnHands?warehouse=$wh&user=$username";
    print("url processSubmit : $url");
    List processSubmit = [];
    List dataItemName = data.map((element) => element['itemName']).toList();
    List dataUnit = data.map((element) => element['idUnit']).toList();
    List dataIdItem = data.map((element) => element['idItem']).toList();
    List dataFisikQty = fisikControllerList.map((element) => element.text.isEmpty?element.text=0.toString():element.text).toList();
    List dataqtySystem = data.map((element) => element['inventQty']).toList();
    log("dataFisikQty :$dataFisikQty");
    Map<String, Object> body (String idProduct, String unit, int qtyFisik, double qtySystem){
      var isiBody =  {
        "idProduct": idProduct,
        "unit": unit,
        "qtyFisik": qtyFisik,
        'qtySystem': qtySystem
      };
      return isiBody;
    }
    for (int i=0; i < data.length; i++){
      processSubmit.add(body(dataIdItem[i], dataUnit[i], int.parse(dataFisikQty[i]), dataqtySystem[i]));
    }
    json.encode(processSubmit);
    final response = await post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(processSubmit),
    );
    log("body post : ${jsonEncode(processSubmit)}");
    if(response.statusCode==200){
      Future.delayed(Duration(seconds: 1),(){
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Submit Completed Successfully!',
          onConfirmBtnTap: (){
            Get.offAll(ReconsileViewExhibition());
          }
        );
      });
    }else{
      Future.delayed(Duration(seconds: 1),(){
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: '${response.body}',
        );
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStockOnHand();
  }

  DataTable createDataTable(){
    return DataTable(
      columnSpacing: 50.w,
        columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('ID Produk')),
      DataColumn(label: Text('Stokhand')),
      DataColumn(label: Text('Fisik')),
      DataColumn(label: Text('Unit'))
    ];
  }

  List<TextEditingController> fisikControllerList = [];
  TextEditingController fisikController = TextEditingController();

  List<DataRow> _createRows() {
    // for (int i = 0; i < data.length; i++)
      return data.asMap().map((i, element){
        // fisikControllerList = List.generate(i, (index) => TextEditingController());
        fisikControllerList.add(TextEditingController());
        return MapEntry(
            i, DataRow(
            cells: [
                    DataCell(Text(element['itemName'])),
                    DataCell(Text(element['inventQty'].toString().split(".")[0])),
                    DataCell(
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: fisikControllerList[i],
                        onChanged: ((value) {
                          value = fisikControllerList[i].text;
                          print(fisikControllerList[i].text);
                          // print(value);
                          // fisikControllerList[i].text = value;
                          // print(fisikControllerList[i].text);
                        }),
                      ),
                    ),
                    DataCell(Text(element['idUnit'])),
          ]
        ));
      }).values.toList();
    // return data.map((book){
    //     return DataRow(
    //       cells: [
    //         DataCell(Text(book['itemName'])),
    //         DataCell(Text(book['inventQty'].toString().split(".")[0])),
    //         DataCell(
    //           TextFormField(
    //             keyboardType: TextInputType.number,
    //             controller: fisikControllerList[i],
    //             onChanged: ((value) {
    //               print(i);
    //               print(book);
    //               // print(value);
    //               // fisikControllerList[i].text = value;
    //               // print(fisikControllerList[i].text);
    //             }),
    //           ),
    //         ),
    //         DataCell(Text(book['idUnit'])),
    //       ]);
    // }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: colorBlueDark,
            title: Text(
              'Reconciliation History',
              style: textHeaderView,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: colorAccent,
              onPressed: () => _onBackPress(),
            )),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 500.w,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                // Text(data.toString()),
                createDataTable(),
                SizedBox(height: 50.h,),
                ElevatedButton(
                    onPressed: (){
                      processSubmit();
                    },
                    child: Text("Submit")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
