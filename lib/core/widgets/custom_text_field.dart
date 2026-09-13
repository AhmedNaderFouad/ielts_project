import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final AutovalidateMode autovalidateMode;
  final bool hideErrorText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hideErrorText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          autovalidateMode: autovalidateMode,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark ? AppColors.white : AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: isDark ? AppColors.darkSurface : AppColors.inputFill,
            prefixIcon: Icon(
              prefixIcon,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              size: 20.r,
            ),
            suffixIcon: suffixIcon,
            errorMaxLines: 3,
            errorStyle: hideErrorText
                ? const TextStyle(height: 0, fontSize: 0)
                : TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.error,
                    height: 1.2,
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark
                    ? AppColors.darkUnselectedBorder
                    : AppColors.inputBorder,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
