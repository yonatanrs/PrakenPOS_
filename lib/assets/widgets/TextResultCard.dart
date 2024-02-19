import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';

class TextResultCard extends StatelessWidget {
  final String title, value;
  final BuildContext context;
  TextResultCard({required this.title, required this.value, required this.context});

  @override
  Widget build(BuildContext context2) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            title,
            style: TextStyle(
              color: colorBlueDark,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
            child: Text(
              value,
              style: TextStyle(
                  color: colorBlueDark,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(17)),
            ),
          ),
        )
      ],
    );
  }
}
