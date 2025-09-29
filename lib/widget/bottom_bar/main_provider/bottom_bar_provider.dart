import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/bottom_bar/bottom_bar_cubit.dart';
import '../../../res/drawable/icon/icons.dart';
import '../../../res/value/color/color.dart';
import '../../../res/value/style/textstyles.dart';
import '../custom_floating/custom_floating.dart';

// class ProviderBottomBar extends StatelessWidget {
//   const ProviderBottomBar({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     final bloc = BlocProvider.of<BottomBarCubit>(context, listen: true);
//     return CustomFloatingNavbar(
//       onTap: (int index) => bloc.changeProviderBar(index),
//       currentIndex: bloc.selectedProvider,
//       backgroundColor: mainColor,
//       unselectedItemColor: white,
//       iconSize: 18.h,
//       dotSize: 10.h,
//       textStyle: TextStyles.errorStyle
//           .copyWith(color: white, fontWeight: FontWeight.bold),
//       items: [
//         CustomFloatingNavbarItem(icon: home, title: tr("home")),
//         CustomFloatingNavbarItem(icon: subscribe, title: tr("request_sent")),
//         CustomFloatingNavbarItem(icon: appointment, title: tr("appointments")),
//         CustomFloatingNavbarItem(icon: profile, title: tr("account")),
//       ],
//     );
//   }
// }

class ProviderBottomBar extends StatelessWidget {
  const ProviderBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BottomBarCubit>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        color: white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: CustomFloatingNavbar(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        onTap: (int index) => bloc.changeProviderBar(index),
        currentIndex: bloc.selectedProvider,
        backgroundColor: mainColor,
        unselectedItemColor: Colors.white60,
        selectedItemColor: Colors.white,
        iconSize: 22.h,
        dotSize: 6.h,
        textStyle: TextStyles.errorStyle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
        items: [
          CustomFloatingNavbarItem(
            icon: home,
            title: tr("home"),
            showTitleAlways: true,
          ),
          CustomFloatingNavbarItem(
            icon: subscribe,
            title: tr("request_sent"),
            showTitleAlways: true,
          ),
          CustomFloatingNavbarItem(
            icon: appointment,
            title: tr("appointments"),
            showTitleAlways: true,
          ),
          CustomFloatingNavbarItem(
            icon: profile,
            title: tr("account"),
            showTitleAlways: true,
          ),
        ],
      ),
    );
  }
}
