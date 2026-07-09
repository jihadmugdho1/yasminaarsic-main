import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/home/controller/home_controller.dart';
import 'package:vendora/features/home/controller/pop_up_controller.dart';
import 'package:vendora/features/home/models/pop_up_offer_model.dart';
import 'package:vendora/features/home/widgets/categoy_item.dart';
import 'package:vendora/features/home/widgets/category_skeleton_loader.dart';
import 'package:vendora/features/home/widgets/offer_card.dart';
import 'package:vendora/features/home/widgets/offer_card_shimmer.dart';
import 'package:vendora/features/home/vendor_details/screen/vendor_details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());
  final popupController = Get.put(PopupOfferController());

  @override
  Widget build(BuildContext context) {
    final locale = Get.find<LocalizationController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    color: AppColors.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Image.asset(
                            ImagePath.appLogo,
                            height: 60.h,
                            width: 130.w,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  locale.get('discover_offers'),
                                  style: primaryFontStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Obx(
                                () => Text(
                                  locale.get(
                                    'browse_amazing_BOGO_deals_from_top_vendors',
                                  ),
                                  style: secondaryFontStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    lineHeight: 10,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                height: 40.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: controller.onSearchChanged,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20.sp,
                                      color: AppColors.textPrimary,
                                    ),
                                    suffixIcon: Obx(() {
                                      if (controller.showSearchResults.value) {
                                        return IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            size: 20.sp,
                                            color: AppColors.textPrimary,
                                          ),
                                          onPressed: controller.clearSearch,
                                        );
                                      }
                                      return SizedBox.shrink();
                                    }),
                                    hintText: locale.get('search_vendors'),
                                    hintStyle: tertiaryFontStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Results
                  Obx(() {
                    if (controller.showSearchResults.value) {
                      return Container(
                        width: double.infinity,
                        color: AppColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Obx(
                                () => Text(
                                  controller.isSearching.value
                                      ? locale.get('searching')
                                      : '${locale.get('search_results')} (${controller.searchResults.length})',
                                  style: primaryFontStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (controller.isSearching.value)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.3,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            else if (controller.searchResults.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Text(
                                  locale.get('no_vendors_found'),
                                  style: secondaryFontStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              )
                            else
                              Container(
                                constraints: BoxConstraints(maxHeight: 200.h),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final vendor =
                                        controller.searchResults[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                        child: Icon(
                                          Icons.store,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        vendor.vendorProfile?.businessName ??
                                            vendor.name,
                                        style: primaryFontStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        vendor.vendorProfile?.businessName ??
                                            vendor.vendorProfile?.city ??
                                            'Vendor',
                                        style: secondaryFontStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      onTap: () =>
                                          controller.onSearchVendorTap(vendor),
                                    );
                                  },
                                ),
                              ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
                  // Carousel
                  Obx(() {
                    if (controller.isLoadingSlider.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      );
                    }

                    final urls = controller.sliderImageUrls;
                    if (urls.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 200.h,
                                viewportFraction: 1.0,
                                enlargeCenterPage: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration: const Duration(
                                  milliseconds: 600,
                                ),
                                onPageChanged: (index, reason) {
                                  controller.setCurrentIndex(index);
                                },
                              ),
                              items: urls.map((url) {
                                return Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                    );
                                  },
                                );
                              }).toList(),
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
                                  children: urls.asMap().entries.map((entry) {
                                    return Container(
                                      width: 12.w,
                                      height: 12.h,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            controller.currentIndex.value ==
                                                entry.key
                                            ? AppColors.primary
                                            : Colors.white.withValues(
                                                alpha: 0.7,
                                              ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 16.h),
                  // Categories grid
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Obx(() {
                      if (controller.isLoadingCategories.value) {
                        return CategorySkeletonLoader(
                          itemCount: 6,
                          crossAxisCount: 3,
                        );
                      }

                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          mainAxisSpacing: 18.h,
                          crossAxisSpacing: 18.w,
                        ),
                        itemBuilder: (context, index) {
                          final cat = controller.categories[index];
                          return Obx(() {
                            final isSelected =
                                controller.selectedCategory.value == index;
                            return CategoryGridItem(
                              label: cat.name,
                              icon: cat.icon,
                              isSelected: isSelected,
                              onTap: () {
                                controller.setSelectedCategory(index);
                              },
                            );
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 32.h),
                  // New offers
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Obx(
                      () => Text(
                        locale.get('new_offers_section'),
                        style: primaryFontStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff101728),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.isLoadingOffers.value) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(5, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 18.w : 12.w,
                              ),
                              child: const OfferCardShimmer(),
                            );
                          }),
                        ),
                      );
                    }
                    if (controller.newOffers.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: SizedBox(
                          height: 180.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(height: 40.h, IconPath.corruptedfile),
                              SizedBox(width: 10.w),
                              Text(
                                'No new offers available',
                                style: primaryFontStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.newOffers.map((offer) {
                          int index = controller.newOffers.indexOf(offer);

                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 18.w : 10.w,
                            ),
                            child: OfferCard(
                              imagePath: offer.imagePath,
                              titleKey: offer.title,
                              locationKey: offer.location,
                              categoryLabelKey: offer.categoryLabel,
                              isNetworkImage: offer.isNetworkImage,
                              offerData: offer.offerApiData,
                              onTap: (userId) {
                                Get.to(
                                  () => VendorDetailsScreen(),
                                  arguments: userId,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                  // Load more new offers
                  // Obx(() {
                  //   if (controller.hasMoreNewOffers.value &&
                  //       controller.selectedCategory.value != 0) {
                  //     return Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 18.w),
                  //       child: ElevatedButton(
                  //         onPressed: controller.isLoadingMoreNew.value
                  //             ? null
                  //             : controller.loadMoreNewOffers,
                  //         child: controller.isLoadingMoreNew.value
                  //             ? CircularProgressIndicator()
                  //             : Text(locale.get('load_more')),
                  //       ),
                  //     );
                  //   }
                  //   return SizedBox.shrink();
                  // }),
                  SizedBox(height: 32.h),
                  // Trending offers
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Obx(
                      () => Text(
                        locale.get('trending_offers'),
                        style: primaryFontStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff101728),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.isLoadingOffers.value) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(5, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? 18.w : 12.w,
                              ),
                              child: const OfferCardShimmer(),
                            );
                          }),
                        ),
                      );
                    }
                    if (controller.trendingOffers.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: SizedBox(
                          height: 180.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(height: 40.h, IconPath.corruptedfile),
                              SizedBox(width: 10.w),
                              Text(
                                'No trending offers available',
                                style: primaryFontStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.trendingOffers.map((offer) {
                          int index = controller.trendingOffers.indexOf(offer);
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 18.w : 12.w,
                            ),
                            child: OfferCard(
                              imagePath: offer.imagePath,
                              titleKey: offer.title,
                              locationKey: offer.location,
                              categoryLabelKey: offer.categoryLabel,
                              isNetworkImage: offer.isNetworkImage,
                              offerData: offer.offerApiData,
                              onTap: (userId) {
                                Get.to(
                                  () => VendorDetailsScreen(),
                                  arguments: userId,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  // Load more trending offers
                  SizedBox(height: 16.h),
                  Builder(
                    builder: (context) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        popupController.showPopup(
                          PopupOfferModel(
                            title: locale.get('free_redemptions_title'),
                            description: "",
                            actionLabel: locale.get('sign_up_action'),
                            trialDuration: locale.get('free_trial_duration'),
                            iconPath: "", // Not used with built-in icon here
                          ),
                        );
                      });
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // // Popup positioned at the bottom
            // Positioned(
            //   bottom: 20,
            //   left: 0,
            //   right: 0,
            //   child: Builder(
            //     builder: (context) {
            //       return PopupOfferWidget(controller: popupController);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
