// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:my_academy/res/drawable/image/images.dart';
// import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
// import 'package:my_academy/res/value/style/textstyles.dart';
// import 'package:my_academy/widget/buttons/master/master_button.dart';
// import 'package:my_academy/widget/logo/logo/logo.dart';
// import 'package:my_academy/widget/side_padding/side_padding.dart';
// import 'package:my_academy/widget/space/space.dart';

// import '../../../bloc/lesson_details/lesson_details_provider_cubit.dart';
// import '../../../bloc/provider_course_details/provider_course_details_cubit.dart';
// import '../../../model/common/lessons/lesson_model.dart';
// import '../../../repository/provider/lesson_details/lesson_details_repository.dart';
// import '../../../res/value/color/color.dart';
// import '../../../widget/alert/delete/delete_alert.dart';
// import '../../../widget/error/page/error_page.dart';
// import '../../../widget/loader/loader.dart';
// import '../../activity/provider_screens/add_contant/add_content_screen.dart';
// import '../../activity/user_screens/trainer/trainer_screen.dart';
// import '../../card_view/trainer_card/trainer_card.dart';

// class ProviderLessonDetailsView extends StatelessWidget {
//   const ProviderLessonDetailsView({super.key, required this.id});
//   final int id;

//   @override
//   Widget build(final BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) => LessonDetailsProviderCubit(
//               lessonDetailsProviderRepository:
//                   LessonDetailsProviderRepository(),
//               id: id,
//             )..getLessonDetails(),
//         child: BlocConsumer<LessonDetailsProviderCubit,
//                 LessonDetailsProviderState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               return BlocBuilder<LessonDetailsProviderCubit,
//                   LessonDetailsProviderState>(builder: (context, state) {
//                 if (state is LessonDetailsLoadedState) {
//                   final data = (state).data;
//                   return lessonDetailsView(context, data!);
//                 } else if (state is CourseDetailsErrorState) {
//                   return const ErrorPage();
//                 } else {
//                   return const Loading();
//                 }
//               });
//             }));
//   }

//   lessonDetailsView(context, LessonDetails lessonDetails) {
//     return BlocProvider(
//         create: (BuildContext context) => LessonDetailsProviderCubit(
//             lessonDetailsProviderRepository: LessonDetailsProviderRepository(),
//             id: id),
//         child: BlocConsumer<LessonDetailsProviderCubit,
//                 LessonDetailsProviderState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               final bloc = LessonDetailsProviderCubit.get(context);

