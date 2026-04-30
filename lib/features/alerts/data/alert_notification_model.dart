import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertNotificationModel {
  final String title;
  final String description;
  final DateTime dateTime;
  final String badgeText;
  final Color badgeColor;
  final String svgIconPath;
  final Color iconBackgroundColor;
  final Color iconForegroundColor;
  final Color backgroundColor;
  final RxBool isNew; // ✅ Track if notification is new

  AlertNotificationModel({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.badgeText,
    required this.badgeColor,
    required this.svgIconPath,
    required this.iconBackgroundColor,
    required this.iconForegroundColor,
    required this.backgroundColor,
    bool isNew = true, // ✅ Default to true
  }) : isNew = isNew.obs;
}

// New API-based notification models
class NotificationResponse {
  final bool success;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final List<NotificationItem> notifications;
  final NotificationMeta meta;

  NotificationData({required this.notifications, required this.meta});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications:
          (json['data'] as List<dynamic>?)
              ?.map((item) => NotificationItem.fromJson(item))
              .toList() ??
          [],
      meta: NotificationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class NotificationItem {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationDataItem data;
  final String type;
  final String status;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.data,
    required this.type,
    required this.status,
    this.sentAt,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: NotificationDataItem.fromJson(json['data'] ?? {}),
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  bool get isRead => status == 'READ';
  bool get isUnread => !isRead;
}

class NotificationDataItem {
  final String screen;
  final String offerId;
  final String offerType;

  NotificationDataItem({
    required this.screen,
    required this.offerId,
    required this.offerType,
  });

  factory NotificationDataItem.fromJson(Map<String, dynamic> json) {
    return NotificationDataItem(
      screen: json['screen'] ?? '',
      offerId: json['offerId'] ?? '',
      offerType: json['offerType'] ?? '',
    );
  }
}

class NotificationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  NotificationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}
