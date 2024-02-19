import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';

class WidgetStateLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: 200,
          //   child: SvgPicture.asset(
          //     'lib/assets/icons/state/ic_loading.svg',
          //   ),
          // ),
          // SizedBox(height: 10),
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            'Loading',
            textAlign: TextAlign.center,
            style: TextStyle(color: colorBlueDark, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
