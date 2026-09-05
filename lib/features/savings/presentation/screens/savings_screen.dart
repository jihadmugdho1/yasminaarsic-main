// lib/features/savings/presentation/screens/savings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/savings/controller/savings_controller.dart';
import 'package:vendora/features/savings/presentation/widgets/monthly_savings_card.dart';
import 'package:vendora/features/savings/presentation/widgets/offer_card.dart';
import 'package:vendora/features/savings/presentation/widgets/savings_summary_card.dart';
import 'package:vendora/features/subscription/presentation/widgets/subscription_card.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  Widget _buildOfferCardShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: 150.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 14.h,
                        width: 100.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 12.h,
                        width: 80.w,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Container(
                            height: 12.h,
                            width: 60.w,
                            color: Colors.grey[300],
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            height: 12.h,
                            width: 40.w,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsSummaryCardShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      height: 16.h,
                      width: 120.w,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 4.h),
                    // Amount
                    Container(
                      height: 20.h,
                      width: 80.w,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 4.h),
                    // Description
                    Container(
                      height: 16.h,
                      width: 150.w,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySavingsCardShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              // Icon Circle
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Container(
                      height: 16.h,
                      width: 100.w,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 4.h),
                    // Amount
                    Container(
                      height: 20.h,
                      width: 70.w,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 4.h),
                    // Description
                    Container(
                      height: 16.h,
                      width: 120.w,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavingsController());
    final locale = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refreshSavingsData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SubscriptionCard(
                    title: locale.get('your_savings'),
                    subtitle: locale.get('track_savings'),
                    backgroundColor: const Color(0xFF6C63FE),
                    titleColor: Colors.white,
                    subtitleColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),

                // Error message banner if any
                Obx(() {
                  if (controller.isError.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value.isNotEmpty
                                    ? controller.errorMessage.value
                                    : 'Failed to load savings data',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => controller.fetchSavingsData(),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildSavingsSummaryCardShimmer();
                    }
                    final data = controller.savingsData.value;
                    return SavingsSummaryCard(
                      title: locale.get('total_savings'),
                      savingsAmount: data.totalSavings,
                      description: locale
                          .get('from_redeemed_offers')
                          .replaceFirst(
                            '{count}',
                            data.redeemedOffersCount.toString(),
                          ),
                      icon: Icons.balance,
                      backgroundColor: const Color(0xFFFFF6D5),
                      iconBackgroundColor: const Color(0xFFFFD700),
                      descriptionColor: const Color(0xFFF4DB35),
                      onTap: controller.onSavingsSummaryTap,
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildMonthlySavingsCardShimmer();
                    }
                    final data = controller.savingsData.value;
                    return MonthlySavingsCard(
                      title: locale.get('this_month'),
                      amount: data.monthlySavings,
                      description: locale.get('keep_saving'),
                      icon: Icons.trending_up,
                      backgroundColor: const Color(0xFFF0F5FF),
                      iconBackgroundColor: const Color(0xFF6C5CE7),
                      descriptionColor: const Color(0xFF6C63FE),
                      onTap: controller.onMonthlySavingsTap,
                    );
                  }),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => Text(
                      locale.get('redeemed_offers'),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                        color: const Color(0xFF101828),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    // Show shimmer effect while loading
                    return Column(
                      children: List.generate(
                        3,
                        (index) => _buildOfferCardShimmer(),
                      ),
                    );
                  }

                  final offers = controller.savingsData.value.redeemedOffers;

                  if (offers.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 32.h,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 64.h,
                              width: 64.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Iconsax.empty_wallet,
                                size: 30.sp,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No redeemed offers yet',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Redeem offers to start tracking your savings here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontFamily: 'Inter',
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (int i = 0; i < offers.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          child: Obx(
                            () => OfferCard(
                              title: offers[i].title,
                              subtitle: offers[i].merchant,
                              priceBadge: offers[i].savingsBadge,
                              date: offers[i].redeemedDate,
                              location: offers[i].location,
                              imageAssetPath: offers[i].imagePath,
                              isSelected:
                                  controller.selectedOfferIndex.value ==
                                  i, // ✅ Selection state
                              onTap: () => controller.onOfferTap(i),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
