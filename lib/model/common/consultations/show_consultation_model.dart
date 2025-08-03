// import 'package:my_academy/models/common/consultations/consultations_model.dart';
// import 'package:my_academy/models/common/time/time_model.dart';
// import '../provider/provider_model.dart';
//
// class ShowConsultationModel {
//   ShowConsultationModel({
//     this.id,
//     this.hourPrice,
//     this.description,
//     this.consultationField,
//     this.times,
//     this.subscriptions,
//     this.provider,
//   });
//
//   int? id;
//   int? hourPrice;
//   String? description;
//   ConsultationsModel? consultationField;
//   List<Time>? times;
//   int? subscriptions;
//   Provider? provider;
//
//   factory ShowConsultationModel.fromJson(Map<String, dynamic> json) => ShowConsultationModel(
//     id: json["id"],
//     hourPrice: json["hour_price"],
//     description: json["description"],
//     consultationField: ConsultationsModel.fromJson(json["consultation_field"]),
//     times: List<Time>.from(json["times"].map((x) => Time.fromJson(x))),
//     subscriptions: json["subscriptions"],
//     provider: Provider.fromJson(json["provider"]),
//   );
// }