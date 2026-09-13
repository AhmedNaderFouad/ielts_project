import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class PasswordRequirementTile extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordRequirementTile({
    super.key,
    required this.text,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
              key: ValueKey(isMet),
              color: isMet
                  ? Colors.green
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted),
              size: 18.r,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: isMet
                  ? (isDark ? AppColors.white : AppColors.textDark)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textMuted),
              fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
