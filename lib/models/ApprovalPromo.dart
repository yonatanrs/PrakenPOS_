class ApprovalPromosi {
  int? id;
  String? name;
  dynamic status;
  dynamic createdBy;
  dynamic createdDateTime;
  dynamic lines;

  ApprovalPromosi(
      {this.id,
        this.name,
        this.status,
        this.createdBy,
        this.createdDateTime,
        this.lines});

  ApprovalPromosi.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    status = json['Status'];
    createdBy = json['CreatedBy'];
    createdDateTime = json['CreatedDateTime'];
    lines = json['Lines'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Status'] = this.status;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDateTime'] = this.createdDateTime;
    data['Lines'] = this.lines;
    return data;
  }
}
