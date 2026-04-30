class UploadImageResponse {
  final String imageUrl;
  final String message;

  UploadImageResponse({
    required this.imageUrl,
    required this.message,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      imageUrl: json['imageUrl'] ?? json['url'] ?? json['image'] ?? '',
      message: json['message'] ?? 'Image uploaded',
    );
  }
}