import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/home/vendor_details/models/offer_model.dart';
import '../../controllers/offer_dialog_controller.dart';

class OfferDialog extends StatelessWidget {
  final Offer offer;
  final int offerIndex;
  final Map<String, dynamic>? offerDetail;

  const OfferDialog({
    super.key,
    required this.offer,
    required this.offerIndex,
    this.offerDetail,
  });

  /// Build offer image with fallback to default image
  Widget _buildOfferImage() {
    final thumbnail = offerDetail?['thumbnail'] as String? ??
        offerDetail?['imageUrl'] as String? ??
        offer.imageUrl;

    if (thumbnail.isNotEmpty) {
      final isRemoteUrl = thumbnail.startsWith('http://') ||
          thumbnail.startsWith('https://') ||
          thumbnail.startsWith('/');

      if (isRemoteUrl) {
        final fullUrl = thumbnail.startsWith('/')
            ? 'https://api.vendora.rs$thumbnail'
            : thumbnail;

        return Image.network(
          fullUrl,
          height: 190.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              ImagePath.appLogo,
              height: 190.h,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 190.h,
              width: double.infinity,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            );
          },
        );
      }
    }

    return Image.asset(
      ImagePath.appLogo,
      height: 190.h,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tag = 'offer_${offer.id ?? offerIndex}';
    final locale = Get.find<LocalizationController>();

    if (Get.isRegistered<OfferController>(tag: tag)) {
      Get.delete<OfferController>(tag: tag);
    }

    final controller = Get.put(
      OfferController(
        isReuseable: offer.isReuseable,
        offerData: offer,
        offerIndex: offerIndex,
        offerDetail: offerDetail,
      ),
      tag: tag,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              margin: EdgeInsets.only(top: 36.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: _buildOfferImage(),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 14.h),
                        if (controller.offer.value.title.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.offer.value.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 5.h),
                        Builder(
                          builder: (context) {
                            final profile = (offerDetail?['VendorProfile'] ??
                                offerDetail?['vendorProfile']) as Map<String, dynamic>?;
                            final vendorName = profile?['businessName'] as String? ??
                                profile?['user']?['name'] as String? ??
                                offer.restaurantName;
                            if (vendorName.isEmpty) return const SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vendorName,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (controller.offer.value.description.isNotEmpty) ...[
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.offer.value.description,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ],
                        if (controller.offer.value.location.isNotEmpty) ...[
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 18.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    controller.offer.value.location,
                                    style: TextStyle(fontSize: 12.sp),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 18.sp),
                              SizedBox(width: 8.w),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(controller.offer.value.expiryDate),
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        if (controller.offer.value.estimatedValue > 0) ...[
                          SizedBox(height: 5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              children: [
                                Icon(Icons.attach_money_outlined, size: 18.sp),
                                SizedBox(width: 8.w),
                                Obx(
                                  () => Text(
                                    '${locale.get('estimated_value')}: \$${controller.offer.value.estimatedValue.toStringAsFixed(controller.offer.value.estimatedValue.truncateToDouble() == controller.offer.value.estimatedValue ? 0 : 2)}',
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (controller.offer.value.terms.isNotEmpty) ...[
                          SizedBox(height: 10.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: const Divider(),
                          ),
                          SizedBox(height: 4.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Obx(
                                () => Text(
                                  locale.get('terms_conditions'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.offer.value.terms,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.redeemOffer(context);
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: AppColors.yellow,
                              minimumSize: Size(0, 40.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              locale.get('redeem_offer_action'),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                              side: BorderSide(color: AppColors.textSecondary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(0, 40.h),
                            ),
                            child: Text(
                              locale.get('close_dialog'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
          // Offer Type badge
          Positioned(
            top: 49.h,
            right: 22.w,
            child: Builder(
              builder: (context) {
                final badgeText = (offerDetail?['type'] as String?) ??
                    (offer.category.isNotEmpty ? offer.category : null);
                if (badgeText == null || badgeText.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
