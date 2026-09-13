import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verify_recovery_code_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/onboarding/presentation/pages/getting_started_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.verifyRecoveryCode:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => VerifyRecoveryCodeScreen(email: email),
        );
      case Routes.verifyEmail:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => VerifyEmailScreen(email: email),
        );
      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final email = args['email'] ?? '';
        final resetToken = args['resetToken'] ?? '';
        return MaterialPageRoute(
          builder: (_) =>
              ResetPasswordScreen(email: email, resetToken: resetToken),
        );
      case Routes.gettingStarted:
        return MaterialPageRoute(builder: (_) => const GettingStartedScreen());
      case Routes.mainShell:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Main Shell Placeholder')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
