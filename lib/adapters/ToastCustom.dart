import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastCustom {
  void FlutterToast(String message, Color color1, Color color2) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: color1,
        textColor: color2,
        fontSize: ScreenUtil().setSp(16));
  }
}
