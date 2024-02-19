import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';

class WidgetStateNoData extends StatelessWidget {
  final String message;
  WidgetStateNoData({required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   height: 200,
          //   child: SvgPicture.asset(
          //     'lib/assets/icons/state/ic_no_data.svg'
          //   ),
          // ),
          // SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorBlueDark, fontSize: 35),
          ),
        ],
      ),
    );
  }
}
