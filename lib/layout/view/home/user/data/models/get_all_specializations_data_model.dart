class GetAllSpecializationsDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  List<SpecializationData>? data;

  GetAllSpecializationsDataModel(
      {this.success,
        this.errorCode,
        this.status,
        this.notificationsCount,
        this.messages,
        this.data});

  GetAllSpecializationsDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    if (json['data'] != null) {
      data = <SpecializationData>[];
      json['data'].forEach((v) {
        data!.add(new SpecializationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['errorCode'] = this.errorCode;
    data['status'] = this.status;
    data['notificationsCount'] = this.notificationsCount;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SpecializationData {
  int? id;
  String? name;
  String? image;

  SpecializationData({this.id, this.name, this.image});

  SpecializationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}