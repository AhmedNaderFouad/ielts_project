import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed ?? () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.inputFill,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark
                ? AppColors.darkUnselectedBorder
                : AppColors.inputBorder,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.r,
            color: isDark ? AppColors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
