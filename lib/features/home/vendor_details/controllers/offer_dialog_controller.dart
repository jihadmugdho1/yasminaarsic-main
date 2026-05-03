import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/alert_dialogs/offer_dialog_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/widgets/alert_dialogs/qr_dialog.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/alert_dialogs/qr_dialog_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/offer_model.dart';
import 'package:yasminaarsic/features/home/vendor_details/controllers/vendor_details_controller.dart';
import 'package:yasminaarsic/features/home/vendor_details/services/offer_service.dart';

class OfferController extends GetxController {
  final bool isReuseable;
  final Offer? offerData;
  final int offerIndex; // ✅ Track offer index
  final Map<String, dynamic>? offerDetail;

  OfferController({
    this.isReuseable = false,
    this.offerData,
    this.offerIndex = 0, // ✅ Add index parameter
    this.offerDetail,
  });

  late var offer = OfferDialogModel(
    title: offerDetail?['title'] ?? offerData?.title ?? 'Buy 1 Get 1 Free',
    description:
        offerDetail?['description'] ??
        offerData?.description ??
        'Enjoy our signature dishes with BOGO offer on all main courses',
    location:
        offerDetail?['VendorProfile']?['city'] ??
        offerData?.location ??
        'Downtown, City Center',
    expiryDate: offerDetail?['validUntil'] != null
        ? DateTime.tryParse(offerDetail!['validUntil']) ??
              DateTime(2025, 12, 31)
        : offerData?.expiryDate ?? DateTime(2025, 12, 31),
    estimatedValue: offerDetail?['estimatedValue']?.toDouble() ?? 25.0,
    terms:
        offerDetail?['termsAndConditions'] ??
        'Valid on dine-in only. Not valid with other offers. Valid Mon-Thu only.',
    imageUrl: offerDetail?['imageUrl'] ?? offerData?.imageUrl ?? '',
    isRedeemed: offerData?.isRedeemed ?? false,
    isReuseable: isReuseable,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    // Update the offer's isReuseable flag with the passed parameter
    offer.update((val) {
      val?.isReuseable = isReuseable;
    });
  }

  void redeemOffer(BuildContext context) async {
    // Get offer ID
    final offerId = offerDetail != null
        ? offerDetail!['id']
        : offerData?.id ?? 'OFFER_${DateTime.now().millisecondsSinceEpoch}';

    print('🔄 Generating QR code for offer: $offerId');

    try {
      // Call the service to generate QR code and get token
      final offerService = OfferService();
      final response = await offerService.generateOfferQRCode(offerId);

      if (response.isSuccess && response.responseData != null) {
        // Extract token from response data
        final qrData = response.responseData as Map<String, dynamic>;
        final qrToken = qrData['token'] as String? ?? '';

        print('✅ QR Code Token extracted: $qrToken');

        // Create QrOffer with the token from API
        final qrOffer = QrOffer(
          qrCode: qrToken, // Use the token from API
          title: offerDetail?['title'] ?? offer.value.title,
          description: offerDetail?['description'],
          vendor:
              offerDetail?['VendorProfile']?['businessName'] ?? offer.value.title,
          location: offerDetail?['VendorProfile']?['city'] ?? offer.value.location,
          validUntil: offerDetail?['validUntil'] != null
              ? DateTime.tryParse(
                      offerDetail!['validUntil'],
                    )?.toString().split(' ')[0] ??
                  offer.value.expiryDate.toString().split(' ')[0]
              : offer.value.expiryDate.toString().split(' ')[0],
          isRedeemed: false,
          isReuseable: offerDetail?['isReusable'] ?? offer.value.isReuseable,
        );

        // Log the final QrOffer object
        print('✅ Final QrOffer Object:');
        print('  - QR Code (Token): ${qrOffer.qrCode}');
        print('  - Title: ${qrOffer.title}');
        print('  - Description: ${qrOffer.description}');
        print('  - Vendor: ${qrOffer.vendor}');
        print('  - Location: ${qrOffer.location}');
        print('  - Valid Until: ${qrOffer.validUntil}');
        print('  - Is Reusable: ${qrOffer.isReuseable}');
        print('  - Is Redeemed: ${qrOffer.isRedeemed}');

        // Show QR code dialog - pass QrOffer directly
        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierLabel: 'QrDialog',
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: QrRedemptionAlertDialog(
                  qrOffer: qrOffer,
                  onClose: () {
                    // Only mark as redeemed for one-time offers
                    if (!isReuseable) {
                      // Update local offer state
                      offer.update((val) {
                        val?.isRedeemed = true;
                      });

                      // ✅ Use the dedicated method to update only this specific offer
                      try {
                        final vendorController =
                            Get.find<VendorDetailsController>();
                        vendorController.markOfferAsRedeemed(offerIndex);
                      } catch (e) {
                        print('Error updating offer: $e');
                      }
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
        // Handle error case
        print('❌ Failed to generate QR code: ${response.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate QR code: ${response.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error generating QR code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating QR code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
