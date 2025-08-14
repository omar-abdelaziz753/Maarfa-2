part of 'pay_cubit.dart';

abstract class PayState {}

class PayInitial extends PayState {}

class PayLoading extends PayState {}

class PayLoaded extends PayState {
  dynamic data;
  PayLoaded({required this.data});
}

class PayError extends PayState {}

class PayLoadedState extends PayState {
  PayModel data;
  PayLoadedState({required this.data});
}

class PayErrorState extends PayState {}

class PostPayState extends PayState {}

class TypePayState extends PayState {}

class PaymentMethodLoadedState extends PayState {
  List<PaymentMethodModel> data;
  PaymentMethodLoadedState({required this.data});
}

class SetPaymentMethod extends PayState {}

class CourseCancelState extends PayState {}

class LessonCancelState extends PayState {}


final class MakeCouponLoadingState extends PayState {}

final class MakeCouponSuccessState extends PayState {
  final CouponResponseDataModel couponResponseDataModel;
  MakeCouponSuccessState({required this.couponResponseDataModel});
}

final class MakeCouponErrorState extends PayState {}