// lib/features/home/widgets/offer_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/common/styles/global_text_style.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/utils/constants/image_path.dart';
import 'package:yasminaarsic/features/home/models/offer_api_model.dart';

class OfferCard extends StatelessWidget {
  final String imagePath;
  final String titleKey;
  final String locationKey;
  final String categoryLabelKey;
  final Function(String userId) onTap; // Changed to pass userId
  final bool isNetworkImage; // Flag to indicate if image is from network
  final OfferApiModel? offerData; // Store the full offer data

  const OfferCard({
    super.key,
    required this.imagePath,
    required this.titleKey,
    required this.locationKey,
    required this.categoryLabelKey,
    required this.onTap, // Required onTap
    this.isNetworkImage = false, // Default to asset image
    this.offerData,
  });

  String _buildLocationText(LocalizationController locale) {
    final vendorName =
        offerData?.vendorProfile?.businessName ??
        offerData?.vendorProfile?.user?.name;

    if (vendorName != null && vendorName.trim().isNotEmpty) {
      return vendorName.trim();
    }

    return locale.get(locationKey);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();

    return GestureDetector(
      onTap: () {
        // Extract userId from vendorProfile if available
        final userId = offerData?.vendorProfile?.userId ?? '';
        onTap(userId);
      },
      child: Container(
        width: 164.w,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: isNetworkImage
                  ? _NetworkImageWithTimeout(
                      imageUrl: imagePath,
                      height: 110.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      timeoutSeconds: 5,
                      fallbackImage: ImagePath.appLogo,
                    )
                  : Image.asset(
                      imagePath,
                      height: 110.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    locale.currentLanguage.value; // Trigger reactivity
                    return Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      locale.get(titleKey),
                      style: primaryFontStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    );
                  }),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(Icons.store, size: 18.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Obx(() {
                          locale.currentLanguage.value; // Trigger reactivity
                          return Text(
                            _buildLocationText(locale),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: secondaryFontStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: 10.w,
                  //     vertical: 5.h,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.yellow[600],
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Obx(() {
                  //     locale.currentLanguage.value; // Trigger reactivity
                  //     return Text(
                  //       locale.get(categoryLabelKey),
                  //       style: TextStyle(
                  //         color: Colors.black87,
                  //         fontSize: 12.sp,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkImageWithTimeout extends StatefulWidget {
  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final int timeoutSeconds;
  final String fallbackImage;

  const _NetworkImageWithTimeout({
    required this.imageUrl,
    required this.height,
    this.width,
    required this.fit,
    required this.timeoutSeconds,
    required this.fallbackImage,
  });

  @override
  _NetworkImageWithTimeoutState createState() =>
      _NetworkImageWithTimeoutState();
}

class _NetworkImageWithTimeoutState extends State<_NetworkImageWithTimeout> {
  bool _showFallback = false;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && !_showFallback && !_imageLoaded) {
        setState(() {
          _showFallback = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      return Image.asset(
        widget.fallbackImage,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
    }

    return Image.network(
      widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          _imageLoaded = true;
        }
        return child;
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          widget.fallbackImage,
          height: widget.height,
          width: widget.width,
          fit: widget.fit,
        );
      },
    );
  }
}
