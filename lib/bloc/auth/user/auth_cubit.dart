import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_academy/layout/activity/provider_screens/main/main_screen.dart';
import 'package:my_academy/layout/activity/user_screens/main/main_screen.dart';
import 'package:my_academy/model/guest/guest_data_model.dart';
import 'package:my_academy/service/network/dio/dio_service.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../model/common/cities/city_model.dart';
import '../../../model/common/nationalities/nationality_model.dart';
import '../../../repository/provider/auth_provider/auth_provider_repository.dart';
import '../../../repository/user/auth_user/auth_user_repository.dart';
import '../../../repository/user/edit_profile/user_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../service/auth/auth_service.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../widget/toast/toast.dart';
import '../../bottom_bar/bottom_bar_cubit.dart';

part 'auth_state.dart';

class AuthUserCubit extends Cubit<AuthState> {
  AuthUserCubit(
    this.authRepository,
  ) : super(AuthInitial());

  static AuthUserCubit get(BuildContext context) => BlocProvider.of(context);
  final AuthUserRepository authRepository;
  AuthProviderRepository authProviderRepository = AuthProviderRepository();
  RoundedLoadingButtonController authController =
      RoundedLoadingButtonController();
  SharedPrefService prefService = SharedPrefService();
  var firebaseAuth = FirebaseAuth.instance;

  Timer? timer;
  int start = 60;
  bool timerVisibility = true;
  var oneSec = const Duration(seconds: 1);

  String twoDigits(int number) => number.toString().padLeft(2, '0');

  int auth = 0;
  bool isPassword = true;
  bool isConfirm = true;
  bool loading = false;

  String? cityName;
  int? cityId;

  List<Map<String, dynamic>> gendreArList = [
    {"id": 1, "name": "ذكر"},
    {"id": 2, "name": "أنثى"}
  ];
  List<Map<String, dynamic>> gendreEnList = [
    {"id": 1, "name": "Male"},
    {"id": 2, "name": "Female"}
  ];
  List<TextEditingController> controllers = [];
  List<String?> validators = [null, null, null, null, null, null, null];
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController passConfirm = TextEditingController();
  String? gender;

  String? nationName;
  int? nationId;
  DateTime? pickedDate;
  String? birthdate;
  int? genderValue;

  List<Map<String, dynamic>> genderArList = [
    {"id": 1, "name": "ذكر"},
    {"id": 2, "name": "أنثى"}
  ];
  List<Map<String, dynamic>> genderEnList = [
    {"id": 1, "name": "Male"},
    {"id": 2, "name": "Female"}
  ];

  bool? agree = false;

  CityModel? city;

