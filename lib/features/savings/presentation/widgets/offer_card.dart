// lib/features/savings/presentation/widgets/offer_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendora/core/utils/constants/colors.dart';

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
  final bool isSelected;
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
    this.isSelected = false,
    this.onTap,
  });

  Widget _buildImage() {
    final imagePath = imageAssetPath?.trim() ?? '';

    if (imagePath.isEmpty) {
      return Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image_outlined, color: Colors.grey[400], size: 28),
      );
    }

    final isRemote = imagePath.startsWith('http://') ||
        imagePath.startsWith('https://') ||
        imagePath.startsWith('/');

    if (isRemote) {
      final fullUrl = imagePath.startsWith('/')
          ? 'https://api.vendora.rs$imagePath'
          : imagePath;
      final encodedUrl = Uri.encodeFull(fullUrl);

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          encodedUrl,
          width: 80.w,
          height: 80.h,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80.w,
              height: 80.h,
              color: Colors.grey[100],
              child: Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 24,
              ),
            );
          },
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          width: 80.w,
          height: 80.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey[400],
                size: 24,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Preview (Network or Asset)
            _buildImage(),
            const SizedBox(width: 14),
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
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (priceBadge != null && priceBadge!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: priceBadgeColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            priceBadge!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w700,
                              color: priceTextColor,
                            ),
                          ),
                        ),
                      ],
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (date != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14.sp,
                          color: dateColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _formatDate(date!),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Arial',
                              color: dateColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  if (location != null && location!.trim().isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.sp,
                          color: locationColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                              color: locationColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
