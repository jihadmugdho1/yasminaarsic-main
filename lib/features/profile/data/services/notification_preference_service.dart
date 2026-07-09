import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vendora/core/models/response_data.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/constants/api_constants.dart';
import 'package:vendora/core/utils/logging/logger.dart';

class NotificationPreferenceService {
  static const String _contentType = 'application/json; charset=utf-8';

  Future<ResponseData> getNotificationPreferences() async {
    final token = StorageService.token;
    if (token == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'No token available',
        responseData: null,
      );
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.notificationPreference),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': _contentType},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        AppLoggerHelper.debug("Get Notification Preferences  status: ${response.body}");
        if (body['success'] == true) {
          return ResponseData(
            isSuccess: true,
            statusCode: 200,
            responseData: body['data'],
            errorMessage: '',
          );
         
        }
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: body['message'] ?? 'Unknown error',
          responseData: null,
        );
      }

      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to load preferences',
        responseData: null,
      );
    } catch (e) {
      AppLoggerHelper.error('Get Notification Preferences Error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error',
        responseData: null,
      );
    }
  }

  Future<ResponseData> updateNotificationPreferences(Map<String, dynamic> data) async {
    final token = StorageService.token;
    if (token == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'No token available',
        responseData: null,
      );
    }

    try {
      AppLoggerHelper.debug('[NotificationPref] PATCH request payload: ${jsonEncode(data)}');

      final response = await http.patch(
        Uri.parse(ApiConstants.notificationPreference),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': _contentType},
        body: jsonEncode(data),
      );

      AppLoggerHelper.debug('[NotificationPref] PATCH response status: ${response.statusCode}');
      AppLoggerHelper.debug('[NotificationPref] PATCH response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final isSuccess = body['success'] == true;
        AppLoggerHelper.debug('[NotificationPref] PATCH success=$isSuccess data: ${body['data']}');
        return ResponseData(
          isSuccess: isSuccess,
          statusCode: 200,
          responseData: body['data'],
          errorMessage: isSuccess ? '' : body['message'] ?? 'Update failed',
        );
      }

      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Update failed',
        responseData: null,
      );
    } catch (e) {
      AppLoggerHelper.error('Update Notification Preferences Error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network error',
        responseData: null,
      );
    }
  }
}
