// lib/features/authentication/presentation/screens/login_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/widgets/custom_button.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/authentication/controllers/login_controller.dart';
import 'package:yasminaarsic/features/authentication/data/services/authentication_service.dart';
import 'package:yasminaarsic/features/authentication/presentation/widgets/custom_text_form_field.dart';
import 'package:yasminaarsic/features/authentication/presentation/widgets/forgot_password_dialog.dart';
import 'package:yasminaarsic/features/authentication/presentation/widgets/forgot_pass_verification_dialog.dart';
import 'package:yasminaarsic/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller (lazy, auto-disposed)
    final controller = Get.find<LoginController>();
    final locale = Get.find<LocalizationController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Obx(
          () => Text(
            locale.get('login'),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: SvgPicture.asset(IconPath.backArrow, width: 14.w, height: 14.h),
        //   onPressed: () => Get.back(),
        // ),
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
              key: controller.loginFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Title
                    Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          locale.get('welcome'),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Description
                    Obx(
                      () => Text(
                        locale.get('welcome_description'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Email Field Label
                    Obx(
                      () => Text(
                        locale.get('email_or_mobile'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Email Input
                    CustomTextFormField(
                      hintText: locale.get('example_email'),
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.emailControllerOne,
                      validator: controller.validateEmail,
                    ),
                    SizedBox(height: 24.h),

                    // Password Label
                    Obx(
                      () => Text(
                        locale.get('password'),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Password Input
                    Obx(
                      () => CustomTextFormField(
                        hintText: locale.get('enter_your_password'),
                        obscureText: controller.obscurePasswordOne.value,
                        suffixSvg: Icon(
                          controller.obscurePasswordOne.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onSuffixTap: controller.togglePasswordOneVisibility,
                        controller: controller.passwordControllerOne,
                        validator: controller.validatePassword,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(
                        () => TextButton(
                          onPressed: controller.isForgotPasswordLoading.value
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ForgotPasswordDialog(
                                      title: locale.get('forgot_password'),
                                      emailLabel: locale.get('email'),
                                      resetButtonText: locale.get('Send Code'),
                                      primaryColor: AppColors.blueColor,
                                      onClosePressed: () {
                                        Navigator.pop(context);
                                      },
                                      onResetPressed: (email) async {
                                        controller
                                                .isForgotPasswordLoading
                                                .value =
                                            true;
                                        try {
                                          // Call reset password API
                                          final authService =
                                              Get.find<AuthenticationService>();
                                          final response = await authService
                                              .resetPassword(email: email);

                                          if (response != null &&
                                              (response.statusCode == 200 ||
                                                  response.statusCode == 201)) {
                                            AppLoggerHelper.info(
                                              '✅ Password reset code sent successfully!',
                                            );
                                            if (context.mounted) {
                                              Navigator.pop(
                                                context,
                                              ); // Close forgot password dialog
                                            }
                                            // Show verification dialog
                                            Get.dialog(
                                              ForgotPassVerificationDialog(
                                                title:
                                                    'Reset Password Verification',
                                                description:
                                                    'A verification code has been sent to $email.',
                                                loading:
                                                    controller.isVerifyLoading,
                                                onVerifyPressed: (code) async {
                                                  controller
                                                          .isVerifyLoading
                                                          .value =
                                                      true;
                                                  try {
                                                    // Call verify reset code API
                                                    final authService =
                                                        Get.find<
                                                          AuthenticationService
                                                        >();
                                                    final verifyResponse =
                                                        await authService
                                                            .verifyResetCode(
                                                              email: email,
                                                              code: code,
                                                            );

                                                    if (verifyResponse !=
                                                            null &&
                                                        (verifyResponse
                                                                    .statusCode ==
                                                                200 ||
                                                            verifyResponse
                                                                    .statusCode ==
                                                                201)) {
                                                      AppLoggerHelper.info(
                                                        '✅ Reset code verification successful!',
                                                      );

                                                      // Extract token from response and store in controller
                                                      try {
                                                        final responseData =
                                                            jsonDecode(
                                                              verifyResponse
                                                                  .body,
                                                            );
                                                        final token =
                                                            responseData['data']?['resetToken'] ??
                                                            responseData['data']?['token'];
                                                        if (token != null) {
                                                          controller
                                                                  .resetToken =
                                                              token;
                                                          await StorageService.saveResetToken(
                                                            token,
                                                          );
                                                          AppLoggerHelper.info(
                                                            '🔑 Token extracted and stored: $token',
                                                          );
                                                        }
                                                      } catch (e) {
                                                        AppLoggerHelper.error(
                                                          '❌ Failed to extract token: $e',
                                                        );
                                                      }

                                                      // Close dialog and navigate
                                                      if (context.mounted) {
                                                        Navigator.pop(
                                                          context,
                                                        ); // Close verification dialog
                                                      }
                                                      Get.toNamed(
                                                        AppRoute
                                                            .setPasswordScreen,
                                                      );
                                                    } else {
                                                      AppLoggerHelper.error(
                                                        '❌ Reset code verification failed',
                                                      );
                                                    }
                                                  } finally {
                                                    controller
                                                            .isVerifyLoading
                                                            .value =
                                                        false;
                                                  }
                                                },
                                                onResendPressed: () async {
                                                  // Resend code logic
                                                  final authService =
                                                      Get.find<
                                                        AuthenticationService
                                                      >();
                                                  final resendResponse =
                                                      await authService
                                                          .resetPassword(
                                                            email: email,
                                                          );

                                                  if (resendResponse != null &&
                                                      (resendResponse
                                                                  .statusCode ==
                                                              200 ||
                                                          resendResponse
                                                                  .statusCode ==
                                                              201)) {
                                                    AppLoggerHelper.info(
                                                      '✅ Reset code resent successfully!',
                                                    );
                                                  } else {
                                                    AppLoggerHelper.error(
                                                      '❌ Failed to resend reset code',
                                                    );
                                                  }
                                                },
                                                onClosePressed: () {
                                                  Get.back(); // Close verification dialog
                                                },
                                              ),
                                              barrierDismissible: false,
                                            );
                                          } else {
                                            AppLoggerHelper.error(
                                              '❌ Failed to send reset code: ${response?.statusCode}',
                                            );
                                          }
                                        } finally {
                                          controller
                                                  .isForgotPasswordLoading
                                                  .value =
                                              false;
                                        }
                                      },
                                    ),
                                  );
                                },
                          child: Obx(
                            () => Text(
                              controller.isForgotPasswordLoading.value
                                  ? '${locale.get('forgot_password')}..'
                                  : locale.get('forgot_password'),
                              style: TextStyle(
                                color: controller.isForgotPasswordLoading.value
                                    ? Colors.grey
                                    : AppColors.blueColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Login Button
                    Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () => CustomButton(
                          text: locale.get('login'),
                          textColor: AppColors.yellowAccent,
                          backgroundColor: AppColors.blueColor,
                          type: ButtonType.filled,
                          minWidth: 207.w,
                          borderRadius: 8.r,
                          height: 45.h,
                          loading: controller.isLoginLoading.value,
                          onPressed: controller.isLoginLoading.value
                              ? null
                              : controller
                                    .login, // ✅ Business logic in controller
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Divider Text
                    Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () => Text(
                          locale.get('or_sign_up_with'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF252525),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Social Login Icons
                    Center(
                      child: InkWell(
                        onTap: controller.signUpWithGoogle,
                        child: Image.asset(
                          ImagePath.googleImage,
                          height: 40.h,
                          width: 40.h,
                        ),
                      ),
                    ),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            locale.get('dont_have_account'),
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoute.signUpScreen);
                          },
                          child: Obx(
                            () => Text(
                              locale.get('sign_up'),
                              style: TextStyle(color: Color(0xFF6C63FE)),
                            ),
                          ),
                        ),
                      ],
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
