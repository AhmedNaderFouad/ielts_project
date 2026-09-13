import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../widgets/password_requirement_tile.dart';
import '../widgets/password_reset_success_dialog.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/auth_header_illustration.dart';
import '../widgets/auth_security_info_card.dart';
import '../widgets/auth_return_to_sign_in.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String resetToken;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isConfirmPasswordObscured = true;

  bool get _isLengthMet => _passwordController.text.length >= 8;
  bool get _isUppercaseMet =>
      RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get _isLowercaseMet =>
      RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _isSpecialMet =>
      RegExp(r'[\d\W_]').hasMatch(_passwordController.text);
  bool get _isMatchMet =>
      _passwordController.text == _confirmPasswordController.text &&
      _confirmPasswordController.text.isNotEmpty;

  bool get _allRequirementsMet =>
      _isLengthMet &&
      _isUppercaseMet &&
      _isLowercaseMet &&
      _isSpecialMet &&
      _isMatchMet;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleReset() {
    if (_formKey.currentState!.validate() && _allRequirementsMet) {
      context.read<AuthCubit>().confirmPasswordReset(
        email: widget.email,
        newPassword: _passwordController.text.trim(),
        resetToken: widget.resetToken,
      );
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
        } else if (state is PasswordResetSuccess) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                PasswordResetSuccessDialog(email: widget.email),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                    const AuthHeaderIllustration(
                      iconAsset: AppAssets.securityIcon,
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Create New Password',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your new password must be distinct from previously used credentials.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 32.h),
                    // Input Fields
                    CustomTextField(
                      label: 'NEW PASSWORD',
                      hintText: '********',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      onChanged: (_) => setState(() {}),
                      validator: AppValidators.validatePassword,
                      hideErrorText: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      label: 'CONFIRM NEW PASSWORD',
                      hintText: '********',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _isConfirmPasswordObscured,
                      controller: _confirmPasswordController,
                      onChanged: (_) => setState(() {}),
                      validator: (value) =>
                          AppValidators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                      hideErrorText: true,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                          () => _isConfirmPasswordObscured =
                              !_isConfirmPasswordObscured,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Real-Time Validation Checklist
                    Column(
                      children: [
                        PasswordRequirementTile(
                          text: 'At least 8 characters',
                          isMet: _isLengthMet,
                        ),
                        PasswordRequirementTile(
                          text: 'Contains an uppercase letter',
                          isMet: _isUppercaseMet,
                        ),
                        PasswordRequirementTile(
                          text: 'Contains a lowercase letter',
                          isMet: _isLowercaseMet,
                        ),
                        PasswordRequirementTile(
                          text: 'Contains a number or special character',
                          isMet: _isSpecialMet,
                        ),
                        PasswordRequirementTile(
                          text: 'Passwords match',
                          isMet: _isMatchMet,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: state is AuthLoading
                              ? 'Resetting...'
                              : 'Reset & Sign In',
                          trailingIcon: state is AuthLoading
                              ? null
                              : Icons.arrow_forward,
                          onPressed:
                              (_allRequirementsMet && state is! AuthLoading)
                              ? _handleReset
                              : null,
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    // Security Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 16.r,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '256-BIT ENCRYPTED CREDENTIAL UPDATE',
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
                    // Info Card
                    const AuthSecurityInfoCard(
                      title: 'Candidate Account Security',
                      description:
                          'Updating your password will securely sign you out of all other active IELTS preparation sessions.',
                      icon: Icons.refresh_rounded,
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
