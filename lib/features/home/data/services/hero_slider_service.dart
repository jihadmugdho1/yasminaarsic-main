import 'package:vendora/core/models/response_data.dart';
import 'package:vendora/core/services/network_caller.dart';
import 'package:vendora/core/services/storage_service.dart';
import 'package:vendora/core/utils/constants/api_constants.dart';
import 'package:vendora/core/utils/logging/logger.dart';

class HeroSliderService {
  final NetworkCaller _networkCaller = NetworkCaller();

  String? get _authToken {
    final token = StorageService.token;
    return token != null ? 'Bearer $token' : null;
  }

  Future<ResponseData> getActiveSliders() async {
    try {
      final response = await _networkCaller.getRequest(
        ApiConstants.heroSlider,
        token: _authToken,
      );

      if (response.isSuccess) {
        final body = response.responseData as Map<String, dynamic>;
        final data = body['data'];
        List<String> imageUrls = [];

        if (data is List) {
          imageUrls = data
              .map((item) => (item as Map<String, dynamic>)['imageUrl'] as String? ?? '')
              .where((url) => url.isNotEmpty)
              .toList();
        } else if (data is Map<String, dynamic>) {
          final url = data['imageUrl'] as String? ?? '';
          if (url.isNotEmpty) imageUrls = [url];
        }

        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: imageUrls,
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
      AppLoggerHelper.error('Error fetching hero sliders', e);
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: e.toString(),
      );
    }
  }
}
