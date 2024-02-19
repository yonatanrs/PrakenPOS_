import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/models/ApprovalPromo.dart';
import 'package:flutter_scs/models/promosi.dart';
import 'package:flutter_scs/parameters/UrlAPI.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'approval-promo-page.dart';

class ApprovalPromoPresenter extends GetxController {
  final data = <ApprovalPromosi>[].obs;

  String? IdEmp;

  // RxList<String> priceController = [].obs;
  // RxList<TextEditingController> priceController = [].obs;


  Future<dynamic> getDataApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IdEmp = prefs.getString("getIdEmp").toString();
    var urlApproval = '${ApiConstant().urlApi}Api/Approval/$IdEmp';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IdEmp = prefs.getString("getIdEmp").toString();
    var urlApprovalDetails = "${ApiConstant().urlApi}api/Promo/$idProduct?approvalId=$IdEmp";
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

  showAlertSuccess(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Center(child: Text("Success")),
            content: SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                      Icons.check_rounded,
                    size: 30,
                    color: Colors.green,
                  ),
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 0.7,
                  ),
                ],
              ),
            )));
  }

  showAlertReject(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Center(child: Text("Rejected")),
            content: SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.clear,
                    size: 30,
                    color: Colors.red,
                  ),
                  const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 0.7,
                  ),
                ],
              ),
            )));
  }


  approvalProcess(BuildContext context, int idPromosi, dynamic price, dynamic discount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IdEmp = prefs.getString("getIdEmp").toString();
    var urlApprove = "${ApiConstant().urlApi}api/Approval?id=$idPromosi&value=1&approvedBy=$IdEmp";
    print("ini urlApprove : $urlApprove");
    var jsonApprovalButton = await post(
        Uri.parse(urlApprove),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "Id": idPromosi,
          "Lines": [
            {
              "Price": price,
              "Disc": discount,
            }
          ]
        },
    ));
    print(jsonApprovalButton.statusCode.toString());
    print(jsonApprovalButton.body.toString());
    if(jsonApprovalButton.statusCode==200){
      showAlertSuccess(context);
      Future.delayed(Duration(seconds: 3),(){
        Get.off(ApprovalPromoPage());
      });
    }
    update();
  }

  rejectProcess(BuildContext context,int idPromosi, dynamic price, dynamic discount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    IdEmp = prefs.getString("getIdEmp").toString();
    var urlApprove =
        "${ApiConstant().urlApi}api/Approval?id=$idPromosi&value=2&approvedBy=$IdEmp";
    print("ini urlApprove : $urlApprove");
    var jsonRejectButton = await post(
        Uri.parse(urlApprove),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "Id": idPromosi,
          "Lines": [
            {
              "Price": price,
              "Disc": discount,
            }
          ]
        },
    ));
    print(jsonRejectButton.statusCode.toString());
    print(jsonRejectButton.body.toString());
    if(jsonRejectButton.statusCode==200){
      showAlertReject(context);
      Future.delayed(Duration(seconds: 3),(){
        Get.off(ApprovalPromoPage());
      });
    }
    update();
  }
}
