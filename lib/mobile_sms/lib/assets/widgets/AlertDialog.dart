import 'package:flutter/material.dart';

class AlertLoading {
  Future<void> alertLoading(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Loading"),
        );
      },
    );
  }
}
