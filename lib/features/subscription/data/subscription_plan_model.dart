

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
    final rawPrice = json['price'];
    final String price = rawPrice is num
        ? rawPrice.toStringAsFixed(2)
        : (rawPrice?.toString() ?? '0.00');

    return SubscriptionPlanModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: price,
      durationInDays: (json['durationInDays'] is num)
          ? (json['durationInDays'] as num).toInt()
          : int.tryParse(json['durationInDays']?.toString() ?? '') ?? 365,
      currency: json['currency']?.toString() ?? 'USD',
      currentPriceDisplay: json['currentPriceDisplay']?.toString() ?? '',
      isActive: json['isActive'] is bool ? json['isActive'] as bool : true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
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
