import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/models/vendor_model.dart';

class VendorService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetch vendor details by user ID
  Future<ResponseData> getVendorById(String userId) async {
    try {
      final url = ApiConstants.getVendorById(userId);

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Fetching vendor details from: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(url, token: authToken);

      AppLoggerHelper.debug(
        'Vendor Details API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final vendorData =
              response.responseData['data'] as Map<String, dynamic>;
          final vendor = VendorModel.fromJson(vendorData);
          AppLoggerHelper.debug(
            'Vendor details loaded successfully: ${vendor.name}',
          );
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: vendor,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing vendor data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing vendor data: ${parseError.toString()}',
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
      AppLoggerHelper.error('Exception while fetching vendor details', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Exception: ${e.toString()}',
      );
    }
  }

  /// Search vendors by name
  Future<ResponseData> searchVendors(String query) async {
    try {
      final url = ApiConstants.searchVendors(query);

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Searching vendors from: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(url, token: authToken);

      AppLoggerHelper.debug(
        'Search Vendors API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final vendorsData = response.responseData['data'] as List<dynamic>;
          final vendors = vendorsData
              .map((vendorJson) => VendorModel.fromJson(vendorJson))
              .toList();
          AppLoggerHelper.debug(
            'Vendors search completed successfully. Found ${vendors.length} vendors',
          );
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: vendors,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing vendors data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage:
                'Error parsing vendors data: ${parseError.toString()}',
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
      AppLoggerHelper.error('Exception while searching vendors', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Exception: ${e.toString()}',
      );
    }
  }
}
