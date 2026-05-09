class Offer {
  final String? id;
  final String title;
  final String restaurantName;
  final String description;
  final String location;
  final String imageUrl;
  final String category;
  final DateTime expiryDate;
  final bool isReuseable;
 

  Offer({
    this.id,
    required this.title,
    required this.restaurantName,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.category,
    required this.expiryDate,
    this.isReuseable = false,
  
  });

  // ✅ Copy constructor for creating modified copies (immutable)
  Offer copyWith({
    String? id,
    String? title,
    String? restaurantName,
    String? description,
    String? location,
    String? imageUrl,
    String? category,
    DateTime? expiryDate,
    bool? isReuseable,
    bool? isRedeemed,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      restaurantName: restaurantName ?? this.restaurantName,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      isReuseable: isReuseable ?? this.isReuseable,

    );
  }
}
