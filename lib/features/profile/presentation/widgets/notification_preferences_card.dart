// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';

class NotificationPreferencesCard extends StatelessWidget {
  final String title;
  final List<NotificationPreference> preferences;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? labelColor;
  final Color? descriptionColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const NotificationPreferencesCard({
    super.key,
    this.title = 'Notification Preferences',
    required this.preferences,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black87,
    this.labelColor = Colors.black,
    this.descriptionColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + Icon
            Row(
              children: [
                Icon(Icons.notifications_outlined, size: 20, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial',
                    color: titleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Preferences List
            ...preferences.map((pref) => _buildPreferenceItem(pref)),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(NotificationPreference pref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pref.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                    color: labelColor,
                  ),
                ),
                if (pref.description.isNotEmpty)
                  Text(
                    pref.description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: descriptionColor,
                    ),
                  ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9, // Make the switch 80% of its original size
            child: Switch(
              value: pref.isEnabled,
              onChanged: (value) {
                pref.onChanged?.call(value);
                Get.snackbar(
                  pref.label,
                  value ? '${pref.label} enabled' : '${pref.label} disabled',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              // --- Border / Outline Color ---
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                Set<WidgetState> states,
              ) {
                return states.contains(WidgetState.selected)
                    ? AppColors.primary
                    : AppColors.textSecondary.withOpacity(0.2);
              }),
              activeThumbColor: AppColors.white,
              activeTrackColor: AppColors.primary,
              activeColor: AppColors.primary,

              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              inactiveThumbColor: AppColors.textSecondary.withOpacity(0.36),
              inactiveTrackColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class to define each preference item
class NotificationPreference {
  final String label;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;

  const NotificationPreference({
    required this.label,
    this.description = '',
    required this.isEnabled,
    this.onChanged,
  });
}
