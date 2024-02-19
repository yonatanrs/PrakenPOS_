import 'dart:async';
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/widgets/ConditionNull.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/widgets/TextResultCard.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Lines.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Promosi.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/mobile_sms/lib/providers/LinesProvider.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_approvalpp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ApiConstant.dart';
import 'HistoryNomorPP.dart';
import 'HistorySO.dart';
import 'HistorySOAll.dart';

class HistoryLinesApproved extends StatefulWidget {
  @override
  _HistoryLinesApprovedState createState() => _HistoryLinesApprovedState();
  String? numberPP;
  int? idEmp;

  HistoryLinesApproved({this.numberPP, this.idEmp});
}

class _HistoryLinesApprovedState extends State<HistoryLinesApproved> {
  List<Promosi> _listHistorySO = <Promosi>[];
  dynamic _listHistorySOEncode;
  bool? _statusDisable = true;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  List<int> _listid = <int>[];
  List<Lines> listDisc = <Lines>[];
  DateTime selectedDate = DateTime.now();
  late DateTime fromDate, toDate;
  late DateTime dateFrom, dateTo;
  double discount = 0.0;
  late User _user;
  late int code;

  bool valueSelectAll = false;

  var dataHeader;
  bool startApp = false;
  Future<Null> listHistorySO() async {
    await Future.delayed(Duration(seconds: 1));
    Promosi.getListLines(widget.numberPP!, code, _user.token!, _user.username)
        .then((value) {
      setState(() {
        _listHistorySO = value;
        _listHistorySOEncode = jsonEncode(_listHistorySO);
        dataHeader = jsonDecode(_listHistorySOEncode);
      });
    });
    return null;
  }

  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getSharedPreference();
    Future.delayed(Duration(seconds: 2),(){
      startApp = true;
      listHistorySO();
    });
  }

  late Promosi promosi;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressLines,
      child: MaterialApp(
        theme: Theme.of(context),
        home: ChangeNotifierProvider<LinesProvider>(
          create: (ctx) => LinesProvider(),
          // builder: (context) => LinesProvider(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                // onPressed: (){
                //   Get.offAll(page);
                // },
                onPressed: onBackPressLines,
              ),
              title: Text(
                "List Lines",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            body: Scaffold(
              body: RefreshIndicator(
                onRefresh: listHistorySO,
                child: FutureBuilder(
                  future: Promosi.getListLines(
                      widget.numberPP!, code, _user!.token!, _user!.username),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    _listHistorySO == null
                        ? _listHistorySO = snapshot.data
                        : _listHistorySO = _listHistorySO;
                    if (_listHistorySO == null) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Loading...",
                          ),
                        ),
                      );
                    } else {
                      if (_listHistorySO![0].codeError == 404 ||
                          _listHistorySO![0].codeError == 303) {
                        return ConditionNull(
                            message: _listHistorySO![0].message);
                      } else {
                        return startApp==false?Center(child: CircularProgressIndicator()):SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextResultCard(
                                      context: context,
                                      title: "No. PP",
                                      value: RegExp(r"\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}").hasMatch(dataHeader[0]["nomorPP"])==true?dataHeader[0]["nomorPP"].replaceRange(34, null, ""):dataHeader[0]["nomorPP"],
                                    ),
                                    TextResultCard(
                                      context: context,
                                      title: "PP. Type",
                                      value: "${dataHeader[0]["type"]}",
                                    ),
                                    TextResultCard(
                                      context: context,
                                      title: "Customer",
                                      value: "${dataHeader[0]["customer"]}",
                                    ),
                                    TextResultCard(
                                      context: context,
                                      title: "Note",
                                      value: "${dataHeader[0]["note"]}",
                                    ),
                                    Container(
                                        width: ScreenUtil().setHeight(MediaQuery.of(context).size.width),
                                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Consumer<LinesProvider>(
                                            builder: (context, linesProv, _) => TextFormField(
                                              readOnly: true,
                                              initialValue: dataHeader[0]["fromDate"].split(" ")[0].toString(),
                                              keyboardType: TextInputType.datetime,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  filled: true,
                                                  labelText: 'From Date',
                                                  hintStyle: TextStyle(
                                                      color: Theme.of(context).primaryColor,
                                                      fontSize: 15),
                                                  errorStyle: TextStyle(
                                                      color: Theme.of(context).errorColor,
                                                      fontSize: 15)),
                                            ))),
                                    Container(
                                        width:
                                        ScreenUtil().setHeight(MediaQuery.of(context).size.width),
                                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Consumer<LinesProvider>(
                                            builder: (context, linesProv, _) => TextFormField(
                                              readOnly: true,
                                              initialValue: dataHeader[0]["toDate"].split(" ")[0],
                                              keyboardType: TextInputType.datetime,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  filled: true,
                                                  labelText: 'To Date',
                                                  hintStyle: TextStyle(
                                                      color: Theme.of(context).primaryColor,
                                                      fontSize: 15),
                                                  errorStyle: TextStyle(
                                                      color: Theme.of(context).errorColor,
                                                      fontSize: 15)),
                                            ))),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount: _listHistorySO?.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return CardLinesAdapter(
                                      widget.numberPP!, _listHistorySO![index], index);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container CardLinesAdapter(String namePP, Promosi promosi, int index) {

    double price = double.parse(promosi.price!.replaceAll(RegExp("Rp"), "").replaceAll(".", ""));
    double disc1 = double.parse(promosi.disc1!);
    double disc2 = double.parse(promosi.disc2!);
    double disc3 = double.parse(promosi.disc3!);
    double disc4 = double.parse(promosi.disc4!);
    double discValue1 = double.parse(promosi.value1!);
    double discValue2 = double.parse(promosi.value2!);
    double totalPriceDiscOnly = price - (price * ((disc1+disc2+disc3+disc4)/100));
    double totalPriceDiscValue = price - (discValue1+discValue2);
    List<Promosi> data = _listHistorySO;
    print("dataDetail :${jsonEncode(_listHistorySO)}");
    List qtyFrom = data.map((element) => element.qty).toList();
    print("qty from :$qtyFrom");
    List qtyTo = data.map((element) => element.qtyTo).toList();
    print("qty to :$qtyTo");
    print("no pp :${promosi.nomorPP}");
    print("pp type :${promosi.ppType}");
    String? str = promosi.nomorPP;

    bool hasDateTime = RegExp(r"\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}").hasMatch(str!);
    print("hasDateTime : ${hasDateTime}"); // Output: true
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
              title: "Product",
              value: promosi.product!,
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  child: TextResultCard(
                    context: context,
                    title: "Qty From",
                    value: qtyFrom[index].toString(),
                  ),
                ),
                Container(
                  width: 150,
                  child: TextResultCard(
                    context: context,
                    title: "Qty To",
                    value: qtyTo[index].toString(),
                  ),
                ),
              ],
            ),
            TextResultCard(
              context: context,
              title: 'Unit',
              value: promosi.unitId!,
            ),
            TextResultCard(
              context: context,
              title: "Price",
              value: promosi.price!,
            ),
            //Discount
            promosi.ppType=="Bonus"?SizedBox():Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc1(%) PRB",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: promosi.disc1?.split(".").first,
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc2(%) COD",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: promosi.disc2?.split(".").first,
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),
              ],
            ),
            promosi.ppType=="Bonus"?SizedBox():Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc3(%) Principal1",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: promosi.disc3?.split(".").first,
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc4(%) Principal2",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: promosi.disc4!.split(".").first,
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),
              ],
            ),
            promosi.ppType=="Bonus"?SizedBox():Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc Value1 ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: "${MoneyFormatter(amount: double.parse(promosi.value1!)).output.withoutFractionDigits}",
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  width: MediaQuery.of(context).size.width / 5,
                  child: Text(
                    "Disc Value2 ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: ScreenUtil().setSp(15),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Consumer<LinesProvider>(
                    builder: (context, linesProv, _) => TextFormField(
                      readOnly: _statusDisable!,
                      keyboardType: TextInputType.text,
                      initialValue: "${MoneyFormatter(amount: double.parse(promosi.value2!)).output.withoutFractionDigits}",
                      onFieldSubmitted: (value) {
                        setBundleLines(
                            promosi.id, double.parse(value), null, null);
                      },
                    ),
                  ),
                ),
              ],
            ),
            promosi.ppType=="Diskon"?SizedBox():TextResultCard(
              context: context,
              title: 'Bonus Item',
              value: promosi.suppItem!,
            ),
            promosi.ppType=="Diskon"?SizedBox():TextResultCard(
              context: context,
              title: 'Bonus Qty',
              value: promosi.suppQty!,
            ),
            promosi.ppType=="Diskon"?SizedBox():TextResultCard(
              context: context,
              title: 'Bonus Unit',
              value: promosi.suppUnit!,
            ),


            TextResultCard(
                context: context,
                title: "Total",
                value: "Rp${MoneyFormatter(amount: promosi.disc1=="0.00"&&promosi.disc2=="0.00"&&promosi.disc3=="0.00"&&promosi.disc4=="0.00"?totalPriceDiscValue:totalPriceDiscOnly).output.withoutFractionDigits.replaceAll(",", ".")}"
            ),
          ],
        ));
  }

  void setBundleLines(
      int id, double disc, DateTime? fromDate, DateTime? toDate) async {
    Lines model = new Lines();
    List<Lines> listDisc = <Lines>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? result = preferences.getString("result");
    if (result != "") {
      var listStringResult = json.decode(result!);
      for (var objectResult in listStringResult) {
        var objects = Lines.fromJson(objectResult as Map<String, dynamic>);
        listDisc.add(objects);
      }
    }
    model.id = id;
    model.disc = disc;
    model.fromDate = fromDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(fromDate).toString();
    model.toDate = toDate == null
        ? null
        : DateFormat('MM-dd-yyyy').format(toDate).toString();
    listDisc.add(model);
    List<Map> listResult = listDisc.map((f) => f.toJson()).toList();
    result = jsonEncode(listResult);
    preferences.setString("result", result);
  }

  approveNew(String apprroveOrReject)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic id = prefs.getInt("userid");
    String url = ApiConstant(code).urlApi + "api/Approve/$id";
    List<Promosi> data = _listHistorySO;
    print(_listHistorySO);
    List idLines = data.map((element) => element.id).toList();

    dynamic isiBody = jsonEncode(<String, dynamic>{
      "status": apprroveOrReject=="Approve"?1:2,
      "id": idLines,
    });
    final response = await put(Uri.parse(url),
      headers: <String, String>{
        // 'authorization': basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: isiBody,
    );
    print(id);
    print(url);
    print("isi approve or reject : $isiBody");
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200){
      Get.offAll(HistoryNomorPP());
    }
    else{
      Get.dialog(
          Center(
            child: Text("${response.statusCode}"),
          )
      );
    }
  }

  void getUpdateData(
      BuildContext context, List<Lines> listDisc, int idEmp, int code) async {List<Lines> listDisc = <Lines>[];
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Future.delayed(Duration(milliseconds: 10));
  String? result = preferences.getString("result");
  var listStringResult = json.decode(result!);
  for (var objectResult in listStringResult) {
    var objects = Lines.fromJson(objectResult as Map<String, dynamic>);
    listDisc.add(objects);
  }
  preferences.setString("result", "");
  _approvePP(context, listDisc, widget.idEmp!, code);
  }

  DateTime convertDate(String date) {
    final dateTime = DateTime.parse(date ?? "");
    return dateTime;
  }

  Future<bool> _approvePP(
      BuildContext context, List<Lines> listDisc, int idEmp, int code) {
    Completer<bool> completer = Completer();
    Promosi.approveSalesOrder(listDisc, code).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HistoryNomorPP();
      }));
    }).catchError((onError) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'Error : ' + onError.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red[500],
          textColor: Colors.black,
          fontSize: ScreenUtil().setSp(16));
      completer.complete(false);
    });
    return completer.future;
  }

  void getSharedPreference() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    List<User> listUser = _userBox.values.map((e) => e as User).toList();
    SharedPreferences pref = await SharedPreferences.getInstance();
    Future.delayed(Duration(milliseconds: 10));
    setState(() {
      _user = listUser[0];
      code = pref.getInt("code")!;
    });
  }

  Future<bool> onBackPressLines() {
    Get.off(DashboardApprovalPP(initialIndexs: 1,));
    return Future.value(false);
  }
}
