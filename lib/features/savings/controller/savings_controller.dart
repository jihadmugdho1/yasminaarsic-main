// lib/features/savings/controller/savings_controller.dart

import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/savings/data/models/savings_model.dart';
import 'package:vendora/features/savings/data/models/savings_offer_model.dart';
import 'package:vendora/features/savings/data/models/redeemed_offers_response_model.dart';
import 'package:vendora/features/savings/data/services/savings_service.dart';

class SavingsController extends GetxController {
  late Rx<SavingsModel> savingsData;
  var selectedOfferIndex = (-1).obs;
  final isLoading = false.obs;

  final SavingsService _savingsService = SavingsService();

  @override
  void onInit() {
    super.onInit();

    // Initialize savings data first
    savingsData = SavingsModel(
      totalSavings: 0,
      redeemedOffersCount: 0,
      monthlySavings: 0,
      redeemedOffers: [],
    ).obs;

    _fetchSavingsData();

    // Listen for language changes and re-fetch savings data
    final locale = Get.find<LocalizationController>();
    ever(locale.currentLanguage, (_) {
      _fetchSavingsData();
    });
  }

  Future<void> _fetchSavingsData() async {
    isLoading.value = true;
    try {
      final response = await _savingsService.getMyRedeemedOffers();

      if (response.isSuccess && response.responseData != null) {
        final apiData = response.responseData as RedeemedOffersResponseModel;

        // Convert API model to UI model
        final offers = apiData.data.redeemedOffers
            .map((item) => SavingsOfferModel(
                  title: item.title,
                  merchant: item.vendorName ?? 'Unknown Vendor',
                  savingsBadge: '+\$${item.savedAmount.toStringAsFixed(0)}',
                  redeemedDate: item.lastRedeemedAt,
                  location: item.vendorAddress,
                  imagePath: item.image,
                ))
            .toList();

        savingsData.value = SavingsModel(
          totalSavings: apiData.data.totalSaving,
          redeemedOffersCount: offers.length,
          monthlySavings: apiData.data.totalSaving,
          redeemedOffers: offers,
        );
      } else {
        AppLoggerHelper.error('Savings Load Error', response.errorMessage);
        Get.snackbar('Error', response.errorMessage);
      }
    } catch (e) {
      AppLoggerHelper.error('Savings Load Error', e);
      Get.snackbar('Error', 'Failed to load savings data');
    } finally {
      isLoading.value = false;
    }
  }

  void onSavingsSummaryTap() {}

  void onMonthlySavingsTap() {}

  void onOfferTap(int index) {
    // Toggle selection: tap same card → deselect
    selectedOfferIndex.value = selectedOfferIndex.value == index ? -1 : index;
  }
}
