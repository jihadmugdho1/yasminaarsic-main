// lib/features/editProfile/data/edit_profile_model.dart
import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

class UserProfile {
  final bool success;
  final String message;
  final UserData data;

  UserProfile({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        success: json["success"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );
}

class UserData {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? location;
  final DateTime? dateOfBirth;
  final String? imageUrl;
  final String role;
  final String status;
  final bool isEmailVerified;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.location,
    this.dateOfBirth,
    this.imageUrl,
    required this.role,
    required this.status,
    required this.isEmailVerified,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        location: json["location"],
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.tryParse(json["dateOfBirth"]) ??
                // Fallback if only date (no time)
                DateTime.tryParse("${json["dateOfBirth"]}T00:00:00.000Z"),
        imageUrl: json["imageUrl"],
        role: json["role"],
        status: json["status"],
        isEmailVerified: json["isEmailVerified"],
        updatedAt: DateTime.tryParse(json["updatedAt"]) ??
            DateTime.tryParse("${json["updatedAt"]}T00:00:00.000Z") ??
            DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "location": location,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "phone": phone,
      };

  String get avatarInitials {
    if (name.isEmpty) return ' ';
    final names = name.trim().split(' ');
    if (names.length > 1 && names[1].isNotEmpty) {
      return names[0][0].toUpperCase() + names[1][0].toUpperCase();
    } else if (names.isNotEmpty && names[0].isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return ' ';
  }
}