// lib/features/savings/presentation/widgets/offer_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? priceBadge;
  final Color? priceBadgeColor;
  final Color? priceTextColor;
  final DateTime? date;
  final String? location;
  final String? imageAssetPath;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? dateColor;
  final Color? locationColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool isSelected; // ✅ New parameter
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.priceBadge,
    this.priceBadgeColor = const Color(0xFFF4DB35),
    this.priceTextColor = const Color(0xFF000000),
    this.date,
    this.location,
    this.imageAssetPath,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.titleColor = const Color(0xFF101828),
    this.subtitleColor = const Color(0xFF4A5565),
    this.dateColor = const Color(0xFF6A7282),
    this.locationColor = const Color(0xFF6A7282),
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16),
    this.isSelected = false, // ✅ Default to false
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Set border color based on selection
    Color borderColor = isSelected
        ? const Color(0xFF6C63FE) // Selected border color (vibrant purple)
        : Colors.grey.withOpacity(0.2); // Default border

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0, // Slightly thicker when selected
          ),
        ),
        child: Row(
          children: [
            // Image Asset
            if (imageAssetPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageAssetPath!,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.w,
                      height: 80.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey[500], size: 24),
                    );
                  },
                ),
              )
            else
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: Colors.grey[500], size: 24),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Inter',
                            color: titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priceBadge != null)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: priceBadgeColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priceBadge!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w600,
                              color: priceTextColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (date != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 16, color: dateColor),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(date!),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Arial',
                            color: dateColor,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if (location != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: locationColor),
                        const SizedBox(width: 4),
                        Text(
                          location!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                            color: locationColor,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}