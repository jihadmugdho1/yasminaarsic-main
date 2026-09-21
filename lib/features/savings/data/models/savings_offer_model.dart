// lib/features/savings/data/models/savings_offer_model.dart

class SavingsOfferModel {
  final String id;
  final String offerId;
  final String vendorId;
  final String title;
  final String merchant; // e.g., 'PowerFit Gym'
  final String savingsBadge; // e.g., '+$50' or '+268 RSD'
  final double savedAmount;
  final double estimatedValue;
  final DateTime redeemedDate;
  final String location;
  final String imagePath;
  final String? thumbnail;
  final List<String> images;

  SavingsOfferModel({
    this.id = '',
    this.offerId = '',
    this.vendorId = '',
    required this.title,
    required this.merchant,
    required this.savingsBadge,
    this.savedAmount = 0.0,
    this.estimatedValue = 0.0,
    required this.redeemedDate,
    required this.location,
    required this.imagePath,
    this.thumbnail,
    this.images = const [],
  });

  /// Returns a clean, non-empty list of all available images
  List<String> get allImages {
    final list = <String>[];
    for (final img in images) {
      if (img.trim().isNotEmpty && !list.contains(img.trim())) {
        list.add(img.trim());
      }
    }
    if (imagePath.trim().isNotEmpty && !list.contains(imagePath.trim())) {
      list.insert(0, imagePath.trim());
    }
    if (thumbnail != null &&
        thumbnail!.trim().isNotEmpty &&
        !list.contains(thumbnail!.trim())) {
      list.add(thumbnail!.trim());
    }
    return list;
  }
}