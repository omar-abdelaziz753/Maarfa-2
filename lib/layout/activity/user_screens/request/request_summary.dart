// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:my_academy/layout/card_view/discount_code_card/discount_code_card.dart';
// import 'package:my_academy/layout/card_view/payment_card/payment_card.dart';
// import 'package:my_academy/models/common/courses/course_details/course_details_model.dart';
// import 'package:my_academy/res/value/style/textstyles.dart';
// import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
// import 'package:my_academy/widget/buttons/master/master_button.dart';
// import 'package:my_academy/widget/side_padding/side_padding.dart';
// import 'package:my_academy/widget/space/space.dart';
// import '../../../../res/value/color/color.dart';
// import '../../../card_view/request_summery_details_card.dart/request_course_details_card.dart';
// import '../../../card_view/table_from_to_card/table_card.dart';
// import '../success_booking/booking_success.dart';
//
// class RequestCourseScreen extends StatefulWidget {
//   const RequestCourseScreen({Key? key,required this.courseDetailsModel}) : super(key: key);
//   final CourseDetailsModel courseDetailsModel;
//
//   @override
//   State<RequestCourseScreen> createState() => _RequestCourseScreenState();
// }
//
// class _RequestCourseScreenState extends State<RequestCourseScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: DefaultAppBar(title: tr("requset_summary")),
//       body: SidePadding(
//         sidePadding: 30,
//         child: ListView(
//           children: [
//             const RequstCourseDetailsCard(),
//             const Space(
//               boxHeight: 30,
//             ),
//             const Divider(
//               thickness: 1,
//             ),
//             const DiscountCodeCard(),
//             const Space(
//               boxHeight: 30,
//             ),
//             const PaymentCard(),
//             const Space(
//               boxHeight: 30,
//             ),
//             const Divider(
//               thickness: 1,
//             ),
//             Text(
//               tr("reserved_appointments"),
//               style: TextStyles.appBarStyle.copyWith(color: black),
//             ),
//             const Space(
//               boxHeight: 20,
//             ),
//             const TableCard(),
//             const Space(
//               boxHeight: 30,
//             ),
//             MasterButton(
//               buttonText: tr("pay"),
//               onPressed: () {
//                 Get.to(const BookingStatus());
//               },
//             ),
//             const Space(
//               boxHeight: 30,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
