import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class AuthSecurityInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const AuthSecurityInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.inputFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark
                    ? AppColors.darkUnselectedBorder
                    : AppColors.inputBorder,
              ),
            ),
            child: Icon(
              icon,
              size: 24.r,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
