// lib/features/savings/data/models/savings_model.dart
import 'savings_offer_model.dart';

class SavingsModel {
  final double totalSavings;
  final int redeemedOffersCount;
  final double monthlySavings;
  final List<SavingsOfferModel> redeemedOffers;

  SavingsModel({
    required this.totalSavings,
    required this.redeemedOffersCount,
    required this.monthlySavings,
    required this.redeemedOffers,
  });
}