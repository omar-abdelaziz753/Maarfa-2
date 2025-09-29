class NotificationModel {
  NotificationModel({
    this.id,
    this.title,
    this.text,
    this.type,
    this.objectId,
    this.createdAt,
  });

  String? id;
  String? title;
  String? text;
  String? type;
  dynamic objectId;
  String? createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        type: json["type"],
        objectId: json["object_id"],
        createdAt: json["created_at"],
      );
}
