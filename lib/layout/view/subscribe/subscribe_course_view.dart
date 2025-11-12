import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../bloc/subscribe/subscribe_cubit.dart';
import '../../../model/user/subscriptions/subscribe_course/subscribe_course_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../activity/static/empty_screens/empty_screens.dart';
import '../../activity/user_screens/request/requst_download.dart';
import '../../card_view/current_subject/current_subject_card.dart';
import '../../card_view/subscribe_course/subscribe_course_card.dart';
import 'subscribe_course_cache_view.dart';

class SubscribeCourseView extends StatelessWidget {
  const SubscribeCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<SubscribeCubit>(context)
          ..getSubscriptionCourse(),
        child: BlocConsumer<SubscribeCubit, SubscribeState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<SubscribeCubit, SubscribeState>(
                  builder: (context, state) {
                if (state is LoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is CourseSubscriptionLoadedState) {
                  //final data = state.data;
                  final bloc = SubscribeCubit.get(context);
                  return subscribeCourseView(
                    context: context,
                    data: bloc.subscribeCourseModel!,
                  );
                } else if (state is CourseSubscriptionLoadErrorState) {
                  return const ErrorPage();
                } else {
                  return const SubscribeCourseCacheView();
                }
              });
            }));
  }

  subscribeCourseView({
    required BuildContext context,
    required SubscribeCourseModel data,
  }) {
    final bloc = SubscribeCubit.get(context);
    // bloc.initCourse(data);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.liveSubscription!.isEmpty
              ? const SizedBox()
              : const Space(
                  boxHeight: 20,
                ),
          data.liveSubscription!.isEmpty
              ? const SizedBox()
              : SidePadding(
                  sidePadding: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(tr("current"),
                          textAlign: TextAlign.start,
                          style: TextStyles.unselectedStyle.copyWith(
                              color: mainColor, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
          bloc.subscribeCourseModel!.liveSubscription!.isEmpty ||
                  bloc.subscribeCourseModel!.liveSubscription == null
              ? const SizedBox()
              : CustomList(
                  listHeight: 100000000000000,
                  listWidth: screenWidth,
                  scroll: const NeverScrollableScrollPhysics(),
                  axis: Axis.vertical,
                  count: bloc.subscribeCourseModel!.liveSubscription!.length,
                  child: (context, index) => Column(
                        children: [
                          CurrentSubjectCard(
                            currentTimeId: bloc.subscribeCourseModel!
                                .liveSubscription![index].currentTimeId,
                            type: "course",
                            isLive: bloc.subscribeCourseModel!
                                        .liveSubscription![index].course.type ==
                                    1
                                ? false
                                : true,
                            image: bloc.subscribeCourseModel!
                                .liveSubscription![index].course.image!,
                            id: bloc.subscribeCourseModel!
                                .liveSubscription![index].course.id!,
                            courseTitle: bloc.subscribeCourseModel!
                                .liveSubscription![index].course.name!,
                            price: bloc.subscribeCourseModel!
                                .liveSubscription![index].course.price,
                            name:
                                "${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.title!} ${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.firstName!} ${bloc.subscribeCourseModel!.liveSubscription![index].course.provider.lastName!}",
                          ),
                          const Space(
                            boxHeight: 15,
                          ),
                        ],
                      )),
          data.subscriptions.isEmpty
              ? SizedBox(
                  width: screenWidth,
                  height: screenHeight * 2 / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      EmptyScreen(
                        title: tr("no_subscriptions"),
                        image: emptyCurrent,
                        width: screenWidth,
                        height: 300.h,
                        color: mainColor.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                )
              : SidePadding(
                  sidePadding: 15,
                  child: Text(tr("courses"),
                      textAlign: TextAlign.start,
                      style: TextStyles.unselectedStyle.copyWith(
                          color: blackColor, fontWeight: FontWeight.w700)),
                ),
          CustomList(
              listHeight: 100000000000000,
              listWidth: screenWidth,
              scroll: const NeverScrollableScrollPhysics(),
              axis: Axis.vertical,
              count: data.subscriptions.length,
              child: (context, index) => Column(

                    children: [
                      const Space(
                        boxHeight: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => RequsetAndDownload(
                              data: data.subscriptions[index]));
                        },
                        child: SubscribeCourseCard(
                          image: data.subscriptions[index].course.image,
                          id: data.subscriptions[index].course.id!,
                          courseTitle: data.subscriptions[index].course.name!,
                          price: data.subscriptions[index].course.price,
                          providerName:
                              "${data.subscriptions[index].course.provider.title!} ${data.subscriptions[index].course.provider.firstName!} ${data.subscriptions[index].course.provider.lastName!}",
                          status: data.subscriptions[index].course.type == 1
                              ? tr("offline")
                              : data.subscriptions[index].course.type == 2
                                  ? tr("live")
                                  : tr("online"),
                          finishPercent: 0.5,
                        ),
                      ),
                      const Space(
                        boxHeight: 15,
                      ),
                    ],
                  ))
        ],
      ),
    );
  }
}
