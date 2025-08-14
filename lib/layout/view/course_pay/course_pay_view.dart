import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';

import '../../../bloc/pay/pay_cubit.dart';
import '../../../model/payment_method/payment_method_model/payment_method_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/alert/delete/delete_alert.dart';
import '../../../widget/buttons/master/master_button.dart';
import '../../../widget/buttons/master_load/master_load_button.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';
import '../../card_view/request_summery_details_card.dart/request_course_details_card.dart';
import '../../card_view/table_from_to_card/table_card.dart';

class CoursePayView extends StatelessWidget {
  final int id;
  final List<PaymentMethodModel>? paymentMethod;
  final bool isRequest;
  const CoursePayView({
    super.key,
    required this.id,
    required this.paymentMethod,
    this.isRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PayCubit()..getPay(id),
        child: BlocConsumer<PayCubit, PayState>(
            listener: (context, state) {},
            builder: (context, state) {
              return BlocBuilder<PayCubit, PayState>(builder: (context, state) {
                if (state is PayLoadedState) {
                  final data = (state).data;
                  return coursePayView(context, data);
                } else if (state is PayErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              });
            }));
  }

  coursePayView(context, data) {
    // String total = (double.parse(data.course.price.replaceAll(",", "")) *
    //         double.parse(data.course.numberOfHours!.toString()))
    // .toString();
    return BlocProvider(
        create: (BuildContext context) => PayCubit(),
        child: BlocConsumer<PayCubit, PayState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = PayCubit.get(context);
              return SidePadding(
                sidePadding: 30,
                child: ListView(
                  children: [
                    RequstCourseDetailsCard(courseDetailsModel: data.course),
                    const Space(
                      boxHeight: 20,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    // const DiscountCodeCard(),
                    const Space(
                      boxHeight: 30,
                    ),
                    isRequest
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr("payment_method"),
                                style: TextStyles.appBarStyle
                                    .copyWith(color: black),
                              ),
                              const Space(
                                boxHeight: 10,
                              ),
                              SizedBox(
                                width: screenWidth,
                                height: 50,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: bloc.value,
                                          onChanged: (v) {
                                            bloc.setPayment(v);
                                          },
                                        ),
                                        Opacity(
                                            opacity: bloc.value == 2 ? 1 : 0.3,
                                            child: Image.asset(paidImage)),
                                        Text(
                                          tr("pay_online"),
                                          style: bloc.value == 2
                                              ? TextStyles.textView16Bold
                                                  .copyWith(color: mainColor)
                                              : TextStyles.subTitleStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: grey),
                                        ),
                                      ],
                                    ),
                                    // colorFilter: ColorFilter.mode(Colors.white.withValues(alpha:0.8), BlendMode.modulate,)
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: bloc.value,
                                          onChanged: (v) {
                                            bloc.setPayment(v);
                                          },
                                        ),
                                        Opacity(
                                            opacity: bloc.value == 1 ? 1 : 0.3,
                                            child: Image.asset(wallet)),
                                        Text(
                                          tr("wallet"),
                                          style: bloc.value == 1
                                              ? TextStyles.textView16Bold
                                                  .copyWith(color: mainColor)
                                              : TextStyles.subTitleStyle
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const Space(
                      boxHeight: 10,
                    ),
                    bloc.value == 1
                        ? const SizedBox()
                        : CustomList(
                            listHeight: 10000000000,
                            count: paymentMethod!.length,
                            child: (context, index) => Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: bloc.payment,
                                  onChanged: (int? v) => bloc.setPaymentMethod(
                                      v!, paymentMethod![index].id!),
                                ),
                                Opacity(
                                    opacity: bloc.payment == index ? 1 : 0.3,
                                    child: CachedImage(
                                      imageUrl:
                                          paymentMethod![index].image ?? "",
                                      width: 40.w,
                                      height: 40.h,
                                      fit: BoxFit.contain,
                                    )),
                              ],
                            ),
                          ),
                    const Space(
                      boxHeight: 30,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Text(
                      tr("reserved_appointments"),
                      style: TextStyles.appBarStyle.copyWith(color: black),
                    ),
                    const Space(
                      boxHeight: 20,
                    ),
                    CustomList(
                        listHeight: 100000000000,
                        listWidth: screenWidth,
                        count: data.groups.length,
                        scroll: const NeverScrollableScrollPhysics(),
                        axis: Axis.vertical,
                        child: (context, index) => Padding(
                              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                              child: TableCard(data: data.groups[index]),
                            )),
                    const Space(
                      boxHeight: 30,
                    ),
                    data.status != 2
                        ? const SizedBox()
                        : MasterLoadButton(
                            buttonController: bloc.payController,
                            buttonText:
                                "${tr("pay")} (${data.course.priceWithTax} ${tr("sar")})",
                            onPressed: () {
                              bloc.pay(id: id, context: context, coupon: bloc.couponT!);
                              // , wallet: false);
                              // Get.to(const BookingStatus());
                            },
                          ),
                    const Space(
                      boxHeight: 20,
                    ),
                    if (data.status == 1)
                      Text(
                        tr("order_under_review"),
                        style: TextStyles.appBarStyle.copyWith(color: black),
                      ),
                    data.status == 4
                        ? const SizedBox()
                        : MasterButton(
                            borderColor: transparent,
                            buttonColor: circleColor.withValues(alpha: 0.1),
                            buttonStyle: TextStyles.appBarStyle
                                .copyWith(color: circleColor),
                            buttonText: tr("cancel_subscribe"),
                            onPressed: () => deleteAlert(
                              deleteTap: () =>
                                  bloc.cancelCourse(data.course.id!),
                            ),
                          ),
                    const Space(
                      boxHeight: 30,
                    ),
                  ],
                ),
              );
            }));
  }
}
