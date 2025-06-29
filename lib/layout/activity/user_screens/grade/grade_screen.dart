import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/user_screens/main/main_screen.dart';
import 'package:my_academy/repository/common/educational_stages/educational_stages_repository.dart';
import 'package:my_academy/widget/app_bar/default_app_bar/default_app_bar.dart';
import 'package:my_academy/widget/error/page/error_page.dart';
import 'package:my_academy/widget/loader/loader.dart';
import '../../../../bloc/educational_stages_years/educational_stages_cubit.dart';
import '../../../view/connectivity/connectivity_view.dart';
import '../../../view/years/years/years_view.dart';

class GradeScreen extends StatelessWidget {
  const GradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const MainScreen());
        return true;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
            title: tr("grades"),
            centerTitle: false,
            backPressed: () => Get.offAll(() => const MainScreen())),
        body: ConnectivityView(
          child: BlocProvider(
            create: (BuildContext context) =>
                EducationalStagesCubit(EducationalStagesRepository())
                  ..getEducationalStages(),
            child: BlocConsumer<EducationalStagesCubit, EducationalStagesState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is EducationalStagesLoadedState) {
                  final data = state.data;
                  return YearsView(stages: data);
                } else if (state is EducationalStagesErrorState) {
                  return const ErrorPage();
                } else {
                  return const Loading();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
