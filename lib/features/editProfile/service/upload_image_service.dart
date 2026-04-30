import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:yasminaarsic/core/services/storage_service.dart';
import 'package:yasminaarsic/core/utils/constants/api_constants.dart';
import 'package:yasminaarsic/features/editProfile/data/upload_image_model.dart';

class UploadImageService {
  String? _getAuthHeader() {
    final token = StorageService.token;
    return token != null ? 'Bearer $token' : null;
  }

  Future<UploadImageResponse?> uploadImage(File imageFile) async {
    final auth = _getAuthHeader();
    if (auth == null) return null;

    try {
      final request = http.MultipartRequest('POST', Uri.parse(ApiConstants.uploadImage));
      request.headers['Authorization'] = auth;

      final mimeType = _getMimeType(imageFile.path);
      final file = await http.MultipartFile.fromPath('image', imageFile.path, contentType: mimeType);
      request.files.add(file);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true) {
          final data = body['data'];
          if (data is Map<String, dynamic>) {
            return UploadImageResponse.fromJson(data);
          } else if (data is String) {
            return UploadImageResponse(imageUrl: data, message: 'Image uploaded');
          }
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  MediaType? _getMimeType(String filePath) {
    final lower = filePath.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return MediaType('image', 'jpeg');
    } else if (lower.endsWith('.png')) {
      return MediaType('image', 'png');
    } else if (lower.endsWith('.gif')) {
      return MediaType('image', 'gif');
    } else if (lower.endsWith('.webp')) {
      return MediaType('image', 'webp');
    }
    return null;
  }
}