// lib/features/profile/data/models/profile_model.dart

import 'models/notification_preference_model.dart';

class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String birthDate;
  final String avatarInitials;
  final String? imageUrl;
  final List<NotificationPreferenceModel> notificationPreferences;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.birthDate,
    required this.avatarInitials,
    this.imageUrl,
    required this.notificationPreferences,
  });
}