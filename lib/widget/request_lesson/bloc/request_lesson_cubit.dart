// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:my_academy/service/network/dio/dio_service.dart';
// import 'package:my_academy/widget/request_lesson/data/models/coupon_response_model.dart';
//
// part 'request_lesson_state.dart';
//
// class RequestLessonCubit extends Cubit<RequestLessonState> {
//   RequestLessonCubit() : super(RequestLessonInitial());
//
//   CouponResponseDataModel? couponResponseDataModel;
//    dynamic finalP = 0;
//
//   Future<void> makeCouponRequest({
//     required String lessonId,
//     required String coupon,
//   }) async {
//     emit(MakeCouponLoadingState());
//     try {
//       final response = await DioService().post(
//         '/clients/request/coupons/apply',
//         body: {
//           "lesson_id": lessonId,
//           "coupon": coupon,
//         },
//       );
//       response.fold((error) {
//         print(error);
//         emit(MakeCouponErrorState());
//       }, (data) {
//         couponResponseDataModel = CouponResponseDataModel.fromJson(data);
//         finalP = couponResponseDataModel!.data!.finalPrice!;
//         emit(MakeCouponSuccessState(couponResponseDataModel: couponResponseDataModel!));
//       });
//     } catch (e) {
//       print(e);
//       emit(MakeCouponErrorState());
//     }
//   }
// }
