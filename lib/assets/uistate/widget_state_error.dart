import 'package:flutter/material.dart';
import '../style.dart';

class WidgetStateError extends StatelessWidget {
  final String message;

  final VoidCallback onPressed; // Change type to VoidCallback
  WidgetStateError({required this.message, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   height: 200,
          //   child: SvgPicture.asset(
          //     'lib/assets/icons/state/ic_error.svg',
          //   ),
          // ),
          // SizedBox(height: 10),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorBlueDark, fontSize: 35),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: colorBlueDark,
              ),
              onPressed: onPressed,
              child: Text(
                'Reload',
                style: TextStyle(fontSize: 20, color: colorAccent),
              ),
            ),
          )
        ],
      ),
    );
  }
}
