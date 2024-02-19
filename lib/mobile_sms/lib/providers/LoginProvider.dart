import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/DashboardPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginProvider with ChangeNotifier {
  LoginProvider();
  late Box _userBox;
  late SharedPreferences preferences;
  String _message = "";
  late int _status;

  Future<void> setMessage(
      String username, String password, BuildContext context, int code) async {
    _userBox = await Hive.openBox('users');
    preferences = await SharedPreferences.getInstance();
    User.getUsers(username, password, code).then((value) {
      print("valuecode: ${value.code}");
      // User.getUserNOTPassword(username, code)
      _status = value.code!;
      if (value.code != 200) {
        print("statuscodeLoginProvider: $_status");
        print("ini message status code: $_status");
        _message = value.message!;
        Navigator.pop(context);
      } else {
        setBoxLogin(value, code);
        Get.offAll(DashboardPage());
      }
    }).catchError((onError) {
      _message = onError.toString();
    });
    notifyListeners();
  }

  setBoxLogin(User value, int code) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('ddMMyyyy');
    final String dateLogin = formatter.format(now);
    Future.delayed(Duration(milliseconds: 20));
    _userBox.add(value);
    Future.delayed(Duration(milliseconds: 20));
    preferences.setInt("code", code);
    preferences.setString("date", dateLogin);
    preferences.setInt("flag", 1);
    preferences.setString("result", "");
  }

  String get getMessage => _message;
  int get getStatus => _status;
}
