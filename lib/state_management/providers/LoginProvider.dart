import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  LoginProvider();

  String _message = "";
  String token = "";

  void setMessage(String messageError) {
    _message = messageError;
    notifyListeners();
  }

  String get getMessage => _message;
}
