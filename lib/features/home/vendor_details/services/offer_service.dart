import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_response_model.dart';

class OfferService {
  final NetworkCaller _networkCaller = NetworkCaller();
String?token="";
  /// Fetch offers for a specific vendor by vendor ID
  ///
  /// Parameters:
  /// - vendorId: The ID of the vendor to fetch offers for
  /// - page: Page number for pagination (default: 1)
  /// - limit: Number of offers per page (default: 10)
  /// - search: Search term to filter offers (optional)
  /// - status: Filter by offer status (optional)
  /// - type: Filter by offer type (optional)
  Future<ResponseData> getVendorOffers({
    required String vendorId,
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String? type,
  }) async {
    try {
      final baseUrl = ApiConstants.baseUrl;
      final endpoint = 'offer/vendor/$vendorId';
      final url = '$baseUrl$endpoint';

      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        if (type != null && type.isNotEmpty) 'type': type,
      };

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Fetching offers from: $url, Query: $queryParams, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(
        url,
        token: authToken,
        queryParams: queryParams,
      );

      AppLoggerHelper.debug(
        'Offers API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final responseData = response.responseData as Map<String, dynamic>;
          final offerResponse = OfferResponse.fromJson(responseData);

          AppLoggerHelper.debug(
            'Offers loaded successfully: ${offerResponse.data.offers.length} offers found',
          );

          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: offerResponse,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing offers data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing offers data: ${parseError.toString()}',
          );
        }
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offers: ${response.errorMessage}',
        );
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: null,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offers', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 0,
        responseData: null,
        errorMessage: 'Error fetching offers: ${e.toString()}',
      );
    }
  }

  /// Fetch single offer details by offer ID
  Future<ResponseData> getOfferById(String offerId) async {
    try {
      final baseUrl = ApiConstants.baseUrl;
      final endpoint = 'offer/$offerId';
      final url = '$baseUrl$endpoint';

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      AppLoggerHelper.debug(
        'Fetching offer details from: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.getRequest(url, token: authToken);

      AppLoggerHelper.debug(
        'Single offer API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final responseData = response.responseData as Map<String, dynamic>;
          final offerData = responseData['data'] as Map<String, dynamic>;

          AppLoggerHelper.debug(
            'Offer details loaded successfully: ${offerData['title']}',
          );

          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: offerData,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing offer data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing offer data: ${parseError.toString()}',
          );
        }
      } else {
        AppLoggerHelper.error(
          'Failed to fetch offer details: ${response.errorMessage}',
        );
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: null,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error fetching offer details', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 0,
        responseData: null,
        errorMessage: 'Error fetching offer details: ${e.toString()}',
      );
    }
  }

  /// Generate a one-time QR code for the specified offer
  ///
  /// Parameters:
  /// - offerId: The ID of the offer to generate QR code for
  ///
  /// Returns:
  /// - ResponseData with QR code token in the data field
  Future<ResponseData> generateOfferQRCode(String offerId) async {
    try {
      final baseUrl = ApiConstants.baseUrl;
      final endpoint = 'offer/qr-code';
      final url = '$baseUrl$endpoint';

      // Get token from StorageService
      final token = StorageService.token;
      final authToken = token != null ? 'Bearer $token' : null;

      final requestBody = {'offerId': offerId};
      

      AppLoggerHelper.debug(
        'Generating QR code for offer: $offerId, URL: $url, Token: ${token != null ? 'Bearer token provided' : 'No token'}',
      );

      final response = await _networkCaller.postRequest(
        url,
        body: requestBody,
        token: authToken,
      );

      AppLoggerHelper.debug(
        'QR Code generation API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final responseData = response.responseData as Map<String, dynamic>;
          final qrData = responseData['data'] as Map<String, dynamic>;
          final extractedToken = qrData['token'] as String?;

          // Store token in the service property for access in UI
          this.token = extractedToken ?? '';

          AppLoggerHelper.debug(
            'QR code generated successfully for offer: $extractedToken',
          );

          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: qrData,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing QR code data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: 'Error parsing QR code data: ${parseError.toString()}',
          );
        }
      } else {
        AppLoggerHelper.error(
          'Failed to generate QR code: ${response.errorMessage}',
        );
        return ResponseData(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: null,
          errorMessage: response.errorMessage,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error generating QR code', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 0,
        responseData: null,
        errorMessage: 'Error generating QR code: ${e.toString()}',
      );
    }
  }
}
