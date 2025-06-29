part of 'educational_stages_cubit.dart';

abstract class EducationalStagesState {
  // const EducationalStagesState();
}

class EducationalStagesInitial extends EducationalStagesState {
  // @override
  // List<Object> get props => [];
}

class EducationalStagesLoadingState extends EducationalStagesState {}

class EducationalStagesLoadedState extends EducationalStagesState {
  List<EducationalStageModel> data;
  List<LessonData> lessonData;

  EducationalStagesLoadedState({required this.data, required this.lessonData});
}

class EducationalStagesErrorState extends EducationalStagesState {}

class EducationalYearsInitial extends EducationalStagesState {
  // @override
  // List<Object> get props => [];
}

class EducationalYearsLoadingState extends EducationalStagesState {}

class EducationalYearsLoadedState extends EducationalStagesState {
  List<EducationalYearModel> data;

  EducationalYearsLoadedState({required this.data});
}

class SelectStageState extends EducationalStagesState {}

class InitYearState extends EducationalStagesState {}

class SameStageState extends EducationalStagesState {}

class ChangeStageState extends EducationalStagesState {}

class EducationalYearsErrorState extends EducationalStagesState {}

class SameGradeState extends EducationalStagesState {}

class NewGradeState extends EducationalStagesState {}

class ChooseGradeState extends EducationalStagesState {}

class InitGradesState extends EducationalStagesState {}

class InitProviderGradesState extends EducationalStagesState {}

class EditGradesState extends EducationalStagesState {}

class InitYearsState extends EducationalStagesState {}
