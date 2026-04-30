// lib/features/authentication/presentation/screens/set_password_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/utils/constants/icon_path.dart';
import 'package:yasminaarsic/features/authentication/controllers/login_controller.dart';
import 'package:yasminaarsic/features/authentication/presentation/widgets/custom_text_form_field.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final controller = Get.find<LoginController>();
  late final String? resetToken;
  late final bool isChangePassword;

  @override
  void initState() {
    super.initState();
    print('🔑 SetPasswordScreen.initState() - Get.arguments: ${Get.arguments}');
    resetToken = Get.arguments as String?;
    isChangePassword = resetToken == null;
    print(
      '🔑 SetPasswordScreen.initState() - resetToken assigned: $resetToken, isChangePassword: $isChangePassword',
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          isChangePassword ? 'Change Password' : 'Set Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset(IconPath.backArrow, width: 14.w, height: 14.h),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0.r),
            child: Form(
              key: controller.setPasswordFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your password must be at-least 8 characters long.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF252525),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    if (isChangePassword) ...[
                      Text(
                        'Enter current password',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => CustomTextFormField(
                          hintText: 'Enter current password',
                          obscureText: controller.obscureCurrentPassword.value,
                          suffixSvg: Icon(
                            controller.obscureCurrentPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onSuffixTap:
                              controller.toggleCurrentPasswordVisibility,
                          controller: controller.currentPasswordController,
                          validator: controller.validatePassword,
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    Text(
                      'Enter new password',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => CustomTextFormField(
                        hintText: 'Enter new password',
                        obscureText: controller.obscureNewPasswordThree.value,
                        suffixSvg: Icon(
                          controller.obscureNewPasswordThree.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onSuffixTap:
                            controller.toggleNewPasswordThreeVisibility,
                        controller: controller.newPasswordControllerThree,
                        validator: controller.validatePassword,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    Text(
                      'Reconfirm new password',
                      style: TextStyle(
                        fontFamily: 'inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => CustomTextFormField(
                        hintText: 'Reconfirm new password',
                        obscureText: controller.obscureConfirmPasswordTwo.value,
                        suffixSvg: Icon(
                          controller.obscureConfirmPasswordTwo.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onSuffixTap:
                            controller.toggleConfirmPasswordTwoVisibility,
                        controller: controller.confirmPasswordControllerTwo,
                        validator: (value) => controller.validatePasswordMatch(
                          value,
                          controller.newPasswordControllerThree.text,
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),

                    Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () => CustomButton(
                          text: 'Set Password',
                          textColor: AppColors.yellowAccent,
                          backgroundColor: AppColors.blueColor,
                          type: ButtonType.filled,
                          minWidth: 207.w,
                          borderRadius: 8.r,
                          height: 45.h,
                          loading: controller.isSetPasswordLoading.value,
                          onPressed: controller.isSetPasswordLoading.value
                              ? null
                              : () {
                                  print(
                                    '🔑 Button pressed - resetToken: $resetToken, isChangePassword: $isChangePassword',
                                  );
                                  if (isChangePassword) {
                                    controller.changePassword();
                                  } else {
                                    controller.setPassword(resetToken);
                                  }
                                },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
