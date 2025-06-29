import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';

import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../model/common/educational_stages/educational_stages_db_response.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class EducationalStagesRepository {
  SharedPrefService prefService = SharedPrefService();

  getEducationalStages({Map<String, dynamic>? params}) async {
    try {
      return await DioService()
          .get('/educational_stages', queryParams: params ?? {})
          .then((value) => value.fold((l) => showToast(l), (r) {
                EducationalStagesDbResponse educationalStages =
                    EducationalStagesDbResponse.fromJson(r);
                return educationalStages;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  editGrades(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post("/provider/auth/editEducationalStages", body: data)
          .then((value) => value.fold((l) => showToast('$l'), (r) {
                showToast('${r["messages"]}');
                prefService.setValue('profile', json.encode(r));
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      return debugPrint(e.toString());
    }
  }

  getLessonsPrices() async {
    try {
      return await DioService()
          .get('/lesson')
          .then((value) => value.fold((l) => showToast(l), (r) {
                LessonModelPrice specializations = LessonModelPrice.fromJson(r);
                return specializations;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
