import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/bookmark/bookmark_cubit.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../activity/user_screens/subject/subject_screen.dart';

class SubjectCard extends StatelessWidget {
  final bool isBlue;
  final dynamic lessonDetails;
  final int? yearId;
  final int? stageId;
  final VoidCallback onTap;
  final bool isUser;

  const SubjectCard({
    super.key,
    required this.isBlue,
    required this.lessonDetails,
    required this.onTap,
    required this.isUser,
    this.yearId,
    this.stageId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => BookmarkCubit(),
        child: BlocConsumer<BookmarkCubit, BookmarkState>(
            listener: (context, state) {},
            builder: (context, state) {
              // final bloc = BookmarkCubit.get(context);
              return SidePadding(
                sidePadding: 15,
                child: InkWell(
                  onTap: () => Get.to(() => SubjectScreen(
                      lessonDetails: lessonDetails, isUser: isUser)),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    // padding: EdgeInsets.all(10.w),
                    width: screenWidth,
                    height: 180.h,
                    decoration: BoxDecoration(
                        color: textfieldColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        SidePadding(
                          sidePadding: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 65.w,
                                height: 65.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: blueGradient,
                                ),
                                child: Center(
                                  child: Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: lessonDetails.provider.image,
                                      width: 60.w,
                                      height: 60.h,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) {
                                        return const Logo(
                                          logoHeight: 50,
                                          logoWidth: 50,
                                        );
                                      },
                                      placeholder: (context, url) => const Logo(
                                        logoHeight: 50,
                                        logoWidth: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(lessonDetails.provider!.firstName!,
                                      style: TextStyles.unselectedStyle
                                          .copyWith(
                                              color: black,
                                              fontWeight: FontWeight.w700)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        star,
                                        height: 15.h,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        lessonDetails.provider!.rate!
                                            .toString(),
                                        style: TextStyles.subTitleStyle
                                            .copyWith(
                                                color: secColor,
                                                fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "(${lessonDetails.provider!.rateCount!} ${tr("rater")})",
                                        style: TextStyles.smallStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${lessonDetails.hourPrice} ${tr("sar")}",
                                    style: TextStyles.unselectedStyle.copyWith(
                                        color: mainColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "/",
                                    style: TextStyles.introStyle
                                        .copyWith(color: black),
                                  ),
                                  Text(
                                    tr("hour"),
                                    style: TextStyles.errorStyle
                                        .copyWith(color: textfieldColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SidePadding(
                          sidePadding: 25,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: onTap
                                  // context.read<LessonsCubit>().getLessons(
                                  //     yearId: yearId, stageId: stageId);
                                  ,
                                  icon: Image.asset(
                                      isBlue ? blueBookmarkIcon : bookmarkIcon,
                                      height: 35,
                                      fit: BoxFit.contain),
                                ),
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    lessonDetails.content!,
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.contentStyle,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
