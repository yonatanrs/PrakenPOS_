import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:dio/dio.dart';

class Segment {
  int? id;
  String? nameSegment;

  Segment({this.id, this.nameSegment});

  Segment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameSegment = json['nameSegment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameSegment'] = this.nameSegment;
    return data;
  }

  static Future<List<Segment>?> getSegment() async {
    String url = ApiConstant().urlApi + "api/segment";
    var dio = Dio();

    List<Segment> models = [];
    try {
      Response response = await dio.get(url);
      var jsonObject = response.data;
      if (jsonObject != null) {
        for (var product in jsonObject) {
          var objects = Segment.fromJson(product as Map<String, dynamic>);
          models.add(objects);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print('Error Segment : ${e.error}');
    }
    return models;
  }
}
