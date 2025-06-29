part of 'filter_cubit.dart';

abstract class FilterState {}

class FilterInitial extends FilterState {}

class InitPriceState extends FilterState {}

class InitRateState extends FilterState {}

class InitStatusState extends FilterState {}

class InitSpecializationState extends FilterState {}

class SpecializationLoadingState extends FilterState {}

class SpecializationLoadedState extends FilterState {
  List<Specialization> data;

  SpecializationLoadedState({required this.data});
}

class SpecializationErrorState extends FilterState {}

class SameSpecializationState extends FilterState {}

class ChangeSpecializationState extends FilterState {}

class DifferentSpecializationState extends FilterState {}

class SameRateState extends FilterState {}

class ChangeRateState extends FilterState {}

class DifferentRateState extends FilterState {}

class SameStatusState extends FilterState {}

class ChangeStatusState extends FilterState {}

class DifferentStatusState extends FilterState {}

class ClearFilterState extends FilterState {}
