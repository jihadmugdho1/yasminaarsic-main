// lib/features/subscription/presentation/screens/subscription_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/core/utils/constants/colors.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/subscription/controller/subscription_controller.dart';
import 'package:yasminaarsic/features/subscription/presentation/widgets/subscription_card.dart';
import 'package:yasminaarsic/features/subscription/presentation/widgets/subscription_card_shimmer.dart';
import 'package:yasminaarsic/features/subscription/presentation/widgets/subscription_details_card.dart';
import 'package:yasminaarsic/features/subscription/presentation/widgets/subscription_status_card.dart';
import 'package:yasminaarsic/features/subscription/presentation/screens/plan_details_screen.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  final data = controller.subscriptionData.value;
                  return SubscriptionDetailsCard(
                    planTitle: data.planTitle,
                    planSubtitle: data.planSubtitle,
                    trailingBadgeText: data.trailingBadgeText,
                    trailingBadgeColor: data.trailingBadgeColor,
                    startDate: data.startDate,
                    renewalDate: data.renewalDate,
                    planDescription: data.planDescription,
                    pricePerYear: data.pricePerYear,
                    isAutoRenewEnabled: data.isAutoRenewEnabled,
                    autoRenewMessage: data.autoRenewMessage,
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
                  );
                }),
              ),
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
                    child: Center(
                      child: SubscriptionShimmer(),
                    ),
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
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Center(
                      child: Text(
                        'No subscription plans available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
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
                            trailingBadgeText: plan.isActive ? 'Active' : 'Inactive',
                            trailingBadgeColor: plan.isActive ? const Color(0xFFF4DB35) : Colors.grey,
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
              ...List.generate(
                controller.subscriptionData.value.history.length,
                (index) {
                  final item = controller.subscriptionData.value.history[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(
                        // ✅ Wrap in Obx to react to selection change
                        () => SubscriptionStatusCard(
                          price: item.price,
                          startDate: item.startDate,
                          endDate: item.endDate,
                          paidDate: item.paidDate,
                          statusText: item.statusText,
                          statusColor: item.statusColor,
                          isSelected:
                              controller.selectedHistoryIndex.value ==
                              index, // ✅
                          onTap: () => controller.onHistoryItemTap(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
