import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import 'auth_badge.dart';
import 'primary_button.dart';

class LegalContentDialog extends StatelessWidget {
  final String badgeText;
  final String title;
  final String content;
  final VoidCallback onAccept;

  const LegalContentDialog({
    super.key,
    required this.badgeText,
    required this.title,
    required this.content,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.background,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                AuthBadge(text: badgeText.toUpperCase(), icon: Icons.circle),
                SizedBox(height: 16.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  constraints: BoxConstraints(maxHeight: 0.55.sh),
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textMuted,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                PrimaryButton(
                  text: 'I Understand & Accept',
                  onPressed: () {
                    onAccept();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
          // Close Button
          Positioned(
            right: 12.r,
            top: 12.r,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.inputBorder.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 20.r,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
