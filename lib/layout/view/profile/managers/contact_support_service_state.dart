part of 'contact_support_service_cubit.dart';

@immutable
sealed class ContactSupportServiceState {}

final class ContactSupportServiceInitial extends ContactSupportServiceState {}

/// Get All Contact Support Service States
final class GetAllContactSupportServiceLoadingState extends ContactSupportServiceState {}

final class GetAllContactSupportServiceSuccessState extends ContactSupportServiceState {
  final String staticMessage;
  final List<QuestionData> data;

  GetAllContactSupportServiceSuccessState({required this.staticMessage, required this.data});
}

final class GetAllContactSupportServiceErrorState extends ContactSupportServiceState {
  final String? errorMessage;

  GetAllContactSupportServiceErrorState({this.errorMessage});
}