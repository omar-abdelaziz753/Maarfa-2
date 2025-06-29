import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../bloc/add_request/add_request_cubit.dart';
import '../../../../widget/buttons/master_load/master_load_button.dart';
import '../../../../widget/request_lesson/request_lesson_details_card.dart';
import '../../../card_view/reserved_appointments_card/reserved_appointments_card.dart';

class RequestLessonScreen extends StatelessWidget {
  final dynamic lessonDetails;
  final List<int>? times;

  const RequestLessonScreen({
    super.key,
    this.lessonDetails,
    this.times,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: tr("requset_summary")),
      body: SidePadding(
        sidePadding: 30,
        child: ListView(
          children: [
            // RequestLessonDetailsCard(lessonDetails: lessonDetails!),
            const Space(
              boxHeight: 30,
            ),
            const Divider(
              thickness: 1,
            ),
            // const DiscountCodeCard(),
            // const Space(
            //   boxHeight: 30,
            // ),
            // const PaymentCard(),
            // const Space(
            // boxHeight: 30,
            // ),
            // const Divider(
            // thickness: 1,
            // ),
            // Text(
            //   tr("reserved_appointments"),
            //   style: TextStyles.appBarStyle.copyWith(color: black),
            // ),
            const Space(
              boxHeight: 20,
            ),
            ReservedAppointmentsCard(
                lessonDetails: lessonDetails!, times: times),
            const Space(
              boxHeight: 30,
            ),
            BlocProvider(
              create: (context) => AddRequestCubit(),
              child: BlocConsumer<AddRequestCubit, AddRequestState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final bloc = AddRequestCubit.get(context);
                  return MasterLoadButton(
                    buttonController: bloc.authController,
                    buttonText: tr("send_request"),
                    onPressed: () {
                      bloc.addRequestLesson(
                          context: context,
                          lessonId: lessonDetails!.id!,
                          times: times ?? []);
                      // Get.to(const BookingStatus());
                    },
                  );
                },
              ),
            ),
            const Space(
              boxHeight: 30,
            ),
          ],
        ),
      ),
    );
  }
}
