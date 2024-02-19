import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/widgets/Debounce.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/widgets/TextResultCard.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Promosi.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/mobile_sms/lib/view/HistoryNomorPP_All.dart';
import 'package:flutter_scs/mobile_sms/lib/view/HistoryNomorPP_Pending.dart';
import 'package:flutter_scs/mobile_sms/lib/view/input-page/input-page-new.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_page.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_page.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HistoryLines.dart';
import 'Login.dart';

class HistoryNomorPP extends StatefulWidget {
  @override
  _HistoryNomorPPState createState() => _HistoryNomorPPState();
  // int idEmp;
  // int codeUrl;
  // HistoryNomorPP({this.idEmp, this.codeUrl});
}

class _HistoryNomorPPState extends State<HistoryNomorPP> {
  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  var _listHistory, listHistoryReal;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  late User _user;
  late int code;

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getSharedPreference();
  }

  Future<Null> listHistory() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getListPromosi(0, code, _user.token??"token kosong", _user.username).then((value) {
      print("userToken: ${_user.token}");
      setState(() {
        listHistoryReal = value;
        _listHistory = listHistoryReal;
      });
    });
    return null;
  }

  Future<Null> listHistoryAll() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getAllListPromosi(0, code, _user.token??"token kosong", _user.username).then((value) {
      print("userToken: ${_user.token}");
      setState(() {
        listHistoryReal = value;
        _listHistory = listHistoryReal;
      });
    });
    return null;
  }

  List<Widget> pages = [
    Container(
      height: Get.size.height,
      width: Get.size.width,
      child: HistoryPending(),
    ),
    Container(
      height: Get.size.height,
      width: Get.size.width,
      child: HistoryAll(),
    ),
  ];

  final ScrollController listController  = ScrollController();

  Future<bool> onBackPressLines() {
    Get.back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBackPressLines,
      child: MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
          floatingActionButton: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                  heroTag: "TransactionList",
                  onPressed: (){
                    Get.to(TransactionHistoryPage());
                  },
                  label: Text("Order Taking List")),
              SizedBox(height: 10,),
              FloatingActionButton.extended(
                heroTag: "Transaction",
                  onPressed: (){
                    Get.to(TransactionPage());
                  },
                  label: Text("Order Taking")),
              SizedBox(height: 10,),
              FloatingActionButton.extended(
                heroTag: "All PP",
                  onPressed: (){
                    setState(() {
                      listController.animateTo(
                        listController.position.maxScrollExtent,
                        duration: Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                      );
                    });
                  },
                  label: Text("All History")),
            ],
          ),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColorDark,
            leading: IconButton(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: LogOut,
            ),
            actions: [
              Center(
                child: IconButton(
                  icon: Icon(Icons.edit,color: Colors.white,),
                  onPressed: (){
                    Get.to(InputPageNew());
                  },
                ),
              )
            ],
            title: Text(
              "List PP",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            controller: listController,
            children: pages
          ),
        ),
      ),
    );
  }

  Container CardAdapter(Promosi promosi) {
    return Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: <Widget>[
            TextResultCard(
              context: context,
              title: "No. PP",
              value: promosi.nomorPP!,
            ),
            TextResultCard(
              context: context,
              title: "Date",
              value: promosi.date,
            ),
            TextResultCard(
              context: context,
              title: "Customer",
              value: promosi.customer!,
            ),
            TextButton(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                child: Center(
                  child: Text(
                    "VIEW LINES",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: ScreenUtil().setSp(13),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return HistoryLines(
                    numberPP: promosi?.namePP,
                    idEmp: _user.id,
                  );
                }));
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                      width: 2),
                ),
                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
              ),
            )
          ],
        ));
  }

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    print("userBox hive : ${listUser}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 20));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code")!;
    });
  }

  Future<bool> onBackPress() async{
    deleteBoxUser();
    await Get.offAll(LoginView());
    return Future.value(false);
  }

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
}
