class AbsentRequest {
  int? id;
  String? fileNameAbsent;
  String? longitude;
  String? lattitude;
  int? status;

  AbsentRequest(
      {this.id,
      this.fileNameAbsent,
      this.longitude,
      this.lattitude,
      this.status});

  AbsentRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileNameAbsent = json['fileNameAbsent'];
    longitude = json['longitude'];
    lattitude = json['lattitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileNameAbsent'] = this.fileNameAbsent;
    data['longitude'] = this.longitude;
    data['lattitude'] = this.lattitude;
    data['status'] = this.status;
    return data;
  }
}