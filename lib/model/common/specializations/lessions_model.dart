class LessonModelPrice {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  List<LessonData>? data;

  LessonModelPrice(
      {this.success,
      this.errorCode,
      this.status,
      this.notificationsCount,
      this.messages,
      this.data});

  LessonModelPrice.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    if (json['data'] != null) {
      data = <LessonData>[];
      json['data'].forEach((v) {
        data!.add(LessonData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['errorCode'] = errorCode;
    data['status'] = status;
    data['notificationsCount'] = notificationsCount;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LessonData {
  String? key;
  String? value;

  LessonData({this.key, this.value});

  LessonData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
