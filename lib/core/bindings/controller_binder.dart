import 'package:get/get.dart';
import 'package:vendora/core/localization/localization_controller.dart';
import 'package:vendora/features/authentication/controllers/login_controller.dart';
import 'package:vendora/features/authentication/data/services/authentication_service.dart';
import 'package:vendora/features/profile/controller/profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Register LocalizationController as permanent so it's available app-wide
    Get.put<LocalizationController>(LocalizationController(), permanent: true);

    // Register AuthenticationService as permanent so it's available app-wide
    Get.put<AuthenticationService>(AuthenticationService(), permanent: true);

    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
  }
}
