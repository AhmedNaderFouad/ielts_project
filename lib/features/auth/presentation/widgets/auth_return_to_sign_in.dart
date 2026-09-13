import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthReturnToSignIn extends StatelessWidget {
  final VoidCallback onTap;

  const AuthReturnToSignIn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.arrow_back, size: 16),
      label: const Text('Return to Candidate Sign In'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
