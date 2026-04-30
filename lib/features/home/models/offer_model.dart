class OfferModel {
  final String imagePath;
  final String title;
  final String location;
  final String categoryLabel;
  final bool isNetworkImage;
  final dynamic offerApiData; // Store the full API response data

  OfferModel({
    required this.imagePath,
    required this.title,
    required this.location,
    required this.categoryLabel,
    this.isNetworkImage = false,
    this.offerApiData,
  });
}
