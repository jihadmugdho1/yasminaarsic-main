import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/home/vendor_details/controllers/vendor_details_controller.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/offer_card.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/alert_dialogs/offer_dialog.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/alert_dialogs/offer_dialog_shimmer.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/vendor_details_card.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/vendor_details_card_shimmer.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/vendor_offer_card_shimmer.dart';
import 'package:yasminaarsic/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:yasminaarsic/features/profile/controller/profile_controller.dart';

class VendorDetailsScreen extends StatelessWidget {
  VendorDetailsScreen({super.key});

  final VendorDetailsController controller = Get.put(VendorDetailsController());
  late final CarouselSliderController carouselController =
      CarouselSliderController();
  final profileController = Get.put(ProfileController());
  void _showSubscribeDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'SubscribeDialog',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FE).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      size: 36.sp,
                      color: const Color(0xFF6C63FE),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Subscription Required',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: const Color(0xFF101828),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please subscribe to a plan to access this offer.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                      fontFamily: 'Inter',
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.until((route) => route.isFirst);
                        Get.find<BottomNavController>().changeTab(1);
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: const Color(0xFF6C63FE),
                        minimumSize: Size(0, 44.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Go to Subscription',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            locale.get('back_to_vendors'),
            textAlign: TextAlign.center,
            style: primaryFontStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        toolbarHeight: kToolbarHeight + 20,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshVendorDetails();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Carousel Slider with rounded borders and navigation buttons
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Stack(
                  children: [
                    Obx(() {
                      if (controller.isLoading.value) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: 180.h,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
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
                    Positioned(
                      left: 10.w,
                      top: 80.h,
                      child: Container(
                        height: 25.h,
                        width: 25.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            int prevIndex =
                                (controller.currentIndex.value - 1) %
                                controller.carouselItems.length;
                            if (prevIndex < 0) {
                              prevIndex = controller.carouselItems.length - 1;
                            }
                            controller.setCurrentIndex(prevIndex);
                            carouselController.animateToPage(
                              prevIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          iconSize: 18.sp,
                          padding: EdgeInsets.all(5),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 80.h,
                      child: Container(
                        height: 25.h,
                        width: 25.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            int nextIndex =
                                (controller.currentIndex.value + 1) %
                                controller.carouselItems.length;
                            controller.setCurrentIndex(nextIndex);
                            carouselController.animateToPage(
                              nextIndex,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          iconSize: 18.sp,
                          padding: EdgeInsets.all(5),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 14.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.carouselItems
                                .asMap()
                                .entries
                                .map((entry) {
                                  return Container(
                                    width: 12.w,
                                    height: 12.h,
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.currentIndex.value ==
                                              entry.key
                                          ? AppColors.primary
                                          : Colors.white.withOpacity(0.7),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Obx(
                  () => controller.isLoading.value
                      ? const VendorDetailsCardShimmer()
                      : VendorDetailsCard(),
                ),
              ),

              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(
                  () => Text(
                    controller.isLoading.value
                        ? '${locale.get('available_offers')} (0)'
                        : '${locale.get('available_offers')} (${controller.offers.length})',
                    textAlign: TextAlign.start,
                    style: primaryFontStyle(
                      color: const Color(0xFF101727),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: const VendorOfferCardShimmer(),
                        );
                      },
                    );
                  }

                  if (controller.offers.isEmpty) {
                    return Center(
                      child: Text(
                        'No offers available',
                        style: primaryFontStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.offers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: OfferCard(
                          offer: controller.offers[index],
                          onTap: () async {
                            if (!profileController.isSubscribed.value) {
                              AppLoggerHelper.debug("User subscribe value : ${profileController.isSubscribed.value}");
                              _showSubscribeDialog(context);
                              return;
                            }
                            AppLoggerHelper.debug("subscription value : ${profileController.isSubscribed.value}");

                            final offerId = controller.offers[index].id;
                            if (offerId != null && offerId.isNotEmpty) {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierLabel: 'LoadingOfferDialog',
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 200),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: const OfferDialogShimmer(),
                                        ),
                                      );
                                    },
                                transitionBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                              );

                              await controller.fetchOfferDetails(offerId);

                              if (!context.mounted) return;
                              Navigator.of(context).pop();

                              if (!context.mounted) return;
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: 'OfferDialog',
                                barrierColor: Colors.transparent.withOpacity(
                                  0.5,
                                ),
                                transitionDuration: Duration(milliseconds: 200),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return Center(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: OfferDialog(
                                            offer: controller.offers[index],
                                            offerIndex: index,
                                            offerDetail: controller
                                                .selectedOfferDetail
                                                .value,
                                          ),
                                        ),
                                      );
                                    },
                                transitionBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
