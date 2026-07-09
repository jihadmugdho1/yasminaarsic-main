// lib/features/home/screens/main_app_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:vendora/features/bottom_navbar/widget/bottom_navbar_widget.dart';

class MainAppScreen extends StatelessWidget {
  MainAppScreen({super.key}) {
    // Log the stored token when entering MainAppScreen
    final token = StorageService.token;
    final userId = StorageService.userId;
    AppLoggerHelper.info('🚀 Entered MainAppScreen');
    AppLoggerHelper.info('🔑 Stored Access Token: $token');
    AppLoggerHelper.info('🆔 Stored User ID: $userId');
  }

  final controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.screens[controller.currentIndex.value]),
      bottomNavigationBar: const BottomNavbarWidget(),
    );
  }
}
