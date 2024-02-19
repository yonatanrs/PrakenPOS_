import 'package:dio/dio.dart';
import 'package:flutter_scs/models/absent/AbsentResponse.dart';
import 'package:flutter_scs/services/AbsentServices.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AbsentController extends GetxController with StateMixin<AbsentModel> {
  void getAbsent(String idSales) async {
    change(null, status: RxStatus.loading());
    var position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          forceAndroidLocationManager: true);
    } catch (e) {
      print("Message :: ${e.toString()}");
    }

    try {
      var dataAbsent = await AbsentServices.getAbsent(idSales);
      if (dataAbsent == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(
            AbsentModel(
                absentResponse: dataAbsent,
                idSales: idSales,
                currentPosition: position),
            status: RxStatus.success());
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        change(null, status: RxStatus.error("No Connection"));
      } else if (e.type == DioErrorType.cancel) {
        change(null, status: RxStatus.error("No Connection"));
      } else {
        change(null, status: RxStatus.error("Error"));
      }
    }
  }
}

class AbsentModel {
  AbsentResponse? absentResponse;
  String? idSales;
  Position? currentPosition;
  AbsentModel({this.absentResponse, this.idSales, this.currentPosition});
}
