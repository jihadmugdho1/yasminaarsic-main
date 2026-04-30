class NotificationModel {
  final String id;
  final String userId;
  final bool newOffer;
  final bool renewalReminder;
  final bool promotional;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.newOffer,
    required this.renewalReminder,
    required this.promotional,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      newOffer: json['newOffer'] ?? false,
      renewalReminder: json['renewalReminder'] ?? false,
      promotional: json['promotional'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'newOffer': newOffer,
      'renewalReminder': renewalReminder,
      'promotional': promotional,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}