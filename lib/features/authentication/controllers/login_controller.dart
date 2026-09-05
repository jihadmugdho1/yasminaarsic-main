import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/authentication/controllers/google_sign_in_controller.dart';
import 'package:vendora/features/authentication/data/services/authentication_service.dart';
import 'package:vendora/features/authentication/presentation/widgets/verification_code_dialog.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:vendora/features/bottom_navbar/screen/main_app_screen.dart';
import 'package:vendora/routes/app_routes.dart';

class LoginController extends GetxController {
  // Form keys for validation
  final loginFormKey = GlobalKey<FormState>();
  final setPasswordFormKey = GlobalKey<FormState>();

  // Loading states
  final isLoginLoading = false.obs;
  final isSetPasswordLoading = false.obs;
  final isForgotPasswordLoading = false.obs;
  final isVerifyLoading = false.obs;

  // Text Editing Controllers
  final emailControllerOne = TextEditingController();
  final passwordControllerOne = TextEditingController();
  final newPasswordControllerOne = TextEditingController();
  final newPasswordControllerTwo = TextEditingController();
  final newPasswordControllerThree = TextEditingController();
  final confirmPasswordControllerOne = TextEditingController();
  final confirmPasswordControllerTwo = TextEditingController();
  final currentPasswordController = TextEditingController();
  String? resetToken;

  // Password visibility
  var obscurePasswordOne = true.obs;
  var obscureNewPasswordOne = true.obs;
  var obscureNewPasswordTwo = true.obs;
  var obscureNewPasswordThree = true.obs;
  var obscureConfirmPasswordTwo = true.obs;
  var obscureCurrentPassword = true.obs;

  void togglePasswordOneVisibility() =>
      obscurePasswordOne.value = !obscurePasswordOne.value;

  void toggleNewPasswordOneVisibility() =>
      obscureNewPasswordOne.value = !obscureNewPasswordOne.value;

  void toggleNewPasswordTwoVisibility() =>
      obscureNewPasswordTwo.value = !obscureNewPasswordTwo.value;

  void toggleNewPasswordThreeVisibility() =>
      obscureNewPasswordThree.value = !obscureNewPasswordThree.value;

  void toggleConfirmPasswordTwoVisibility() =>
      obscureConfirmPasswordTwo.value = !obscureConfirmPasswordTwo.value;

  void toggleCurrentPasswordVisibility() =>
      obscureCurrentPassword.value = !obscureCurrentPassword.value;

  // Delegate Google Sign-In to GoogleSignInController for backwards compatibility
  RxBool get isLoading => Get.find<GoogleSignInController>().isLoading;

  Future<void> signUpWithGoogle() =>
      Get.find<GoogleSignInController>().signInWithGoogle();

  Future<void> signOutGoogle() =>
      Get.find<GoogleSignInController>().signOutGoogle();

