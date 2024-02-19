import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CheckCondition.dart';
import 'package:flutter_scs/state_management/providers/LoginProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/assets/widgets/AlertLoading.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/Employee.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io' show Platform, exit;

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FocusNode _usernameFocus = new FocusNode();
  final FocusNode _passwordFocus = new FocusNode();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _ipAddressController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  bool isExhibition = false;
  int codeEnpoint = 1;

  @override
  void initState() {
    super.initState();
    checkPermission();
    _loadRememberMeStatus();
  }

  Future<void> _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final box = GetStorage();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    bool exhibition = prefs.getBool("rememberMeExhibition") ?? false;

    setState(() {
      _rememberMe = rememberMe;
      _usernameController.text = username;
      _passwordController.text = password;
      isExhibition = exhibition;
      _ipAddressController.text = box.read("ipAddress")??"hrms.prb.co.id:8877";
    });
  }


  Future<void> _saveRememberMeStatus(bool rememberMe, String username, String password, bool isSetIP, String ipAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe);
    await prefs.setBool('rememberMeExhibition', isSetIP);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }


  Future<void> _clearRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('rememberMe');
    await prefs.remove('username');
    await prefs.remove('password');
  }

   checkPermission() async {
     await Geolocator.requestPermission();
    var status = await Geolocator.isLocationServiceEnabled();
    if (status == false) {
      await Geolocator.openLocationSettings();
    }
  }

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: _closeApp,
      child: ChangeNotifierProvider<LoginProvider>(
        create: (context) => LoginProvider(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3 -
                        ScreenUtil().setHeight(50),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(100)),
                      color: colorBlueDark,
                    ),
                    child: Center(
                      child: Text(
                        'PRAKEN POS',
                        style: textHeaderView,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(70)),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(25)),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    decoration: BoxDecoration(
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: colorBlueDark,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(90),
                        )),
                    child: TextFormField(
                      validator: (value) {
                        return CheckCondition().checkNull(value!);
                      },
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      focusNode: _usernameFocus,
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(
                            context, _usernameFocus, _passwordFocus);
                      },
                      style: textFieldForm,
                      decoration: InputDecoration(
                          hintText: 'Insert your username AX',
                          labelText: 'Username*',
                          labelStyle: textLabelForm,
                          hintStyle: textHintForm,
                          errorStyle: textError,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: colorAccent)),
                          icon: Icon(
                            Icons.person_outline,
                            color: colorBlueDark,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(25)),
                    margin: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    decoration: BoxDecoration(
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: colorBlueDark,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(90),
                        )),
                    child: Consumer<LoginProvider>(
                      builder: (context, objectLogin, _) => TextFormField(
                          validator: (value) {
                            return CheckCondition().checkNull(value!);
                          },
                          obscureText: _obscureText,
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (term) {
                            _passwordFocus.unfocus();
                            processLogin(
                                _formKey,
                                objectLogin,
                                context,
                                _usernameController.text,
                                _passwordController.text);
                          },
                          style: textFieldForm,
                          decoration: InputDecoration(
                            hintText: 'Insert your password',
                            labelText: 'Password*',
                            labelStyle: textLabelForm,
                            hintStyle: textHintForm,
                            errorStyle: textError,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: colorAccent)),
                            icon: Icon(
                              Icons.lock,
                              color: colorBlueDark,
                            ),
                            suffixIcon: new GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: new Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: colorBlueDark,
                              ),
                            ),
                          )),
                    ),
                  ),
                  Center(
                    child: Container(
                        margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
                        child: Consumer<LoginProvider>(
                          builder: (context, message, _) =>
                              message.getMessage == "1"
                                  ? Text('')
                                  : Text(
                                      message.getMessage.toString(),
                                      style: textError,
                                    ),
                        )),
                  ),
                  CheckboxListTile(
                      value: isExhibition,
                      title: Text("Exhibition"),
                      onChanged: (value)async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        final box = GetStorage();
                        setState(() {
                          isExhibition = !isExhibition;
                          if(isExhibition==true){
                            prefs.setInt("codeEnpoint", 0);
                            box.write("codeEnpoint", 0);
                          }else{
                            prefs.setInt("codeEnpoint", 1);
                            box.write("codeEnpoint", 1);
                          }
                        });
                      }
                  ),
                  isExhibition==true?Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              // height: 35, // Atur ketinggian Container sesuai kebutuhan Anda
                              child: TextFormField(
                                controller: _ipAddressController,
                                decoration: InputDecoration(
                                  labelText: "IP",
                                  contentPadding: EdgeInsets.zero, // Menghapus padding bawaan
                                  enabledBorder: UnderlineInputBorder( // Mengatur garis bawah saat tidak dalam keadaan fokus
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder( // Mengatur garis bawah saat dalam keadaan fokus
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                setState(() {
                                  final box = GetStorage();
                                  prefs.setString("ipAddress", _ipAddressController.text);
                                  box.write("ipAddress", _ipAddressController.text);
                                });
                              },
                              child: Text("Set IP"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ):SizedBox(),

                  SizedBox(height: 20,),
                  CheckboxListTile(
                    value: _rememberMe,
                    title: Text("Remember Me"),
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: colorBlueDark,
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: colorAccent,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(90),
                        )),
                    child: Consumer<LoginProvider>(
                      builder: (context, objectLogin, _) => TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              processLogin(
                                  _formKey,
                                  objectLogin,
                                  context,
                                  _usernameController.text,
                                  _passwordController.text);
                            });
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(40))),
                        ),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: textButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Text(
                    'v.0.1-dev',
                    style: textChildCard,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setPreference(String username, String flag, String idSales,
      String token, String dateLogin) async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("username", username);
      await preferences.setString("flag", flag);
      await preferences.setString("idSales", idSales);
      await preferences.setString("token", token);
      await preferences.setString("dateLogin", dateLogin);
    }catch(exp){
      print("Exception 1 : $exp");
    }
  }

  void getIdDevice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String deviceId;
    OneSignal.shared.setAppId("d51e7b74-eebc-48e9-8af6-a2d1cbd58e33",);
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });
    Future.delayed(Duration(seconds: 60));
    OneSignal.shared.getDeviceState().then((value) {
      deviceId = value!.userId!;
      preferences.setString("idDevice", deviceId);
    });
  }

  void getAllData(String token, String username) async {
    Box _productBox = await Hive.openBox("products");
    Box _customerBox = await Hive.openBox("customers");
    Box _priceBox = await Hive.openBox("prices");

    if (_productBox.length == 0) {
      Product.getAllProduct(token, username, 'X').then((value) {
        for (int a = 0; a < value.length; a++) {
          _productBox.add(value[a]);
        }
      });
    }
    if (_customerBox.length == 0) {
      Customer.getAllCustomer(token, username).then((value) {
        for (int a = 0; a < value.length; a++) {
          _customerBox.add(value[a]);
        }
      });
    }
    if (_priceBox.length == 0) {
      PriceDiscount.getAllPrice().then((value) {
        for (int a = 0; a < value.length; a++) {
          _priceBox.add(value[a]);
        }
      });
    }
  }

  processLogin(GlobalKey<FormState> formKey, LoginProvider objectLogin,
      BuildContext context, String username, String password) async{
    String username = _usernameController.text;
    String password = _passwordController.text;
    String ipAddress = _passwordController.text;
    if (_rememberMe) {
      await _saveRememberMeStatus(true, username, password, isExhibition, ipAddress);
    } else {
      await _clearRememberMeStatus();
    }
    AlertLoading().alertLoading(context);
    getIdDevice();
    Employee.getEmployee(username, password, context).then((value)async{
      List<String> result = value!.message!.split('_');
      String _message = result[0];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final box = GetStorage();
      prefs.setString("getIdEmp", result[2]);
      prefs.setString("idSales", result[2]);
      prefs.setString("getName", result[3]);
      prefs.setString("getWh", result[4]);
      box.write("getName", result[3]);
      if (result.length == 1) {
        Navigator.of(context).pop();
        objectLogin.setMessage(_message);
      } else {
        if (result[1] == '0') {
          Navigator.of(context).pop();
          objectLogin.setMessage(_message);
        } else {
          String _idSales = result[1];
          String dateLogin = DateFormat("ddMMMyyyy").format(DateTime.now());
          setPreference(username, _message, _idSales, value!.token!, dateLogin);
          getAllData(value.token!, username);
          if(value.token!=null){
            // Get.offAll(MainMenuView());
          }
        }
      }
    }).catchError((onError) {
      Navigator.of(context).pop();
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<bool> _closeApp() {
    exit(0);
  }
}
