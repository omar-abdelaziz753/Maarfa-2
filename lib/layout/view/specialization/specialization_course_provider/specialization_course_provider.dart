import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';

import '../../../../bloc/content/content_cubit.dart';
import '../../../../bloc/specialzation/specialization_cubit.dart';
import '../../../../bloc/specialzation/specialization_state.dart';
import '../../../../model/common/courses/course_details/course_details_model.dart';
import '../../../../repository/common/specializations/specializations_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/bottom_sheet/week_bottom_sheet.dart';
import '../../../../widget/buttons/master/master_button.dart';
import '../../../../widget/buttons/master_load/master_load_button.dart';
import '../../../../widget/course_type/course_type.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';
import '../../../../widget/upload_content_image/upload_content_image.dart';
import '../../../activity/provider_screens/map/map_screen.dart';
import '../../../card_view/skills/skills_card.dart';

class SpecializationCourseView extends StatelessWidget {
  const SpecializationCourseView({super.key, this.courseDetailsMode});
  final CourseDetailsModel? courseDetailsMode;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            SpecializationCubit(SpecializationsRepository())
              ..getSpecializations(),
        child: BlocConsumer<SpecializationCubit, SpecializationState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SpecializationLoadedState) {
                final specialization = (state).data;
                return SpecializationView(
                  specialization: specialization,
                  courseDetailsModel: courseDetailsMode,
                  lessonData: (state).lessonData,
                );
              } else if (state is SpecializationErrorState) {
                return const ErrorPage();
              } else {
                return const Loading();
              }
            }));
  }
}

class SpecializationView extends StatefulWidget {
  const SpecializationView({
    super.key,
    this.courseDetailsModel,
    required this.specialization,
    required this.lessonData,
  });
  final CourseDetailsModel? courseDetailsModel;
  final List<Specialization> specialization;
  final List<LessonData> lessonData;
  @override
  State<SpecializationView> createState() => _SpecializationViewState();
}

