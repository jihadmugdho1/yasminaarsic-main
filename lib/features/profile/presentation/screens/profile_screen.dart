// lib/features/profile/presentation/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:vendora/core/common/widgets/custom_button.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/core/utils/constants/icon_path.dart';
import 'package:vendora/features/profile/controller/profile_controller.dart';
import 'package:vendora/features/profile/presentation/widgets/language_selection_card.dart';
import 'package:vendora/features/profile/presentation/widgets/notification_preferences_card.dart';
import 'package:vendora/features/profile/presentation/widgets/password_change_card.dart';
import 'package:vendora/features/profile/presentation/widgets/profile_detail_card.dart';
import 'package:vendora/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:vendora/features/profile/presentation/widgets/language_selection_card_shimmer.dart';
import 'package:vendora/features/profile/presentation/widgets/notification_preferences_card_shimmer.dart';
import 'package:vendora/features/profile/presentation/widgets/password_change_card_shimmer.dart';
import 'package:vendora/features/profile/presentation/widgets/profile_details_card_shimmer.dart';
import 'package:vendora/features/profile/presentation/widgets/profile_header_card_shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final locale = Get.find<LocalizationController>();

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
                  return const ProfileHeaderCardShimmer();
                } else {
                  final p = controller.profile.value;
                  return ProfileHeaderCard(
                    name: p.name,
                    email: p.email,
                    avatarInitials: p.avatarInitials,
                    imageUrl: p.imageUrl,
                    backgroundColor: const Color(0xFF6C63FE),
                    nameColor: Colors.white,
                    emailColor: Colors.white70,
                    backButtonColor: Colors.white,
                    editButtonColor: const Color(0xFFFFD700),
                    editTextColor: Colors.black,
                    onEditPressed: controller.onEditPressed,
                  );
                }
              }),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const ProfileDetailsCardShimmer();
                  } else {
                    final p = controller.profile.value;
                    return ProfileDetailsCard(
                      name: p.name,
                      email: p.email,
                      phone: p.phone,
                      location: p.location,
                      birthDate: p.birthDate,
                      backgroundColor: Colors.white,
                      textColor: Colors.black87,
                      labelColor: Colors.grey,
                      iconColor: Colors.grey,
                      onTap: controller.onProfileCardTap,
                      onEmailTap: controller.onEmailTap,
                      onPhoneTap: controller.onPhoneTap,
                    );
                  }
                }),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const PasswordChangeCardShimmer();
                  } else {
                    return PasswordChangeCard(
                      title: locale.get('change_password'),
                      buttonText: locale.get('change_password'),
                      backgroundColor: Colors.white,
                      titleColor: Colors.black87,
                      buttonColor: const Color(0xFFFFD700),
                      buttonTextColor: Colors.black,
                      icon: Icons.lock_outlined,
                      onPressed: controller.onChangePasswordPressed,
                      onTap: controller.onPasswordCardTap,
                    );
                  }
                }),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const LanguageSelectionCardShimmer();
                  } else {
                    return LanguageSelectionCard(
                      title: locale.get('language'),
                      selectedLanguage: controller.selectedLanguage.value,
                      onLanguageChanged: controller.onLanguageChanged,
                      backgroundColor: Colors.white,
                      titleColor: Colors.black87,
                    );
                  }
                }),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const NotificationPreferencesCardShimmer();
                  } else {
                    final prefs =
                        controller.profile.value.notificationPreferences;
                    return NotificationPreferencesCard(
                      title: locale.get('notification_preferences'),
                      preferences: [
                        for (int i = 0; i < prefs.length; i++)
                          NotificationPreference(
                            label: prefs[i].label,
                            description: prefs[i].description,
                            isEnabled: prefs[i].isEnabled,
                            onChanged: (value) =>
                                controller.onNotificationToggle(i, value),
                          ),
                      ],
                      backgroundColor: Colors.white,
                      titleColor: Colors.black87,
                      labelColor: Colors.black,
                      descriptionColor: Colors.grey,
                      iconColor: Colors.grey,
                      onTap: controller.onNotificationPreferencesTap,
                    );
                  }
                }),
              ),
              // SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: CustomButton(
                  text: locale.get('logout'),
                  textColor: const Color(0xFF4F39F6),
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFF4F39F6),
                  leadingIcon: SvgPicture.asset(IconPath.logoutIcon),
                  type: ButtonType.text,
                  minWidth: double.infinity,
                  borderRadius: 8.r,
                  height: 36.h,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.white,
                      title: Text(locale.get('logout')),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF4F39F6)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            controller.onLogoutPressed();
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Color(0xFF4F39F6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
