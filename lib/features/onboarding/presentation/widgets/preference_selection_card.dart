import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class PreferenceSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final bool isSelected;
  final VoidCallback onTap;

  const PreferenceSelectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final unselectedBg = isDark
        ? AppColors.darkSurface
        : theme.cardTheme.color ?? theme.colorScheme.surface;
    final selectedBg = isDark
        ? AppColors.darkSelectedBackground
        : AppColors.primary.withValues(alpha: 0.08);

    final unselectedBorder = isDark
        ? AppColors.darkUnselectedBorder
        : AppColors.inputBorder;
    final selectedBorder = isDark
        ? AppColors.darkPrimaryAccent
        : AppColors.primary;

    final circleOutlineColor = isDark
        ? AppColors.darkCircleOutline
        : AppColors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 2.r : 1.5.r,
          ),
          boxShadow: isSelected && isDark
              ? [
                  BoxShadow(
                    color: AppColors.darkPrimaryAccent.withValues(alpha: 0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                leading,
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? (isDark
                            ? AppColors.darkPrimaryAccent
                            : AppColors.primary)
                      : circleOutlineColor,
                  size: 24.r,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? (isDark ? AppColors.darkPrimaryAccent : AppColors.primary)
                    : theme.textTheme.titleSmall?.color,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: isSelected
                    ? (isDark
                          ? AppColors.darkSecondaryAccent
                          : AppColors.primary.withValues(alpha: 0.7))
                    : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
