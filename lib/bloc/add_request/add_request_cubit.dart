import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/model/common/courses/course_details/course_details_model.dart';
import 'package:my_academy/widget/toast/toast.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../model/provider/home/home_db_response.dart';
import '../../model/user/groups_courses/groups_courses_model.dart';
import '../../repository/user/add_request/add_request_repository.dart';
import '../../widget/master_load_button/app_loading_button.dart';

part 'add_request_state.dart';

class AddRequestCubit extends Cubit<AddRequestState> {
  AddRequestCubit() : super(AddRequestInitial());
  RoundedLoadingButtonController authController =
      RoundedLoadingButtonController();
  AppLoadingButtonController requestController = AppLoadingButtonController();

  static AddRequestCubit get(BuildContext context) => BlocProvider.of(context);
  AddRequestsRepository addRequestsRepository = AddRequestsRepository();

  DateTime focusedDay = DateTime.now();

  List<int> times = [];
  List<Time> timeModel = [];

  bool isShow = false;

  initTimes(times, lesson) {
    for (int i = 0; i < lesson.length; i++) {
      if (times!.contains(lesson[i].id)) {
        timeModel.add(lesson[i]);
      }
    }
    emit(InitTimeState());
  }

  setDate(DateTime focused, times) {
    switch (focused == focusedDay) {
      case true:
        isShow = false;
        focusedDay = focused;
        getTimes(focused, times);
        emit(SameDayState());
        break;
      case false:
        isShow = false;
        focusedDay = focused;
        getTimes(focused, times);
        emit(DifferentDayState());
        break;
    }
    emit(SetDateState());
  }

  void getTimes(focused, times) {
    for (int i = 0; i < times.length; i++) {
      switch (
          DateFormat("yyyy-MM-dd").format(DateTime.parse(times[i].startsAt)) ==
              DateFormat("yyyy-MM-dd").format(focused)) {
        case true:
          isShow = true;
          emit(ShowTimeState());
          break;
        case false:
          break;
      }
    }
    emit(GetTimeState());
  }

  addRequestLesson({
    required int lessonId,
    required List<int> times,
    required BuildContext context,
  }) async {
    addRequestsRepository
        .addRequestLesson(id: lessonId, times: times, context: context)
        .whenComplete(() {
      authController.reset();
      emit(AddRequestLoaded());
    });
  }

  addTimeId({required int timeId}) {
    if (times.contains(timeId)) {
      times.remove(timeId);
    } else {
      times.add(timeId);
    }
    emit(IsSelectedChipState());
  }

  validateRequest({
    required int lessonId,
    required String type,
    required dynamic lessonDetails,
    required BuildContext context,
    bool? isHome = false
  }) async {
    if (times.isEmpty) {
      //Todo: add to lang files
      //authController.reset();
      showToast(tr("please_add_at_least_one_time"));
      authController.reset();
    } else {
      addRequestsRepository
          .validateRequest(
            id: lessonId,
            type: type,
            times: times,
            lessonDetails: lessonDetails,
        isHome: isHome, context: context,
          )
          .whenComplete(() => authController.reset());
    }
    emit(ValidateRequest());
  }

  addRequestCourse({
    required int courseId,
    required int groupId,
  }) {
    addRequestsRepository
        .addRequestCourse(id: courseId, groupId: groupId)
        .whenComplete(() {
      authController.reset();
    });
    emit(AddCourseRequestState());
  }

  validateCourseRequest(
      {required int courseId,
      required int groupId,
      required CourseDetailsModel courseDetailsModel,
      required GroupModel groupModel
      // required String type,
      }) {
    addRequestsRepository
        .validateCourseRequest(
            id: courseId,
            groupId: groupId,
            courseDetailsModel: courseDetailsModel,
            groupModel: groupModel)
        .whenComplete(() {
      authController.reset();
      emit(ValidateRequest());
    });
  }
}
