// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:my_academy/layout/card_view/share_live_bottom_sheet/share_live_link_bottom_sheet.dart';

// import '../../../bloc/live/live_cubit.dart';
// import '../../../models/provider/home/home_db_response.dart';
// import '../../../repository/live/live_repository.dart';
// import '../../../res/drawable/icon/icons.dart';
// import '../../../res/value/color/color.dart';
// import '../../../res/value/dimenssion/dimenssions.dart';
// import '../../../res/value/style/textstyles.dart';
// import '../../../widget/loader/loader.dart';
// import '../../../widget/logo/logo/logo.dart';
// import '../../../widget/side_padding/side_padding.dart';
// import '../../../widget/space/space.dart';

// class ProviderCurrentCard extends StatelessWidget {
//   final CurrentAction? data;
//   const ProviderCurrentCard({super.key, this.data});
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) => LiveCubit(LiveRepository()),
//         child: BlocConsumer<LiveCubit, LiveState>(
//             listener: (context, state) {},
//             builder: (context, state) {
//               final bloc = LiveCubit.get(context);
//               return SidePadding(
//                 sidePadding: 15,
//                 child: Container(
//                   height: 170.h,
//                   width: screenWidth,
//                   decoration: BoxDecoration(
//                     // color: white,
//                     borderRadius: BorderRadius.circular(5.r),
//                     border: Border.all(
//                       color: textfieldColor,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Space(
//                         boxHeight: 15,
//                       ),
//                       SidePadding(
//                         sidePadding: 5,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Container(
//                               clipBehavior: Clip.antiAliasWithSaveLayer,
//                               width: 80.w,
//                               height: 70.h,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5.r)),
//                               child: data!.type == "lesson"
//                                   ? const Logo(
//                                       logoHeight: 50,
//                                       logoWidth: 50,
//                                     )
//                                   : CachedNetworkImage(
//                                       imageUrl: data!.item!.image ?? "",
//                                       width: 80.w,
//                                       height: 70.h,
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) => const Logo(
//                                             logoHeight: 50,
//                                             logoWidth: 50,
//                                           )),
//                             ),
//                             const Space(
//                               boxWidth: 10,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   width: screenWidth / 2,
//                                   child: Text(
//                                       data!.type == "lesson"
//                                           ? data!.item!.subject!.name
//                                           : data!.item!.name ?? "",
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyles.appBarStyle.copyWith(
//                                           color: blackColor,
//                                           fontWeight: FontWeight.bold)),
//                                 ),
//                                 Text(
//                                     data!.type == "lesson"
//                                         ? tr("subject")
//                                         : tr("course"),
//                                     style: TextStyles.subTitleStyle),
//                                 const Space(
//                                   boxWidth: 10,
//                                 ),
//                                 SizedBox(
//                                   width: screenWidth / 1.8,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Image.asset(tableCells,
//                                           height: 15.h, fit: BoxFit.contain),
//                                       const Space(
//                                         boxWidth: 5,
//                                       ),
//                                       Text(
//                                           data!.item!.nextTime == ""
//                                               ? DateFormat("yyyy-MM-dd").format(
//                                                   DateTime.parse(DateTime.now()
//                                                       .toString()))
//                                               : DateFormat("yyyy-MM-dd HH:mm")
//                                                   .format(DateTime.parse(data!
//                                                       .item!.nextTime
//                                                       .toString())),
//                                           style: TextStyles.hintStyle),
//                                       const Spacer(),
//                                       Text("#${data!.item!.id}",
//                                           style: TextStyles.hintStyle),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       bloc.isLoad
//                           ? const Loading()
//                           : data!.type == "lesson"
//                               ? Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: InkWell(
//                                           onTap: () => bloc.enterLive(
//                                               true, data!.item!.id, data!.type!,
//                                               timeId: data!.timeId!),
//                                           child: Container(
//                                             width: screenWidth,
//                                             height: 40.h,
//                                             color: mainLightColor,
//                                             child: Center(
//                                                 child: Text(tr("enter_lesson"),
//                                                     style: TextStyles
//                                                         .unselectedStyle
//                                                         .copyWith(
//                                                             color: white,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w700))),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(
//                                         width: 12,
//                                       ),
//                                       _getShareIcon(context, data!),
//                                     ],
//                                   ),
//                                 )
//                               : data!.item.type == 1
//                                   ? const SizedBox()
//                                   : Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: InkWell(
//                                               onTap: () => bloc.enterLive(true,
//                                                   data!.item!.id, data!.type!,
//                                                   timeId: data!.timeId!),
//                                               child: Container(
//                                                 width: screenWidth,
//                                                 height: 40.h,
//                                                 color: mainLightColor,
//                                                 child: Center(
//                                                     child: Text(
//                                                         tr("enter_lesson"),
//                                                         style: TextStyles
//                                                             .unselectedStyle
//                                                             .copyWith(
//                                                                 color: white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700))),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 12,
//                                           ),
//                                           _getShareIcon(context, data!),
//                                         ],
//                                       ),
//                                     ),
//                     ],
//                   ),
//                 ),
//               );
//             }));
//   }

//   Widget _getShareIcon(BuildContext context, CurrentAction data) {
//     return InkWell(
//       onTap: () {
//         ShareLiveLinkBottomSheet.open(context,
//             type: data.type!, id: data.item!.id, timeId: data.timeId!);
//       },
//       child: Container(
//         height: 40.h,
//         width: 40.h,
//         padding: const EdgeInsets.all(6),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4), color: mainLightColor),
//         child: FittedBox(
//           fit: BoxFit.scaleDown,
//           child: Icon(
//             Icons.share,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/live/live_cubit.dart';
import '../../../model/provider/home/home_db_response.dart';
import '../../../repository/live/live_repository.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/logo/logo/logo.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../card_view/share_live_bottom_sheet/share_live_link_bottom_sheet.dart';

class ProviderCurrentCard extends StatelessWidget {
  final CurrentAction? data;

  const ProviderCurrentCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveCubit(LiveRepository()),
      child: BlocConsumer<LiveCubit, LiveState>(
        listener: (_, __) {},
        builder: (context, state) {
          final bloc = LiveCubit.get(context);
          final isLesson = data?.type == "lesson";
          final item = data!.item;

          return SidePadding(
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: isLesson
                            ? const Logo(logoHeight: 60, logoWidth: 60)
                            : CachedNetworkImage(
                                imageUrl: item?.image ?? "",
                                width: 80.w,
                                height: 70.h,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const Logo(
                                  logoHeight: 60,
                                  logoWidth: 60,
                                ),
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isLesson ? item!.subject!.name : item!.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.titleStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              isLesson ? tr("subject") : tr("course"),
                              style: TextStyles.subTitleStyle,
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                Image.asset(tableCells, height: 14.h),
                                SizedBox(width: 5),
                                Text(
                                  item!.nextTime == ""
                                      ? DateFormat("yyyy-MM-dd")
                                          .format(DateTime.now())
                                      : DateFormat("yyyy-MM-dd HH:mm").format(
                                          DateTime.parse(item.nextTime!)),
                                  style: TextStyles.hintStyle,
                                ),
                                Spacer(),
                                Text("#${item.id}",
                                    style: TextStyles.hintStyle),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (bloc.isLoad)
                    const Loading()
                  else if (isLesson || item!.type != 1)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainLightColor,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              bloc.enterLive(true, item!.id, data!.type!,
                                  timeId: data!.timeId!);
                            },
                            child: Text(
                              tr("enter_lesson"),
                              // style: TextStyles.buttonStyle.copyWith(color: white),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _getShareIcon(context, data!),
                      ],
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getShareIcon(BuildContext context, CurrentAction data) {
    return InkWell(
      onTap: () {
        ShareLiveLinkBottomSheet.open(
          context,
          type: data.type!,
          id: data.item!.id,
          timeId: data.timeId!,
        );
      },
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          color: mainLightColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Icon(Icons.share, color: Colors.white, size: 20),
      ),
    );
  }
}
