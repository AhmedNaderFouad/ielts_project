import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String categoryLabel;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.categoryLabel,
    this.onBack,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final trackColor = isDark
        ? AppColors.darkTrackBackground
        : AppColors.grey.withValues(alpha: 0.2);
    final activeFillColor = isDark
        ? AppColors.darkPrimaryAccent
        : AppColors.primary;

    final activeStepTextColor = isDark
        ? AppColors.darkSecondaryAccent
        : AppColors.primary;
    final inactiveStepTextColor = const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentStep > 1) ...[
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? AppColors.white : AppColors.textDark,
                      size: 20.r,
                    ),
                    onPressed: onBack,
                  ),
                  SizedBox(width: 12.w),
                ],
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
            if (currentStep == 1)
              TextButton(
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Skip',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: List.generate(totalSteps, (index) {
            bool isActive = index < currentStep;
            return Expanded(
              child: Container(
                height: 6.h,
                margin: EdgeInsets.only(
                  right: index == totalSteps - 1 ? 0 : 8.w,
                ),
                decoration: BoxDecoration(
                  color: isActive ? activeFillColor : trackColor,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP $currentStep OF $totalSteps',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: inactiveStepTextColor,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              categoryLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: activeStepTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
