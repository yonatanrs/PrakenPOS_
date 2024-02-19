import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/mobile_sms/lib/view/Login.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/DashboardPage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'assets/global.dart';
import 'models/User.dart';
import 'view/HistoryNomorPP.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box _user;
  late String value;
  late int flag;

  Future<void> checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    if (token != null) {
      Get.offAll(DashboardPage()); // Navigate to DashboardPage without the ability to go back
    }
  }


  late String onesignalUserID;

  getOneSignal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    OneSignal.shared.setAppId("ffad8398-fdf5-4aef-a16b-a33696f48630");
    OneSignal.shared.getDeviceState().then((deviceState) {
      onesignalUserID = deviceState!.userId!;
      print("playerID ${onesignalUserID}");
      setState(() {
        prefs.setString("getPlayerID", onesignalUserID);
      });
      print("OneSignal: device state: ${deviceState.jsonRepresentation()}");
    }
    );
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print(
          "OneSignal: subscription changed:: ${changes.jsonRepresentation()}");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
            (OSNotificationReceivedEvent event) {
          event.complete(event.notification);
        });
    OneSignal.shared.setNotificationOpenedHandler((
        OSNotificationOpenedResult result) {});
  }

  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    registeredAdapter();
    // resetSharedPrefs();
    Future.delayed(Duration(seconds: 1),(){
      getOneSignal();
    });
    checkAutoLogin();
  }

  resetSharedPrefs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:()=> GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginView()/*DashboardPage()*//*HistoryNomorPP()*/,
        // HistoryNomorPP(),
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColorDark: colorPrimary,
          primaryColor: colorSecondary,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: colorAccent, // Used where accentColor was previously used
          ),
          errorColor: colorError,
          dialogTheme: DialogTheme(
              backgroundColor: colorNetral,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: colorAccent))),
        ),
        builder:  (context, widget) {
          // ScreenUtil.init();
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          );
        },
      ),
    );
  }

  void registeredAdapter() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('ddMMyyyy');
    final String dateCurrent = formatter.format(now);

    final appDocument = await getApplicationDocumentsDirectory();
    Hive.init(appDocument.path);
    Hive.registerAdapter(UserAdapter());
    Box userBox = await Hive.openBox('users');
    SharedPreferences pref = await SharedPreferences.getInstance();

    Future.delayed(Duration(milliseconds: 20));
    setState(() {
      flag = pref.getInt("flag")!;
      if(flag == null){
        pref.setInt("flag", 0);
      }

      value = pref.getString("date")!;
      if (value != dateCurrent) {
        pref.setInt("flag", 0);
        deleteBoxUser();
      }

      flag = pref.getInt("flag")!;
      _user = userBox;
    });
  }

  void deleteBoxUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    Future.delayed(Duration(milliseconds: 25));
    await _userBox.deleteFromDisk();

  }
}
