import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      textTheme: _textTheme(AppColors.textDark, AppColors.textMuted),
      inputDecorationTheme: _inputDecorationTheme(
        AppColors.inputFill,
        AppColors.inputBorder,
        AppColors.textMuted,
        AppColors.primary,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary),
      checkboxTheme: _checkboxTheme(AppColors.primary, AppColors.inputBorder),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: AppColors.inputBorder),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimaryAccent,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimaryAccent,
        secondary: AppColors.darkSecondaryAccent,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      useMaterial3: true,
      textTheme: _textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        AppColors.darkSurface,
        AppColors.darkUnselectedBorder,
        AppColors.darkTextSecondary,
        AppColors.darkPrimaryAccent,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(AppColors.darkPrimaryAccent),
      checkboxTheme: _checkboxTheme(
        AppColors.darkPrimaryAccent,
        AppColors.darkUnselectedBorder,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(
            color: AppColors.darkUnselectedBorder,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color primaryColor, Color mutedColor) {
    return TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(fontSize: 14.sp, color: mutedColor),
      labelLarge: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: primaryColor,
        letterSpacing: 1.1,
      ),
      labelSmall: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: mutedColor,
        letterSpacing: 1.1,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    Color fill,
    Color border,
    Color hint,
    Color focusBorderColor,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: focusBorderColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.0),
      ),
      hintStyle: TextStyle(color: hint.withValues(alpha: 0.5), fontSize: 14.sp),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color backgroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.white,
        minimumSize: Size(double.infinity, 56.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme(
    Color activeColor,
    Color borderColor,
  ) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeColor;
        }
        return AppColors.transparent;
      }),
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    );
  }
}
