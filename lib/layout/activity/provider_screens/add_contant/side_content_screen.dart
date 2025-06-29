import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/constants.dart';
import 'package:my_academy/layout/activity/provider_screens/add_contant/add_content_screen.dart';
import 'package:my_academy/layout/activity/provider_screens/bank_account/adding_bank_account_screen.dart';
import 'package:my_academy/res/value/color/color.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/buttons/master/master_button.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';

import '../../../../bloc/content/content_cubit.dart';
import '../../../../repository/provider/lessons/lessons_repository.dart';
import '../../../../widget/space/space.dart';
import 'add_course_screen.dart';

class SideContentScreen extends StatelessWidget {
  const SideContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            ContentCubit(ProviderLessonsRepository()),
        child: BlocConsumer<ContentCubit, ContentState>(
          listener: (context, state) {},
          builder: (context, state) {
            final bloc = ContentCubit.get(context);
            return Scaffold(
              appBar: DefaultAppBar(title: tr("add_content")),
              body: SidePadding(
                sidePadding: 20,
                child: (hasBankAccount == true)
                    ? ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const Space(boxHeight: 20),
                          // GestureDetector(
                          //   onTap: () => bloc.selectContent(1),
                          //   child: AnimatedContainer(
                          //     clipBehavior: Clip.antiAliasWithSaveLayer,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       border: Border.all(
                          //         color: bloc.selectedContent == 1
                          //             ? mainColor
                          //             : Colors.transparent,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     duration: const Duration(milliseconds: 300),
                          //     child: Image.asset(
                          //       "assets/images/group_course.jpeg",
                          //       height: 200.h,
                          //       fit: BoxFit.fill,
                          //     ),
                          //   ),
                          // ),
                          // const Space(boxHeight: 20),
                          // GestureDetector(
                          //   onTap: () => bloc.selectContent(2),
                          //   child: AnimatedContainer(
                          //     clipBehavior: Clip.antiAliasWithSaveLayer,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20),
                          //       border: Border.all(
                          //         color: bloc.selectedContent == 2
                          //             ? mainColor
                          //             : Colors.transparent,
                          //         width: 2,
                          //       ),
                          //     ),
                          //     duration: const Duration(milliseconds: 300),
                          //     child: Image.asset(
                          //       "assets/images/private_course.jpeg",
                          //       height: 200.h,
                          //       fit: BoxFit.fill,
                          //     ),
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () => bloc.selectContent(1),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: bloc.selectedContent == 1
                                      ? mainColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  "assets/images/group_course.jpeg",
                                  height: 250.h,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const Space(boxHeight: 20),
                          GestureDetector(
                            onTap: () => bloc.selectContent(2),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: bloc.selectedContent == 2
                                      ? mainColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  "assets/images/private_course.jpeg",
                                  height: 250.h,
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),

                          const Space(boxHeight: 40),
                          MasterButton(
                            buttonText: tr("next"),
                            onPressed: () => bloc.selectedContent == 1
                                ? Get.to(() => const AddCourseScreen())
                                : Get.to(() => const AddContentScreen()),
                          ),
                          const Space(boxHeight: 20),
                        ],
                      )
                    : Center(
                        child: MasterButton(
                          buttonText: tr("add_bank"),
                          onPressed: () =>
                              Get.to(() => const AddingBankAccount()),
                        ),
                      ),
              ),
            );
          },
        ));
  }
}
