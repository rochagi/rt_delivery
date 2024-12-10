import 'package:flutter/material.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const CustomElevatedButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.orange,
        ),
        onPressed: onTap,
        child: Padding(
          padding: padding ??
              const EdgeInsets.only(top: 16, bottom: 16, left: 5, right: 5),
          child: Text(
            title,
            style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
