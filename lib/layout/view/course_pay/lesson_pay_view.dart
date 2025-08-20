import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_academy/widget/request_lesson/bloc/request_lesson_cubit.dart';

import '../../../bloc/pay/pay_cubit.dart';
import '../../../model/pay/pay_response.dart';
import '../../../model/payment_method/payment_method_model/payment_method_model.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/alert/delete/delete_alert.dart';
import '../../../widget/buttons/master/master_button.dart';
import '../../../widget/buttons/master_load/master_load_button.dart';
import '../../../widget/error/page/error_page.dart';
import '../../../widget/image_handler/image_from_network/network_image.dart';
import '../../../widget/loader/loader.dart';
import '../../../widget/master_list/custom_list.dart';
import '../../../widget/request_lesson/request_lesson_details_card.dart';
import '../../../widget/side_padding/side_padding.dart';
import '../../../widget/space/space.dart';

class LessonPayView extends StatefulWidget {
  final int id;
  final List<PaymentMethodModel>? paymentMethod;
  final bool isRequest;

  const LessonPayView({
    super.key,
    required this.id,
    required this.paymentMethod,
    this.isRequest = false,
  });

  @override
  State<LessonPayView> createState() => _LessonPayViewState();
}

class _LessonPayViewState extends State<LessonPayView> {
  final TextEditingController couponController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (BuildContext context) => PayCubit()..getPay(widget.id),
          child: BlocConsumer<PayCubit, PayState>(
              listener: (context, state) {},
              builder: (context, state) {
                return BlocBuilder<PayCubit, PayState>(builder: (context, state) {
                  if (state is PayLoadedState) {
                    // print("a77777");
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

  coursePayView(context, PayModel data) {
    // String total = (double.parse(data.course.price.replaceAll(",", "")) *
    //         double.parse(data.course.numberOfHours!.toString()))
    //     .toString();
    return BlocProvider(
  create: (context) => PayCubit(),
  child: BlocProvider(
        create: (BuildContext context) => PayCubit(),
        child: BlocConsumer<PayCubit, PayState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = PayCubit.get(context);
              return SidePadding(
                sidePadding: 30,
                child: ListView(
                  children: [
                    RequestLessonDetailsCard(lessonDetails: data.lesson),

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

                    data.status != 2
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
                            count: widget.paymentMethod!.length,
                            child: (context, index) => Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: bloc.payment,
                                  onChanged: (int? v) => bloc.setPaymentMethod(
                                      v!, widget.paymentMethod![index].id!),
                                ),
                                Opacity(
                                    opacity: bloc.payment == index ? 1 : 0.3,
                                    child: CachedImage(
                                      imageUrl:
                                          widget.paymentMethod![index].image ?? "",
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
                    // TableCard(data: data.times[0]),

                    Text(
                      DateFormat("MM/dd/yyyy hh:mm:ss tt", "en")
                          .format((data.times![0].startsAt!)),
                      style: TextStyles.hintStyle.copyWith(color: black),
                    ),
                    // CustomList(
                    //     listHeight: 100000000000,
                    //     listWidth: screenWidth,
                    //     count: data.times.length,
                    //     scroll: const NeverScrollableScrollPhysics(),
                    //     axis: Axis.vertical,
                    //     child: (context, index) => Padding(
                    //           padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    // child: TableCard(data: data.groups[index]),
                    //         )),
                    const Space(
                      boxHeight: 30,
                    ),
                    data.status != 2
                        ? const SizedBox()
                        : BlocBuilder<PayCubit,
                        PayState>(
                          builder: (context, state) {
                            final cubit =
                                context.read<PayCubit>();

                            final priceText = state is MakeCouponSuccessState
                                ? bloc.finalP.toString()
                                : data.lesson!.finalPriceWithTax!;

                            print('--------');
                            print(state is MakeCouponSuccessState);
                            print(priceText);
                            print('--------');

                            return MasterLoadButton(
                                buttonController: bloc.payController,
                                buttonText: "${tr("pay")} ($priceText ${tr("sar")})t",
                                onPressed: () {
                                  bloc.pay(id: widget.id, context: context, coupon: bloc.couponT ?? '');
                                },
                            );
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
                            buttonColor: circleColor.withValues(alpha: 0.2),
                            buttonStyle: TextStyles.appBarStyle
                                .copyWith(color: circleColor),
                            buttonText: tr("cancel"),
                            onPressed: () => deleteAlert(
                              deleteTap: () =>
                                  bloc.cancelLesson(data.lesson!.id!),
                            ),
                          ),
                    const Space(
                      boxHeight: 30,
                    ),
                  ],
                ),
              );
            })),
);
  }
}
