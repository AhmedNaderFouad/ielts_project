import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_auth_button.dart';
import '../../../../core/widgets/or_divider.dart';
import '../../../../core/widgets/auth_badge.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        rememberMe: _rememberMe,
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
        } else if (state is AuthAuthenticated) {
          CustomSnackBar.show(
            context,
            message: 'Welcome back!',
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
                    SizedBox(height: 40.h),
                    Image.asset(AppAssets.appLogo, width: 80.r, height: 80.r),
                    SizedBox(height: 24.h),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to continue your IELTS prep',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16.h),
                    const AuthBadge(
                      text: 'Target: Band 8.0+ Academic',
                      icon: Icons.circle,
                    ),
                    SizedBox(height: 32.h),
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'scholar@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: AppValidators.validateEmail,
                      onChanged: (_) => setState(() {}),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      label: 'Password',
                      hintText: '********',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      controller: _passwordController,
                      validator: AppValidators.validatePassword,
                      onChanged: (_) => setState(() {}),
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
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) =>
                                    setState(() => _rememberMe = value!),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.white
                                    : AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            Routes.forgotPassword,
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.darkPrimaryAccent
                                  : AppColors.primary,
                              fontWeight: FontWeight.w600,
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
                              ? 'Signing In...'
                              : 'Sign In',
                          trailingIcon: state is AuthLoading
                              ? null
                              : Icons.arrow_forward,
                          onPressed: state is AuthLoading
                              ? null
                              : _handleSignIn,
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    const OrDivider(),
                    SizedBox(height: 32.h),
                    SocialAuthButton(
                      text: 'Continue with Google',
                      assetPath: AppAssets.googleIcon,
                      onPressed: () => context
                          .read<AuthCubit>()
                          .signInWithGoogle(rememberMe: _rememberMe),
                    ),
                    SizedBox(height: 16.h),
                    SocialAuthButton(
                      text: 'Continue with Apple',
                      assetPath: Theme.of(context).brightness == Brightness.dark
                          ? AppAssets.appleIconWhite
                          : AppAssets.appleIconBlack,
                      onPressed: () {},
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.signUp),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
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
