import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/settings/presentation/manager/settings_cubit.dart';
import '../widgets/preference_selection_card.dart';

class PreferencesView extends StatelessWidget {
  const PreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sectionHeaderStyle = theme.textTheme.labelSmall?.copyWith(
      color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    );

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalize Your Experience',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.textDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Select your preferred app language and interface appearance.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textMuted,
                ),
              ),
              SizedBox(height: 32.h),

              // PREFERRED LANGUAGE Section
              Text('PREFERRED LANGUAGE', style: sectionHeaderStyle),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: PreferenceSelectionCard(
                      title: 'English',
                      subtitle: 'Primary UI & Drills',
                      leading: Text('🇬🇧', style: TextStyle(fontSize: 24.sp)),
                      isSelected: state.locale.languageCode == 'en',
                      onTap: () =>
                          context.read<SettingsCubit>().changeLanguage('en'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: PreferenceSelectionCard(
                      title: 'بالعربي',
                      subtitle: 'واجهة عربية كاملة',
                      leading: Text('🇸🇦', style: TextStyle(fontSize: 24.sp)),
                      isSelected: state.locale.languageCode == 'ar',
                      onTap: () =>
                          context.read<SettingsCubit>().changeLanguage('ar'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // APP APPEARANCE Section
              Text('APP APPEARANCE', style: sectionHeaderStyle),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: PreferenceSelectionCard(
                      title: 'Light Mode',
                      subtitle: 'Default crisp academic',
                      leading: Icon(
                        Icons.wb_sunny_outlined,
                        size: 24.r,
                        color: isDark
                            ? AppColors.darkPrimaryAccent
                            : AppColors.primary,
                      ),
                      isSelected: state.themeMode == ThemeMode.light,
                      onTap: () => context
                          .read<SettingsCubit>()
                          .changeThemeMode(ThemeMode.light),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: PreferenceSelectionCard(
                      title: 'Dark Mode',
                      subtitle: 'Easy on eyes at night',
                      leading: Icon(
                        Icons.nightlight_round_outlined,
                        size: 24.r,
                        color: isDark
                            ? AppColors.darkPrimaryAccent
                            : AppColors.primary,
                      ),
                      isSelected: state.themeMode == ThemeMode.dark,
                      onTap: () => context
                          .read<SettingsCubit>()
                          .changeThemeMode(ThemeMode.dark),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}
