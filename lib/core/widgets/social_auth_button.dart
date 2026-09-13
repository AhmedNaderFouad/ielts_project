import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class SocialAuthButton extends StatelessWidget {
  final String text;
  final String assetPath;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialAuthButton({
    super.key,
    required this.text,
    required this.assetPath,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            (isDark ? AppColors.darkSurface : AppColors.inputFill),
        side: BorderSide(
          color: isDark
              ? AppColors.darkUnselectedBorder
              : AppColors.inputBorder,
        ),
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 24.r, height: 24.r),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              color:
                  textColor ?? (isDark ? AppColors.white : AppColors.textDark),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
