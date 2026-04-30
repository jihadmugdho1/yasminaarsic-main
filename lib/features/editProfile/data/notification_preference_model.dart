
class NotificationPreferenceModel {
  final String id;
  final String userId;
  final bool newOffer;
  final bool renewalReminder;
  final bool promotional;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationPreferenceModel({
    required this.id,
    required this.userId,
    required this.newOffer,
    required this.renewalReminder,
    required this.promotional,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferenceModel(
      id: json['id'],
      userId: json['userId'],
      newOffer: json['newOffer'] ?? false,
      renewalReminder: json['renewalReminder'] ?? false,
      promotional: json['promotional'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newOffer': newOffer,
      'renewalReminder': renewalReminder,
      'promotional': promotional,
    };
  }
}