  Future<GoogleSignInAccount?> handleGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        "email",
        "https://www.googleapis.com/auth/user.birthday.read",
        "https://www.googleapis.com/auth/userinfo.profile"
      ],
    );
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    emit(HandleGoogleState());
    return googleSignInAccount;
  }

  googleLogin() async {
    loading = true;
    try {
      GoogleSignInAccount? googleSignInAccount = await handleGoogle();
      final googleAuth = await googleSignInAccount!.authentication;
      final googleAuthCred = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final user = await firebaseAuth.signInWithCredential(googleAuthCred);
      Map<String, dynamic> data = {
        "first_name": user.additionalUserInfo!.profile!["given_name"],
        "last_name": user.additionalUserInfo!.profile!["family_name"],
        "email": user.user!.email,
        "provider": "google",
        "provider_id": user.user!.providerData[0].uid,
        "gender": 1,
        // "birth_date": user.user!.phoneNumber,
      };
      authRepository.socialLogin(data);
      loading = false;
      emit(LoginGoogleState());
      return user;
    } catch (error) {
      loading = false;
      return error;
    }
  }

  Future<void> appleLogin(BuildContext context) async {
    loading = true;
    try {
      if (!await TheAppleSignIn.isAvailable()) {
        loading = false;
        return showToast(tr("apple_error")); //Break from the program
      }
      String fristName;
      String lastName;
      final authService = AuthService();
      final user = await authService
          .signInWithApple(scopes: [Scope.email, Scope.fullName]);
      // print('uid: ${user.uid}');
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.getString('apple_email') == null) {
        final bool isFoundSpace = user.displayName != null &&
            user.displayName!.split(" ").isNotEmpty &&
            user.displayName!.split(" ").length > 1;
        fristName = user.displayName == null
            ? user.email!.split("@")[0]
            : isFoundSpace
                ? user.displayName!.split(" ")[0]
                : user.displayName!;
        lastName = user.displayName == null
            ? user.email!.split("@")[0]
            : isFoundSpace
                ? user.displayName!.split(" ")[1]
                : user.displayName!;

        await preferences.setString('apple_firstname', fristName);
        await preferences.setString('apple_lastname', lastName);
        await preferences.setString('apple_email', user.email ?? "");
        await preferences.setString('apple_provider_id', user.uid);
      }
      Map<String, dynamic> data = {
        "first_name": preferences.getString('apple_firstname'),
        "last_name": preferences.getString('apple_lastname') ?? "",
        "email": preferences.getString('apple_email'),
        "provider": "apple",
        "provider_id": user.uid,
        "gender": 1,
        //  "birth_date": user.user!.phoneNumber,
      };

      ///heeeeeeeer
      authRepository.socialLogin(data);
      loading = false;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
    }
    emit(LoginAppleState());
  }

  void startTimer() {
    log('startTimer');
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          timer.cancel();
          emit(EndTimerState());
          // start = 60;
        } else {
          start--;
          // startTimer();
          emit(StartTimerState());
        }
      },
    );
    emit(TimerState());
  }

  @override
  void emit(AuthState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  chooseCity(val) {
    switch (city == val) {
      case true:
        city = val;
        cityName = val.name;
        cityId = val.id;
        emit(SameCityState());
        break;
      case false:
        city = val;
        cityName = val.name;
        cityId = val.id;
        emit(ChangeCityState());
        break;
    }
    emit(ChooseCityState());
  }

  NationalityModel? nation;

  chooseNation(val) {
    switch (nation == val) {
      case true:
        nation = val;
        nationName = val.name;
        nationId = val.id;
        emit(SameNationState());
        break;
      case false:
        nation = val;
        nationName = val.name;
        nationId = val.id;
        emit(ChangeNationState());
        break;
    }
    emit(ChooseNationState());
  }

  agreeTerms(state) {
    switch (state == true) {
      case true:
        agree = true;
        emit(AcceptTermsState());
        break;
      case false:
        agree = false;
        emit(RejectTermsState());
    }
  }

  void changeEmail(String email) async {
    Map<String, dynamic> data = {
      "email": email,
      "code": code.text.trim(),
    };
    UserRepository()
        .changeEmail(data)
        .whenComplete(() => authController.reset());
    emit(EditEmailState());
  }

  pickDate() async {
    pickedDate = await showDatePicker(
      context: Get.context!,
      locale: const Locale("en"),
      // initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime(1900),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: blackColor,
            ),
          ),
          child: child ?? const SizedBox()),
    );
    if (pickedDate != null) {
      birthdate = DateFormat("yyyy-MM-dd", "en").format(pickedDate!);
    }
    emit(SelectBirthdateState());
  }

  chooseGender(state) {
    switch (state == true) {
      case true:
        genderValue = 1;
        emit(SameGenderState());
        break;
      case false:
        genderValue = 2;
        emit(ChangeGenderState());
    }
    emit(SelectGenderState());
  }

  void changeAuth(state) {
    switch (state == 1) {
      case true:
        auth = 0;
        break;
      case false:
        auth = 1;
        break;
    }
    emit(ChangeAuthState());
  }

  void securePassword() {
    if (isPassword == true) {
      isPassword = false;
      // secureColor = mainColor;
    } else {
      isPassword = true;
      // secureColor = hintColor.withValues(alpha:0.5);
    }
    emit(ChangePasswordState());
  }

  void secureConfirm() {
    if (isConfirm == true) {
      isConfirm = false;
    } else {
      isConfirm = true;
    }
    emit(ChangeConfirmState());
  }

  void validate(String val, int index, bool password) {
    switch (password ? val.length < 8 : val.isEmpty) {
      case true:
        validators[index] =
            password == true ? tr("error_password") : tr("error_message");
        emit(ValidateEmptyState());
        break;
      case false:
        validators[index] = null;
        emit(ValidateNotEmptyState());
        break;
    }
    emit(ValidateState());
  }

  void login() async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final role = prefService.getBool("isUser") ?? true;
    if (email.text.isEmpty || password.text.isEmpty) {
      controllers = [email, password];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      authController.reset();
    } else {
      Map<String, dynamic> data = {
        "email": email.text.trim(),
        "password": password.text.trim(),
      };
      debugPrint("$role  t = user || f =prov");

      role == true
          ? authRepository
              .userLogin(data)
              .whenComplete(() => authController.reset())
          : authRepository
              .providerLogin(data)
              .whenComplete(() => authController.reset());
    }
    emit(LoginState());
  }


  // Future<void> guestLogin(bool isUser, BuildContext context) async {
  //   emit(GuestLoadingState());
  //
  //   try {
  //     // Use DioService to make the POST request
  //     final response = await DioService().post(
  //       '/check-guest', // Replace with the actual API endpoint path
  //     );
  //
  //     // Handle the response using Either from dartz
  //     return response.fold(
  //       (failure) {
  //         // Failure case
  //         emit(GuestErrorState(failure.toString()));
  //       },
  //       (data) {
  //         // Success case
  //         guestData = GuestDataModel.fromJson(data);
  //
  //         if (guestData.status == true && guestData.data?.guestToken != null) {
  //           // Save guest token to shared preferences
  //           SharedPreferences.getInstance().then((prefs) {
  //             prefs.setString('guest_token', guestData.data!.guestToken!);
  //           });
  //
  //           isUser
  //               ? Get.to(() => MainScreen())
  //               : Get.to(() => ProviderMainScreen());
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(guestData.message ?? 'Login as guest successful'),
  //           ));
  //
  //           emit(GuestSuccessState());
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             backgroundColor: Colors.red,
  //             content: Text(guestData.message ?? 'Failed to login as guest'),
  //           ));
  //           emit(GuestErrorState(
  //               guestData.message ?? 'Failed to login as guest'));
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     emit(GuestErrorState('An unexpected error occurred: $e'));
  //   }
  // }

  void validateEmail() async {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        password.text.isEmpty ||
        confirm.text.isEmpty ||
        confirm.text != password.text) {
      controllers = [firstName, lastName, email, phone, password, confirm];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = i > 3 ? tr("error_password") : tr("error_message")
            : validators[i] = null;
        controllers[4].text != controllers[5].text
            ? validators[5] = tr("error_same_password")
            : validators[5] = null;
      }
      authController.reset();
    } else {
      if (birthdate == null) {
        showToast(tr("error_birthdate"));
        authController.reset();
      } else if (genderValue == null) {
        showToast(tr("error_gender"));
        authController.reset();
      } else if (cityId == null) {
        showToast(tr("error_city"));
        authController.reset();
      } else if (nationId == null) {
        showToast(tr("error_nation"));
        authController.reset();
      } else if (agree == false) {
        showToast(tr("error_agree"));
        authController.reset();
      } else {
        Map<String, dynamic> data = {
          "first_name": firstName.text.trim(),
          "last_name": lastName.text.trim(),
          "birth_date": birthdate,
          "nationality_id": nationId,
          "gender": genderValue,
          "city_id": cityId,
          "email": email.text.trim(),
          "phone": phone.text.trim(),
          "password": password.text.trim(),
          "password_confirmation": confirm.text.trim(),
        };
        authRepository
            .validateRegister(data, email.text.trim())
            .whenComplete(() => authController.reset());
      }
    }
    emit(ValidateEmailState());
  }

  resendCodeUser(Map<String, dynamic> data, email) {
    emit(LoadingState());
    log('resendCodeUser');

    data.containsKey("code") ? data.remove("code") : () {};
    authRepository.validateRegister(data, email);
    emit(ValidateEmailState());
  }

  void resendEditEmail(bool isUser, String email) async {
    emit(LoadingState());
    log('validateEmail');
    UserRepository().validateEmail(email, isUser);
    emit(ValidateEmailState());
  }

  void registerUser(Map<String, dynamic> data) {
    data.putIfAbsent("code", () => code.text.trim());
    authRepository
        .userRegister(data)
        .whenComplete(() => authController.reset());
    emit(RegisterUserState());
  }

  void sendCode(String email, bool? isCode, bool? isEdit,
      Map<String, dynamic>? data, File? cv) async {
    emit(LoadingState());
    data != null
        ? data.containsKey("code")
            ? data.remove("code")
            : () {}
        : () {};
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final role = prefService.getBool("isUser") ?? true;
    if (email.isEmpty) {
      validators[0] = tr("error_message");
      authController.reset();
    } else {
      role == true
          ? await authRepository
              .sendCode(email, isCode, isEdit, data)
              .catchError((_) => emit(AuthInitial()))
              .whenComplete(() {
              emit(ActivateState());
              authController.reset();
            })
          : await authProviderRepository
              .sendCode(email, isCode, isEdit, data, cv)
              .catchError((_) => emit(AuthInitial()))
              .whenComplete(() {
              emit(ActivateState());
              authController.reset();
            });
    }
  }

  void checkCode(String email) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final role = prefService.getBool("isUser") ?? true;
    if (email.isEmpty || code.text.isEmpty) {
      controllers = [
        code,
      ];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] =
                i == 1 ? tr("error_password") : tr("error_message")
            : validators[i] = null;
      }
      authController.reset();
    } else {
      Map<String, dynamic> data = {
        "email": email,
        "code": code.text.trim(),
      };
      role == true
          ? authRepository
              .checkCode(data, email, code.text)
              .whenComplete(() => authController.reset())
          : authProviderRepository
              .checkCode(data, email, code.text)
              .whenComplete(() => authController.reset());
      emit(CheckCodeState());
    }
  }

  // bool showDeleteAccount = false;
  // Future<void> getDeleteStatus() async {
  //   emit(SelectGenderState());
  //   showDeleteAccount = await authProviderRepository.getDeleteStatus();
  //   emit(AuthInitial());
  // }

  Future<void> deleteAccount() async {
    authProviderRepository.deleteAccount().whenComplete(() async {
      BlocProvider.of<BottomBarCubit>(Get.context!).changeBottomBar(0);
      BlocProvider.of<BottomBarCubit>(Get.context!).changeProviderBar(0);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
    });
    emit(LogoutState());
  }

  void resetPassword(String email, String code) async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final role = prefService.getBool("isUser") ?? true;
    if (newPass.text.isEmpty || passConfirm.text.isEmpty) {
      controllers = [newPass, passConfirm];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_password")
            : validators[i] = null;
      }
      authController.reset();
    } else {
      Map<String, dynamic> data = {
        "password": newPass.text.trim(),
        "password_confirmation": passConfirm.text.trim(),
        "code": code,
        "email": email,
      };
      role == true
          ? authRepository.forget(data).whenComplete(() {
              authController.reset();
            })
          : authProviderRepository.forget(data).whenComplete(() {
              authController.reset();
            });
    }
    emit(RestoreState());
  }
}
