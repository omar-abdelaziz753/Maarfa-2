import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../res/value/color/color.dart';
// import 'package:iconsax/iconsax.dart';

class NotificationButton extends StatelessWidget {
  final int count;

  const NotificationButton(
      {super.key, required this.count, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      //     () {
      //   Get.to(const NotificationsScreen(isUser: true,));
      // },
      child: Stack(
        alignment: FractionalOffset.topRight,
        children: [
          Container(
            width: 45.w,
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: white,
            ),
            child: Center(
              // child: Icon(
              //   Iconsax.notification,
              //   color: mainColor,
              //   size: 25.r,
              // ),
              // ),
              // child: Icon(
              //   Icons.notifications_none_outlined,
              //   color: mainColor,
              //   size: 30.sp,
              // ),
              child: Icon(
                Icons.notifications_active,
                color: mainColor,
              ),
            ),
          ),
          count > 0
              ? Icon(Icons.circle, color: circleColor, size: 15.r)
              : const SizedBox(),
        ],
      ),
    );
  }
}
