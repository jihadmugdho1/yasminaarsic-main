class OfferResponse {
  final bool success;
  final String message;
  final OfferData data;

  OfferResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OfferData.fromJson(json['data'] ?? {}),
    );
  }
}

class OfferData {
  final List<OfferItem> offers;
  final OfferMeta meta;

  OfferData({required this.offers, required this.meta});

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offers:
          (json['data'] as List<dynamic>?)
              ?.map((e) => OfferItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      meta: OfferMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class OfferItem {
  final String id;
  final String title;
  final String description;
  final String type; // DISCOUNT, BOGO, etc.
  final String status; // ACTIVE, EXPIRED, etc.
  final bool isReusable;
  final int maxRedemptions;
  final int redeemedCount;
  final DateTime validFrom;
  final DateTime validUntil;
  final String vendorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic metadata;
  final double? estimatedValue;
  final String? termsAndConditions;
  final bool isDeleted;
  final int? cooldownPeriod;
  final String? thumbnail;

  OfferItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.isReusable,
    required this.maxRedemptions,
    required this.redeemedCount,
    required this.validFrom,
    required this.validUntil,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
    this.estimatedValue,
    this.termsAndConditions,
    this.isDeleted = false,
    this.cooldownPeriod,
    this.thumbnail,
  });

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      isReusable: json['isReusable'] ?? false,
      maxRedemptions: json['maxRedemptions'] ?? 0,
      redeemedCount: json['redeemedCount'] ?? 0,
      validFrom: DateTime.tryParse(json['validFrom'] ?? '') ?? DateTime.now(),
      validUntil: DateTime.tryParse(json['validUntil'] ?? '') ?? DateTime.now(),
      vendorId: json['vendorId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      metadata: json['metadata'],
      estimatedValue: (json['estimatedValue'] as num?)?.toDouble(),
      termsAndConditions: json['termsAndConditions'] as String?,
      isDeleted: json['isDeleted'] ?? false,
      cooldownPeriod: json['cooldownPeriod'] as int?,
      thumbnail: json['thumbnail'] as String?,
    );
  }
}

class OfferMeta {
  final int total;
  final int page;
  final int lastPage;

  OfferMeta({required this.total, required this.page, required this.lastPage});

  factory OfferMeta.fromJson(Map<String, dynamic> json) {
    return OfferMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      lastPage: json['lastPage'] ?? 1,
    );
  }
}
