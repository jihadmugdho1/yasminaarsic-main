// lib/features/alerts/presentation/screens/alerts_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/alerts/controller/alerts_controller.dart';
import 'package:yasminaarsic/features/alerts/presentation/widgets/notification_header_card.dart';
import 'package:yasminaarsic/features/alerts/presentation/widgets/offer_notification_card.dart';
import 'package:yasminaarsic/features/alerts/presentation/widgets/notification_card_shimmer.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlertsController());
    final locale = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Obx(() {
              return NotificationHeaderCard(
                title: locale.get('notifications'),
                subtitle:
                    '${locale.get('unread_notification').replaceFirst('1', controller.unreadCount.toString())}${controller.unreadCount == 1 ? '' : 's'}',
                actionButtonText: locale.get('mark_all_read'),
                backgroundColor: const Color(0xFF6C63FE),
                titleColor: Colors.white,
                subtitleColor: Colors.white,
                actionButtonColor: const Color(0xFFFFD700),
                actionTextColor: const Color(0xFF0A0A0A),
                onActionPressed: controller.onMarkAllAsRead,
                onTap: controller.onHeaderTap,
              );
            }),

            // Content
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value &&
                    controller.notifications.isEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 8, // Show 8 shimmer cards
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        child: const NotificationCardShimmer(),
                      );
                    },
                  );
                }

                // Error state
                if (controller.hasError.value &&
                    controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load notifications',
                          style: TextStyle(fontSize: 16.sp, color: Colors.red),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: controller.refreshNotifications,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (controller.notifications.isEmpty) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(IconPath.notificationIcon,height: 20.h,),
                      SizedBox(width: 5.w,),
                      Text(
                        'No notifications yet',
                        style: TextStyle(fontSize: 16.sp, color: AppColors.textPrimary),
                      ),
                    ],
                  );
                }

                // Notifications list
                return RefreshIndicator(
                  onRefresh: controller.refreshNotifications,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        controller.notifications.length +
                        (controller.hasNextPage.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Load more indicator
                      if (index == controller.notifications.length) {
                        if (controller.isLoadingMore.value) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          // Trigger load more when reaching the end
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.loadMoreNotifications();
                          });
                          return const SizedBox.shrink();
                        }
                      }

                      final item = controller.notifications[index];
                      final legacyItem = controller.convertToLegacyModel(item);

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        child: OfferNotificationCard(
                          title: item.title,
                          description: item.body,
                          dateTime: item.createdAt,
                          badgeText: item.isUnread ? 'New' : null,
                          badgeColor: legacyItem.badgeColor,
                          svgIconPath: legacyItem.svgIconPath,
                          iconBackgroundColor: legacyItem.iconBackgroundColor,
                          iconForegroundColor: legacyItem.iconForegroundColor,
                          backgroundColor: legacyItem.backgroundColor,
                          isSelected:
                              controller.selectedNotificationIndex.value ==
                              index,
                          onTap: () => controller.onNotificationTap(index),
                          onDelete: () => controller.deleteNotification(index),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
