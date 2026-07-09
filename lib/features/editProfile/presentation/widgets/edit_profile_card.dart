// lib/features/editProfile/presentation/widgets/edit_profile_card.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';

class EditProfileCard extends StatelessWidget {
  final String? name;
  final String? avatarInitials;
  final String? imageUrl;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? buttonTextColor;
  final Color? cancelButtonColor;
  final Color? saveButtonColor;
  final EdgeInsets padding;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onSavePressed;
  final VoidCallback? onCameraPressed;
  final File? selectedImage;
  final bool isSaving;

  const EditProfileCard({
    super.key,
    this.name = 'John Doe',
    this.avatarInitials = 'J',
    this.imageUrl,
    this.textColor = Colors.white,
    this.buttonTextColor = Colors.white,
    this.cancelButtonColor = const Color(0xFF9E9E9E),
    this.saveButtonColor = const Color(0xFFFFD700),
    this.padding = const EdgeInsets.all(24),
    this.onBackPressed,
    this.onCancelPressed,
    this.onSavePressed,
    this.backgroundColor,
    this.onCameraPressed,
    this.selectedImage,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          // Top Bar: Cancel and Save Buttons at Right Top
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: onCancelPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: buttonTextColor,
                  side: BorderSide(color: Colors.white.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon(Icons.close, size: 18.sp, color: Colors.black),
                    SizedBox(width: 4.w),
                    Obx(
                      () => Text(
                        locale.get('cancel'),
                        style: TextStyle(fontSize: 14.sp, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: isSaving ? null : onSavePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSaving ? Colors.grey : saveButtonColor,
                  foregroundColor: buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                ),
                child: Text(
                  isSaving ? 'Save...' : locale.get('save_profile'),
                  style: TextStyle(fontSize: 14.sp, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Avatar Circle + Camera Icon (Centered)
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // Avatar Circle (shows image or initials)
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.w),
                ),
                child: selectedImage != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(selectedImage!, scale: 1.0)
                          ..evict(),
                        radius: 40.w,
                      )
                    : (imageUrl != null && imageUrl!.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl!),
                            radius: 40.w,
                          )
                        : Center(
                            child: Text(
                              avatarInitials ?? 'J',
                              style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
              ),
              // Camera Button
              GestureDetector(
                onTap: onCameraPressed,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.w),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Name Display
          Text(
            name ?? 'John Doe',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
