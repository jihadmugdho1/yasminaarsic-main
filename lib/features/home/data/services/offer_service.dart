import 'dart:convert';

import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/models/offer_api_model.dart';

class OfferService {
  final NetworkCaller _networkCaller = NetworkCaller();

  String? get _authToken {
    final token = StorageService.token;
    return token != null ? 'Bearer $token' : null;
  }

  List<OfferApiModel> _parseOffers(Map<String, dynamic> responseData) {
    final raw = responseData['data'];
    if (raw == null) {
      AppLoggerHelper.warning('_parseOffers: "data" key is null. Full response: ${responseData.keys.toList()}');
      return [];
    }

    List<dynamic> offersData;
    if (raw is List) {
      offersData = raw;
    } else if (raw is Map<String, dynamic>) {
      final offers = raw['offers'];
      if (offers == null) {
        AppLoggerHelper.warning('_parseOffers: "data.offers" key is null. data keys: ${raw.keys.toList()}');
        return [];
      }
      offersData = offers as List<dynamic>;
    } else {
      AppLoggerHelper.warning('_parseOffers: unexpected "data" type: ${raw.runtimeType}');
      return [];
    }

    return offersData
        .map((json) => OfferApiModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  int _parseTotalPages(Map<String, dynamic> responseData) {
    final raw = responseData['data'];
    if (raw is Map<String, dynamic>) {
      final pagination = raw['pagination'] as Map<String, dynamic>?;
      return (pagination?['totalPages'] as int?) ?? 1;
    }
    return 1;
  }

  /// Fetch all offers — used for "All Offers" category
  Future<ResponseData> getOffers({
    String? categoryId,
    required int limit,
    int page = 1,
  }) async {
    try {
      final url = ApiConstants.getOffers(
        categoryId: categoryId,
        limit: limit,
        page: page,
      );
      AppLoggerHelper.debug('Fetching offers from: $url');
      final response = await _networkCaller.getRequest(url, token: _authToken);

      if (response.isSuccess) {
        final offers = _parseOffers(response.responseData);
        final totalPages = _parseTotalPages(response.responseData);
        AppLoggerHelper.debug('Offers loaded: ${offers.length}');
        AppLoggerHelper.debug("api endpoiunt :$url");
        AppLoggerHelper.debug("loaded : ${jsonEncode(response.responseData)}");

      


          
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: {'offers': offers, 'totalPages': totalPages},
          errorMessage: '',
        );
      }
  
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: null,
        errorMessage: response.errorMessage,
      );

    } catch (e) {
      AppLoggerHelper.error('Exception while fetching offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch newest offers for a specific category
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
      AppLoggerHelper.debug('Fetching newest offers from: $url');
      final response = await _networkCaller.getRequest(url, token: _authToken);

      AppLoggerHelper.debug('Newest offers raw response: ${jsonEncode(response.responseData)}');
      if (response.isSuccess) {
        final offers = _parseOffers(response.responseData);
        final totalPages = _parseTotalPages(response.responseData);
        AppLoggerHelper.debug('Newest offers loaded: ${offers.length}, totalPages: $totalPages');
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: {'offers': offers, 'totalPages': totalPages},
          errorMessage: '',
        );
      }
      AppLoggerHelper.error('Newest offers API failed [${response.statusCode}]: ${response.errorMessage}');
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: null,
        errorMessage: response.errorMessage,
      );
    } catch (e) {
      AppLoggerHelper.error('Exception while fetching newest offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }

  /// Fetch trending offers for a specific category
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
      AppLoggerHelper.debug('Fetching trending offers from: $url');
      final response = await _networkCaller.getRequest(url, token: _authToken);

      AppLoggerHelper.debug('Trending offers raw response: ${jsonEncode(response.responseData)}');
      if (response.isSuccess) {
        final offers = _parseOffers(response.responseData);
        final totalPages = _parseTotalPages(response.responseData);
        AppLoggerHelper.debug('Trending offers loaded: ${offers.length}, totalPages: $totalPages');
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: {'offers': offers, 'totalPages': totalPages},
          errorMessage: '',
        );
      }
      AppLoggerHelper.error('Trending offers API failed [${response.statusCode}]: ${response.errorMessage}');
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: null,
        errorMessage: response.errorMessage,
      );
    } catch (e) {
      AppLoggerHelper.error('Exception while fetching trending offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }
}
