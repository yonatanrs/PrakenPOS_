import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_approvalpp.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_ordertaking.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_pp.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  void deleteBoxUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    SharedPreferences pref = await SharedPreferences.getInstance();

    Future.delayed(Duration(milliseconds: 10));
    await _userBox.deleteFromDisk();
    pref.setInt("flag", 0);
    pref.setString("result", "");
  }

  Future<bool> onBackPress() async{
    deleteBoxUser();
    await Get.offAll(LoginView());
    return Future.value(false);
  }

  void LogOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure log out ?'),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text('Cancel')),
            TextButton(onPressed: onBackPress, child: Text('Ok')),
          ],
        ));
  }

  List dataMenu = [
    {
      "title": "Program\nPromotion",
      "icon": Icons.discount_outlined,
      "naviGateTo": DashboardPP(),
    },
    {
      "title": "Approval\nPP",
      "icon": Icons.approval_outlined,
      "naviGateTo": DashboardApprovalPP(),
    },
    {
      "title": "Order\nTaking",
      "icon": Icons.shopping_bag_outlined,
      "naviGateTo": DashboardOrderTaking(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          onPressed: LogOut,
        ),
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 120,
              width: Get.width,
              child: ListView.builder(
                  itemCount: dataMenu.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Container(
                      width: 110,
                      margin: EdgeInsets.only(right: 5,left: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            Get.to(dataMenu[index]['naviGateTo']);
                          },
                          child: Container(
                              child: Stack(
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Icon(dataMenu[index]['icon'],color: Colors.black54,size: 45,)
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(dataMenu[index]['title'],style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)),
                                  ),
                                ],
                              ))),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
