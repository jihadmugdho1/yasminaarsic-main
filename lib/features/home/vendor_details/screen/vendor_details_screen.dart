import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/home/vendor_details/controllers/vendor_details_controller.dart';
import 'package:vendora/features/home/vendor_details/widgets/alert_dialogs/subscribe_required_dialog.dart';
import 'package:vendora/features/home/vendor_details/widgets/offer_card.dart';
import 'package:vendora/features/home/vendor_details/widgets/alert_dialogs/offer_dialog.dart';
import 'package:vendora/features/home/vendor_details/widgets/alert_dialogs/offer_dialog_shimmer.dart';
import 'package:vendora/features/home/vendor_details/widgets/vendor_carousel_slider.dart';
import 'package:vendora/features/home/vendor_details/widgets/vendor_details_card.dart';
import 'package:vendora/features/home/vendor_details/widgets/vendor_details_card_shimmer.dart';
import 'package:vendora/features/home/vendor_details/widgets/vendor_offer_card_shimmer.dart';
import 'package:vendora/features/profile/controller/profile_controller.dart';

class VendorDetailsScreen extends StatelessWidget {
  final String vendorname = Get.arguments;
  VendorDetailsScreen({super.key});

  final VendorDetailsController controller = Get.put(VendorDetailsController());
  late final CarouselSliderController carouselController =
      CarouselSliderController();
  final profileController = Get.put(ProfileController());

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

              // Vendor Image Carousel Slider
              VendorCarouselSlider(
                controller: controller,
                carouselController: carouselController,
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
                  () => controller.isLoading.value
                      ? const SizedBox.shrink()
                      : Text(
                          '${locale.get('available_offers')} (${controller.offers.length})',
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
                      physics: const NeverScrollableScrollPhysics(),
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
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.offers.length,
                    itemBuilder: (context, index) {
                      return OfferCard(
                        offer: controller.offers[index],
                        onTap: () async {
                          if (profileController.trialDaysRemaining.value == 0) {
                            AppLoggerHelper.debug(
                              "subscription value : ${profileController.isSubscribed.value}, trialDaysRemaining: ${profileController.trialDaysRemaining.value}",
                            );

                            AppLoggerHelper.debug(
                              " trail value :${profileController.trialDaysRemaining.value}",
                            );
                            SubscribeRequiredDialog.show(context);
                            return;
                          }

                          AppLoggerHelper.debug(
                            "subscription value : ${profileController.isSubscribed.value}",
                          );

                          final offer = controller.offers[index];
                          final offerId = offer.id;

                          AppLoggerHelper.debug(
                            'OfferCard tapped - index: $index, offerId: $offerId, title: ${offer.title}',
                          );

                          if (offerId == null || offerId.isEmpty) {
                            AppLoggerHelper.error('OfferCard tapped but offerId is null or empty');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Offer ID is not available'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            barrierLabel: 'LoadingOfferDialog',
                            barrierColor: Colors.black.withOpacity(0.5),
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const Center(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: OfferDialogShimmer(),
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

                          final offerDetail = controller.selectedOfferDetail.value;
                          if (offerDetail == null) {
                            AppLoggerHelper.error(
                              'Failed to fetch offer details for offer ID: $offerId',
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to load offer details. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          if (!context.mounted) return;
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: 'OfferDialog',
                            barrierColor: Colors.transparent.withOpacity(0.5),
                            transitionDuration: const Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Center(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: OfferDialog(
                                    offer: controller.offers[index],
                                    offerIndex: index,
                                    offerDetail: offerDetail,
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
                        },
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
