class AbsentResponse {
  Data? data; // Make data nullable since it's being handled as such
  String message;
  bool error;

  AbsentResponse({this.data, required this.message, required this.error});

  AbsentResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'] != null ? Data.fromJson(json['data']) : null,
        message = json['message'],
        error = json['error'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  int? id;
  String? idSales;
  String? dateAbsent;
  String? timeCheckIn;
  String? timeCheckOut;
  String? locationCheckIn;
  String? locationCheckOut;
  String? fileNameCheckIn;
  String? fileNameCheckOut;

  Data(
      {this.id,
      this.idSales,
      this.dateAbsent,
      this.timeCheckIn,
      this.timeCheckOut,
      this.locationCheckIn,
      this.locationCheckOut,
      this.fileNameCheckIn,
      this.fileNameCheckOut});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idSales = json['idSales'];
    dateAbsent = json['dateAbsent'];
    timeCheckIn = json['timeCheckIn'];
    timeCheckOut = json['timeCheckOut'];
    locationCheckIn = json['locationCheckIn'];
    locationCheckOut = json['locationCheckOut'];
    fileNameCheckIn = json['fileNameCheckIn'];
    fileNameCheckOut = json['fileNameCheckOut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idSales'] = this.idSales;
    data['dateAbsent'] = this.dateAbsent;
    data['timeCheckIn'] = this.timeCheckIn;
    data['timeCheckOut'] = this.timeCheckOut;
    data['locationCheckIn'] = this.locationCheckIn;
    data['locationCheckOut'] = this.locationCheckOut;
    data['fileNameCheckIn'] = this.fileNameCheckIn;
    data['fileNameCheckOut'] = this.fileNameCheckOut;
    return data;
  }
}