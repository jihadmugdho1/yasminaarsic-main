import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/features/alerts/data/alert_notification_model.dart';

class AlertsNotificationService {
  static Future<NotificationResponse> getNotifications({
    String? type,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url = ApiConstants.getNotifications(
        type: type,
        status: status,
        page: page,
        limit: limit,
      );

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final response = await NetworkCaller().getRequest(url, token: authToken);

      if (response.isSuccess && response.responseData != null) {
        return NotificationResponse.fromJson(response.responseData!);
      } else {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to fetch notifications',
        );
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  static Future<bool> markAsRead(String notificationId) async {
    try {
      final url = ApiConstants.markNotificationAsRead(notificationId);

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final response = await NetworkCaller().patchRequest(
        url,
        token: authToken,
      );

      return response.isSuccess;
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  static Future<bool> markAllAsRead() async {
    try {
      final url = ApiConstants.markAllNotificationsAsRead;

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final response = await NetworkCaller().patchRequest(
        url,
        token: authToken,
      );

      return response.isSuccess;
    } catch (e) {
      throw Exception('Error marking all notifications as read: $e');
    }
  }

  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final url = ApiConstants.deleteNotification(notificationId);

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final response = await NetworkCaller().deleteRequest(
        url,
        token: authToken,
      );

      return response.isSuccess;
    } catch (e) {
      throw Exception('Error deleting notification: $e');
    }
  }

  static Future<int> getUnreadCount() async {
    try {
      final url = ApiConstants.getUnreadNotificationCount;

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final response = await NetworkCaller().getRequest(url, token: authToken);

      if (response.isSuccess && response.responseData != null) {
        // Try different possible response structures
        int count = 0;

        // Case 1: Count directly in response
        if (response.responseData!['count'] != null) {
          count = response.responseData!['count'] as int;
        }
        // Case 2: Count under 'data' key
        else if (response.responseData!['data'] != null) {
          final data = response.responseData!['data'];
          if (data is Map && data['count'] != null) {
            count = data['count'] as int;
          } else if (data is int) {
            count = data;
          }
        }
        // Case 3: Count directly in response data
        else if (response.responseData!['data'] is int) {
          count = response.responseData!['data'] as int;
        }

        return count;
      } else {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to fetch unread count',
        );
      }
    } catch (e) {
      throw Exception('Error fetching unread count: $e');
    }
  }
}
