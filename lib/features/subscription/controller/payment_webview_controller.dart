import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yasminaarsic/core/core.dart';

class PaymentWebViewController extends GetxController {
  PaymentWebViewController({
    required this.paymentId,
    this.authToken,
  });

  final String paymentId;
  final String? authToken;

  late final WebViewController webViewController;

  final RxBool showBlockingLoader = true.obs;
  final RxDouble progress = 0.0.obs;

  bool _initialPageLoaded = false;

  @override
  void onInit() {
    super.onInit();

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
          },
          onWebResourceError: (WebResourceError error) {
            AppLoggerHelper.error(
              'WebView error: ${error.description}',
              error,
            );
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
