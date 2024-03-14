import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? code;
String? ipAdress;

getFromSharedPrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final box = GetStorage();
  // code = prefs.getInt("codeEnpoint")??1;
  // ipAdress = prefs.getString("ipAddress")??"hrms.prb.co.id:8877";

  code = box.read("codeEnpoint")??1;
  ipAdress = box.read("ipAddress")??"api-scs.prb.co.id";
}

class ApiConstant {
  String urlApi = '';
  ApiConstant() {
    final box = GetStorage();
    code = box.read("codeEnpoint")??1;
    ipAdress = box.read("ipAddress")??"api-scs.prb.co.id";
    print("code : $code");
    print("ipAddress : $ipAdress");
    if (code == 0) {
      //domain utama
      urlApi = 'http://$ipAdress/';
    } else if (code == 1) {
      //jlm
      urlApi = 'http://api-scs.prb.co.id/'; //debuging1
      // urlApi = 'http://192.168.0.13:8897/'; //debuging2
      // urlApi = 'http://119.18.157.236:8878/'; //release
    }
  }
}


