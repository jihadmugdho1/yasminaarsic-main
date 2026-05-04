import 'package:flutter/material.dart';

class SubscriptionHistoryModel {
  final String id;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFree;
  final String price;
  final String paymentStatus;
  final SubscriptionHistoryPlan? plan;

  SubscriptionHistoryModel({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.isFree,
    required this.price,
    required this.paymentStatus,
    this.plan,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      isFree: json['isFree'] ?? false,
      price: json['price'] ?? '0',
      paymentStatus: json['paymentStatus'] ?? '',
      plan: json['SubscriptionPlan'] != null
          ? SubscriptionHistoryPlan.fromJson(
              json['SubscriptionPlan'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return DateTime.now();
    }
  }

  double get priceAsDouble => double.tryParse(price) ?? 0.0;

  String get statusText => paymentStatus.isNotEmpty ? paymentStatus : status;

  Color get statusColor {
    switch (statusText.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFFF4DB35);
      case 'COMPLETED':
      case 'PAID':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
      case 'CANCELED':
        return Colors.red;
      case 'EXPIRED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

class SubscriptionHistoryPlan {
  final String id;
  final String name;
  final String price;
  final String currentPriceDisplay;
  final int durationInDays;
  final String currency;

  SubscriptionHistoryPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currentPriceDisplay,
    required this.durationInDays,
    required this.currency,
  });

  factory SubscriptionHistoryPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionHistoryPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '0',
      currentPriceDisplay: json['currentPriceDisplay'] ?? '',
      durationInDays: json['durationInDays'] ?? 0,
      currency: json['currency'] ?? 'USD',
    );
  }
}
