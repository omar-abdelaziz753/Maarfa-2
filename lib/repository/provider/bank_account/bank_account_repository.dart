import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:my_academy/constants.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';

import '../../../failure.dart';
import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/alert/error/error_alert.dart';
import '../../../widget/toast/toast.dart';

class BankAccountRepository {
  bankAccount(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post('/provider/auth/update_bank_account', body: data)
          .then((value) => value.fold((l) => showToast("$l"), (r) async {
                showToast(r['messages'].toString());
                SharedPrefService prefService = SharedPrefService();

                prefService.setBool("has_bank_account", true);

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

  requestPay() async {
    try {
      return DioService().post('/provider/payments/request').then(
          (value) => value.fold((l) => showErrorAlert(message: "$l"), (r) {
                showToast(r['messages'].toString());
              }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
