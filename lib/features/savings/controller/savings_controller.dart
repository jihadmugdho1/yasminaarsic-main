// lib/features/savings/controller/savings_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/savings/data/models/savings_model.dart';
import 'package:vendora/features/savings/data/models/savings_offer_model.dart';
import 'package:vendora/features/savings/data/models/redeemed_offers_response_model.dart';
import 'package:vendora/features/savings/data/services/savings_service.dart';
import 'package:vendora/features/savings/presentation/widgets/redeemed_offer_detail_dialog.dart';

class SavingsController extends GetxController {
  late Rx<SavingsModel> savingsData;
  var selectedOfferIndex = (-1).obs;
  final isLoading = false.obs;
  final isError = false.obs;
  final errorMessage = ''.obs;

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

    fetchSavingsData();

    // Listen for language changes and re-fetch savings data
    final locale = Get.find<LocalizationController>();
    ever(locale.currentLanguage, (_) {
      fetchSavingsData();
    });
  }

  Future<void> refreshSavingsData() async {
    await fetchSavingsData(showLoading: false);
  }

  Future<void> fetchSavingsData({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    isError.value = false;
    errorMessage.value = '';
    try {
      final response = await _savingsService.getMyRedeemedOffers();

      if (response.isSuccess && response.responseData != null) {
        final apiData = response.responseData as RedeemedOffersResponseModel;

        // Convert API model to UI model
        final offers = apiData.data.redeemedOffers.map((item) {
          final badgeText = item.savedAmount > 0
              ? '+${item.savedAmount.toStringAsFixed(0)} RSD'
              : '';

          String primaryImage = item.image.trim();
          if (primaryImage.isEmpty && item.images.isNotEmpty) {
            primaryImage = item.images.first.trim();
          }
          if (primaryImage.isEmpty && item.thumbnail != null) {
            primaryImage = item.thumbnail!.trim();
          }

          return SavingsOfferModel(
            id: item.id,
            offerId: item.offerId,
            vendorId: item.vendorId,
            title: item.title,
            merchant:
                (item.vendorName != null && item.vendorName!.trim().isNotEmpty)
                    ? item.vendorName!.trim()
                    : 'Unknown Vendor',
            savingsBadge: badgeText,
            savedAmount: item.savedAmount,
            estimatedValue: item.estimatedValue,
            redeemedDate: item.lastRedeemedAt,
            location: item.vendorAddress,
            imagePath: primaryImage,
            thumbnail: item.thumbnail,
            images: item.images,
          );
        }).toList();

        final totalSav = apiData.data.totalSavings > 0
            ? apiData.data.totalSavings
            : apiData.data.totalSaving;
        final count = apiData.data.totalRedeemedCount > 0
            ? apiData.data.totalRedeemedCount
            : (apiData.data.totalOffersRedeemed > 0
                ? apiData.data.totalOffersRedeemed
                : offers.length);
        final monthSav = apiData.data.thisMonthSavings > 0
            ? apiData.data.thisMonthSavings
            : (apiData.data.currentMonthSaving > 0
                ? apiData.data.currentMonthSaving
                : apiData.data.totalSaving);

        savingsData.value = SavingsModel(
          totalSavings: totalSav,
          redeemedOffersCount: count,
          monthlySavings: monthSav,
          redeemedOffers: offers,
        );
        isError.value = false;
      } else {
        isError.value = true;
        errorMessage.value = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Failed to load savings data';
        AppLoggerHelper.error('Savings Load Error', response.errorMessage);
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Failed to load savings data';
      AppLoggerHelper.error('Savings Load Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  void onSavingsSummaryTap() {}

  void onMonthlySavingsTap() {}

  void onOfferTap(int index, BuildContext context) {
    selectedOfferIndex.value = index;
    final offers = savingsData.value.redeemedOffers;
    if (index >= 0 && index < offers.length) {
      RedeemedOfferDetailDialog.show(context, offers[index]);
    }
  }

  void showOfferDetails(SavingsOfferModel offer, BuildContext context) {
    RedeemedOfferDetailDialog.show(context, offer);
  }
}
