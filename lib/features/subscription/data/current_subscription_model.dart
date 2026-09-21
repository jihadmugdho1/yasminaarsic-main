import 'package:flutter/material.dart';
import 'package:vendora/features/subscription/data/subscription_history_model.dart';

class CurrentSubscriptionModel {
  final String id;
  final String planName;
  final String status;
  final int? trialPeriodDays;
  final DateTime? trialEndsAt;
  final bool isTrialActive;
  final bool isTrialExpired;
  final int? trialDaysRemaining;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final String? price;
  final String? currency;
  final bool? isFree;
  final String? paymentStatus;
  final SubscriptionHistoryPlan? plan;

  CurrentSubscriptionModel({
    required this.id,
    required this.planName,
    required this.status,
    this.trialPeriodDays,
    this.trialEndsAt,
    this.isTrialActive = false,
    this.isTrialExpired = false,
    this.trialDaysRemaining,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.price,
    this.currency,
    this.isFree,
    this.paymentStatus,
    this.plan,
  });

  factory CurrentSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return CurrentSubscriptionModel(
      id: json['id']?.toString() ?? '',
      planName: json['planName']?.toString() ??
          json['SubscriptionPlan']?['name']?.toString() ??
          '',
      status: json['status']?.toString() ?? 'ACTIVE',
      trialPeriodDays: json['trialPeriodDays'] is num
          ? (json['trialPeriodDays'] as num).toInt()
          : int.tryParse(json['trialPeriodDays']?.toString() ?? ''),
      trialEndsAt: _parseOptionalDate(json['trialEndsAt']),
      isTrialActive: json['isTrialActive'] is bool
          ? json['isTrialActive'] as bool
          : (json['isTrialActive']?.toString().toLowerCase() == 'true'),
      isTrialExpired: json['isTrialExpired'] is bool
          ? json['isTrialExpired'] as bool
          : (json['isTrialExpired']?.toString().toLowerCase() == 'true'),
      trialDaysRemaining: json['trialDaysRemaining'] is num
          ? (json['trialDaysRemaining'] as num).toInt()
          : int.tryParse(json['trialDaysRemaining']?.toString() ?? ''),
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      createdAt: _parseOptionalDate(json['createdAt']),
      price: json['price']?.toString(),
      currency: json['currency']?.toString(),
      isFree: json['isFree'] is bool ? json['isFree'] as bool : null,
      paymentStatus: json['paymentStatus']?.toString(),
      plan: json['SubscriptionPlan'] != null &&
              json['SubscriptionPlan'] is Map<String, dynamic>
          ? SubscriptionHistoryPlan.fromJson(
              json['SubscriptionPlan'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static DateTime? _parseOptionalDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  bool get isTrial =>
      isTrialActive ||
      planName.toLowerCase().contains('trial') ||
      trialPeriodDays != null;

  bool get isActive => status.toUpperCase() == 'ACTIVE' || isTrialActive;

  int get daysRemaining {
    if (trialDaysRemaining != null) return trialDaysRemaining!;
    final targetDate = trialEndsAt ?? endDate;
    final diff = targetDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  String get displayTitle {
    if (planName.isNotEmpty) return planName;
    if (plan?.name.isNotEmpty ?? false) return plan!.name;
    return isTrial ? 'Free Trial' : 'Current Plan';
  }

  String get displaySubtitle {
    if (isTrial) {
      final days = trialPeriodDays ?? 7;
      return '$days Days Trial';
    }
    if (plan != null) {
      return '${plan!.durationInDays} Days Plan';
    }
    final diff = endDate.difference(startDate).inDays;
    return diff > 0 ? '$diff Days Plan' : 'Active Plan';
  }

  String get displayPrice {
    if (isTrial || isFree == true) return 'Free';
    if (plan != null) {
      final p = plan!.currentPriceDisplay.isNotEmpty
          ? plan!.currentPriceDisplay
          : plan!.price;
      return '${plan!.currency} $p';
    }
    if (price != null && price!.isNotEmpty && price != '0') {
      final curr = currency ?? '\$';
      return '$curr$price';
    }
    return 'Free';
  }

  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return const Color(0xFF17A34A);
      case 'EXPIRED':
        return Colors.red;
      case 'CANCELLED':
      case 'CANCELED':
        return Colors.red;
      default:
        return isTrialActive ? const Color(0xFF17A34A) : Colors.grey;
    }
  }
}
