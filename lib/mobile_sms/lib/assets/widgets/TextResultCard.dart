import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextResultCard extends StatelessWidget {
  String title, value;
  BuildContext context;
  TextResultCard({required this.title, required this.value, required this.context});

  @override
  Widget build(BuildContext context2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(ScreenUtil().setWidth(3)),
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            title??"",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: ScreenUtil().setSp(15),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(4)),
            child: Text(
              "$value",
              style: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        )
      ],
    );
  }
}
