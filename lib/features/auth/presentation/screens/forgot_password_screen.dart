import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/auth_header_illustration.dart';
import '../widgets/auth_security_info_card.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final lastEmail = context.read<AuthCubit>().lastSentEmail;
    _emailController = TextEditingController(text: lastEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleRecovery() {
    if (_formKey.currentState!.validate()) {
      final enteredEmail = _emailController.text.trim();
      final lastEmail = context.read<AuthCubit>().lastSentEmail;

      if (enteredEmail == lastEmail &&
          context.read<AuthCubit>().resendCooldown > 0) {
        // Email is unchanged and timer is active:
        // Simply navigate to OTP screen
        Navigator.pushNamed(
          context,
          Routes.verifyRecoveryCode,
          arguments: enteredEmail,
        );
      } else {
        // Email changed or timer expired: Trigger new OTP
        context.read<AuthCubit>().sendResetOTP(enteredEmail);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          CustomSnackBar.show(
            context,
            message: state.errorMessage,
            type: SnackBarType.error,
          );
        } else if (state is OTPSentSuccess) {
          CustomSnackBar.show(
            context,
            message: 'Recovery code sent to your email',
            type: SnackBarType.success,
          );
          Navigator.pushNamed(
            context,
            Routes.verifyRecoveryCode,
            arguments: state.email,
          );
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    const AuthTopBar(
                      badgeText: 'IELTS ACADEMIC',
                      badgeIcon: Icons.school_outlined,
                    ),
                    SizedBox(height: 40.h),
                    const AuthHeaderIllustration(iconAsset: AppAssets.lockIcon),
                    SizedBox(height: 32.h),
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Enter your registered institutional or personal email to receive a secure password recovery code.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 32.h),
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'example@gmail.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16.r,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Associated with your IELTS Candidate Profile',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: state is AuthLoading
                              ? 'Sending...'
                              : 'Send Verification Code',
                          trailingIcon: state is AuthLoading
                              ? null
                              : Icons.arrow_forward,
                          onPressed: state is AuthLoading
                              ? null
                              : _handleRecovery,
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16.r,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkPrimaryAccent
                              : AppColors.info,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '256-bit encrypted authentication',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    const AuthSecurityInfoCard(
                      title: 'Candidate ID Support',
                      description:
                          'Lost access to your test registration email? Contact your local test center administrator.',
                      icon: Icons.help_outline,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
