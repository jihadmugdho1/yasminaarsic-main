import 'package:get/get.dart';
import 'package:yasminaarsic/features/home/vendor_details/models/alert_dialogs/qr_dialog_model.dart';

class QrRedemptionController extends GetxController {
  // MVC Pattern: Store QR offers as RxList like vendor_details_controller
  final RxList<QrOffer> qrOffers = <QrOffer>[].obs;

  // Currently selected offer for display in dialog
  final Rx<QrOffer?> currentOffer = Rx<QrOffer?>(null);

  @override
  void onInit() {
    super.onInit();
    // // Initialize with sample QR offers (can be replaced with API data)
    // qrOffers.addAll([
    //   QrOffer(
    //     qrCode: 'QR_BOGO_001',
    //     title: 'Buy 1 Get 1 Free - Main Course',
    //     vendor: 'Bella Vista Restaurant',
    //     location: 'Downtown, City Center',
    //     validUntil: '2025-12-31',
    //     isRedeemed: false,
    //   ),
    //   QrOffer(
    //     qrCode: 'QR_DISC_002',
    //     title: '30% Off on Appetizers',
    //     vendor: 'Bella Vista Restaurant',
    //     location: 'Downtown, City Center',
    //     validUntil: '2025-12-15',
    //     isRedeemed: false,
    //   ),
    //   QrOffer(
    //     qrCode: 'QR_FREE_003',
    //     title: 'Free Dessert with Dinner',
    //     vendor: 'Bella Vista Restaurant',
    //     location: 'Downtown, City Center',
    //     validUntil: '2025-12-25',
    //     isRedeemed: false,
    //   ),
    // ]);
  }

  // Set current offer for display in dialog
  void setCurrentOffer(QrOffer offer) {
    currentOffer.value = offer;
  }

  // Get current offer for dialog display
  QrOffer get offer =>
      currentOffer.value ??
      QrOffer(
        qrCode: '',
        title: '',
        vendor: '',
        location: '',
        validUntil: '',
        isRedeemed: false,
      );

  // Mark offer as redeemed by index
  void markRedeemedByIndex(int index) {
    if (index >= 0 && index < qrOffers.length) {
      qrOffers[index] = qrOffers[index].copyWith(isRedeemed: true);
      if (currentOffer.value?.qrCode == qrOffers[index].qrCode) {
        currentOffer.value = qrOffers[index];
      }
    }
  }

  // Mark current offer as redeemed
  void markRedeemed() {
    if (currentOffer.value != null) {
      currentOffer.value = currentOffer.value!.copyWith(isRedeemed: true);
      // Update in list as well
      final index = qrOffers.indexWhere(
        (q) => q.qrCode == currentOffer.value!.qrCode,
      );
      if (index != -1) {
        qrOffers[index] = currentOffer.value!;
      }
    }
  }
}
