import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';

import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../model/common/specializations/specializations_db_response.dart';
import '../../../model/common/subjects/subjects_db_response.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class SpecializationsRepository {
  SharedPrefService prefService = SharedPrefService();

  getSpecializations() async {
    try {
      return await DioService()
          .get('/specializations')
          .then((value) => value.fold((l) => showToast(l), (r) {
                SpecializationsDbResponse specializations =
                    SpecializationsDbResponse.fromJson(r);
                return specializations;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getSubjects() async {
    try {
      return await DioService()
          .get('/subjects')
          .then((value) => value.fold((l) => showToast(l), (r) {
                SubjectsDbResponse subjects = SubjectsDbResponse.fromJson(r);
                return subjects;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  editSpecialization(Map<String, dynamic> data) async {
    try {
      return DioService()
          .post("/provider/auth/editSpecialization", body: data)
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
