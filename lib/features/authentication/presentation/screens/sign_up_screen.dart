// lib/features/authentication/presentation/screens/sign_up_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/utils/constants/icon_path.dart';
import 'package:yasminaarsic/core/utils/constants/image_path.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/authentication/controllers/login_controller.dart';
import 'package:yasminaarsic/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:yasminaarsic/routes/app_routes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Obx(
          () => Text(
            locale.get('signup'),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: SvgPicture.asset(IconPath.backArrow, width: 14.w, height: 14.h),
          onPressed: () => Get.back(),
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
              key: controller.signUpFormKey,
              child: SingleChildScrollView(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          locale.get('welcome'),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        locale.get('welcome_description'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF252525),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 32.h),

                      // Full Name
                      Text(
                        locale.get('full_name'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        hintText: locale.get('john_doe'),
                        keyboardType: TextInputType.name,
                        controller: controller.nameController,
                        validator: controller.validateName,
                      ),
                      SizedBox(height: 24.h),

                      // Email or Mobile
                      Text(
                        locale.get('email'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        hintText: locale.get('example_email'),
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailControllerTwo,
                        validator: controller.validateEmail,
                      ),
                      SizedBox(height: 24.h),
                      // Full Name
                      Text(
                        locale.get('Mobile Number'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField(
                        hintText: locale.get('Enter mobile number'),
                        keyboardType: TextInputType.name,
                        controller: controller.phonecontroller,
                      ),
                      SizedBox(height: 24.h),
                      // Password
                      Text(
                        locale.get('password'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => CustomTextFormField(
                          hintText: locale.get('enter_your_password'),
                          obscureText: controller.obscurePasswordTwo.value,
                          suffixSvg: Icon(
                            controller.obscurePasswordTwo.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onSuffixTap: controller.togglePasswordTwoVisibility,
                          controller: controller.passwordControllerTwo,
                          validator: controller.validatePassword,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // // Confirm Password
                      // Text(
                      //   locale.get('confirm_password'),
                      //   style: TextStyle(
                      //     fontFamily: 'Inter',
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      // SizedBox(height: 8.h),
                      // Obx(
                      //   () => CustomTextFormField(
                      //     hintText: locale.get('enter_your_password'),
                      //     obscureText:
                      //         controller.obscureConfirmPasswordOne.value,
                      //     suffixSvg: Icon(
                      //       controller.obscureConfirmPasswordOne.value
                      //           ? Icons.visibility_off
                      //           : Icons.visibility,
                      //       color: Colors.grey[600],
                      //     ),
                      //     onSuffixTap:
                      //         controller.toggleConfirmPasswordOneVisibility,
                      //     controller: controller.confirmPasswordControllerOne,
                      //     validator: (value) =>
                      //         controller.validatePasswordMatch(
                      //           value,
                      //           controller.passwordControllerTwo.text,
                      //         ),
                      //   ),
                      // ),
                      SizedBox(height: 16.h),

                      // Terms Agreement
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${locale.get('by_continuing')} ',
                            style: TextStyle(
                              color: const Color(0xFF252525),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: locale.get('terms_of_use'),
                                style: TextStyle(
                                  color: const Color(0xFF6C63FE),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              TextSpan(
                                text: ' ${locale.get('and')} ',
                                style: TextStyle(
                                  color: const Color(0xFF252525),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: locale.get('privacy_policy'),
                                style: TextStyle(
                                  color: const Color(0xFF6C63FE),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Sign Up Button
                      Align(
                        alignment: Alignment.center,
                        child: Obx(
                          () => CustomButton(
                            text: locale.get('signup'),
                            textColor: AppColors.yellowAccent,
                            backgroundColor: AppColors.blueColor,
                            type: ButtonType.filled,
                            minWidth: 250.w,
                            borderRadius: 8.r,
                            height: 45.h,
                            loading: controller.isSignUpLoading.value,
                            onPressed: controller.isSignUpLoading.value
                                ? null
                                : controller.signUp,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Social Login
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          locale.get('or_sign_up'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF252525),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Center(
                        child: Image.asset(
                          ImagePath.googleImage,
                          height: 32.h,
                          width: 32.w,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${locale.get('already_have_account')} ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoute.loginScreen),
                            child: Text(
                              locale.get('log_in'),
                              style: TextStyle(
                                color: Color(0xFF6C63FE),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
