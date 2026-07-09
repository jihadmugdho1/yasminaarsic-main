import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vendora/core/core.dart';
import 'package:vendora/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:vendora/features/profile/controller/profile_controller.dart';

class PaymentWebViewController extends GetxController {
  PaymentWebViewController({required this.paymentId, this.authToken});

  final String paymentId;
  final String? authToken;

  late final WebViewController webViewController;
  late final ProfileController _profileController;

  final RxBool showBlockingLoader = true.obs;
  final RxDouble progress = 0.0.obs;

  bool _initialPageLoaded = false;
  bool _navigationHandled = false;

  bool _isPaymentSuccess(String url) {
    final lower = url.toLowerCase();
    return lower.contains('success') ||
        lower.contains('payment-complete') ||
        lower.contains('payment_complete') ||
        lower.contains('order-complete') ||
        lower.contains('order_complete');
  }

  @override
  void onInit() async {
    super.onInit();

    _profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    final headers = <String, String>{
      'accept': '*/*',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            progress.value = 0;
            if (!_initialPageLoaded) {
              showBlockingLoader.value = true;
            }
          },
          onProgress: (int p) {
            progress.value = p / 100.0;
          },
          onPageFinished: (String url) {
            if (!_initialPageLoaded) {
              _initialPageLoaded = true;
              showBlockingLoader.value = false;
            }
            progress.value = 1;
            if (!_navigationHandled && _isPaymentSuccess(url)) {
              _navigationHandled = true;

              Get.until((route) => route.isFirst);
              _profileController.fetchProfileData();
              Get.find<BottomNavController>().changeTab(1);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (!_navigationHandled && _isPaymentSuccess(request.url)) {
              _navigationHandled = true;
              Get.until((route) => route.isFirst);
              _profileController.fetchProfileData();
              Get.snackbar(
                backgroundColor: Colors.green,
                colorText: AppColors.white,

                "Payment Success ",
                "Complete Payment",
              );
              Get.find<BottomNavController>().changeTab(1);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            AppLoggerHelper.error('WebView error: ${error.description}', error);
            if (!_initialPageLoaded) {
              showBlockingLoader.value = false;
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(ApiConstants.getCheckoutPaymentForm(paymentId)),
        headers: headers,
      );
  }
}
