import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:vendora/core/core.dart';
import 'package:vendora/features/subscription/data/subscription_history_model.dart';
import 'package:vendora/features/subscription/data/subscription_plan_model.dart';
import 'package:vendora/features/subscription/data/checkout_response_model.dart';

class SubscriptionService {
  final NetworkCaller _networkCaller = NetworkCaller();

  // Fetch all subscription plans from API
  Future<ResponseData> getSubscriptionPlans() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.subscriptionPlans,
      );

      if (response.isSuccess && response.responseData != null) {
        List<SubscriptionPlanModel> plans = [];

        final data = response.responseData as Map<String, dynamic>;

        // Navigate to data.data array which contains the plans
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          final innerData = data['data'] as Map<String, dynamic>;

          if (innerData['data'] is List) {
            plans = (innerData['data'] as List)
                .map(
                  (plan) => SubscriptionPlanModel.fromJson(
                    plan is Map<String, dynamic> ? plan : {},
                  ),
                )
                .toList();
          }
        }

        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          errorMessage: '',
          responseData: plans,
        );
      }
     

      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
        responseData: null,
      );
    }
  }

  // Fetch current user subscription
  Future<ResponseData> getCurrentSubscription() async {
    try {
      final token = StorageService.token;
      final response = await _networkCaller.getRequest(
        ApiConstants.currentSubscription,
        token: token != null ? 'Bearer $token' : null,
      );

      if (response.isSuccess && response.responseData != null) {
        final root = response.responseData as Map<String, dynamic>;
        final data = root['data'];
        if (data is Map<String, dynamic>) {
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: '',
            responseData: SubscriptionHistoryModel.fromJson(data),
          );
        }
      }

      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
        responseData: null,
      );
    }
  }

  // Fetch subscription history
  Future<ResponseData> getSubscriptionHistory({int page = 1, int limit = 10}) async {
    try {
      final token = StorageService.token;
      final response = await _networkCaller.getRequest(
        ApiConstants.getSubscriptionHistory(page: page, limit: limit),
        token: token != null ? 'Bearer $token' : null,
      );

      if (response.isSuccess && response.responseData != null) {
        final root = response.responseData as Map<String, dynamic>;
        // Response shape: { data: { data: [...], meta: {...} } }
        final outerData = root['data'];
        final List<SubscriptionHistoryModel> items = [];

        if (outerData is Map<String, dynamic>) {
          final list = outerData['data'];
          if (list is List) {
            for (final item in list) {
              if (item is Map<String, dynamic>) {
                items.add(SubscriptionHistoryModel.fromJson(item));
              }
            }
          }
        } else if (outerData is List) {
          for (final item in outerData) {
            if (item is Map<String, dynamic>) {
              items.add(SubscriptionHistoryModel.fromJson(item));
            }
          }
        }

        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          errorMessage: '',
          responseData: items,
        );
      }

      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
        responseData: null,
      );
    }
  }

  // Checkout - Subscribe to a plan
  Future<ResponseData> checkout({
    required String subscriptionPlanId,
    required String idempotencyKey,
    String? promoCode,
  }) async {
    try {
      final body = {
        "subscriptionPlanId": subscriptionPlanId,
        "idempotencyKey": idempotencyKey,
        if (promoCode != null && promoCode.isNotEmpty) "promoCode": promoCode,
      };

      final token = StorageService.token;
      final response = await _networkCaller.postRequest(
        ApiConstants.subscriptionCheckout,
        body: body,
        token: token != null ? 'Bearer $token' : null,
      );

      AppLoggerHelper.debug("checkout body : $body");

      AppLoggerHelper.debug("acces token: $token");
      AppLoggerHelper.debug("checkout response: ${response.responseData}");

      if (response.isSuccess && response.responseData != null) {
        try {
          final checkoutResponse = CheckoutResponse.fromJson(
            response.responseData as Map<String, dynamic>,
          );
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            errorMessage: '',
            responseData: checkoutResponse,
          );
        } catch (e) {
          return ResponseData(
            isSuccess: false,
            statusCode: 500,
            errorMessage: 'Failed to parse checkout response: $e',
            responseData: null,
          );
        }
      }

      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
        responseData: null,
      );
    }
  }

  // Get payment form HTML — response is raw HTML, not JSON, so we bypass NetworkCaller
  Future<ResponseData> getPaymentFormHtml(String paymentId) async {
    try {
      final token = StorageService.token;
      final uri = Uri.parse(ApiConstants.getCheckoutPaymentForm(paymentId));
      AppLoggerHelper.debug(
        'getPaymentFormHtml -> GET $uri (token: ${token != null ? "yes" : "no"})',
      );
      final response = await http.get(uri, headers: {
        'accept': '*/*',
        if (token != null) 'Authorization': 'Bearer $token',
      }).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final body = response.body;
        final preview = body.length > 800 ? body.substring(0, 800) : body;
        AppLoggerHelper.debug(
          'getPaymentFormHtml <- ${response.statusCode} (len: ${body.length}) preview: $preview',
        );
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          errorMessage: '',
          responseData: body,
        );
      }

      final errorBodyPreview =
          response.body.length > 800 ? response.body.substring(0, 800) : response.body;
      AppLoggerHelper.debug(
        'getPaymentFormHtml <- ${response.statusCode} errorBody: $errorBodyPreview',
      );

      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to load payment form (${response.statusCode})',
        responseData: null,
      );
    } on TimeoutException {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage: 'Request timeout',
        responseData: null,
      );
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: e.toString(),
        responseData: null,
      );
    }
  }
}
