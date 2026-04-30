import 'package:flutter/material.dart';
class SubscriptionModel {
  final String planTitle;
  final String planSubtitle;
  final String trailingBadgeText;
  final Color trailingBadgeColor;
  final DateTime startDate;
  final DateTime renewalDate;
  final String planDescription;
  final String pricePerYear;
  final bool isAutoRenewEnabled;
  final String autoRenewMessage;
  final List<SubscriptionHistoryItem> history;

  SubscriptionModel({
    required this.planTitle,
    required this.planSubtitle,
    required this.trailingBadgeText,
    required this.trailingBadgeColor,
    required this.startDate,
    required this.renewalDate,
    required this.planDescription,
    required this.pricePerYear,
    required this.isAutoRenewEnabled,
    required this.autoRenewMessage,
    required this.history,
  });
}

class SubscriptionHistoryItem {
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime paidDate;
  final String statusText;
  final Color statusColor;

  SubscriptionHistoryItem({
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.paidDate,
    required this.statusText,
    required this.statusColor,
  });
}