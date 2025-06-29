import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/widget/toast/toast.dart';

import '../../layout/activity/user_screens/class/class_screen.dart';
import '../../layout/activity/user_screens/specification/specification_screen.dart';
import '../../model/common/courses/course_details/course_details_model.dart';
import '../../model/common/specializations/specializations_model.dart';
import '../../repository/common/specializations/specializations_repository.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(FilterInitial());

  static FilterCubit get(BuildContext context) => BlocProvider.of(context);
  SpecializationsRepository specializationsRepository =
      SpecializationsRepository();
  List<Specialization>? specializationList;

  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  String? specializationName;

  initPrice(Map<String, dynamic>? filter, data) {
    specializationList = data;
    if (filter != null) {
      minPrice.value = filter.containsKey("min_price")
          ? minPrice.value.copyWith(text: filter["min_price"])
          : minPrice.value.copyWith(text: null);
      maxPrice.value = filter.containsKey("max_price")
          ? maxPrice.value.copyWith(text: filter["max_price"])
          : maxPrice.value.copyWith(text: null);
    }
    emit(InitPriceState());
  }

  initSpecialzation(filter) {
    if (filter != null) {
      if (filter.containsKey("specialization_ids[]")) {
        for (int i = 0; i < specializationList!.length; i++) {
          if (specializationList![i].id == filter["specialization_ids[]"]) {
            selectedSpecialization = i;
          }
        }
        changeSelectedSpecialization(
            selectedSpecialization!, specializationList);
        getFiltersMap('specialization_ids[]', filter["specialization_ids[]"]);
      }
    }
    emit(InitSpecializationState());
  }

  initRate(Map<String, dynamic>? filter) {
    if (filter != null) {
      selectedRate = filter.containsKey("rate") ? filter["rate"] : null;
      status = filter.containsKey("type") ? filter["type"] - 1 : null;
    }
    emit(InitRateState());
  }

  initStatus(Map<String, dynamic>? filter) {
    if (filter != null) {
      status = filter.containsKey("type") ? filter["type"] - 1 : null;
      selectedRate = filter.containsKey("rate") ? filter["rate"] : null;
    }
    emit(InitStatusState());
  }

  getSpecializations() {
    specializationsRepository.getSpecializations().then((value) {
      specializationList = value.specialization;
      emit(SpecializationLoadedState(data: value.specialization));
    });
  }

  int? selectedSpecialization;

  changeSelectedSpecialization(int index, data) {
    if (selectedSpecialization == index) {
      emit(SameSpecializationState());
    } else {
      selectedSpecialization = index;
      specializationName = data.name;
      emit(DifferentSpecializationState());
    }
    emit(ChangeSpecializationState());
  }

  int? selectedRate;

  changeSelectedRate(int index) {
    if (selectedRate == index) {
      emit(SameRateState());
    } else {
      selectedRate = index;
      emit(DifferentRateState());
    }
    emit(ChangeRateState());
  }

  List<String> statusList = [tr("offline"), tr("online")];
  int? status;

  changeSelectedStatus(int index) {
    if (status == index) {
      emit(SameStatusState());
    } else {
      status = index;
      emit(DifferentStatusState());
    }
    emit(ChangeStatusState());
  }

  Map<String, dynamic> filtersMap = {};

  getFiltersMap(String key, dynamic value) {
    filtersMap.addAll({
      key: value,
    });
  }

  clearFilter(isCourse, yearId, stageId, title) {
    selectedSpecialization = null;
    status = null;
    selectedRate = null;
    minPrice.clear();
    maxPrice.clear();
    filtersMap.clear();
    isCourse
        ? Get.offAll(() => SpecificationScreen(
              id: stageId,
              title: specializationName ?? title,
            ))
        : Get.offAll(() => ClassScreen(
              id: yearId,
              stageId: stageId,
              name: title,
            ));
    emit(ClearFilterState());
  }

  getFilteredCourses(title, id) {
    if (filtersMap.isEmpty) {
      showToast('please select at least one Filter !');
    } else {
      //ToDo : Saber implement the get course request
      filtersMap.addAll({
        "maxPrice": maxPrice.text.trim(),
        "minPrice": minPrice.text.trim(),
      });
      Get.offAll(() => SpecificationScreen(
            id: id,
            title: specializationName ?? title,
            filter: filtersMap,
          ));
    }
  }

  getFilteredLessons(title, yearId, stageId) {
    // if (filtersMap.isEmpty) {
    //   showToast('please select at least one Filter !');
    // } else {
    //ToDo : Saber implement the get course request
    filtersMap.addAll({
      "maxPrice": maxPrice.text.trim(),
      "minPrice": minPrice.text.trim(),
    });
    Get.offAll(() => ClassScreen(
          id: yearId,
          filterData: filtersMap,
          stageId: stageId,
          name: title,
        ));
    // }
  }
}
