// part of 'home_cubit.dart';
//
// @immutable
// sealed class HomeState {}
//
// final class HomeInitial extends HomeState {}
//
// /// Get All Teachers States
// final class GetAllTeachersLoadingState extends HomeState {}
//
// final class GetAllTeachersSuccessState extends HomeState {}
//
// final class GetAllTeachersLoadingMoreState extends HomeState {}
//
// final class GetAllTeachersErrorState extends HomeState {
//   final String? errorMessage;
//
//   GetAllTeachersErrorState({this.errorMessage});
// }

abstract class Home2State {}

class HomeInitial extends Home2State {}

class GetAllTeachersLoadingState extends Home2State {}

class GetAllTeachersSuccessState extends Home2State {}

class GetAllTeachersErrorState extends Home2State {
  final String errorMessage;

  GetAllTeachersErrorState({required this.errorMessage});
}

class GetAllTeachersLoadingMoreState extends Home2State {}

/// Get All Specializations States
class GetAllSpecializationsLoadingState extends Home2State {}

class GetAllSpecializationsSuccessState extends Home2State {}

class GetAllSpecializationsErrorState extends Home2State {
  final String errorMessage;

  GetAllSpecializationsErrorState({required this.errorMessage});
}

/// Get Teacher Details States
class GetTeacherDetailsLoadingState extends Home2State {}

class GetTeacherDetailsSuccessState extends Home2State {}

class GetTeacherDetailsErrorState extends Home2State {
  final String errorMessage;  // Add this line

  GetTeacherDetailsErrorState({required this.errorMessage});
}

/// Make Book States
class MakeBookLoadingState extends Home2State {}

class MakeBookSuccessState extends Home2State {}

class MakeBookErrorState extends Home2State {
  final String errorMessage;

  MakeBookErrorState({required this.errorMessage});
}

/// Get All Best Teachers States
class GetAllBestTeachersLoadingState extends Home2State {}

class GetAllBestTeachersSuccessState extends Home2State {}

class GetAllBestTeachersErrorState extends Home2State {
  final String errorMessage;

  GetAllBestTeachersErrorState({required this.errorMessage});
}