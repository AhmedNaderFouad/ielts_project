import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_badge.dart';
import '../../../../core/widgets/primary_button.dart';
import 'package:ielts_project/core/routing/routes.dart';
import '../../../../core/utils/app_string_utils.dart';

class PasswordResetSuccessDialog extends StatefulWidget {
  final String email;

  const PasswordResetSuccessDialog({super.key, required this.email});

  @override
  State<PasswordResetSuccessDialog> createState() =>
      _PasswordResetSuccessDialogState();
}

class _PasswordResetSuccessDialogState
    extends State<PasswordResetSuccessDialog> {
  int _secondsRemaining = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _navigateToSignIn();
      }
    });
  }

  void _navigateToSignIn() {
    _timer?.cancel();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signIn,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.background,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                // Success Illustration
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 48.r,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                const AuthBadge(text: 'SECURITY VERIFIED', icon: Icons.circle),
                SizedBox(height: 16.h),
                Text(
                  'Password Reset Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Your candidate credentials have been securely updated. All other active testing sessions have been signed out for your protection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24.h),
                // Account Summary Card
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Candidate Account',
                        Text(
                          AppStringUtils.maskEmail(widget.email),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      Divider(color: AppColors.inputBorder, height: 24.h),
                      _buildSummaryRow(
                        'Target Level',
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: 14.r,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                'Band 8.0+ Verified',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: AppColors.inputBorder, height: 24.h),
                      _buildSummaryRow(
                        'Session Status',
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8.r,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                'Encrypted SHA-256 • Just now',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                PrimaryButton(
                  text: 'Continue to Sign In',
                  trailingIcon: Icons.arrow_forward,
                  onPressed: _navigateToSignIn,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Redirecting to login in ${_secondsRemaining}s...',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Need Help? Contact Test Center Support',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close Button
          Positioned(
            right: 12.r,
            top: 12.r,
            child: GestureDetector(
              onTap: () {
                _timer?.cancel();
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.inputBorder.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 20.r,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textMuted),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Align(alignment: Alignment.centerRight, child: value),
        ),
      ],
    );
  }
}
