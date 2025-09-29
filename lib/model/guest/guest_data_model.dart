// class GuestDataModel {
//   bool? status;
//   String? message;
//   Data? data;
//
//   GuestDataModel({this.status, this.message, this.data});
//
//   GuestDataModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   bool? isGuestMode;
//   String? guestToken;
//
//   Data({this.isGuestMode, this.guestToken});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     isGuestMode = json['is-guest-mode'];
//     guestToken = json['guest-token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['is-guest-mode'] = isGuestMode;
//     data['guest-token'] = guestToken;
//     return data;
//   }
// }
