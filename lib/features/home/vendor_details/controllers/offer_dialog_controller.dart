import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendora/core/utils/logging/logger.dart';
import 'package:vendora/features/home/vendor_details/models/alert_dialogs/offer_dialog_model.dart';
import 'package:vendora/features/home/vendor_details/widgets/alert_dialogs/qr_dialog.dart';
import 'package:vendora/features/home/vendor_details/models/alert_dialogs/qr_dialog_model.dart';
import 'package:vendora/features/home/vendor_details/models/offer_model.dart';
import 'package:vendora/features/home/vendor_details/services/offer_service.dart';

class OfferController extends GetxController {
  final bool isReuseable;
  final Offer? offerData;
  final int offerIndex;
  final Map<String, dynamic>? offerDetail;

  OfferController({
    this.isReuseable = false,
    this.offerData,
    this.offerIndex = 0,
    this.offerDetail,
  });

  late Rx<OfferDialogModel> offer;

  @override
  void onInit() {
    super.onInit();

    final detail = offerDetail;
    final profile = (detail?['VendorProfile'] ?? detail?['vendorProfile'])
        as Map<String, dynamic>?;

    final String title = detail?['title'] as String? ?? offerData?.title ?? '';
    final String description =
        detail?['description'] as String? ?? offerData?.description ?? '';
    final String location = profile?['city'] as String? ??
        profile?['streetAddress'] as String? ??
        offerData?.location ??
        '';

    final String? rawExpiry = detail?['validUntil'] as String?;
    final DateTime expiryDate = rawExpiry != null
        ? DateTime.tryParse(rawExpiry) ?? offerData?.expiryDate ?? DateTime.now()
        : offerData?.expiryDate ?? DateTime.now();

    final dynamic rawEstimated = detail?['estimatedValue'];
    final double estimatedValue = (rawEstimated is num)
        ? rawEstimated.toDouble()
        : (double.tryParse(rawEstimated?.toString() ?? '') ?? 0.0);

    final String terms = detail?['termsAndConditions'] as String? ?? '';
    final String imageUrl = detail?['thumbnail'] as String? ??
        detail?['imageUrl'] as String? ??
        offerData?.imageUrl ??
        '';

    final bool effectiveReusable =
        detail?['isReusable'] as bool? ?? isReuseable;

    offer = OfferDialogModel(
      title: title,
      description: description,
      location: location,
      expiryDate: expiryDate,
      estimatedValue: estimatedValue,
      terms: terms,
      imageUrl: imageUrl,
      isReuseable: effectiveReusable,
    ).obs;
  }

  void redeemOffer(BuildContext context) async {
    final offerId = offerDetail?['id'] as String? ?? offerData?.id;

    if (offerId == null || offerId.isEmpty) {
      AppLoggerHelper.error('Invalid offer ID for QR code generation');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid offer ID for QR code generation'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AppLoggerHelper.debug('Generating QR code for offer ID: $offerId');

    try {
      final offerService = OfferService();
      final response = await offerService.generateOfferQRCode(offerId);

      if (response.isSuccess && response.responseData != null) {
        final qrData = response.responseData as Map<String, dynamic>;
        final qrToken = qrData['token'] as String? ?? '';

        AppLoggerHelper.debug('QR Code Token extracted: $qrToken');

        final profile = (offerDetail?['VendorProfile'] ??
            offerDetail?['vendorProfile']) as Map<String, dynamic>?;
        final vendorName = profile?['businessName'] as String? ??
            profile?['user']?['name'] as String? ??
            offerData?.restaurantName ??
            offer.value.title;
        final locationName = profile?['city'] as String? ??
            profile?['streetAddress'] as String? ??
            offer.value.location;

        final qrOffer = QrOffer(
          qrCode: qrToken,
          title: offerDetail?['title'] as String? ?? offer.value.title,
          description: offerDetail?['description'] as String? ??
              offer.value.description,
          vendor: vendorName,
          location: locationName,
          validUntil: offerDetail?['validUntil'] != null
              ? DateTime.tryParse(
                      offerDetail!['validUntil'] as String,
                    )?.toString().split(' ')[0] ??
                  offer.value.expiryDate.toString().split(' ')[0]
              : offer.value.expiryDate.toString().split(' ')[0],
          isRedeemed: false,
          isReuseable:
              offerDetail?['isReusable'] as bool? ?? offer.value.isReuseable,
        );

        if (!context.mounted) return;
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'QrDialog',
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: QrRedemptionAlertDialog(
                  qrOffer: qrOffer,
                  onClose: () {
                    if (!offer.value.isReuseable) {
                      offer.update((val) {
                        val?.isRedeemed = true;
                      });
                    }
                    Get.back();
                  },
                ),
              ),
            );
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 0.96, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
        );
      } else {
        AppLoggerHelper.error(
          'Failed to generate QR code: ${response.errorMessage}',
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to generate QR code: ${response.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error generating QR code', e);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating QR code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