class _SpecializationViewState extends State<SpecializationView> {
  @override
  void initState() {
    super.initState();
    if (widget.courseDetailsModel != null) {
      final bloc = context.read<ContentCubit>();
      final course = widget.courseDetailsModel!;
      bloc.typeValue = course.type;
      bloc.name.text = course.name ?? "";
      bloc.location.text = course.location ?? "";
      bloc.specialization = widget.specialization
          .firstWhere((element) => element.id == course.specialization?.id);
      bloc.chooseSpecialization(bloc.specialization);
      bloc.description.text = course.content ?? "";
      bloc.price.text = course.priceWithoutTax ?? "";
      bloc.hours.text = course.numberOfHours.toString();
      bloc.systemValue = course.attendanceType;
      bloc.people.text = (course.maxStudents ?? "").toString();
      bloc.skillsList
          .addAll(course.tags?.map<String>((e) => e.name ?? "").toList() ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.lessonData);
    final minPrice = int.tryParse(widget.lessonData
                .firstWhere((e) => e.key == "individual_price_min")
                .value ??
            "0") ??
        0;
    final maxPrice = int.tryParse(widget.lessonData
                .firstWhere((e) => e.key == "individual_price_max")
                .value ??
            "0") ??
        0;

    return BlocConsumer<ContentCubit, ContentState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.watch<ContentCubit>();
        return SidePadding(
          sidePadding: 15,
          child: ListView(
            children: [
              Text(
                tr("course"),
                style: TextStyles.contentStyle,
              ),
              UploadContentImage(
                image: bloc.contentImage,
                isPicked: bloc.picked,
                onTap: () => bloc.pickImage(),
              ),
              const Space(
                boxHeight: 15,
              ),
              CourseType(
                title: tr("course_type"),
                firstChoice: tr("offline"),
                secondChoice: tr("live"),
                groupValue: bloc.typeValue,
                onChangedFirst: (v) => bloc.setCourseType(1),
                onChangedSecond: (v) => bloc.setCourseType(2),
              ),
              const Space(
                boxHeight: 15,
              ),
              MasterTextField(
                controller: bloc.name,
                hintText: tr("course_name"),
                errorText: bloc.validators[0],
                onChanged: (val) => bloc.validate(val, 0),
              ),
              const Space(
                boxHeight: 15,
              ),
              bloc.typeValue == 1
                  ? MasterTextField(
                      onTap: () {
                        bloc.specialization = null;
                        bloc.specializationId = null;
                        bloc.specializationName = null;
                        Get.to(() => MapScreen(data: bloc.specialization));
                      },
                      readOnly: true,
                      controller: bloc.location,
                      hintText: tr("course_location"),
                    )
                  : const SizedBox(),
              Space(
                boxHeight: bloc.typeValue == 1 ? 15 : 0,
              ),
              Container(
                height: 70.h,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: textfieldColor,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(5.r)),
                child: DropdownButton<Specialization>(
                  isExpanded: true,
                  elevation: 0,
                  hint: SidePadding(
                    sidePadding: 15,
                    child: Text(
                      tr("specification"),
                      style: TextStyles.appBarStyle.copyWith(color: mainColor),
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: profileIconCardColor,
                    size: 40.h,
                  ),
                  style: TextStyles.appBarStyle.copyWith(color: mainColor),
                  borderRadius: BorderRadius.circular(4.r),
                  value: bloc.specialization,
                  onChanged: (val) => bloc.chooseSpecialization(val),
                  items: widget.specialization
                      .map<DropdownMenuItem<Specialization>>(
                          (Specialization value) {
                    return DropdownMenuItem<Specialization>(
                        value: value,
                        child: Center(
                            child: Text("${value.name}",
                                style: TextStyles.appBarStyle
                                    .copyWith(color: mainColor))));
                  }).toList(),
                ),
              ),
              const Space(
                boxHeight: 15,
              ),
              MasterTextField(
                controller: bloc.description,
                hintText: tr("description"),
                maxLines: 5,
                minLines: 5,
                fieldHeight: 130,
                errorText: bloc.validators[1],
                onChanged: (val) => bloc.validate(val, 1),
              ),
              const Space(
                boxHeight: 20,
              ),
              MasterTextField(
                controller: bloc.hours,
                hintText: tr("course_hours"),
                keyboardType: TextInputType.number,
                errorText: bloc.validators[2],
                onChanged: (val) => bloc.validate(val, 2),
                suffixIcon: "hour",
              ),
              const Space(
                boxHeight: 20,
              ),
              CourseType(
                title: tr("course_system"),
                firstChoice: tr("individual"),
                secondChoice: tr("group"),
                groupValue: bloc.systemValue,
                onChangedFirst: (v) {
                  bloc.price.clear();
                  bloc.people.clear();

                  return bloc.setCourseSystem(1);
                },
                onChangedSecond: (v) {
                  bloc.price.clear();
                  bloc.people.clear();
                  return bloc.setCourseSystem(2);
                },
              ),
              bloc.systemValue == 1
                  ? const SizedBox()
                  : Column(
                      children: [
                        const Space(
                          boxHeight: 15,
                        ),
                        MasterTextField(
                          controller: bloc.people,
                          hintText: tr("max_people"),
                          keyboardType: TextInputType.number,
                          errorText: bloc.validators[4],
                          suffixIcon: "people",
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                                final text = newValue.text;
                                if (text.isEmpty) return newValue;
                                final num = int.tryParse(text);
                                if (num != null && num >= 2 && num <= 5) {
                                  return newValue;
                                }
                                return oldValue;
                              },
                            ),
                          ],
                          onChanged: (val) {
                            bloc.validate(val, 4);

                            final count = int.tryParse(val);
                            if (count != null && count >= 2 && count <= 5) {
                              final key = "group_price_$count";
                              final match = widget.lessonData.firstWhere(
                                (element) => element.key == key,
                                orElse: () => LessonData(key: '', value: ''),
                              );

                              if (match.key!.isNotEmpty &&
                                  match.value != null) {
                                bloc.price.text = match.value!;
                              }
                            } else {
                              bloc.price.clear();
                            }
                          },
                        ),
                      ],
                    ),
              const Space(
                boxHeight: 15,
              ),
              MasterTextField(
                controller: bloc.price,
                hintText: bloc.systemValue == 1
                    ? "${tr("course_price_between")} $minPrice - $maxPrice "
                    : tr("course_price"),
                keyboardType: TextInputType.number,
                errorText: bloc.validators[3],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(maxPrice.toString().length),
                ],
                onChanged: (val) {
                  final inputVal = int.tryParse(val) ?? 0;
                  if (val.isEmpty) {
                    bloc.validators[3] = null;
                  } else if (inputVal < minPrice || inputVal > maxPrice) {
                    bloc.validators[3] =
                        "${tr("course_price_between")} $minPrice - $maxPrice ${tr("sar")}";
                  } else {
                    bloc.validators[3] = null;
                  }
                  setState(() {});
                },
                suffixIcon: "sar",
                readOnly: bloc.systemValue != 1,
              ),
              const Space(
                boxHeight: 20,
              ),
              MasterTextField(
                controller: bloc.skills,
                hintText: tr("skills_acquired"),
                suffix: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      bloc.addSkills();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Icon(
                        Icons.add,
                        color: mainColor,
                        size: 30.h,
                      ),
                    )),
              ),
              bloc.skillsList.isEmpty
                  ? const SizedBox()
                  : Column(
                      children: [
                        const Space(
                          boxHeight: 15,
                        ),
                        Wrap(
                          children: List.generate(
                              bloc.skillsList.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: SkillsCard(
                                        onTap: () => bloc.removeSkill(
                                            bloc.skillsList[index]),
                                        title: "#${bloc.skillsList[index]}"),
                                  )),
                        ),
                      ],
                    ),
              const Space(
                boxHeight: 15,
              ),
              bloc.isShow
                  ? const SizedBox()
                  : MasterButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        bloc.showTable();
                      },
                      buttonText: tr("add_table"),
                      buttonColor: profileColor,
                      borderColor: profileColor,
                      buttonStyle:
                          TextStyles.appBarStyle.copyWith(color: mainColor),
                    ),
              bloc.isShow
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MasterButton(
                                onPressed: () => bloc.pickStartDate(),
                                buttonText: bloc.startDate ?? tr("start_date"),
                                buttonColor: white,
                                borderColor: textfieldColor,
                                buttonStyle: TextStyles.appBarStyle
                                    .copyWith(color: mainColor),
                              ),
                            ),
                            const Space(
                              boxWidth: 10,
                            ),
                            Expanded(
                              child: MasterButton(
                                onPressed: () => bloc.pickEndDate(),
                                buttonText: bloc.endDate ?? tr("end_date"),
                                buttonColor: white,
                                borderColor: textfieldColor,
                                buttonStyle: TextStyles.appBarStyle
                                    .copyWith(color: mainColor),
                              ),
                            ),
                          ],
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MasterButton(
                                onPressed: () => bloc.pickStartTime(),
                                buttonText: bloc.startTime ?? tr("time_from"),
                                buttonColor: white,
                                borderColor: textfieldColor,
                                buttonStyle: TextStyles.appBarStyle
                                    .copyWith(color: mainColor),
                              ),
                            ),
                            // const Space(
                            //   boxWidth: 10,
                            // ),
                            // Expanded(
                            //   child: MasterButton(
                            //     onPressed: () => bloc.pickEndTime(),
                            //     buttonText: bloc.endTime ?? tr("time_to"),
                            //     buttonColor: white,
                            //     borderColor: textfieldColor,
                            //     buttonStyle: TextStyles.appBarStyle
                            //         .copyWith(color: mainColor),
                            //   ),
                            // ),
                          ],
                        ),
                        const Space(
                          boxHeight: 15,
                        ),
                        MasterButton(
                          onPressed: () => daysBottomSheet(),
                          buttonText: bloc.selectedDays.isEmpty
                              ? tr("days")
                              : Get.locale!.languageCode == "ar"
                                  ? bloc.daysAr[bloc.selectedDays[0]]
                                          .toString() +
                                      tr("etc")
                                  : bloc.daysEn[bloc.selectedDays[0]] +
                                      tr("etc"),
                          buttonColor: white,
                          borderColor: textfieldColor,
                          buttonStyle:
                              TextStyles.appBarStyle.copyWith(color: mainColor),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Space(
                boxHeight: 15,
              ),
              MasterLoadButton(
                buttonController: bloc.contentController,
                onPressed: () => bloc.addCourse(),
                buttonText: tr("add_content"),
              ),
              const Space(
                boxHeight: 100,
              ),
            ],
          ),
        );
      },
    );
  }
}
