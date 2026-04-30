import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/features/home/vendor_details/controllers/offer_dialog_controller.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/alert_dialogs/qr_dialog_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/alert_dialogs/qr_dialog.dart';

class OfferDialog extends StatelessWidget {
  final Offer? offer;
  final int offerIndex;
  final Map<String, dynamic>? offerDetail;

  const OfferDialog({
    Key? key,
    this.offer,
    this.offerIndex = 0,
    this.offerDetail,
  }) : super(key: key);
  Widget _buildOfferImage() {
    final controller = Get.find<OfferController>();
    final imageUrl = controller.offer.value.imageUrl;

    // Check if URL is empty or null
    if (imageUrl.isEmpty) {
      return Container(
        height: 190.h,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            ImagePath.appLogo,
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    // Check if it's a network URL
    if (imageUrl.startsWith('http') ||
        imageUrl.startsWith('https') ||
        imageUrl.startsWith('/')) {
      final fullUrl = imageUrl.startsWith('/')
          ? 'https://yasminaarsic-server.onrender.com$imageUrl'
          : imageUrl;

      return _NetworkImageWithTimeout(
        imageUrl: fullUrl,
        height: 190.h,
        width: double.infinity,
        fit: BoxFit.cover,
        timeoutSeconds: 2,
        fallbackImage: ImagePath.appLogo,
      );
    } else {
      // Local asset
      return Image.asset(
        imageUrl,
        height: 190.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 190.h,
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Image.asset(
                ImagePath.appLogo,
                height: 100.h,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OfferController(
        offerData: offer,
        offerIndex: offerIndex,
        offerDetail: offerDetail,
      ),
    );
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            margin: EdgeInsets.only(top: 36.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  child: _buildOfferImage(),
                ),
                SizedBox(height: 14.h),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bella Vista Restaurant",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
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
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        controller.offer.value.location,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        '${controller.offer.value.expiryDate.toLocal()}'.split(
                          ' ',
                        )[0],
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money_outlined, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Estimated value: \$${controller.offer.value.estimatedValue}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3, // Redeem button takes 3/4 width
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.offer.value.isRedeemed
                                ? () {
                                    showQrRedemptionDialog(
                                      context,
                                      QrOffer(
                                        title: controller.offer.value.title,
                                        vendor: "Bella Vista Restaurant",
                                        location:
                                            controller.offer.value.location,
                                        validUntil:
                                            '${controller.offer.value.expiryDate.toLocal()}'
                                                .split(' ')[0],
                                        isRedeemed:
                                            controller.offer.value.isRedeemed,
                                        qrCode: 'ABC123XYZ',
                                      ),
                                    );
                                  }
                                : () => controller.redeemOffer(context),
                            style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              backgroundColor: controller.offer.value.isRedeemed
                                  ? Colors.yellow
                                  : AppColors
                                        .primary, // Using Color(0xFF5B4FE9)
                              // ... rest of your styling
                            ),
                            child: Text(
                              controller.offer.value.isRedeemed
                                  ? 'Already Redeemed Offer'
                                  : 'Redeem Offer',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        flex: 1, // Close button takes 1/4 width
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: Text('Close'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: BorderSide(color: Colors.yellow),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(0, 48.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Dining badge
          Positioned(
            top: 49.h,
            right: 22.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Dining",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showQrRedemptionDialog(BuildContext context, QrOffer offer) {
    Get.dialog(
      QrRedemptionAlertDialog(qrOffer: offer, onClose: () => Get.back()),
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
    Key? key,
    required this.imageUrl,
    required this.height,
    this.width,
    required this.fit,
    required this.timeoutSeconds,
    required this.fallbackImage,
  }) : super(key: key);

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
    // Start a timer to show fallback after timeout
    Future.delayed(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && !_imageLoaded) {
        setState(() {
          _showFallback = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showFallback) {
      // Show fallback image after timeout
      return Container(
        height: widget.height,
        width: widget.width,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            widget.fallbackImage,
            height: 100.h,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Image.network(
      widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image loaded successfully
          _imageLoaded = true;
          return child;
        }
        // Show loading indicator while loading
        return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Show fallback on error
        return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.white,
          child: Center(
            child: Image.asset(
              widget.fallbackImage,
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
