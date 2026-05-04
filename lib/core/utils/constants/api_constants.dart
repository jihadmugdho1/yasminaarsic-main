class ApiConstants {
  static const String baseUrl =
      "https://api.vendora.rs/api/v1/";

  static String get register => "${baseUrl}auth/register";
  static String get verifyEmail => "${baseUrl}auth/verify-email";
  static String get login => "${baseUrl}auth/login";
  static String get passwordResetSendCode =>
      "${baseUrl}auth/password-reset/send-code";
  static String get passwordResetVerifyCode =>
      "${baseUrl}auth/password-reset/verify-code";
  static String get confirmPasswordReset =>
      "${baseUrl}auth/password-reset/confirm";
  static String get changePassword => "${baseUrl}auth/change-password";
  static String get get => "${baseUrl}category";

  // FCM Token
  static String get registerFcmToken => "${baseUrl}users/fcm-token";

  // Offers
  static String getOffers({
    String? categoryId,
    required int limit,
    int page = 1,
  }) {
    final params = ['page=$page', 'limit=$limit'];
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      params.add('categoryId=$categoryId');
    }
    return "${baseUrl}offer?${params.join('&')}";
  }

  static String getNewestOffers({
    required String categoryId,
    required int limit,
    int page = 1,
  }) {
    return "${baseUrl}offer/newest?categoryId=$categoryId&limit=$limit&page=$page";
  }

  static String getTrendingOffers({
    required String categoryId,
    required int limit,
    int page = 1,
  }) {
    return "${baseUrl}offer/trending?categoryId=$categoryId&limit=$limit&page=$page";
  }

  // Vendor
  static String getVendorById(String userId) {
    return "${baseUrl}vendors/$userId";
  }

  static String searchVendors(String query) {
    return "${baseUrl}vendors?search=$query";
  }

  // Subscription
  static String get subscriptionPlans => "${baseUrl}subscription-plan";
  static String get currentSubscription => "${baseUrl}subscription/current";
  static String getSubscriptionHistory({int page = 1, int limit = 10}) =>
      "${baseUrl}subscription/history?page=$page&limit=$limit";
  static String get subscriptionCheckout => "${baseUrl}subscription/subscribe/checkout";
  
  static String getCheckoutPaymentForm(String paymentId) {
    return "${baseUrl}subscription/checkout/$paymentId/form";
  }

  // Notifications
  static String getNotifications({
    String? type,
    String? status,
    int page = 1,
    int limit = 20,
  }) {
    final queryParams = <String>[];
    if (type != null && type.isNotEmpty) queryParams.add('type=$type');
    if (status != null && status.isNotEmpty) queryParams.add('status=$status');
    queryParams.add('page=$page');
    queryParams.add('limit=$limit');

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.join('&')}'
        : '';
    return "${baseUrl}api/v1/notifications$queryString";
  }

  static String markNotificationAsRead(String notificationId) {
    return "${baseUrl}api/v1/notifications/$notificationId/read";
  }

  static String deleteNotification(String notificationId) {
    return "${baseUrl}api/v1/notifications/$notificationId";
  }

  static String get markAllNotificationsAsRead =>
      "${baseUrl}api/v1/notifications/mark-all-read";

  static String get getUnreadNotificationCount =>
      "${baseUrl}api/v1/notifications/unread-count";

  static String get getProfile => "${baseUrl}users/me";
  static String get updateProfile =>
      "${baseUrl}users"; // Used with ID in service
  static String get uploadImage => "${baseUrl}users/upload-image";
  static String get notificationPreference =>
      "${baseUrl}users/notification-preferences";
  // static String get notificationPreference => "${baseUrl}users/notification-preferences";
  static String get myRedeemedOffers => "${baseUrl}offer/my-redeemed-offers";
  static String get generateOfferQRCode => "${baseUrl}offer/qr-code";

  // Hero Slider
  static String get heroSlider => "${baseUrl}app-hero-slider/active";
}
