import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/authentication/data/services/authentication_service.dart';
import 'package:vendora/routes/app_routes.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '760103787556-in8ppsm1lpnq2b56ogvigv7nspfljjo4.apps.googleusercontent.com',
  );

  final isLoading = false.obs;

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    } catch (e) {
      AppLoggerHelper.error('Google sign-out error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
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
        AppLoggerHelper.info(
          '💾 Saved trialDaysRemaining: $trialDays, hasActiveSubscription: $hasSubscription to storage from Google login.',
        );
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

  // Backwards compatibility alias
  Future<void> signUpWithGoogle() => signInWithGoogle();
}
