class GetAllBestTeacherDataModel {
  bool? success;
  int? errorCode;
  int? status;
  int? notificationsCount;
  String? messages;
  Dataaaa? data;

  GetAllBestTeacherDataModel(
      {this.success,
        this.errorCode,
        this.status,
        this.notificationsCount,
        this.messages,
        this.data});

  GetAllBestTeacherDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorCode = json['errorCode'];
    status = json['status'];
    notificationsCount = json['notificationsCount'];
    messages = json['messages'];
    data = json['data'] != null ? new Dataaaa.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['errorCode'] = this.errorCode;
    data['status'] = this.status;
    data['notificationsCount'] = this.notificationsCount;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Dataaaa {
  List<ProvidersMM>? providers;

  Dataaaa({this.providers});

  Dataaaa.fromJson(Map<String, dynamic> json) {
    if (json['providers'] != null) {
      providers = <ProvidersMM>[];
      json['providers'].forEach((v) {
        providers!.add(new ProvidersMM.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.providers != null) {
      data['providers'] = this.providers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProvidersMM {
  int? id;
  String? title;
  String? degree;
  String? firstName;
  String? lastName;
  String? specialization;
  int? rate;
  int? rateCount;
  String? imagePath;

  ProvidersMM(
      {this.id,
        this.title,
        this.degree,
        this.firstName,
        this.lastName,
        this.specialization,
        this.rate,
        this.rateCount,
        this.imagePath});

  ProvidersMM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    degree = json['degree'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    specialization = json['specialization'];
    rate = json['rate'];
    rateCount = json['rate_count'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['degree'] = this.degree;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['specialization'] = this.specialization;
    data['rate'] = this.rate;
    data['rate_count'] = this.rateCount;
    data['image_path'] = this.imagePath;
    return data;
  }
}