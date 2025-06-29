import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../failure.dart';
import '../../../layout/activity/auth/forget/check_password_screen.dart';
import '../../../layout/activity/auth/forget/new_password.dart';
import '../../../layout/activity/auth/login/login_screen.dart';
import '../../../layout/activity/auth/register/provider/about_register_screen.dart';
import '../../../layout/activity/auth/register/provider/verification_screen.dart';
import '../../../layout/activity/auth/register/user/code_screen.dart';
import '../../../layout/activity/provider_screens/account_data/edit_account_information_screen.dart';
import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../layout/activity/role/role_screen.dart';
import '../../../model/provider/certificate/certificate_response.dart';
import '../../../model/provider/provider/provider_model.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../service/notification/notification_serivce.dart';
import '../../../widget/alert/error/error_alert.dart';
import '../../../widget/toast/toast.dart';

class AuthProviderRepository {
  SharedPrefService prefService = SharedPrefService();

  providerLogin(Map<String, dynamic> data, String phone) async {
    try {
      return DioService()
          .post('/provider/auth/login', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                prefService.setValue("token", r["data"]["token"]);
                prefService.setValue("type", "provider");
                prefService.setValue("user_name", r);
                updateFCMToken();
                showToast(tr('welcome'));
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  socialLogin(Map<String, dynamic> data, String phone) async {
    try {
      return DioService()
          .post('/client/auth/social-login', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                prefService.setValue("token", r["data"]["token"]);
                prefService.setValue("type", "provider");
                updateFCMToken();
                showToast(tr('welcome'));
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  providerVerify(File cvFile, Map<String, dynamic> data) async {
    try {
      return DioService()
          .post('/provider/auth/sendVerificationCodeRegister', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                Get.to(() => VerificationScreen(
                      email: data["email"],
                      data: data,
                      cv: cvFile,
                      isUser: false,
                      isEdit: false,
                      code: r["data"]["code"],
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  providerRegister(File cvFile, Map<String, dynamic> data) async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    Uri? uri = link?.link;
    Map<String, dynamic>? queryParams = uri == null ? {} : uri.queryParameters;
    String? referral = queryParams["referral"] ?? "";
    data.putIfAbsent("referral", () => referral);
    try {
      return DioService()
          .requestWithFile(cvFile, data, '/provider/auth/register', "cv")
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                // prefService.setValue("token", r["data"]["token"]);
                // prefService.setValue("type", "provider");
                // updateFCMToken();
                Get.offAll(() => const LoginScreen(isUser: false));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  editCV(File cvFile) async {
    try {
      return DioService()
          .requestWithFile(cvFile, {}, "/provider/auth/editCv", "cv")
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                prefService.setValue('profile', json.encode(r));
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  editCertificate(File certificateFile) async {
    try {
      return DioService()
          .requestWithFile(certificateFile, {},
              "/provider/auth/editCertificate", "certificate")
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                Provider data = Provider.fromJson(r["data"]);
                Get.offAll(() => EditAccountInformation(
                      data: data,
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  deleteCertificate(int id) async {
    try {
      return DioService().post("/provider/auth/deleteCertificate",
          body: {"id": id}).then((value) => value.fold(
              (l) => showErrorAlert(
                    message: '$l',
                  ), (r) {
            showToast(r["messages"]);
            Provider data = Provider.fromJson(r["data"]);
            Get.offAll(() => EditAccountInformation(
                  data: data,
                ));
          }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  validateRegister(
    Map<String, dynamic> data,
    String email,
  ) async {
    try {
      return DioService()
          .post('/provider/auth/validate', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                Get.to(() => AboutRegisterScreen(
                      data: data,
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  forget(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post('/provider/auth/reset-password', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                showToast(r["messages"]);
                // showToast(tr('welcome'));
                // prefService.setValue("token", r["data"]["token"]);
                // prefService.setValue("type", "provider");
                // Get.offAll(() => const ProviderMainScreen());
                Get.offAll(() => const LoginScreen(isUser: false));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> sendCode(String email, bool? isCode, bool? isEdit,
      Map<String, dynamic>? data, File? cv) async {
    try {
      final response =
          await DioService().post('/provider/auth/SendVerificationCode', body: {
        "email": email,
      });
      response.fold(
          (l) => showErrorAlert(
                message: '$l',
              ), (r) {
        showToast(r['messages']);
        Get.back();
        isEdit!
            ? Get.to(() => CodeScreen(
                  email: email,
                  isEdit: isEdit,
                  isUser: false,
                  data: data!,
                ))
            : isCode!
                ? Get.to(() => VerificationScreen(
                    email: email,
                    isEdit: isEdit,
                    isUser: false,
                    data: data!,
                    cv: cv,
                    code: r["data"]["code"]))
                : Get.to(() => CheckPasswordScreen(
                      email: email,
                    ));
      });
    } catch (e) {
      throw Exception();
    }
  }

  checkCode(Map<String, dynamic> data, String email, code) async {
    try {
      return DioService()
          .post('/provider/auth/VerifyAccount', body: data)
          .then((value) => value.fold(
                  (l) => showErrorAlert(
                        message: '$l',
                      ), (r) {
                // prefService.setValue("token", r["data"]["token"]);
                // showToast(tr('welcome'));
                Get.to(() => NewPasswordScreen(
                      email: email,
                      code: code,
                    ));
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  updateFCMToken() async {
    final fcmToken = await NotificationService.instance!.getToken();
    log("fcmmmmm$fcmToken");
    try {
      return DioService().post('/provider/auth/updateFcmToken', body: {
        "fcm_token": fcmToken,
        "device_type": Platform.isIOS ? "ios" : "android"
      }).then((value) => value.fold(
              (l) => showErrorAlert(
                    message: '$l',
                  ), (r) {
            // showErrorAlert(
            //   message: "url: /provider/auth/updateFcmToken\nbody: {'fcm_token': $fcmToken}\nresponse: $r"
            // );
          }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  getCertificate() async {
    try {
      return await DioService()
          .get('/provider/auth/getCertificate')
          .then((value) => value.fold((l) => debugPrint(l.toString()), (r) {
                CertificateDbResponse certificate =
                    CertificateDbResponse.fromJson(r);
                return certificate;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> getDeleteStatus() async {
    try {
      final resposne =
          await DioService().post('/client/delete-status') as Either;
      return resposne.fold<bool>((l) => false, (r) {
        return r["data"]["message"] == 1;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getBool("isUser") ?? true;
    try {
      return DioService()
          .post(
            role ? "/client/auth/signout" : "/provider/auth/signout",
          )
          .then((value) => value.fold((l) => showToast("$l"), (r) {
                showToast(r["messages"]);
                prefService.setValue("token", "0");
                prefService.delete("slider");
                prefService.delete("profile");
                prefService.delete("home");
                prefService.delete("offers");
                prefService.delete("requests_course");
                prefService.delete("requests_lesson");
                prefService.delete("bookmark_lesson");
                prefService.delete("bookmark_course");
                prefService.delete("subscribe_course");
                prefService.delete("subscribe_lesson");
                // prefService.delete("");
                Get.offAll(() => const RoleScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getBool("isUser") ?? true;
    try {
      return DioService()
          .post(
            role
                ? "/client/auth/delete-account"
                : "/provider/auth/delete-account",
          )
          .then((value) => value.fold((l) => showToast("$l"), (r) {
                showToast(r["messages"]);
                prefService.setValue("token", "0");
                prefService.delete("slider");
                prefService.delete("profile");
                prefService.delete("home");
                prefService.delete("offers");
                prefService.delete("requests_course");
                prefService.delete("requests_lesson");
                prefService.delete("bookmark_lesson");
                prefService.delete("bookmark_course");
                prefService.delete("subscribe_course");
                prefService.delete("subscribe_lesson");
                Get.offAll(() => const RoleScreen());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
