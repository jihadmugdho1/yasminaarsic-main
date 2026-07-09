// lib/features/alerts/controller/alerts_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/alerts/data/alert_notification_model.dart';
import 'package:vendora/features/alerts/data/notification_service.dart';

class AlertsController extends GetxController {
  // API-based notification data
  var notifications = <NotificationItem>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // Pagination
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var hasNextPage = true.obs;

  // Filters
  var selectedType = ''.obs;
  var selectedStatus = ''.obs;

  // Selection
  var selectedNotificationIndex = (-1).obs; // -1 means none selected

  // Unread count from API
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchUnreadCount() async {
    try {
      final count = await AlertsNotificationService.getUnreadCount();
      unreadCount.value = count;
    } catch (e) {
      print('Error fetching unread count: $e');
      // Keep the current count on error
    }
  }

  Future<void> fetchNotifications({
    bool isLoadMore = false,
    bool refresh = false,
  }) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        hasNextPage.value = true;
        notifications.clear();
      }

      if (isLoadMore) {
        if (!hasNextPage.value) return;
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
      }

      hasError.value = false;
      errorMessage.value = '';

      final response = await AlertsNotificationService.getNotifications(
        type: selectedType.value.isEmpty ? null : selectedType.value,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        page: isLoadMore ? currentPage.value + 1 : 1,
        limit: 20,
      );

      if (isLoadMore) {
        notifications.addAll(response.data.notifications);
        currentPage.value++;
      } else {
        notifications.value = response.data.notifications;
        currentPage.value = 1;
      }

      totalPages.value = response.data.meta.totalPages;
      hasNextPage.value = currentPage.value < totalPages.value;

      // Refresh unread count after fetching notifications
      await fetchUnreadCount();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications(refresh: true);
  }

  Future<void> loadMoreNotifications() async {
    await fetchNotifications(isLoadMore: true);
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final success = await AlertsNotificationService.markAsRead(
        notificationId,
      );
      if (success) {
        // Update local state
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final updatedNotification = NotificationItem(
            id: notifications[index].id,
            userId: notifications[index].userId,
            title: notifications[index].title,
            body: notifications[index].body,
            data: notifications[index].data,
            type: notifications[index].type,
            status: 'READ',
            sentAt: notifications[index].sentAt,
            readAt: DateTime.now(),
            createdAt: notifications[index].createdAt,
            updatedAt: DateTime.now(),
          );
          notifications[index] = updatedNotification;
        }
        // Refresh unread count after marking as read
        await fetchUnreadCount();
      }
      return success;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  void filterByType(String type) {
    selectedType.value = type;
    fetchNotifications(refresh: true);
  }

  void filterByStatus(String status) {
    selectedStatus.value = status;
    fetchNotifications(refresh: true);
  }

  void clearFilters() {
    selectedType.value = '';
    selectedStatus.value = '';
    fetchNotifications(refresh: true);
  }

  void onNotificationTap(int index) {
    // Toggle or set selection — here we just select one at a time
    selectedNotificationIndex.value = selectedNotificationIndex.value == index
        ? -1
        : index;

    // Mark as read if it's unread
    if (index >= 0 &&
        index < notifications.length &&
        notifications[index].isUnread) {
      markNotificationAsRead(notifications[index].id);
    }
  }

  void deleteNotification(int index) async {
    // Validate index
    if (index < 0 || index >= notifications.length) {
      return;
    }

    final notificationId = notifications[index].id;
    try {
      final success = await AlertsNotificationService.deleteNotification(
        notificationId,
      );
      if (success) {
        notifications.removeAt(index);

        // Reset selected index if it was the deleted notification
        if (selectedNotificationIndex.value == index) {
          selectedNotificationIndex.value = -1;
        }

        // Show success snackbar
        Get.snackbar(
          'Success',
          'Notification deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Show error snackbar
        Get.snackbar(
          'Error',
          'Failed to delete notification',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      AppLoggerHelper.debug('Error deleting notification: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to delete notification',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void onHeaderTap() {
    // Placeholder
  }

  // Legacy methods for backward compatibility (keeping old AlertNotificationModel methods)
  void onMarkAllAsRead() async {
    try {
      final success = await AlertsNotificationService.markAllAsRead();
      if (success) {
        // Mark all notifications as read by refreshing from server
        unreadCount.value = 0;
        refreshNotifications();
      }
    } catch (e) {
      AppLoggerHelper.debug('Error marking all as read: $e');
    }
  }

  // Helper method to convert API notification to legacy model for UI compatibility
  AlertNotificationModel convertToLegacyModel(NotificationItem item) {
    return AlertNotificationModel(
      title: item.title,
      description: item.body,
      dateTime: item.createdAt,
      badgeText: item.isUnread ? 'New' : '',
      badgeColor: item.isUnread ? const Color(0xFFFFD700) : Colors.transparent,
      svgIconPath: _getIconForType(item.type),
      iconBackgroundColor: _getBackgroundColorForType(item.type),
      iconForegroundColor: _getForegroundColorForType(item.type),
      backgroundColor: const Color(0xFFEFF6FF),
      isNew: item.isUnread,
    );
  }

  String _getIconForType(String type) {
    switch (type) {
      case 'NEW_OFFER':
        return 'assets/icons/gift_icon.svg';
      case 'PROMOTION':
        return 'assets/icons/promotion_icon.svg';
      default:
        return 'assets/icons/notification_icon.svg';
    }
  }

  Color _getBackgroundColorForType(String type) {
    switch (type) {
      case 'NEW_OFFER':
        return const Color(0xFFDCFCE7);
      case 'PROMOTION':
        return const Color(0xFFF3E8FF);
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  Color _getForegroundColorForType(String type) {
    switch (type) {
      case 'NEW_OFFER':
        return const Color(0xFF00A63E);
      case 'PROMOTION':
        return const Color(0xFF9810FA);
      default:
        return const Color(0xFF155DFC);
    }
  }
}
