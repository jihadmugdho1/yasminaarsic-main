import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/features/editProfile/data/edit_profile_model.dart';

class EditProfileService {
  static const String _contentType = 'application/json; charset=utf-8';

  String? _getAuthHeader() {
    final token = StorageService.token;
    return token != null ? 'Bearer $token' : null;
  }

  Future<UserData?> getProfile() async {
    final auth = _getAuthHeader();
    if (auth == null) return null;

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getProfile),
        headers: {'Authorization': auth, 'Content-Type': _contentType},
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return UserData.fromJson(body['data']);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<UserData?> updateProfile(String userId, Map<String, dynamic> data) async {
    final auth = _getAuthHeader();
    if (auth == null) return null;

    try {
      final response = await http.patch(
        Uri.parse('${ApiConstants.baseUrl}users/$userId'),
        headers: {'Authorization': auth, 'Content-Type': _contentType},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return UserData.fromJson(body['data']);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}