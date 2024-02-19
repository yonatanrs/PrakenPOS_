import 'package:dio/dio.dart';
import 'package:flutter_scs/models/absent/AbsentRequest.dart';
import 'package:flutter_scs/models/absent/AbsentResponse.dart';
import 'package:flutter_scs/models/ApiConstant.dart';

class AbsentServices {
  static Future<AbsentResponse> getAbsent(String idSales) async {
    String url = ApiConstant().urlApi + "api/Absent?idSales=" + idSales;
    var dio = Dio();
    final response = await dio.get(
      url,
      options: Options(
        receiveDataWhenStatusError: true,
        receiveTimeout: 2000,
        sendTimeout: 2000,
      ),
    );
    var objects = AbsentResponse.fromJson(response.data);
    return objects;
  }

  static Future<AbsentResponse> processAbsent(AbsentRequest data) async {
    String url = ApiConstant().urlApi + "api/Absent";
    var dio = Dio();
    Response response = await dio.post(url, data: data);
    var jsonObject = response.data;
    var objects = AbsentResponse.fromJson(jsonObject as Map<String, dynamic>);
    return objects;
  }
}
