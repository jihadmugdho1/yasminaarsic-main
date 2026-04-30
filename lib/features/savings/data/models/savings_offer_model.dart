// lib/features/savings/data/models/savings_offer_model.dart
class SavingsOfferModel {
  final String title;
  final String merchant;       // e.g., 'PowerFit Gym'
  final String savingsBadge;   // e.g., '+$50'
  final DateTime redeemedDate;
  final String location;
  final String imagePath;

  SavingsOfferModel({
    required this.title,
    required this.merchant,
    required this.savingsBadge,
    required this.redeemedDate,
    required this.location,
    required this.imagePath,
  });
}