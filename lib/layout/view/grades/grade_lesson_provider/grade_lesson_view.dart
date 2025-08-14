import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/model/common/specializations/lessions_model.dart';

import '../../../../bloc/content/content_cubit.dart';
import '../../../../bloc/educational_stages_years/educational_stages_cubit.dart';
import '../../../../model/common/educational_stages/educational_stages_model.dart';
import '../../../../model/common/lessons/lesson_model.dart';
import '../../../../repository/common/educational_stages/educational_stages_repository.dart';
import '../../../../repository/provider/lessons/lessons_repository.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/alert/delete/delete_alert.dart';
import '../../../../widget/buttons/master/master_button.dart';
import '../../../../widget/buttons/master_load/master_load_button.dart';
import '../../../../widget/custom_grid/custom_grid.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/loader/loader.dart';
import '../../../../widget/side_padding/side_padding.dart';
import '../../../../widget/space/space.dart';
import '../../../../widget/textfield/master/master_textfield.dart';
import '../../../card_view/date/date_card.dart';
import '../../specialization/specialization_lesson_provider/specialization_lesson_view.dart';
import '../../years/years_lesson_provider/years_lesson_view.dart';

class GradesLessonView extends StatelessWidget {
  const GradesLessonView({super.key, this.lesson});
  final LessonDetails? lesson;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            EducationalStagesCubit(EducationalStagesRepository())
              ..getEducationalStages(),
        child: BlocConsumer<EducationalStagesCubit, EducationalStagesState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is EducationalStagesLoadedState) {
                final data = (state).data;
                return BlocProvider(
                    create: (BuildContext context) =>
                        ContentCubit(ProviderLessonsRepository()),
                    child: GradView(
                      data: data,
                      lesson: lesson,
                      lessonData: (state).lessonData,
                    ));
              } else if (state is EducationalStagesErrorState) {
                return const ErrorPage();
              } else {
                return const Loading();
              }
            }));
  }
}

class GradView extends StatefulWidget {
  const GradView({
    super.key,
    this.lesson,
    required this.data,
    required this.lessonData,
  });
  final List<EducationalStageModel> data;
  final LessonDetails? lesson;
  final List<LessonData> lessonData;

  @override
  State<GradView> createState() => _GradViewState();
}

