import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class AuthHeaderIllustration extends StatelessWidget {
  final String iconAsset;
  final Color? glowColor;

  const AuthHeaderIllustration({
    super.key,
    required this.iconAsset,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppColors.primary;
    return Container(
      width: 120.r,
      height: 120.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.05),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [Image.asset(iconAsset, width: 60.r, height: 60.r)],
      ),
    );
  }
}
