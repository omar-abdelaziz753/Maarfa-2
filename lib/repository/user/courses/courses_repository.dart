import 'package:flutter/cupertino.dart';

import '../../../model/common/courses/course_details/course_details_db_response.dart';
import '../../../model/common/courses/courses_db_response.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class CoursesRepository {
  getCourses(type, Map<String, dynamic> filter) async {
    try {
      return await DioService()
          .get(type == '' ? '/clients/courses/list' : '/clients/courses/list?$type', queryParams: filter)
          .then((value) {
        return value.fold((l) => showToast(l), (r) {
          CoursesDetailsDbResponse courses =
              CoursesDetailsDbResponse.fromJson(r);
          return courses;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  courseDetails(int id) async {
    try {
      return await DioService()
          .get('/clients/courses/$id/show')
          .then((value) => value.fold((l) => showToast(l), (r) {
                CourseDetailsDbResponse courseDetails =
                    CourseDetailsDbResponse.fromJson(r);
                return courseDetails;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
