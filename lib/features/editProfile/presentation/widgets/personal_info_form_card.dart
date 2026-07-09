// lib/features/editProfile/presentation/widgets/personal_info_form_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/authentication/presentation/widgets/custom_text_form_field.dart'; // ✅ Your widget

class PersonalInfoFormCard extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextEditingController birthDateController;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? labelColor;
  final Color? inputBackgroundColor;
  final Color? iconColor;
  final EdgeInsets padding;
  final VoidCallback? onBirthDatePressed;
  final String? Function(String?)? emailValidator;
  final String? Function(String?)? phoneValidator;
  final String? Function(String?)? locationValidator;
  final String? Function(String?)? birthDateValidator;
  final GlobalKey<FormState>? formKey;

  const PersonalInfoFormCard({
    super.key,
    this.title = 'Personal Information',
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
    required this.birthDateController,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black87,
    this.labelColor = Colors.grey,
    this.inputBackgroundColor = const Color(0xFFF5F5F5),
    this.iconColor = Colors.grey,
    this.padding = const EdgeInsets.all(20),
    this.onBirthDatePressed,
    this.emailValidator,
    this.phoneValidator,
    this.locationValidator,
    this.birthDateValidator,
    this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Container(
      padding: EdgeInsets.all(padding.horizontal.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Obx(() {
              locale.currentLanguage.value; // Trigger reactive update
              return Text(
                locale.get('personal_information'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                  color: titleColor,
                ),
              );
            }),
            SizedBox(height: 24.h),
            // Name
            _buildLabeledField(
              label: 'Name',
              icon: Icons.person_outline,
              child: CustomTextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                fillColor: inputBackgroundColor,
                borderRadius: 8.r,
                // No specific validator for name is passed, so removing the incorrect emailValidator
              ),
            ),
            SizedBox(height: 16.h),



            // Email
            _buildLabeledField(
              label: 'email',
              icon: Icons.email_outlined,
              child: CustomTextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                fillColor: inputBackgroundColor,
                borderRadius: 8.r,
                validator: emailValidator,
              ),
            ),
            SizedBox(height: 16.h),

            // Phone
            _buildLabeledField(
              label: 'phone',
              icon: Icons.phone_outlined,
              child: CustomTextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                fillColor: inputBackgroundColor,
                borderRadius: 8.r,
                validator: phoneValidator,
              ),
            ),
            SizedBox(height: 16.h),

            // Location
            _buildLabeledField(
              label: 'location',
              icon: Icons.location_on_outlined,
              child: CustomTextFormField(
                controller: locationController,
                fillColor: inputBackgroundColor,
                borderRadius: 8.r,
                validator: locationValidator,
              ),
            ),
            SizedBox(height: 16.h),

            // Birth Date (read-only with trailing icon)
            _buildLabeledField(
              label: 'birth_date',
              icon: Icons.calendar_today_outlined,
              child: CustomTextFormField(
                controller: birthDateController,
                fillColor: inputBackgroundColor,
                borderRadius: 8.r,
                readOnly: true,
                validator: birthDateValidator,
                onTap: onBirthDatePressed,
                suffixSvg: Icon(
                  Icons.calendar_today_outlined,
                  color: iconColor,
                  size: 20.sp,
                ),
                onSuffixTap: onBirthDatePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final locale = Get.find<LocalizationController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          locale.currentLanguage.value; // Trigger reactive update
          return Text(
            locale.get(label),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          );
        }),
        SizedBox(height: 4.h),
        Row(
          children: [
            Icon(icon, size: 20.sp, color: iconColor),
            SizedBox(width: 12.w),
            Expanded(child: child),
          ],
        ),
      ],
    );
  }
}
