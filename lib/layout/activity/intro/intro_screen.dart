import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_academy/layout/activity/role/role_screen.dart';
import 'package:my_academy/service/local/share_prefs_service.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';
import 'package:my_academy/widget/space/space.dart';

import '../../../bloc/intro/intro_cubit.dart';
import '../../../res/drawable/image/images.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/dimenssion/dimenssions.dart';
import '../../../res/value/style/textstyles.dart';
import '../../../widget/background/background_image.dart';
import '../../../widget/buttons/intro_button/intro_button.dart';
import '../../../widget/intro/intro_page/intro_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SharedPrefService pref = SharedPrefService();
    return BlocProvider(
        create: (BuildContext context) => IntroCubit(),
        child: BlocConsumer<IntroCubit, IntroState>(
            listener: (context, state) {},
            builder: (context, state) {
              final bloc = IntroCubit.get(context);
              return Scaffold(
                backgroundColor: white,
                body: BackgroundImage(
                  image: bloc.intro == 0
                      ? startIntroBackground
                      : endIntroBackground,
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Space(
                          //   boxHeight: 0.01 * screenHeight,
                          // ),
                          SizedBox(
                            width: screenWidth,
                            height: screenHeight * 0.8,
                            child: PageView(
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index) => bloc.scrollIntro(index),
                              children: List.generate(
                                bloc.imageIntro.length,
                                (index) => IntroPage(
                                  style: bloc.intro == 0
                                      ? TextStyles.introStyle2
                                          .copyWith(color: black)
                                      : TextStyles.introStyle2
                                          .copyWith(color: white),
                                  titleStyle: TextStyles.introStyle
                                      .copyWith(color: cvColor),
                                  image: bloc.imageIntro[bloc.intro],
                                  subject: Get.locale!.languageCode == "ar"
                                      ? bloc.subjectIntroAr[bloc.intro]
                                      : bloc.subjectIntroEn[bloc.intro],
                                  title: Get.locale!.languageCode == "ar"
                                      ? bloc.titleIntroAr[bloc.intro]
                                      : bloc.titleIntroEn[bloc.intro],
                                ),
                              ),
                            ),
                          ),
                          const Space(
                            boxHeight: 20,
                          ),
                          SidePadding(
                            sidePadding: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IntroButton(
                                  color:
                                      bloc.intro == 0 ? mainLightColor : white,
                                  percent: bloc.percent,
                                  onPressed: () {
                                    bloc.changeIntro(bloc.intro);
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    pref.setBool("seen", true);
                                    Get.offAll(() => const RoleScreen());
                                  },
                                  child: Text(
                                    tr("skip"),
                                    style: TextStyles.agreeStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              );
            }));
  }
}
