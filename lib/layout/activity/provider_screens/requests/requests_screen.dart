import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_academy/layout/view/connectivity/connectivity_view.dart';
import 'package:my_academy/layout/view/provider_requests/provider_course_requests.dart';
import 'package:my_academy/widget/headers/course_subject/course_subject_header.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../../bloc/provider_requests/provider_requests_cubit.dart';
import '../../../../repository/provider/requests/requests_repository.dart';
import '../../../view/provider_requests/provider_lesson_requests.dart';

class ProviderRequestsScreen extends StatelessWidget {
  const ProviderRequestsScreen({super.key});
  // final scrollController = ScrollController();

  // void setupScrollController(context) {
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels != 0) {
  //         BlocProvider.of<ProviderRequestsCubit>(context).getRequests();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) =>
            ProviderRequestsCubit(RequestsProvider()),
        child: BlocConsumer<ProviderRequestsCubit, ProviderRequestsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = ProviderRequestsCubit.get(context);
              return ConnectivityView(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Space(
                        boxHeight: 45,
                      ),
                      CourseSubjectHeader(
                        courseTap: () => bloc.chooseCourseSubject(false),
                        subjectTap: () => bloc.chooseCourseSubject(true),
                        isSubject: bloc.isSubject,
                      ),

                      bloc.isSubject
                          ? const SidePadding(
                              sidePadding: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProviderRequestsSubjectView(),
                                ],
                              ),
                            )
                          : const SidePadding(
                              sidePadding: 15,
                              child: Column(
                                children: [ProviderRequestsCourseView()],
                              ),
                            ),
                      const Space(
                        boxHeight: 30,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
