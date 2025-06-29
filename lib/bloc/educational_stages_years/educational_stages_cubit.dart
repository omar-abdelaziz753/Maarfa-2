import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../model/common/educational_stages/educational_stages_model.dart';
import '../../model/common/educational_stages/educational_years_model.dart';
import '../../model/provider/provider/provider_model.dart';
import '../../repository/common/educational_stages/educational_stages_repository.dart';
import '../../repository/common/educational_years/educational_years_repository.dart';

part 'educational_stages_state.dart';

class EducationalStagesCubit extends Cubit<EducationalStagesState> {
  EducationalStagesCubit(this.educationalStagesRepository)
      : super(EducationalStagesInitial());
  EducationalStagesRepository educationalStagesRepository;
  static EducationalStagesCubit get(BuildContext context) =>
      BlocProvider.of(context);

  RoundedLoadingButtonController gradesController =
      RoundedLoadingButtonController();

  int? isSelect;
  List<EducationalYearModel> yearsModel = [];
  int? yearsId;
  int? stage;

  List<bool> selectedGrade = [];
  List<int> gradesId = [];

  initYears(data) {
    yearsModel = data;
    emit(InitYearsState());
  }

  chooseGrades(state, index, data) {
    switch (state == false) {
      case true:
        selectedGrade[index] = false;
        gradesId.remove(data[index].id);
        emit(SameGradeState());
        break;
      case false:
        selectedGrade[index] = true;
        gradesId.add(data[index].id);
        emit(NewGradeState());
        break;
    }
    emit(ChooseGradeState());
  }

  getInitGrade(data) {
    selectedGrade = List.filled(data.length, false);
    emit(InitGradesState());
  }

  initProviderGrade(Provider user, List<EducationalStageModel> data) {
    for (int i = 0; i < user.educationalStages!.length; i++) {
      gradesId.add(user.educationalStages![i].id!);
    }
    for (int i = 0; i < data.length; i++) {
      if (gradesId.contains(data[i].id)) {
        selectedGrade[i] = true;
      } else {
        chooseGrades(false, i, data);
      }
    }
    emit(InitProviderGradesState());
  }

  editGrades() {
    Map<String, dynamic> data = {
      "educational_stages":
          List.generate(gradesId.length, (index) => gradesId[index]),
    };
    // if (gradesId.isEmpty) {
    //   showToast(tr("choose_specialization"));
    //   gradesController.reset();
    // } else {
    educationalStagesRepository
        .editGrades(data)
        .whenComplete(() => gradesController.reset());
    // }
    emit(EditGradesState());
  }

  initYear(data) {
    if (data.isNotEmpty) {
      yearsId = data[0].id;
    }
    emit(InitYearState());
  }

  getEducationalStages() {
    SharedPrefService prefService = SharedPrefService();

    educationalStagesRepository.getEducationalStages().then((value) async {
      String? token = await prefService.getValue("token");
      print("token $token");
      if (token != "0") {
        educationalStagesRepository.getLessonsPrices().then((value2) {
          emit(EducationalStagesLoadedState(
              data: value.educationalStage, lessonData: value2.data));
        });
      } else {
        emit(EducationalStagesLoadedState(
            data: value.educationalStage, lessonData: []));
      }
    });
  }

  getEducationalYears() async {
    final response =
        await EducationalYearsRepository().getEducationalYears(yearsId ?? 0);
    yearsModel = response.educationalYear ?? [];
    emit(EducationalYearsLoadedState(data: yearsModel));
  }

  selectStage(state, data) {
    if (stage == data[state].id) {
      isSelect = state;
      yearsId = data[state].id;
      getEducationalYears();
      emit(SameStageState());
    } else {
      isSelect = state;
      yearsId = data[state].id;
      getEducationalYears();
      emit(SelectStageState());
    }
    emit(ChangeStageState());
  }

  void emitLoading() => emit(EducationalYearsInitial());
  void emitYearsError() => emit(EducationalYearsErrorState());
  void emitStagesError() => emit(EducationalStagesErrorState());
}
