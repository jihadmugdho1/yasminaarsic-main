class OfferDialogModel {
  final String title;
  final String description;
  final String location;
  final DateTime expiryDate;
  final double estimatedValue;
  final String terms;
  final String imageUrl;
  bool isRedeemed;
  bool isReuseable;

  OfferDialogModel({
    required this.title,
    required this.description,
    required this.location,
    required this.expiryDate,
    required this.estimatedValue,
    required this.terms,
    this.imageUrl = '',
    this.isRedeemed = false,
    this.isReuseable = false,
  });
}
