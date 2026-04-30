class RedeemedOffersResponseModel {
  final bool success;
  final String message;
  final RedeemedOffersData data;

  RedeemedOffersResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RedeemedOffersResponseModel.fromJson(Map<String, dynamic> json) {
    return RedeemedOffersResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RedeemedOffersData.fromJson(json['data'] ?? {}),
    );
  }
}

class RedeemedOffersData {
  final double totalSaving;
  final List<RedeemedOfferItem> redeemedOffers;

  RedeemedOffersData({
    required this.totalSaving,
    required this.redeemedOffers,
  });

  factory RedeemedOffersData.fromJson(Map<String, dynamic> json) {
    return RedeemedOffersData(
      totalSaving: (json['totalSaving'] as num?)?.toDouble() ?? 0.0,
      redeemedOffers: (json['redeemedOffers'] as List?)
              ?.map((e) => RedeemedOfferItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class RedeemedOfferItem {
  final String offerId;
  final String title;
  final String? vendorName;
  final String image;
  final double savedAmount;
  final DateTime lastRedeemedAt;
  final String vendorAddress;

  RedeemedOfferItem({
    required this.offerId,
    required this.title,
    this.vendorName,
    required this.image,
    required this.savedAmount,
    required this.lastRedeemedAt,
    required this.vendorAddress,
  });

  factory RedeemedOfferItem.fromJson(Map<String, dynamic> json) {
    return RedeemedOfferItem(
      offerId: json['offerId'] ?? '',
      title: json['title'] ?? '',
      vendorName: json['vendorName'],
      image: json['image'] ?? '',
      savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0.0,
      lastRedeemedAt: json['lastRedeemedAt'] != null
          ? DateTime.parse(json['lastRedeemedAt'] as String)
          : DateTime.now(),
      vendorAddress: json['vendorAddress'] ?? '',
    );
  }
}
