class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['icon'];
    String resolvedIcon = 'assets/icons/offer_icon.png';

    if (rawIcon != null && rawIcon is String && rawIcon.trim().isNotEmpty) {
      resolvedIcon = rawIcon;
    }

    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: resolvedIcon,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
