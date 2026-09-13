import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  final String text;
  const OrDivider({super.key, this.text = "OR CONTINUE WITH"});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark
                ? AppColors.darkUnselectedBorder
                : AppColors.inputBorder,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark
                ? AppColors.darkUnselectedBorder
                : AppColors.inputBorder,
          ),
        ),
      ],
    );
  }
}
