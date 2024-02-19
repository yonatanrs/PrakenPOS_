import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlueDark,
        title: Text(
          "My Profile",
          style: textHeaderView,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
            margin: EdgeInsets.all(ScreenUtil().setHeight(10)),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 2.0,
                ),
              ],
              color: Colors.white,
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text('Nama : Budi Soo Hoon',
                      style: textHeaderCard),
                  Text('Nama : Budi Soo Hoon',
                      style: textHeaderCard),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
