import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ApiConstant.dart';
part 'User.g.dart';

@HiveType(typeId: 0) // Unique typeId for Hive
class User {
  @HiveField(0)
  int id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String? password; // Nullable if it can be null
  @HiveField(3)
  String fullname;
  @HiveField(4)
  String level;
  @HiveField(5)
  String roles;
  @HiveField(6)
  String? approvalRoles; // Nullable
  @HiveField(7)
  String? brand; // Nullable
  @HiveField(8)
  String? custSegment; // Nullable
  @HiveField(9)
  String? businessUnit; // Nullable
  @HiveField(10)
  String? token; // Nullable
  @HiveField(11)
  String? message; // Nullable
  @HiveField(12)
  int? code; // Nullable
  @HiveField(13)
  User? user; // Nullable, and assuming it's supposed to be another User instance
  @HiveField(14)
  dynamic so; // Keep as dynamic if uncertain about the type

  User(
      {
        this.id = 0, // Default value
        this.username = '',
        this.password, // Nullable, no default value needed
        this.fullname = '',
        this.level = '',
        this.roles = '',
        this.approvalRoles, // Nullable
        this.brand, // Nullable
        this.custSegment, // Nullable
        this.businessUnit, // Nullable
        this.token, // Nullable
        this.message, // Nullable
        this.code, // Nullable
        this.user, // Nullable
        this.so, // Nullable or dynamic
      });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        username = json['username'] ?? '',
        password = json['password'],
        fullname = json['fullname'] ?? '',
        level = json['level'] ?? '',
        roles = json['roles'] ?? '',
        approvalRoles = json['approvalRoles'],
        brand = json['brand'],
        custSegment = json['custSegment'],
        businessUnit = json['businessUnit'],
        token = json['token'],
        message = json['message'],
        code = json['code'],
        user = json['user'] != null ? User.fromJson(json['user']) : null,
        so = json['so'];

  static Future<User> getUsers(String username, String password, int code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = ApiConstant(code).urlApi + "api/LoginSMS?playerId=${prefs.getString("idDevice")}";
    print("ini url login sms $url");

    dynamic dataLogin = {
      "username": username,
      "password": password
    };

    final apiResult = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataLogin),
    );

    print("apiResultLogin :${apiResult.statusCode}\n${apiResult.body}");

    if (apiResult.statusCode == 200) {
      print("ini api result login : ${apiResult.statusCode}");
      print("ini api result login : ${apiResult.body}");
      print("ini data login : $dataLogin");

      dynamic jsonObject = json.decode(apiResult.body);
      User _user = User.fromJson(jsonObject);

      prefs.setString("username", _user.username);
      prefs.setString("token", _user.token!); // Assuming token is non-nullable.
      prefs.setInt("userid", _user.id);
      prefs.setString("so", _user.so.toString());

      print("ini username login : ${_user.username}");
      print("ini userid : ${_user.id}");

      return _user;
    } else {
      // Handle error scenario, e.g., by throwing an exception
      throw Exception('Failed to login with status code: ${apiResult.statusCode}');
    }
  }


// static Future<User> getUsers(
  //     String username, String password, int code) async {
  //   Response apiResult;
  //   String url = ApiConstant(code).urlApi + "api/LoginSMS";
  //   print("ini url login $url");
  //
  //   try {
  //     var dio = Dio();
  //     dio.options.headers['content-type'] = 'application/json';
  //     dynamic dataLogin = {
  //       "username": username,
  //       "password": password
  //     },
  //     apiResult = await dio.post(url, data: dataLogin,).timeout(Duration(minutes: 5));
  //     print("ini api result login : ${apiResult.statusCode}");
  //     print("ini api result login : ${apiResult.body}");
  //     print("ini data login : $dataLogin");
  //   }
  //   on TimeoutException catch (_) {
  //     throw "Time out. Please reload.";
  //   } on SocketException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   } on HttpException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   } catch (_) {
  //     throw "Username and Password invalid.";
  //   }
  //
  //   dynamic jsonObject = apiResult.data;
  //   print("ini isi login $jsonObject");
  //   var data = jsonObject as Map<String, dynamic>;
  //   User _user = User.fromJson(data);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("username", _user.username);
  //   prefs.setString("token", _user.token);
  //   print("ini username login : ${_user.username}");
  //   return _user;
  // }

  // static Future<User> getUserNOTPassword(String username, int code) async {
  //   var apiResult;

  //   String url =
  //       ApiConstant(code).urlApi + "api/hujanlogin?username=" + username;
  //   try {
  //     apiResult = await http.get(url).timeout(Duration(minutes: 5));
  //   } on TimeoutException catch (_) {
  //     throw "Time out. Please reload.";
  //   } on HttpException catch (_) {
  //     throw "No Connection. Please connect to Internet.";
  //   }
  //   var jsonObject = json.decode(apiResult.body);
  //   var data = jsonObject as Map<String, dynamic>;
  //   return User.convertUser(data);
  // }
}
