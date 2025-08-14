import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/bloc/pay/pay_cubit.dart';
import 'package:my_academy/bloc/payment/payment_cubit.dart';
import 'package:my_academy/widget/request_lesson/bloc/request_lesson_cubit.dart';

import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/space/space.dart';

class RequestLessonDetailsCard extends StatefulWidget {
  final dynamic lessonDetails;

  const RequestLessonDetailsCard({
    super.key,
    this.lessonDetails,
  });

  @override
  State<RequestLessonDetailsCard> createState() =>
      _RequestLessonDetailsCardState();
}

class _RequestLessonDetailsCardState extends State<RequestLessonDetailsCard> {
  final TextEditingController _couponController = TextEditingController();

  void _applyCoupon() {}

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PayCubit, PayState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final cubit = context.read<PayCubit>();

        final priceText = state is MakeCouponSuccessState
            ? cubit.couponResponseDataModel!.data!.finalPrice.toString()
            : widget.lessonDetails!.finalPriceWithTax!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lessonDetails?.subject?.name ?? '',
              style: TextStyles.appBarStyle
                  .copyWith(color: blackColor, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr("subject"),
                  style: TextStyles.errorStyle.copyWith(color: mainColor),
                ),
                Text(
                  tr("live"),
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
                  boxWidth: 15,
                ),
                Text(
                  "${widget.lessonDetails!.provider!.title} ${widget.lessonDetails!.provider!.firstName} ${widget.lessonDetails!.provider!.lastName}",
                  style: TextStyles.hintStyle.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            const Space(
              boxHeight: 20,
            ),

            const Divider(
              thickness: 1,
            ),

            const Space(
              boxHeight: 20,
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
                      controller: _couponController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'coupon_code',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 15),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_couponController.text.isNotEmpty) {
                        // // Handle coupon application logic here
                        // print('Applying coupon: ${_couponController.text}');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('تم تطبيق الكوبون: ${_couponController.text}'),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                        cubit.makeCouponRequest(
                          lessonId: widget.lessonDetails!.id.toString(),
                          coupon: _couponController.text,
                        );
                        cubit.finalP = cubit.couponResponseDataModel!.data!.finalPrice!;
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
              boxHeight: 20,
            ),

            const Divider(
              thickness: 1,
            ),
            const Space(
              boxHeight: 30,
            ),
            const Space(
              boxHeight: 30,
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
                          widget.lessonDetails?.priceWithoutTax ?? '',
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
                          widget.lessonDetails!.tax!,
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
                          // cubit.couponResponseDataModel!.data!!.toString(),
                          widget.lessonDetails!.finalPriceWithTax!,
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
              boxHeight: 12,
            ),

            state is MakeCouponSuccessState ?
            Column(
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
                              cubit.couponResponseDataModel!.data!.discountValue!.toString(),
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
              ],
            ) : const SizedBox.shrink(),


            state is MakeCouponSuccessState ?
            Column(
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
                              cubit.couponResponseDataModel!.data!.finalPrice!.toString(),
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
              ],
            ) : const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
