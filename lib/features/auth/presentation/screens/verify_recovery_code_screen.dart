import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_string_utils.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/auth_header_illustration.dart';
import '../widgets/auth_security_info_card.dart';
import '../widgets/auth_return_to_sign_in.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class VerifyRecoveryCodeScreen extends StatefulWidget {
  final String email;
  const VerifyRecoveryCodeScreen({super.key, required this.email});

  @override
  State<VerifyRecoveryCodeScreen> createState() =>
      _VerifyRecoveryCodeScreenState();
}

class _VerifyRecoveryCodeScreenState extends State<VerifyRecoveryCodeScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  late int _secondsRemaining;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = context.read<AuthCubit>().resendCooldown;
    if (_secondsRemaining > 0) {
      _startTimer();
    } else {
      _canResend = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleVerify() {
    if (_pinController.text.length == 6) {
      context.read<AuthCubit>().verifyResetOTP(
        widget.email,
        _pinController.text,
      );
    } else {
      CustomSnackBar.show(
        context,
        message: 'Please enter a valid 6-digit code',
        type: SnackBarType.error,
      );
    }
  }

  void _handleResend() {
    context.read<AuthCubit>().sendResetOTP(widget.email);
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: AppColors.textDark,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 1.5),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.inputFill,
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        } else if (state is OTPVerificationSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Code Verified Successfully',
            type: SnackBarType.success,
          );
          Navigator.pushNamed(
            context,
            Routes.resetPassword,
            arguments: {'email': widget.email, 'resetToken': state.resetToken},
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 12.h),
                  const AuthTopBar(
                    badgeText: 'IELTS ACADEMIC',
                    badgeIcon: Icons.school_outlined,
                  ),
                  SizedBox(height: 40.h),
                  const AuthHeaderIllustration(iconAsset: AppAssets.mailIcon),
                  SizedBox(height: 32.h),
                  Text(
                    'Verify Recovery Code',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'We have sent a 6-digit verification code to your registered academic email address:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.alternate_email,
                          size: 16.r,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppStringUtils.maskEmail(widget.email),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.r,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Pinput(
                    length: 6,
                    controller: _pinController,
                    focusNode: _focusNode,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    showCursor: true,
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 9.h),
                          width: 2.w,
                          height: 20.h,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    onCompleted: (pin) => _handleVerify(),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: _canResend ? _handleResend : null,
                        child: Row(
                          children: [
                            Icon(
                              Icons.history,
                              size: 16.r,
                              color: _canResend
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _canResend
                                  ? 'Resend Code'
                                  : 'Resend in ${_formatTime(_secondsRemaining)}',
                              style: TextStyle(
                                color: _canResend
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        text: state is AuthLoading
                            ? 'Verifying...'
                            : 'Verify & Continue',
                        trailingIcon: state is AuthLoading
                            ? null
                            : Icons.arrow_forward,
                        onPressed: state is AuthLoading ? null : _handleVerify,
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 16.r,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '256-BIT ENCRYPTED SECURE RECOVERY SESSION',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  const AuthSecurityInfoCard(
                    title: 'Having trouble receiving the code?',
                    description:
                        'Please check your junk or spam folder, or connect with your authorized British Council or IDP center administrator.',
                    icon: Icons.help_outline_rounded,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
