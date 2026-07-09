import 'package:vendora/core/services/network_caller.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/models/response_data.dart';
import 'package:vendora/core/utils/constants/api_constants.dart';
import 'package:vendora/features/savings/data/models/redeemed_offers_response_model.dart';

class SavingsService {
  final NetworkCaller _networkCaller = NetworkCaller();

  Future<ResponseData> getMyRedeemedOffers() async {
    try {
      final token = StorageService.token;
      if (token == null) {
        return ResponseData(
          isSuccess: false,
          statusCode: 401,
          responseData: null,
          errorMessage: 'Unauthorized: No token found',
        );
      }

      final response = await _networkCaller.getRequest(
        ApiConstants.myRedeemedOffers,
        token: 'Bearer $token',
      );

      if (response.isSuccess && response.responseData != null) {
        final model = RedeemedOffersResponseModel.fromJson(
          response.responseData as Map<String, dynamic>,
        );
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: model,
          errorMessage: '',
        );
      }

      return response;
    } catch (e) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Error fetching redeemed offers: ${e.toString()}',
      );
    }
  }
}
