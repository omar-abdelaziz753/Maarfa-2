import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/user_screens/request/course_request_summary.dart';
import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';
import 'package:my_academy/model/user/groups_courses/groups_courses_model.dart';

import '../../../layout/activity/user_screens/main/main_screen.dart';
import '../../../layout/activity/user_screens/request/request_lesson_screen.dart';
import '../../../service/network/dio/dio_service.dart';
import '../../../widget/alert/alert_messege.dart';
import '../../../widget/toast/toast.dart';

class AddRequestsRepository {
  addRequestLesson({
    required int id,
    required List<int> times,
    required BuildContext context,
  }) async {
    try {
      return await DioService().post('/clients/requests', body: {
        'type': 'lesson',
        "id": id,
        "times": List.generate(times.length, (index) => times[index]),
      }).then((value) {
        return value.fold((l) => showToast(l.toString()), (r) {
          Get.offAll(() => const MainScreen());
          // if (r['data'] != null) {
          //   context.read<PayCubit>().pay(
          //         id: r['data']['id'],
          //         context: context,
          //       );
          // } else {
          //   showToast(r['messages']);
          // }
          // return addLessonRequest;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  validateRequest({
    required int id,
    required String type,
    required List<int> times,
    required dynamic lessonDetails,
    required BuildContext context,
    bool? isHome = false
  }) async {
    try {
      return await DioService().post('/clients/requests/validate', body: {
        'type': type,
        "id": id,
        "times": List.generate(times.length, (index) => times[index]),
      }).then((value) {
        return value.fold((l) => showToast(l), (r) {
          // ValidateRequestModel validateRequest =
          //     ValidateRequestModel.fromJson(r);
          if(isHome == true){
            Get.to(() =>
                RequestLessonScreen(lessonDetails: lessonDetails, times: times));
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                    (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking confirmed successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }

          // return validateRequest;
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///course requests
  validateCourseRequest(
      {required int id,
      // required String type,
      required int groupId,
      required CourseDetailsModel courseDetailsModel,
      required GroupModel groupModel}) async {
    try {
      return await DioService().post('/clients/requests/validate', body: {
        'type': "course",
        "id": id,
        "group_id": groupId,
      }).then((value) {
        return value.fold((l) => showToast(l.toString()), (r) {
          // if (r['status'] == 400) {
          // showToast(r['messages'] ?? "Error");
          // } else {
          // showToast(r['messages']);
          // ValidateRequestModel validateRequest =
          // ValidateRequestModel.fromJson(r);
          Get.to(() => RequestCourseScreen(
              id: id,
              courseDetailsModel: courseDetailsModel,
              group: groupModel));
          // return validateRequest;
          // }
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  addRequestCourse({
    required int id,
    required int groupId,
  }) async {
    try {
      return await DioService().post('/clients/requests', body: {
        'type': 'course',
        "id": id,
        "group_id": groupId,
      }).then((value) {
        return value.fold((l) => showToast(l), (r) {
          showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return const SimpleAlert();
              }).then((value) => Get.offAll(const MainScreen()));
          // Get.offAll(() => const MainScreen());
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
