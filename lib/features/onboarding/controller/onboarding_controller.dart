import 'package:get/get.dart';
import 'package:yasminaarsic/routes/app_routes.dart';
import 'package:yasminaarsic/core/utils/constants/icon_path.dart';

class OnboardingController extends GetxController {
    final List<String> icons = [
      IconPath.giftIcon,
      IconPath.qrCodeIcon,
      IconPath.piggiIcon,
      IconPath.notificationIcon,
    ];
  RxInt currentIndex = 0.obs;

  final List<String> titles = [
    'Discover Amazing Offers',
    'Easy Redemption',
    'Track Your Savings',
    'Stay Updated',
  ];

  final List<String> descriptions = [
    'Browse hundreds of BOGO deals from top vendors in your area',
    'Generate a QR code and show it at the vendor to redeem your offer',
    'See how much you save with every offer you redeem',
    'Get notified about new offers and exclusive promotions',
  ];

  int get pageCount => titles.length;

  bool get isLastSlide => currentIndex.value == pageCount - 1;

  void next() {
    if (!isLastSlide) {
      currentIndex.value++;
    }
  }

  void skip() {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  void getStarted() {
    Get.offAllNamed(AppRoute.loginScreen);
  }
}
