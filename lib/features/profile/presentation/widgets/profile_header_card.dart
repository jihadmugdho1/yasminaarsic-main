import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/profile/controller/profile_controller.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarInitials;
  final Color? backgroundColor;
  final Color? nameColor;
  final Color? emailColor;
  final Color? backButtonColor;
  final Color? editButtonColor;
  final Color? editTextColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.email,
    this.avatarInitials = 'J',
    this.backgroundColor = const Color(0xFF6C5CE7), // Purple as in image
    this.nameColor = Colors.white,
    this.emailColor = Colors.white70,
    this.backButtonColor = Colors.white,
    this.editButtonColor = const Color(0xFFFFD700), // Yellow
    this.editTextColor = Colors.black,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(24),
    this.onBackPressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          // Top Bar: Back + Edit
          Row(
            children: [
              // Back Button
              // TextButton.icon(
              //   onPressed: onBackPressed ?? () => Navigator.pop(context),
              //   icon: Icon(Icons.arrow_back_ios_new, size: 18, color: backButtonColor),
              //   label: Text('Back', style: TextStyle(color: backButtonColor)),
              // ),
              const Spacer(),
              // Edit Button
              Obx(() {
                final controller = Get.find<ProfileController>();
                final isLoading = controller.isLoading.value;
                return FilledButton.icon(
                  onPressed: isLoading ? null : onEditPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: editButtonColor,
                    foregroundColor: editTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  icon: isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              editTextColor ?? Colors.black,
                            ),
                          ),
                        )
                      : Icon(Icons.edit_outlined, size: 18),
                  label: Text(
                    isLoading
                        ? locale.get('loading')
                        : locale.get('edit_profile'),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 32),

          // Avatar Circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(
              child: Text(
                avatarInitials!,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Arial',
              color: nameColor,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'Arial',
              fontWeight: FontWeight.w400,
              color: emailColor,
            ),
          ),
        ],
      ),
    );
  }
}
