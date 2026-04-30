import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/editProfile/data/notification_preference_model.dart';

class NotificationPreferenceService {
  static const String _contentType = 'application/json; charset=utf-8';

  Future<ResponseData> getNotificationPreferences() async {
    final token = StorageService.token;
    if (token == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'No authentication token available',
        responseData: null,
      );
    }

    try {
      final uri = Uri.parse(ApiConstants.notificationPreference);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': token,
          'Content-Type': _contentType,
        },
      );

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          if (body is Map<String, dynamic> && body['success'] == true) {
            final data = body['data'] as Map<String, dynamic>?;
            if (data != null) {
              final preferences = NotificationPreferenceModel.fromJson(data);
              return ResponseData(
                isSuccess: true,
                statusCode: 200,
                responseData: preferences,
                errorMessage: '',
              );
            } else {
              return ResponseData(
                isSuccess: false,
                statusCode: 200,
                errorMessage: 'Missing data in response',
                responseData: null,
              );
            }
          } else {
            final message = body['message'] ?? 'Unknown error';
            return ResponseData(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: message,
              responseData: null,
            );
          }
        } catch (e) {
          AppLoggerHelper.error('JSON parsing error in getNotificationPreferences', e);
          return ResponseData(
            isSuccess: false,
            statusCode: 500,
            errorMessage: 'Failed to parse notification preferences',
            responseData: null,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthorized access – please log in again',
          responseData: null,
        );
      } else {
        final message = _extractErrorMessage(response.body);
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: message,
          responseData: null,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Network error in getNotificationPreferences', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Network request failed',
        responseData: null,
      );
    }
  }

  Future<ResponseData> updateNotificationPreferences(
      NotificationPreferenceModel preferences) async {
    final token = StorageService.token;
    if (token == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 401,
        errorMessage: 'No authentication token available',
        responseData: null,
      );
    }

    try {
      final uri = Uri.parse(ApiConstants.notificationPreference);
      final response = await http.patch(
        uri,
        headers: {
          'Authorization': token,
          'Content-Type': _contentType,
        },
        body: jsonEncode(preferences.toJson()),
      );

      if (response.statusCode == 200) {
        try {
          final body = jsonDecode(response.body);
          if (body is Map<String, dynamic> && body['success'] == true) {
            return ResponseData(
              isSuccess: true,
              statusCode: 200,
              responseData: body,
              errorMessage: '',
            );
          } else {
            final message = body['message'] ?? 'Update failed';
            return ResponseData(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: message,
              responseData: null,
            );
          }
        } catch (e) {
          AppLoggerHelper.error('JSON parsing error in updateNotificationPreferences', e);
          return ResponseData(
            isSuccess: false,
            statusCode: 500,
            errorMessage: 'Invalid response format',
            responseData: null,
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Session expired or access denied',
          responseData: null,
        );
      } else {
        final message = _extractErrorMessage(response.body);
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: message,
          responseData: null,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Network error in updateNotificationPreferences', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Failed to update notification preferences',
        responseData: null,
      );
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final body = jsonDecode(responseBody);
      if (body is Map<String, dynamic>) {
        return body['message'] ?? 'An error occurred';
      }
    } catch (_) {
      // Ignore JSON parse errors
    }
    return 'Request failed';
  }
}