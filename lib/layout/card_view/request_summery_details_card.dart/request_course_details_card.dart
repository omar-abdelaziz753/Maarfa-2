import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/pay/pay_cubit.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class RequstCourseDetailsCard extends StatefulWidget {
  const RequstCourseDetailsCard({super.key, required this.courseDetailsModel});

  final dynamic courseDetailsModel;

  @override
  State<RequstCourseDetailsCard> createState() =>
      _RequstCourseDetailsCardState();
}

class _RequstCourseDetailsCardState extends State<RequstCourseDetailsCard> {
  final TextEditingController couponController = TextEditingController();

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String hourPrice = (double.parse(
                widget.courseDetailsModel.priceWithoutTax.replaceAll(",", "")) /
            double.parse(widget.courseDetailsModel.numberOfHours!.toString()))
        .toStringAsFixed(2);
    return BlocConsumer<PayCubit, PayState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = context.read<PayCubit>();

        final priceText = state is MakeCouponSuccessState
            ? cubit.couponResponseDataModel!.data!.finalPrice.toString()
            : widget.courseDetailsModel!.priceWithoutTax!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    child: Image.asset(course)),
                const Space(
                  boxWidth: 10,
                ),
                Expanded(
                  child: Text(widget.courseDetailsModel.name!,
                      // "حصص جماعية فى فن إدارة الاعمال و التطور للمبتدئين",
                      style: TextStyles.appBarStyle.copyWith(
                          color: blackColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("course"),
                  style: TextStyles.errorStyle.copyWith(color: mainColor),
                ),
                Text(
                  widget.courseDetailsModel.type == 1
                      ? tr("offline")
                      : tr("live"),
                  style: TextStyles.subTitleStyle.copyWith(color: enterColor),
                ),
              ],
            ),
            Row(
              children: [
                Image.asset(
                  profile,
                  height: 17.h,
                  fit: BoxFit.contain,
                  color: textfieldColor,
                ),
                const Space(
                  boxWidth: 10,
                ),
                Text(
                  "${widget.courseDetailsModel.provider!.title} ${widget.courseDetailsModel.provider!.firstName} ${widget.courseDetailsModel.provider!.lastName}",
                  // "أ/ عادل السيد",
                  style: TextStyles.hintStyle.copyWith(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),

            /// Coupon code
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: couponController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'coupon_code',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (couponController.text.isNotEmpty) {
                        // // Handle coupon application logic here
                        // print('Applying coupon: ${_couponController.text}');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('تم تطبيق الكوبون: ${_couponController.text}'),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                        cubit.makeCouponRequest(
                          lessonId: widget.courseDetailsModel!.id.toString(),
                          coupon: couponController.text,
                        );
                        cubit.finalP =
                            cubit.couponResponseDataModel!.data!.finalPrice!;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('يرجى إدخال رمز الكوبون'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'تطبيق',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("hourly_price"),
                  style: TextStyles.hintStyle,
                ),
                Row(
                  children: [
                    Text(
                      hourPrice.toString(),
                      // "80",
                      style: TextStyles.hintStyle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Space(
                      boxWidth: 10,
                    ),
                    Text(
                      tr("sar"),
                      style: TextStyles.hintStyle,
                    ),
                  ],
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("course_hours"),
                  style: TextStyles.hintStyle.copyWith(color: mainColor),
                ),
                Row(
                  children: [
                    Text(
                      widget.courseDetailsModel.numberOfHours.toString(),
                      style: TextStyles.hintStyle.copyWith(
                          color: mainColor, fontWeight: FontWeight.bold),
                    ),
                    const Space(
                      boxWidth: 10,
                    ),
                    Text(
                      tr("hour"),
                      style: TextStyles.hintStyle.copyWith(color: mainColor),
                    ),
                  ],
                ),
              ],
            ),
            const Space(
              boxHeight: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("priceWithoutTax"),
                  style: TextStyles.appBarStyle
                      .copyWith(color: secColor, fontSize: 14.sp),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.courseDetailsModel!.priceWithoutTax!,
                          style: TextStyles.hintStyle.copyWith(
                              color: secColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Space(
                        boxWidth: 4,
                      ),
                      Text(
                        tr("sar"),
                        style: TextStyles.hintStyle.copyWith(color: secColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Space(
              boxHeight: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("tax"),
                  style: TextStyles.appBarStyle
                      .copyWith(color: secColor, fontSize: 14.sp),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.courseDetailsModel!.tax!,
                          style: TextStyles.hintStyle.copyWith(
                              color: secColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Space(
                        boxWidth: 4,
                      ),
                      Text(
                        tr("sar"),
                        style: TextStyles.hintStyle.copyWith(color: secColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Space(
              boxHeight: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("total"),
                  style: TextStyles.appBarStyle
                      .copyWith(color: secColor, fontSize: 16.sp),
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          widget.courseDetailsModel!.priceWithTax!,
                          style: TextStyles.hintStyle.copyWith(
                              color: secColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Space(
                        boxWidth: 4,
                      ),
                      Text(
                        tr("sar"),
                        style: TextStyles.hintStyle.copyWith(color: secColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Space(
              boxHeight: 10,
            ),

            state is MakeCouponSuccessState
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قيمة الخصم',
                            // tr("priceWithoutTax"),
                            style: TextStyles.appBarStyle
                                .copyWith(color: secColor, fontSize: 14.sp),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    cubit.couponResponseDataModel!.data!
                                        .discountValue!
                                        .toString(),
                                    style: TextStyles.hintStyle.copyWith(
                                        color: secColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Space(
                                  boxWidth: 4,
                                ),
                                Text(
                                  tr("sar"),
                                  style: TextStyles.hintStyle
                                      .copyWith(color: secColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Space(
                        boxHeight: 12,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),

            state is MakeCouponSuccessState
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السعر بعد الحصم',
                            // tr("priceWithoutTax"),
                            style: TextStyles.appBarStyle
                                .copyWith(color: secColor, fontSize: 14.sp),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    cubit.couponResponseDataModel!.data!
                                        .finalPrice!
                                        .toString(),
                                    style: TextStyles.hintStyle.copyWith(
                                        color: secColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Space(
                                  boxWidth: 4,
                                ),
                                Text(
                                  tr("sar"),
                                  style: TextStyles.hintStyle
                                      .copyWith(color: secColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Space(
                        boxHeight: 12,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
