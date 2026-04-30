class CheckoutResponse {
  final bool success;
  final String message;
  final CheckoutData data;

  CheckoutResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CheckoutData.fromJson(json['data'] ?? {}),
    );
  }
}

class CheckoutData {
  final String subscriptionId;
  final String paymentId;
  final CheckoutDetails checkout;

  CheckoutData({
    required this.subscriptionId,
    required this.paymentId,
    required this.checkout,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      subscriptionId: json['subscriptionId'] ?? '',
      paymentId: json['paymentId'] ?? '',
      checkout: CheckoutDetails.fromJson(json['checkout'] ?? {}),
    );
  }
}

class CheckoutDetails {
  final String actionUrl;
  final Map<String, dynamic> fields;

  CheckoutDetails({
    required this.actionUrl,
    required this.fields,
  });

  factory CheckoutDetails.fromJson(Map<String, dynamic> json) {
    return CheckoutDetails(
      actionUrl: json['actionUrl'] ?? '',
      fields: json['fields'] ?? {},
    );
  }
}
