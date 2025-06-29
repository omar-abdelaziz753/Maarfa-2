import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_academy/constants.dart';

import '../../../failure.dart';
import '../../../layout/activity/auth/forget/check_password_screen.dart';
import '../../../layout/activity/auth/forget/new_password.dart';
import '../../../layout/activity/auth/login/login_screen.dart';
import '../../../layout/activity/auth/register/user/code_screen.dart';
import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../layout/activity/user_screens/main/main_screen.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../service/notification/notification_serivce.dart';
import '../../../widget/alert/error/error_alert.dart';
import '../../../widget/toast/toast.dart';

class AuthUserRepository {
  SharedPrefService prefService = SharedPrefService();

  providerLogin(
    Map<String, dynamic> data,
  ) async {
    try {
      return DioService()
          .post('/provider/auth/login', body: data)
          // .then((value) => value.fold(
          //         (l) => showErrorAlert(
          //               message: '$l',
          //             ), (r) {
          //       prefService.setValue("token", r["data"]["token"]);
          //       prefService.setBool("seen", true);
          //       prefService.setValue("type", "provider");
          //       prefService.setValue('profile', json.encode(r["data"]["user"]));
          //       showToast(tr('welcome'));
          //       updateFCMToken();
          //       // prefService.setValue('profile', json.encode(r));
          //       prefService.setBool(
          //           "has_bank_account", r["data"]["has_bank_account"] ?? false);
          //       print(
          //           "has_bank_account: ${prefService.getBool("has_bank_account")}");
          //       Get.offAll(() => const ProviderMainScreen());
          //       // Get.to(() => const ProviderMainScreen());
          //     }));
          .then((value) =>
              value.fold((l) => showErrorAlert(message: '$l'), (r) async {
                prefService.setValue("token", r["data"]["token"]);
                prefService.setBool("seen", true);
                prefService.setValue("type", "provider");
                prefService.setValue('profile', json.encode(r["data"]["user"]));
                showToast(tr('welcome'));
                updateFCMToken();
                print(
                    " print checke ${r["data"]["user"]["bank_account"] == null}");
                prefService.setBool("has_bank_account",
                    r["data"]["user"]["bank_account"] != null ? true : false);

                final result = await prefService.getBool("has_bank_account");

                result.fold((failure) => print("Error: $failure"), (value) {
                  print("has_bank_account: $value");
                  hasBankAccount = value;
                  print("hasBankAccount: $hasBankAccount");
                });

                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  userLogin(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post('/client/auth/login', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) async {
                updateFCMToken();
                prefService.setValue("token", r["data"]["token"]);
                prefService.setValue("type", "user");
                prefService.setBool("seen", true);
                prefService.setBool("already_log", true);
                prefService.setValue('profile', json.encode(r["data"]["user"]));
                // Save user id here
                prefService.setValue(
                    'user_id', r["data"]["user"]["id"].toString());
                print('================');
                // print(r["data"]["user"]["id"].toString());
                print(await prefService.getValue('user_id'));
                print('================');

                showToast(tr('welcome'));
                Get.offAll(
                  () => const MainScreen(),
                );
                // Get.to(() => const MainScreen(),);
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  socialLogin(Map<String, dynamic> data) async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri? uri = link?.link;
    Map<String, dynamic>? queryParams = uri == null ? {} : uri.queryParameters;
    String? referral = queryParams["referral"] ?? "";
    data.putIfAbsent("referral", () => referral);
    try {
      return DioService()
          .post('/client/auth/socialLogin', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                updateFCMToken();
                prefService.setValue("token", r["data"]["token"]);
                prefService.setValue("type", "user");
                prefService.setBool("seen", true);
                prefService.setValue('profile', json.encode(r["data"]["user"]));
                // showToast(tr('welcome'));
                Get.offAll(() => const MainScreen());
              }));
    } catch (e) {
      showToast(e.toString());
      return left(Failure(e.toString()));
    }
  }

  userRegister(Map<String, dynamic> data) async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri? uri = link?.link;
    Map<String, dynamic>? queryParams = uri == null ? {} : uri.queryParameters;
    String? referral = queryParams["referral"] ?? "";
    data.putIfAbsent("referral", () => referral);
    try {
      return DioService()
          .post('/client/auth/register', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                updateFCMToken();
                showToast(r["messages"]);
                prefService.setValue("token", r["data"]["token"]);
                prefService.setValue("type", "user");
                prefService.setBool("already_log", true);
                prefService.setBool("seen", true);
                prefService.setValue('profile', json.encode(r["data"]["user"]));
                Get.offAll(() => const MainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  validateRegister(Map<String, dynamic> data, String email) async {
    try {
      return DioService()
          .post('/client/auth/validateRegister', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                Get.to(() => CodeScreen(
                      email: email,
                      data: data,
                      isUser: true,
                      isEdit: false,
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<dynamic> sendCode(String email, bool? isCode, bool? isEdit,
      Map<String, dynamic>? data) async {
    try {
      return DioService().post('/client/auth/sendCode', body: {
        "email": email,
      }).then((value) => value.fold(
              (l) => showErrorAlert(
                    message: '$l',
                  ), (r) {
            showToast(r['messages']);
            isCode!
                ? Get.to(() => CodeScreen(
                      email: email,
                      isEdit: isEdit!,
                      isUser: true,
                      data: data!,
                    ))
                : Get.to(() => CheckPasswordScreen(
                      email: email,
                    ));
          }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  checkCode(Map<String, dynamic> data, String email, code) async {
    try {
      return DioService()
          .post('/client/auth/verifyCode', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                // prefService.setValue("token", r["data"]["token"]);
                showToast(r['messages'] ?? "null");
                Get.to(() => NewPasswordScreen(
                      email: email,
                      code: code,
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  forget(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post('/client/auth/forgetPassword', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                // prefService.setValue("token", r["data"]["token"]);
                // prefService.setValue("type", "user");
                // prefService.setValue('profile', json.encode(r["data"]["user"]));
                // Get.offAll(() => const MainScreen());
                Get.offAll(() => const LoginScreen(isUser: true));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  updateFCMToken() async {
    final fcmToken = await NotificationService.instance!.getToken();
    log("fcmmmmm    $fcmToken");

    try {
      return DioService().post('/client/auth/updateFcmToken', body: {
        "fcm_token": fcmToken,
        "device_type": Platform.isIOS ? "ios" : "android"
      }).then((value) => value.fold(
              (l) => showErrorAlert(
                    message: '$l',
                  ), (r) {
            // showErrorAlert(message: "response: $r");
            debugPrint(r.toString());
          }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
