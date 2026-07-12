import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/constants/api_constants.dart';
import 'package:vendora/core/utils/logging/logger.dart';

class AuthenticationService extends GetxService {
  // Get headers with Bearer token for authenticated requests
  Map<String, String> _getHeaders({bool needsAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth) {
      final token = StorageService.token;
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        AppLoggerHelper.info('🔐 Authorization header added with Bearer token');
      }
    }

    return headers;
  }

  Future<http.Response?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? role,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.register);

      // Log the API URL
      AppLoggerHelper.info('📤 Register API Called: ${url.toString()}');

      final body = {
        'name': name,
        'email': email,
        "mobileNumber":phone,
        'password': password,
        'role': role,
      };

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      // Log the response details
      AppLoggerHelper.info(
        '✅ Register Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info('📥 Register Response Body: ${response.body}');
      AppLoggerHelper.info('📄 Register Response Headers: ${response.headers}');

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Register Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.verifyEmail);

      AppLoggerHelper.info('📤 Verify Email API Called: ${url.toString()}');

      final body = {'email': email, 'code': code};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Verify Email Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info('📥 Verify Email Response Body: ${response.body}');

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Verify Email Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.login);

      AppLoggerHelper.info('📤 Login API Called: ${url.toString()}');

      final body = {'email': email, 'password': password};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info('✅ Login Response Status: ${response.statusCode}');
      AppLoggerHelper.info('📥 Login Response Body: ${response.body}');

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Login Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> googleLogin(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}auth/login/google');

      AppLoggerHelper.info('📤 Google Login API Called: ${url.toString()}');

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(data)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(data))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              throw Exception('Request timeout');
            },
          );

      AppLoggerHelper.info(
        '✅ Google Login Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info('📥 Google Login Response Body: ${response.body}');

      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Google Login Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> resetPassword({required String email}) async {
    try {
      final url = Uri.parse(ApiConstants.passwordResetSendCode);

      AppLoggerHelper.info('📤 Reset Password API Called: ${url.toString()}');

      final body = {'email': email};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Reset Password Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info('📥 Reset Password Response Body: ${response.body}');

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Reset Password Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.passwordResetVerifyCode);

      AppLoggerHelper.info(
        '📤 Verify Reset Code API Called: ${url.toString()}',
      );

      final body = {'email': email, 'code': code};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Verify Reset Code Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info(
        '📥 Verify Reset Code Response Body: ${response.body}',
      );

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Verify Reset Code Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> confirmPasswordReset({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.confirmPasswordReset);

      AppLoggerHelper.info(
        '📤 Confirm Password Reset API Called: ${url.toString()}',
      );

      final body = {'token': token, 'newPassword': newPassword};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(url, headers: _getHeaders(), body: jsonEncode(body))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Confirm Password Reset Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info(
        '📥 Confirm Password Reset Response Body: ${response.body}',
      );

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error(
        '❌ Confirm Password Reset Error: $e',
        e,
        stackTrace,
      );
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.changePassword);

      AppLoggerHelper.info('📤 Change Password API Called: ${url.toString()}');

      final body = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
            url,
            headers: _getHeaders(needsAuth: true),
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Change Password Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info(
        '📥 Change Password Response Body: ${response.body}',
      );

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Change Password Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }

  Future<http.Response?> registerFcmToken({
    required String token,
    required String platform,
    required String deviceId,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.registerFcmToken);

      AppLoggerHelper.info(
        '📤 Register FCM Token API Called: ${url.toString()}',
      );

      final body = {'token': token, 'platform': platform, 'deviceId': deviceId};

      AppLoggerHelper.info('📝 Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
            url,
            headers: _getHeaders(needsAuth: true),
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              AppLoggerHelper.error('⏱️ Request timeout after 30 seconds');
              return http.Response('Request timeout', 408);
            },
          );

      AppLoggerHelper.info(
        '✅ Register FCM Token Response Status: ${response.statusCode}',
      );
      AppLoggerHelper.info(
        '📥 Register FCM Token Response Body: ${response.body}',
      );

      return response;
    } catch (e, stackTrace) {
      AppLoggerHelper.error('❌ Register FCM Token Error: $e', e, stackTrace);
      AppLoggerHelper.warning(
        '⚠️ Make sure the backend server is running at ${ApiConstants.baseUrl}',
      );
      rethrow;
    }
  }
}
