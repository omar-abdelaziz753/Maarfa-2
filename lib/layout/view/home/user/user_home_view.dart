import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/view/home/user/all_teachers.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_cubit.dart';
import 'package:my_academy/layout/view/home/user/data/cubit/home_state.dart';
import 'package:my_academy/layout/view/home/user/data/models/get_all_best_teachers_data_model.dart';
import 'package:my_academy/layout/view/home/user/teacher_details/teacher_details_screen.dart';
import 'package:my_academy/layout/view/home/user/view_all_specialization_screen.dart';
import 'package:my_academy/layout/view/home/user/view_all_teachers.dart';
import 'package:my_academy/model/common/search/search_db_response.dart';
import 'package:my_academy/widget/headers/home/home_header.dart';

import '../../../../bloc/cities/cities_cubit.dart';
import '../../../../bloc/home/home_cubit.dart';
import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../bloc/subscribe/subscribe_cubit.dart';
import '../../../../repository/provider/home/home_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/error/page/error_page.dart';
import '../../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../../widget/master_list/custom_list.dart';
import '../../../../widget/search_home_widget/search_home_widget.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/user_screens/course/course_screen.dart';
import '../../../activity/user_screens/grade/grade_screen.dart';
import '../../../activity/user_screens/offers/offers_screen.dart';
import '../../../card_view/current_subject/current_subject_card.dart';
import '../../../card_view/home/home_card.dart';
import '../../home/user/user_home_cache_view.dart';
import 'data/models/get_teacher_details_data_model.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  @override
  void initState() {
    super.initState();

    context.read<CitiesCubit>().getCitiesInSplash();
    context.read<NationsCubit>().getNationsInSplash();
    context.read<Home2Cubit>().getAllBestTeachers();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
  create: (context) => Home2Cubit()..getAllBestTeachers(),
  child: BlocProvider(
        create: (BuildContext context) =>
            HomeCubit(HomeRepository())..getClientHome(),
        child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                if (state is SliderLoadedState) {
                  final data = (state).data;
                  return profileView(
                    context,
                    data,
                  );

                  // return CurrentSubjectCard(isLive: userCurrentAction.item, type: userCurrentAction.type??"", courseTitle: userCurrentAction.item.title, name: name, price: price, id: id);
                } else if (state is SliderErrorState) {
                  return const ErrorPage();
                } else {
                  return const UserHomeCacheView();
                }
              });
            })),
);
  }

  profileView(context, data) {
    return ListView(
      children: [
        const Space(
          boxHeight: 25,
        ),
        HomeHeader(
          isUser: true,
          data: data,
        ),
        const Space(
          boxHeight: 25,
        ),
        const SearchHomeWidget(),
        const Space(
          boxHeight: 15,
        ),
        BlocProvider.value(
          value: BlocProvider.of<SubscribeCubit>(context)
            ..getSubscriptionCourseHome()
            ..getSubscriptionLessonHome(),
          child: BlocBuilder<SubscribeCubit, SubscribeState>(
            builder: (context, susState) {
              final bloc = SubscribeCubit.get(context);

              return Column(
                children: [
                  if ((bloc.subscribeCourseModel != null &&
                          bloc.subscribeCourseModel!.liveSubscription!
                              .isNotEmpty) ||
                      (bloc.subscribeSubjectModel != null &&
                          bloc.subscribeSubjectModel!.liveSubscription
                              .isNotEmpty))
                    susState is SubjectSubscriptionLoadedState
                        ? CustomList(
                            listHeight: 100000000000000,
                            listWidth: screenWidth,
                            scroll: const NeverScrollableScrollPhysics(),
                            axis: Axis.vertical,
                            count: bloc
                                .subscribeSubjectModel!.liveSubscription.length,
                            child: (context, index) => Column(
                                  children: [
                                    CurrentSubjectCard(
                                      currentTimeId: bloc
                                          .subscribeSubjectModel!
                                          .liveSubscription[index]
                                          .currentTimeId,
                                      type: "lesson",
                                      isLive: true,
                                      id: bloc.subscribeSubjectModel!
                                          .liveSubscription[index].lesson.id,
                                      courseTitle: bloc
                                          .subscribeSubjectModel!
                                          .liveSubscription[index]
                                          .lesson
                                          .subject!
                                          .name!,
                                      price: bloc
                                          .subscribeSubjectModel!
                                          .liveSubscription[index]
                                          .lesson
                                          .hourPrice!,
                                      name:
                                          "${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.title!} ${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.firstName!} ${bloc.subscribeSubjectModel!.liveSubscription[index].lesson.provider.lastName!}",
                                    ),
                                    const Space(
                                      boxHeight: 15,
                                    ),
                                  ],
                                ))
                        : CustomList(
                            listHeight: 100000000000000,
                            listWidth: screenWidth,
                            scroll: const NeverScrollableScrollPhysics(),
                            axis: Axis.vertical,
                            count: bloc
                                .subscribeCourseModel!.liveSubscription!.length,
                            child: (context, index) => Column(
                                  children: [
                                    CurrentSubjectCard(
                                      currentTimeId: bloc
                                          .subscribeCourseModel!
                                          .liveSubscription![index]
                                          .currentTimeId,
                                      type: "course",
                                      isLive: bloc
                                                  .subscribeCourseModel!
                                                  .liveSubscription![index]
                                                  .course
                                                  .type ==
                                              1
                                          ? false
                                          : true,
                                      image: bloc
                                          .subscribeCourseModel!
                                          .liveSubscription![index]
                                          .course
                                          .image!,
                                      id: bloc.subscribeCourseModel!
                                          .liveSubscription![index].course.id!,
                                      courseTitle: bloc
                                          .subscribeCourseModel!
                                          .liveSubscription![index]
                                          .course
                                          .name!,
                                      price: bloc
                                          .subscribeCourseModel!
                                          .liveSubscription![index]
                                          .course
                                          .price,
                                      name:
                                          "${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.title!} ${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.firstName!} ${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.lastName!}",
                                    ),
                                    const Space(
                                      boxHeight: 15,
                                    ),
                                  ],
                                )),
                  SizedBox(
                    width: screenWidth,
                    height: 245.h,
                    child: Swiper(
                      autoplay: true,
                      itemCount: data.data.offers!.length,
                      viewportFraction: 0.9,
                      scale: 0.92,
                      pagination: SwiperPagination(
                        margin: const EdgeInsets.only(bottom: 8),
                        builder: DotSwiperPaginationBuilder(
                          color: mainColor.withOpacity(0.2),
                          activeColor: accentColor,
                          size: 6.0,
                          activeSize: 8.0,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final offer = data.data.offers![index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(16.r),
                          onTap: () => Get.to(() => const OffersScreen()),
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Top Image
                                  Expanded(
                                    child: CachedImage(
                                      imageUrl: offer.image!,
                                      fit: BoxFit.fill,
                                      width: screenWidth,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Offer Title
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      offer.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.textView16SemiBold
                                          .copyWith(
                                        color: cvColor,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // Offer Description
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      offer.content!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyles.hintStyle
                                          .copyWith(fontSize: 13.sp),
                                    ),
                                  ),

                                  // const Spacer(),

                                  // CTA Button (Optional)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16.0,
                                        bottom: 12.0,
                                        top: 8),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "View Details →",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )

                  // SizedBox(
                  //   width: screenWidth,
                  //   height: 260.h,
                  //   child: Swiper(
                  //     autoplay: true,
                  //     itemCount: data.data.offers!.length,
                  //     itemBuilder: (context, index) => InkWell(
                  //       onTap: () => Get.to(() => const OffersScreen()),
                  //       child: Container(
                  //           clipBehavior: Clip.antiAliasWithSaveLayer,
                  //           decoration: BoxDecoration(
                  //               color: white,
                  //               borderRadius: BorderRadius.circular(10.r)),
                  //           height: 250.h,
                  //           width: screenWidth,
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Material(
                  //                 borderRadius: BorderRadius.circular(15.r),
                  //                 elevation: 0.5,
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(15.r),
                  //                   child: CachedImage(
                  //                     imageUrl: data.data.offers![index].image!,
                  //                     width: screenWidth,
                  //                     height: 150,
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //               ),
                  //               const Space(boxHeight: 10),
                  //               SidePadding(
                  //                 sidePadding: 15,
                  //                 child: Text(data.data.offers![index].name!,
                  //                     style: TextStyles.textView14SemiBold
                  //                         .copyWith(color: cvColor)),
                  //               ),
                  //               SidePadding(
                  //                 sidePadding: 15,
                  //                 child: Text(data.data.offers![index].content!,
                  //                     maxLines: 2,
                  //                     softWrap: true,
                  //                     overflow: TextOverflow.clip,
                  //                     style: TextStyles.hintStyle),
                  //               ),
                  //             ],
                  //           )),
                  //     ),
                  //     viewportFraction: 0.9,
                  //     scale: .90,
                  //     pagination: SwiperPagination(
                  //       margin: const EdgeInsets.only(bottom: 5),
                  //       builder: DotSwiperPaginationBuilder(
                  //           color: mainColor.withOpacity(0.1),
                  //           activeColor: accentColor),
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          ),
        ),
        const Space(
          boxHeight: 15,
        ),

        /// Best Teachers
        // Row(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 18.h),
        //       child: Text(
        //         tr("best_teachers"),
        //         style: TextStyles.titleStyle.copyWith(color: black),
        //       ),
        //     ),
        //     const Spacer(),
        //     TextButton(
        //       onPressed: () {
        //         Get.to(() => const ViewAllSpecializationScreen());
        //       },
        //       // onPressed: () => Get.to(() => const TeachersScreen()),
        //       child: Text(
        //         tr("view_all"),
        //         style: TextStyles.hintStyle.copyWith(
        //           decoration: TextDecoration.underline,
        //           fontWeight: FontWeight.w700,
        //           decorationColor: grey,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const Space(
        //   boxHeight: 15,
        // ),
        // BestTeachersCard(
        //   teachers: [
        //     // TeacherModel(
        //     //   name: "John Doe",
        //     //   imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
        //     //   subject: "Mathematics",
        //     //   rating: 4.5,
        //     // ),
        //     // TeacherModel(
        //     //   name: "Jane Smith",
        //     //   imageUrl: "https://randomuser.me/api/portraits/women/2.jpg",
        //     //   subject: "Physics",
        //     //   rating: 4.8,
        //     // ),
        //     // TeacherModel(
        //     //   name: "Mark Johnson",
        //     //   imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
        //     //   subject: "Chemistry",
        //     //   rating: 4.6,
        //     // ),
        //   ],
        // ),
        /// Best Teachers
        BlocProvider(
          create: (BuildContext context) => Home2Cubit()..getAllBestTeachers(),
          child: BlocBuilder<Home2Cubit, Home2State>(
            builder: (context, state) {
              if (state is GetAllBestTeachersLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is GetAllBestTeachersErrorState) {
                return Center(
                  child: Text('Error: ${state.errorMessage}'),
                );
              }

              final cubit = context.read<Home2Cubit>();
              print('--------------------------');
              print(cubit.bestTeachers);
              print('--------------------------');

              return BestTeachersCard(
                teachers: cubit.bestTeachers,
                onSeeAll: () {
                  // Navigate to all teachers screen
                  Get.to(() => const ViewAllSpecializationScreen());
                },
                onTeacherTap: (teacher) {
                  // Navigate to teacher details screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherDetailsScreen(teacherId: teacher.id.toString())));
                },
              );
            },
          ),
        ),

        const Space(
          boxHeight: 15,
        ),
        RightHomeCard(
          title: tr("need_subject"),
          buttonText: tr("grades"),
          image: onlineSubject,
          subTitle: tr("subject_available"),
          onTap: () => Get.to(() => const GradeScreen()),
        ),
        LeftHomeCard(
          title: tr("need_course"),
          buttonText: tr("courses"),
          image: course,
          subTitle: tr("course_available"),
          onTap: () => Get.to(() => const CourseScreen()),
        ),
        const Space(
          boxHeight: 50,
        ),
      ],
    );
  }
}

// class BestTeachersCard extends StatelessWidget {
//   final List<TeacherModel> teachers;
//
//   const BestTeachersCard({super.key, required this.teachers});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 210.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         itemCount: teachers.length,
//         separatorBuilder: (_, __) => SizedBox(width: 12.w),
//         itemBuilder: (context, index) {
//           final teacher = teachers[index];
//           return GestureDetector(
//             onTap: () {
//               // Navigate to detail screen or perform action
//               // Get.to(() => TeacherDetailScreen(teacher: teacher));
//             },
//             child: Container(
//               width: 150.w,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Image
//                   ClipRRect(
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
//                     child: CachedNetworkImage(
//                       imageUrl: teacher.imageUrl,
//                       width: 150.w,
//                       height: 100.h,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) => const Icon(Icons.error),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           teacher.name,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyles.textView14SemiBold.copyWith(color: black),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           teacher.subject,
//                           style: TextStyles.hintStyle.copyWith(fontSize: 12.sp),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(Icons.star, size: 14.sp, color: Colors.amber),
//                             SizedBox(width: 4.w),
//                             Text(
//                               teacher.rating.toStringAsFixed(1),
//                               style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


class BestTeachersCard extends StatelessWidget {
  final List<ProvidersMM> teachers;
  final VoidCallback? onSeeAll;
  final Function(ProvidersMM)? onTeacherTap;

  const BestTeachersCard({
    super.key,
    required this.teachers,
    this.onSeeAll,
    this.onTeacherTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTeachersList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            tr("best_teachers"),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              tr('view_all'),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTeachersList(BuildContext context) {
    if (teachers.isEmpty) {
      return _buildEmptyState(context);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = _getCardWidth(screenWidth);
    final cardHeight = _getCardHeight(screenWidth);

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          return _buildTeacherCard(teachers[index], cardWidth);
        },
      ),
    );
  }

  double _getCardWidth(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: Card takes most of screen width minus margins
      return screenWidth * 0.5;
    } else if (screenWidth < 1200) {
      // Tablet: Smaller cards to show more
      return screenWidth * 0.35;
    } else {
      // Desktop: Fixed max width
      return 320;
    }
  }

  double _getCardHeight(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile: Taller cards
      // return 380.h;
      return 230.h;
      // return 260.h;
    } else if (screenWidth < 1200) {
      // Tablet: Medium height
      return 200.h;
      // return 230.h;
      // return 350.h;
    } else {
      // Desktop: Compact height
      return 170.h;
      // return 200.h;
      // return 320;
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: _getCardHeight(screenWidth),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: screenWidth < 600 ? 48 : 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: screenWidth < 600 ? 12 : 16),
          Text(
            'No teachers available',
            style: TextStyle(
              fontSize: screenWidth < 600 ? 14 : 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(ProvidersMM teacher, double cardWidth) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTeacherTap?.call(teacher),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTeacherImage(teacher, cardWidth),
                _buildTeacherInfo(teacher, cardWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherImage(ProvidersMM teacher, double cardWidth) {
    // Image height is proportional to card width
    final imageHeight = cardWidth * 0.5;

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          children: [
            // Teacher Image
            teacher.imagePath != null && teacher.imagePath!.isNotEmpty
                ? Image.network(
              teacher.imagePath!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return _buildAvatarFallback(teacher, cardWidth);
              },
            )
                : _buildAvatarFallback(teacher, cardWidth),

            // Rating Badge
            if (teacher.rate != null && teacher.rate! > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        teacher.rate.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(ProvidersMM teacher, double cardWidth) {
    // Font size scales with card width
    final fontSize = (cardWidth * 0.12).clamp(24.0, 40.0);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade300,
            Colors.purple.shade300,
          ],
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(teacher),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherInfo(ProvidersMM teacher, double cardWidth) {
    // Font sizes scale with card width
    final nameFontSize = (cardWidth * 0.06).clamp(16.0, 20.0);
    final titleFontSize = (cardWidth * 0.04).clamp(12.0, 14.0);
    final specializationFontSize = (cardWidth * 0.035).clamp(11.0, 13.0);
    final ratingFontSize = (cardWidth * 0.045).clamp(13.0, 15.0);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(cardWidth * 0.05), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher Name
            Text(
              _getFullName(teacher),
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: cardWidth * 0.015),

            // Title and Degree
            if (teacher.title != null || teacher.degree != null)
              Text(
                '${teacher.title ?? ''} ${teacher.degree ?? ''}'.trim(),
                style: TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

            SizedBox(height: cardWidth * 0.03),

            // Specialization
            if (teacher.specialization != null && teacher.specialization!.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: cardWidth * 0.035,
                  vertical: cardWidth * 0.015,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  teacher.specialization!,
                  style: TextStyle(
                    fontSize: specializationFontSize,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // const Spacer(),
            //
            // // Rating Section
            // if (teacher.rate != null && teacher.rateCount != null)
            //   Container(
            //     padding: EdgeInsets.symmetric(vertical: cardWidth * 0.02),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.star,
            //           color: Colors.amber[600],
            //           size: ratingFontSize,
            //         ),
            //         SizedBox(width: cardWidth * 0.01),
            //         Text(
            //           '${teacher.rate}',
            //           style: TextStyle(
            //             fontSize: ratingFontSize,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.black87,
            //           ),
            //         ),
            //         SizedBox(width: cardWidth * 0.01),
            //         Expanded(
            //           child: Text(
            //             '(${teacher.rateCount} reviews)',
            //             style: TextStyle(
            //               fontSize: titleFontSize,
            //               color: Colors.grey[600],
            //             ),
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  String _getFullName(ProvidersMM teacher) {
    final firstName = teacher.firstName ?? '';
    final lastName = teacher.lastName ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Teacher' : fullName;
  }

  String _getInitials(ProvidersMM teacher) {
    final firstName = teacher.firstName ?? '';
    final lastName = teacher.lastName ?? '';
    String initials = '';

    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }

    return initials.isEmpty ? 'T' : initials;
  }
}

// Updated BestTeachersCard widget that works with your API data
// class BestTeachersCard extends StatelessWidget {
//   final List<ProvidersMM> teachers;
//   final VoidCallback? onSeeAll;
//   final Function(ProvidersMM)? onTeacherTap;
//
//   const BestTeachersCard({
//     super.key,
//     required this.teachers,
//     this.onSeeAll,
//     this.onTeacherTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(context),
//           const SizedBox(height: 16),
//           _buildTeachersList(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           'Best Teachers',
//           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         if (onSeeAll != null)
//           TextButton(
//             onPressed: onSeeAll,
//             child: Text(
//               'View All', // Replace with tr('view_all') if using easy_localization
//               style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildTeachersList() {
//     if (teachers.isEmpty) {
//       return _buildEmptyState();
//     }
//
//     return SizedBox(
//       // height: 320, // Increased height for better content display
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         itemCount: teachers.length,
//         itemBuilder: (context, index) {
//           return _buildTeacherCard(teachers[index]);
//         },
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Container(
//       height: 320,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.school_outlined,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No teachers available',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeacherCard(ProvidersMM teacher) {
//     return Container(
//       width: 300, // Slightly increased width
//       margin: const EdgeInsets.only(right: 16),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => onTeacherTap?.call(teacher),
//           borderRadius: BorderRadius.circular(16),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildTeacherImage(teacher),
//                 _buildTeacherInfo(teacher),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTeacherImage(ProvidersMM teacher) {
//     return Container(
//       height: 160, // Increased height
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       child: ClipRRect(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//         child: Stack(
//           children: [
//             // Teacher Image
//             teacher.imagePath != null && teacher.imagePath!.isNotEmpty
//                 ? Image.network(
//               teacher.imagePath!,
//               width: double.infinity,
//               height: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 return _buildAvatarFallback(teacher);
//               },
//             )
//                 : _buildAvatarFallback(teacher),
//
//             // Rating Badge
//             if (teacher.rate != null && teacher.rate! > 0)
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.7),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                         size: 12,
//                       ),
//                       const SizedBox(width: 2),
//                       Text(
//                         teacher.rate.toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAvatarFallback(ProvidersMM teacher) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Colors.blue.shade300,
//             Colors.purple.shade300,
//           ],
//         ),
//       ),
//       child: Center(
//         child: Text(
//           _getInitials(teacher),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 36,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTeacherInfo(ProvidersMM teacher) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Teacher Name
//             Text(
//               _getFullName(teacher),
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//
//             const SizedBox(height: 6),
//
//             // Title and Degree
//             if (teacher.title != null || teacher.degree != null)
//               Text(
//                 '${teacher.title ?? ''} ${teacher.degree ?? ''}'.trim(),
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//
//             const SizedBox(height: 12),
//
//             // Specialization
//             if (teacher.specialization != null && teacher.specialization!.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.blue.shade200),
//                 ),
//                 child: Text(
//                   teacher.specialization!,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.blue.shade700,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//
//             const Spacer(),
//
//             // Rating Section
//             if (teacher.rate != null && teacher.rateCount != null)
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.star,
//                       color: Colors.amber[600],
//                       size: 16,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${teacher.rate}',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '(${teacher.rateCount} reviews)',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getFullName(ProvidersMM teacher) {
//     final firstName = teacher.firstName ?? '';
//     final lastName = teacher.lastName ?? '';
//     final fullName = '$firstName $lastName'.trim();
//     return fullName.isEmpty ? 'Teacher' : fullName;
//   }
//
//   String _getInitials(ProvidersMM teacher) {
//     final firstName = teacher.firstName ?? '';
//     final lastName = teacher.lastName ?? '';
//     String initials = '';
//
//     if (firstName.isNotEmpty) {
//       initials += firstName[0].toUpperCase();
//     }
//     if (lastName.isNotEmpty) {
//       initials += lastName[0].toUpperCase();
//     }
//
//     return initials.isEmpty ? 'T' : initials;
//   }
// }