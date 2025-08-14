import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/common/courses/course_details/course_details_model.dart';
import '../../model/common/courses/course_model.dart';
import '../../model/common/educational_stages/educational_stages_model.dart';
import '../../model/common/educational_stages/educational_years_model.dart';
import '../../model/common/lessons/lesson_model.dart';
import '../../model/common/subjects/subjects_model.dart';
import '../../model/date/date_model.dart';
import '../../repository/common/educational_years/educational_years_repository.dart';
import '../../repository/provider/lessons/lessons_repository.dart';
import '../../res/value/color/color.dart';
import '../../service/local/share_prefs_service.dart';
import '../../widget/toast/toast.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final ProviderLessonsRepository lessonRepository;
  ContentCubit(this.lessonRepository) : super(ContentInitial());
  static ContentCubit get(BuildContext context) => BlocProvider.of(context);

  SharedPrefService prefs = SharedPrefService();

  RoundedLoadingButtonController contentController =
      RoundedLoadingButtonController();

  List<TextEditingController> controllers = [];
  List<String?> validators = [null, null, null, null, null, null, null];

  int page = 1;
  int selectedContent = 1;
  EducationalStageModel? grade;
  EducationalYearModel? year;
  Specialization? specialization;
  SubjectModel? subject;

  bool isShow = false;

  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController hours = TextEditingController();
  TextEditingController people = TextEditingController();
  TextEditingController skills = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  List<EducationalYearModel> yearsModel = [];
  List<SubjectModel> subjectModel = [];

  DateModel? period;
  List<DateModel?> periodList = [];

  List<CourseModel> courseModel = [];
  List<LessonDetails> lessonModel = [];

  String? gradeName;
  int? gradeId;

  String? yearName;
  int? yearId;

  String? specializationName;
  int? specializationId;

  String? subjectName;
  int? subjectId;

  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;

  File? contentImage;
  bool picked = false;

  int? typeValue = 1;
  int? systemValue = 1;

  List<String> daysEn = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  List<String> daysAr = [
    "الأحد",
    "الإثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
  ];

  List<int> selectedDays = [];
  List<String> skillsList = [];

  clearCourseData() {
    picked = false;
    isShow = false;
    typeValue = 1;
    systemValue = 1;
    name.clear();
    location.clear();
    description.clear();
    hours.clear();
    price.clear();
    people.clear();
    skills.clear();
    selectedDays.clear();
    skillsList.clear();
    specialization = null;
    specializationName = null;
    specializationId = null;
    contentImage = null;
    startDate = null;
    endDate = null;
    startTime = null;
    endTime = null;
    prefs.delete("lat");
    prefs.delete("lng");
    prefs.delete("address");
    emit(ClearCourseDataState());
  }

  getLocation() async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final address = prefService.getString("address");
    location.value = location.value.copyWith(text: address ?? "");
    emit(InitAddressData());
  }

  removeSkill(state) {
    skillsList.remove(state);
    emit(RemoveSkillState());
  }

  selectDays(state) {
    switch (selectedDays.contains(state)) {
      case true:
        selectedDays.remove(state);
        emit(UnselectDaysState());
        break;
      case false:
        selectedDays.add(state);
        emit(SelectDayState());
        break;
    }
    emit(SetDaysState());
  }

  pickStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      locale: const Locale("en"),
      // initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (context, child) => Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: blackColor,
            ),
          ),
          child: child ?? const SizedBox()),
    );
    if (pickedDate != null) {
      startDate = DateFormat("yyyy-MM-dd", "en").format(pickedDate);
    }
    emit(ChooseStartDateState());
  }

  pickEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      locale: const Locale("en"),
      // initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: blackColor,
            ),
          ),
          child: child ?? const SizedBox()),
    );
    if (pickedDate != null) {
      endDate = DateFormat("yyyy-MM-dd", "en").format(pickedDate);
    }
    emit(ChooseEndDateState());
  }

  // pickStartTime() async {
  //   TimeOfDay? pickedDate = await showTimePicker(
  //     context: Get.context!,
  //     // initialEntryMode: DatePickerEntryMode.calendarOnly,
  //     initialTime: TimeOfDay.now(),
  //     builder: (context, child) => MediaQuery(
  //       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
  //       child: Theme(
  //         data: ThemeData(
  //           colorScheme: const ColorScheme.light(
  //             primary: mainColor,
  //             onPrimary: white,
  //             onSurface: mainColor,
  //           ),
  //         ),
  //         child: Localizations.override(
  //           context: Get.context!,
  //           locale: const Locale('en', 'US'),
  //           child: child!,
  //         ),
  //       ),
  //     ),
  //   );
  //   if (pickedDate != null) {
  //     startTime = MediaQuery.of(Get.context!).alwaysUse24HourFormat
  //         ? pickedDate.format(Get.context!)
  //         : "${pickedDate.hour < 10 ? "0${pickedDate.hour}" : pickedDate.hour}:${pickedDate.minute < 10 ? "0${pickedDate.minute}" : pickedDate.minute}";

  //     endTime
  //   }
  //   emit(ChooseStartTimeState());
  // }
  pickStartTime() async {
    TimeOfDay? pickedDate = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: mainColor,
            ),
          ),
          child: Localizations.override(
            context: Get.context!,
            locale: const Locale('en', 'US'),
            child: child!,
          ),
        ),
      ),
    );

    if (pickedDate != null) {
      final now = DateTime.now();
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedDate.hour,
        pickedDate.minute,
      );

      final endDateTime = startDateTime.add(const Duration(hours: 1));
      final endTimeOfDay = TimeOfDay.fromDateTime(endDateTime);

      final use24Hour = MediaQuery.of(Get.context!).alwaysUse24HourFormat;

      startTime = use24Hour
          ? pickedDate.format(Get.context!)
          : "${pickedDate.hour.toString().padLeft(2, '0')}:${pickedDate.minute.toString().padLeft(2, '0')}";

      endTime = use24Hour
          ? endTimeOfDay.format(Get.context!)
          : "${endTimeOfDay.hour.toString().padLeft(2, '0')}:${endTimeOfDay.minute.toString().padLeft(2, '0')}";
    }

    emit(ChooseStartTimeState());
  }

  pickEndTime() async {
    TimeOfDay? pickedDate = await showTimePicker(
      context: Get.context!,
      // initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: white,
              onSurface: mainColor,
            ),
          ),
          child: Localizations.override(
            context: Get.context!,
            locale: const Locale('en', 'US'),
            child: child!,
          ),
        ),
      ),
    );
    if (pickedDate != null) {
      endTime = MediaQuery.of(Get.context!).alwaysUse24HourFormat
          ? pickedDate.format(Get.context!)
          : "${pickedDate.hour < 10 ? "0${pickedDate.hour}" : pickedDate.hour}:${pickedDate.minute < 10 ? "0${pickedDate.minute}" : pickedDate.minute}";
    }
    emit(ChooseEndTimeState());
  }

  showTable() {
    switch (isShow == true) {
      case true:
        isShow = false;
        emit(HideTableState());
        break;
      case false:
        isShow = true;
        emit(ShowTableState());
        break;
    }
    emit(ChangeTableState());
  }

  pickImage() async {
    emit(PickInitState());
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    contentImage = File(pickedFile?.path ?? "");
    picked = true;
    emit(PickPictureState());
  }

  setCourseType(state) {
    switch (typeValue == state) {
      case true:
        typeValue = state;
        emit(SameTypeState());
        break;
      case false:
        typeValue = state;
        emit(DifferrentTypeState());
        break;
    }
    emit(SetCourseTypeState());
  }

  setCourseSystem(state) {
    switch (systemValue == state) {
      case true:
        systemValue = state;
        emit(SameSystemState());
        break;
      case false:
        systemValue = state;
        emit(DifferrentSystemState());
        break;
    }
    emit(SetCourseSystemState());
  }

  addSkills() {
    skills.text.isEmpty
        ? showToast(tr("error_skills"))
        : skillsList.add(skills.text.trim());
    skills.clear();
    emit(AddSkillsState());
  }

  validate(String val, int index) {
    switch (val.isEmpty) {
      case true:
        validators[index] = tr("error_message");
        emit(ValidateEmptyState());
        break;
      case false:
        validators[index] = null;
        emit(ValidateNotEmptyState());
        break;
    }
    emit(ValidateState());
  }

  selectContent(state) {
    switch (selectedContent == state) {
      case true:
        selectedContent = state;
        emit(SameContentState());
        break;
      case false:
        selectedContent = state;
        emit(DifferentContentState());
        break;
    }
    emit(ChangeContentState());
  }

  Future<void> chooseGrade(val,
      {EducationalYearModel? lessonYear,
      EducationalYearModel? lessonSubject}) async {
    switch (grade != val) {
      case true:
        gradeId = null;
        newGrade(val);

        await getEducationalYearsByID(grade!.id!);
        if (lessonYear != null && lessonSubject != null) {
          chooseYear(
              yearsModel.firstWhere((element) => element.id == lessonYear.id));
          await getSubjects(grade!.id!);
          chooseSubject(subjectModel
              .firstWhere((element) => element.name == lessonSubject.name));
        }
        emit(SameGradeState());
        break;
      case false:
        gradeId = null;
        newGrade(val);

        emit(SameGradeState());
        await getEducationalYearsByID(grade!.id!);
        emit(ChooseGradeState());
        if (lessonYear != null && lessonSubject != null) {
          chooseYear(
              yearsModel.firstWhere((element) => element.id == lessonYear.id));
          await getSubjects(grade!.id!);
          chooseSubject(subjectModel
              .firstWhere((element) => element.name == lessonSubject.name));
        }
        break;
    }
    emit(ChooseGradeState());
  }

  newGrade(val) {
    grade = val;
    gradeName = val.name;
    gradeId = val.id;

    year = null;
    yearName = null;
    yearId = null;
    subject = null;
    subjectName = null;
    subjectId = null;
    emit(DifferentGradeState());
  }

  chooseYear(val) {
    emit(SameYearState());
    switch (year == val) {
      case true:
        year = val;
        yearName = val.name;
        yearId = val.id;
        getSubjects(yearId!);
        emit(ChooseYearState());
        break;
      case false:
        yearId = null;
        Future.delayed(const Duration(milliseconds: 200), () => newYear(val));

        emit(ChooseYearState());
        break;
    }
    emit(ChooseYearState());
  }

  newYear(val) {
    year = val;
    yearName = val.name;
    yearId = val.id;
    subject = null;
    subjectName = null;
    subjectId = null;

    getSubjects(yearId!);
    emit(DifferentYearState());
  }

  chooseSubject(val) {
    switch (subject == val) {
      case true:
        subject = val;
        subjectName = val.name;
        subjectId = val.id;
        emit(SameSubjectState());
        break;
      case false:
        subject = val;
        subjectName = val.name;
        subjectId = val.id;
        break;
    }
    emit(ChooseSubjectState());
  }

  chooseSpecialization(val) {
    switch (specialization == val) {
      case true:
        specialization = val;
        specializationName = val.name;
        specializationId = val.id;
        emit(SameSpecializationState());
        break;
      case false:
        specialization = val;
        specializationName = val.name;
        specializationId = val.id;
        emit(DifferentSpecializationState());
        break;
    }
    emit(ChooseSpecializationState());
  }

  setStartDate(s) {
    startDate = DateFormat("yyyy-MM-dd").format(s);
    emit(ChooseStartDateState());
  }

  setEndDate(s) {
    endDate = DateFormat("yyyy-MM-dd").format(s);
    emit(ChooseEndDateState());
  }

  setStartTime(s) {
    startTime = DateFormat("HH:mm", "en").format(s);
    emit(ChooseStartTimeState());
  }

  setEndTime(s) {
    endTime = DateFormat("HH:mm", "en").format(s);
    emit(ChooseEndTimeState());
  }

  setDate(d, t) {
    period = DateModel(day: d, time: t);
    log("setDATE");
    emit(ChooseDateState());
    return true;
  }

  addDate() {
    if (periodList.contains(period)) {
      showToast(tr("already_added"));
      period = null;
      emit(DateFoundState());
    } else if (period == null) {
      showToast(tr("error_period"));
    } else {
      periodList.add(period);
      period = null;
      emit(AddDateState());
    }
    emit(UpdateDateListState());
  }

  deleteDate(date) {
    periodList.remove(date);
    Get.back();
    emit(DeleteDateState());
  }

  addLesson() {
    if (description.text.isEmpty || price.text.isEmpty) {
      controllers = [description, price];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      contentController.reset();
    } else {
      if (yearId == null) {
        showToast(tr("error_year"));
        contentController.reset();
      } else if (gradeId == null) {
        showToast(tr("error_grade"));
        contentController.reset();
      } else if (subjectId == null) {
        showToast(tr("error_specialization"));
        contentController.reset();
      } else if (periodList.isEmpty) {
        showToast(tr("error_period"));
        contentController.reset();
      } else {
        Map<String, dynamic> data = {
          "educational_stage_id": gradeId,
          "educational_year_id": yearId,
          "subject_id": subjectId,
          "content": description.text.trim(),
          "hour_price": price.text.trim(),
          "times": List.generate(
              periodList.length,
              (index) => {
                    "day": periodList[index]!.day,
                    "time": periodList[index]!.time
                  }),
        };
        lessonRepository
            .addLesson(data)
            .whenComplete(() => contentController.reset());
      }
    }
    emit(AddLessonState());
  }

  addCourse() async {
    SharedPreferences prefService = await SharedPreferences.getInstance();
    final lat = prefService.getString("lat");
    final lng = prefService.getString("lng");

    if (description.text.isEmpty || price.text.isEmpty) {
      controllers = [name, description, hours, price];
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].text.isEmpty
            ? validators[i] = tr("error_message")
            : validators[i] = null;
      }
      contentController.reset();
    } else {
      if (people.text.isEmpty && systemValue == 2) {
        validators[4] = tr("error_message");
        contentController.reset();
      } else if (skillsList.isEmpty) {
        showToast(tr("error_skills"));
        contentController.reset();
      } else if (startDate == null ||
          endDate == null ||
          startTime == null ||
          endTime == null ||
          selectedDays.isEmpty) {
        showToast(tr("error_date"));
        contentController.reset();
      } else if (lat == null && lng == null && typeValue == 1) {
        showToast(tr("error_location"));
        contentController.reset();
      } else if (contentImage == null) {
        showToast(tr("error_image"));
        contentController.reset();
      } else if (specializationId == null) {
        showToast(tr("error_specialization"));
        contentController.reset();
      } else {
        Map<String, dynamic> data = {
          "name": name.text.trim(),
          "type": typeValue,
          "location": "$lat, $lng",
          "educational_stage_id": gradeId,
          "educational_year_id": yearId,
          "subject_id": subjectId,
          "specialization_id": specializationId,
          "content": description.text.trim(),
          "number_of_hours": hours.text.trim(),
          "price": price.text.trim(),
          "attendance_type": systemValue,
          "max_students": people.text.trim(),
          "tags[]":
              List.generate(skillsList.length, (index) => skillsList[index]),
          "groups": List.generate(
              1,
              (i) => {
                    "start_date": startDate,
                    "end_date": endDate,
                    "start_time": startTime,
                    "end_time": endTime,
                    "days": selectedDays.map((e) => e.toString()).join(","),
                  }),
        };
        lessonRepository
            // ignore: unnecessary_null_in_if_null_operators
            .addCourse(contentImage ?? null, data)
            .whenComplete(() => contentController.reset());
      }
    }
    emit(AddCourseState());
  }

  Future<void> getEducationalYearsByID(int id) async {
    final educationalYears =
        await EducationalYearsRepository().getEducationalYears(id);
    yearsModel = educationalYears.educationalYear ?? [];
    emit(EducationalYearsLoadedState(data: yearsModel));
  }

  initYears(data) {
    yearsModel = data;
    emit(InitYearsState());
  }

  Future getSubjects(int id) async {
    final value = await lessonRepository.getSubjects(id);
    if (value != null) {
      subjectModel = value.subject ?? [];
      // initSubject(value.subject);
      emit(SubjectLoadedState(data: value.subject ?? []));
    }
  }

  initSubject(data) {
    subjectModel = data;
    emit(InitSubjectState());
  }

  initLesson(data) {
    page == 1 ? lessonModel = data : lessonModel.addAll(data.data.lessons);
    emit(InitialCourseState());
  }

  getLessons() async {
    if (state is LessonsLoadingState) return;
    final currentState = state;
    var oldLessons = <LessonDetails>[];
    if (currentState is LessonsLoadedState) {
      oldLessons = currentState.lessons;
    }
    emit(LessonsLoadingState(oldLessons, isFirstFetch: page == 1));
    lessonRepository.getLessons(page).then((newLessons) {
      page++;
      lessonModel.addAll(newLessons.data.lessons);
      if (newLessons.data.pagination.hasMorePages == true) {
        lessonRepository.getLessons(page).then((v) {
          lessonModel.addAll(v.data.lessons);
          emit(LessonsLoadedState(lessonModel));
        });
      }
      emit(LessonsLoadedState(lessonModel));
    });
  }

  initCourse(data) {
    page == 1 ? courseModel = data : courseModel.addAll(data.data.courses);
    emit(InitialCourseState());
  }

  getCourses() async {
    if (state is CoursesLoadingState) return;
    final currentState = state;
    var oldCourses = <CourseModel>[];
    if (currentState is CoursesLoadedState) {
      oldCourses = currentState.courses;
      courseModel = currentState.courses;
    }
    emit(CoursesLoadingState(oldCourses, isFirstFetch: page == 1));
    lessonRepository.getCourses(page).then((newCourses) {
      page++;
      courseModel.addAll(newCourses.data!.courses!);
      if (newCourses.data!.pagination!.hasMorePages == true) {
        // courseModel.addAll(newCourses.data.courses);
        lessonRepository.getCourses(page).then((v) {
          courseModel.addAll(v.data!.courses!);
          emit(CoursesLoadedState(courseModel));
        });
      }
      emit(CoursesLoadedState(courseModel));
    });
  }
}
