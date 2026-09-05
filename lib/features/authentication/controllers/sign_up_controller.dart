import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/authentication/data/services/authentication_service.dart';
import 'package:vendora/features/authentication/data/services/terms_service.dart';
import 'package:vendora/features/authentication/presentation/widgets/verification_code_dialog.dart';
import 'package:vendora/features/bottom_navbar/screen/main_app_screen.dart';

class SignUpController extends GetxController {
  // Form key for validation
  final signUpFormKey = GlobalKey<FormState>();

  // Loading states
  final isSignUpLoading = false.obs;
  final isVerifyLoading = false.obs;

  // Terms and Conditions
  final isTermsAccepted = false.obs;
  final termsContent = ''.obs;
  final isTermsLoading = false.obs;
  final _termsService = TermsService();

  // Text Editing Controllers
  final nameController = TextEditingController();
  final phonecontroller = TextEditingController();
  final emailControllerTwo = TextEditingController();
  final passwordControllerTwo = TextEditingController();
  final confirmPasswordControllerOne = TextEditingController();

  // Password visibility
  var obscurePasswordTwo = true.obs;
  var obscureConfirmPasswordOne = true.obs;

  void togglePasswordTwoVisibility() =>
      obscurePasswordTwo.value = !obscurePasswordTwo.value;

  void toggleConfirmPasswordOneVisibility() =>
      obscureConfirmPasswordOne.value = !obscureConfirmPasswordOne.value;

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

  Future<void> fetchTermsAndCondition() async {
    isTermsLoading.value = true;
    try {
      final response = await _termsService.getActiveTerms();
      if (response.isSuccess && response.responseData != null) {
        final data = response.responseData as Map<String, dynamic>;
        termsContent.value =
            data['data']?['content'] as String? ??
            data['content'] as String? ??
            '';
        AppLoggerHelper.debug('Terms and conditions fetched successfully');
      } else {
        AppLoggerHelper.error(
          'Failed to fetch terms: ${response.errorMessage}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching terms', e);
    } finally {
      isTermsLoading.value = false;
    }
  }

  void signUp() async {
    if (!isTermsAccepted.value) {
      Get.snackbar(
        'Terms Required',
        'Please accept the Terms and Conditions to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate form before proceeding
    if (signUpFormKey.currentState?.validate() ?? false) {
      isSignUpLoading.value = true;
      try {
        final authService = Get.find<AuthenticationService>();

        final response = await authService.register(
          phone: phonecontroller.text,
          name: nameController.text,
          email: emailControllerTwo.text,
          password: passwordControllerTwo.text,
          role: 'USER',
        );

        if (response != null &&
            (response.statusCode == 201 || response.statusCode == 200)) {
          AppLoggerHelper.info('✅ Registration successful! OTP sent to email.');
          try {
            final responseData = jsonDecode(response.body);
            final data = responseData['data'];
            if (data != null) {
              final trialDays = data['trialDaysRemaining'];
              final hasSubscription = data['hasActiveSubscription'];
              await StorageService.saveTrialAndSubscription(
                trialDaysRemaining: trialDays is int
                    ? trialDays
                    : int.tryParse(trialDays.toString()) ?? 0,
                hasActiveSubscription: hasSubscription == true,
              );
              AppLoggerHelper.info(
                '💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from register.',
              );
            }
          } catch (e) {
            AppLoggerHelper.error(
              'Error saving trial/subscription from register: $e',
            );
          }
          _showVerificationDialog();
        } else if (response != null) {
          AppLoggerHelper.error(
            '❌ Registration failed with status: ${response.statusCode}',
          );
        } else {
          AppLoggerHelper.error('❌ Registration failed: No response received');
        }
      } catch (e) {
        AppLoggerHelper.error('❌ Sign up error: $e', e);
      } finally {
        isSignUpLoading.value = false;
      }
    }
  }

  void _showVerificationDialog() {
    Get.dialog(
      VerificationCodeDialog(
        title: 'Email Verification',
        description:
            'A verification code has been sent to ${emailControllerTwo.text}.',
        loading: isVerifyLoading,
        onSubmitPressed: verifyEmailCode,
        onChangeEmailPressed: () {
          Get.back(); // Close dialog
        },
        onClosePressed: () {
          Get.back(); // Close dialog
        },
      ),
      barrierDismissible: false,
    );
  }

  void verifyEmailCode(String code) async {
    isVerifyLoading.value = true;
    try {
      final authService = Get.find<AuthenticationService>();
      final response = await authService.verifyEmail(
        email: emailControllerTwo.text,
        code: code,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        AppLoggerHelper.info('✅ Email verification successful!');
        AppLoggerHelper.info('📥 Verify Email Response: ${response.body}');

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
              '💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from verify.',
            );
          }

          Get.back(); // Close dialog
          await _registerFcmToken();
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offAll(() => MainAppScreen());
          });
        } else {
          AppLoggerHelper.error('❌ Verification failed: success is not true');
        }
      } else {
        AppLoggerHelper.error(
          '❌ Email verification failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('❌ Verify email error: $e', e);
    } finally {
      isVerifyLoading.value = false;
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

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
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
      'ℹ️ SignUpController.onClose() - controllers not disposed',
    );
    super.onClose();
  }
}
