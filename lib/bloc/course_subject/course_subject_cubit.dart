import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/common/courses/course_details/course_details_model.dart';
import '../../repository/user/courses/courses_repository.dart';

part 'course_subject_state.dart';

class CourseSubjectCubit extends Cubit<CourseSubjectState> {
  CourseSubjectCubit(this.coursesRepository) : super(CourseSubjectInitial());

  static CourseSubjectCubit get(BuildContext context) =>
      BlocProvider.of(context);
  CoursesRepository coursesRepository;

  bool isSubject = false;
  bool isSelected = false;

  List<String> typeListAr = ["الكل", "حضوري", "أونلاين", "مباشر"];
  List<String> typeListEn = ["All", "Offline", "Online", "Live"];

  List<Map<String, dynamic>> typeList = [
    {"type": tr("all"), "isSelected": true},
    {"type": tr("offline"), "isSelected": false},
    {"type": tr("online"), "isSelected": false},
    {"type": tr("live"), "isSelected": false},
  ];

  List<bool> courseList = [];
  List<CourseDetailsModel>? coursesModel;

  initBookMarkCourse(data) {
    coursesModel = data;
    for (int i = 0; i < data.length; i++) {
      courseList.add(data[i].isBookmarked);
    }
    emit(InitBookmarkState());
  }

  bookmarkCourse(index) {
    switch (courseList[index] == true) {
      case true:
        courseList[index] = false;
        emit(RemoveBookmarkState());
        break;
      case false:
        courseList[index] = true;
        emit(AddBookmarkState());
        break;
    }
    emit(BookmarkState());
  }

  chooseCourseSubject(state) {
    switch (state == true) {
      case true:
        isSubject = true;
        emit(ChooseSubjectState());
        break;
      case false:
        isSubject = false;
        emit(ChooseCourseState());
    }
  }

  getCoursesByType(state, id, filter) {
    switch (state) {
      case 1:
        state == 1
            ? typeList[0]["isSelected"] = true
            : typeList[0]["isSelected"] = false;
        return getCourses(1, id, filter);
      case 2:
        state == 2
            ? typeList[1]["isSelected"] = true
            : typeList[1]["isSelected"] = false;
        return getCourses(2, id, filter);
      case 3:
        state == 3
            ? typeList[2]["isSelected"] = true
            : typeList[2]["isSelected"] = false;
        return getCourses(3, id, filter);
      case 4:
        state == 4
            ? typeList[3]["isSelected"] = true
            : typeList[3]["isSelected"] = false;
        return getCourses(4, id, filter);
      default:
    }
  }

  getCourses(type, int id, Map<String, dynamic> filter) {
    emit(CourseSubjectLoadingState());
    // filter.contains("specialization_ids[]")?
    filter.remove("specialization_ids[]");
    filter.containsKey("minPrice")
        ? filter["minPrice"].isEmpty
            ? filter.remove("minPrice")
            : () {}
        : () {};
    filter.containsKey("maxPrice")
        ? filter["maxPrice"].isEmpty
            ? filter.remove("maxPrice")
            : () {}
        : () {};
    // filter.putIfAbsent("specialization_ids[]", () => id);
    coursesRepository
        .getCourses(type == 1 ? "" : "&type=$type", filter)
        // .getCourses(type == 1 ? "/list" : "&type=$type", filter)
        .then((value) {
      emit(CourseLoadedState(data: value.data.courses));
    });
  }

  getCourseById(int id) {
    coursesRepository.courseDetails(id).then((value) {
      emit(CourseDetailsLoadedState(data: value.data));
    });
  }
}
