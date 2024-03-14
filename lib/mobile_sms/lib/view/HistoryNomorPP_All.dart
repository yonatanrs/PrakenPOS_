import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/models/ApiConstant.dart';
import 'package:flutter_scs/mobile_sms/lib/view/HistoryLinesAll.dart';
import 'package:flutter_scs/mobile_sms/lib/view/HistoryLinesAllEdit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../assets/global.dart';
import '../assets/widgets/Debounce.dart';
import '../assets/widgets/TextResultCard.dart';
import '../models/Promosi.dart';
import '../models/User.dart';
import 'Login.dart';

class HistoryAll extends StatefulWidget {
  const HistoryAll({Key? key}) : super(key: key);

  @override
  _HistoryAllState createState() => _HistoryAllState();
}

class _HistoryAllState extends State<HistoryAll> {

  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  var _listHistory, listHistoryReal;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  late User _user;
  late int code;

  Future<Null> listHistory() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getAllListPromosi(0, code, _user.token??"token kosong", _user.username).then((value) {
      print("userToken: ${_user.token}");
      setState(() {
        listHistoryReal = value;
        _listHistory = listHistoryReal;
        // _listHistory.sort((a, b) => b.idTransaction - a.idTransaction);
      });
    });
    return null;
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
              title: "Type",
              value: promosi.customer!,
            ),
            TextResultCard(
              context: context,
              title: "AXStatus",
              value: promosi.axStatus==""?"-":promosi.axStatus!,
            ),
            SizedBox(height: 4,),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                      child: Center(
                        child: Text(
                          "VIEW LINES",
                          textAlign: TextAlign.center,
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
                            return HistoryLinesAll(
                              numberPP: promosi.namePP,
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
                  ),
                ),
                SizedBox(width: 2.w,),
                Expanded(
                  child: TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                      child: Center(
                        child: Text(
                          "VIEW STATUS",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: ScreenUtil().setSp(13),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var url = "${ApiConstant(1).urlApi}api/PromosiHeader?username=${prefs.getString("username")}&NoPP=${promosi.namePP}";
                      print("url :$url");
                      print("promo :${jsonEncode(promosi)}");
                      final response = await get(
                          Uri.parse(url),
                          headers: <String, String>{'authorization': _user.token!}
                      );
                      final listData = jsonDecode(response.body);
                      if(listData!=null&&response.statusCode==200){
                        Get.defaultDialog(
                          title: "Approval Status",
                          content: SingleChildScrollView(
                            child: Container(
                              width: Get.width,
                              height: Get.height-630,
                              child: ListView.builder(
                                  itemCount: listData.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Approval ${index+1} :"),
                                              Text("${listData[index]['User']}")
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Status :"),
                                              Text("${listData[index]['Status'].toString().replaceAll("Approve", "Approved")}")
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            )
                          )
                        );
                      }
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
                  ),
                ),
                SizedBox(width: 2.w,),
                Expanded(
                  child: TextButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(ScreenUtil().setWidth(7)),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                      child: Center(
                        child: Text(
                          "EDIT\nLINES",
                          textAlign: TextAlign.center,
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
                            return HistoryLinesAllEdit(
                              numberPP: promosi.namePP,
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
                  ),
                ),
              ],
            )
          ],
        ));
  }

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 20));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code")!;
    });
  }

  Future<bool> onBackPress() async{
    deleteBoxUser();
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return LoginView();
        }));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: TextField(
              controller: filterController,
              decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.all(ScreenUtil().setHeight(10)),
                  hintText: 'Enter customer, number PP or date',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: colorPrimary),
                      onPressed: () {
                        String value = filterController.text;
                        _debouncer.run(() {
                          setState(() {
                            _listHistory = listHistoryReal.where((element) =>
                            element.nomorPP
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                                element.date
                                    .toLowerCase()
                                    .contains(value.toLowerCase())||element.customer
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                                .toList();
                            print(_listHistory);
                          });
                        });
                      })),
              onEditingComplete: () {
                String value = filterController.text;
                _debouncer.run(() {
                  setState(() {
                    _listHistory = listHistoryReal
                        .where((element) =>
                    element.nomorPP
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                        element.date
                            .toLowerCase()
                            .contains(value.toLowerCase())||element.customer
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                        .toList();
                    print(_listHistory);
                  });
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: listHistory,
              child: FutureBuilder(
                future: Promosi.getAllListPromosi(
                    0, code, _user.token??"", _user.username??""),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError != true) {
                      _listHistory == null
                          ? _listHistory = listHistoryReal = snapshot.data
                          : _listHistory = _listHistory;
                      if (_listHistory.length == 0) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text('No Data'),
                              Text('Swipe down for refresh item'),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                          itemCount: _listHistory?.length,
                          itemBuilder:
                              (BuildContext context, int index) =>
                              CardAdapter(
                                _listHistory[index],
                              ));
                    } else {
                      print(snapshot.error.toString());
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.none) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Text('No Data'),
                          Text('Swipe down for refresh item'),
                        ],
                      ),
                    );
                  } else {
                    Future.delayed(Duration(milliseconds: 5));
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'Loading',
                      ),
                    );
                  }return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
