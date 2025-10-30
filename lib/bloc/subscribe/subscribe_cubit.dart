import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../model/user/subscriptions/subscribe_course/subscribe_course_model.dart';
import '../../model/user/subscriptions/subscribe_subject/subscribe_subject_model.dart';
import '../../repository/user/subscriptions/subscriptions_repository.dart';
import '../../widget/toast/toast.dart';

part 'subscribe_state.dart';

class SubscribeCubit extends Cubit<SubscribeState> {
  SubscribeCubit(this.subscriptionsRepository) : super(SubscribeInitial());

  static SubscribeCubit get(BuildContext context) => BlocProvider.of(context);
  SubscriptionsRepository subscriptionsRepository;
  List<String> typeListAr = ["الكل", "حضوري", "أونلاين", "مباشر"];
  List<String> typeListEn = ["All", "Offline", "Online", "Live"];

  // List<String> filters = [];

  String status = "";

  changeFilter(String state) {
    if (status == state) {
      status = state;
      emit(SameFilterState());
    } else {
      status = state;
      emit(DifferrentFilterState());
    }
    emit(ChangeStatusState());
  }

  bool isSubject = false;

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

  clearFilter(type) {
    status = "";
    if (type == 'lesson') {
      changeFilter('');
      getSubscriptionLesson();
    } else {
      getSubscriptionCourse();
    }
    Get.back();
    emit(EmptyFilterState());
  }

  SubscribeCourseModel? subscribeCourseModel;
  SubscribeSubjectModel? subscribeSubjectModel;

  initSubject(data) {
    subscribeSubjectModel = data;
    emit(SubjectSubscriptionLoadedState(data: subscribeSubjectModel!));
  }

  // initCourse(data) {
  //   subscribeCourseModel = data;
  //   emit(CourseSubscriptionLoadedState(data: data));
  // }

  getSubscriptionCourseHome() {
    subscriptionsRepository.subscriptionsCourse(status).then((value) {
      subscribeCourseModel = value.data;
      if (subscribeCourseModel?.liveSubscription?.isNotEmpty ?? false) {
        emit(CourseSubscriptionLoadedState(data: value.data));
      }
    });
  }

  getSubscriptionCourse() {
    emit(LoadingState());
    subscriptionsRepository.subscriptionsCourse(status).then((value) {
      subscribeCourseModel = value.data;
      emit(CourseSubscriptionLoadedState(data: value.data));
    });
  }

  getSubscriptionCourseCache() {
    subscriptionsRepository.subscriptionsCourse(status).then((value) {
      subscribeCourseModel = value.data;
      emit(CourseSubscriptionLoadedState(data: value.data));
    });
  }

  getSubscriptionLessonHome() {
    subscriptionsRepository.subscriptionsSubject(status).then((value) {
      subscribeSubjectModel = value.data;
      if (subscribeSubjectModel?.liveSubscription.isNotEmpty ?? false) {
        emit(SubjectSubscriptionLoadedState(data: value.data));
      }
    });
  }

  getSubscriptionLesson() {
    emit(LoadingState());
    subscriptionsRepository.subscriptionsSubject(status).then((value) {
      subscribeSubjectModel = value.data;

      emit(SubjectSubscriptionLoadedState(data: value.data));
    });
  }

  getSubscriptionLessonCache() {
    subscriptionsRepository.subscriptionsSubjectCache(status).then((value) {
      subscribeSubjectModel = value.data;
      emit(SubjectSubscriptionLoadedState(data: value.data));
    });
  }

  // getFilteredCourseData() {
  //   subscriptionsRepository
  //       .subscriptionsCourse({"status": status}).then((value) {
  //     subscribeCourseModel = value.data;
  //     emit(CourseSubscriptionLoadedState(data: value.data));
  //   });
  // }

  // getFilteredLessonData() {
  //   subscriptionsRepository
  //       .subscriptionsSubject({"status": status}).then((value) {
  //     subscribeSubjectModel = value.data;
  //     emit(SubjectSubscriptionLoadedState(data: value.data));
  //   });
  // }

  getFilteredCoursesHandler() {
    print('==========================');
    print(status);
    print('==========================');
    if (status == "") {
      showToast('choose filter first');
    } else if (status == 'comming') {
      status = 'comming';
      getSubscriptionCourse();
    } else {
      status = 'finished';
      getSubscriptionCourse();
    }
  }

  getFilteredLessonsHandler() {
    print('==========================');
    print(status);
    print('==========================');
    if (status == "") {
      showToast('choose filter first');
    } else if (status == 'comming') {
      status = 'comming';
      getSubscriptionLesson();
      emit(SubscriptionLessonCommingState());
    } else {
      status = 'finished';
      getSubscriptionLesson();
      emit(SubscriptionLessonFinishedState());
    }

    emit(SubscriptionLessonState());
  }
}
