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
  final double totalSavings;
  final String totalSavingsFormatted;
  final double currentMonthSaving;
  final double currentMonthSavings;
  final double thisMonthSaving;
  final double thisMonthSavings;
  final String thisMonthSavingsFormatted;
  final int totalRedeemedCount;
  final int totalOffersRedeemed;
  final int currentMonthRedeemedCount;
  final int thisMonthRedeemedCount;
  final List<RedeemedOfferItem> redeemedOffers;

  RedeemedOffersData({
    required this.totalSaving,
    required this.totalSavings,
    this.totalSavingsFormatted = '',
    required this.currentMonthSaving,
    required this.currentMonthSavings,
    required this.thisMonthSaving,
    required this.thisMonthSavings,
    this.thisMonthSavingsFormatted = '',
    required this.totalRedeemedCount,
    required this.totalOffersRedeemed,
    required this.currentMonthRedeemedCount,
    required this.thisMonthRedeemedCount,
    required this.redeemedOffers,
  });

  factory RedeemedOffersData.fromJson(Map<String, dynamic> json) {
    final rawList = json['redeemedOffers'] ??
        json['allRedeemed'] ??
        json['currentMonthRedeemedOffers'] ??
        json['thisMonthOffers'];

    final offersList = (rawList as List?)
            ?.map((e) => RedeemedOfferItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final totalSav = (json['totalSaving'] as num?)?.toDouble() ??
        (json['totalSavings'] as num?)?.toDouble() ??
        0.0;
    final curMonthSav = (json['currentMonthSaving'] as num?)?.toDouble() ??
        (json['currentMonthSavings'] as num?)?.toDouble() ??
        (json['thisMonthSaving'] as num?)?.toDouble() ??
        (json['thisMonthSavings'] as num?)?.toDouble() ??
        0.0;

    return RedeemedOffersData(
      totalSaving: totalSav,
      totalSavings: (json['totalSavings'] as num?)?.toDouble() ?? totalSav,
      totalSavingsFormatted: json['totalSavingsFormatted']?.toString() ?? '',
      currentMonthSaving: curMonthSav,
      currentMonthSavings: (json['currentMonthSavings'] as num?)?.toDouble() ?? curMonthSav,
      thisMonthSaving: (json['thisMonthSaving'] as num?)?.toDouble() ?? curMonthSav,
      thisMonthSavings: (json['thisMonthSavings'] as num?)?.toDouble() ?? curMonthSav,
      thisMonthSavingsFormatted: json['thisMonthSavingsFormatted']?.toString() ?? '',
      totalRedeemedCount: (json['totalRedeemedCount'] as num?)?.toInt() ??
          (json['totalOffersRedeemed'] as num?)?.toInt() ??
          offersList.length,
      totalOffersRedeemed: (json['totalOffersRedeemed'] as num?)?.toInt() ??
          (json['totalRedeemedCount'] as num?)?.toInt() ??
          offersList.length,
      currentMonthRedeemedCount: (json['currentMonthRedeemedCount'] as num?)?.toInt() ??
          (json['thisMonthRedeemedCount'] as num?)?.toInt() ??
          offersList.length,
      thisMonthRedeemedCount: (json['thisMonthRedeemedCount'] as num?)?.toInt() ??
          (json['currentMonthRedeemedCount'] as num?)?.toInt() ??
          offersList.length,
      redeemedOffers: offersList,
    );
  }
}

class RedeemedOfferItem {
  final String id;
  final String eventId;
  final String offerId;
  final String vendorId;
  final String title;
  final String? vendorName;
  final String image;
  final String? thumbnail;
  final List<String> images;
  final double savedAmount;
  final double estimatedValue;
  final DateTime? redeemedAt;
  final DateTime lastRedeemedAt;
  final String vendorAddress;

  RedeemedOfferItem({
    required this.id,
    required this.eventId,
    required this.offerId,
    required this.vendorId,
    required this.title,
    this.vendorName,
    required this.image,
    this.thumbnail,
    required this.images,
    required this.savedAmount,
    required this.estimatedValue,
    this.redeemedAt,
    required this.lastRedeemedAt,
    required this.vendorAddress,
  });

  factory RedeemedOfferItem.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    List<String> parsedImages = [];
    if (rawImages is List) {
      parsedImages = rawImages
          .map((e) => e?.toString() ?? '')
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }

    final rawImage = json['image']?.toString() ?? '';
    final rawThumbnail = json['thumbnail']?.toString();

    if (parsedImages.isEmpty && rawImage.isNotEmpty) {
      parsedImages = [rawImage];
    }

    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return RedeemedOfferItem(
      id: json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      offerId: json['offerId']?.toString() ?? json['id']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      vendorName: json['vendorName']?.toString(),
      image: rawImage.isNotEmpty ? rawImage : (parsedImages.isNotEmpty ? parsedImages.first : ''),
      thumbnail: rawThumbnail,
      images: parsedImages,
      savedAmount: (json['savedAmount'] as num?)?.toDouble() ?? 0.0,
      estimatedValue: (json['estimatedValue'] as num?)?.toDouble() ??
          (json['savedAmount'] as num?)?.toDouble() ??
          0.0,
      redeemedAt: json['redeemedAt'] != null ? parseDate(json['redeemedAt']) : null,
      lastRedeemedAt: parseDate(json['lastRedeemedAt'] ?? json['redeemedAt']),
      vendorAddress: json['vendorAddress']?.toString() ?? '',
    );
  }
}
