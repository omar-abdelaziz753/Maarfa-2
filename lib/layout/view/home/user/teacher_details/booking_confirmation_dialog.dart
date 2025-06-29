import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingConfirmationDialog extends StatelessWidget {
  final String teacherName;
  final VoidCallback onConfirm;

  const BookingConfirmationDialog({
    super.key,
    required this.teacherName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 28.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'bookingSuccess'.tr(),
              style: TextStyle(
                color: Colors.green[600],
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Text(
          '${'bookLesson'.tr()} $teacherName ${'successfully'.tr()}. ${'contactSoon'.tr()}',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ),
      actions: [
        Container(
          width: double.infinity,
          child: TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'ok'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static void show(BuildContext context, String teacherName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BookingConfirmationDialog(
        teacherName: teacherName,
        onConfirm: () => Navigator.of(context).pop(),
      ),
    );
  }
}