class _GradViewState extends State<GradView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      if (widget.lesson != null) {
        final lessonData = widget.lesson!;
        ContentCubit bloc = context.read<ContentCubit>();
        bloc.description.text = lessonData.content ?? "";
        bloc.price.text = lessonData.hourPrice.toString().split('.').first;
        bloc.grade = widget.data.firstWhere(
            (element) => element.id == lessonData.educationalStage?.id);
        bloc.chooseGrade(bloc.grade,
            lessonYear: lessonData.educationalYear!,
            lessonSubject: lessonData.subject);
      }
    });
  }

  DateTime _initialDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    DateTime.now().hour,
    DateTime.now().minute,
  );

  void _updateDateTime() {
    setState(() {
      _initialDateTime = DateTime.now().add(const Duration(days: 1));
    });
  }

  TextEditingController lessonDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // // print(widget.lessonData);
    // final minPrice = int.tryParse(widget.lessonData
    //             .firstWhere((e) => e.key == "individual_price_min")
    //             .value ??
    //         "0") ??
    //     0;
    // final maxPrice = int.tryParse(widget.lessonData
    //             .firstWhere((e) => e.key == "individual_price_max")
    //             .value ??
    //         "0") ??
    //     0;

    // final minPrice = int.tryParse(
    //       widget.lessonData
    //               .firstWhere(
    //                 (e) => e.key == "individual_price_min",
    //                 orElse: () => LessonData(
    //                     key: '', value: ''), // Provide a default value
    //               )
    //               .value ??
    //           "0",
    //     ) ??
    //     0;

    // final maxPrice = int.tryParse(
    //       widget.lessonData
    //               .firstWhere(
    //                 (e) => e.key == "individual_price_max",
    //                 orElse: () => LessonData(key: '', value: ''),
    //               )
    //               .value ??
    //           "0",
    //     ) ??
    //     0;
    return BlocConsumer<ContentCubit, ContentState>(
        listener: (context, state) {},
        builder: (context, state) {
          final bloc = context.watch<ContentCubit>();
          return SidePadding(
            sidePadding: 15,
            child: ListView(
              children: [
                Text(
                  tr("subject"),
                  style: TextStyles.contentStyle,
                ),
                Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: textfieldColor,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r)),
                  child: DropdownButton<EducationalStageModel>(
                    isExpanded: true,
                    elevation: 0,
                    hint: SidePadding(
                      sidePadding: 15,
                      child: Text(
                        tr("grades"),
                        style:
                            TextStyles.appBarStyle.copyWith(color: mainColor),
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: profileIconCardColor,
                      size: 40.h,
                    ),
                    dropdownColor: white,
                    style: TextStyles.appBarStyle.copyWith(color: mainColor),
                    borderRadius: BorderRadius.circular(4.r),
                    value: bloc.grade,
                    onChanged: (val) => bloc.chooseGrade(val),
                    items: widget.data
                        .map<DropdownMenuItem<EducationalStageModel>>(
                            (EducationalStageModel value) {
                      return DropdownMenuItem<EducationalStageModel>(
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
                if (bloc.gradeId != null)
                  YearsLessonView(
                    id: bloc.gradeId!,
                    yearValue: bloc.year,
                    yearTap: (val) => bloc.chooseYear(val),
                  ),
                if (bloc.yearId != null)
                  SpecializationLessonView(
                    id: bloc.yearId!,
                    isEdit: widget.lesson != null,
                    subjectValue: bloc.subject,
                    subjectTap: (val) => bloc.chooseSubject(val),
                  ),
                MasterTextField(
                  controller: bloc.description,
                  hintText: tr("description"),
                  maxLines: 5,
                  minLines: 5,
                  fieldHeight: 130,
                  errorText: bloc.validators[0],
                  onChanged: (val) => bloc.validate(val, 0),
                ),
                const Space(
                  boxHeight: 20,
                ),
                MasterTextField(
                  controller: bloc.price,
                  hintText: tr("hourly_price"),
                  keyboardType: TextInputType.number,
                  errorText: bloc.validators[3],
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // LengthLimitingTextInputFormatter(
                    //     maxPrice.toString().length),
                  ],
                  onChanged: (val) {
                    // final inputVal = int.tryParse(val) ?? 0;

                    
                    // if (val.isEmpty) {
                    //   bloc.validators[3] = null;
                    // } else if (inputVal < minPrice || inputVal > maxPrice) {
                    //   bloc.validators[3] =
                    //       "${tr("hourly_price_between")} $minPrice - $maxPrice ${tr("sar")}";
                    // } else {
                    //   bloc.validators[3] = null;
                    // }
                    setState(() {});
                  },
                  suffixIcon: "sar",
                ),
                const Space(
                  boxHeight: 15,
                ),
                MasterTextField(
                  controller: lessonDateController,
                  hintText: tr("lesson_time_date"),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  onTap: () {
                    _updateDateTime();
                    _showDialog(
                        CupertinoDatePicker(
                          key: ValueKey(_initialDateTime),
                          initialDateTime: _initialDateTime,
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              _initialDateTime = newDateTime;

                              String formattedHour = DateFormat('HH', 'en')
                                  .format(_initialDateTime);
                              String formattedMinute = DateFormat('mm', 'en')
                                  .format(_initialDateTime);
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd', 'en')
                                      .format(_initialDateTime);
                              lessonDateController.text =
                                  '$formattedDate $formattedHour:$formattedMinute';
                              context.read<ContentCubit>().setDate(
                                  formattedDate,
                                  '$formattedHour:$formattedMinute');
                            });
                          },
                        ),
                        context);
                  },
                ),
                const Space(
                  boxHeight: 20,
                ),
                MasterButton(
                  onPressed: () => bloc.addDate(),
                  buttonText: tr("add_table"),
                  buttonColor: profileColor,
                  borderColor: profileColor,
                  buttonStyle:
                      TextStyles.appBarStyle.copyWith(color: mainColor),
                ),
                const Space(
                  boxHeight: 25,
                ),
                CustomGrid(
                  listHeight: 10000000000000,
                  scroll: const NeverScrollableScrollPhysics(),
                  count: bloc.periodList.length,
                  aspectRatio: 3.h,
                  child: (context, index) => DateCard(
                      onTap: () => deleteAlert(
                          deleteTap: () =>
                              bloc.deleteDate(bloc.periodList[index])),
                      date: bloc.periodList[index]!.day,
                      time: bloc.periodList[index]!.time),
                ),
                const Space(
                  boxHeight: 25,
                ),
                MasterLoadButton(
                  buttonController: bloc.contentController,
                  onPressed: () => bloc.addLesson(),
                  buttonText: tr("add_content"),
                ),
                const Space(
                  boxHeight: 100,
                ),
              ],
            ),
          );
        });
  }

  calenderBottomSheet(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        color: white, borderRadius: BorderRadius.circular(20)),
                    child: CupertinoDatePicker(
                      minimumDate: DateTime.now(),
                      maximumDate:
                          DateTime.now().add(const Duration(days: 3650)),
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime newDate) {
                        context.read<ContentCubit>().setDate(null, newDate);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(style: BorderStyle.none),
                        ),
                        child: Center(
                          child: Text(
                            tr('done'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

void _showDialog(Widget child, BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
