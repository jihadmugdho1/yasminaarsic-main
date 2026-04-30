import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/core/utils/constants/image_path.dart';
import 'package:yasminaarsic/features/home/vendor_details/controllers/vendor_details_controller.dart';

class VendorDetailsCard extends StatelessWidget {
  final VendorDetailsController controller = Get.find();

  /// Build vendor image with fallback to default image
  Widget _buildVendorImage() {
    final imageUrl = controller.restaurant.value.imageUrl;

    // Check if URL is empty or null
    if (imageUrl.isEmpty) {
      return Image.asset(
        ImagePath.appLogo,
        width: 60.w,
        height: 50.h,
        fit: BoxFit.cover,
      );
    }

    // Try to load network image with timeout and fallback
    return _NetworkImageWithTimeout(
      imageUrl: imageUrl,
      width: 63.w,
      height: 63.h,
      fit: BoxFit.cover,
      timeoutSeconds: 5,
      fallbackImage: ImagePath.appLogo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Obx(
      () => Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildVendorImage(),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.restaurant.value.name,
                          style: primaryFontStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.h,
                            vertical: 4.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.restaurant.value.category,
                            style: primaryFontStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                controller.restaurant.value.description,
                style: primaryFontStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  lineHeight: 10.sp,
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18.sp),
                  SizedBox(width: 8.w),
                  Obx(
                    () => Text(
                      locale.get('vendor_location_label'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      controller.restaurant.value.location,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryFontStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.phone, size: 18.sp),
                  SizedBox(width: 8.w),
                  Obx(
                    () => Text(
                      locale.get('vendor_phone_label'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      controller.restaurant.value.phone,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryFontStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 18.sp),
                  SizedBox(width: 8.w),
                  Obx(
                    () => Text(
                      locale.get('vendor_email_label'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      controller.restaurant.value.email,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryFontStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              // Row(
              //   children: [
              //     Icon(Icons.language, size: 18.sp),
              //     SizedBox(width: 8.w),
              //     Obx(
              //       () => Text(
              //         locale.get('vendor_website_label'),
              //         style: TextStyle(
              //           fontSize: 12.sp,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 4.w),
              //     Expanded(
              //       child: Text(
              //         controller.restaurant.value.website,
              //         overflow: TextOverflow.ellipsis,
              //         style: secondaryFontStyle(
              //           fontSize: 12.sp,
              //           fontWeight: FontWeight.w400,
              //           color: AppColors.textSecondary,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 8.h),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Icon(Icons.access_time, size: 18.sp),
              //     SizedBox(width: 8.w),
              //     Obx(
              //       () => Text(
              //         locale.get('vendor_hours_label'),
              //         style: TextStyle(
              //           fontSize: 12.sp,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 4.w),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: controller.restaurant.value.hours.entries
              //             .map(
              //               (e) => Text(
              //                 '${e.key}: ${e.value}',
              //                 style: secondaryFontStyle(
              //                   fontSize: 12.sp,
              //                   fontWeight: FontWeight.w400,
              //                   color: AppColors.textSecondary,
              //                   lineHeight: 11,
              //                 ),
              //               ),
              //             )
              //             .toList(),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkImageWithTimeout extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final int timeoutSeconds;
  final String fallbackImage;

  const _NetworkImageWithTimeout({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
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

  @override
  void initState() {
    super.initState();
    // Start a timer to show fallback after timeout
    Future.delayed(Duration(seconds: widget.timeoutSeconds), () {
      if (mounted && !_showFallback) {
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
      return Image.asset(
        widget.fallbackImage,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image loaded successfully
          return child;
        }
        // Show loading indicator while loading
        return Container(
          width: widget.width,
          height: widget.height,
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
        return Image.asset(
          widget.fallbackImage,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
