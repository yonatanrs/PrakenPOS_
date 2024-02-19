import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_scs/models/ApiConstant.dart';
import 'package:flutter_scs/models/upload/UploadFileResponse.dart';

class UploadService {
  static Future<UploadFileResponse> uploadFile(File file, int status) async {
    Dio dio = new Dio();
    FormData formData = FormData.fromMap({
      "attachmentName": await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last)
    });
    var response = await dio.post(
        ApiConstant().urlApi + "api/upload?status=" + status.toString(),
        data: formData);
    var jsonObject = response.data;
    var objects = UploadFileResponse.fromJson(jsonObject as Map<String, dynamic>);
    return objects;
  }
}
