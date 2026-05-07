import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';

class TermsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<ResponseData> getActiveTerms() async {
    try {
      final token = StorageService.token;
      final authToken = token != null && token.isNotEmpty ? 'Bearer $token' : null;

      AppLoggerHelper.debug('Fetching terms and conditions from: ${ApiConstants.termsAndCondition}');

      final response = await _networkCaller.getRequest(
        ApiConstants.termsAndCondition,
        token: authToken,
      );

      AppLoggerHelper.debug('Terms API response - Status: ${response.statusCode}, Success: ${response.isSuccess}');
      return response;
    } catch (e) {
      AppLoggerHelper.error('Error fetching terms and conditions', e);
      return ResponseData(isSuccess: false, statusCode: 0, errorMessage: e.toString(), responseData: null);
    }
  }
}
