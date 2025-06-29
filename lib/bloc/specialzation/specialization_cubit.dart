import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/bloc/specialzation/specialization_state.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../layout/activity/auth/register/provider/grades_register_screen.dart';
import '../../model/common/courses/course_details/course_details_model.dart';
import '../../model/provider/provider/provider_model.dart';
import '../../repository/common/specializations/specializations_repository.dart';
import '../../widget/toast/toast.dart';

class SpecializationCubit extends Cubit<SpecializationState> {
  SpecializationCubit(this.specializationsRepository)
      : super(SpecializationInitial());
  SpecializationsRepository specializationsRepository;

  RoundedLoadingButtonController specializationController =
      RoundedLoadingButtonController();

  static SpecializationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  List<bool> selectedSpecialization = [];
  List<int> specializationId = [];

  validateSpecialization(Map<String, dynamic> data) {
    if (specializationId.isEmpty) {
      showToast(tr("choose_specialization"));
    } else {
      data.putIfAbsent(
          "specializations[]",
          () => List.generate(
              specializationId.length, (index) => specializationId[index]));
      Get.to(() => GradesRegisterScreen(
            data: data,
          ));
    }
  }

  chooseSpecialization(state, index, data) {
    switch (state == false) {
      case true:
        selectedSpecialization[index] = false;
        specializationId.remove(data[index].id);
        emit(SameSpecializationState());
        break;
      case false:
        selectedSpecialization[index] = true;
        specializationId.add(data[index].id);
        emit(NewSpecializationState());
        break;
    }
    emit(ChooseSpecializationState());
  }

  getInitSpecialization(data) {
    selectedSpecialization = List.filled(data.length, false);
    emit(InitSpecializationState());
  }

  initProviderSpecialization(Provider user, List<Specialization> data) {
    for (int i = 0; i < user.specializations!.length; i++) {
      specializationId.add(user.specializations![i].id!);
    }
    for (int i = 0; i < data.length; i++) {
      if (specializationId.contains(data[i].id)) {
        selectedSpecialization[i] = true;
      } else {
        chooseSpecialization(false, i, data);
      }
    }
    emit(InitProviderSpecializationState());
  }

  editSpecialization() {
    Map<String, dynamic> data = {
      "specializations": List.generate(
          specializationId.length, (index) => specializationId[index]),
    };
    if (specializationId.isEmpty) {
      showToast(tr("choose_specialization"));
      specializationController.reset();
    } else {
      specializationsRepository
          .editSpecialization(data)
          .whenComplete(() => specializationController.reset());
    }
    emit(EditSpecializationState());
  }

  getSpecializations() {
    SharedPrefService prefService = SharedPrefService();

    specializationsRepository.getSpecializations().then((value) async {
      String? token = await prefService.getValue("token");
      print("token $token");
      if (token != "0") {
        await specializationsRepository.getLessonsPrices().then((value2) {
          emit(SpecializationLoadedState(
              data: value.specialization, lessonData: value2.data));
        });
      } else {
        emit(SpecializationLoadedState(
            data: value.specialization, lessonData: List<LessonData>.empty()));
      }
    });
  }

  getSubjects() {
    specializationsRepository.getSubjects().then((value) {
      emit(SubjectLoadedState(data: value.subject));
    });
  }
}
