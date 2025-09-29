import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/provider_screens/course_details/course_details.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: 15,
      child: Container(
        width: screenWidth,
        height: 110.h,
        decoration: BoxDecoration(
          color: subjectColor,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: inProgressBorderColor,
          ),
        ),
        child: Column(
          children: [
            SidePadding(
              sidePadding: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 75.h,
                            child: Container(
                              width: 65.w,
                              height: 65.h,
                              decoration: BoxDecoration(
                                  gradient: blueGradient,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Container(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: CachedNetworkImage(
                                      imageUrl: "",
                                      width: 60.w,
                                      height: 60.h,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Logo(
                                            logoHeight: 50,
                                            logoWidth: 50,
                                          )),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50.h,
                            right: 5.w,
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              width: 55.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                  color: black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Center(
                                  child: Text("حضوري",
                                      style: TextStyles.errorStyle
                                          .copyWith(color: white))),
                            ),
                          ),
                        ],
                      ),
                      const Space(
                        boxHeight: 5,
                      ),
                      Text("#123456",
                          style: TextStyles.errorStyle
                              .copyWith(color: textfieldColor)),
                    ],
                  ),
                  const Space(
                    boxWidth: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenWidth / 2,
                        child: Text("حصص جماعية في اساسيات التصميم",
                            style: TextStyles.appBarStyle.copyWith(
                                color: blackColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: screenWidth / 2,
                        child: Row(
                          children: [
                            Image.asset(
                              profile,
                              height: 15.h,
                              fit: BoxFit.contain,
                              color: textfieldColor,
                            ),
                            Text("أ/ عادل السيد", style: TextStyles.hintStyle),
                            const Spacer(),
                            Image.asset(money,
                                height: 15.h, fit: BoxFit.contain),
                            Text("80 ${tr("sar")}",
                                style: TextStyles.hintStyle),
                          ],
                        ),
                      ),
                      const Space(
                        boxWidth: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Get.to(() => const CourseDetails()),
                            child: Text(tr("subject_details"),
                                style: TextStyles.subTitleStyle),
                          ),
                          const Space(
                            boxWidth: 5,
                          ),
                          Image.asset(moreInfo,
                              height: 10.h, fit: BoxFit.contain),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
