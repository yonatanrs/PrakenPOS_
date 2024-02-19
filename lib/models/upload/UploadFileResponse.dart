class UploadFileResponse {
  String? fileName;
  bool? error;
  String? message;

  UploadFileResponse({this.fileName, this.error, this.message});

  UploadFileResponse.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}