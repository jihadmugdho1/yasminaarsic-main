import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/features/bottom_navbar/screen/main_app_screen.dart';
import 'package:vendora/features/onboarding/screen/onborading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static String name = "/";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initServices();
    _moveToNextScreen();
  }

  Future<void> _initServices() async {
    await StorageService.init();
  }

  // ++++++++++++++++++++++++++++++
  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    // Check if user is already logged in
    if (StorageService.hasToken()) {
      final token = StorageService.token;
      final userId = StorageService.userId;
      AppLoggerHelper.info('🔍 Token found in storage during splash');
      AppLoggerHelper.info('🔑 Stored Access Token: $token');
      AppLoggerHelper.info('🆔 Stored User ID: $userId');
      Get.offAll(() => MainAppScreen());
    } else {
      AppLoggerHelper.info('❌ No token found in storage');
      Get.offAll(() => const OnboradingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(child: Image.asset(ImagePath.appLogo)),
    );
  }
}
