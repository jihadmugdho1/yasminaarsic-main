// lib/features/subscription/presentation/widgets/subscription_status_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';

class SubscriptionStatusCard extends StatelessWidget {
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime paidDate;
  final String statusText;
  final Color statusColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? priceColor;
  final Color? iconColor;
  final Color? statusTextColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isSelected; // ✅ New parameter
  final VoidCallback? onTap;

  const SubscriptionStatusCard({
    super.key,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.paidDate,
    this.statusText = 'Active',
    this.statusColor = const Color(0xFFFFD700),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black87,
    this.priceColor = Colors.black,
    this.iconColor = Colors.grey,
    this.statusTextColor = Colors.black,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
    this.isSelected = false, // ✅ Default to false
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial',
                    color: priceColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(startDate)} to ${_formatDate(endDate)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  locale
                      .get('paid_on')
                      .replaceFirst('{date}', _formatShortDate(paidDate)),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w400,
                    color: textColor?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