  Future<void> _registerFcmToken() async {
    final fcmToken = StorageService.fcmToken;
    if (fcmToken == null) {
      AppLoggerHelper.error('❌ No FCM token found');
      return;
    }

    final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
    final deviceId = Random().nextInt(1000000).toString();

    try {
      final authService = Get.find<AuthenticationService>();
      final response = await authService.registerFcmToken(
        token: fcmToken,
        platform: platform,
        deviceId: deviceId,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        AppLoggerHelper.info('✅ FCM token registered successfully');
      } else {
        AppLoggerHelper.error(
          '❌ Failed to register FCM token: ${response?.statusCode}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Error registering FCM token: $e');
    }
  }

  void login() async {
    // Validate form before proceeding
    if (loginFormKey.currentState?.validate() ?? false) {
      isLoginLoading.value = true;
      try {
        final authService = Get.find<AuthenticationService>();

        final response = await authService.login(
          email: emailControllerOne.text,
          password: passwordControllerOne.text,
        );

        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          AppLoggerHelper.info('✅ Login successful!');
          AppLoggerHelper.info('📥 Login Response: ${response.body}');

          final responseData = jsonDecode(response.body);
          final success = responseData['success'];
          final data = responseData['data'];
          final accessToken = data['accessToken'];
          final userId = data['user']['id'];
          final message = responseData['message'];

          AppLoggerHelper.info('🔑 Access Token: $accessToken');
          AppLoggerHelper.info('🆔 User ID: $userId');
          AppLoggerHelper.info('📄 Message: $message');

          if (success == true) {
            await StorageService.saveToken(accessToken, userId);
            AppLoggerHelper.info(
              '💾 Token and User ID saved to shared preferences',
            );

            final trialDays = data['trialDaysRemaining'];
            final hasSubscription = data['hasActiveSubscription'];
            if (trialDays != null || hasSubscription != null) {
              await StorageService.saveTrialAndSubscription(
                trialDaysRemaining: trialDays is int
                    ? trialDays
                    : int.tryParse(trialDays.toString()) ?? 0,
                hasActiveSubscription: hasSubscription == true,
              );
              AppLoggerHelper.info(
                '💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from login.',
              );
            }

            await _registerFcmToken();

            Future.delayed(const Duration(milliseconds: 800), () {
              Get.offAll(() => MainAppScreen());
            });
          } else {
            AppLoggerHelper.error('❌ Login failed: success is not true');
            Get.snackbar(
              'Login Failed',
              message ?? 'Something went wrong. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          AppLoggerHelper.error(
            '❌ Login failed with status: ${response?.statusCode}',
          );
          String errorMessage = 'Something went wrong. Please try again.';
          try {
            if (response != null && response.body.isNotEmpty) {
              final errorData = jsonDecode(response.body);
              errorMessage = errorData['message'] as String? ?? errorMessage;
            }
          } catch (_) {}

          if (response?.statusCode == 401 &&
              errorMessage.toLowerCase().contains('verify your email')) {
            Get.snackbar(
              'Email Not Verified',
              'Please verify your email to continue.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            _showLoginVerificationDialog();
          } else {
            Get.snackbar(
              'Login Failed',
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      } catch (e) {
        AppLoggerHelper.error('❌ Login error: $e', e);
      } finally {
        isLoginLoading.value = false;
      }
    }
  }

  void _showLoginVerificationDialog() {
    Get.dialog(
      VerificationCodeDialog(
        title: 'Email Verification',
        description:
            'A verification code has been sent to ${emailControllerOne.text}.',
        loading: isVerifyLoading,
        onSubmitPressed: _verifyLoginEmailCode,
        onChangeEmailPressed: () => Get.back(),
        onClosePressed: () => Get.back(),
      ),
      barrierDismissible: false,
    );
  }

  void _verifyLoginEmailCode(String code) async {
    isVerifyLoading.value = true;
    try {
      final authService = Get.find<AuthenticationService>();
      final response = await authService.verifyEmail(
        email: emailControllerOne.text,
        code: code,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final responseData = jsonDecode(response.body);
        final success = responseData['success'];
        final data = responseData['data'];
        final accessToken = data['accessToken'];
        final userId = data['user']['id'];

        if (success == true) {
          await StorageService.saveToken(accessToken, userId);
          final trialDays = data['trialDaysRemaining'];
          final hasSubscription = data['hasActiveSubscription'];
          if (trialDays != null || hasSubscription != null) {
            await StorageService.saveTrialAndSubscription(
              trialDaysRemaining: trialDays is int
                  ? trialDays
                  : int.tryParse(trialDays.toString()) ?? 0,
              hasActiveSubscription: hasSubscription == true,
            );
            AppLoggerHelper.info(
              '💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from login verify.',
            );
          }
          Get.back();
          await _registerFcmToken();
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offAll(() => MainAppScreen());
          });
        } else {
          Get.snackbar(
            'Verification Failed',
            responseData['message'] ?? 'Verification failed. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        String errorMessage = 'Verification failed. Please try again.';
        try {
          if (response != null && response.body.isNotEmpty) {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] as String? ?? errorMessage;
          }
        } catch (_) {}
        Get.snackbar(
          'Verification Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Verify login email error: $e', e);
    } finally {
      isVerifyLoading.value = false;
    }
  }

  void verifyResetCode(String code) async {
    try {
      final authService = Get.find<AuthenticationService>();
      final response = await authService.verifyResetCode(
        email: emailControllerOne.text,
        code: code,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        AppLoggerHelper.info('✅ Reset code verification successful!');
        AppLoggerHelper.info('📥 Verify Reset Code Response: ${response.body}');

        final responseData = jsonDecode(response.body);
        final success = responseData['success'];
        final message = responseData['message'];
        final data = responseData['data'];

        AppLoggerHelper.info('📄 Message: $message');

        if (success == true) {
          final token = data is Map
              ? (data['resetToken'] ?? data['token'])
              : null;

          if (token != null) {
            resetToken = token;
            await StorageService.saveResetToken(token);
            AppLoggerHelper.info('🔑 Reset token stored: $token');
          } else {
            AppLoggerHelper.error('❌ No reset token found in response data');
          }

          Get.back();
          Get.toNamed(AppRoute.setPasswordScreen, arguments: token);
          AppLoggerHelper.info('🔄 Navigate to set password screen');
        } else {
          AppLoggerHelper.error(
            '❌ Reset code verification failed: success is not true',
          );
        }
      } else {
        AppLoggerHelper.error(
          '❌ Reset code verification failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Verify reset code error: $e', e);
    }
  }

  void setPassword([String? token]) async {
    final resetTokenValue = token ?? resetToken ?? StorageService.resetToken;
    AppLoggerHelper.info(
      '🔑 SetPassword called - resetToken: ${resetTokenValue != null ? 'Token available' : 'No token'} (provided: $token, memory: $resetToken, storage: ${StorageService.resetToken})',
    );

    if (setPasswordFormKey.currentState?.validate() ?? false) {
      if (resetTokenValue == null) {
        AppLoggerHelper.error('❌ No reset token available');
        return;
      }

      isSetPasswordLoading.value = true;
      try {
        final authService = Get.find<AuthenticationService>();
        final response = await authService.confirmPasswordReset(
          token: resetTokenValue,
          newPassword: newPasswordControllerThree.text,
          confirmPassword: confirmPasswordControllerTwo.text,
        );

        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          AppLoggerHelper.info('✅ Password reset successful!');
          AppLoggerHelper.info(
            '📥 Confirm Password Reset Response: ${response.body}',
          );

          final responseData = jsonDecode(response.body);
          final success = responseData['success'];
          final message = responseData['message'];

          if (success == true) {
            await StorageService.clearResetToken();
            resetToken = null;

            newPasswordControllerOne.clear();
            newPasswordControllerTwo.clear();
            newPasswordControllerThree.clear();
            confirmPasswordControllerOne.clear();
            confirmPasswordControllerTwo.clear();

            Get.offAllNamed(AppRoute.loginScreen);
            AppLoggerHelper.info('🔄 Password reset completed successfully');
          } else {
            AppLoggerHelper.error('❌ Password reset failed: $message');
          }
        } else {
          AppLoggerHelper.error(
            '❌ Password reset failed: ${response?.statusCode}',
          );
        }
      } catch (e) {
        AppLoggerHelper.error('❌ Set password error: $e', e);
      } finally {
        isSetPasswordLoading.value = false;
      }
    }
  }

  void changePassword() async {
    if (setPasswordFormKey.currentState?.validate() ?? false) {
      isSetPasswordLoading.value = true;
      try {
        final authService = Get.find<AuthenticationService>();
        final response = await authService.changePassword(
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordControllerThree.text,
        );

        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          AppLoggerHelper.info('✅ Password changed successfully!');
          AppLoggerHelper.info('📥 Change Password Response: ${response.body}');

          final responseData = jsonDecode(response.body);
          final success = responseData['success'];
          final message = responseData['message'];

          if (success == true) {
            currentPasswordController.clear();
            newPasswordControllerOne.clear();
            newPasswordControllerTwo.clear();
            newPasswordControllerThree.clear();
            confirmPasswordControllerOne.clear();
            confirmPasswordControllerTwo.clear();

            Get.snackbar(
              'Success',
              'Password changed successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );

            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAllNamed(AppRoute.mainAppScreen);
              final bottomNavController = Get.find<BottomNavController>();
              bottomNavController.changeTab(4);
            });

            AppLoggerHelper.info('🔄 Password changed successfully');
          } else {
            AppLoggerHelper.error('❌ Password change failed: $message');
          }
        } else {
          AppLoggerHelper.error(
            '❌ Password change failed: ${response?.statusCode}',
          );
        }
      } catch (e) {
        AppLoggerHelper.error('❌ Change password error: $e', e);
      } finally {
        isSetPasswordLoading.value = false;
      }
    }
  }

  // Validation methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validatePasswordMatch(String? value, String referencePassword) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != referencePassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void onClose() {
    AppLoggerHelper.info(
      'ℹ️ LoginController.onClose() - controllers not disposed',
    );
    super.onClose();
  }
}
