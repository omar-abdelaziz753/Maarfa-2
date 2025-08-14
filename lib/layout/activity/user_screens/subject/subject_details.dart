import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/static/contact_us/contact_us_screen.dart';
import 'package:my_academy/res/value/dimenssion/dimenssions.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/buttons/master/master_button.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';
import '../../../../model/provider/home/home_db_response.dart';
import '../../../../res/drawable/icon/icons.dart';
import '../../../../res/value/color/color.dart';
import '../../../../widget/alert/alert_rate.dart';

class SubjectDetails extends StatelessWidget {
  const SubjectDetails({
    super.key,
    this.hourPrice,
    this.hours,
    required this.providerId,
    required this.providerName,
    required this.subjectTitle,
    required this.isFinshed,
    required this.subjectYear,
    this.times,
  });

  final int providerId;
  final String subjectTitle;
  final String subjectYear;
  final String providerName;
  final String? hourPrice;
  final bool isFinshed;
  final int? hours;
  final List<Time>? times;

  @override
  Widget build(BuildContext context) {
    String total = (double.parse(hourPrice!) * hours!).toStringAsFixed(2);
    return Scaffold(
      appBar: DefaultAppBar(title: tr("requset_summary")),
      body: SidePadding(
        sidePadding: 30,
        child: SingleChildScrollView(
          child: SidePadding(
            sidePadding: 30,
            child: Column(
              children: [
                Text(
                  subjectTitle,
                  // "مادة لغة عربية",
                  style: TextStyles.appBarStyle.copyWith(color: black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("subject"),
                      style: TextStyles.errorStyle.copyWith(color: mainColor),
                    ),
                    Text(
                      subjectYear,
                      // "الصف الأول الثانوى",
                      style: TextStyles.errorStyle.copyWith(color: enterColor),
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
                      providerName,
                      // "أ/ عادل السيد",
                      style: TextStyles.hintStyle.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                const Space(
                  boxHeight: 30,
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
                          // "80",
                          hourPrice.toString(),
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
                  boxHeight: 30,
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
                          hours.toString(),
                          style: TextStyles.hintStyle.copyWith(
                              color: mainColor, fontWeight: FontWeight.bold),
                        ),
                        const Space(
                          boxWidth: 10,
                        ),
                        Text(
                          tr("hour"),
                          style:
                              TextStyles.hintStyle.copyWith(color: mainColor),
                        ),
                      ],
                    ),
                  ],
                ),
                const Space(
                  boxHeight: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr("total"),
                      style: TextStyles.appBarStyle.copyWith(color: secColor),
                    ),
                    Row(
                      children: [
                        Text(
                          total,
                          // "220",
                          style: TextStyles.hintStyle
                              .copyWith(color: secColor, fontSize: 16),
                        ),
                        const Space(
                          boxWidth: 10,
                        ),
                        Text(
                          tr("sar"),
                          style: TextStyles.hintStyle.copyWith(color: secColor),
                        ),
                      ],
                    ),
                  ],
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
                Column(
                  children: List.generate(
                    times!.length,
                    (index) => Container(
                      width: screenWidth,
                      color: profileColor,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  //Todo change week day to arabic
                                  DateFormat("EEEE").format(DateTime.parse(
                                      times![index].startsAt.toString())),
                                  style: TextStyles.contentStyle
                                      .copyWith(color: mainColor),
                                ),
                                Text(
                                  DateFormat("dd/MM").format(DateTime.parse(
                                      times![index].startsAt.toString())),
                                  style: TextStyles.contentStyle
                                      .copyWith(color: mainColor),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  DateFormat("hh:mm").format(DateTime.parse(
                                      times![index].startsAt.toString())),
                                  style: TextStyles.agreeStyle
                                      .copyWith(color: black),
                                ),
                                Text(
                                  DateFormat("hh:mm").format(DateTime.parse(
                                      times![index].endsAt.toString())),
                                  style: TextStyles.agreeStyle
                                      .copyWith(color: black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // const ReservedAppointmentsCard(),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(tr("rate_note"),
                          style: TextStyles.subTitleStyle
                              .copyWith(color: Colors.black)),
                    ),
                    TextButton(
                        onPressed: () => Get.to(() => const ContactUsScreen()),
                        child: Text(tr("from_here"),
                            style: TextStyles.subTitleStyle))
                  ],
                ),
                const SizedBox(height: 15),
                MasterButton(
                  buttonText: tr("rate"),
                  buttonColor: Colors.amber,
                  borderColor: Colors.amber,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RateAlert(
                            id: providerId,
                            type: 'course',
                          );
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
