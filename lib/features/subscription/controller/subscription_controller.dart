// lib/features/subscription/controller/subscription_controller.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yasminaarsic/core/core.dart';
import 'package:yasminaarsic/core/localization/localization_controller.dart';
import 'package:yasminaarsic/features/subscription/data/checkout_response_model.dart';
import 'package:yasminaarsic/features/subscription/data/subscription_model.dart';
import 'package:yasminaarsic/features/subscription/data/subscription_plan_model.dart';
import 'package:yasminaarsic/features/subscription/data/subscription_service.dart';
import 'package:yasminaarsic/features/subscription/presentation/screens/payment_webview_screen.dart';

class SubscriptionController extends GetxController {
  late final subscriptionData = _initializeSubscriptionData().obs;
  var selectedHistoryIndex = (-1).obs; // ✅ Track tapped index

  // ✅ Subscription Plans
  final subscriptionPlans = <SubscriptionPlanModel>[].obs;
  final isLoadingPlans = false.obs;
  final plansErrorMessage = ''.obs;

  final SubscriptionService _subscriptionService = SubscriptionService();

  // ✅ Plan Details / Checkout state (used by PlanDetailsScreen)
  final selectedPlan = Rxn<SubscriptionPlanModel>();
  final TextEditingController promoCodeController = TextEditingController();
  final isPromoApplied = false.obs;
  final discountAmount = 0.0.obs;
  final isCheckingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen for language changes and update subscription data
    final locale = Get.find<LocalizationController>();
    ever(locale.currentLanguage, (_) {
      subscriptionData.value = _initializeSubscriptionData();
    });

    // ✅ Fetch subscription plans on init
    fetchSubscriptionPlans();
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }

  // ✅ Fetch subscription plans from API
  Future<void> fetchSubscriptionPlans() async {
    isLoadingPlans.value = true;
    plansErrorMessage.value = '';

    try {
      final response = await _subscriptionService.getSubscriptionPlans();

      if (response.isSuccess && response.responseData != null) {
        final plans = response.responseData as List<SubscriptionPlanModel>;
        subscriptionPlans.assignAll(plans);
         // 🔥 DEBUG RAW RESPONSE
      AppLoggerHelper.debug(
        "RAW API RESPONSE: ${jsonEncode(response.responseData)}",
      );
      
      } else {
        plansErrorMessage.value = response.errorMessage;
      }
    } catch (e) {
      plansErrorMessage.value = 'Error loading subscription plans: $e';
    } finally {
      isLoadingPlans.value = false;
    }
  }

  void openPlanDetails(SubscriptionPlanModel plan) {
    selectedPlan.value = plan;
    promoCodeController.clear();
    isPromoApplied.value = false;
    discountAmount.value = 0.0;
    isCheckingOut.value = false;
  }

  void closePlanDetails() {
    selectedPlan.value = null;
    promoCodeController.clear();
    isPromoApplied.value = false;
    discountAmount.value = 0.0;
    isCheckingOut.value = false;
  }

  double get basePrice {
    final plan = selectedPlan.value;
    if (plan == null) return 0;
    return double.tryParse(plan.price) ?? 0;
  }

  double get finalPrice {
    final price = basePrice;
    return isPromoApplied.value ? (price - discountAmount.value) : price;
  }

  void applyPromoCode() {
    final plan = selectedPlan.value;
    if (plan == null) return;

    final promoCode = promoCodeController.text.trim();
    if (promoCode.isEmpty) {
      Get.snackbar('Promo Code', 'Please enter a promo code');
      return;
    }

    isPromoApplied.value = true;
    discountAmount.value = (double.tryParse(plan.price) ?? 0) * 0.1;

    Get.snackbar(
      'Promo Code',
      'Promo code applied! Discount: \$${discountAmount.value.toStringAsFixed(2)}',
    );
  }

  Future<void> checkoutSelectedPlan() async {
    final plan = selectedPlan.value;
    if (plan == null) return;
    if (isCheckingOut.value) return;

    isCheckingOut.value = true;
    try {
      final idempotencyKey = const Uuid().v4();
      final checkoutResult = await _subscriptionService.checkout(
        subscriptionPlanId: plan.id,
        idempotencyKey: idempotencyKey,
        promoCode: isPromoApplied.value ? promoCodeController.text.trim() : null,
      );

      if (!checkoutResult.isSuccess || checkoutResult.responseData == null) {
        Get.snackbar('Checkout Failed', checkoutResult.errorMessage);
        return;
      }

      final paymentId =
          (checkoutResult.responseData as CheckoutResponse).data.paymentId;

      // Debug: fetch HTML once and print in logs (doesn't block navigation)
      _subscriptionService.getPaymentFormHtml(paymentId);

      Get.to(
        () => PaymentWebViewScreen(
          paymentId: paymentId,
          authToken: StorageService.token,
        ),
      );
    } catch (e, st) {
      AppLoggerHelper.error('Checkout error', e, st);
      Get.snackbar('Checkout Failed', e.toString());
    } finally {
      isCheckingOut.value = false;
    }
  }

  SubscriptionModel _initializeSubscriptionData() {
    final locale = Get.find<LocalizationController>();
    return SubscriptionModel(
      planTitle: locale.get('current_plan'),
      planSubtitle: locale.get('annual_subscription'),
      trailingBadgeText: locale.get('active_status'),
      trailingBadgeColor: const Color(0xFFF4DB35),
      startDate: DateTime(2024, 6, 15),
      renewalDate: DateTime(2025, 6, 15),
      planDescription: locale.get('subscription_plan_desc'),
      pricePerYear: locale.get('price_per_year'),
      isAutoRenewEnabled: true,
      autoRenewMessage: locale.get('auto_renew_msg'),
      history: [
        SubscriptionHistoryItem(
          price: 99.99,
          startDate: DateTime(2025, 10, 25),
          endDate: DateTime(2026, 10, 25),
          paidDate: DateTime(2025, 10, 25),
          statusText: locale.get('active_status'),
          statusColor: const Color(0xFFF4DB35),
        ),
        SubscriptionHistoryItem(
          price: 99.99,
          startDate: DateTime(2025, 10, 25),
          endDate: DateTime(2026, 10, 25),
          paidDate: DateTime(2025, 10, 25),
          statusText: locale.get('completed_status'),
          statusColor: Colors.green,
        ),
      ],
    );
  }

  void onUpdatePaymentPressed() {
    debugPrint('Update payment pressed');
  }

  void onCancelSubscriptionPressed() {
    debugPrint('Cancel subscription pressed');
  }

  void onCardTap() {
    debugPrint('Card tapped');
  }

  void onHistoryItemTap(int index) {
    // Toggle selection: tap same → deselect
    selectedHistoryIndex.value = selectedHistoryIndex.value == index
        ? -1
        : index;
  }
}
