import 'package:get/get.dart';
import 'package:yasminaarsic/features/home/models/pop_up_offer_model.dart';

class PopupOfferController extends GetxController {
  var isVisible = false.obs;
  late PopupOfferModel offerModel;

  void showPopup(PopupOfferModel model) {
    offerModel = model;
    isVisible.value = true;
  }

  void hidePopup() {
    isVisible.value = false;
  }
}
