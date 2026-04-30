class OfferApiModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final bool isReusable;
  final int maxRedemptions;
  final int redeemedCount;
  final String validFrom;
  final String validUntil;
  final String vendorId;
  final String createdAt;
  final String updatedAt;
  final dynamic metadata;
  final int estimatedValue;
  final String termsAndConditions;
  final bool isDeleted;
  final int cooldownPeriod;
  final String thumbnail;
  final VendorProfileModel? vendorProfile;

  OfferApiModel({
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
    required this.estimatedValue,
    required this.termsAndConditions,
    required this.isDeleted,
    required this.cooldownPeriod,
    required this.thumbnail,
    this.vendorProfile,
  });

  factory OfferApiModel.fromJson(Map<String, dynamic> json) {
    return OfferApiModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      isReusable: json['isReusable'] ?? false,
      maxRedemptions: json['maxRedemptions'] ?? 0,
      redeemedCount: json['redeemedCount'] ?? 0,
      validFrom: json['validFrom'] ?? '',
      validUntil: json['validUntil'] ?? '',
      vendorId: json['vendorId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      metadata: json['metadata'],
      estimatedValue: json['estimatedValue'] ?? 0,
      termsAndConditions: json['termsAndConditions'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      cooldownPeriod: json['cooldownPeriod'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      vendorProfile: json['VendorProfile'] != null
          ? VendorProfileModel.fromJson(json['VendorProfile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'isReusable': isReusable,
      'maxRedemptions': maxRedemptions,
      'redeemedCount': redeemedCount,
      'validFrom': validFrom,
      'validUntil': validUntil,
      'vendorId': vendorId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'metadata': metadata,
      'estimatedValue': estimatedValue,
      'termsAndConditions': termsAndConditions,
      'isDeleted': isDeleted,
      'cooldownPeriod': cooldownPeriod,
      'thumbnail': thumbnail,
      'VendorProfile': vendorProfile?.toJson(),
    };
  }
}

class VendorProfileModel {
  final String id;
  final String userId;
  final String? businessName;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;
  final String city;
  final String? contactEmail;
  final String? logoUrl;
  final String streetAddress;
  final String vendorId;
  final String zipCode;
  final String categoryId;
  final UserModel? user;

  VendorProfileModel({
    required this.id,
    required this.userId,
    this.businessName,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
    this.contactEmail,
    this.logoUrl,
    required this.streetAddress,
    required this.vendorId,
    required this.zipCode,
    required this.categoryId,
    this.user,
  });

  factory VendorProfileModel.fromJson(Map<String, dynamic> json) {
    return VendorProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      businessName: json['businessName'],
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      city: json['city'] ?? '',
      contactEmail: json['contactEmail'],
      logoUrl: json['logoUrl'],
      streetAddress: json['streetAddress'] ?? '',
      vendorId: json['vendorId'] ?? '',
      zipCode: json['zipCode'] ?? '',
      categoryId: json['categoryId'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'isVerified': isVerified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'city': city,
      'contactEmail': contactEmail,
      'logoUrl': logoUrl,
      'streetAddress': streetAddress,
      'vendorId': vendorId,
      'zipCode': zipCode,
      'categoryId': categoryId,
      'user': user?.toJson(),
    };
  }
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String role;
  final String? dateOfBirth;
  final String? location;
  final String? imageUrl;
  final String? phone;
  final String status;
  final bool isEmailVerified;
  final String verificationCode;
  final String verificationCodeExpiry;
  final dynamic fcmTokens;
  final String? lastActiveAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    this.dateOfBirth,
    this.location,
    this.imageUrl,
    this.phone,
    required this.status,
    required this.isEmailVerified,
    required this.verificationCode,
    required this.verificationCodeExpiry,
    this.fcmTokens,
    this.lastActiveAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      role: json['role'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      phone: json['phone'],
      status: json['status'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      verificationCode: json['verificationCode'] ?? '',
      verificationCodeExpiry: json['verificationCodeExpiry'] ?? '',
      fcmTokens: json['fcmTokens'],
      lastActiveAt: json['lastActiveAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role,
      'dateOfBirth': dateOfBirth,
      'location': location,
      'imageUrl': imageUrl,
      'phone': phone,
      'status': status,
      'isEmailVerified': isEmailVerified,
      'verificationCode': verificationCode,
      'verificationCodeExpiry': verificationCodeExpiry,
      'fcmTokens': fcmTokens,
      'lastActiveAt': lastActiveAt,
    };
  }
}
