import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/legal_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_auth_button.dart';
import '../../../../core/widgets/or_divider.dart';
import '../../../../core/widgets/legal_content_dialog.dart';
import 'package:ielts_project/core/routing/routes.dart';
import '../../../../core/utils/app_validators.dart';
import '../widgets/password_requirement_tile.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../widgets/auth_top_bar.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isNameValid =>
      AppValidators.validateName(_nameController.text) == null;
  bool get _isEmailValid =>
      AppValidators.validateEmail(_emailController.text) == null;

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

  bool get _canSubmit =>
      _isNameValid && _isEmailValid && _allRequirementsMet && _agreeToTerms;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate() && _canSubmit) {
      final enteredEmail = _emailController.text.trim();
      final lastSignUpEmail = context.read<AuthCubit>().lastSignUpEmail;

      if (enteredEmail == lastSignUpEmail &&
          context.read<AuthCubit>().resendCooldown > 0) {
        // Email is unchanged and timer is active:
        // Simply navigate to OTP screen
        Navigator.pushNamed(
          context,
          Routes.verifyEmail,
          arguments: enteredEmail,
        );
      } else {
        // Email changed or timer expired: Trigger new Sign Up / OTP flow
        context.read<AuthCubit>().signUp(
          name: _nameController.text.trim(),
          email: enteredEmail,
          password: _passwordController.text.trim(),
        );
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => LegalContentDialog(
        badgeText: 'Terms of Service',
        title: 'User Agreement',
        content: LegalConstants.termsOfServiceText,
        onAccept: () => setState(() => _agreeToTerms = true),
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => LegalContentDialog(
        badgeText: 'Privacy Policy',
        title: 'Data Protection',
        content: LegalConstants.privacyPolicyText,
        onAccept: () => setState(() => _agreeToTerms = true),
      ),
    );
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
        } else if (state is SignupOTPRequired) {
          CustomSnackBar.show(
            context,
            message: 'Verification code sent!',
            type: SnackBarType.success,
          );
          Navigator.pushNamed(
            context,
            Routes.verifyEmail,
            arguments: state.email,
          );
        } else if (state is AuthAuthenticated) {
          CustomSnackBar.show(
            context,
            message: 'Account created successfully!',
            type: SnackBarType.success,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.gettingStarted,
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                    const AuthTopBar(),
                    SizedBox(height: 8.h),
                    Image.asset(AppAssets.appLogo, width: 60.r, height: 60.r),
                    SizedBox(height: 16.h),
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Start your journey to band 8.0+',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24.h),
                    CustomTextField(
                      label: 'Full Name',
                      hintText: 'Alexander Wright',
                      prefixIcon: Icons.person_outline,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: AppValidators.validateName,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'example@gmail.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Password',
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Confirm Password',
                      hintText: '********',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
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
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) =>
                              setState(() => _agreeToTerms = value!),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkPrimaryAccent
                                        : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _showTermsDialog,
                                ),
                                const TextSpan(text: ' & '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.darkPrimaryAccent
                                        : AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _showPrivacyDialog,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: state is AuthLoading
                              ? 'Creating Account...'
                              : 'Verify & Create Account',
                          trailingIcon: state is AuthLoading
                              ? null
                              : Icons.arrow_forward,
                          onPressed: (_canSubmit && state is! AuthLoading)
                              ? _handleSignUp
                              : null,
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    const OrDivider(text: "OR SIGN UP WITH"),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: SocialAuthButton(
                            text: 'Google',
                            assetPath: AppAssets.googleIcon,
                            onPressed: () =>
                                context.read<AuthCubit>().signInWithGoogle(),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SocialAuthButton(
                            text: 'Apple',
                            assetPath:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppAssets.appleIconWhite
                                : AppAssets.appleIconBlack,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkPrimaryAccent
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
