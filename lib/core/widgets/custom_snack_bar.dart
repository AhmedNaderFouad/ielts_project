import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

enum SnackBarType { success, error, info }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
  }) {
    final Color backgroundColor;
    final IconData icon;

    switch (type) {
      case SnackBarType.success:
        backgroundColor = AppColors.success;
        icon = Icons.check_circle_rounded;
        break;
      case SnackBarType.error:
        backgroundColor = AppColors.error;
        icon = Icons.error_outline_rounded;
        break;
      case SnackBarType.info:
        backgroundColor = AppColors.textDark;
        icon = Icons.info_outline_rounded;
        break;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 20.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }
}
