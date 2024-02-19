class Lines {
  int? id;
  double? disc;
  String? fromDate;
  String? toDate;
  dynamic model;

  // Updated constructor
  Lines({this.id, this.disc, this.fromDate, this.toDate, this.model});

  Map<String, dynamic> toJsonDisc() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disc'] = this.disc;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    return data;
  }

  Map toJson() => {
    'id': id,
    'disc': disc,
    'fromDate': fromDate,
    'toDate': toDate
  };

  // Updated fromJson constructor
  Lines.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        disc = json['disc'].toDouble(),
        fromDate = json['fromDate'],
        toDate = json['toDate'];
}
