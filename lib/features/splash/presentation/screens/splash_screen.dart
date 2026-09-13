import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/manager/auth_cubit.dart';
import '../../../auth/presentation/manager/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // We wait for the animation to finish before navigating,
        // but we can pre-check the state here.
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 260.w,
                      height: 260.h,
                      child: Lottie.asset(
                        AppAssets.splashLottie,
                        controller: _controller,
                        repeat: false,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..forward().whenComplete(() {
                              if (mounted) {
                                final authCubit = context.read<AuthCubit>();
                                final state = authCubit.state;

                                if (state is AuthAuthenticated) {
                                  if (authCubit.isPreferencesCompleted) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.mainShell,
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.gettingStarted,
                                      (route) => false,
                                    );
                                  }
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.signIn,
                                    (route) => false,
                                  );
                                }
                              }
                            });
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 28.r,
                      height: 28.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: Text(
                    'v 1.0.0',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
