// lib/features/savings/presentation/widgets/redeemed_offer_detail_dialog.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/features/savings/data/models/savings_offer_model.dart';

class RedeemedOfferDetailDialog extends StatefulWidget {
  final SavingsOfferModel offer;

  const RedeemedOfferDetailDialog({
    super.key,
    required this.offer,
  });

  static Future<void> show(BuildContext context, SavingsOfferModel offer) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'RedeemedOfferDetailDialog',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: RedeemedOfferDetailDialog(offer: offer),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<RedeemedOfferDetailDialog> createState() =>
      _RedeemedOfferDetailDialogState();
}

class _RedeemedOfferDetailDialogState extends State<RedeemedOfferDetailDialog> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  Widget _buildCarouselImage(String imagePath) {
    final cleanPath = imagePath.trim();
    if (cleanPath.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[500],
            size: 40.sp,
          ),
        ),
      );
    }

    final isRemote = cleanPath.startsWith('http://') ||
        cleanPath.startsWith('https://') ||
        cleanPath.startsWith('/');

    if (isRemote) {
      final fullUrl = cleanPath.startsWith('/')
          ? 'https://api.vendora.rs$cleanPath'
          : cleanPath;
      final encodedUrl = Uri.encodeFull(fullUrl);

      return Image.network(
        encodedUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[500],
                size: 40.sp,
              ),
            ),
          );
        },
      );
    } else {
      return Image.asset(
        cleanPath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey[500],
                size: 40.sp,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.offer.allImages;
    final hasMultipleImages = images.length > 1;
    final locale = Get.find<LocalizationController>();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 0.88.sh,
          maxWidth: 400.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel Slider Section
                Stack(
                  children: [
                    if (images.isEmpty)
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: Colors.grey[400],
                            size: 48.sp,
                          ),
                        ),
                      )
                    else
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 200.h,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: hasMultipleImages,
                          autoPlay: hasMultipleImages,
                          autoPlayInterval: const Duration(seconds: 4),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 600),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: images.map((img) {
                          return _buildCarouselImage(img);
                        }).toList(),
                      ),

                    // Top Gradient Overlay for readability of badges
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 60.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Top-left: Image Counter Badge (if multiple images)
                    if (hasMultipleImages)
                      Positioned(
                        top: 14.h,
                        left: 14.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 9.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${_currentImageIndex + 1}/${images.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Top-right: Close Button
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),

                    // Bottom: Carousel Indicator Dots
                    if (hasMultipleImages)
                      Positioned(
                        bottom: 10.h,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: images.asMap().entries.map((entry) {
                            final isSelected =
                                _currentImageIndex == entry.key;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: isSelected ? 18.w : 6.w,
                              height: 6.h,
                              margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white.withValues(alpha: 0.7),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),

                // Offer Content Body
                Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status & Category Badge Row
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xFFC8E6C9),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: const Color(0xFF2E7D32),
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Redeemed Offer',
                                  style: TextStyle(
                                    color: const Color(0xFF2E7D32),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (widget.offer.savingsBadge.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Saved ${widget.offer.savingsBadge}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Title
                      Text(
                        widget.offer.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: const Color(0xFF101828),
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Merchant / Vendor
                      Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              widget.offer.merchant,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                                color: const Color(0xFF4A5565),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),
                      const Divider(height: 1, color: Color(0xFFEAECF0)),
                      SizedBox(height: 14.h),

                      // Savings Info Card
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCE6),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFF4DB35).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.savings_outlined,
                                color: Colors.black87,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount Saved',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                      color: const Color(0xFF707672),
                                    ),
                                  ),
                                  Text(
                                    widget.offer.savingsBadge.isNotEmpty
                                        ? widget.offer.savingsBadge
                                        : '${widget.offer.savedAmount.toStringAsFixed(2)} RSD',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Arial',
                                      color: const Color(0xFF101828),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.offer.estimatedValue > 0)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Est. Value',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                      color: const Color(0xFF707672),
                                    ),
                                  ),
                                  Text(
                                    '${widget.offer.estimatedValue.toStringAsFixed(0)} RSD',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Arial',
                                      color: const Color(0xFF4A5565),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),

                      // Location Detail
                      if (widget.offer.location.trim().isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18.sp,
                              color: const Color(0xFF6A7282),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF98A2B3),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    widget.offer.location,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF344054),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],

                      // Redeemed Date Detail
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16.sp,
                            color: const Color(0xFF6A7282),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Redeemed On',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF98A2B3),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a')
                                      .format(widget.offer.redeemedDate),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: const Color(0xFF344054),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Close Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            locale.get('close') != 'close'
                                ? locale.get('close')
                                : 'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
