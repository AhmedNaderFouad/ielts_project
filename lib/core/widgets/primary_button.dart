import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          if (trailingIcon != null) ...[
            SizedBox(width: 8.w),
            Icon(trailingIcon, size: 20.r),
          ],
        ],
      ),
    );
  }
}
