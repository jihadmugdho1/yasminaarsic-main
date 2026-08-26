import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/features/home/vendor_details/controllers/vendor_details_controller.dart';
import 'package:vendora/features/home/vendor_details/widgets/vendor_carousel_shimmer.dart';

class VendorCarouselSlider extends StatelessWidget {
  final VendorDetailsController controller;
  final CarouselSliderController carouselController;

  const VendorCarouselSlider({
    super.key,
    required this.controller,
    required this.carouselController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const VendorCarouselShimmer();
            }
            return CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                height: 180.h,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  controller.setCurrentIndex(index);
                },
              ),
              items: controller.carouselItems.isEmpty
                  ? [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/noSummaryImage.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey[600],
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  : controller.carouselItems
                      .map(
                        (item) => ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: item.imagePath.startsWith('http')
                              ? Image.network(
                                  item.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey[600],
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  item.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey[600],
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )
                      .toList(),
            );
          }),
          Obx(() {
            if (controller.isLoading.value ||
                controller.carouselItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return Positioned(
              bottom: 14.h,
              left: 0,
              right: 0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.carouselItems
                      .asMap()
                      .entries
                      .map((entry) {
                        return Container(
                          width: 12.w,
                          height: 12.h,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentIndex.value == entry.key
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.7),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
