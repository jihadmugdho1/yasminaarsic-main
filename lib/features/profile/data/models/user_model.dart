import 'notification_model.dart';

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
  final bool isSubscribed;
  final String? verificationCode;
  final String? verificationCodeExpiry;
  final List<NotificationModel> notifications;

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
    this.isSubscribed = false,
    this.verificationCode,
    this.verificationCodeExpiry,
    required this.notifications,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? 'example@email.com',
      name: json['name'] ?? 'Your Name',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      role: json['role'] ?? 'USER',
      dateOfBirth: json['dateOfBirth'] ?? "Your birth date",
      location: json['location'] ?? 'Your Location',
      imageUrl: json['imageUrl'],
      phone: json['phone'] ?? '+1 000 000 0000',
      status: json['status'] ?? 'ACTIVE',
      isEmailVerified: json['isEmailVerified'] ?? false,
      isSubscribed: json['isSubscribed'] ?? false,
      verificationCode: json['verificationCode'],
      verificationCodeExpiry: json['verificationCodeExpiry'],
      notifications:
          (json['notifications'] as List?)
              ?.map((n) => NotificationModel.fromJson(n))
              .toList() ??
          [],
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
      'notifications': notifications.map((n) => n.toJson()).toList(),
    };
  }
}