//               return SingleChildScrollView(
//                   child: Column(children: [
//                 Stack(alignment: FractionalOffset.topCenter, children: [
//                   Image.asset(profileBackground,
//                       height: 235.h, width: screenWidth, fit: BoxFit.fill),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const Space(
//                         boxHeight: 150,
//                       ),
//                       Stack(
//                         alignment: FractionalOffset.bottomRight,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.all(5.h),
//                             child: Container(
//                               height: 135.h,
//                               width: 135.w,
//                               clipBehavior: Clip.antiAliasWithSaveLayer,
//                               decoration: const BoxDecoration(
//                                   color: white, shape: BoxShape.circle),
//                               child: Center(
//                                 child: Container(
//                                   height: 125.h,
//                                   width: 125.w,
//                                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                                   decoration: const BoxDecoration(
//                                       color: profileBorderCardColor,
//                                       shape: BoxShape.circle),
//                                   child: Center(
//                                     child: CachedNetworkImage(
//                                         imageUrl:
//                                             lessonDetails.provider!.image!,
//                                         width: 125.w,
//                                         height: 125.h,
//                                         fit: BoxFit.cover,
//                                         errorWidget: (context, url, error) =>
//                                             const SizedBox(),
//                                         placeholder: (context, url) =>
//                                             const Logo(
//                                               logoHeight: 50,
//                                               logoWidth: 50,
//                                             )),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Image.asset(
//                           //     lessonDetails.isBookmarked
//                           //         ? blueBookmarkIcon
//                           //         : bookmarkIcon,
//                           //     height: 50.h,
//                           //     fit: BoxFit.contain),
//                         ],
//                       ),
//                       Text(lessonDetails.provider!.firstName!,
//                           textAlign: TextAlign.center,
//                           style: TextStyles.appBarStyle.copyWith(
//                               fontSize: 20.sp,
//                               color: blackColor,
//                               fontWeight: FontWeight.w700)),
//                       Text(lessonDetails.provider!.title!,
//                           textAlign: TextAlign.center,
//                           style: TextStyles.hintStyle),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             star,
//                             height: 15.h,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             lessonDetails.provider!.rate!.toString(),
//                             style: TextStyles.subTitleStyle.copyWith(
//                                 color: secColor, fontWeight: FontWeight.w700),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             "(${lessonDetails.provider!.rateCount!} ${tr("rater")})",
//                             style: TextStyles.smallStyle,
//                           ),
//                         ],
//                       ),
//                       const Space(
//                         boxHeight: 20,
//                       ),
//                       SidePadding(
//                         sidePadding: 15,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 Text(
//                                   lessonDetails.subject!.name!,
//                                   style: TextStyles.introStyle.copyWith(
//                                       color: blackColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 //Todo:implement the exact params
//                                 Text(
//                                   "${lessonDetails.educationalStage!.name}-${lessonDetails.educationalYear!.name}",
//                                   style: TextStyles.hintStyle,
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       lessonDetails.hourPrice!,
//                                       style: TextStyles.selectedStyle
//                                           .copyWith(fontSize: 40.sp),
//                                     ),
//                                     Text(
//                                       tr("sar"),
//                                       style: TextStyles.roleStyle.copyWith(
//                                           color: mainColor, fontSize: 20.sp),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   tr("per_hour"),
//                                   style: TextStyles.roleStyle.copyWith(
//                                       color: mainColor, fontSize: 20.sp),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Space(
//                         boxHeight: 20,
//                       ),
//                       SidePadding(
//                         sidePadding: 15,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 tr("subject_details"),
//                                 style: TextStyles.appBarStyle
//                                     .copyWith(color: blackColor),
//                               ),
//                             ),
//                             Text(
//                               lessonDetails.content!,
//                               style: TextStyles.hintStyle,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Space(boxHeight: 10.h),
//                       SidePadding(
//                         sidePadding: 15,
//                         child: GestureDetector(
//                           onTap: () => Get.to(() => TrainerScreen(
//                                 id: lessonDetails.provider!.id!,
//                                 isUser: false,
//                               )),
//                           child: TrainerCard(
//                             courseDetailsModel: lessonDetails,
//                             isLesson: true,
//                           ),
//                         ),
//                       ),
//                       const Space(boxHeight: 20),
//                       if (lessonDetails.times!.isNotEmpty)
//                         Wrap(
//                           children: List.generate(
//                             lessonDetails.times!.length,
//                             (index) {
//                               return Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 2.h, horizontal: 3.w),
//                                 child: ChoiceChip(
//                                   backgroundColor: white,
//                                   shape: RoundedRectangleBorder(
//                                     side:
//                                         const BorderSide(color: textfieldColor),
//                                     borderRadius: BorderRadius.circular(25.r),
//                                   ),
//                                   onSelected: (t) {},
//                                   selectedColor: mainColor,
//                                   label: Column(
//                                     children: [
//                                       Text(
//                                           DateFormat("yyyy-MM-dd", "en").format(
//                                               DateTime.parse(lessonDetails
//                                                   .times![index].startsAt
//                                                   .toString())),
//                                           style: const TextStyle(
//                                             color: black,
//                                           )),
//                                       Text(
//                                           "${DateFormat("HH:mm", "en").format(DateTime.parse(lessonDetails.times![index].startsAt.toString()))} - ${DateFormat("HH:mm", "en").format(DateTime.parse(lessonDetails.times![index].endsAt.toString()))}",
//                                           style: TextStyles.appBarStyle
//                                               .copyWith(
//                                                   color: black,
//                                                   fontWeight: FontWeight.bold)),
//                                     ],
//                                   ),
//                                   selected: false,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       const Space(boxHeight: 30),
//                       MasterButton(
//                         sidePadding: 15,
//                         // buttonStyle:
//                         //     TextStyles.appBarStyle.copyWith(color: mainColor),
//                         onPressed: () {
//                           Get.to(
//                             () => AddContentScreen(
//                               lesson: lessonDetails,
//                             ),
//                           );
//                         },
//                         buttonText: tr("repeat"),
//                       ),
//                       Space(boxHeight: 10.h),
//                       MasterButton(
//                           sidePadding: 15,
//                           borderColor: transparent,
//                           buttonColor: circleColor.withOpacity(0.1),
//                           buttonStyle: TextStyles.appBarStyle
//                               .copyWith(color: circleColor),
//                           onPressed: () => deleteAlert(
//                                 deleteTap: () => bloc.deleteLesson(id),
//                               ),
//                           buttonText: tr("deactive")),
//                       const Space(boxHeight: 30),
//                     ],
//                   ),
//                 ]),
//               ]));
//             }));
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/res/drawable/image/images.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/image_handler/image_from_network/network_image.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../bloc/lesson_details/lesson_details_provider_cubit.dart';
import '../../../bloc/provider_course_details/provider_course_details_cubit.dart';
import '../../../model/common/lessons/lesson_model.dart';
import '../../../repository/provider/lesson_details/lesson_details_repository.dart';
import '../../../res/value/color/color.dart';
import '../../../widget/alert/delete/delete_alert.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/loader/loader.dart';
import '../../activity/provider_screens/add_contant/add_content_screen.dart';
import '../../activity/user_screens/trainer/trainer_screen.dart';

