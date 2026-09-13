import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/extensions/context_extension.dart';
import '../widgets/onboarding_progress_header.dart';
import 'welcome_view.dart';
import 'preferences_view.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle completion (e.g. mark onboarding as finished)
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    // Navigate to Home/Main Shell
  }

  String _getCategoryLabel(BuildContext context, int page) {
    switch (page) {
      case 0:
        return context.l10n.welcome;
      case 1:
        return 'Preferences';
      case 2:
        return 'Target';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Fixed / Sticky Top Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: OnboardingProgressHeader(
                currentStep: _currentPage + 1,
                totalSteps: 3,
                title: l10n.gettingStarted,
                categoryLabel: _getCategoryLabel(context, _currentPage),
                onBack: _previousPage,
                onSkip: _skipOnboarding,
              ),
            ),

            // 2. Scrollable Body Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  const WelcomeView(),
                  const PreferencesView(),
                  // Placeholder for Step 3
                  Center(
                    child: Text(
                      'Target View Placeholder',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Fixed Bottom Action Area (Button & Micro-copy)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentPage == 1) ...[
                    Text(
                      l10n.settingsNote,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textMuted,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  PrimaryButton(
                    text: l10n.continueButton,
                    trailingIcon: Icons.arrow_forward,
                    onPressed: _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
