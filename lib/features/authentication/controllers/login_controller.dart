import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/authentication/data/services/authentication_service.dart';
import 'package:vendora/features/authentication/data/services/terms_service.dart';
import 'package:vendora/features/authentication/presentation/widgets/verification_code_dialog.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:vendora/features/bottom_navbar/screen/main_app_screen.dart';
import 'package:vendora/routes/app_routes.dart';

class LoginController extends GetxController {
  // ✅ Form keys for validation
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final setPasswordFormKey = GlobalKey<FormState>();

  // Loading states
  final isLoginLoading = false.obs;
  final isSignUpLoading = false.obs;
  final isSetPasswordLoading = false.obs;
  final isForgotPasswordLoading = false.obs;
  final isVerifyLoading = false.obs;
  final isLoading = false.obs;

  // Terms and Conditions
  final isTermsAccepted = false.obs;
  final termsContent = ''.obs;
  final isTermsLoading = false.obs;
  final _termsService = TermsService();

  final nameController = TextEditingController();
  final phonecontroller = TextEditingController();
  final emailControllerOne = TextEditingController();
  final emailControllerTwo = TextEditingController();
  final passwordControllerOne = TextEditingController();
  final passwordControllerTwo = TextEditingController();
  final newPasswordControllerOne = TextEditingController();
  final newPasswordControllerTwo = TextEditingController();
  final newPasswordControllerThree = TextEditingController();
  final confirmPasswordControllerOne = TextEditingController();
  final confirmPasswordControllerTwo = TextEditingController();
  final currentPasswordController = TextEditingController();
  String? resetToken;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '760103787556-in8ppsm1lpnq2b56ogvigv7nspfljjo4.apps.googleusercontent.com',
  );

  var obscurePasswordOne = true.obs;
  var obscurePasswordTwo = true.obs;
  var obscureNewPasswordOne = true.obs;
  var obscureNewPasswordTwo = true.obs;
  var obscureNewPasswordThree = true.obs;
  var obscureConfirmPasswordOne = true.obs;
  var obscureConfirmPasswordTwo = true.obs;
  var obscureCurrentPassword = true.obs;

  void togglePasswordTwoVisibility() =>
      obscurePasswordTwo.value = !obscurePasswordTwo.value;

  void togglePasswordOneVisibility() =>
      obscurePasswordOne.value = !obscurePasswordOne.value;

  void toggleNewPasswordOneVisibility() =>
      obscureNewPasswordOne.value = !obscureNewPasswordOne.value;

  void toggleNewPasswordTwoVisibility() =>
      obscureNewPasswordTwo.value = !obscureNewPasswordTwo.value;

  void toggleNewPasswordThreeVisibility() =>
      obscureNewPasswordThree.value = !obscureNewPasswordThree.value;

  void toggleConfirmPasswordOneVisibility() =>
      obscureConfirmPasswordOne.value = !obscureConfirmPasswordOne.value;

  void toggleConfirmPasswordTwoVisibility() =>
      obscureConfirmPasswordTwo.value = !obscureConfirmPasswordTwo.value;

  void toggleCurrentPasswordVisibility() =>
      obscureCurrentPassword.value = !obscureCurrentPassword.value;

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
        // Get the authentication service
        final authService = Get.find<AuthenticationService>();

        // Call the login API
        final response = await authService.login(
          email: emailControllerOne.text,
          password: passwordControllerOne.text,
        );

        // Check if login was successful
        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          AppLoggerHelper.info('✅ Login successful!');
          AppLoggerHelper.info('📥 Login Response: ${response.body}');

          // Parse the response to extract data
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
            // Save token and user ID to shared preferences
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
              AppLoggerHelper.info('💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from login.');
            }

            // Register FCM token
            await _registerFcmToken();

            // Navigate to main app screen
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
        // Get the authentication service
        final authService = Get.find<AuthenticationService>();

        // Call the register API
        final response = await authService.register(
          phone: phonecontroller.text,

          name: nameController.text,
          email: emailControllerTwo.text,
          password: passwordControllerTwo.text,
          role: 'USER',
        );

        // Check if registration was successful
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
              AppLoggerHelper.info('💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from register.');
            }
          } catch (e) {
            AppLoggerHelper.error('Error saving trial/subscription from register: $e');
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
          // Optionally, allow changing email, but for now just close
        },
        onClosePressed: () {
          Get.back(); // Close dialog
        },
      ),
      barrierDismissible: false,
    );
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
            AppLoggerHelper.info('💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from login verify.');
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

        // Parse the response to extract data
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
          // Save token and user ID to shared preferences
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
            AppLoggerHelper.info('💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from verify.');
          }

          Get.back(); // Close dialog
          // Register FCM token
          await _registerFcmToken();
          // Navigate to main app screen
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

  void verifyResetCode(String code) async {
    try {
      final authService = Get.find<AuthenticationService>();
      final response = await authService.verifyResetCode(
        email: emailControllerOne
            .text, // Assuming reset password uses emailControllerOne
        code: code,
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        AppLoggerHelper.info('✅ Reset code verification successful!');
        AppLoggerHelper.info('📥 Verify Reset Code Response: ${response.body}');

        // Parse the response to extract data
        final responseData = jsonDecode(response.body);

        final success = responseData['success'];
        final message = responseData['message'];
        final data = responseData['data'];

        AppLoggerHelper.info('📄 Message: $message');

        if (success == true) {
          // Store the reset token in persistent storage and controller memory
          final token = data is Map
              ? (data['resetToken'] ?? data['token'])
              : null;

          if (token != null) {
            resetToken = token; // Store in memory
            await StorageService.saveResetToken(token);
            AppLoggerHelper.info('🔑 Reset token stored: $token');
          } else {
            AppLoggerHelper.error('❌ No reset token found in response data');
          }

          Get.back(); // Close dialog
          // Navigate to set password screen
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
    // Priority: provided token > memory token > storage token
    final resetTokenValue = token ?? resetToken ?? StorageService.resetToken;
    AppLoggerHelper.info(
      '🔑 SetPassword called - resetToken: ${resetTokenValue != null ? 'Token available' : 'No token'} (provided: $token, memory: $resetToken, storage: ${StorageService.resetToken})',
    );

    // Validate form before proceeding
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

          // Parse the response
          final responseData = jsonDecode(response.body);
          final success = responseData['success'];
          final message = responseData['message'];

          if (success == true) {
            // Clear the reset token from storage and memory
            await StorageService.clearResetToken();
            resetToken = null;

            // Clear all password controllers
            newPasswordControllerOne.clear();
            newPasswordControllerTwo.clear();
            newPasswordControllerThree.clear();
            confirmPasswordControllerOne.clear();
            confirmPasswordControllerTwo.clear();

            // Navigate to login screen
            Get.offAllNamed(AppRoute.loginScreen);

            // Show success message
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
    // Validate form before proceeding
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

          // Parse the response
          final responseData = jsonDecode(response.body);
          final success = responseData['success'];
          final message = responseData['message'];

          if (success == true) {
            // Clear all password controllers
            currentPasswordController.clear();
            newPasswordControllerOne.clear();
            newPasswordControllerTwo.clear();
            newPasswordControllerThree.clear();
            confirmPasswordControllerOne.clear();
            confirmPasswordControllerTwo.clear();

            // Show success snackbar
            Get.snackbar(
              'Success',
              'Password changed successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );

            // Navigate to profile screen after a short delay to allow snackbar to show
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.offAllNamed(AppRoute.mainAppScreen);
              // Ensure profile tab is selected (index 4)
              final bottomNavController = Get.find<BottomNavController>();
              bottomNavController.changeTab(4);
            });

            // Show success message
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

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      AppLoggerHelper.error('Google sign-out error: $e');
    }
  }

  Future<void> signUpWithGoogle() async {
    try {
      EasyLoading.show(status: 'Signing in...');
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        EasyLoading.dismiss();
        return; // user cancelled
      }

      AppLoggerHelper.debug('Google account selected: $googleUser');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      AppLoggerHelper.debug(
        'Google authentication tokens: ${jsonEncode({'idToken': googleAuth.idToken, 'accessToken': googleAuth.accessToken, 'serverAuthCode': googleUser.serverAuthCode})}',
      );

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      // Sign into Firebase with the Google credential to get a Firebase ID token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AppLoggerHelper.debug(
        'Firebase auth credential: ${jsonEncode(credential.asMap())}',
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      AppLoggerHelper.debug(
        'Firebase userCredential response: $userCredential',
      );

      final String? idToken = await userCredential.user?.getIdToken();

      AppLoggerHelper.debug('Firebase ID token: $idToken');

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }
      StorageService.saveName(googleUser.displayName ?? '');
      final String? fcmToken =
          StorageService.fcmToken ??
          await FirebaseMessaging.instance.getToken();

      AppLoggerHelper.debug("profile image :${googleUser.photoUrl}");
      final authService = Get.find<AuthenticationService>();

      final requestBody = {
        'idToken': idToken,
        'fcmToken': fcmToken ?? '',
        'email': googleUser.email,
        'name': googleUser.displayName ?? '',
        'imageUrl': googleUser.photoUrl ?? '',
      };

      AppLoggerHelper.debug(
        'Google login request payload: ${jsonEncode(requestBody)}',
      );

      final response = await authService.googleLogin(requestBody);

      AppLoggerHelper.debug(
        'Google login API response: ${jsonEncode(response)}',
      );

      if (response == null || response['success'] != true) {
        throw Exception(
          'Google login failed: ${response?['message'] ?? 'Unknown error'}',
        );
      }

      final responseData = response['data'];

      AppLoggerHelper.debug(
        'Google login response data: ${jsonEncode(responseData)}',
      );

      if (responseData == null || responseData['accessToken'] == null) {
        throw Exception('Google login failed: No access token from server');
      }

      await StorageService.saveToken(
        responseData['accessToken'] as String,
        responseData['user']?['id']?.toString() ?? '',
      );

      final trialDays = responseData['trialDaysRemaining'];
      final hasSubscription = responseData['hasActiveSubscription'];
      if (trialDays != null || hasSubscription != null) {
        await StorageService.saveTrialAndSubscription(
          trialDaysRemaining: trialDays is int
              ? trialDays
              : int.tryParse(trialDays.toString()) ?? 0,
          hasActiveSubscription: hasSubscription == true,
        );
        AppLoggerHelper.info('💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from Google login.');
      }

      if (googleUser.photoUrl != null) {
        await StorageService.saveImageUrl(googleUser.photoUrl!);
      }

      if (fcmToken != null) {
        final fcmResponse = await authService.registerFcmToken(
          token: fcmToken,
          platform: Platform.isIOS ? 'ios' : 'android',
          deviceId: 'device_id',
        );

        AppLoggerHelper.debug(
          'Register FCM token response: status=${fcmResponse?.statusCode}, body=${fcmResponse?.body}',
        );
      }

      Get.offAllNamed(AppRoute.mainAppScreen);
    } on PlatformException catch (e) {
      AppLoggerHelper.error('Google Sign-In Platform Exception: $e');
      if (e.code == 'channel-error') {
        EasyLoading.showError(
          'Google Sign-In not configured. Please check your Firebase setup.',
        );
      } else {
        EasyLoading.showError('Google Sign-In failed. Please try again.');
      }
    } catch (e) {
      AppLoggerHelper.error('Google sign-in error: $e');
      EasyLoading.showError('Google sign-in failed. Try again.');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  // ✅ Validation methods
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
    // Intentionally keep TextEditingController instances alive to avoid
    // use-after-dispose errors when widgets are still mounted.
    AppLoggerHelper.info(
      'ℹ️ LoginController.onClose() - controllers not disposed',
    );
    super.onClose();
  }
}
