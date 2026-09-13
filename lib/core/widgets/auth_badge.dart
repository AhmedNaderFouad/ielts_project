import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AuthBadge extends StatelessWidget {
  final String text;
  final IconData? icon;

  const AuthBadge({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.inputFill,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14.r,
              color: isDark ? AppColors.darkPrimaryAccent : AppColors.primary,
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
