import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardMainMenuAdapter.dart';
import 'package:flutter_scs/adapters/ToastCustom.dart';
import 'package:flutter_scs/assets/constant.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Employee.dart';
import 'package:flutter_scs/models/absent/AbsentRequest.dart';
import 'package:flutter_scs/models/absent/AbsentResponse.dart';
import 'package:flutter_scs/state_management/getx/AbsentController.dart';
import 'package:flutter_scs/state_management/getx/ReportSalesController.dart';
import 'package:flutter_scs/view/ListCustomerView.dart';
import 'package:flutter_scs/view/login/LoginView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:location_permissions/location_permissions.dart';

import 'AbsentView.dart';

class MainMenuView extends StatefulWidget {
  @override
  _MainMenuViewState createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  var absentController = Get.put(AbsentController());
  var reportSalesController = Get.put(ReportSalesController());

  String? idSales;
  var statusMocking = true;
  AbsentResponse? dataAbsent;
  var noConnection = false;

  String? role;
  String canvas = "canvas";
  String regular = "regular";

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    requestLocationPermission();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // statusMocking = await TrustLocation.isMockLocation;
    var idSales = preferences.getString("idSales");
    print("id Sales :: $idSales");
    if (idSales == null) {
      Navigator.pushReplacement(context, _route(0));
    } else {
      reportSalesController.getReportSales(idSales);
      absentController.getAbsent(idSales);
      // }
    }
  }

  void requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(BoxConstraints(
    //   maxWidth: MediaQuery.of(context).size.width,
    //   maxHeight: MediaQuery.of(context).size.height,
    // ));

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () => _showAlertDialogLogOut(),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colorBlueDark,
            automaticallyImplyLeading: false,
            title: Text(
              'Beranda',
              style: textHeaderView,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.home),
                color: colorAccent,
                onPressed: () => _showAlertDialogLogOut(),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            heroTag: UniqueKey(),
            key: UniqueKey(),
            onPressed: () {
              // Navigator.pushReplacement(context, _route(1));
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text('Choose Type of Visit'),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: Text("Canvas",style: TextStyle(color: Colors.white)),
                                onPressed: () async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("getRole", "Canvas");
                                print("Ini canvas");
                                Navigator.pushReplacement(context, _route(1));

                                }),
                            ElevatedButton(
                                child: Text("Regular",style: TextStyle(color: Colors.white),),
                                onPressed: () async{
                                  print("Ini regular");
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("getRole", "Regular");
                                  Navigator.pushReplacement(context, _route(1));
                                }),
                          ],
                        ),
                      ));
            },
            backgroundColor: colorNetral,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: colorBlueDark)),
            icon: SvgPicture.asset(
              'lib/assets/icons/Trolley.svg',
              color: colorBlueDark,
            ),
            elevation: 5.0,
            label: Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(12)),
              child: Text(
                'MULAI TRANSAKSI',
                style: TextStyle(
                    color: colorBlueDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                color: colorBlueDark,
                height: MediaQuery.of(context).size.height / 5,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(90),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(
                                  color: colorBlueSky,
                                  style: BorderStyle.solid,
                                  width: 1.5)),
                          child: reportSalesBox()),
                      absentBox(),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Get.delete<SetPromoPresenter>();
                      //         Get.to(SetPromoPage());
                      //         // Get.to(SetPromoMain());
                      //       },
                      //       child: Container(
                      //         height: 130,
                      //         width: 126,
                      //         child: Card(
                      //           shadowColor: colorAccent,
                      //           elevation: 5,
                      //           color: colorBlueDark,
                      //           child: Center(
                      //             child: Wrap(
                      //               children: <Widget>[
                      //                 Column(
                      //                   children: <Widget>[
                      //                     Container(
                      //                       margin: EdgeInsets.symmetric(
                      //                           vertical: 10),
                      //                       child: Icon(
                      //                         Icons.create,
                      //                         color: colorNetral,
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       "Set Promo",
                      //                       textAlign: TextAlign.center,
                      //                       style: textButtonMainMenu,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.delete<SetPromoPresenter>();
                      //         Get.to(ExhibitionPage());
                      //         // Get.to(SetPromoMain());
                      //       },
                      //       child: Container(
                      //         height: 130,
                      //         width: 126,
                      //         child: Card(
                      //           shadowColor: colorAccent,
                      //           elevation: 5,
                      //           color: colorBlueDark,
                      //           child: Center(
                      //             child: Wrap(
                      //               children: <Widget>[
                      //                 Column(
                      //                   children: <Widget>[
                      //                     Container(
                      //                       margin: EdgeInsets.symmetric(
                      //                           vertical: 10),
                      //                       child: Icon(
                      //                         Icons.event_available,
                      //                         color: colorNetral,
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       "Exhibition",
                      //                       textAlign: TextAlign.center,
                      //                       style: textButtonMainMenu,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.to(ApprovalPromoPage());
                      //       },
                      //       child: Container(
                      //         height: 130,
                      //         width: 126,
                      //         child: Card(
                      //           shadowColor: colorAccent,
                      //           elevation: 5,
                      //           color: colorBlueDark,
                      //           child: Center(
                      //             child: Wrap(
                      //               children: <Widget>[
                      //                 Column(
                      //                   children: <Widget>[
                      //                     Container(
                      //                       margin: EdgeInsets.symmetric(
                      //                           vertical: 10),
                      //                       child: Icon(
                      //                         Icons.approval,
                      //                         color: colorNetral,
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       "Approval\nPromo",
                      //                       textAlign: TextAlign.center,
                      //                       style: textButtonMainMenu,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: listButton
                              .map((item) => CardMainMenu(
                                    title: item['title'],
                                    nameIcon: item['image'],
                                    index: item['index'],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget reportSalesBox() {
    if (noConnection) {
      return Center(child: Text('No Connection'));
    } else {
      return reportSalesController.obx(
          (state) => Column(
                children: <Widget>[
                  Container(
                    child: Text(
                      state!.description!,
                      style: textChildCard,
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            state.date!,
                            style: textChildCard,
                            textAlign: TextAlign.left,
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          state.amount ?? '0',
                          style: textChildCard,
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ],
              ), onError: (value) {
        return Center(
            child: Column(
          children: [
            TextButton(
                onPressed: () {
                  reloadReportSales();
                },
                style: TextButton.styleFrom(backgroundColor: colorBlueDark),
                child: Text(
                  'Reload',
                  style: TextStyle(color: colorNetral),
                )),
          ],
        ));
      });
    }
  }

  Widget absentBox() {
    if (noConnection) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: colorBlueSky)),
          child: Text('No Connection'));
    } else {
      return absentController.obx(
          (state) => Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: colorBlueSky)),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    Text('Your Location'),
                    Text(
                        '${state!.currentPosition!.latitude}; ${state.currentPosition!.longitude}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text("Clock In"), Text("Clock Out")],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(state.absentResponse == null
                            ? ''
                            : state.absentResponse!.data!.timeCheckIn!),
                        Text(state.absentResponse == null
                            ? ''
                            : state.absentResponse!.data!.timeCheckOut!)
                      ],
                    ),
                    statusMocking == true
                        ? Text(
                            'Fake GPS sedang aktif. Silahkan matikan dahulu agar bisa absen')
                        : state.absentResponse!.data!.timeCheckIn == '--:--'
                            ? TextButton(
                                onPressed: () => absent(
                                    1,
                                    state.idSales!,
                                    state.currentPosition!,
                                    state.absentResponse!),
                                style: TextButton.styleFrom(
                                    backgroundColor: colorBlueDark),
                                child: Text(
                                  'Check In',
                                  style: TextStyle(color: colorNetral),
                                ))
                            : state.absentResponse!.data!.timeCheckOut! == '--:--'
                                ? TextButton(
                                    onPressed: () => absent(
                                        2,
                                        state.idSales!,
                                        state.currentPosition!,
                                        state.absentResponse!),
                                    style: TextButton.styleFrom(
                                        backgroundColor: colorBlueDark),
                                    child: Text(
                                      'Check Out',
                                      style: TextStyle(color: colorNetral),
                                    ))
                                : SizedBox(height: 0)
                  ]))), onError: (value) {
        return Center(
            child: Column(
          children: [
            // Text(state.message),
            TextButton(
                onPressed: () {
                  reloadAbsent();
                },
                style: TextButton.styleFrom(backgroundColor: colorBlueDark),
                child: Text(
                  'Reload',
                  style: TextStyle(color: colorNetral),
                )),
          ],
        ));
      });
    }
  }

  void reloadAbsent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (idSales == null) {
      idSales = preferences.getString("idSales");
    }
    absentController.getAbsent(idSales!);
  }

  void reloadReportSales() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (idSales == null) {
      idSales = preferences.getString("idSales");
    }
    reportSalesController.getReportSales(idSales!);
  }

  void absent(int status, String idSales, Position currentPosition,
      AbsentResponse dataAbsent) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int code =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AbsentView(
          idSales: idSales,
          data: AbsentRequest(
              id: dataAbsent.data?.id,
              lattitude: currentPosition.latitude.toString(),
              longitude: currentPosition.longitude.toString(),
              status: status));
    }));
    if (code == 1) {
      absentController.getAbsent(idSales);
    }
  }

  Future<bool> _onBackPress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idSales = preferences.getString("username");
    print("Id Sales Log out : $idSales");
    Employee.logOut(idSales!).then((value) async {
      if (value == "1") {
        preferences.setString("flag", "0");
        preferences.setString("idSales", "0");
        Box _productBox = await Hive.openBox("products");
        Box _customerBox = await Hive.openBox("customers");
        Box _priceBox = await Hive.openBox("prices");

        await _productBox.deleteFromDisk();
        await _customerBox.deleteFromDisk();
        await _priceBox.deleteFromDisk();

        Navigator.pushReplacement(context, _route(0));
      } else {
        var result = value.split('_');
        ToastCustom().FlutterToast(result[0], colorError, colorFontError);
        // Navigator.pop(context);
      }
    });
    return true;
  }

  Future<bool> _showAlertDialogLogOut() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Informasi !!!'),
            content: Text(
              'Yakin Anda ingin keluar ?',
              style: TextStyle(fontSize: 12, color: colorBlueDark),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tidak')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onBackPress();
                  },
                  child: Text('Ya'))
            ],
          );
        });
    return true;
  }

  Route _route(int condition) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          condition == 0 ? LoginView() : ListCustomerView(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
