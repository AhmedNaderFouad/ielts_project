import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/auth_badge.dart';

class AuthTopBar extends StatelessWidget {
  final String? badgeText;
  final IconData? badgeIcon;
  final VoidCallback? onBackTap;

  const AuthTopBar({super.key, this.badgeText, this.badgeIcon, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomBackButton(onPressed: onBackTap),
        if (badgeText != null) AuthBadge(text: badgeText!, icon: badgeIcon),
      ],
    );
  }
}
