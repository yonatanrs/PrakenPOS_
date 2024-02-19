import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/assets/global.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/mobile_sms/lib/providers/LoginProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with WidgetsBindingObserver {
  List<String> _dropdownUrl = [];
  User models = new User();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey keyCategory = GlobalKey();
  bool _obscureText = true;
  late String _selectedUrl;
  late int code;
  List _listUrl = ["Server Main", "Server 1", "Server 2"];

  deleteHistorySharedPrefs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // deleteHistorySharedPrefs();
    _selectedUrl = _listUrl[1];
    code = 1;
    autoLogin();
  }

  Future<Map<String, String>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return {'username': username!, 'password': password!};
  }

  Future<void> autoLogin() async {
    Map<String, String> credentials = await getCredentials();
    if (credentials['username'] != null && credentials['password'] != null) {
      _username.text = credentials['username']!;
      _password.text = credentials['password']!;
      login(_username.text, _password.text, context);
    }
  }

  void login(String username, String password, BuildContext context) {
    if (code == null) {
      Fluttertoast.showToast(
          msg: 'Tolong pilih server terlebih dahulu.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: colorWarning,
          textColor: colorPrimary,
          fontSize: ScreenUtil().setSp(16));
    } else {
      Text("Loading");
      Provider.of<LoginProvider>(context, listen: false).setMessage(username, password, context, code).then((_) {
        int statusCode = Provider.of<LoginProvider>(context, listen: false).getStatus;
        if (statusCode == 200 && _rememberMe) {
          saveCredentials(username, password);
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        StreamProvider<int>(
          initialData: 0,
          create: (ctx)=> Stream.periodic(Duration(milliseconds: 1000), (i) => i),
        ),
        ChangeNotifierProvider<LoginProvider>.value(value: LoginProvider())
      ],
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            color: colorAccent,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Sales & Marketing System Mobile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorPrimary,
                              fontSize: ScreenUtil().setSp(30),
                              fontFamily: 'Lobster'),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(20.0),
                ),
                _buildLoginForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _rememberMe = false; // Add this line

  Future<void> saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }


  Container _buildLoginForm(BuildContext context) {
    _fieldFocusChange(
        BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }

    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(reverse: true),
            child: Container(
              height: ScreenUtil().setHeight(400),
              padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(90))),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, insert your Username';
                          }
                          return null;
                        },
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        focusNode: _usernameFocus,
                        onFieldSubmitted: (term) {
                          _fieldFocusChange(
                              context, _usernameFocus, _passwordFocus);
                        },
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            color: Theme.of(context).primaryColorDark),
                        decoration: InputDecoration(
                            hintText: 'Insert your username AX',
                            labelText: 'Username*',
                            errorStyle: TextStyle(
                                color: colorError,
                                fontSize: ScreenUtil().setSp(13)),
                            hintStyle: TextStyle(
                                color: colorAccent,
                                fontSize: ScreenUtil().setSp(15)),
                            labelStyle: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: ScreenUtil().setSp(17)),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person_pin,
                              color: Theme.of(context).primaryColorDark,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setHeight(10)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, insert your Password';
                          }
                          return null;
                        },
                        obscureText: _obscureText,
                        controller: _password,
                        textInputAction: TextInputAction.done,
                        focusNode: _passwordFocus,
                        onFieldSubmitted: (term) {
                          _passwordFocus.unfocus();
                        },
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: ScreenUtil().setSp(15)),
                        decoration: InputDecoration(
                          hintText: 'Insert your password',
                          labelText: 'Password*',
                          errorStyle: TextStyle(
                              color: colorError,
                              fontSize: ScreenUtil().setSp(13)),
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: ScreenUtil().setSp(15)),
                          labelStyle: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: ScreenUtil().setSp(17)),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          suffixIcon: new GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: new Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        )),
                  ),
                  Container(
                    child: Divider(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(10)),
                  ),
                  Center(
                    child: Consumer<LoginProvider>(
                        builder: (context, message, _) => Container(
                              margin: EdgeInsets.all(
                                  ScreenUtil().setHeight(10)),
                              child: Text(
                                message.getMessage.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).errorColor,
                                    fontSize: ScreenUtil().setSp(15)),
                              ),
                            )),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(5),
                  ),
                  CheckboxListTile(
                    title: Text("Remember me"),
                    value: _rememberMe,
                    onChanged: (newValue) async{
                      setState(() {
                        _rememberMe = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Container(
                    child: Text(
                        'Pilih Server Main. Jika lemot atau no connection silahkan pindah ke server 1 / server 2.'),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(10),
                        ScreenUtil().setWidth(5),
                        ScreenUtil().setWidth(5),
                        ScreenUtil().setWidth(5)),
                    child: DropdownButton(
                      hint: Text(' Server : Choose One '),
                      value: _selectedUrl,
                      items: _listUrl.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            List _list = Set.from(_listUrl).toList();
                            int idx = _list.indexOf(value);
                            _selectedUrl = value as String; // Cast to String as value is non-null
                            code = idx;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(430),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Consumer<LoginProvider>(
                  builder: (context, objectLogin, _) => ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_rememberMe) {
                          saveCredentials(_username.text, _password.text);
                        }
                        login(_username.text, _password.text, context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ScreenUtil().setWidth(40))),
                    ),
                    child: Container(
                        width: ScreenUtil().setWidth(90),
                        height: ScreenUtil().setWidth(30),
                        margin:
                            EdgeInsets.all(ScreenUtil().setWidth(10)),
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
