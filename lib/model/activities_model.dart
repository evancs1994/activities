class ActivityModel {
  int id;
  String activityType;
  String institution;
  DateTime when;
  String objective;
  String remarks;
  String result;
  bool status;

  ActivityModel(
      {this.id,
      this.activityType,
      this.institution,
      this.when,
      this.objective,
      this.remarks,
      this.result,
      this.status});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
        id: int.parse(json['id']),
        activityType: json['activityType'],
        institution: json['institution'],
        when: DateTime.parse(json['when']),
        objective: json['objective'],
        remarks: json['remarks'],
        result: json['result'],
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'activityType': activityType,
        'institution': institution,
        'when': when.toString(),
        'objective': objective,
        'remarks': remarks,
        'result': result,
        'status': status ?? false
      };
}
