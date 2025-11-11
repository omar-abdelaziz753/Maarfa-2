import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';

import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../space/space.dart';

class CourseSubjectHeader extends StatelessWidget {
  final VoidCallback? courseTap;
  final VoidCallback? subjectTap;
  final bool isSubject;
  const CourseSubjectHeader(
      {super.key, this.courseTap, this.subjectTap, required this.isSubject});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20.0,
      shadowColor: borderColor.withValues(alpha: 0.15),
      child: Container(
        width: screenWidth,
        height: 90.h,
        color: white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: courseTap,
              child: Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: !isSubject ? mainColor : white,
                                  width: 2.h))),
                      child: Center(
                          child: Text(
                        tr("course"),
                        style: !isSubject
                            ? TextStyles.selectedStyle
                            : TextStyles.unselectedStyle,
                      ))),
                  !isSubject
                      ? Container(
                          height: 15.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            const Space(
              boxWidth: 100,
            ),
            InkWell(
              onTap: subjectTap,
              child: Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: isSubject ? mainColor : white,
                                  width: 2.h))),
                      child: Center(
                          child: Text(
                        tr("subject"),
                        style: isSubject
                            ? TextStyles.selectedStyle
                            : TextStyles.unselectedStyle,
                      ))),
                  isSubject
                      ? Container(
                          height: 15.h,
                          width: 25.w,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.r),
                              topRight: Radius.circular(30.r),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
