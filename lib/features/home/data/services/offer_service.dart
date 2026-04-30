import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/models/offer_api_model.dart';

class OfferService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetch newest offers from API
  Future<ResponseData> getNewestOffers({
    required String categoryId,
    required int limit,
    int page = 1,
  }) async {
    try {
      final url = ApiConstants.getNewestOffers(
        categoryId: categoryId,
        limit: limit,
        page: page,
      );

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Fetching newest offers from: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(url, token: authToken);

      AppLoggerHelper.debug(
        'Newest Offers API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final offersData = response.responseData['data'] as List<dynamic>;
          final offers = offersData
              .map(
                (json) => OfferApiModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
          AppLoggerHelper.debug(
            'Newest offers loaded successfully: ${offers.length}',
          );
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: offers,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing newest offers data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing offers data: ${parseError.toString()}',
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: null,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Exception while fetching newest offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Exception: ${e.toString()}',
      );
    }
  }

  /// Fetch trending offers from API
  Future<ResponseData> getTrendingOffers({
    required String categoryId,
    required int limit,
    int page = 1,
  }) async {
    try {
      final url = ApiConstants.getTrendingOffers(
        categoryId: categoryId,
        limit: limit,
        page: page,
      );

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Fetching trending offers from: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(url, token: authToken);

      AppLoggerHelper.debug(
        'Trending Offers API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final offersData = response.responseData['data'] as List<dynamic>;
          final offers = offersData
              .map(
                (json) => OfferApiModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
          AppLoggerHelper.debug(
            'Trending offers loaded successfully: ${offers.length}',
          );
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: offers,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error(
            'Error parsing trending offers data',
            parseError,
          );
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing offers data: ${parseError.toString()}',
          );
        }
      } else {
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: null,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Exception while fetching trending offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Exception: ${e.toString()}',
      );
    }
  }
}
