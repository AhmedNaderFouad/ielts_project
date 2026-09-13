import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../widgets/feature_badge_chip.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hero Illustration
          Image.asset(
            'assets/logos/onboarding_welcome_logo.png',
            height: 280.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 40.h),
          // Typography
          Text(
            l10n.welcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 28.sp,
              color: isDark ? AppColors.white : AppColors.textDark,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.welcomeSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),
          // Feature Chips
          const Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              FeatureBadgeChip(icon: '🎯', label: 'Tailored Study Path'),
              FeatureBadgeChip(icon: '⚡', label: 'Real-time Band Scoring'),
              FeatureBadgeChip(icon: '🌐', label: 'Global Standard'),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
