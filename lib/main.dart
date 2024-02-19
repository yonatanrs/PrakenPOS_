import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/mobile_sms/lib/models/User.dart';
import 'package:flutter_scs/models/Cart.dart';
import 'package:flutter_scs/models/Customer.dart';
import 'package:flutter_scs/models/PriceDiscount.dart';
import 'package:flutter_scs/models/Product.dart';
import 'package:flutter_scs/view/Splash_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
    Hive.registerAdapter(UserAdapter());
    // Register other adapters similarly
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  MyApp();
}

class _MyAppState extends State<MyApp> {
  late String onesignalUserID;

  getOneSignal() async {
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    OneSignal.shared.setAppId(
      "d51e7b74-eebc-48e9-8af6-a2d1cbd58e33",
    );
    OneSignal.shared.getDeviceState().then((value) async {
      onesignalUserID = value!.userId!;
      print("User Id One Signal :: $onesignalUserID");
      setState(() {
        preferences.setString("idDevice", onesignalUserID);
      });
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print(
          "OneSignal: subscription changed:: ${changes.jsonRepresentation()}");
    });
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied");
      }
    }
  }

  removeSharedPrefs()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void initState() {
    super.initState();
//    WidgetsFlutterBinding.ensureInitialized();
    getOneSignal();
    // getCurrentLocation();
    // checkLogin();
    deleteBoxUser();
    registeredAdapter();
    // removeSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:()=> GetMaterialApp(
        home: SplashScreen(),
        theme: ThemeData(
          fontFamily: 'Lato',
          dialogTheme: DialogTheme(
              backgroundColor: colorNetral,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: colorAccent))),
        ),
      ),
    );
  }

  late Box _user;
  void registeredAdapter() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Initialize Hive only if it hasn't been initialized yet.
    if (!Hive.isBoxOpen('users')) {
      Hive.init(appDocumentDir.path);

      // Check and register UserAdapter.
      if (!Hive.isAdapterRegistered(UserAdapter().typeId)) {
        Hive.registerAdapter(UserAdapter());
      }

      // Check and register ProductAdapter.
      if (!Hive.isAdapterRegistered(ProductAdapter().typeId)) {
        Hive.registerAdapter(ProductAdapter());
      }

      // Check and register CustomerAdapter.
      if (!Hive.isAdapterRegistered(CustomerAdapter().typeId)) {
        Hive.registerAdapter(CustomerAdapter());
      }

      // Check and register PriceDiscountAdapter.
      if (!Hive.isAdapterRegistered(PriceDiscountAdapter().typeId)) {
        Hive.registerAdapter(PriceDiscountAdapter());
      }

      // Check and register CartAdapter.
      if (!Hive.isAdapterRegistered(CartAdapter().typeId)) {
        Hive.registerAdapter(CartAdapter());
      }
    }

    // Open the 'users' box if not already opened.
    if (!Hive.isBoxOpen('users')) {
      _user = await Hive.openBox('users');
    } else {
      _user = Hive.box('users');
    }
  }

  void deleteBoxUser() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Box _userBox = await Hive.openBox('users');
    Future.delayed(Duration(milliseconds: 25));
    await _userBox.deleteFromDisk();
  }
}
