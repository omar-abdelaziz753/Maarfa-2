part of 'contact_support_service_cubit.dart';

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

/// Get All Polls States
final class GetAllPollsLoadingState extends ContactSupportServiceState {}

final class GetAllPollsSuccessState extends ContactSupportServiceState {
  final List<Questions> questions;
  final List<Answers> answers;

  GetAllPollsSuccessState({
    required this.questions,
    required this.answers,
  });
}

final class GetAllPollsErrorState extends ContactSupportServiceState {
  final String? errorMessage;

  GetAllPollsErrorState({this.errorMessage});
}

/// Submit Poll Answer States
final class SubmitPollAnswerLoadingState extends ContactSupportServiceState {}

final class SubmitPollAnswerSuccessState extends ContactSupportServiceState {
  final String message;

  SubmitPollAnswerSuccessState({required this.message});
}

final class SubmitPollAnswerErrorState extends ContactSupportServiceState {
  final String? errorMessage;

  SubmitPollAnswerErrorState({this.errorMessage});
}