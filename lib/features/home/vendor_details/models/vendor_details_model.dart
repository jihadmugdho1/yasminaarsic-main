class VendorDetailsModel {
  final String name;
  final String category;
  final String description;
  final String location;
  final String phone;
  final String email;
  final String website;
  final Map<String, String> hours;
  final String imageUrl;

  VendorDetailsModel({
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.phone,
    required this.email,
    required this.website,
    required this.hours,
    required this.imageUrl,
  });
}
