import 'dart:convert';

import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/models/category_model.dart';

class CategoryService {
  final NetworkCaller _networkCaller = NetworkCaller();


  Future<ResponseData> getCategories() async {
    try {
      AppLoggerHelper.debug('Fetching categories from: ${ApiConstants.get}');

      final response = await _networkCaller.getRequest(ApiConstants.get);

      AppLoggerHelper.debug(
        'Categories API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final categoriesData = response.responseData['data'] as List<dynamic>;
          final categories = categoriesData
              .map(
                (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
          AppLoggerHelper.debug(
            'Categories loaded successfully: ${categories.length}',
          );
          AppLoggerHelper.debug('Category fetch : ${jsonEncode(response.responseData)}');
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: categories,
            errorMessage: '',
          );
          
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing categories data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage:
                'Error parsing categories data: ${parseError.toString()}',
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
      AppLoggerHelper.error('Category Service Error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Failed to fetch categories: ${e.toString()}',
      );
    }
  }
}
