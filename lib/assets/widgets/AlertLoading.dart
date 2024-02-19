import 'package:flutter/material.dart';

class AlertLoading {
  Future<void> alertLoading(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),SizedBox(height: 8,),Text("Loading")],),);
      },
    );
  }
}
