import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../view/MainMenuView.dart';

class Employee {
  int? id;
  String? employeeId;
  String? name;
  String? username;
  String? password;
  String? salesOffice;
  String? businessUnit;
  String? segment;
  int? flag;
  String? message;
  String? token;

  Employee(
      {this.id,
      this.employeeId,
      this.name,
      this.username,
      this.password,
      this.salesOffice,
      this.businessUnit,
      this.segment,
      this.flag});
  factory Employee.convertUser(Map<String, dynamic> object) {
    return Employee(
        id: object['id'],
        employeeId: object['employeeId'],
        name: object['name'],
        username: object['username'],
        password: object['password'],
        salesOffice: object['salesOffice'],
        businessUnit: object['businessUnit'],
        segment: object['segment'],
        flag: object['flag']);
  }

  Employee.fromLoginJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toLoginJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }


  static Future<void> setBoxLogin(User value, int code) async {
    Box _userBox = await Hive.openBox('users');
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('ddMMyyyy');
    final String dateLogin = formatter.format(now);

    _userBox.add(value);
    preferences.setInt("code", code);
    preferences.setString("date", dateLogin);
    preferences.setInt("flag", 1);
    preferences.setString("result", "");
  }

  static Future<Employee?> getEmployee(String username, String password, BuildContext context) async {
    Employee employee = Employee();
    String url = ApiConstant().urlApi + "api/Login";
    var bodyLogin = jsonEncode({"username": username, "password": password});
    try {
      final apiResult = await http.post(
        Uri.parse(url),
        body: bodyLogin,
        headers: {'content-type': 'application/json'},
      );
      var jsonObject = json.decode(apiResult.body);
      employee = Employee.fromLoginJson(jsonObject);
      print("url login : $url");
      print("body login : $bodyLogin");
      print("status code login : ${apiResult.statusCode}");
      if (apiResult.statusCode == 200) {
        Box _userBox;
        SharedPreferences preferences;
        String? _message = "";
        int? _status;
        preferences = await SharedPreferences.getInstance();
        _userBox = await Hive.openBox('users');
        User.getUsers(username, password, code!).then((value) {
          print("valuecode: ${value.code}");
          // User.getUserNOTPassword(username, code)
          _status = value.code;
          if (value.code != 200) {
            print("statuscodeLoginProvider: $_status");
            print("ini message status code: $_status");
            _message = value.message;
          } else {
            Get.offAll(MainMenuView());
            setBoxLogin(value, code!);
          }
        }).catchError((onError) {
          _message = onError.toString();
        });
        return employee;
      } else {
        print("Login failed. Status ${apiResult.statusCode}");
        // You can handle the failure case here, such as displaying an error message.
      }
    } on TimeoutException catch (_) {
      employee.message = "Time out. Please reload._0";
    } on SocketException catch (_) {
      employee.message = "No Connection. Please connect to Internet._0";
    } on HttpException catch (_) {
      employee.message = "No Connection. Please connect to Internet._0";
    } catch (_) {
      employee.message = "No Connection. Please connect to Internet._0";
    }

    return null; // Return null or handle the failure case accordingly.
  }

  static Future<String> logOut(String username) async {
    String url = ApiConstant().urlApi + "api/Logout?username=" + username;
    var apiResult, data;
    try {
      apiResult = await http.post(
        Uri.parse(url),
        headers: {'content-type': 'application/json'},
      );
      final jsonObject = json.decode(apiResult.body);
      print("url logout : $url");
      print("json response : ${apiResult.body}");
      data = jsonObject as String;
    } on TimeoutException catch (_) {
      data = "Time out. Please reload._0";
    } on SocketException catch (_) {
      data = "No Connection. Please connect to Internet._0";
    } on HttpException catch (_) {
      data = "No Connection. Please connect to Internet._0";
    } catch (_) {
      data = "No Connection. Please connect to Internet._0";
    }
    return data;
  }
}
