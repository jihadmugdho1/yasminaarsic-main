

class SubscriptionPlanModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final int durationInDays;
  final String currency;
  final String currentPriceDisplay;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInDays,
    required this.currency,
    required this.currentPriceDisplay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0.00',
      durationInDays: json['durationInDays'] ?? 365,
      currency: json['currency'] ?? 'USD',
      currentPriceDisplay: json['currentPriceDisplay'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationInDays': durationInDays,
      'currency': currency,
      'currentPriceDisplay': currentPriceDisplay,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
