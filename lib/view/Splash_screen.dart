import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_scs/view/login/LoginView.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? idSales;
  String? flag;
  String? dateLoginSession;
  String? dateLogin;
  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    checkLogin();
  }

  _startSplashScreen() async {
    var _duration = Duration(seconds: 5);
    return Timer(_duration, _checkPageRoute());
  }

  _checkPageRoute() {
    if (flag == '1') {
      if (dateLogin == dateLoginSession) {
        _navigationPage(MainMenuView());
      } else {
        _navigationPage(LoginView());
      }
    } else {
      _navigationPage(LoginView());
    }
  }

  _navigationPage(var pageRoute) {
    print(pageRoute);
    SchedulerBinding.instance.addPostFrameCallback((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return pageRoute;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlueDark,
      body: Center(
        child: Text(
          'PRAKEN POS',
          style: TextStyle(color: colorAccent, fontSize: 35),
        ),
      ),
    );
  }

  getSharedPrefs()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    setState(() {
      idSales = (prefs.getString("idSales"));
      flag = (prefs.getString("flag"));
      dateLoginSession = (prefs.getString("dateLogin"));
    });
  }

  void checkLogin() async {
    try{
      setState(() {
        idSales == null?"0":idSales;
        print("ini cek idsales: $idSales");
        flag == null?"0":flag;
        dateLoginSession == null?"0":dateLoginSession;
        dateLogin = DateFormat("ddMMMyyyy").format(DateTime.now());
      });
      _startSplashScreen();
    }catch(exp) {
      print("Error splash : $exp");
    }

  }
}
