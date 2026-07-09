// lib/features/subscription/presentation/screens/subscription_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/subscription/controller/subscription_controller.dart';
import 'package:vendora/features/subscription/presentation/widgets/subscription_card.dart';
import 'package:vendora/features/subscription/presentation/widgets/subscription_card_shimmer.dart';
import 'package:vendora/features/subscription/presentation/widgets/subscription_details_card.dart';
import 'package:vendora/features/subscription/presentation/widgets/subscription_status_card.dart';
import 'package:vendora/features/subscription/presentation/screens/plan_details_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final locale = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionCard(
                  title: locale.get('subscription'),
                  subtitle: locale.get('manage_subscription'),
                  backgroundColor: const Color(0xFF6C63FE),
                  titleColor: Colors.white,
                  subtitleColor: Colors.white,
                ),
                SizedBox(height: 16.h),
                // ✅ All current Subscription Plans Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Current Plans',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: const Color(0xFF101828),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(() {
                  if (controller.isLoadingCurrentSubscription.value) {
                    return const SubscriptionCurrentPlanShimmer();
                  }

                  // if (controller.currentSubscriptionError.value.isNotEmpty) {
                  //   return Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //     child: Container(
                  //       padding: EdgeInsets.all(12.w),
                  //       decoration: BoxDecoration(
                  //         color: Colors.red.shade50,
                  //         borderRadius: BorderRadius.circular(8.r),
                  //         border: Border.all(color: Colors.red.shade200),
                  //       ),
                  //       child: Text(
                  //         controller.currentSubscriptionError.value,
                  //         style: TextStyle(
                  //           fontSize: 14.sp,
                  //           color: Colors.red.shade700,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }

                  final sub = controller.currentSubscription.value;
                  if (sub == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Iconsax.card_slash,
                                  size: 40.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                locale.get('No active subscriptions'),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                locale.get(
                                  'Your subscriptions will appear here once activated.',
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey[500],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  final plan = sub.plan;
                  final badgeColor = sub.status.toUpperCase() == 'ACTIVE'
                      ? const Color(0xFFF4DB35)
                      : Colors.grey;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SubscriptionDetailsCard(
                      planTitle: plan?.name ?? sub.status,
                      planSubtitle: plan != null
                          ? '${plan.durationInDays} Days Plan'
                          : '',
                      trailingBadgeText: sub.status,
                      trailingBadgeColor: badgeColor,
                      startDate: sub.startDate,
                      renewalDate: sub.endDate,
                      planDescription: plan?.name ?? '',
                      pricePerYear: plan != null
                          ? '${plan.currency} ${plan.currentPriceDisplay.isNotEmpty ? plan.currentPriceDisplay : plan.price}'
                          : sub.price,
                      isAutoRenewEnabled: false,
                      autoRenewMessage: '',
                      showCancelButton: false,
                      updatePaymentButtonText: locale.get(
                        'update_payment_method',
                      ),
                      cancelSubscriptionButtonText: locale.get(
                        'cancel_subscription',
                      ),
                      onUpdatePaymentPressed: controller.onUpdatePaymentPressed,
                      onCancelSubscriptionPressed:
                          controller.onCancelSubscriptionPressed,
                      onCardTap: controller.onCardTap,
                    ),
                  );
                }),
                SizedBox(height: 16.h),
                // ✅ All Subscription Plans Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'Available Plans',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      color: const Color(0xFF101828),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // ✅ Display subscription plans
                Obx(() {
                  if (controller.isLoadingPlans.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(child: SubscriptionShimmer()),
                    );
                  }

                  if (controller.plansErrorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          controller.plansErrorMessage.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    );
                  }

                  if (controller.subscriptionPlans.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.h,
                          horizontal: 24.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.card_slash,
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              'No subscription plans available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(
                      controller.subscriptionPlans.length,
                      (index) {
                        final plan = controller.subscriptionPlans[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: SubscriptionDetailsCard(
                              planTitle: plan.name,
                              planSubtitle: '${plan.durationInDays} Days Plan',
                              trailingBadgeText: plan.isActive
                                  ? 'Active'
                                  : 'Inactive',
                              trailingBadgeColor: plan.isActive
                                  ? const Color(0xFFF4DB35)
                                  : Colors.grey,
                              planDescription: plan.description,
                              pricePerYear: plan.currentPriceDisplay.isNotEmpty
                                  ? plan.currentPriceDisplay
                                  : '${plan.currency} ${plan.price}',
                              updatePaymentButtonText: 'Select Plan',
                              cancelSubscriptionButtonText: 'View Details',
                              onUpdatePaymentPressed: () {
                                Get.to(
                                  () => PlanDetailsScreen(plan: plan),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              onCancelSubscriptionPressed: () {
                                Get.to(
                                  () => PlanDetailsScreen(plan: plan),
                                  transition: Transition.rightToLeft,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => Text(
                      locale.get('subscription_history'),
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
                  if (controller.isLoadingHistory.value) {
                    return const SubscriptionHistoryShimmer();
                  }

                  if (controller.historyErrorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          controller.historyErrorMessage.value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    );
                  }

                  if (controller.subscriptionHistory.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'No subscription history',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(
                      controller.subscriptionHistory.length,
                      (index) {
                        final item = controller.subscriptionHistory[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                              () => SubscriptionStatusCard(
                                price: item.priceAsDouble,
                                startDate: item.startDate,
                                endDate: item.endDate,
                                paidDate: item.startDate,
                                statusText: item.statusText,
                                statusColor: item.statusColor,
                                isSelected:
                                    controller.selectedHistoryIndex.value ==
                                    index,
                                onTap: () => controller.onHistoryItemTap(index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
