import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionButtonText;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? actionButtonColor;
  final Color? actionTextColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  const NotificationHeaderCard({
    super.key,
    this.title = 'Notifications',
    this.subtitle = 'You have 1 unread notification',
    this.actionButtonText = 'Mark All as Read',
    this.backgroundColor = const Color(0xFF6C5CE7), // Purple as in image
    this.titleColor = Colors.white,
    this.subtitleColor = Colors.white70,
    this.actionButtonColor = const Color(0xFFFFD700), // Yellow
    this.actionTextColor = const Color(0xFF0A0A0A),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
    this.onActionPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.h,
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.r),
            bottomRight: Radius.circular(10.r),
          ),
        ),
        child: Row(
          children: [
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),

            // Action Button
            FilledButton(
              onPressed: onActionPressed,
              style: FilledButton.styleFrom(
                backgroundColor: actionButtonColor,
                foregroundColor: actionTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
              ),
              child: Text(actionButtonText),
            ),
          ],
        ),
      ),
    );
  }
}
