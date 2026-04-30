import 'package:yasminaarsic/core/models/response_data.dart';
import 'package:yasminaarsic/core/services/network_caller.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/core/utils/logging/logger.dart';
import 'package:yasminaarsic/features/profile/data/models/user_model.dart';

class ProfileService {
  final NetworkCaller _networkCaller = NetworkCaller();

  /// Fetch user profile from API and return UserModel wrapped in ResponseData
  Future<ResponseData> getProfile(String? token) async {
    try {
      // AppLoggerHelper.debug(
      //   'Fetching profile from: ${ApiConstants.getProfile}, Token: ${token != null ? 'Bearer token provided' : 'No token provided'}',
      // );

      final response = await _networkCaller.getRequest(
        ApiConstants.getProfile,
        token: token,
      );

      AppLoggerHelper.debug(
        'Profile API Response - Status: ${response.statusCode}, Success: ${response.isSuccess}',
      );

      if (response.isSuccess) {
        try {
          final userData =
              response.responseData['data'] as Map<String, dynamic>;
          final user = UserModel.fromJson(userData);
          AppLoggerHelper.debug('User loaded successfully: ${user.name}');
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: user,
            errorMessage: '',
          );
        } catch (parseError) {
          AppLoggerHelper.error('Error parsing user data', parseError);
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage:
                'Error parsing profile data: ${parseError.toString()}',
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
      AppLoggerHelper.error('Profile Service Error', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Failed to fetch profile: ${e.toString()}',
      );
    }
  }
}
