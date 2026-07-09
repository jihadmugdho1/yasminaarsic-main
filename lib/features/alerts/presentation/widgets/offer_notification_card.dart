// lib/features/alerts/presentation/widgets/offer_notification_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vendora/core/common/widgets/custom_button.dart';

class OfferNotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime? dateTime;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? descriptionColor;
  final Color? dateTimeColor;
  final Color? iconBackgroundColor;
  final Color? iconForegroundColor;
  final String? svgIconPath;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isSelected; // ✅ New parameter
  final VoidCallback? onTap;
  final VoidCallback? onDelete; // ✅ Delete callback

  const OfferNotificationCard({
    super.key,
    required this.title,
    required this.description,
    this.dateTime,
    this.badgeText = 'New',
    this.badgeColor = const Color(0xFFFFD700),
    this.badgeTextColor = Colors.black,
    this.backgroundColor = const Color(0xFFF0F5FF),
    this.titleColor = Colors.black87,
    this.descriptionColor = const Color(0xFF4A5565),
    this.dateTimeColor = const Color(0xFF6A7282),
    this.iconBackgroundColor = const Color(0xFF90EE90),
    this.iconForegroundColor = Colors.white,
    this.svgIconPath,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
    this.isSelected = false, // ✅ Default to false
    this.onTap,
    this.onDelete, // ✅ Delete callback
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Define border color based on selection
    Color borderColor = isSelected
        ? const Color(0xFF6C63FE) // Selected border color (purple)
        : const Color(0xFFC5BDFF); // Default border color

    // ✅ Use white background when not selected
    Color bgColor = isSelected
        ? (backgroundColor ?? const Color(0xFFF0F5FF))
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: 2.0, // Slightly thicker to be noticeable
          ),
        ),
        child: Row(
          children: [
            // SVG Icon Circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: svgIconPath != null
                  ? SvgPicture.asset(
                      svgIconPath!,
                      color: iconForegroundColor,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => _buildFallbackIcon(),
                      errorBuilder: (context, error, stackTrace) =>
                          _buildFallbackIcon(),
                    )
                  : _buildFallbackIcon(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Arial',
                            color: titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (badgeText != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: descriptionColor),
                  ),
                  const SizedBox(height: 8),
                  if (dateTime != null)
                    // Text(
                    //   _formatDateTime(dateTime!),
                    //   style: TextStyle(
                    //     fontSize: 16.sp,
                    //     color: dateTimeColor,
                    //   ),
                    // ),
                    Row(
                      children: [
                        Text(
                          _formatDateTime(dateTime!),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: dateTimeColor,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Confirm Delete',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this notification?',
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    CustomButton(
                                      text: 'Cancel',
                                      type: ButtonType.outlined,
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      backgroundColor: Colors.white,
                                      textColor: Colors.grey,
                                      borderColor: Colors.grey,
                                      borderRadius: 8,
                                    ),
                                    CustomButton(
                                      text: 'Delete',
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onDelete?.call();
                                      },
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(Icons.info_outline, color: iconForegroundColor, size: 20);
  }

  String _formatDateTime(DateTime dateTime) {
    final time = DateFormat.jm().format(dateTime); // "10:00 AM"
    final date = DateFormat('MMM d').format(dateTime); // "Oct 24"
    return '$date, $time';
  }
}
