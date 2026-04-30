// lib/features/editProfile/presentation/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/features/editProfile/controller/edit_profile_controller.dart';
import 'package:yasminaarsic/features/editProfile/presentation/widgets/edit_profile_card.dart';
import 'package:yasminaarsic/features/editProfile/presentation/widgets/personal_info_form_card.dart';
import 'package:yasminaarsic/features/editProfile/presentation/widgets/edit_profile_card_shimmer.dart';
import 'package:yasminaarsic/features/editProfile/presentation/widgets/personal_info_form_card_shimmer.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SafeArea(
          child: Column(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return const EditProfileCardShimmer();
                } else {
                  final p = controller.profile.value;
                  return EditProfileCard(
                    name: p.name,
                    avatarInitials: p.avatarInitials,
                    backgroundColor: const Color(0xFF6C63FE),
                    textColor: Colors.white,
                    buttonTextColor: Colors.white,
                    cancelButtonColor: const Color(0xFF9E9E9E),
                    saveButtonColor: const Color(0xFFFFD700),
                    onBackPressed: controller.onBackPressed,
                    onCancelPressed: controller.onCancelPressed,
                    onSavePressed: controller.onSavePressed,
                    onCameraPressed: controller.onCameraPressed,
                    selectedImage: controller.selectedImage.value,
                    isSaving: controller.isSaving.value,
                  );
                }
              }),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const PersonalInfoFormCardShimmer();
                  } else {
                    return PersonalInfoFormCard(
                      emailController: controller.emailController,
                      nameController: controller.nameController,
                      phoneController: controller.phoneController,
                      locationController: controller.locationController,
                      birthDateController: controller.birthDateController,
                      onBirthDatePressed: controller.onBirthDatePressed,
                      emailValidator: controller.validateEmail,
                      phoneValidator: controller.validatePhone,
                      locationValidator: controller.validateLocation,
                      birthDateValidator: controller.validateBirthDate,
                      formKey: controller.formKey,
                    );
                  }
                }),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
