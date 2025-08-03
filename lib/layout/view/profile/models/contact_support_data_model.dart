class ContactSupportDataModel {
  bool? success;
  String? staticMessage;
  List<QuestionData>? data;

  ContactSupportDataModel({this.success, this.staticMessage, this.data});

  ContactSupportDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    staticMessage = json['Static_Message'];
    if (json['data'] != null) {
      data = <QuestionData>[];
      json['data'].forEach((v) {
        data!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['Static_Message'] = this.staticMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionData {
  int? id;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;

  QuestionData({this.id, this.question, this.answer, this.createdAt, this.updatedAt});

  QuestionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
