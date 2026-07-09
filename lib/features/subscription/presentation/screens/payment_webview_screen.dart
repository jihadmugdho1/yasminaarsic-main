// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendora/core/utils/constants/colors.dart';
import 'package:vendora/features/subscription/controller/payment_webview_controller.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String paymentId;
  final String? authToken;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentId,
    this.authToken,
  });

  @override
  Widget build(BuildContext context) {
    final tag = 'payment_webview_$paymentId';
    final PaymentWebViewController controller =
        Get.isRegistered<PaymentWebViewController>(tag: tag)
            ? Get.find<PaymentWebViewController>(tag: tag)
            : Get.put(
                PaymentWebViewController(
                  paymentId: paymentId,
                  authToken: authToken,
                ),
                tag: tag,
              );

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await _showCancelDialog(context) ?? false;
        if (shouldPop) {
          Get.delete<PaymentWebViewController>(tag: tag, force: true);
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            'Complete Payment',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final shouldPop = await _showCancelDialog(context) ?? false;
              if (shouldPop) {
                Get.delete<PaymentWebViewController>(tag: tag, force: true);
                Get.back();
              }
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller.webViewController),
            Obx(() {
              if (!controller.showBlockingLoader.value) {
                return const SizedBox.shrink();
              }
              // Important: show this only for the FIRST HTML load.
              // After that, the gateway page handles its own UI and redirects.
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showCancelDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment?'),
        content: const Text('Are you sure you want to cancel the payment process?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue Payment'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
