import 'package:flutter/cupertino.dart';

import '../../../model/common/lessons/lesson_db_response.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/toast/toast.dart';

class LessonDetailsProviderRepository {
  getLessonDetails(int id) async {
    try {
      return await DioService()
          .get('/providers/lessons/$id/show')
          .then((value) => value.fold((l) => showToast(l), (r) {
                LessonDetailsDbResponse lessonDetails =
                    LessonDetailsDbResponse.fromJson(r);
                return lessonDetails;
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteLesson(int id) async {
    try {
      return await DioService()
          .delete22("/providers/lessons/$id/delete")
          .then((value) => value.fold((l) => showToast(l), (r) {
                showToast(r["message"]);
              }));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}