class ProviderLessonDetailsView extends StatelessWidget {
  const ProviderLessonDetailsView({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonDetailsProviderCubit(
        lessonDetailsProviderRepository: LessonDetailsProviderRepository(),
        id: id,
      )..getLessonDetails(),
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: BlocConsumer<LessonDetailsProviderCubit,
            LessonDetailsProviderState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is LessonDetailsLoadedState) {
              return LessonDetailsContent(lessonDetails: state.data!);
            } else if (state is CourseDetailsErrorState) {
              return const ErrorPage();
            }
            return const Center(child: Loading());
          },
        ),
      ),
    );
  }
}

class LessonDetailsContent extends StatelessWidget {
  final LessonDetails lessonDetails;

  const LessonDetailsContent({super.key, required this.lessonDetails});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                _buildProfileSection(context),

                // Price & Subject Info
                _buildInfoSection(),

                // Divider
                Divider(height: 40.h, thickness: 1, color: Colors.grey[200]),

                // Lesson Description
                _buildDescriptionSection(),

                // Trainer Card
                _buildTrainerSection(context),

                // Available Times
                if (lessonDetails.times!.isNotEmpty) _buildTimesSection(),

                // Action Buttons
                _buildActionButtons(context, lessonDetails.id),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          // Profile Avatar
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: lessonDetails.provider!.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 50.w,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Name & Title
          Text(
            lessonDetails.provider!.firstName!,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            lessonDetails.provider!.title!,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18.w),
              SizedBox(width: 4.w),
              Text(
                lessonDetails.provider!.rate!.toString(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: secColor,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                "(${lessonDetails.provider!.rateCount!} ${tr("rater")})",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr("subject"),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lessonDetails.subject!.name!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "${lessonDetails.educationalStage!.name}-${lessonDetails.educationalYear!.name}",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tr("price_per_hour"),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: lessonDetails.hourPrice!,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                    TextSpan(
                      text: " ${tr("sar")}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("subject_details"),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            lessonDetails.content!,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildTrainerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("about_trainer"),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => Get.to(() => TrainerScreen(
                id: lessonDetails.provider!.id!,
                isUser: false,
              )),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: CardWidget(
              courseDetailsModel: lessonDetails,
              isLesson: true,
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr("available_times"),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: lessonDetails.times!.map((time) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat("MMM d, yyyy", "en").format(
                      DateTime.parse(time.startsAt.toString()),
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${DateFormat("h:mm a", "en").format(DateTime.parse(time.startsAt.toString()))} - ${DateFormat("h:mm a", "en").format(DateTime.parse(time.endsAt.toString()))}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, id) {
    final bloc = context.read<LessonDetailsProviderCubit>();

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {
              Get.to(() => AddContentScreen(lesson: lessonDetails));
            },
            child: Text(
              tr("repeat"),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              side: BorderSide(color: circleColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () => deleteAlert(
              deleteTap: () => bloc.deleteLesson(id),
            ),
            child: Text(
              tr("deactive"),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: circleColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final dynamic courseDetailsModel;
  final bool isLesson;

  const CardWidget({
    super.key,
    required this.courseDetailsModel,
    this.isLesson = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: isLesson == true
                    ? CachedImage(
                        imageUrl: courseDetailsModel.provider!.image ?? "",
                        width: screenWidth,
                        height: 130.h,
                        fit: BoxFit.cover,
                      )
                    : CachedImage(
                        imageUrl: courseDetailsModel.provider!.imagePath ?? "",
                        width: screenWidth,
                        height: 130.h,
                        fit: BoxFit.cover,
                      ),
              ),
              Space(boxWidth: 5.w),
              Expanded(
                child: Text(
                  "${courseDetailsModel.provider!.title} ${courseDetailsModel.provider!.firstName} ${courseDetailsModel.provider!.lastName} ",
                  softWrap: true,
                  style: TextStyles.appBarStyle.copyWith(color: black),
                ),
              ),
              Image.asset(
                star,
                height: 15.h,
                fit: BoxFit.contain,
              ),
              const Space(
                boxWidth: 5,
              ),
              Text(
                courseDetailsModel.provider.rate.toString(),
                style: TextStyles.subTitleStyle
                    .copyWith(color: secColor, fontWeight: FontWeight.w700),
              ),
              const Space(
                boxWidth: 5,
              ),
              Text(
                "(${courseDetailsModel.provider.rateCount!} ${tr("rater")})",
                style: TextStyles.smallStyle,
              ),
            ],
          ),
          SizedBox(
            width: screenWidth,
            child: Text(
              "${courseDetailsModel.provider!.bio}",
              softWrap: true,
              style: TextStyles.errorStyle.copyWith(color: grey),
            ),
          ),
        ],
      ),
    );
  }
}
