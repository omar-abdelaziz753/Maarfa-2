import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/buttons/master_load/master_load_button.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';

import '../../../../bloc/add_request/add_request_cubit.dart';
import '../../../../widget/app_bar/default_app_bar/default_app_bar.dart';
import '../../../../widget/space/space.dart';

class CalenderScreen extends StatelessWidget {
  final dynamic lessonDetails;

  const CalenderScreen({
    super.key,
    this.lessonDetails,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AddRequestCubit(),
        child: BlocConsumer<AddRequestCubit, AddRequestState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = AddRequestCubit.get(context);
              return Scaffold(
                  appBar: DefaultAppBar(title: tr("available_appointments")),
                  body: SidePadding(
                    sidePadding: 15,
                    child: ListView(
                      children: [
                        const Space(
                          boxHeight: 40,
                        ),
                        Text(
                          tr("setadate"),
                          style: TextStyles.subTitleStyle.copyWith(color: grey),
                        ),
                        const Space(
                          boxHeight: 30,
                        ),
                        // ClanderTable(
                        //     focusedDay: bloc.focusedDay,
                        //     onTap: (selectedDay, focusedDay) =>
                        //         bloc.setDate(focusedDay, lessonDetails!.times)),
                        const Space(
                          boxHeight: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr("available_hours"),
                              style: TextStyles.appBarStyle.copyWith(
                                  color: black, fontWeight: FontWeight.bold),
                            ),
                            const Space(
                              boxHeight: 10,
                            ),
                            Text(tr("make_appointment"),
                                style: TextStyles.subTitleStyle.copyWith(
                                  color: grey,
                                )),
                          ],
                        ),
                        const Space(
                          boxHeight: 20,
                        ),
                        Wrap(
                          children: List.generate(
                            lessonDetails!.times!.length,
                            (index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.h, horizontal: 3.w),
                                child: ChoiceChip(
                                  backgroundColor: white,
                                  shape: RoundedRectangleBorder(
                                    side:
                                        const BorderSide(color: textfieldColor),
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  onSelected: (t) {
                                    bloc.addTimeId(
                                        timeId:
                                            lessonDetails!.times![index].id!);
                                  },
                                  selectedColor: mainColor,
                                  label: Column(
                                    children: [
                                      Text(
                                          DateFormat("yyyy-MM-dd", "en").format(
                                              DateTime.parse(lessonDetails!
                                                  .times![index].startsAt
                                                  .toString())),
                                          style: TextStyle(
                                            color: bloc.times.contains(
                                                    lessonDetails!
                                                        .times![index].id!)
                                                ? white
                                                : black,
                                          )),
                                      Text(
                                          "${DateFormat("HH:mm", "en").format(DateTime.parse(lessonDetails!.times![index].startsAt.toString()))} - ${DateFormat("HH:mm", "en").format(DateTime.parse(lessonDetails!.times![index].endsAt.toString()))}",
                                          style: TextStyles.appBarStyle
                                              .copyWith(
                                                  color: bloc.times.contains(
                                                          lessonDetails!
                                                              .times![index]
                                                              .id!)
                                                      ? white
                                                      : black,
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  selected: bloc.times.contains(
                                          lessonDetails!.times![index].id!)
                                      ? true
                                      : false,
                                ),
                              );
                            },
                          ),
                        ),
                        const Space(
                          boxHeight: 10,
                        ),
                        Text(tr("enroll_end_with_start"),
                            style: TextStyles.subTitleStyle
                                .copyWith(color: grey, fontSize: 16.sp)),
                        const Space(
                          boxHeight: 50,
                        ),
                        // bottom == true ?
                        MasterLoadButton(
                          buttonController: bloc.authController,
                          onPressed: () {
                            bloc.validateRequest(
                              lessonId: lessonDetails!.id!,
                              type: 'lesson',
                              lessonDetails: lessonDetails!,
                              context: context
                            );
                          },
                          sidePadding: 0,
                          buttonWidth: screenWidth,
                          buttonText: tr("send_request"),
                        ),
                        // : const SizedBox(),
                        const Space(
                          boxHeight: 100,
                        ),
                      ],
                    ),
                  ));
            }));
  }
}
