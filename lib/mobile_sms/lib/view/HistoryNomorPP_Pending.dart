
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assets/global.dart';
import '../assets/widgets/Debounce.dart';
import '../assets/widgets/TextResultCard.dart';
import '../models/Promosi.dart';
import '../models/User.dart';
import 'HistoryLines.dart';

class HistoryPending extends StatefulWidget {
  const HistoryPending({Key? key}) : super(key: key);

  @override
  _HistoryPendingState createState() => _HistoryPendingState();
}

class _HistoryPendingState extends State<HistoryPending> {

  final _debouncer = Debounce(miliseconds: 5);
  TextEditingController filterController = new TextEditingController();
  var _listHistory, listHistoryReal;
  late GlobalKey<RefreshIndicatorState> refreshKey;
  User? _user;
  int? code;

  Future<Null> listHistory() async {
    await Future.delayed(Duration(seconds: 5));
    Promosi.getListPromosi(0, code!, _user!.token??"token kosong", _user!.username).then((value) {
      print("userToken: ${_user!.token}");
      if(mounted){
        setState(() {
          listHistoryReal = value;
          _listHistory = listHistoryReal;
        });
      }
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
              title: "Salesman",
              value: promosi.salesman,
            ),
            TextResultCard(
              context: context,
              title: "Sales Office",
              value: promosi.salesOffice!,
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
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(13),
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                      return HistoryLines(
                        numberPP: promosi.namePP,
                        idEmp: _user!.id,
                      );
                    }));
              },
              style: TextButton.styleFrom(
                backgroundColor: colorBlueDark,
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
    print("userBox hive : $listUser");
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 20));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code")!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPreference();
    listHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   title: Text("Approval PP"),
      // ),
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
                future: Promosi.getListPromosi(0, code ?? 0, _user?.token??"", _user?.username??""),
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
