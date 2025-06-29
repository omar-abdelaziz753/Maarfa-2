import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/content/content_cubit.dart';
import '../../../layout/activity/provider_screens/main/main_screen.dart';
import '../../../model/common/courses/courses_model.dart';
import '../../../model/common/get_and_filter_lessons/get_and_filter_lessons_response.dart';
import '../../../model/common/subjects/subjects_db_response.dart';
import '../../../service/local/share_prefs_service.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class ProviderLessonsRepository {
  SharedPrefService prefService = SharedPrefService();

  addLesson(Map<String, dynamic> data) async {
    try {
      return await DioService()
          .post('/providers/lessons/create', body: data)
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]);
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<CoursesDbResponse> getCourses(int page) async {
    try {
      CoursesDbResponse? coursesDbResponse;
      final response =
          await DioService().get('/providers/courses?status=$page');
      response.fold((l) {
        showToast(l);
        throw l;
      }, (r) {
        coursesDbResponse = CoursesDbResponse.fromJson(r);
      });
      return coursesDbResponse!;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  addCourse(File? image, Map<String, dynamic> data) async {
    try {
      return await DioService()
          .requestWithFile(image, data, '/providers/courses/create', "image")
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["messages"]);
                BlocProvider.of<ContentCubit>(Get.context!).clearCourseData();
                Get.offAll(() => const ProviderMainScreen());
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<AllLessonsDbResponse> getLessons(int page) async {
    try {
      AllLessonsDbResponse? lessonsDbResponse;
      final response = await DioService().get('/providers/lessons?page=$page');
      response.fold((l) {
        showToast(l);
        throw l;
      }, (r) {
        lessonsDbResponse = AllLessonsDbResponse.fromJson(r);
      });
      return lessonsDbResponse!;
    } catch (e) {
      rethrow;
    }
  }

  getAppointmentsLessons(int page, String status) async {
    try {
      return await DioService()
          .get(status == ""
              ? "/providers/lessons?page=$page"
              : '/providers/lessons?page=$page&status=$status')
          .then((value) => value.fold((l) => showToast(l), (r) {
                prefService.setValue("subscribe_lesson", json.encode(r));
                AllLessonsDbResponse getLessons =
                    AllLessonsDbResponse.fromJson(r);
                return getLessons;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getAppointmentsLessonsCache(String status) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('subscribe_lesson')) {
      var response = prefs.getString('subscribe_lesson');
      AllLessonsDbResponse lessonResponse =
          AllLessonsDbResponse.fromJson(json.decode(response!));
      return lessonResponse;
    }
  }

  Future<SubjectsDbResponse?> getSubjects(id) async {
    try {
      SubjectsDbResponse? subjectsDbResponse;
      final response =
          await DioService().get('/subjects?educational_year_id=$id');
      response.fold((l) => showToast(l), (r) {
        subjectsDbResponse = SubjectsDbResponse.fromJson(r);
      });
      return subjectsDbResponse;
    } catch (e) {
      debugPrint(e.toString());

      throw Exception();
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
