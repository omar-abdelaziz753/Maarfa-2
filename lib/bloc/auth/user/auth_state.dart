part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class ChangeAuthState extends AuthState {}

class ChangePasswordState extends AuthState {}

class ChangeConfirmState extends AuthState {}

class LoginState extends AuthState {}



class RegisterState extends AuthState {}

class ValidateEmptyState extends AuthState {}

class ValidateNotEmptyState extends AuthState {}

class ValidateState extends AuthState {}

class ForgetState extends AuthState {}

class RestoreState extends AuthState {}

class CheckCodeState extends AuthState {}

class ActivateState extends AuthState {}

class ResendCodeState extends AuthState {
  final String code;
  ResendCodeState({
    required this.code,
  });
}

class LogoutState extends AuthState {}

class SameGenderState extends AuthState {}

class ChangeGenderState extends AuthState {}

class SelectGenderState extends AuthState {}

class SameCityState extends AuthState {}

class ChangeCityState extends AuthState {}

class ChooseCityState extends AuthState {}

class SameNationState extends AuthState {}

class ChangeNationState extends AuthState {}

class ChooseNationState extends AuthState {}

class AuthLoadedState extends AuthState {
  final List<CityModel>? data;
  AuthLoadedState({this.data});
}

class AuthErrorState extends AuthState {}

class AcceptTermsState extends AuthState {}

class RejectTermsState extends AuthState {}

class ValidateEmailState extends AuthState {}

class SelectBirthdateState extends AuthState {}

class RegisterUserState extends AuthState {}

class EndTimerState extends AuthState {}

class StartTimerState extends AuthState {}

class TimerState extends AuthState {}

class EditEmailState extends AuthState {}

class HandleGoogleState extends AuthState {}

class LoginGoogleState extends AuthState {}

class LoginAppleState extends AuthState {}

class LoadingState extends AuthState {}
