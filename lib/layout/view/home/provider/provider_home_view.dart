import 'package:card_swiper/card_swiper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/widget/headers/home/home_header.dart';

import '../../../../../widget/error/page/error_page.dart';
import '../../../../bloc/cities/cities_cubit.dart';
import '../../../../bloc/home/home_cubit.dart';
import '../../../../bloc/nations/nations_cubit.dart';
import '../../../../model/provider/home/home_db_response.dart';
import '../../../../repository/provider/home/home_repository.dart';
import '../../../../res/drawable/image/images.dart';
import '../../../../res/value/color/color.dart';
import '../../../../res/value/dimenssion/dimenssions.dart';
import '../../../../res/value/style/textstyles.dart';
import '../../../../widget/row_title/master_row.dart';
import '../../../../widget/space/space.dart';
import '../../../activity/provider_screens/all_course/all_courses_screen.dart';
import '../../../activity/provider_screens/all_subject/all_subject_screen.dart';
import '../../../activity/static/empty_screens/empty_screens.dart';
import '../../../card_view/provider_course/provider_course_card.dart';
import '../../../card_view/provider_current/provider_current_card.dart';
import '../../../card_view/provider_subject/provider_subject_card.dart';
import 'provider_home_cache_view.dart';

class ProviderHomeView extends StatefulWidget {
  const ProviderHomeView({super.key});

  @override
  State<ProviderHomeView> createState() => _ProviderHomeViewState();
}

class _ProviderHomeViewState extends State<ProviderHomeView> {
  @override
  void initState() {
    super.initState();

    context.read<CitiesCubit>().getCitiesInSplash();
    context.read<NationsCubit>().getNationsInSplash();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            HomeCubit(HomeRepository())..getHome(),
        child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                if (state is HomeLoadedState && state.data != null) {
                  final data = (state).data;
                  return homeView(context, data);
                } else if (state is HomeLoadErrorState) {
                  return const ErrorPage();
                } else {
                  return const HomeCacheView();
                }
              });
            }));
  }

  Widget homeView(BuildContext context, HomeDbResponse? data) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30.h, bottom: 20),
          decoration: const BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: HomeHeader(
            isNotify: false,
            isUser: false,
            data: data,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Space(boxHeight: 20),
                      SizedBox(
                        height: 150.sp,
                        child: Swiper(
                          autoplay: true,
                          itemCount: images.length,
                          itemBuilder: (context, index) => ClipRRect(
                            // padding: EdgeInsets.symmetric(horizontal: 5.sp),
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              images[index],
                              width: screenWidth,
                              // height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          viewportFraction: 1,
                          scale: 0.9,
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        tr("request"),
                        style: TextStyles.titleStyle.copyWith(color: mainColor),
                      ),
                      const Space(boxHeight: 10),
                      data!.data.currentAction == null ||
                              data.data.currentAction!.item == null
                          ? EmptyScreen(
                              title: tr("no_current"),
                              image: emptyCurrent,
                              width: screenWidth,
                              height: 170.h,
                            )
                          : ProviderCurrentCard(data: data.data.currentAction),
                      const Space(boxHeight: 30),
                      MasterRow(
                        title: tr("t_courses"),
                        subTitle: tr("view_all_c"),
                        onTap: () => Get.to(() => const ProviderCourseScreen()),
                      ),
                      const Space(boxHeight: 10),
                      data.data.courses?.isEmpty ?? true
                          ? EmptyScreen(
                              title: tr("no_course"),
                              image: emptyCurrent,
                              width: screenWidth,
                              height: 170.h,
                              color: mainColor.withValues(alpha: 0.3),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 10.h),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.w,
                                      mainAxisSpacing: 10.h,
                                      mainAxisExtent: 200.sp),
                              itemCount: data.data.courses!.length,
                              itemBuilder: (context, index) =>
                                  ProviderCourseCard(
                                      data: data.data.courses![index]),
                            ),
                      const Space(boxHeight: 10),
                      MasterRow(
                        title: tr("courses_offered"),
                        subTitle: tr("view_all_l"),
                        onTap: () =>
                            Get.to(() => const ProviderSubjectScreen()),
                      ),
                      const Space(boxHeight: 10),
                      data.data.lessons?.isEmpty ?? true
                          ? EmptyScreen(
                              title: tr("no_lesson"),
                              image: emptyCurrent,
                              width: screenWidth,
                              height: 170.h,
                              color: mainColor.withValues(alpha: 0.3),
                            )
                          : ListView.builder(
                              itemCount: data.data.lessons!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: ProviderSubjectCard(
                                    data: data.data.lessons?[index] ,
                                ),
                              ),
                            ),
                      const Space(boxHeight: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List<String> images = [
  "assets/images/banner_image.jpeg",
  "assets/images/banner_2.jpeg",
];
