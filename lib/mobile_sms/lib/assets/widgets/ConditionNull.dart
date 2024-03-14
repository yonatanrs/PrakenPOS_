import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConditionNull extends StatelessWidget {
  String message;
  ConditionNull({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          message??"",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.error,
              fontSize: ScreenUtil().setSp(25)),
        ),
      ),
    );
  }
}
