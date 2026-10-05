import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AvatarCircle extends StatelessWidget {
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const AvatarCircle({
    super.key,
    required this.initials,
    this.radius = 16,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.primaryLight,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: textColor ?? AppColors.primary,
        ),
      ),
    );
  }
}
