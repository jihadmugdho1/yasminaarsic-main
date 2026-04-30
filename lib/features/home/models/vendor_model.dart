class VendorModel {
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
  final VendorProfileModel? vendorProfile;

  VendorModel({
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
    this.vendorProfile,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
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
      vendorProfile: json['vendorProfile'] != null
          ? VendorProfileModel.fromJson(json['vendorProfile'])
          : null,
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
      'vendorProfile': vendorProfile?.toJson(),
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
  final CategoryModel? category;

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
    this.category,
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
      category: json['Category'] != null
          ? CategoryModel.fromJson(json['Category'])
          : null,
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
      'Category': category?.toJson(),
    };
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
